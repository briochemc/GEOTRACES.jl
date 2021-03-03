# GEOTRACES.jl

A package for reading and using [GEOTRACES](https://www.geotraces.org/) data in Julia.

<p>
  <a href="https://github.com/briochemc/GEOTRACES.jl/actions">
    <img src="https://img.shields.io/github/workflow/status/briochemc/GEOTRACES.jl/Mac%20OS%20X?label=OSX&logo=Apple&logoColor=white&style=flat-square">
  </a>
  <a href="https://github.com/briochemc/GEOTRACES.jl/actions">
    <img src="https://img.shields.io/github/workflow/status/briochemc/GEOTRACES.jl/Linux?label=Linux&logo=Linux&logoColor=white&style=flat-square">
  </a>
  <a href="https://github.com/briochemc/GEOTRACES.jl/actions">
    <img src="https://img.shields.io/github/workflow/status/briochemc/GEOTRACES.jl/Windows?label=Windows&logo=Windows&logoColor=white&style=flat-square">
  </a>
  <a href="https://codecov.io/gh/briochemc/GEOTRACES.jl">
    <img src="https://img.shields.io/codecov/c/github/briochemc/GEOTRACES.jl/master?label=Codecov&logo=codecov&logoColor=white&style=flat-square">
  </a>
</p>

> ***Important note***
>
> In order to use this software, you must first download the GEOTRACES IDP 17 data as a NetCDF file.
>
> I would recommend that you place it in a `Data` directory in your local "home" directory.
> For example, on OSX, the path of my GEOTRACES NetCDF file is:
>
> ```
> $HOME/Data/GEOTRACES/GEOTRACES_IDP2017_v2/discrete_sample_data/netcdf/GEOTRACES_IDP2017_v2_Discrete_Sample_Data.nc
> ```
>
> Alternatively, you can configure this path by setting the `GEOTRACES_IDP2017_PATH` environment variable to point to the location **of the NetCDF file** you downloaded.
> So, in your Julia code, you could do something like
>
> ```julia
> ENV["GEOTRACES_IDP2017_PATH"] = <path_to_your_GEOTRACES_data>
> ```
>
> The GEOTRACES data management committee does not allow third-party distribution of its data and does not provide a public URL pointing directly to the data, which prevents this package from downloading the data for you.
> However, **the GEOTRACES data are publicly accessible, but they *must be manually downloaded***.

To use this package, like every other registered Julia package, you must [add it to your environment](https://julialang.github.io/Pkg.jl/v1/managing-packages/#Adding-registered-packages), and then

```julia
julia> using GEOTRACES
```

should work.

### What this package does

Simply put, this package helps you read and use GEOTRACES data in Julia.

- Most GEOTRACES variable names are not very explicit (e.g., `var70` for Cadmium).
    For this reason, GEOTRACES.jl provides shortcut names for common tracers/variables.
    To check which variable they correspond to, you can do (taking Cadmium as an example)

    ```julia
    julia> GEOTRACES.variable("Cd")
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
    At this stage, only a few variables have a predefined shortcut (those I have used myself).
    But suggestions to add new shortcut names are more than welcome! Just start an issue to ask for it on the repository and I'll try to respond ASAP!
    (PRs even better — check the `varname` function for the current list of predefined shortcuts.)


- For those variables with a predefined shortcut name, you can get the vector of the concentrations with units (using [Unitful.jl](https://github.com/PainterQubits/Unitful.jl)) with the `GEOTRACES.observations` function:

    ```julia
    julia> Cd = GEOTRACES.observations("Cd")
    6935-element MetadataArrays.MetadataArray{Unitful.Quantity{Float32,𝐍 𝐌⁻¹,Unitful.FreeUnits{(kg⁻¹, nmol),𝐍 𝐌⁻¹,nothing}},1,NamedTuple{(:name, :GEOTRACESvarname, :lat, :lon, :depth),Tuple{String,String,Array{Float32,1},Array{Float32,1},Array{Unitful.Quantity{Float32,𝐋,Unitful.FreeUnits{(m,),𝐋,nothing}},1}}},Array{Unitful.Quantity{Float32,𝐍 𝐌⁻¹,Unitful.FreeUnits{(kg⁻¹, nmol),𝐍 𝐌⁻¹,nothing}},1}}:
     0.0528f0 nmol kg⁻¹
     0.0697f0 nmol kg⁻¹
     0.1557f0 nmol kg⁻¹
                      ⋮
     1.0396f0 nmol kg⁻¹
     1.0376f0 nmol kg⁻¹
     1.0307f0 nmol kg⁻¹
    ```

- Although it can be used as one, this is not a standard vector, it's a `MetadataVector`, i.e., it comes with some metadata. To get the corresponding metadata of that tracer's observations, like location, date, etc., one can simply append `.metadata`:

    ```julia
    julia> MD = Cd.metadata ; # a named tuple with lat, lon, depth, and more...

    julia> MD.depth
    6935-element Array{Unitful.Quantity{Float32,𝐋,Unitful.FreeUnits{(m,),𝐋,nothing}},1}:
       10.0f0 m
       25.0f0 m
       51.0f0 m
              ⋮
     1101.0f0 m
     1198.0f0 m
     1300.0f0 m

    julia> MD.lat
    6935-element Array{Float32,1}:
     -49.5472
     -49.5472
     -49.5472
       ⋮
      48.65
      48.65
      48.65
    ```

    The default metadata contains latitude, longitude, and depth,

    ```julia
    julia> keys(MD)
    (:name, :GEOTRACESvarname, :lat, :lon, :depth)
    ```
    but you could also have specified which metadata you wanted using the `metadatakeys` keyword:

    ```julia
    julia> Cd2 = GEOTRACES.observations("Cd", metadatakeys=("lat", "lon")); keys(Cd2.metadata)
    (:name, :GEOTRACESvarname, :lat, :lon) # <- no depth field
    ```

- Sometimes, you want to extract data for two or more tracers but *only where/when these are observed simultaneously*. GEOTRACES does the filtering for you if you ask for them in the same call:

    ```julia
    julia> Cd, PO₄, DFe = GEOTRACES.observations("Cd", "PO₄", "DFe") # Cd, PO₄, and DFe obs with units
    (Unitful.Quantity{Float32,𝐍 𝐌⁻¹,Unitful.FreeUnits{(kg⁻¹, nmol),𝐍 𝐌⁻¹,nothing}}[0.0528f0 nmol kg⁻¹, 0.0697f0 nmol kg⁻¹, 0.1557f0 nmol kg⁻¹, 0.3743f0 nmol kg⁻¹, 0.4684f0 nmol kg⁻¹, 0.533f0 nmol kg⁻¹, 0.5569f0 nmol kg⁻¹, 0.6011f0 nmol kg⁻¹, 0.6586f0 nmol kg⁻¹, 0.7084f0 nmol kg⁻¹  …  0.7873171f0 nmol kg⁻¹, 0.8044f0 nmol kg⁻¹, 0.7717073f0 nmol kg⁻¹, 0.7809f0 nmol kg⁻¹, 0.74536586f0 nmol kg⁻¹, 0.7665f0 nmol kg⁻¹, 0.7336f0 nmol kg⁻¹, 0.7464f0 nmol kg⁻¹, 0.7295f0 nmol kg⁻¹, 0.7203122f0 nmol kg⁻¹], Unitful.Quantity{Float32,𝐍 𝐌⁻¹,Unitful.FreeUnits{(kg⁻¹, μmol),𝐍 𝐌⁻¹,nothing}}[1.01f0 μmol kg⁻¹, 2.37f0 μmol kg⁻¹, 2.34f0 μmol kg⁻¹, 2.29f0 μmol kg⁻¹, 2.25f0 μmol kg⁻¹, 2.23f0 μmol kg⁻¹, 2.21f0 μmol kg⁻¹, 1.01f0 μmol kg⁻¹, 1.11f0 μmol kg⁻¹, 1.46f0 μmol kg⁻¹  …  2.56f0 μmol kg⁻¹, 2.55f0 μmol kg⁻¹, 2.5f0 μmol kg⁻¹, 2.48f0 μmol kg⁻¹, 2.42f0 μmol kg⁻¹, 2.35f0 μmol kg⁻¹, 2.33f0 μmol kg⁻¹, 2.32f0 μmol kg⁻¹, 2.32f0 μmol kg⁻¹, 2.31f0 μmol kg⁻¹], Unitful.Quantity{Float32,𝐍 𝐌⁻¹,Unitful.FreeUnits{(kg⁻¹, nmol),𝐍 𝐌⁻¹,nothing}}[0.52f0 nmol kg⁻¹, 0.37f0 nmol kg⁻¹, 0.43f0 nmol kg⁻¹, 0.35f0 nmol kg⁻¹, 0.31f0 nmol kg⁻¹, 0.36f0 nmol kg⁻¹, 0.41f0 nmol kg⁻¹, 0.44f0 nmol kg⁻¹, 0.64f0 nmol kg⁻¹, 0.75f0 nmol kg⁻¹  …  0.6087805f0 nmol kg⁻¹, 0.66097564f0 nmol kg⁻¹, 0.6707317f0 nmol kg⁻¹, 0.5721951f0 nmol kg⁻¹, 0.50731707f0 nmol kg⁻¹, 0.4878049f0 nmol kg⁻¹, 0.46341464f0 nmol kg⁻¹, 0.4497561f0 nmol kg⁻¹, 0.44f0 nmol kg⁻¹, 0.48292682f0 nmol kg⁻¹])
    ```

- Finally, eventually, you probably will want the GEOTRACES data organized into cruise transects and profiles. This is supported under the hood by the [OceanographyCruises.jl](https://github.com/briochemc/OceanographyCruises.jl) package, so that you can do

    ```julia
    julia> Cd = GEOTRACES.transects("Cd")
    Transects of Cd
    (Cruises GA02, GA03, GA04, GA10, GA11, GI04, GIPY01, GIPY02, GIPY04, GIPY05, GIPY06, GIPY13, GP02, GP13, GP16, GP18, GPpr01, GPpr02, and GPpr07.)
    ```

    to access all the transects that have Cadmium concentrations, and explore the data transect by transect, you can append `.transects` and chose a cruise, e.g.,

    ```julia
    julia> Cd_GA02 = Cd.transects[1]
    Transect of Observed Cd
    Cruise GA02
    ┌─────────┬─────────────────────┬─────────────────────┬────────────────────┐
    │ Station │                Date │                 Lat │                Lon │
    ├─────────┼─────────────────────┼─────────────────────┼────────────────────┤
    │     001 │ 2011-03-05T19:28:00 │  -49.54719924926758 │  307.3118896484375 │
    │     002 │ 2010-05-02T19:36:57 │    64.0000991821289 │  325.7500915527344 │
    │     002 │ 2011-03-06T23:17:05 │  -48.89419937133789 │  311.2652893066406 │
    │     003 │ 2011-03-08T01:17:59 │  -46.91999816894531 │  312.8004150390625 │
    │     003 │ 2010-05-03T21:30:00 │   62.34510040283203 │ 324.00189208984375 │
    │     004 │ 2011-03-09T01:31:59 │   -44.7067985534668 │  314.4638977050781 │
    │     005 │ 2011-03-10T00:58:29 │ -42.371299743652344 │  315.9742126464844 │
    │    ⋮    │          ⋮          │          ⋮          │         ⋮          │
    └─────────┴─────────────────────┴─────────────────────┴────────────────────┘
    ```

    which contains all the profiles of the GA02 cruise. You can further explore profiles by appending `.profiles` and selecting a profile, e.g.,

    ```julia
    julia> Cd_GA02_profile1 = Cd_GA02.profiles[1]
    Depth profile at Station 001 2011-03-05T19:28:00 (49.5S, 307.3E)
    ┌───────┬──────────────────────┐
    │ Depth │    Value [nmol kg⁻¹] │
    ├───────┼──────────────────────┤
    │  10.0 │ 0.052799999713897705 │
    │  25.0 │  0.06970000267028809 │
    │  51.0 │  0.15569999814033508 │
    │  74.0 │   0.3743000030517578 │
    │ 100.0 │   0.4684000015258789 │
    │ 151.0 │   0.5047000050544739 │
    │ 200.0 │   0.5329999923706055 │
    │   ⋮   │          ⋮           │
    └───────┴──────────────────────┘
    ```

    Finally, you can access the vectors of concentration values (with units!) and depths by appending `.values` and `.depths`:

    ```julia
    julia> Cd_GA02_profile1.values
    24-element Array{Unitful.Quantity{Float32,𝐍 𝐌⁻¹,Unitful.FreeUnits{(kg⁻¹, nmol),𝐍 𝐌⁻¹,nothing}},1}:
     0.0528f0 nmol kg⁻¹
     0.0697f0 nmol kg⁻¹
     0.1557f0 nmol kg⁻¹
                      ⋮
     0.6946f0 nmol kg⁻¹
     0.6997f0 nmol kg⁻¹
     0.7067f0 nmol kg⁻¹

    julia> Cd_GA02_profile1.depths
    24-element Array{Float64,1}:
       10.0
       25.0
       51.0
        ⋮
     2123.0
     2248.0
     2312.0
     ```

I hope you find this tool useful! Suggestions and PRs welcome!
