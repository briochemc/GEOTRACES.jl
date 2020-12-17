using NCDatasets

using Random
rng = MersenneTwister(1234)

# Create mock data in a temporary directory
mockdir = mktempdir(homedir())
mockdata_path = joinpath(mockdir, "GEOTRACES_mockdata.nc")
ENV["GEOTRACES_IDP17_PATH"] = mockdata_path 

ds = Dataset(mockdata_path, "c")

# The following was generated using something like below
# (Giving up on making this reproducible because of GEOTRACES own agreements/rules.)
#=
mockdir = mktempdir(homedir())
ncfile = GEOTRACES.GEOTRACES_IDP17_DiscreteSamples_path()
ncgen(ncfile, joinpath(mockdir, "mockdata.jl"))
=#

# Dimensions

ds.dim["N_STATIONS"] = 1866
ds.dim["N_SAMPLES"] = 698
ds.dim["STRING6"] = 6
ds.dim["STRING20"] = 20

# Declare variables
# _FillValue modified by BP from "" to '\0'

ncmetavar1 = defVar(ds,"metavar1", Char, ("STRING6", "N_STATIONS"))
ncmetavar1.attrib["long_name"] = "Cruise"
ncmetavar1.attrib["_FillValue"] = '\0'

ncmetavar2 = defVar(ds,"metavar2", Char, ("STRING20", "N_STATIONS"))
ncmetavar2.attrib["long_name"] = "Station"
ncmetavar2.attrib["_FillValue"] = '\0'

nclongitude = defVar(ds,"longitude", Float32, ("N_STATIONS",))
nclongitude.attrib["long_name"] = "Longitude"
nclongitude.attrib["units"] = "degrees_east"
nclongitude.attrib["C_format"] = "%.3f"
nclongitude.attrib["FORTRAN_format"] = "F12.3"
nclongitude.attrib["_FillValue"] = Float32(-1.0e10)

nclatitude = defVar(ds,"latitude", Float32, ("N_STATIONS",))
nclatitude.attrib["long_name"] = "Latitude"
nclatitude.attrib["units"] = "degrees_north"
nclatitude.attrib["C_format"] = "%.3f"
nclatitude.attrib["FORTRAN_format"] = "F12.3"
nclatitude.attrib["_FillValue"] = Float32(-1.0e10)

ncdate_time = defVar(ds,"date_time", Float64, ("N_STATIONS",))
ncdate_time.attrib["long_name"] = "Decimal Gregorian Days of the station"
ncdate_time.attrib["units"] = "days since 0006-01-01 00:00:00 UTC"
ncdate_time.attrib["comment"] = "Relative Gregorian Days with decimal part"
ncdate_time.attrib["C_format"] = "%.5f"
ncdate_time.attrib["FORTRAN_format"] = "F12.5"
ncdate_time.attrib["_FillValue"] = -1.0e10
ncdate_time.attrib["calendar"] = "proleptic_gregorian"

ncvar1 = defVar(ds,"var1", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar1.attrib["long_name"] = "PRESSURE"
ncvar1.attrib["units"] = "dbar"
ncvar1.attrib["comment"] = "Sample/sensor pressure"
ncvar1.attrib["C_format"] = "%.1f"
ncvar1.attrib["FORTRAN_format"] = "F12.1"
ncvar1.attrib["_FillValue"] = Float32(-1.0e10)

ncvar1_QC = defVar(ds,"var1_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar1_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar1_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar1_QC.attrib["_FillValue"] = '9'

ncvar2 = defVar(ds,"var2", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar2.attrib["long_name"] = "DEPTH"
ncvar2.attrib["units"] = "m"
ncvar2.attrib["comment"] = "Sample/sensor depth"
ncvar2.attrib["C_format"] = "%.1f"
ncvar2.attrib["FORTRAN_format"] = "F12.1"
ncvar2.attrib["_FillValue"] = Float32(-1.0e10)

ncvar2_QC = defVar(ds,"var2_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar2_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar2_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar2_QC.attrib["_FillValue"] = '9'



ncvar7 = defVar(ds,"var7", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar7.attrib["long_name"] = "CTDTMP"
ncvar7.attrib["units"] = "deg C"
ncvar7.attrib["comment"] = "Temperature from CTD sensor in the ITS-90 convention"
ncvar7.attrib["C_format"] = "%.2f"
ncvar7.attrib["FORTRAN_format"] = "F12.2"
ncvar7.attrib["_FillValue"] = Float32(-1.0e10)

ncvar7_QC = defVar(ds,"var7_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar7_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar7_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar7_QC.attrib["_FillValue"] = '9'

ncvar8 = defVar(ds,"var8", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar8.attrib["long_name"] = "CTDSAL"
ncvar8.attrib["comment"] = "Practical salinity from CTD sensor on the PSS-1978 scale"
ncvar8.attrib["C_format"] = "%.3f"
ncvar8.attrib["FORTRAN_format"] = "F12.3"
ncvar8.attrib["_FillValue"] = Float32(-1.0e10)

ncvar8_QC = defVar(ds,"var8_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar8_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar8_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar8_QC.attrib["_FillValue"] = '9'

ncvar14 = defVar(ds,"var14", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar14.attrib["long_name"] = "He_D_CONC_BOTTLE"
ncvar14.attrib["units"] = "nmol/kg"
ncvar14.attrib["comment"] = "Concentration of dissolved Helium"
ncvar14.attrib["C_format"] = "%.3f"
ncvar14.attrib["FORTRAN_format"] = "F12.3"
ncvar14.attrib["_FillValue"] = Float32(-1.0e10)

ncvar14_QC = defVar(ds,"var14_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar14_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar14_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar14_QC.attrib["_FillValue"] = '9'

ncvar14_STD = defVar(ds,"var14_STD", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar14_STD.attrib["long_name"] = "Standard deviation of He_D_CONC_BOTTLE"
ncvar14_STD.attrib["units"] = "nmol/kg"
ncvar14_STD.attrib["comment"] = "Concentration of dissolved Helium"
ncvar14_STD.attrib["C_format"] = "%.3f"
ncvar14_STD.attrib["FORTRAN_format"] = "F12.3"
ncvar14_STD.attrib["_FillValue"] = Float32(-1.0e10)



ncvar19 = defVar(ds,"var19", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar19.attrib["long_name"] = "OXYGEN_D_CONC_BOTTLE"
ncvar19.attrib["units"] = "umol/kg"
ncvar19.attrib["comment"] = "Concentration of dissolved oxygen from a bottle sample"
ncvar19.attrib["C_format"] = "%.3f"
ncvar19.attrib["FORTRAN_format"] = "F12.3"
ncvar19.attrib["_FillValue"] = Float32(-1.0e10)

ncvar19_QC = defVar(ds,"var19_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar19_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar19_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar19_QC.attrib["_FillValue"] = '9'


ncvar21 = defVar(ds,"var21", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar21.attrib["long_name"] = "PHOSPHATE_D_CONC_BOTTLE"
ncvar21.attrib["units"] = "umol/kg"
ncvar21.attrib["comment"] = "Concentration of dissolved phosphate, samples may or may not have been filtered"
ncvar21.attrib["C_format"] = "%.3f"
ncvar21.attrib["FORTRAN_format"] = "F12.3"
ncvar21.attrib["_FillValue"] = Float32(-1.0e10)

ncvar21_QC = defVar(ds,"var21_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar21_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar21_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar21_QC.attrib["_FillValue"] = '9'


ncvar23 = defVar(ds,"var23", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar23.attrib["long_name"] = "SILICATE_D_CONC_BOTTLE"
ncvar23.attrib["units"] = "umol/kg"
ncvar23.attrib["comment"] = "Concentration of dissolved silicate, samples may or may not have been filtered"
ncvar23.attrib["C_format"] = "%.3f"
ncvar23.attrib["FORTRAN_format"] = "F12.3"
ncvar23.attrib["_FillValue"] = Float32(-1.0e10)

ncvar23_QC = defVar(ds,"var23_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar23_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar23_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar23_QC.attrib["_FillValue"] = '9'

ncvar23_STD = defVar(ds,"var23_STD", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar23_STD.attrib["long_name"] = "Standard deviation of SILICATE_D_CONC_BOTTLE"
ncvar23_STD.attrib["units"] = "umol/kg"
ncvar23_STD.attrib["comment"] = "Concentration of dissolved silicate, samples may or may not have been filtered"
ncvar23_STD.attrib["C_format"] = "%.3f"
ncvar23_STD.attrib["FORTRAN_format"] = "F12.3"
ncvar23_STD.attrib["_FillValue"] = Float32(-1.0e10)

ncvar24 = defVar(ds,"var24", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar24.attrib["long_name"] = "NITRATE_D_CONC_BOTTLE"
ncvar24.attrib["units"] = "umol/kg"
ncvar24.attrib["comment"] = "Concentration of dissolved NITRATE, samples may or may not have been filtered"
ncvar24.attrib["C_format"] = "%.3f"
ncvar24.attrib["FORTRAN_format"] = "F12.3"
ncvar24.attrib["_FillValue"] = Float32(-1.0e10)

ncvar24_QC = defVar(ds,"var24_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar24_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar24_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar24_QC.attrib["_FillValue"] = '9'

ncvar24_STD = defVar(ds,"var24_STD", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar24_STD.attrib["long_name"] = "Standard deviation of NITRATE_D_CONC_BOTTLE"
ncvar24_STD.attrib["units"] = "umol/kg"
ncvar24_STD.attrib["comment"] = "Concentration of dissolved NITRATE, samples may or may not have been filtered"
ncvar24_STD.attrib["C_format"] = "%.3f"
ncvar24_STD.attrib["FORTRAN_format"] = "F12.3"
ncvar24_STD.attrib["_FillValue"] = Float32(-1.0e10)


ncvar70 = defVar(ds,"var70", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar70.attrib["long_name"] = "Cd_D_CONC_BOTTLE"
ncvar70.attrib["units"] = "nmol/kg"
ncvar70.attrib["comment"] = "Concentration of dissolved Cd"
ncvar70.attrib["C_format"] = "%.3f"
ncvar70.attrib["FORTRAN_format"] = "F12.3"
ncvar70.attrib["_FillValue"] = Float32(-1.0e10)

ncvar70_QC = defVar(ds,"var70_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar70_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar70_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar70_QC.attrib["_FillValue"] = '9'

ncvar70_STD = defVar(ds,"var70_STD", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar70_STD.attrib["long_name"] = "Standard deviation of Cd_D_CONC_BOTTLE"
ncvar70_STD.attrib["units"] = "nmol/kg"
ncvar70_STD.attrib["comment"] = "Concentration of dissolved Cd"
ncvar70_STD.attrib["C_format"] = "%.3f"
ncvar70_STD.attrib["FORTRAN_format"] = "F12.3"
ncvar70_STD.attrib["_FillValue"] = Float32(-1.0e10)


ncvar73 = defVar(ds,"var73", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar73.attrib["long_name"] = "Fe_D_CONC_BOTTLE"
ncvar73.attrib["units"] = "nmol/kg"
ncvar73.attrib["comment"] = "Concentration of dissolved Fe"
ncvar73.attrib["C_format"] = "%.3f"
ncvar73.attrib["FORTRAN_format"] = "F12.3"
ncvar73.attrib["_FillValue"] = Float32(-1.0e10)

ncvar73_QC = defVar(ds,"var73_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar73_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar73_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar73_QC.attrib["_FillValue"] = '9'

ncvar73_STD = defVar(ds,"var73_STD", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar73_STD.attrib["long_name"] = "Standard deviation of Fe_D_CONC_BOTTLE"
ncvar73_STD.attrib["units"] = "nmol/kg"
ncvar73_STD.attrib["comment"] = "Concentration of dissolved Fe"
ncvar73_STD.attrib["C_format"] = "%.3f"
ncvar73_STD.attrib["FORTRAN_format"] = "F12.3"
ncvar73_STD.attrib["_FillValue"] = Float32(-1.0e10)


ncvar83 = defVar(ds,"var83", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar83.attrib["long_name"] = "Ni_D_CONC_BOTTLE"
ncvar83.attrib["units"] = "nmol/kg"
ncvar83.attrib["comment"] = "Concentration of dissolved Ni"
ncvar83.attrib["C_format"] = "%.3f"
ncvar83.attrib["FORTRAN_format"] = "F12.3"
ncvar83.attrib["_FillValue"] = Float32(-1.0e10)

ncvar83_QC = defVar(ds,"var83_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar83_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar83_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar83_QC.attrib["_FillValue"] = '9'

ncvar83_STD = defVar(ds,"var83_STD", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar83_STD.attrib["long_name"] = "Standard deviation of Ni_D_CONC_BOTTLE"
ncvar83_STD.attrib["units"] = "nmol/kg"
ncvar83_STD.attrib["comment"] = "Concentration of dissolved Ni"
ncvar83_STD.attrib["C_format"] = "%.3f"
ncvar83_STD.attrib["FORTRAN_format"] = "F12.3"
ncvar83_STD.attrib["_FillValue"] = Float32(-1.0e10)


ncvar116 = defVar(ds,"var116", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar116.attrib["long_name"] = "Cd_114_110_D_DELTA_BOTTLE"
ncvar116.attrib["units"] = "per mil"
ncvar116.attrib["comment"] = "Atom ratio of dissolved Cd isotopes expressed in conventional DELTA notation referenced to {NIST3108}"
ncvar116.attrib["C_format"] = "%.3f"
ncvar116.attrib["FORTRAN_format"] = "F12.3"
ncvar116.attrib["_FillValue"] = Float32(-1.0e10)

ncvar116_QC = defVar(ds,"var116_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar116_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar116_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar116_QC.attrib["_FillValue"] = '9'

ncvar116_STD = defVar(ds,"var116_STD", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar116_STD.attrib["long_name"] = "Standard deviation of Cd_114_110_D_DELTA_BOTTLE"
ncvar116_STD.attrib["units"] = "per mil"
ncvar116_STD.attrib["comment"] = "Atom ratio of dissolved Cd isotopes expressed in conventional DELTA notation referenced to {NIST3108}"
ncvar116_STD.attrib["C_format"] = "%.3f"
ncvar116_STD.attrib["FORTRAN_format"] = "F12.3"
ncvar116_STD.attrib["_FillValue"] = Float32(-1.0e10)

ncvar117 = defVar(ds,"var117", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar117.attrib["long_name"] = "Fe_56_54_D_DELTA_BOTTLE"
ncvar117.attrib["units"] = "per mil"
ncvar117.attrib["comment"] = "Atom ratio of dissolved Fe isotopes expressed in conventional DELTA notation referenced to {IRMM-14}"
ncvar117.attrib["C_format"] = "%.3f"
ncvar117.attrib["FORTRAN_format"] = "F12.3"
ncvar117.attrib["_FillValue"] = Float32(-1.0e10)

ncvar117_QC = defVar(ds,"var117_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar117_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar117_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar117_QC.attrib["_FillValue"] = '9'

ncvar117_STD = defVar(ds,"var117_STD", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar117_STD.attrib["long_name"] = "Standard deviation of Fe_56_54_D_DELTA_BOTTLE"
ncvar117_STD.attrib["units"] = "per mil"
ncvar117_STD.attrib["comment"] = "Atom ratio of dissolved Fe isotopes expressed in conventional DELTA notation referenced to {IRMM-14}"
ncvar117_STD.attrib["C_format"] = "%.3f"
ncvar117_STD.attrib["FORTRAN_format"] = "F12.3"
ncvar117_STD.attrib["_FillValue"] = Float32(-1.0e10)


# Global attributes

ds.attrib["Conventions"] = "ODV NetCDF Export File"
ds.attrib["Version"] = "V1.0"
ds.attrib["Creator"] = "rschlitz@BGEO04P020"
ds.attrib["CreateTime"] = "2018-02-11T10:14:37"
ds.attrib["Software"] = "Ocean Data View 5.0.0 - 64 bit (Windows)"
ds.attrib["Source"] = "C:/GEOTRACES/IDP2017/digital_data/GEOTRACES_IDP2017_v2/discrete_sample_data/odv/GEOTRACES_IDP2017_v2_Discrete_Sample_Data.odv"
ds.attrib["SourceLastModified"] = "2018-02-05T20:34:22"
ds.attrib["DataField"] = "GeneralField"
ds.attrib["DataType"] = "GeneralType"

ds.attrib["AdditionnalComment"] = "This is a mock dataset for CI of GEOTRACES.jl"

# Define variables

# metavars \
# Recreate cruises
ranges = [1:79, 80:302, 303:389, 390:480, 481:716, 717:899, 900:922, 923:949, 950:956, 957:967, 968:1017, 1018:1041, 1042:1120, 1121:1282, 1283:1355, 1356:1480, 1481:1544, 1545:1581, 1582:1603, 1604:1672, 1673:1737, 1738:1755, 1756:1762, 1763:1773, 1774:1788, 1789:1815, 1816:1831, 1832:1845, 1846:1851, 1852:1865, 1866:1866]
cruises = ["GA01", "GA02", "GA03", "GA04", "GA06", "GA10", "GA11", "GAc01", "GAc02", "GI04", "GIPY01", "GIPY02", "GIPY04", "GIPY05", "GIPY06", "GIPY11", "GIPY13", "GIpr01", "GP02", "GP13", "GP16", "GP18", "GPc01", "GPc02", "GPc03", "GPpr01", "GPpr02", "GPpr04", "GPpr05", "GPpr07", "GPpr10"]
for (c, r) in zip(cruises, ranges), i in 1:6
    ncmetavar1[i,r] = string(c, repeat('\0', 6-length(c)))[i]
end
# Fake station names going from 1 to 1866
for i in 1:1866
    s = string(i)
    for j in 1:20
        ncmetavar2[j,i] = j≤length(s) ? s[j] : '\0'
    end
end
# depth indices where there is pressure (~4% of the data) (could not used depth as one of them profiles is weird)
idx = [
       23, 239, 47, 23, 47, 23, 23, 23, 23, 23, 23, 71, 23, 239, 23, 71, 23, 71, 23, 71, 23, 263, 23, 71, 23, 71, 141, 23, 23, 69, 23, 23, 287, 23, 71, 23, 71, 23, 287, 23, 71, 23, 71, 23, 239, 23, 23, 23, 23, 71, 23, 23, 23, 71, 12, 13, 47, 23, 23, 23, 167, 95, 23, 71, 187, 23, 23, 23, 71, 261, 23, 71, 23, 23, 23, 23, 23, 237, 71, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 47, 23, 108, 98, 47, 47, 47, 47, 47,
       52, 74, 68, 47, 51, 49, 47, 47, 47, 95, 68, 74, 47, 47, 53, 50, 23, 47, 119, 68, 47, 47, 74, 47, 47, 47, 47, 101, 47, 49, 47, 47, 47, 47, 47, 47, 125, 47, 47, 47, 47, 47, 119, 47, 47, 47, 47, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 38, 134, 0, 100, 37, 175, 0, 101, 52, 37, 101, 124, 174, 37, 37, 100, 0, 172, 100, 0, 36, 0, 218, 100, 101, 101, 98, 121, 36, 36, 0, 37, 12, 36, 0, 0, 196, 100, 0, 145, 36, 0, 1, 169, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 49, 71, 47, 27, 72, 6, 47, 71, 47, 11, 47, 46, 7, 71, 47, 50, 72, 21, 47, 47, 7, 47, 71, 27, 1, 47, 71, 23, 47, 71, 47, 19, 71, 23, 47, 1, 72, 19, 18, 47,
       42, 23, 46, 6, 47, 48, 47, 47, 23, 59, 47, 44, 23, 46, 47, 46, 51, 18, 46, 47, 47, 26, 48, 24, 25, 14, 47, 47, 23, 47, 35, 35, 36, 35, 23, 15, 3, 11, 17, 17, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 38, 35, 28, 11, 47, 47, 12, 1, 23, 47, 71, 23, 23, 47, 47, 47, 46, 47, 47, 47, 47, 47, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 71, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 71, 24, 0, 0, 0, 0, 0, 0, 2, 96, 95, 0, 0, 0, 0, 0, 0, 0, 0, 0, 23, 0, 0, 23, 0, 0, 47, 71, 0, 0, 0, 0, 23, 0, 0, 71, 0, 0, 0, 0, 47, 0, 0, 0, 71, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 0, 0, 23, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 47, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 35, 0, 29, 71, 23, 23, 23, 24, 71, 37, 85, 89, 71, 71, 71,
       0, 0, 0, 0, 71, 23, 51, 95, 71, 143, 92, 41, 29, 71, 71, 70, 71, 101, 56, 104, 100, 52, 79, 154, 23, 116, 132, 76, 22, 133, 0, 0, 0, 0, 0, 0, 21, 9, 21, 21, 21, 10, 21, 10, 19, 21, 21, 10, 24, 10, 21, 10, 21, 10, 10, 8, 10, 10, 7, 10, 21, 10, 21, 0, 5, 0, 0, 5, 0, 5, 22, 22, 25, 28, 12, 12, 26, 27, 30, 22, 20, 14, 23, 30, 23, 23, 24, 22, 35, 23, 23, 21, 23, 29, 23, 15, 23, 23, 23, 15, 35, 23, 23, 23, 23, 35, 23, 15, 35, 23, 23, 27, 23, 23, 23, 14, 35, 23, 23, 23, 23, 17, 35, 23, 23, 23, 23, 18, 35, 23, 17, 47, 88, 23, 697, 63, 579, 23, 23, 88, 88, 23, 88, 23, 23, 23, 23, 505, 23, 33, 63, 71, 47, 64, 88, 21, 13, 13, 12, 14, 18, 20, 21, 21, 21, 21, 53, 21, 21, 21, 20, 21,
       21, 149, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 53, 21, 21, 158, 21, 21, 21, 21, 21, 21, 74, 21, 21, 53, 21, 21, 21, 160, 21, 21, 21, 75, 21, 21, 21, 21, 53, 23, 21, 21, 21, 160, 21, 21, 43, 21, 21, 21, 21, 18, 18, 75, 21, 21, 21, 21, 21, 164, 23, 0, 45, 94, 43, 23, 116, 2, 21, 23, 42, 1, 23, 0, 21, 113, 1, 21, 23, 2, 21, 23, 1, 43, 23, 1, 21, 21, 1, 21, 23, 1, 21, 138, 21, 2, 21, 23, 1, 21, 23, 1, 21, 45, 1, 21, 23, 0, 21, 23, 0, 21, 45, 1, 21, 1, 22, 21, 1, 65, 21, 21, 0, 97, 0, 23, 0, 21, 0, 45, 0, 21, 0, 21, 0, 21, 21, 45, 21, 140, 21, 21, 21, 21, 0, 21, 43, 23, 21, 21, 21, 45, 21, 162, 21, 21, 21, 21, 0, 67, 21, 0, 21, 21, 45, 45, 21, 0, 21, 21, 21, 21, 69,
       21, 45, 21, 21, 21, 69, 21, 21, 17, 21, 45, 53, 45, 0, 18, 14, 44, 21, 21, 21, 96, 0, 21, 21, 21, 21, 21, 96, 21, 45, 21, 21, 140, 21, 21, 143, 21, 21, 21, 23, 144, 45, 32, 14, 17, 20, 21, 20, 0, 23, 23, 23, 35, 23, 23, 35, 23, 23, 23, 35, 23, 23, 30, 21, 23, 30, 23, 30, 23, 23, 32, 23, 32, 23, 23, 32, 23, 32, 23, 23, 32, 23, 32, 23, 32, 23, 23, 32, 23, 32, 23, 23, 32, 23, 23, 23, 32, 23, 23, 32, 23, 23, 32, 23, 23, 32, 23, 32, 23, 23, 32, 23, 23, 32, 23, 32, 23, 32, 23, 32, 23, 32, 47, 48, 10, 9, 10, 23, 11, 10, 8, 91, 69, 9, 62, 16, 24, 48, 23, 23, 97, 23, 25, 24, 121, 25, 24, 25, 96, 23, 25, 16, 25, 24, 24, 20, 12, 97, 24, 23, 135, 13, 11, 11, 18, 15, 25, 12, 15, 23, 17, 24, 23, 21, 20, 24, 25, 21, 23, 23, 24, 22, 121, 23, 24, 22, 25, 23, 23, 121, 48, 24, 20, 24, 15, 23, 19, 18, 24, 23,
       24, 169, 23, 25, 24, 73, 22, 121, 20, 20, 49, 20, 71, 25, 23, 48, 15, 16, 25, 23, 24, 23, 23, 25, 23, 24, 25, 23, 94, 20, 23, 24, 21, 17, 22, 121, 23, 23, 10, 7, 8, 9, 73, 7, 24, 7, 87, 2, 5, 8, 7, 6, 5, 6, 4, 4, 4, 5, 3, 3, 3, 2, 3, 4, 3, 3, 4, 2, 3, 2, 3, 4, 5, 4, 4, 4, 3, 2, 7, 6, 6, 5, 3, 3, 5, 3, 3, 4, 3, 3, 3, 3, 3, 1, 3, 7, 4, 1, 4, 0, 1, 3, 2, 3, 2, 0, 0, 2, 2, 0, 2, 21, 65, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 131, 263, 35, 21, 87, 21, 21, 21, 21, 21, 43, 153, 263, 21, 153, 21, 20, 241, 153, 263, 21, 175, 21, 21, 8, 7, 47, 40, 46, 53, 51, 64, 48, 59, 43, 52, 57, 58, 42, 32, 24, 40, 24, 24, 24, 9, 32, 28, 30, 8, 26, 29, 16, 28, 25, 20, 26, 29, 42, 28, 29, 28, 27, 28, 16, 28, 44, 20, 28, 29, 28, 32, 17, 28, 20, 31, 28, 32, 26, 32, 32, 26, 20, 44, 11, 11, 11, 11, 11, 11, 23, 15, 58, 43, 81, 59, 58, 35, 59, 79, 64,
       56, 58, 59, 47, 58, 89, 58, 58, 55, 90, 58, 81, 43, 96, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 234, 70, 59, 80, 97, 37, 146, 37, 142, 37, 215, 37, 143, 37, 168, 37, 137, 239, 11, 137, 137, 37, 143, 37, 136, 216, 37, 137, 37, 144, 37, 142, 37, 86, 37, 230, 30, 33, 72, 81, 36, 36, 36, 70, 33, 78, 36, 74, 75, 32, 36, 36, 25, 25, 11, 11, 16, 17, 11, 11, 11, 7, 6, 7, 5, 6, 0, 5, 6, 7, 6, 3, 38, 28, 47, 13, 10, 11, 41, 37, 19, 36, 35, 34, 12, 33, 12, 0, 11, 0, 0, 5, 0, 0, 0, 0, 1, 11, 1, 0, 0, 0, 2, 0, 0, 2, 0, 2, 0, 0, 11, 4, 0, 0, 26, 30, 29, 8, 11, 11, 11, 11, 11, 11, 11, 23, 9, 11, 11, 10, 11, 13, 0, 11, 0, 16, 0, 16, 13, 13, 15, 17, 14, 4, 2, 4, 10, 14, 4, 6, 22, 25, 19, 34, 10, 20, 10, 9, 19, 2, 2, 2, 2, 16, 11]
function myfill(v)
    out = fill(fillvalue(v.var), size(v)...)
    for i in eachindex(idx)
        out[1:idx[i], i] .= rand(rng, eltype(v.var), idx[i])
    end
    out
end
function myfill_QC(v)
    out = Array{Char,2}(undef, size(v)...)
    out .= '9'
    for i in eachindex(idx)
        out[1:idx[i], i] .= rand(rng, QC, idx[i])
    end
    out
end
# random lat lon date
nclongitude[:] = rand(eltype(nclongitude.var), size(nclongitude)...)
nclatitude[:] = rand(eltype(nclatitude.var), size(nclatitude)...)
ncdate_time[:] = rand(eltype(ncdate_time.var), size(ncdate_time)...)
# QC characters 1:5
QC = [s[1] for s in string.([1,2,3,4,5])]
# pressure
ncvar1[:] = rand(eltype(ncvar1.var), size(ncvar1)...)
ncvar1_QC[:] = rand(QC, size(ncvar1_QC)...)
# depth
ncvar2[:] = rand(eltype(ncvar2.var), size(ncvar2)...)
ncvar2_QC[:] = rand(QC, size(ncvar2_QC)...)
# temp
ncvar7[:] = rand(eltype(ncvar7.var), size(ncvar7)...)
ncvar7_QC[:] = rand(QC, size(ncvar7_QC)...)
# salinity
ncvar8[:] = rand(eltype(ncvar8.var), size(ncvar8)...)
ncvar8_QC[:] = rand(QC, size(ncvar8_QC)...)
# some tracers
for v in [ncvar14, ncvar14_STD, ncvar19, ncvar21, ncvar23, ncvar23_STD, ncvar24, ncvar24_STD, ncvar70, ncvar70_STD, ncvar73, ncvar73_STD, ncvar83, ncvar83_STD, ncvar116, ncvar116_STD, ncvar117, ncvar117_STD]
    v[:] = myfill(v)
end
for v in [ncvar14_QC, ncvar19_QC, ncvar21_QC, ncvar23_QC, ncvar24_QC, ncvar70_QC, ncvar73_QC, ncvar83_QC, ncvar116_QC, ncvar117_QC]
    v[:] = myfill_QC(v)
end

close(ds)
