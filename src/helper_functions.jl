"""
    dictionary(ds)

A dictionary of the variables `name` and `long_name` attributes.

Useful for development, `dictionary(ds)` allows me to provide shortcuts — and a 
friendlier interface — for accessing GEOTRACES variables.
"""
function dictionary(ds::Dataset)
    Dict((k, longname(var)) for (k,var) in ds)
end

# Not all variables have a `long_name` attribute, so replace by ? if it's not there.
longname(var) = haskey(var.attrib,"long_name") ? var.attrib["long_name"] : "?"


# TODO check these are still useful
isconcentration(var) = occursin("CONC", longname(var))
isdissolvedconcentration(var) = occursin("D_CONC", longname(var))
islowleveldissolvedconcentration(var) = occursin("LL_D_CONC", longname(var))
isstandarddeviation(var) = occursin("Standard deviation", longname(var))

"""
    matchingvariables(ds::Dataset, str::String)

Lists names of variables that have `str` in their `long_name` attribute.
"""
function matchingvariables(ds::Dataset, str::String)
    return [p for p in dictionary(ds) if occursin(Regex(str, "i"), p[2])]
end

variable(ds::Dataset, tracer::String) = println(ds[varname(tracer)])

# Special treatment for metadata

metadatakeyvaluepair(v, idx) = @match name(v) begin
    "metavar1"  => (:Cruise, reduce.(string, filter.(!=('\0'), eachcol(v.var[:,:])))[[i.I[2] for i in idx]])
    "metavar2"  => (:Station, reduce.(string, filter.(!=('\0'), eachcol(v.var[:,:])))[[i.I[2] for i in idx]])
    "longitude" => (:Longitude, float.(v.var[[i.I[2] for i in idx]]))
    "latitude"  => (:Latitude, float.(v.var[[i.I[2] for i in idx]]))
    "var2"      => (:Depth, unitfunction(v.attrib["units"]).(float.(v.var[idx])))
    "var1"      => (:Pressure, unitfunction(v.attrib["units"]).(float.(v.var[idx])))
    "date_time" => (:DateTime, DateTime.(v[[i.I[2] for i in idx]]))
    _           => (Symbol(name(v)), float.(v.var[idx]))
end



"""
    varname(tracer)

Returns the GEOTRACES variable name that "matches" `tracer`.
"""
varname(tracer::String) = @match lowercase(tracer) begin
    "cruise"                                                              => "metavar1"
    "station"                                                             => "metavar2"
    "lat" || "latitude"                                                   => "latitude"
    "lon" || "longitude"                                                  => "longitude"
    "pressure"                                                            => "var1"
    "depth" || "depths"                                                   => "var2"
    "date" || "datetime" || "date/time" || "date and time" || "date time" => "date_time"
    "t" || "temp" || "temperature"                                        => "var7"
    "salinity"                                                            => "var8"
    "he" || "helium"                                                      => "var14"
    "o2" || "o₂" || "oxygen" || "dioxygen"                                => "var19"
    "po₄" || "po4" || "phosphate"                                         => "var21"
    "no₃" || "no3" || "nitrate"                                           => "var23"
    "si" || "si(oh)₄" || "silicate"                                       => "var24"
    "cd" || "cadmium"                                                     => "var70"
    "fe" || "iron" || "dissolved iron" || "dfe"                           => "var73"
    "ni" || "nickel"                                                      => "var83"
    "δcd" || "δ¹¹⁰cd" || "δ110cd" || "δcadmium"                           => "var116"
    "δfe" || "δ⁵⁴fe" || "δ54fe" || "δiron"                                => "var117"
    _ => tracer
end


"""
    isotope(tracer)

Returns the GEOTRACES variable name of the isotope of tracer `str`.
"""
isotope(tracer::String) = @match lowercase(tracer) begin
    "cd" || "cadmium"       => "δcd"
    "fe" || "iron" || "dfe" => "δfe"
    _ => str
end
export isotope


"""
    stdvarname(tracer)

Returns the GEOTRACES variable name of the standard deviation of tracer `str`.
"""
stdvarname(tracer::String) = string(varname(tracer), "_STD")


"""
    qcvarname(tracer)

Returns the GEOTRACES variable name of the standard deviation of tracer `str`.
"""
qcvarname(tracer::String) = string(varname(tracer), "_QC")




# TODO add units
# - cell
# - TU
# - pertenthousand
unitfunction(str::String) = @match str begin
    "degrees_east"                       => identity
    "degrees_north"                      => identity
    "days since 0006-01-01 00:00:00 UTC" => x -> Day(x) + DateTime(6,1,1,0,0,0)
    "dbar"                               => x -> x * u"dbar"
    "m"                                  => x -> x * u"m"
    "deg C"                              => x -> x * u"°C"
    "pmol/kg"                            => x -> x * u"pmol/kg"
    "fmol/kg"                            => x -> x * u"fmol/kg"
    "nmol/kg"                            => x -> x * u"nmol/kg"
    "umol/kg"                            => x -> x * u"μmol/kg"
    "per mil"                            => x -> x * u"permille"
    "TU"                                 => x -> x * 0.118u"Bq/L"
    "per 10000"                          => x -> x * 0.1u"permille"
    "uBq/kg"                             => x -> x * u"μBq/kg"
    "mBq/kg"                             => x -> x * u"mBq/kg"
    "atoms/kg"                           => x -> x * u"1/kg"
    "l"                                  => x -> x * u"L"
    "nmol P/kg"                          => x -> x * u"nmol/kg"
    "umol C/kg"                          => x -> x * u"μmol/kg"
    "nmol N/kg"                          => x -> x * u"nmol/kg"
    "nmol Si/kg"                         => x -> x * u"nmol/kg"
    "ug/kg"                              => x -> x * u"μg/kg"
    "ng/liter"                           => x -> x * u"μg/L"
    "um^3"                               => x -> x * u"μm^3"
    "amol/cell"                          => x -> x * u"amol"
    "fmol/cell"                          => x -> x * u"fmol"
    "fmol/liter"                         => x -> x * u"fmol/L"
end




