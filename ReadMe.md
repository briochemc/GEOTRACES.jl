# GEOTRACES.jl

A package for reading and using GEOTRACES data in Julia.

In order to use this software, you must first download the GEOTRACES IDP 17 data as a NetCDF file and place it in a `Data` directory in your local "home" directory. That is, the path for the NetCDF file should be:

```
$HOME/Data/GEOTRACES/GEOTRACES_IDP2017_v2 2/discrete_sample_data/netcdf/GEOTRACES_IDP2017_v2_Discrete_Sample_Data.nc
```

(You should be able to do `$ echo $HOME` in the terminal to find out where `$HOME` is.)

The GEOTRACES data management committee does not allow third party distribution of its data and does not provide a public URL pointing directly to the data.
However **the GEOTRACES datasets are publicly accessible, but must be *manually* downloaded**.
(This goes against core principles of open science, but the author of the GEOTRACES.jl package respects the decision of the many contributors that have agreed on these limitations.)



### Tools

List of things you might want to extract from GEOTRACES data:

- Most GEOTRACES variable names are not explicit (e.g., `var70` for Cadmium).
    For this reason, GEOTRACES.jl provides shortcut names for common tracers/variables.
    To check which variable they correspond to, you can do (taking Cadmium as an example)
    ```julia
    julia> variable("Cd")
    var70 (698 × 1866)
      Datatype:    Float32
      Dimensions:  N_SAMPLES × N_STATIONS
      Attributes:
       long_name            = Cd_D_CONC_BOTTLE
       units                = nmol/kg
       comment              = Concentration of dissolved Cd
       C_format             = %.3f
       FORTRAN_format       = F12.3
       _FillValue           = -1.0e10
    ```
    These shortcuts are matched to the GEOTRACES variable names in the `tracer_str` function.
    PRs or suggestions to add new shortcut names are welcome!

- A vector of the concentrations of a tracer, e.g., Cadmium, with units (using [Unitful.jl](https://github.com/PainterQubits/Unitful.jl)), with missing values skipped, is returned by:

    ```julia
    julia> Cd = observations("Cd")
    7108-element Array{Quantity{Float32,𝐍*𝐌^-1,Unitful.FreeUnits{(kg^-1, nmol),𝐍*𝐌^-1,nothing}},1}:
     0.0528f0 nmol kg^-1
     0.0697f0 nmol kg^-1
     0.1557f0 nmol kg^-1
                       ⋮
     1.0396f0 nmol kg^-1
     1.0376f0 nmol kg^-1
     1.0307f0 nmol kg^-1
    ```

- To get the corresponding metadata of that tracer's observations, like location, date, etc., one can do

    ```julia
    julia> MD = metadata("Cd") ; # a (lat, lon, depth) named tuple

    julia> MD.Depth
    7108-element Array{Quantity{Float32,𝐋,Unitful.FreeUnits{(m,),𝐋,nothing}},1}:
       10.0f0 m
       25.0f0 m
       51.0f0 m
              ⋮
     1101.0f0 m
     1198.0f0 m
     1300.0f0 m

    julia> MD.Latitude
    7108-element Array{Float32,1}:
     -49.5472
     -49.5472
     -49.5472
       ⋮
      48.65
      48.65
      48.65
    ```

    The default is `(lat, lon, depth)` but you can also specify which metadata you want with the `metadatakeys` keyword with a tuple of the metadata names (shortcuts like `"lat"` and `"lon"` provided).
    For example, `MD` below contains latitude and date information of where/when Cadmium was observed:

    ```julia
    julia> MD = metadata("Cd", metadatakeys=("lat", "date")) ; # just (lat, date)
    
    julia> MD.DateTime
    7108-element Array{Dates.DateTime,1}:
     2011-03-05T19:28:00
     2011-03-05T19:28:00
     2011-03-05T19:28:00
     ⋮
     2012-08-17T00:18:42
     2012-08-17T00:18:42
     2012-08-17T00:18:42
    ```

- Data organized into cruise transects and profiles using the [OceanographyCruises.jl](https://github.com/briochemc/OceanographyCruises.jl) package

    ```julia
    Cd_transects = transects("Cd")
    Cd_transect = transects("Cd", "GA02")
    ```

- GEOTRACES variables sometimes come with a standard deviation, in which case you can use

    ```julia
    Cd_std = standarddeviations("Cd") # STD if it exists
    Cd = observations_with_std("Cd")  # Cd ± Cd_std (using Measurments.jl)
    ```

    > **Note**: we do not recommend it at this stage because a most of the GEOTRACES data comes with no quantification of uncertainty.

- Sometimes you want to extract data for two or more tracers. So you might want them only where/when these are observed simultaneously.

    ```julia
    Cd, PO₄, DFe = observations("Cd", "PO₄", "DFe") # Cd, PO₄, and DFe obs with units
    MD = metadata("Cd", "PO₄", "DFe")          # a (lat, lon, depth) NTuple
    MD = metadata("Cd", "PO₄", "DFe", metadatakeys=("lat", "lon", "depth")) # same as above
    MD = metadata("Cd", "PO₄", "DFe", metadatakeys=("lat", "date"))         # just (lat, date)
    Cd_std, PO₄_std = standarddeviations("Cd", "PO₄") # STD if they exist
    Cd, PO₄ = observations_with_std("Cd", "PO₄")      # Cd ± Cd_std, PO₄ ± PO₄_std
    ```

## TODO

- Deal with uncertainty on a transect or profile/station basis, by taking the maximum of the available std, the minimum observed diff, the last significant digit?
- plotting recipes mimicing Ocean Data View
- figure out a way to CI despite the GEOTRACES data-access restrictions

