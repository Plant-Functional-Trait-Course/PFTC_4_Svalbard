##################################
#### DOWNLOAD AND IMPORT DATA ####
##################################

### Download data
DataDownloadPlan <- drake_plan(
  # Climate
  climate_download = target(download_PFTC_data(country = "Svalbard",
                                               datatype = "climate",
                                               path = "clean_data/climate")),

  # Traits
  trait_download = target(download_PFTC_data(country = "Svalbard",
                                             datatype = "trait",
                                             path = "clean_data/traits")),

  # Meta data (coordinates)
  meta_download = target(download_PFTC_data(country = "Svalbard",
                                            datatype = "meta",
                                            path = "clean_data/meta")),

  # Community
  community_download = target(download_PFTC_data(country = "Svalbard",
                                                 datatype = "community",
                                                 path = "clean_data/community")),

)





# Import data
DataImportPlan <- drake_plan(

  # climate
  climate_itex = read_csv(file = "clean_data/climate/PFTC4_Svalbard_2015_2018_ITEX_Climate.csv"),
  temperature_itex = read_csv(file = "clean_data/climate/PFTC4_Svalbard_2005_2018_ITEX_Temperature.csv"),

  # community
  community_itex = read_csv(file = "clean_data/community/PFTC4_Svalbard_2003_2015_ITEX_Community.csv"),
  height_itex = read_csv(file = "clean_data/community/PFTC4_Svalbard_2003_2015_ITEX_Height.csv"),
  community_gradient = read_csv(file = "clean_data/community/PFTC4_Svalbard_2018_Community_Gradient.csv"),

  # meta
  coordinates = read_excel(path = "clean_data/PFTC4_Svalbard_Coordinates.xlsx"),

  # traits
  traits_itex = read_csv(file = "clean_data/traits/PFTC4_Svalbard_2018_ITEX_Traits.csv"),

  traits_gradient = read_csv(file = "clean_data/traits/PFTC4_Svalbard_2018_Gradient_Traits.csv")

)
