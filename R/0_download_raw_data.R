#### DOWNLOAD RAW DATA FROM OSF ####

#install.packages("remotes")
#remotes::install_github("Plant-Functional-Trait-Course/PFTCFunctions")
library("PFTCFunctions")
library("googlesheets4")

#### CLIMATE ####
# Raw climate data
download_PFTC_data(country = "Svalbard",
                   datatype = "raw_climate",
                   path = "raw_data/climate")

# Unzip files
zipFile <- "raw_data/climate/Climate_Data_ITEX_2015_2018.zip"
outDir <- "raw_data/climate"
unzip(zipFile, exdir = outDir)


#### META DATA ####
# Meta data
download_PFTC_data(country = "Svalbard",
                   datatype = "meta",
                   path = "clean_data")


#### TRAITS ####
# Raw leaf trait data
download_PFTC_data(country = "Svalbard",
                   datatype = "raw_traits",
                   path = "raw_data/traits")

# Unzip Leaf Scans
zipFile <- "raw_data/traits/PFTC4_Svalbard_2018_LeafScans.zip"
outDir <- "raw_data/traits"
unzip(zipFile, exdir = outDir)

# Unzip chemical traits
zipFile <- "raw_data/traits/PFTC_All_IsotopeData.zip"
outDir <- "raw_data/traits"
unzip(zipFile, exdir = outDir)


#### COMMUNITY ####
# Raw community data
download_PFTC_data(country = "Svalbard",
                   datatype = "raw_community",
                   path = "raw_data/community")
