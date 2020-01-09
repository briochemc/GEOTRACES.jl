module GEOTRACES

using OceanographyCruises
using NCDatasets, Unitful, Dates, Match
using Measurements


GEOTRACES_IDP17_DiscreteSamples_path() = joinpath(homedir(), "Data/GEOTRACES/GEOTRACES_IDP2017_v2 2/discrete_sample_data/netcdf/GEOTRACES_IDP2017_v2_Discrete_Sample_Data.nc")

include("helper_functions.jl")

"""
    cruisetrack(cruise_name)

Construct GEOTRACES `CruiseTrack` from cruise name.
"""
function cruisetrack(ds::Dataset, cruise_name)
    idx_cruise = findall(list_of_cruises(ds) .== cruise_name)
    lon = Float64.(ds["longitude"][idx_cruise])
    lat = Float64.(ds["latitude"][idx_cruise])
    date = Dates.DateTime.(ds["date_time"][idx_cruise])
    isort = sortperm(date)
    return CruiseTrack(cruise_name, lon[isort], lat[isort], date[isort])
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
function transect(ds::Dataset, tracer::String, cruise::String)
    var = tracervariable(ds, tracer)
    Istations = findall(list_of_cruises(ds) .== cruise)
    f = unitfunction(var.attrib["units"])
    profiles = DepthProfile{typeof(f(one(eltype(var.var))))}[]
    stations = list_of_stations(ds)
    lat = ds["latitude"]
    lon = ds["longitude"]
    depth = ds["var2"]
    date = ds["date_time"]
    for istation in Istations
        values = var[:,istation]
        ivalues = findall(!ismissing, values)
        isempty(ivalues) && continue
        station = Station(name=stations[istation], lat=lat[istation], lon=lon[istation], date=date[istation])
        push!(profiles, DepthProfile(station=station, depths=float.(depth[ivalues,istation]), values=f.(values[ivalues])))
    end
    return Transect(tracer=tracer, cruise=cruise, profiles=profiles)
end

"""
transects(tracer::String, cruise::String)

The `Transects` of observations of tracer `tracer`.
"""
function transects(ds::Dataset, tracer::String)
    var = tracervariable(ds, tracer)
    f = unitfunction(var.attrib["units"])
    ts = Transect{typeof(f(one(eltype(var.var))))}[]
    cs = String[]
    cruises = unique(list_of_cruises(ds))
    for cruise in cruises
        t = transect(ds, tracer, cruise)
        !isempty(t) && (push!(ts, t); push!(cs, cruise))
    end
    return Transects(tracer=tracer, cruises=cs, transects=ts)
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
"""
function observations(ds::Dataset, tracers::String...)
    fs = ((unitfunction(ds[tracer_str(tracer)].attrib["units"]) for tracer in tracers)...,)
    vs = ((ds[tracer_str(tracer)][:] for tracer in tracers)...,)
    ikeep = findall(i -> !any(ismissing.(getindex.(vs, i))), eachindex(vs[1]))
    return ((f.(float.(view(v, ikeep))) for (f,v) in zip(fs,vs))...,)
end
function observations(ds::Dataset, tracer::String)
    f = unitfunction(ds[tracer_str(tracer)].attrib["units"])
    v = ds[tracer_str(tracer)][:]
    ikeep = findall(!ismissing, v)
    return f.(float.(view(v, ikeep)))
end

"""
    metadata(tracer1, tracer2, tracer3, ...)

Returns the GEOTRACES metadata for given tracers.
"""
function metadata(ds::Dataset, tracers::String...; metadatakeys=("latitude", "longitude", "depth"))
    vs = ((ds[tracer_str(tracer)][:] for tracer in tracers)...,)
    ikeep = findall(i -> !any(ismissing.(getindex.(vs, i))), eachindex(vs[1]))
    ikeep = CartesianIndices(size(vs[1]))[ikeep]
    GEOTRACESmetadatakeys = tracer_str.(metadatakeys)
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

function standard_deviations(ds::Dataset, tracer::String)
    longname = string("Standard deviation of ", ds[tracer_str(tracer)].attrib["long_name"])
    vars = varbyattrib(ds, long_name=longname)
    length(vars) > 1 && error("multiple variables for '$longname'")
    length(vars) == 0 && error("no variable '$longname'")
    var = vars[1]
    unitf = unitfunction(var.attrib["units"])
    return unitf(float.(filter(!ismissing, var[:])))
end

# open and close ds if not provided
for f in [:observations, :metadata, :transect, :transects, :list_of_cruises,
         :list_of_stations, :CruiseTrack, :standard_deviations, :variable, :matchingvariables]
    @eval begin
        $f(args...; kwargs...) =
        Dataset(GEOTRACES_IDP17_DiscreteSamples_path(), "r") do ds
             $f(ds, args...; kwargs...)
        end
        export $f
    end
end

end # module
