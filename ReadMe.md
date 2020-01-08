# GEOTRACES.jl

A package for reading and using GEOTRACES data in Julia.

In order to use this software, you must first download the GEOTRACES IDP 17 data as nc files.

For the discrete sample data, make sure it is located in a `Data` directory in your "home" directory. That is it should be there:
```
$HOME/Data/GEOTRACES/GEOTRACES_IDP2017_v2 2/discrete_sample_data/netcdf/GEOTRACES_IDP2017_v2_Discrete_Sample_Data.nc
```

Downloading the data manually is unfortunately mandatory at this stage.

# Data names

This serves as a reference for accessing data in the GEOTRACES NetCDF files.

These are the first ~30 variables of the GEOTRACES NetCDF file.

|      name |                              long_name |        size |                               unit |
|-----------|----------------------------------------|-------------|------------------------------------|
|  metavar1 |                                 Cruise |   (6, 1866) |                                  ? |
|  metavar2 |                                Station |  (20, 1866) |                                  ? |
|  metavar3 |                                   Type |     (1866,) |                                  ? |
| longitude |                              Longitude |     (1866,) |                       degrees_east |
|  latitude |                               Latitude |     (1866,) |                      degrees_north |
| date_time |  Decimal Gregorian Days of the station |     (1866,) | days since 0006-01-01 00:00:00 UTC |
|      var1 |                               PRESSURE | (698, 1866) |                               dbar |
|      var2 |                                  DEPTH | (698, 1866) |                                  m |
|      var3 |                GEOTRACES Sample Number | (698, 1866) |                                  ? |
|      var4 |                          Bottle Number | (698, 1866) |                                  ? |
|      var5 |                     BODC Bottle Number | (698, 1866) |                                  ? |
|      var6 |                        Firing Sequence | (698, 1866) |                                  ? |
|  var6_STD |  Standard deviation of Firing Sequence | (698, 1866) |                                  ? |
|      var7 |                                 CTDTMP | (698, 1866) |                              deg C |
|      var8 |                                 CTDSAL | (698, 1866) |                                  ? |
|      var9 |                 SALINITY_D_CONC_BOTTLE | (698, 1866) |                                  ? |
|     var10 |                   CFC-11_D_CONC_BOTTLE | (698, 1866) |                            pmol/kg |
|     var11 |                   CFC-12_D_CONC_BOTTLE | (698, 1866) |                            pmol/kg |
|     var12 |                   CFC113_D_CONC_BOTTLE | (698, 1866) |                            pmol/kg |
|     var13 |                      SF6_D_CONC_BOTTLE | (698, 1866) |                            fmol/kg |
|     var14 |                       He_D_CONC_BOTTLE | (698, 1866) |                            nmol/kg |
| var14_STD | Standard deviation of He_D_CONC_BOTTLE | (698, 1866) |                            nmol/kg |
|     var15 |                       Ne_D_CONC_BOTTLE | (698, 1866) |                            nmol/kg |
| var15_STD | Standard deviation of Ne_D_CONC_BOTTLE | (698, 1866) |                            nmol/kg |
|     var16 |                       Ar_D_CONC_BOTTLE | (698, 1866) |                            umol/kg |
| var16_STD | Standard deviation of Ar_D_CONC_BOTTLE | (698, 1866) |                            umol/kg |
|     var17 |                       Kr_D_CONC_BOTTLE | (698, 1866) |                            nmol/kg |
| var17_STD | Standard deviation of Kr_D_CONC_BOTTLE | (698, 1866) |                            nmol/kg |
|     var18 |                       Xe_D_CONC_BOTTLE | (698, 1866) |                            nmol/kg |
| var18_STD | Standard deviation of Xe_D_CONC_BOTTLE | (698, 1866) |                            nmol/kg |

The most common metadata one wants with a given tracer(s) is just location data.
So the default behavior of `observations(tracer)` is to return a n×4 array of

| value | latitude | longitude | depth |

Also given the arrangement and units, it is a good idea to have special treatment for `metavar`s, `lat`/`lon`, dates, and IDs/numbers.

## Tools

List of things you might want to extract from GEOTRACES data:

- A vector of the concentrations of a tracer, e.g., `tracer = "Cd"`.
    Optionally, some metadata of that tracer's observations, like location, date, etc.
    The following functions should work and give what you expect:

    ```julia
    Cd = observations("Cd") # Cd obs with units
    MD = metadata("Cd")     # a (lat, lon, depth) NTuple
    MD = metadata("Cd", metadatakeys=("lat", "lon", "depth")) # same as above
    MD = metadata("Cd", metadatakeys=("lat", "date"))         # just (lat, date)
    ```

    - TODO: some uncertainty might be given as a standard deviation, in which case you can use

        ```julia
        Cd_std = standarddeviations("Cd") # STD if they exist
        Cd = observations_and_std("Cd")   # Cd ± Cd_std (using Measurments.jl)
        ```

- Sometimes you want to extract data for two tracers, to make comparisons. So you might want them only where/when both are observed.

    ```julia
    Cd, PO₄, DFe = observations("Cd", "PO₄", "DFe") # Cd, PO₄, and DFe obs with units
    MD = metadata("Cd", "PO₄", "DFe")          # a (lat, lon, depth) NTuple
    MD = metadata("Cd", "PO₄", "DFe", metadatakeys=("lat", "lon", "depth")) # same as above
    MD = metadata("Cd", "PO₄", "DFe", metadatakeys=("lat", "date"))         # just (lat, date)
    ```

    - TODO: For uncertainty you can use

        ```julia
        tracers = ("Cd", "PO₄")
        Cd_std, PO₄_std = standarddeviations(tracers) # STD if they exist
        Cd, PO₄ = observations_and_std(tracers)   # Cd ± std, PO₄ ± std
        ```

- Data organized into cruise transects and profiles

    ```julia
    Cd_transects = transects("Cd")
    Cd_transect = transects("Cd", "GA02")
    ```