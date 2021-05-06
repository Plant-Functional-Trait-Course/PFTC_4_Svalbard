#### Make a species list ####
library(tidyverse)
library()

commITEX <- read_csv("clean_data/community/PFTC4_Svalbard_2003_2015_ITEX_Community.csv")
commGradient <- read_csv("clean_data/community/PFTC4_Svalbard_2018_Community_Gradient.csv")
traitITEX <- read_csv("clean_data/traits/PFTC4_Svalbard_2018_ITEX_Traits.csv")
traitGradient <- read_csv("clean_data/traits/PFTC4_Svalbard_2018_Gradient_Traits.csv")

fg_f_sp <- read_csv("raw_data/PFTC4_Svalbard_2018_speciesList.csv")


bind_rows(ITEX_comm = commITEX %>% distinct(Taxon),
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
  arrange(FunctionalGroup, Family, Taxon)


Polytrichaceae
# check family names
family_check <- TNRS(spList$family)
family_check %>% filter(Family_score < 1)
# fixed these families
# Amarillidaceae Amaryllidaceae
# Euphobiaceae  Euphorbiaceae

taxon_check <- TNRS(spList$taxon)
# check typos in taxon
taxon_check %>%
  mutate(Name = c(Name_submitted == Accepted_species)) %>%
  select(Name_submitted,
         Name_matched,
         Accepted_species,
         Name,
         Name_matched_accepted_family,
         Accepted_family,
         Canonical_author,
         Accepted_name_author,
         Taxonomic_status) %>% View()
# fixing
# Senecio rhizomathus -> Senecio rhizomatus
# Bartisa tricophylla -> Bartisa trichophylla
# Agrostis perenans -> Agrostis perennans
# check typos in family
taxon_check %>%
  mutate(Name = c(Name_matched_accepted_family == Accepted_family)) %>%
  select(Name_submitted,
         Name_matched,
         Accepted_species,
         Name,
         Name_matched_accepted_family,
         Accepted_family,
         Canonical_author,
         Accepted_name_author,
         Taxonomic_status) %>% View()

dir("clean_data/")

spList %>%
  left_join(taxon_check %>%
              select(Name_submitted, Accepted_name_author), by = c("taxon" = "Name_submitted")) %>%
  rename("functional group" = "functional_group", "authority" = "Accepted_name_author") %>%
  select("functional group", family, authority, taxon, community, trait) %>%
  write_csv("clean_data/PFTC3_Puna_PFTC5_Peru_2018_2020_Full_species_list.csv")

