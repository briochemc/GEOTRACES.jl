using NCDatasets

ds = Dataset("GEOTRACES_mockdata.nc","c")

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
ncvar1_QC.attrib["_FillValue"] = "9"

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
ncvar2_QC.attrib["_FillValue"] = "9"



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
ncvar7_QC.attrib["_FillValue"] = "9"

ncvar8 = defVar(ds,"var8", Float32, ("N_SAMPLES", "N_STATIONS"))
ncvar8.attrib["long_name"] = "CTDSAL"
ncvar8.attrib["comment"] = "Practical salinity from CTD sensor on the PSS-1978 scale"
ncvar8.attrib["C_format"] = "%.3f"
ncvar8.attrib["FORTRAN_format"] = "F12.3"
ncvar8.attrib["_FillValue"] = Float32(-1.0e10)

ncvar8_QC = defVar(ds,"var8_QC", Char, ("N_SAMPLES", "N_STATIONS"))
ncvar8_QC.attrib["Conventions"] = "IODE - IODE data quality codes"
ncvar8_QC.attrib["comment"] = "1: good quality, 2: not evaluated, not available or unknown quality, 3: questionable/suspect quality, 4: bad quality, 9: missing data"
ncvar8_QC.attrib["_FillValue"] = "9"

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
ncvar14_QC.attrib["_FillValue"] = "9"

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
ncvar19_QC.attrib["_FillValue"] = "9"


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
ncvar21_QC.attrib["_FillValue"] = "9"


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
ncvar23_QC.attrib["_FillValue"] = "9"

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
ncvar24_QC.attrib["_FillValue"] = "9"

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
ncvar70_QC.attrib["_FillValue"] = "9"

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
ncvar73_QC.attrib["_FillValue"] = "9"

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
ncvar83_QC.attrib["_FillValue"] = "9"

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
ncvar116_QC.attrib["_FillValue"] = "9"

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
ncvar117_QC.attrib["_FillValue"] = "9"

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
# random lat lon date
nclongitude[:] = rand(eltype(nclongitude.var), size(nclongitude)...)
nclatitude[:] = rand(eltype(nclatitude.var), size(nclatitude)...)
ncdate_time[:] = rand(eltype(ncdate_time.var), size(ncdate_time)...)
# QC characters 1:5
QC = [s[1] for s in string.(1:5)]
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
# He
ncvar14[:] = rand(eltype(ncvar14.var), size(ncvar14)...)
ncvar14_QC[:] = rand(QC, size(ncvar14_QC)...)
ncvar14_STD[:] = rand(eltype(ncvar14_STD.var), size(ncvar14_STD)...)
# O2
ncvar19[:] = rand(eltype(ncvar19.var), size(ncvar19)...)
ncvar19_QC[:] = rand(QC, size(ncvar19_QC)...)
# PO4
ncvar21[:] = rand(eltype(ncvar21.var), size(ncvar21)...)
ncvar21_QC[:] = rand(QC, size(ncvar21_QC)...)
# NO3
ncvar23[:] = rand(eltype(ncvar23.var), size(ncvar23)...)
ncvar23_QC[:] = rand(QC, size(ncvar23_QC)...)
ncvar23_STD[:] = rand(eltype(ncvar23_STD.var), size(ncvar23_STD)...)
# SiOH4
ncvar24[:] = rand(eltype(ncvar24.var), size(ncvar24)...)
ncvar24_QC[:] = rand(QC, size(ncvar24_QC)...)
ncvar24_STD[:] = rand(eltype(ncvar24_STD.var), size(ncvar24_STD)...)
# Cd
ncvar70[:] = rand(eltype(ncvar70.var), size(ncvar70)...)
ncvar70_QC[:] = rand(QC, size(ncvar70_QC)...)
ncvar70_STD[:] = rand(eltype(ncvar70_STD.var), size(ncvar70_STD)...)
# Fe
ncvar73[:] = rand(eltype(ncvar73.var), size(ncvar73)...)
ncvar73_QC[:] = rand(QC, size(ncvar73_QC)...)
ncvar73_STD[:] = rand(eltype(ncvar73_STD.var), size(ncvar73_STD)...)
# Ni
ncvar83[:] = rand(eltype(ncvar83.var), size(ncvar83)...)
ncvar83_QC[:] = rand(QC, size(ncvar83_QC)...)
ncvar83_STD[:] = rand(eltype(ncvar83_STD.var), size(ncvar83_STD)...)
# δCd
ncvar116[:] = rand(eltype(ncvar116.var), size(ncvar116)...)
ncvar116_QC[:] = rand(QC, size(ncvar116_QC)...)
ncvar116_STD[:] = rand(eltype(ncvar116_STD.var), size(ncvar116_STD)...)
# δFe
ncvar117[:] = rand(eltype(ncvar117.var), size(ncvar117)...)
ncvar117_QC[:] = rand(QC, size(ncvar117_QC)...)
ncvar117_STD[:] = rand(eltype(ncvar117_STD.var), size(ncvar117_STD)...)

 close(ds)
