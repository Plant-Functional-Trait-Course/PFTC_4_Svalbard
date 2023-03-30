### Clean soil CN from Gradients

soil_cn_raw <- read_excel(path = "raw_data/soil/PFTC4_Svalbard_raw_CN_2022.xlsx")

meta <- read_csv(file = "clean_data/PFTC4_Svalbard_Coordinates_Gradient.csv")


soil_cn <- soil_cn_raw |>
  # extract meta data
  mutate(Gradient = str_sub(sample_ID, 1, 1),
         Site = as.numeric(str_sub(sample_ID, 2, 2)),
         PlotID = str_sub(sample_ID, 3, 3)) |>
  # join elevation and coordinates
  left_join(meta, by = c("Gradient", "Site", "PlotID")) |>
  rename(C = `%  C`, N = `%  N`) |>
  # long table
  pivot_longer(cols = c(C, N), names_to = "Variable", values_to = "Value") |>
  # add unit
  mutate(Unit = "percentage") |>
  select(Gradient:PlotID, Variable, Value, Unit, Weigth_mg = `vekt   mg`, Elevation_m:Latitude_N)

write_csv(soil_cn, file = "clean_data/soil/PFTC4_Svalbard_2018_Gradient_Clean_Soil_CN.csv")


soil# check data
ggplot(soil_cn, aes(x = Elevation_m, y = Value, colour = Gradient)) +
  geom_point() +
  geom_smooth() +
  scale_colour_manual(name = "", values = c("grey", "green4"), labels = c("Reference", "Nutrient input")) +
  facet_wrap(~ Variable, scales = "free")
