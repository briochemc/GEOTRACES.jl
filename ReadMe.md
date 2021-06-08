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

### Get a table of GEOTRACES observations

Simply use the `GEOTRACES.observations` function. For example, to get cadmium data:

```julia
julia> obs = GEOTRACES.observations("Cd")
6935×7 DataFrame
  Row │ lat       lon      depth      cruise  station  date                 Cd
      │ Float32   Float32  Quantity…  String  String   DateTime…            Quantity…
──────┼──────────────────────────────────────────────────────────────────────────────────────
    1 │ -49.5472  307.312     10.0 m  GA02    001      2011-03-05T19:28:00  0.0528 nmol kg⁻¹
    2 │ -49.5472  307.312     25.0 m  GA02    001      2011-03-05T19:28:00  0.0697 nmol kg⁻¹
    3 │ -49.5472  307.312     51.0 m  GA02    001      2011-03-05T19:28:00  0.1557 nmol kg⁻¹
  ⋮   │    ⋮         ⋮         ⋮        ⋮        ⋮              ⋮                  ⋮
 6933 │  48.65    233.333   1101.0 m  GPpr07  P4       2012-08-17T00:18:42  1.0396 nmol kg⁻¹
 6934 │  48.65    233.333   1198.0 m  GPpr07  P4       2012-08-17T00:18:42  1.0376 nmol kg⁻¹
 6935 │  48.65    233.333   1300.0 m  GPpr07  P4       2012-08-17T00:18:42  1.0307 nmol kg⁻¹
                                                                            6929 rows omitted
```

> Note: In prior versions (< v2.0.0), `GEOTRACES.observations` used to return a vector with metadata. Since v2.0.0, `GEOTRACES.observations` returns tables from [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl), which is quickly becoming the standard for handling tabular data in Julia.

### Variable names made easy (with your help!)

Most GEOTRACES variable names are not very explicit (e.g., `var70` for cadmium).
For this reason, GEOTRACES.jl provides shortcut names for common tracers/variables, like "Cd" for cadmium.
To check which variable they correspond to, you can do (sticking with cadmium as an example)

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

GEOTRACES.jl provides a helper function, `matchingvariables`, to find variable names. For example, to find nickel variable names, you could start with

```julia
julia> GEOTRACES.matchingvariables("ni_")
18-element Vector{Pair{String, String}}:
      "var83" => "Ni_D_CONC_BOTTLE"
 "var333_STD" => "Standard deviation of Ni_SPT_CONC_PUMP"
 "var267_STD" => "Standard deviation of Ni_TPL_CONC_BOTTLE"
     "var267" => "Ni_TPL_CONC_BOTTLE"
 "var384_STD" => "Standard deviation of Ni_TPL_CONC_FISH"
     "var159" => "Ni_D_CONC_FISH"
 "var159_STD" => "Standard deviation of Ni_D_CONC_FISH"
     "var333" => "Ni_SPT_CONC_PUMP"
     "var431" => "Ni_CELL_CONC_BOTTLE"
     "var384" => "Ni_TPL_CONC_FISH"
  "var83_STD" => "Standard deviation of Ni_D_CONC_BOTTLE"
 "var266_STD" => "Standard deviation of Ni_TP_CONC_BOTTLE"
     "var266" => "Ni_TP_CONC_BOTTLE"
     "var383" => "Ni_TP_CONC_FISH"
 "var332_STD" => "Standard deviation of Ni_LPT_CONC_PUMP"
 "var383_STD" => "Standard deviation of Ni_TP_CONC_FISH"
     "var331" => "Ni_TP_CONC_PUMP"
     "var332" => "Ni_LPT_CONC_PUMP"
```

### Joining tracers

Sometimes, you want to extract data for two or more tracers but *only where/when these are observed simultaneously*. GEOTRACES does the filtering for you if you ask for them in the same call, thanks to the `innerjoin` function from [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl):

```julia
julia> obs = GEOTRACES.observations("Cd", "PO₄", "DFe") # Cd, PO₄, and DFe obs with units
5515×9 DataFrame
  Row │ lat       lon      depth      cruise  station  date                 Cd                  PO₄             DFe
      │ Float32   Float32  Quantity…  String  String   DateTime…            Quantity…           Quantity…       Quantity…
──────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1 │ -49.5472  307.312     10.0 m  GA02    001      2011-03-05T19:28:00  0.0528 nmol kg⁻¹    1.01 μmol kg⁻¹  0.52 nmol kg⁻¹
    2 │ -49.5472  307.312     10.0 m  GA02    001      2011-03-05T19:28:00  0.0528 nmol kg⁻¹    1.01 μmol kg⁻¹  0.52 nmol kg⁻¹
    3 │ -49.5472  307.312     25.0 m  GA02    001      2011-03-05T19:28:00  0.0697 nmol kg⁻¹    2.37 μmol kg⁻¹  0.37 nmol kg⁻¹
  ⋮   │    ⋮         ⋮         ⋮        ⋮        ⋮              ⋮                   ⋮                 ⋮                 ⋮
 5513 │ -10.5005  208.0     5101.2 m  GP16    36       2013-12-17T00:02:27  0.7295 nmol kg⁻¹    2.32 μmol kg⁻¹  0.44 nmol kg⁻¹
 5514 │ -10.5005  208.0     5125.4 m  GP16    36       2013-12-17T00:02:27  0.720312 nmol kg⁻¹  2.31 μmol kg⁻¹  0.482927 nmol kg⁻¹
 5515 │ -10.5005  208.0     5125.4 m  GP16    36       2013-12-17T00:02:27  0.720312 nmol kg⁻¹  2.31 μmol kg⁻¹  0.482927 nmol kg⁻¹
                                                                                                                  5509 rows omitted
```

### Arranging observations in transects

If you want the GEOTRACES data organized into cruise transects and profiles, this is supported under the hood by the [OceanographyCruises.jl](https://github.com/briochemc/OceanographyCruises.jl) package, so that you can do

```julia
julia> Cd = GEOTRACES.transects("Cd")
Transects of Cd
(Cruises GA02, GA03, GA04, GA10, GA11, GI04, GIPY01, GIPY02, GIPY04, GIPY05, GIPY06, GIPY13, GP02, GP13, GP16, GP18, GPpr01, GPpr02, and GPpr07.)
```

to access all the transects that have Cadmium concentrations, and explore the data transect by transect, you can append `.transects` and chose a cruise, e.g.,

```julia
julia> Cd_GA02 = Cd.transects[1]
Transect of Cd
Cruise GA02
┌─────────┬─────────────────────┬──────────┬─────────┐
│ Station │                Date │      Lat │     Lon │
├─────────┼─────────────────────┼──────────┼─────────┤
│     001 │ 2011-03-05T19:28:00 │ -49.5472 │ 307.312 │
│     002 │ 2010-05-02T19:36:57 │  64.0001 │  325.75 │
│     002 │ 2011-03-06T23:17:05 │ -48.8942 │ 311.265 │
│     003 │ 2011-03-08T01:17:59 │   -46.92 │   312.8 │
│     003 │ 2010-05-03T21:30:00 │  62.3451 │ 324.002 │
│     004 │ 2011-03-09T01:31:59 │ -44.7068 │ 314.464 │
│     005 │ 2011-03-10T00:58:29 │ -42.3713 │ 315.974 │
│    ⋮    │          ⋮          │    ⋮     │    ⋮    │
└─────────┴─────────────────────┴──────────┴─────────┘
                                       48 rows omitted
```

which contains all the profiles of the GA02 cruise. You can further explore profiles by appending `.profiles` and selecting a profile, e.g.,

```julia
julia> Cd_GA02_profile1 = Cd_GA02.profiles[1]
Depth profile at Station 001 2011-03-05T19:28:00 (49.5S, 307.3E)
┌───────┬───────────────────┐
│ Depth │ Value [nmol kg⁻¹] │
├───────┼───────────────────┤
│  10.0 │            0.0528 │
│  25.0 │            0.0697 │
│  51.0 │            0.1557 │
│  74.0 │            0.3743 │
│ 100.0 │            0.4684 │
│ 151.0 │            0.5047 │
│ 200.0 │             0.533 │
│   ⋮   │         ⋮         │
└───────┴───────────────────┘
              17 rows omitted
```

Finally, you can access the vectors of concentration values (with units!) and depths by appending `.values` and `.depths`:

```julia
julia> Cd_GA02_profile1.values
24-element Vector{Unitful.Quantity{Float32, 𝐍 𝐌⁻¹, Unitful.FreeUnits{(kg⁻¹, nmol), 𝐍 𝐌⁻¹, nothing}}}:
 0.0528f0 nmol kg⁻¹
 0.0697f0 nmol kg⁻¹
 0.1557f0 nmol kg⁻¹
                  ⋮
 0.6946f0 nmol kg⁻¹
 0.6997f0 nmol kg⁻¹
 0.7067f0 nmol kg⁻¹

julia> Cd_GA02_profile1.depths
24-element Vector{Float64}:
   10.0
   25.0
   51.0
    ⋮
 2123.0
 2248.0
 2312.0
```

> Note that [OceanographyCruises.jl](https://github.com/briochemc/OceanographyCruises.jl) will likely undergo breaking changes soon to also leverage the tabular data functionality of DataFrames.jl. So this part of the API for GEOTRACES.jl may change accordingly.

I hope you find this tool useful! Suggestions and PRs welcome!
