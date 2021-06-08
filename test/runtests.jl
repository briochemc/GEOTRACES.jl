# First, generate mock data
include("generate_mockdata.jl")

# Then, run tests on mock data
using Test
using GEOTRACES
using Unitful
using OceanographyCruises
using DataFrames


#@testset "Test dummy cruise" begin
#    ct = dummy_cruise_track()
#    @test ct isa CruiseTrack{Float64,DateTime}
#    @test ct.name isa String
#    @test ct.name == "Dummy Cruise Track"
#    @test ct.lon isa Vector{Float64}
#    @test ct.lat isa Vector{Float64}
#    @test ct.date isa Vector{DateTime}
#end

@testset "Cruises" begin
    @test unique(GEOTRACES.list_of_cruises()) == ["GA01", "GA02", "GA03", "GA04", "GA06", "GA10", "GA11", "GAc01", "GAc02", "GI04", "GIPY01", "GIPY02", "GIPY04", "GIPY05", "GIPY06", "GIPY11", "GIPY13", "GIpr01", "GP02", "GP13", "GP16", "GP18", "GPc01", "GPc02", "GPc03", "GPpr01", "GPpr02", "GPpr04", "GPpr05", "GPpr07", "GPpr10"]
    @test GEOTRACES.list_of_stations() isa Vector{String}
    @test GEOTRACES.cruisetrack("GAO03") isa CruiseTrack
end

@testset "observations" begin
    @testset "$var" for var in ["Cd", "PO₄", "δCd", "Fe"]
        x = GEOTRACES.observations(var)
        @test x isa DataFrame
        @test getproperty(x, var) isa Vector{<:Quantity}
        x_QC = GEOTRACES.qualitycontrols(var)
        @test x_QC isa Vector{Int}
    end
    @testset "($var1, $var2)" for (var1, var2) in zip(["Cd", "PO₄"], ["δCd", "Fe"])
        x = GEOTRACES.observations(var1, var2)
        @test x isa DataFrame
        @test getproperty(x, var1) isa Vector{<:Quantity}
        @test getproperty(x, var2) isa Vector{<:Quantity}
        x_QC, y_QC = GEOTRACES.qualitycontrols(var1, var2)
        @test x_QC isa Vector{Int}
        @test y_QC isa Vector{Int}
        @test length(x_QC) == length(y_QC)
    end
end

@testset "transects" begin
    @testset "$var" for var in ["Cd", "PO₄", "δCd", "Fe"]
        x = GEOTRACES.transects(var)
        @test x isa Transects
        x = GEOTRACES.transect(var; cruise="GA02")
        @test x isa Transect
    end
    @testset "($var1, $var2)" for (var1, var2) in zip(["Cd", "PO₄"], ["δCd", "Fe"])
        obs = GEOTRACES.observations(var1, var2)
        x = GEOTRACES.transects(obs, var1)
        y = GEOTRACES.transects(obs, var2)
        @test x isa Transects
        @test y isa Transects
    end
end

@testset "helper functions" begin
    @test GEOTRACES.matchingvariables("cd") isa Vector{Pair{String, String}}
    @testset "variable names" begin
        @test GEOTRACES.varname("T") == "var7"
        @test GEOTRACES.varname("salinity") == "var8"
        @test GEOTRACES.varname("He") == "var14"
        @test GEOTRACES.varname("O2") == "var19"
        @test GEOTRACES.varname("P") == "var21"
        @test GEOTRACES.varname("NO3") == "var23"
        @test GEOTRACES.varname("Si") == "var24"
        @test GEOTRACES.varname("Cd") == "var70"
        @test GEOTRACES.varname("δCd") == "var116"
        @test GEOTRACES.varname("Fe") == "var73"
        @test GEOTRACES.varname("δFe") == "var117"
        @test GEOTRACES.varname("Ni") == "var83"
        @test GEOTRACES.varname("Nd") == "var94"
        @test GEOTRACES.varname("eNd") == "var105"
        @test GEOTRACES.varname("εNd") == "var105"
    end
end
