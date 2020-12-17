module GEOTRACES

using OceanographyCruises
using NCDatasets
using Unitful
using Dates
using Match
using Measurements
using MetadataArrays
import MetadataArrays: metadata


GEOTRACES_IDP17_DiscreteSamples_path() = get(ENV, "GEOTRACES_IDP17_PATH", joinpath(homedir(), "Data/GEOTRACES/GEOTRACES_IDP2017_v2/discrete_sample_data/netcdf/GEOTRACES_IDP2017_v2_Discrete_Sample_Data.nc"))

include("helper_functions.jl")

"""
    cruisetrack(cruise_name)

Construct GEOTRACES `CruiseTrack` from cruise name.
"""
function cruisetrack(ds::Dataset, cruise)
    ikeep = findall(list_of_cruises(ds) .== cruise)
    ikeep = CartesianIndices((1, length(ds[varname("lat")])))[ikeep]
    metadatakeys=("lat","lon","cruise","station","date")
    GEOTRACESmetadatakeys = varname.(metadatakeys)
    metadata = [metadatakeyvaluepair(ds[k], ikeep) for k in GEOTRACESmetadatakeys]
    m = (; metadata...)
    any(m.cruise .≠ cruise) && error("Not the right cruise!")
    stations = [Station(date=d,lat=y,lon=x,name=string(s)) for (d,y,x,s) in zip(m.date, m.lat, m.lon, m.station)]
    return CruiseTrack(name=cruise, stations=stations)
end

"""
    list_of_cruises()

List of GEOTRACES cruises.
"""
list_of_cruises(ds::Dataset) = reduce.(string, filter.(!=('\0'), eachcol(ds["metavar1"].var[:,:])))

"""
    list_of_stations()

List of GEOTRACES stations.
"""
list_of_stations(ds::Dataset) = string.(reduce.(string, filter.(!=('\0'), eachcol(ds["metavar2"].var[:,:]))))


"""
transect(tracer::String, cruise::String)

The `Transect` of observations of tracer `tracer` along cruise `cruise`.
"""
function transect(ds::Dataset, tracer::String; cruise::String, QCmax=1)
    ts = transects(ds, tracer, QCmax=QCmax)
    i = findall(ts.cruises .== cruise)
    length(i) == 1 ? i = i[1] : error("Multiple identical cruises is an issue!")
    return ts.transects[i]
end



"""
transects(tracer::String, cruise::String)

The `Transects` of observations of tracer `tracer`.
"""
function transects(ds::Dataset, tracer::String; QCmax=1)
    obs = observations(ds, tracer; metadatakeys=("lat","lon","depth","cruise","station","date"), QCmax=QCmax)
    return transects(obs, tracer)
end
function transects(obs::MetadataArray, tracer::String)
    m = metadata(obs)
    cruises = unique(m.cruise)
    ts = Transect{eltype(parent(obs))}[]
    for cruise in cruises
        icruise = findall(m.cruise .== cruise)
        IDs = unique([x for x in zip(m.station[icruise], m.date[icruise], m.lat[icruise], m.lon[icruise])])
        IDstations = unique(m.station[icruise])
        IDdates = unique(m.date[icruise])
        IDlatlons = unique([x for x in zip(m.lat[icruise], m.lon[icruise])])
        profiles = DepthProfile{eltype(parent(obs))}[]
        for sdll in IDs # ID is sdll = (station, date, lat, lon)
            station, date, lat, lon = sdll
            ipro = findall((m.station .== station) .& (m.lat .== lat) .& (m.lon .== lon) .& (m.date .== date))
            (station isa Char) && (station = string(station)) # Because sometimes it's a Char...
            push!(profiles, DepthProfile(station = Station(name=station, lat=lat, lon=lon, date=date), depths=ustrip.(m.depth[ipro]), values=parent(obs)[ipro]))
        end
        push!(ts, Transect(tracer=m.name, cruise=cruise, profiles=profiles))
    end
    return Transects(tracer=tracer, cruises=cruises, transects=ts)
end
function transects(ds::Dataset, tracers::String...; QCmax=1)
    obss = observations(ds, tracers...; metadatakeys=("lat","lon","depth","cruise","station","date"), QCmax=QCmax)
    return ([transects(obs, tracer) for (obs, tracer) in zip(obss, tracers)]...,)
end


#function cruisetrack(ds::Dataset, cruise::String)
#    Istations = findall(list_of_cruises(ds) .== cruise)
#    stations_names = list_of_stations(ds)
#    stations = Station[]
#
#    for istation in Istations
#        station = Station(name=stations_names[istation], lat=ds["latitude"][istation], lon=ds["longitude"][istation])
#        push!(stations, station)
#    end
#
#    return CruiseTrack(name=cruise, stations=stations)
#end


"""
    observations(tracer1, tracer2, tracer3, ...)

Returns the GEOTRACES observations of the given tracers.

### Example usage

```
x, y, z, ... = observations(tracer1, tracer2, tracer3, ...)
x = observations(tracer1)
```

### Quality control flags

By default, only observations with quality control flag of `1` are kept.
If you want more data, you must define keyword-argument `QCmax`.

```
x, y, z, ... = observations(tracer1, tracer2, tracer3, ...; QCmax = 2)
x = observations(tracer1; QCmax = 3)
```
"""
function observations(ds::Dataset, tracers::String...; metadatakeys=("lat", "lon", "depth"), QCmax=1)
    vars = [ds[varname(tracer)] for tracer in tracers]
    fs = [unitfunction(var.attrib["units"]) for var in vars]
    vs = [var[:] for var in vars]
    qcvs = [ds[qcvarname(tracer)].var[:] for tracer in tracers]
    ikeep = findall(i -> all((parse.(Int, getindex.(qcvs, i))) .≤ QCmax), eachindex(qcvs[1]))
    ikeep = CartesianIndices(size(qcvs[1]))[ikeep]
    GEOTRACESmetadatakeys = varname.(metadatakeys)
    metadata = [metadatakeyvaluepair(ds[k], ikeep) for k in GEOTRACESmetadatakeys]
    ms = [(name="Observed $t", GEOTRACESvarname=name(var), metadata...) for (t,var) in zip(tracers,vars)]
    return ((MetadataVector(f.(float.(view(v, ikeep))), m) for (f,v,m) in zip(fs,vs,ms))...,)
end
function observations(ds::Dataset, tracer::String; metadatakeys=("lat", "lon", "depth"), QCmax=1)
    f = unitfunction(ds[varname(tracer)].attrib["units"])
    var = ds[varname(tracer)]
    v = var[:]
    qcv = ds[qcvarname(tracer)].var[:]
    ikeep = findall(parse.(Int, qcv) .≤ QCmax)
    ikeep = CartesianIndices(size(qcv))[ikeep]
    GEOTRACESmetadatakeys = varname.(metadatakeys)
    metadata = [metadatakeyvaluepair(ds[k], ikeep) for k in GEOTRACESmetadatakeys]
    metadata = (name="Observed $(tracer)", GEOTRACESvarname=name(var), metadata...)
    return MetadataVector(f.(float.(view(v, ikeep))), metadata)
end

"""
    qualitycontrols(tracer1, tracer2, tracer3, ...)

Returns the GEOTRACES quality control flag of the given tracers.

GEOTRACES's `Char`s are converted to `Int` by this function.

From GEOTRACES:
```
1 = good quality
2 = not evaluated, not available or unknown quality
3 = questionable/suspect quality
4 = bad quality
9 = missing data
```

Note that there should be no `9` because `missing` data is skipped
by the `observations` function.
"""
function qualitycontrols(ds::Dataset, tracers::String...)
    vs = ((ds[varname(tracer)][:] for tracer in tracers)...,)
    ikeep = findall(i -> !any(ismissing.(getindex.(vs, i))), eachindex(vs[1]))
    qcvs = ((ds[qcvarname(tracer)].var[:] for tracer in tracers)...,)
    return ((parse.(Int, view(qcv, ikeep)) for qcv in qcvs)...,)
end
function qualitycontrols(ds::Dataset, tracer::String)
    v = ds[varname(tracer)][:]
    ikeep = findall(!ismissing, v)
    qcv = ds[qcvarname(tracer)].var[:]
    return parse.(Int, view(qcv, ikeep))
end

"""
    metadata(tracer1, tracer2, tracer3, ...)

Returns the GEOTRACES metadata for given tracers.
"""
function metadata(ds::Dataset, tracers::String...; metadatakeys=("lat", "lon", "depth"), QCmax=1)
    qcvs = ((ds[qcvarname(tracer)].var[:] for tracer in tracers)...,)
    ikeep = findall(i -> all((parse.(Int, getindex.(qcvs, i))) .≤ QCmax), eachindex(qcvs[1]))
    ikeep = CartesianIndices(size(qcvs[1]))[ikeep]
    GEOTRACESmetadatakeys = varname.(metadatakeys)
    metadata = [metadatakeyvaluepair(ds[k], ikeep) for k in GEOTRACESmetadatakeys]
    namedmetadata = (; metadata...)
    return namedmetadata
end


# TODO treatment of uncertainty
# Not all variable have a "standard deviation" in GEOTRACES
# But I could create one from
# - the number of significant digits of each tracer per cruise?
# - the STD along each cruise?
# - the total STD?
function standarddeviations(ds::Dataset, tracer::String)
    _, s = observations(ds, varname(tracer), stdvarname(tracer))
    return s
end

function standarddeviations(ds::Dataset, tracers::String...)
    x_and_s = observations(ds, varname.(tracers)..., stdvarname.(tracers)...)
    return x_and_s[length(tracers)+1:end]
end


function observations_with_std(ds::Dataset, tracer::String)
    x, s = observations(ds, varname(tracer), stdvarname(tracer))
    u = unit(x[1])
    return @. (ustrip(x) ± ustrip(s)) * u
end
function observations_with_std(ds::Dataset, tracers::String...)
    x_and_s = observations(ds, varname.(tracers)..., stdvarname.(tracers)...)
    n = length(tracers)
    us = ((unit(x[1]) for x in x_and_s[1:n])...,)
    return (((ustrip.(x_and_s[i]) .± ustrip.(x_and_s[i+n])) * us[i] for i in 1:n)...,)
end

# open and close ds if not provided
for f in [:observations, :metadata, :transect, :transects, :list_of_cruises,
         :list_of_stations, :variable, :qualitycontrols, :cruisetrack,
         :standarddeviations, :matchingvariables, :observations_with_std]
    @eval begin
        $f(args...; kwargs...) =
        Dataset(GEOTRACES_IDP17_DiscreteSamples_path(), "r") do ds
             $f(ds, args...; kwargs...)
        end
    end
end

end # module
