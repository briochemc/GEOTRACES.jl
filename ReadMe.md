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

> ***Important notes***
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
> The GEOTRACES data management committee does not allow third party distribution of its data and does not provide a public URL pointing directly to the data, which prevents this package from downloading the data for you.
> However, **the GEOTRACES data are publicly accessible, but they *must be manually downloaded***.

To use this package, like every other registered Julia package, you must [add it to your environment](https://julialang.github.io/Pkg.jl/v1/managing-packages/#Adding-registered-packages), and then

```julia
julia> using GEOTRACES
```

should work.

### What this package does

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
    

- A vector of the concentrations of a tracer, e.g., Cadmium, with units (using [Unitful.jl](https://github.com/PainterQubits/Unitful.jl)), with missing values skipped, is returned by:

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

- To get the corresponding metadata of that tracer's observations, like location, date, etc., one can do

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

- Data organized into cruise transects and profiles using the [OceanographyCruises.jl](https://github.com/briochemc/OceanographyCruises.jl) package

    ```julia
    julia> Cd_transects = GEOTRACES.transects("Cd")
    Transects of Cd
    (Cruises GA02, GA03, GA04, GA10, GA11, GI04, GIPY01, GIPY02, GIPY04, GIPY05, GIPY06, GIPY13, GP02, GP13, GP16, GP18, GPpr01, GPpr02, and GPpr07.)
    ```

- Sometimes you want to extract data for two or more tracers but *only where/when these are observed simultaneously*. GEOTRACES does the filtering for you if you ask for them in the same call:

    ```julia
    julia> Cd, PO₄, DFe = GEOTRACES.observations("Cd", "PO₄", "DFe") # Cd, PO₄, and DFe obs with units
    (Unitful.Quantity{Float32,𝐍 𝐌⁻¹,Unitful.FreeUnits{(kg⁻¹, nmol),𝐍 𝐌⁻¹,nothing}}[0.0528f0 nmol kg⁻¹, 0.0697f0 nmol kg⁻¹, 0.1557f0 nmol kg⁻¹, 0.3743f0 nmol kg⁻¹, 0.4684f0 nmol kg⁻¹, 0.533f0 nmol kg⁻¹, 0.5569f0 nmol kg⁻¹, 0.6011f0 nmol kg⁻¹, 0.6586f0 nmol kg⁻¹, 0.7084f0 nmol kg⁻¹  …  0.7873171f0 nmol kg⁻¹, 0.8044f0 nmol kg⁻¹, 0.7717073f0 nmol kg⁻¹, 0.7809f0 nmol kg⁻¹, 0.74536586f0 nmol kg⁻¹, 0.7665f0 nmol kg⁻¹, 0.7336f0 nmol kg⁻¹, 0.7464f0 nmol kg⁻¹, 0.7295f0 nmol kg⁻¹, 0.7203122f0 nmol kg⁻¹], Unitful.Quantity{Float32,𝐍 𝐌⁻¹,Unitful.FreeUnits{(kg⁻¹, μmol),𝐍 𝐌⁻¹,nothing}}[1.01f0 μmol kg⁻¹, 2.37f0 μmol kg⁻¹, 2.34f0 μmol kg⁻¹, 2.29f0 μmol kg⁻¹, 2.25f0 μmol kg⁻¹, 2.23f0 μmol kg⁻¹, 2.21f0 μmol kg⁻¹, 1.01f0 μmol kg⁻¹, 1.11f0 μmol kg⁻¹, 1.46f0 μmol kg⁻¹  …  2.56f0 μmol kg⁻¹, 2.55f0 μmol kg⁻¹, 2.5f0 μmol kg⁻¹, 2.48f0 μmol kg⁻¹, 2.42f0 μmol kg⁻¹, 2.35f0 μmol kg⁻¹, 2.33f0 μmol kg⁻¹, 2.32f0 μmol kg⁻¹, 2.32f0 μmol kg⁻¹, 2.31f0 μmol kg⁻¹], Unitful.Quantity{Float32,𝐍 𝐌⁻¹,Unitful.FreeUnits{(kg⁻¹, nmol),𝐍 𝐌⁻¹,nothing}}[0.52f0 nmol kg⁻¹, 0.37f0 nmol kg⁻¹, 0.43f0 nmol kg⁻¹, 0.35f0 nmol kg⁻¹, 0.31f0 nmol kg⁻¹, 0.36f0 nmol kg⁻¹, 0.41f0 nmol kg⁻¹, 0.44f0 nmol kg⁻¹, 0.64f0 nmol kg⁻¹, 0.75f0 nmol kg⁻¹  …  0.6087805f0 nmol kg⁻¹, 0.66097564f0 nmol kg⁻¹, 0.6707317f0 nmol kg⁻¹, 0.5721951f0 nmol kg⁻¹, 0.50731707f0 nmol kg⁻¹, 0.4878049f0 nmol kg⁻¹, 0.46341464f0 nmol kg⁻¹, 0.4497561f0 nmol kg⁻¹, 0.44f0 nmol kg⁻¹, 0.48292682f0 nmol kg⁻¹])
    ```

