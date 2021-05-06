#### Clean Itex community data ####

# Read in files
ItexAbundance.raw <- read_excel(path = "raw_data/community/ENDALEN_ALL-YEARS_TraitTrain.xlsx", sheet = "SP-ABUND")
ItexHeight.raw <- read_excel(path = "raw_data/community/ENDALEN_ALL-YEARS_TraitTrain.xlsx", sheet = "HEIGHT")
sp <- read_excel(path = "raw_data/community/Species lists_Iceland_Svalbard.xlsx", sheet = "Endalen")

# coordinates
coords <- read_excel(path = "clean_data/PFTC4_Svalbard_Coordinates.xlsx") %>%
  filter(Project == "T",
         Site %in% c("CAS", "BIS", "DRY") |is.na(Site))


# Species names
sp <- sp %>%
  select(SPP, GFNARROWarft, GENUS, SPECIES) %>%
  slice(-1) %>%
  mutate(GFNARROWarft = tolower(GFNARROWarft)) %>%
  rename(Spp = SPP, FunctionalGroup = GFNARROWarft, Genus = GENUS, Species = SPECIES)

# Community data
CommunitySV_ITEX_2003_2015 <- ItexAbundance.raw %>%
  pivot_longer(cols = -c(SUBSITE:YEAR, CRUST, `TOTAL-L`:SOIL), names_to = "Spp", values_to = "Abundance") %>%
  # remove non occurrence
  filter(Abundance > 0) %>%
  rename(Site = SUBSITE, Treatment = TREATMENT, PlotID = PLOT, Year = YEAR) %>%
  mutate(Site2 = substr(Site, 5, 5),
         Site = substr(Site, 1, 3),
         PlotID = gsub("L", "", PlotID)) %>%
  # Select for site L. Site H is the northern site
  filter(Site2 == "L") %>%
  select(-Site2, -`TOTAL-L`, -LITTER, -REINDRO, -BIRDRO, -ROCK, -SOIL, -CRUST) %>%
  left_join(sp, by = c("Spp")) %>%
  # Genus, species and taxon
  mutate(Genus = tolower(Genus),

         Species = tolower(Species),
         Species = if_else(is.na(Species), "sp", Species),

         Taxon = paste(Genus, Species, sep = " ")) %>%
  mutate(Taxon = ifelse(Taxon == "NA oppositifolia", "saxifraga oppositifolia", Taxon),
         Taxon = ifelse(Taxon == "festuca richardsonii", "festuca rubra", Taxon),
         Taxon = ifelse(Taxon == "pedicularis hisuta", "pedicularis hirsuta", Taxon),
         Taxon = ifelse(Taxon == "alopecurus boreale", "alopecurus ovatus", Taxon),
         Taxon = ifelse(Taxon == "stellaria crassipes", "stellaria longipes", Taxon),
         Taxon = ifelse(Taxon == "aulocomnium turgidum", "aulacomnium turgidum", Taxon),
         Taxon = ifelse(Taxon == "oncophorus whalenbergii", "oncophorus wahlenbergii", Taxon),
         Taxon = ifelse(Taxon == "racomitrium canescence", "niphotrichum canescens", Taxon),
         Taxon = ifelse(Taxon == "pedicularis dashyantha", "pedicularis dasyantha", Taxon),
         Taxon = ifelse(Taxon == "ptilidium ciliare ciliare", "ptilidium ciliare", Taxon),
         Taxon = ifelse(Taxon == "moss unidentified sp", "unidentified moss sp", Taxon),
         Taxon = ifelse(Taxon == "pleurocarp moss unidentified sp", "unidentified pleurocarp moss sp", Taxon),
         Taxon = ifelse(Taxon == "polytrichum/polytrichastrum sp", "polytrichum_polytrichastrum sp", Taxon),

         FunctionalGroup = if_else(Taxon == "ochrolechia frigida", "fungi", FunctionalGroup),
         FunctionalGroup = if_else(FunctionalGroup == "forbsv", "forb", FunctionalGroup)) %>%
  # add coords
  left_join(coords %>% select(-Project), by = c("Treatment" , "Site")) %>%

  select(Year, Site:PlotID, Taxon, Abundance, FunctionalGroup, Elevation_m:Longitude_E) %>%
  # rename site and plot names
  mutate(Site = case_when(Site == "BIS" ~ "SB",
                          Site == "CAS" ~ "CH",
                          Site == "DRY" ~ "DH"),
         PlotID = str_replace(PlotID, "BIS", "SB"),
         PlotID = str_replace(PlotID, "CAS", "CH"),
         PlotID = str_replace(PlotID, "DRY", "DH")) %>%
  # flag iced Cassiope plots
  mutate(Flag = if_else(PlotID %in% c("CH-4", "CH-6", "CH-9", "CH-10"), "Iced", NA_character_))

# Create new folder if not there yet
ifelse(!dir.exists("clean_data/community/"), dir.create("clean_data/community/"), FALSE)


write_csv(CommunitySV_ITEX_2003_2015, file = "clean_data/community/PFTC4_Svalbard_2003_2015_ITEX_Community.csv")


# Check community data over time
# CommunitySV_ITEX_2003_2015 %>%
#   ggplot(aes(x = Year, y = Abundance, colour = Taxon)) +
#   geom_point() +
#   geom_line() +
#   facet_wrap( ~ PlotID) +
#   theme(legend.position = "none")



### CHECK SPECIES NAMES ###
# # check TNRS
# library("TNRS")
# dat <- CommunitySV_ITEX_2003_2015 %>%
#   distinct(Taxon) %>%
#   arrange(Taxon) %>%
#   rownames_to_column()
# results <- TNRS(taxonomic_names = dat, matches = "best")
# # get references from the search
# metadata <- TNRS_metadata(bibtex_file = "DataPaper/tnrs_citations.bib")
# metadata$version
# results %>% View()
# results %>%
#   filter(Taxonomic_status == "Synonym")
#
# TNRS(c("cetraria delisei"), matches = "all")
# alopecurus ovatus not changing because Flora of Svalbard is using this name and tropico does not suggest this change
# cetraria delisei Unsure...



### ITEX HEIGHT DATA (not sure if used)
ItexHeight <- ItexHeight.raw %>%
  select(Year = YEAR, Site = SUBSITE, Treatment = TREATMENT, PlotID = PLOT, Xcoord = XCOORD, Ycoord = YCOORD, Canopy_height = HEIGHT) %>%
  filter(Site %in% c("DRY-L", "CAS-L", "BIS-L")) %>%
  mutate(Site = gsub("-L", "", Site),
         PlotID = gsub("L", "", PlotID)) %>%
  filter(!is.na(Canopy_height)) %>%
  # rename site and plot names
  mutate(Site = case_when(Site == "BIS" ~ "SB",
                          Site == "CAS" ~ "CH",
                          Site == "DRY" ~ "DH"),
         PlotID = str_replace(PlotID, "BIS", "SB"),
         PlotID = str_replace(PlotID, "CAS", "CH"),
         PlotID = str_replace(PlotID, "DRY", "DH"))

write_csv(x = ItexHeight, file = "clean_data/community/PFTC4_Svalbard_2003_2015_ITEX_Height.csv")
