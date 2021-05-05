#### CALCULATE LEAF AREA ####

# load libraries
#devtools::install_github("richardjtelford/LeafArea")
library("LeafArea")
library("tidyverse")


# Unzip files
zipFile <- "raw_data/traits/PFTC4_Svalbard_2018_LeafScans.zip"
outDir <- "raw_data/traits"
unzip(zipFile, exdir = outDir)

#### Check LeafIDs
# Load trait IDs
load("raw_data/traits/envelope_codes.Rdata", verbose = TRUE)

# List of scan names
list.of.files <- dir(path = "raw_data/traits/Leaf Scans/", pattern = "jpeg|jpg", recursive = TRUE, full.names = TRUE)

# CHECKS
# dd <- basename(list.of.files) %>%
#   as_tibble() %>%
#   mutate(value = gsub(".jpeg", "", value))
#
# setdiff(dd$value, all_codes$hashcode)
# Only "Unknown_2018-07-20_01_05"


# Function to calculate leaf area
loop.files <-  function(files){

  file.copy(files, new.folder)
  #if(grepl("-NA$", files)){
  #newfile <- basename(files)
  #file.rename(paste0(new.folder, "/", newfile), paste0(new.folder,
  #"/", gsub("-NA$", "", newfile)))
  #}
  print(files)
  area <- try(run.ij(set.directory = new.folder, distance.pixel = 237, known.distance = 2, log = TRUE, low.size = 0.005, trim.pixel = 55, trim.pixel2 = 150, save.image = TRUE))
  if(inherits(area, "try-error")){
    return(data.frame(LeafArea = NA))
  }
  file.copy(dir(new.folder, full.names = TRUE, pattern = "\\.tif"), output.folder)
  Sys.sleep(0.1)
  if(any(!file.remove(dir(new.folder, full.names = TRUE) ))) stop()
  res <- data.frame(ID = names(unlist(area[[2]])), LeafArea = (unlist(area[[2]])))
  return(res)
}



#### Calculate the leaf area using run.ij and check if there are problem.

# test run.ij
# run.ij(set.directory = "~/Desktop/TestLeaf", distance.pixel = 237, known.distance = 2, log = TRUE, low.size = 0.005, trim.pixel = 55, trim.pixel2 = 150, save.image = TRUE)


#### Run run.ij to get areas
list.of.files <- dir(path = "raw_data/traits/Leaf Scans/", pattern = "jpeg|jpg", recursive = TRUE, full.names = TRUE)
new.folder <- "raw_Data/traits/Temp/"
output.folder <- "raw_data/traits/Leaf_Output/"

# Calculate leaf area
LeafArea.raw <- plyr::ldply(list.of.files, loop.files)

# safty copy
#save(LeafArea.raw, file = "raw_data/traits/LeafArea.raw.Rdata")


#### Calculate leaf area
#load("raw_data/traits/LeafArea.raw.Rdata", verbose = TRUE)

LeafArea2018 <- LeafArea.raw %>%
  # remove leaves that were calculated double by mistake
  group_by(ID, LeafArea) %>%
  mutate(n = n()) %>%
  filter(n == 1) %>%
  ungroup() %>%
  # remove jpeg etc from ID name
  mutate(ID = substr(ID, 1, 7)) %>%

  # Sum areas for each ID
  group_by(ID) %>%
  summarise(Area_cm2 = sum(LeafArea), NumberLeavesScan = n())

#write_csv(LeafArea2018, path = "raw_data/traits/PFTC4_Svalbard_2018_LeafArea.csv", col_names = TRUE)
