

using Test, GEOTRACESTools

@testset "Test dummy cruise" begin
    ct = dummy_cruise_track()
    @test ct isa CruiseTrack{Float64,DateTime} 
    @test ct.name isa String 
    @test ct.name == "Dummy Cruise Track"
    @test ct.lon isa Vector{Float64} 
    @test ct.lat isa Vector{Float64} 
    @test ct.date isa Vector{DateTime} 
end
