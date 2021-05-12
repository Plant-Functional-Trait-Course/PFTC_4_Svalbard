#### Make a species list ####
library(tidyverse)
library()

commITEX <- read_csv("clean_data/community/PFTC4_Svalbard_2003_2015_ITEX_Community.csv")
commGradient <- read_csv("clean_data/community/PFTC4_Svalbard_2018_Community_Gradient.csv")
traitITEX <- read_csv("clean_data/traits/PFTC4_Svalbard_2018_ITEX_Traits.csv")
traitGradient <- read_csv("clean_data/traits/PFTC4_Svalbard_2018_Gradient_Traits.csv")

fg_f_sp <- read_csv("raw_data/PFTC4_Svalbard_2018_speciesList.csv")

author <- TNRS(fg_f_sp$Taxon) %>%
  select(Name_submitted, Accepted_name_author)

SpeciesList <- bind_rows(ITEX_comm = commITEX %>% distinct(Taxon),
          ITEX_trait = traitITEX %>% distinct(Taxon),
          .id = "data"
          ) %>%
  mutate(presence = "x") %>%
  pivot_wider(names_from = data, values_from = presence) %>%
  full_join(bind_rows(Gradient_comm = commGradient %>% distinct(Taxon),
                      Gradient_trait = traitGradient %>% distinct(Taxon),
                      .id = "data"
  ) %>%
    mutate(presence = "x") %>%
    pivot_wider(names_from = data, values_from = presence),
  by = "Taxon") %>%
  left_join(fg_f_sp, by = "Taxon") %>%
  select(FunctionalGroup, Family, Taxon:Gradient_trait) %>%
  arrange(FunctionalGroup, Family, Taxon) %>%
  left_join(author, by = c("Taxon" = "Name_submitted"))


write_csv(SpeciesList, "clean_data/community/PFTC4_Svalbard_2018_Species_Experiment_list.csv")

