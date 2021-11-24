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
> In order to use this software, you must first download the GEOTRACES IDP21 data as a NetCDF file.
>
> You must place it in a `Data` directory in your local "home" directory.
> For example, on OSX, the path of my GEOTRACES NetCDF file is:
>
> ```
> $HOME/Data/GEOTRACES/GEOTRACES_IDP2021_v1/seawater/netcdf/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1.nc
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
10118×7 DataFrame
   Row │ lat      lon      depth      cruise  station  date                 Cd
       │ Float32  Float32  Quantity…  String  String   DateTime…            Quantity…
───────┼───────────────────────────────────────────────────────────────────────────────────────
     1 │ -50.594  308.359     10.0 m  GA02    1        2011-03-05T19:50:30   0.05282 nmol kg⁻¹
     2 │ -50.594  308.359     25.0 m  GA02    1        2011-03-05T19:50:30   0.06973 nmol kg⁻¹
     3 │ -50.594  308.359     51.0 m  GA02    1        2011-03-05T19:50:30   0.15567 nmol kg⁻¹
   ⋮   │    ⋮        ⋮         ⋮        ⋮        ⋮              ⋮                   ⋮
 10116 │ -44.119  146.221    740.7 m  GS01    (2)      2018-01-11T15:24:00  0.509746 nmol kg⁻¹
 10117 │ -44.119  146.221    887.9 m  GS01    (2)      2018-01-11T15:24:00  0.649988 nmol kg⁻¹
 10118 │ -44.119  146.221    939.2 m  GS01    (2)      2018-01-11T15:24:00  0.686353 nmol kg⁻¹
                                                                             10112 rows omitted
```

### Variable names made easy (with your help!)

Most GEOTRACES variable names are not very explicit (e.g., `var70` for cadmium).
For this reason, GEOTRACES.jl provides shortcut names for common tracers/variables, like "Cd" for cadmium.
To check which variable they correspond to, you can do (sticking with cadmium as an example)

```julia
julia> GEOTRACES.variable("Cd")
var85 (698 × 3149)
  Datatype:    Float32
  Dimensions:  N_SAMPLES × N_STATIONS
  Attributes:
   long_name            = Cd_D_CONC_BOTTLE
   units                = nmol/kg
   comment              = Concentration of dissolved Cd
   ancillary_variables  = var85_qc var85_err
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
41-element Vector{Pair{String, String}}:
    "var165" => "Ni_60_58_D_DELTA_FISH"
    "var401" => "Ni_SPT_CONC_PUMP"
    "var351" => "Ni_TP_CONC_BOTTLE"
             ⋮
 "var402_qc" => "Quality flag of Ni_SPL_CONC_PUMP"
    "var402" => "Ni_SPL_CONC_PUMP"
 "var435_qc" => "Quality flag of Ni_TP_CONC_FISH"
```

### Joining tracers

Sometimes, you want to extract data for two or more tracers but *only where/when these are observed simultaneously*. GEOTRACES does the filtering for you if you ask for them in the same call, thanks to the `innerjoin` function from [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl):

```julia
julia> obs = GEOTRACES.observations("Cd", "PO₄", "DFe") # Cd, PO₄, and DFe obs with units
6097×9 DataFrame
  Row │ lat       lon      depth      cruise  station  date                 Cd                  PO₄                DFe
      │ Float32   Float32  Quantity…  String  String   DateTime…            Quantity…           Quantity…          Quantity…
──────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    1 │ -50.594   308.359     10.0 m  GA02    1        2011-03-05T19:50:30   0.05282 nmol kg⁻¹    1.012 μmol kg⁻¹      0.52 nmol kg⁻¹
    2 │ -50.594   308.359     10.0 m  GA02    1        2011-03-05T19:50:30   0.05282 nmol kg⁻¹    1.014 μmol kg⁻¹      0.52 nmol kg⁻¹
    3 │ -50.594   308.359     25.0 m  GA02    1        2011-03-05T19:50:30   0.06973 nmol kg⁻¹    2.367 μmol kg⁻¹      0.37 nmol kg⁻¹
  ⋮   │    ⋮         ⋮         ⋮        ⋮        ⋮              ⋮                   ⋮                   ⋮                  ⋮
 6095 │ -51.4577  148.524   1481.8 m  GPpr11  (25)     2016-04-11T03:50:00     0.821 nmol kg⁻¹    2.458 μmol kg⁻¹     0.439 nmol kg⁻¹
 6096 │ -65.4472  139.851    295.8 m  GS01    (54)     2018-01-31T19:26:44  0.861593 nmol kg⁻¹  2.22555 μmol kg⁻¹  0.262196 nmol kg⁻¹
 6097 │ -63.4987  150.0     3435.7 m  GS01    (69)     2018-02-05T12:30:02  0.809597 nmol kg⁻¹  2.27572 μmol kg⁻¹  0.292817 nmol kg⁻¹
                                                                                                                     6091 rows omitted
```

### Arranging observations in transects

If you want the GEOTRACES data organized into cruise transects and profiles, this is supported under the hood by the [OceanographyCruises.jl](https://github.com/briochemc/OceanographyCruises.jl) package, so that you can do

```julia
julia> Cd = GEOTRACES.transects("Cd")
Transects of Cd
(Cruises GA02, GA03, GA04N, GA10, GA11, GI04, GIPY01, GIPY02, GIPY04, GIPY05, GIPY06, GIPY13, GIpr05, GN01, GN02, GN03, GN04, GP02, GP13, GP16, GP18, GP19, GPc03, GPc06, GPpr01, GPpr02, GPpr07, GPpr08, GPpr11, and GS01.)
```

to access all the transects that have Cadmium concentrations, and explore the data transect by transect, you can append `.transects` and chose a cruise, e.g.,

```julia
julia> Cd_GA02 = Cd.transects[1]
Transect of Cd
Cruise GA02
┌─────────┬─────────────────────┬──────────┬─────────┐
│ Station │                Date │      Lat │     Lon │
├─────────┼─────────────────────┼──────────┼─────────┤
│       1 │ 2011-03-05T19:50:30 │  -50.594 │ 308.359 │
│       2 │ 2010-05-02T22:44:44 │  64.0002 │  325.75 │
│       2 │ 2011-03-06T23:27:34 │ -48.9071 │ 311.244 │
│       3 │ 2010-05-03T22:27:44 │  62.3452 │ 324.002 │
│       3 │ 2011-03-08T01:53:49 │ -46.9243 │ 312.793 │
│       3 │ 2012-08-03T14:29:29 │  57.2111 │ 318.401 │
│       4 │ 2011-03-09T01:55:29 │ -44.7052 │ 314.461 │
│    ⋮    │          ⋮          │    ⋮     │    ⋮    │
└─────────┴─────────────────────┴──────────┴─────────┘
                                       53 rows omitted
```

which contains all the profiles of the GA02 cruise. You can further explore profiles by appending `.profiles` and selecting a profile, e.g.,

```julia
julia> Cd_GA02_profile1 = Cd_GA02.profiles[1]
Depth profile at Station 1 2011-03-05T19:50:30 (50.6S, 308.4E)
┌───────┬───────────────────┐
│ Depth │ Value [nmol kg⁻¹] │
├───────┼───────────────────┤
│  10.0 │           0.05282 │
│  25.0 │           0.06973 │
│  51.0 │           0.15567 │
│  74.0 │           0.37431 │
│ 100.0 │           0.46844 │
│ 151.0 │           0.50468 │
│ 200.0 │           0.53303 │
│   ⋮   │         ⋮         │
└───────┴───────────────────┘
              17 rows omitted
```

Finally, you can access the vectors of concentration values (with units!) and depths by appending `.values` and `.depths`:

```julia
julia> Cd_GA02_profile1.values
24-element Vector{Unitful.Quantity{Float32, 𝐍 𝐌⁻¹, Unitful.FreeUnits{(kg⁻¹, nmol), 𝐍 𝐌⁻¹, nothing}}}:
 0.05282f0 nmol kg⁻¹
 0.06973f0 nmol kg⁻¹
 0.15567f0 nmol kg⁻¹
                   ⋮
 0.69459f0 nmol kg⁻¹
 0.69974f0 nmol kg⁻¹
 0.70673f0 nmol kg⁻¹

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

> Note I will simply move the functionality of [OceanographyCruises.jl](https://github.com/briochemc/OceanographyCruises.jl) (e.g., finding a transect "cruise track" using a salesman-problem algorithm) into GEOTRACES and apply functions directly to the dataframe returned by `observations`.

I hope you find this tool useful! Suggestions and PRs welcome!
