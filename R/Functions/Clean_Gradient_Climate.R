#### SOIL TEMPERATURE AND MOISTURE DATA FROM GRADIENT ####

soil_climate_raw <- read_delim(file = "raw_data/climate/PFTC4_SV_2018_SM.csv",
                               delim = ";", locale = locale(decimal_mark = "."))

gradient_climate <- soil_climate_raw %>%
  mutate(LoggerType = "iButton",
         LoggerLocation = "soil") %>%
  mutate(Gradient = str_sub(plot, 1, 1),
         Site = str_sub(plot, 2, 2),
         PlotID = str_sub(plot, 3, 3)) %>%
  # calculate average per plot
  mutate(SoilMoisture = rowMeans(select(., matches("moist\\d")), na.rm = TRUE),
         SoilTemperature = rowMeans(select(., matches("temp\\d")), na.rm = TRUE)) %>%
  select(-c(moist1:moist3, temp1:temp3, moistAVG, tempAVG, plot)) %>%
  pivot_longer(cols = c(SoilMoisture, SoilTemperature), names_to = "Variable", values_to = "Value")

# Create new folder if not there yet
ifelse(!dir.exists("clean_data/climate/"), dir.create("clean_data/climate/"), FALSE)

write_csv(gradient_climate, file = "clean_data/climate/PFTC4_Svalbard_2018_Gradient_Climate.csv")
