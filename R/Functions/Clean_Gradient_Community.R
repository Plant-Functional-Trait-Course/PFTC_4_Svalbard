#### Clean gradient community data ####

# Read in files
community_gradient_raw <- read_csv(file = "raw_data/community/PFTC4_Svalbard_2018_Community.csv")

draba_dic <- read_excel(path = "raw_data/community/PFTC4_Svalbard_2018_Draba_dictionary.xlsx") %>%
  pivot_longer(cols = c(`No Drabas`:`Draba lactea`), names_to = "Draba", values_to = "Precense") %>%
  rename(Gradient = site, Site = transect, PlotID = plot) %>%
  filter(Precense == 1)

# coordinates
coords <- read_csv(file = "clean_data/PFTC4_Svalbard_Coordinates_Gradient.csv")


# clean
community_gradient <- community_gradient_raw %>%
  select(Site, Elevation, Plot, Day, `Alopecurus ovatus`:`Trisetum spicatum`, Collected_by, Weather) %>%
  pivot_longer(cols = c(`Alopecurus ovatus`:`Trisetum spicatum`), names_to = "Taxon", values_to = "Cover") %>%
  filter(!is.na(Cover),
         !is.na(Day)) %>%
  mutate(Date = dmy(paste(Day, "07", "18", sep = "-"))) %>%
  rename(Gradient = Site, Site = Elevation, PlotID = Plot) %>%
  select(Date, Gradient:PlotID, Taxon, Cover, Weather, Collected_by) %>%
  # Fix draba species
  left_join(draba_dic, by = c("Gradient", "Site", "PlotID")) %>%
  mutate(Taxon = if_else(Taxon %in% c("Draba nivalis", "Draba oxycarpa", "Draba sp1", "Draba sp2"), Draba, Taxon),
         Taxon = if_else(Taxon == "No Drabas", "Unknown sp", Taxon)) %>%
  # Fix Cover column
  separate(Cover, into = c("Cover", "Fertile"), sep = "_") %>%
  mutate(Cover = str_replace_all(Cover, " ", ""),
         Cover = as.numeric(Cover),
         Fertile = as.numeric(Fertile),
         Year = 2018,
         Taxon = tolower(Taxon),
         Weather = case_when(Weather == "Sunny" ~ "sunny",
                             Weather == "partly cloudy" ~ "partly_cloudy",
                             Weather %in% c("windy_cloudy", "cloudy_little_wind", "cloudy_wind_SW_partly_sunny", "cloudy_wind") ~ "cloudy_windy",
                             Weather == "partly cloudy" ~ "partly_cloudy",
                             TRUE ~ Weather)) %>%
  # add coords
  left_join(coords, by = c("Gradient" , "Site", "PlotID")) %>%
  select(Year, Date, Gradient, Site, PlotID, Taxon, Cover, Fertile, Weather, Elevation_m:Latitude_N)

write_csv(community_gradient, file = "clean_data/community/PFTC4_Svalbard_2018_Community_Gradient.csv")


# # Check taxonomy
# library(TNRS)
# sp_list_g <- community_gradient %>%
#   distinct(Taxon)
#
# result <- TNRS(spList$Taxon)
#
# # get references from the search
# metadata <- TNRS_metadata(bibtex_file = "DataPaper/tnrs_citations_gradient.bib")
# metadata$version
# result %>% distinct(Taxonomic_status)
# result %>%
#   filter(Taxonomic_status == "Synonym")




#### COMMUNITY STRUCTRE #####

# Read in files
comm_structure_gradient <- community_gradient_raw %>%
  select(Day, Gradient = Site, Site = Elevation, PlotID = Plot, MedianHeight_cm, MaxHeight_cm = Max_height_cm, Vascular:Litter) %>%
  filter(!is.na(Site)) %>%
  mutate(Date = dmy(paste(Day, "07", "18", sep = "-")),
         Year = 2018) %>%
  # Fix Lichen_rock col
  mutate(Lichen_rock = if_else(Lichen_rock == "0_1", "0.1", Lichen_rock),
         Lichen_rock = as.numeric(Lichen_rock)) %>%
  left_join(coords, by = c("Gradient", "Site")) %>%
  pivot_longer(cols = MedianHeight_cm:Litter, names_to = "Variable", values_to = "Value") %>%
  filter(!is.na(Value)) %>%
  select(Year, Date, Gradient, Site, PlotID, Variable, Value, Elevation_m:Longitude_E)


write_csv(comm_structure_gradient, file = "clean_data/community/PFTC4_Svalbard_2018_Community_Structure_Gradient.csv")
