#### JOIN IBUTTON AND TINY TAGS DATA ####

# cleaning scripts
source("R/Functions/load_weather_endalen.R")
source("R/Functions/load_TinyTags.R")
source("R/Functions/load_iButtons.R")

ItexSvalbard_Temperature_2005_2018 <- bind_rows(TinyTag = TinyTag,
                                            iButton = ibutton,
                                            .id = "LoggerType") %>%
  # rename site and plot names
  mutate(Site = case_when(Site == "BIS" ~ "SB",
                          Site == "CAS" ~ "CH",
                          Site == "DRY" ~ "DH"),
         PlotID = str_replace(PlotID, "BIS", "SB"),
         PlotID = str_replace(PlotID, "CAS", "CH"),
         PlotID = str_replace(PlotID, "DRY", "DH"))

# Create new folder if not there yet
ifelse(!dir.exists("clean_data/climate/"), dir.create("clean_data/climate/"), FALSE)

write_csv(ItexSvalbard_Temperature_2005_2018, file = "clean_data/climate/PFTC4_Svalbard_2005_2018_ITEX_Temperature.csv")

write_csv(WeatherStation, file = "clean_data/climate/PFTC4_Svalbard_2015_2018_ITEX_Climate.csv")
