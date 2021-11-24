using NCDatasets
using DataStructures

using Random
rng = MersenneTwister(1234)

# Create mock data in a temporary directory
mockdir = mktempdir(homedir())
mockdata_path = joinpath(mockdir, "GEOTRACES_mockdata.nc")
ENV["GEOTRACES_IDP21_PATH"] = mockdata_path

# The following was generated using something like below
# (Giving up on making this reproducible because of GEOTRACES own agreements/rules.)
#=
]dev GEOTRACES
]add NCDatasets
using GEOTRACES, NCDatasets
mockdir = mktempdir(homedir())
ncfile = GEOTRACES.GEOTRACES_IDP21_DiscreteSamples_path()
ncgen(ncfile, joinpath(mockdir, "mockdata.jl"))
=#

ds = NCDataset(mockdata_path, "c", attrib = OrderedDict(
    "Conventions"               => "CF-1.7",
    "comment"                   => "ODV NetCDF Export File V2.0",
    "Creator"                   => "rschlitz@BGEO04M097-1",
    "CreateTime"                => "2021-11-11T08:45:54",
    "Software"                  => "Ocean Data View 5.5.2 - 64 bit (Windows)",
    "source"                    => "C:/GEOTRACES/IDP2021/output/data/seawater/GEOTRACES_IDP2021_Seawater_Discrete_Sample_Data_v1.odv",
    "SourceLastModified"        => "2021-11-09T15:31:14",
    "DataField"                 => "Ocean",
    "DataType"                  => "Profiles",
    "Description"               => "GEOTRACES IDP2021 seawater discrete sample hydrographic and tracer data",
    "featureType"               => "profile",
    "AdditionnalComment"        => "This is a mock dataset for CI of GEOTRACES.jl"
))

# Dimensions

ds.dim["N_STATIONS"] = 3149
ds.dim["N_SAMPLES"] = 698
ds.dim["STRING26"] = 26
ds.dim["STRING6"] = 6
ds.dim["STRING20"] = 20
ds.dim["STRING23"] = 23
ds.dim["STRING13"] = 13
ds.dim["STRING25"] = 25
ds.dim["STRING75"] = 75
ds.dim["STRING31"] = 31
ds.dim["STRING77"] = 77
ds.dim["STRING7"] = 7
ds.dim["STRING4"] = 4
ds.dim["STRING12"] = 12
ds.dim["STRING22"] = 22
ds.dim["STRING56"] = 56
ds.dim["STRING36"] = 36
ds.dim["STRING10"] = 10

# Declare variables
# _FillValue modified by BP from "" to '\0'

ncmetavar1 = defVar(ds,"metavar1", Char, ("STRING6", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Cruise",
    "units"                     => "",
    "comment"                   => "",
))

ncmetavar2 = defVar(ds,"metavar2", Char, ("STRING26", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Station",
    "units"                     => "",
    "comment"                   => "",
))

nclongitude = defVar(ds,"longitude", Float32, ("N_STATIONS",), attrib = OrderedDict(
    "long_name"                 => "Longitude",
    "standard_name"             => "longitude",
    "units"                     => "degrees_east",
    "comment"                   => "",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

nclatitude = defVar(ds,"latitude", Float32, ("N_STATIONS",), attrib = OrderedDict(
    "long_name"                 => "Latitude",
    "standard_name"             => "latitude",
    "units"                     => "degrees_north",
    "comment"                   => "",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncdate_time = defVar(ds,"date_time", Float64, ("N_STATIONS",), attrib = OrderedDict(
    "long_name"                 => "Decimal Gregorian Days of the station",
    "standard_name"             => "time",
    "units"                     => "days since 2006-01-01 00:00:00 UTC",
    "comment"                   => "Relative Gregorian Days with decimal part",
    "C_format"                  => "%.5f",
    "FORTRAN_format"            => "F12.5",
    "_FillValue"                => -1.0e10,
))

ncvar1 = defVar(ds,"var1", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "CTDPRS_T_VALUE_SENSOR",
    "units"                     => "dbar",
    "comment"                   => "Pressure from CTD sensor",
    "ancillary_variables"       => "var1_qc",
    "C_format"                  => "%.0f",
    "FORTRAN_format"            => "F12.0",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar1_qc = defVar(ds,"var1_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of CTDPRS_T_VALUE_SENSOR",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar2 = defVar(ds,"var2", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "DEPTH",
    "units"                     => "m",
    "comment"                   => "Depth below sea surface calculated from pressure",
    "ancillary_variables"       => "var2_qc",
    "C_format"                  => "%.0f",
    "FORTRAN_format"            => "F12.0",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar2_qc = defVar(ds,"var2_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of DEPTH",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))


ncvar15 = defVar(ds,"var15", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "CTDTMP_T_VALUE_SENSOR",
    "units"                     => "deg C",
    "comment"                   => "Temperature from CTD sensor in the ITS-90 convention. Metadata must include make and model numbers and recent calibration information.",
    "ancillary_variables"       => "var15_qc var15_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar15_qc = defVar(ds,"var15_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of CTDTMP_T_VALUE_SENSOR",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar16 = defVar(ds,"var16", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "CTDSAL_D_CONC_SENSOR",
    "units"                     => "pss-78",
    "comment"                   => "Practical salinity from CTD sensor on the PSS-1978 scale. Metadata must include make and model numbers and recent calibration information.",
    "ancillary_variables"       => "var16_qc var16_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar16_qc = defVar(ds,"var16_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of CTDSAL_D_CONC_SENSOR",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))




ncvar22 = defVar(ds,"var22", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "He_D_CONC_BOTTLE",
    "units"                     => "nmol/kg",
    "comment"                   => "Concentration of dissolved Helium",
    "ancillary_variables"       => "var22_qc var22_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar22_qc = defVar(ds,"var22_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of He_D_CONC_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar22_err = defVar(ds,"var22_err", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Error of He_D_CONC_BOTTLE",
    "units"                     => "nmol/kg",
    "comment"                   => "Concentration of dissolved Helium",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))





ncvar35 = defVar(ds,"var35", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "OXYGEN_D_CONC_BOTTLE",
    "units"                     => "umol/kg",
    "comment"                   => "Concentration of dissolved oxygen from a bottle sample",
    "ancillary_variables"       => "var35_qc",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar35_qc = defVar(ds,"var35_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of OXYGEN_D_CONC_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))





ncvar37 = defVar(ds,"var37", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "PHOSPHATE_D_CONC_BOTTLE",
    "units"                     => "umol/kg",
    "comment"                   => "Concentration of dissolved phosphate, samples may or may not have been filtered",
    "ancillary_variables"       => "var37_qc var37_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar37_qc = defVar(ds,"var37_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of PHOSPHATE_D_CONC_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar37_err = defVar(ds,"var37_err", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Error of PHOSPHATE_D_CONC_BOTTLE",
    "units"                     => "umol/kg",
    "comment"                   => "Concentration of dissolved phosphate, samples may or may not have been filtered",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))





ncvar39 = defVar(ds,"var39", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "SILICATE_D_CONC_BOTTLE",
    "units"                     => "umol/kg",
    "comment"                   => "Concentration of dissolved silicate (silicic acid), samples may or may not have been filtered",
    "ancillary_variables"       => "var39_qc var39_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar39_qc = defVar(ds,"var39_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of SILICATE_D_CONC_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar39_err = defVar(ds,"var39_err", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Error of SILICATE_D_CONC_BOTTLE",
    "units"                     => "umol/kg",
    "comment"                   => "Concentration of dissolved silicate (silicic acid), samples may or may not have been filtered",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))




ncvar40 = defVar(ds,"var40", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "NITRATE_D_CONC_BOTTLE",
    "units"                     => "umol/kg",
    "comment"                   => "Concentration of dissolved nitrate, samples may or may not have been filtered",
    "ancillary_variables"       => "var40_qc var40_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar40_qc = defVar(ds,"var40_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of NITRATE_D_CONC_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar40_err = defVar(ds,"var40_err", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Error of NITRATE_D_CONC_BOTTLE",
    "units"                     => "umol/kg",
    "comment"                   => "Concentration of dissolved nitrate, samples may or may not have been filtered",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))




ncvar85 = defVar(ds,"var85", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Cd_D_CONC_BOTTLE",
    "units"                     => "nmol/kg",
    "comment"                   => "Concentration of dissolved Cd",
    "ancillary_variables"       => "var85_qc var85_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar85_qc = defVar(ds,"var85_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of Cd_D_CONC_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar85_err = defVar(ds,"var85_err", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Error of Cd_D_CONC_BOTTLE",
    "units"                     => "nmol/kg",
    "comment"                   => "Concentration of dissolved Cd",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))





ncvar88 = defVar(ds,"var88", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Fe_D_CONC_BOTTLE",
    "units"                     => "nmol/kg",
    "comment"                   => "Concentration of dissolved Fe",
    "ancillary_variables"       => "var88_qc var88_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar88_qc = defVar(ds,"var88_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of Fe_D_CONC_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar88_err = defVar(ds,"var88_err", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Error of Fe_D_CONC_BOTTLE",
    "units"                     => "nmol/kg",
    "comment"                   => "Concentration of dissolved Fe",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))





ncvar104 = defVar(ds,"var104", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Ni_D_CONC_BOTTLE",
    "units"                     => "nmol/kg",
    "comment"                   => "Concentration of dissolved Ni",
    "ancillary_variables"       => "var104_qc var104_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar104_qc = defVar(ds,"var104_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of Ni_D_CONC_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar104_err = defVar(ds,"var104_err", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Error of Ni_D_CONC_BOTTLE",
    "units"                     => "nmol/kg",
    "comment"                   => "Concentration of dissolved Ni",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))





ncvar158 = defVar(ds,"var158", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Cd_114_110_D_DELTA_BOTTLE",
    "units"                     => "per 10^3",
    "comment"                   => "Atom ratio of dissolved Cd isotopes expressed in conventional DELTA notation referenced to {NIST3108}",
    "ancillary_variables"       => "var158_qc var158_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar158_qc = defVar(ds,"var158_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of Cd_114_110_D_DELTA_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar158_err = defVar(ds,"var158_err", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Error of Cd_114_110_D_DELTA_BOTTLE",
    "units"                     => "per 10^3",
    "comment"                   => "Atom ratio of dissolved Cd isotopes expressed in conventional DELTA notation referenced to {NIST3108}",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))






ncvar160 = defVar(ds,"var160", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Fe_56_54_D_DELTA_BOTTLE",
    "units"                     => "per 10^3",
    "comment"                   => "Atom ratio of dissolved Fe isotopes expressed in conventional DELTA notation referenced to {IRMM-14}",
    "ancillary_variables"       => "var160_qc var160_err",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar160_qc = defVar(ds,"var160_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of Fe_56_54_D_DELTA_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))

ncvar160_err = defVar(ds,"var160_err", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Error of Fe_56_54_D_DELTA_BOTTLE",
    "units"                     => "per 10^3",
    "comment"                   => "Atom ratio of dissolved Fe isotopes expressed in conventional DELTA notation referenced to {IRMM-14}",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))




ncvar109 = defVar(ds,"var109", Float32, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "V_D_CONC_BOTTLE",
    "units"                     => "nmol/kg",
    "comment"                   => "Concentration of dissolved V",
    "ancillary_variables"       => "var109_qc",
    "C_format"                  => "%.3f",
    "FORTRAN_format"            => "F12.3",
    "_FillValue"                => Float32(-1.0e10),
))

ncvar109_qc = defVar(ds,"var109_qc", Int8, ("N_SAMPLES", "N_STATIONS"), attrib = OrderedDict(
    "long_name"                 => "Quality flag of V_D_CONC_BOTTLE",
    "standard_name"             => "status_flag",
    "comment"                   => "SEADATANET - SeaDataNet quality codes",
    "flag_values"               => Int8[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 81],
    "flag_meanings"             => "no_quality_control good_value probably_good_value probably_bad_value bad_value changed_value value_below_detection value_in_excess interpolated_value missing_value value_phenomenon_uncertain nominal_value value_below_limit_of_quantification",
    "_FillValue"                => Int8(57),
))





# Define variables

# metavars \
# Recreate cruises
ranges = [1:79, 80:298, 299:403, 404:471, 472:504, 505:740, 741:798, 799:991, 992:1014, 1015:1053, 1054:1080, 1081:1087, 1088:1089, 1090:1215, 1216:1228, 1229:1241, 1242:1251, 1252:1266, 1267:1281, 1282:1299, 1300:1320, 1321:1370, 1371:1394, 1395:1473, 1474:1636, 1637:1723, 1724:1848, 1849:1862, 1863:1908, 1909:1937, 1938:1984, 1985:2051, 2052:2082, 2083:2092, 2093:2187, 2188:2360, 2361:2403, 2404:2436, 2437:2520, 2521:2643, 2644:2702, 2703:2768, 2769:2786, 2787:2802, 2803:2809, 2810:2820, 2821:2835, 2836:2849, 2850:2863, 2864:2890, 2891:2906, 2907:2921, 2922:2927, 2928:2942, 2943:2985, 2986:2986, 2987:3013, 3014:3115, 3116:3137, 3138:3149]
cruises = ["GA01", "GA02", "GA03", "GA04N", "GA04S", "GA06", "GA08", "GA10", "GA11", "GA13", "GAc01", "GAc02", "GAc03", "GApr08", "GApr09", "GI01", "GI02", "GI03", "GI04", "GI05", "GI06", "GIPY01", "GIPY02", "GIPY04", "GIPY05", "GIPY06", "GIPY11", "GIPY13", "GIpr01", "GIpr05", "GIpr06", "GN01", "GN02", "GN03", "GN04", "GN05", "GP02", "GP06", "GP12", "GP13", "GP15", "GP16", "GP18", "GP19", "GPc01", "GPc02", "GPc03", "GPc05", "GPc06", "GPpr01", "GPpr02", "GPpr04", "GPpr05", "GPpr07", "GPpr08", "GPpr10", "GPpr11", "GS01", "GSc01", "GSc02"]
for (c, r) in zip(cruises, ranges), i in 1:6
    ncmetavar1[i,r] = string(c, repeat('\0', 6-length(c)))[i]
end
# Fake station names going from 1 to 3149
for i in 1:3149
    s = string(i)
    for j in 1:20
        ncmetavar2[j,i] = j≤length(s) ? s[j] : '\0'
    end
end
# number of (depth) indices to mock-fill
idx = rand(reduce(vcat, repeat(0:n, Int(ceil(round(100/n^2)))) for n in 1:698), 3149)
function myfill(v)
    out = fill(fillvalue(v.var), size(v)...)
    for i in eachindex(idx)
        out[1:idx[i], i] .= rand(rng, eltype(v.var), idx[i])
    end
    out
end
function myfill_qc(v)
    out = Array{Int8,2}(undef, size(v)...)
    out .= '9' |> Int8
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
QC = [s[1] |> Int8 for s in string.([1,2,3,4,5])]
# pressure
ncvar1[:] = rand(eltype(ncvar1.var), size(ncvar1)...)
ncvar1_qc[:] = rand(QC, size(ncvar1_qc)...)
# depth
ncvar2[:] = rand(eltype(ncvar2.var), size(ncvar2)...)
ncvar2_qc[:] = rand(QC, size(ncvar2_qc)...)
# temp
ncvar15[:] = rand(eltype(ncvar15.var), size(ncvar15)...)
ncvar15_qc[:] = rand(QC, size(ncvar15_qc)...)
# salinity
ncvar16[:] = rand(eltype(ncvar16.var), size(ncvar16)...)
ncvar16_qc[:] = rand(QC, size(ncvar16_qc)...)
# some tracers
for v in [ncvar22, ncvar35, ncvar37, ncvar39, ncvar40, ncvar85, ncvar88, ncvar104, ncvar109, ncvar158, ncvar160,
          ncvar22_err, ncvar37_err, ncvar39_err, ncvar40_err, ncvar85_err, ncvar88_err, ncvar104_err, ncvar158_err, ncvar160_err]
    v[:] = myfill(v)
end
for v in [ncvar22_qc, ncvar35_qc, ncvar37_qc, ncvar39_qc, ncvar40_qc, ncvar85_qc, ncvar88_qc, ncvar104_qc, ncvar109_qc, ncvar158_qc, ncvar160_qc]
    v[:] = myfill_qc(v)
end

close(ds)
