### stuff


all_comm <- bind_rows(ITEX = community_itex %>%
                        filter(Year == 2015,
                               Treatment == "CTL") %>%
                        rename(Cover = Abundance),
          Gradient = community_gradient %>% mutate(Site = as.character(Site)),
          .id = "Project") %>%
  mutate(Location = if_else(Project == "ITEX", Site, Gradient))


set.seed(32)

comm_fat = all_comm %>%
  select(-c(Project, Year, Treatment, FunctionalGroup:Flag, Date, Fertile, Weather, Gradient)) %>%
  distinct() %>%
  spread(key = Taxon, value = Cover, fill = 0)

comm_fat_spp = comm_fat %>% select(-(Site:Location))

NMDS <- metaMDS(comm_fat_spp, noshare = TRUE, try = 30)

fNMDS <- fortify(NMDS) %>%
  filter(Score == "sites") %>%
  bind_cols(comm_fat %>% select(Site:Location))


Ordination <- ggplot(fNMDS, aes(x = NMDS1, y = NMDS2, group = PlotID, shape = Location, colour = Location)) +
  geom_point(size = 3) +
  coord_equal() +
  scale_shape_manual(values = c(17, 2, 16, 18, 15), labels = c("Birdcliff", "Control", "Cassiope", "Dryas", "Snowbed")) +
  scale_colour_manual(values = c("green4", "grey", "pink2", "red","lightblue"), labels = c("Birdcliff", "Control", "Cassiope", "Dryas", "Snowbed")) +
  labs(x = "NMDS axis 1", y = "NMDS axis 2") +
  theme_bw()

ggsave("Ordination.jpeg", Ordination, dpi = 150)

diversity_itex %>%
  #group_by() %>%
  group_by(Site) %>%
  filter(DiversityIndex == "Richness") %>%
  summarise(mean = mean(Value),
            se = sd(Value)/sqrt(n()))

community_gradient %>% distinct(Taxon)
diversity_grad %>%
  group_by(Gradient) %>%
  filter(DiversityIndex == "Richness") %>%
  summarise(mean = mean(Value),
            se = sd(Value)/sqrt(n()))



traits_itex %>% distinct(Taxon)
traits_itex %>% distinct(ID)
traits_itex %>% distinct(Site, ID)


traits_gradient %>% distinct(Taxon)
traits_gradient %>% distinct(ID)



read_csv("clean_data/community/PFTC4_Svalbard_2018_Species_Experiment_list.csv") %>%
  View()


WeatherStation %>%
  mutate(year = year(DateTime)) %>% ungroup() %>% distinct(year)
WeatherStation %>%
  ungroup() %>%
  group_by(Variable) %>%
  summarise(mean(Value, na.rm = TRUE),
            se = sd(Value, na.rm = TRUE)/sqrt(n()))
WeatherStation %>%
  ungroup() %>%
  mutate(year = year(DateTime),
         month = month(DateTime)) %>%
  filter(month %in% c(6, 7, 8, 9)) %>%
  group_by(Variable) %>%
  summarise(mean(Value, na.rm = TRUE),
                                   se = sd(Value, na.rm = TRUE)/sqrt(n()))

ItexSvalbard_Temperature_2005_2018 %>%
  mutate(year = year(DateTime)) %>% ungroup() %>% distinct(year)

TT <- ItexSvalbard_Temperature_2005_2018 %>%
  filter(LoggerType == "TinyTag")
TT %>% mutate(year = year(DateTime)) %>% ungroup() %>% distinct(year)
TT %>% count(LoggerLocation)

TT %>%
  ungroup() %>%
  mutate(year = year(DateTime),
         month = month(DateTime)) %>%
  filter(month %in% c(6, 7, 8, 9),
         Treatment == "CTL") %>%
  group_by(Variable, LoggerLocation) %>%
  summarise(mean = mean(Value, na.rm = TRUE),
            se = sd(Value, na.rm = TRUE)/sqrt(n()))

TT %>%
  ungroup() %>%
  mutate(year = year(DateTime),
         month = month(DateTime)) %>%
  filter(month %in% c(6, 7, 8, 9)) %>%
  group_by(Variable, Treatment, Site, LoggerLocation) %>%
  summarise(mean = mean(Value, na.rm = TRUE)) %>%
  pivot_wider(names_from = Treatment, values_from = mean) %>%
  mutate(Diff = OTC - CTL)

iB <- ItexSvalbard_Temperature_2005_2018 %>%
  filter(LoggerType == "iButton")
iB %>% mutate(year = year(DateTime)) %>% ungroup() %>% distinct(year)
iB %>% count(LoggerLocation)

iB %>%
  ungroup() %>%
  mutate(year = year(DateTime),
         month = month(DateTime)) %>%
  filter(month %in% c(6, 7, 8, 9),
         Treatment == "CTL") %>%
  group_by(Variable, LoggerLocation) %>%
  summarise(mean = mean(Value, na.rm = TRUE),
            se = sd(Value, na.rm = TRUE)/sqrt(n()))

iB %>%
  ungroup() %>%
  mutate(year = year(DateTime),
         month = month(DateTime)) %>%
  filter(month %in% c(6, 7, 8, 9)) %>%
  group_by(Variable, Treatment, Site, LoggerLocation) %>%
  summarise(mean = mean(Value, na.rm = TRUE)) %>%
  pivot_wider(names_from = Treatment, values_from = mean) %>%
  arrange(LoggerLocation) %>%
  mutate(Diff = OTC - CTL)


comm_structure_gradient %>%
  filter(Variable == "MedianHeight_cm") %>%
  group_by(Variable, Gradient, Elevation_m) %>%
  summarise(mean = mean(Value),
            se = sd(Value)/sqrt(n()))

comm_structure_gradient %>% distinct(Variable)
  filter(Variable %in% c("MedianHeight_cm", "Vascular", "Bryophytes")) %>%
  ggplot(aes(x = factor(Site), y = Value, fill = Gradient)) +
  geom_boxplot() +
  scale_fill_manual(values = c("green4", "grey")) +
  facet_wrap(~ Variable, scales = "free")


ItexStructure %>%
  mutate(Site = factor(Site, levels = c("SB", "CH", "DH"))) %>%
  ggplot(aes(x = Site, y = Value, fill = Treatment)) +
  geom_boxplot() +
  scale_fill_manual(values = c("grey", "red")) +
  facet_wrap(~ Variable, scales = "free")


### TRAITS

ITEX_traits_SV_2018 %>%
  mutate(Trait_cat = if_else(Trait %in% c("C_percent", "N_percent", "CN_ratio", "dN15_permil", "dC13_permil", "P_percent"), "Chem", "Leaf")) %>%
  group_by(Trait_cat) %>%
  distinct(ID) %>% count(Trait_cat)

all_traits <- bind_rows(traits_gradient %>% mutate(Site = as.character(Site)),
          traits_itex)

trait_dist <- all_traits %>%
  filter(!is.na(Site)) %>%
  mutate(Value = if_else(Trait %in% c("Dry_Mass_g", "Wet_Mass_g", "Leaf_Area_cm2", "Plant_Height_cm"),
                         log(Value), Value),
         Trait = factor(Trait, levels = c("Plant_Height_cm", "Shoot_Length_cm", "Shoot_Length_Green_cm", "Wet_Mass_g", "Dry_Mass_g", "Leaf_Area_cm2", "Leaf_Thickness_mm", "SLA_cm2_g", "LDMC", "C_percent", "N_percent", "P_percent", "CN_ratio", "NP_ratio", "dC13_permil", "dN15_permil")),
         Location = if_else(Project == "ITEX", Site, Gradient)) %>%
  ggplot(aes(x = Value, fill = Location, colour = Location)) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = c("green4", "grey", "pink2", "red","lightblue"), labels = c("Birdcliff", "Control", "Cassiope", "Dryas", "Snowbed")) +
  scale_colour_manual(values = c("green4", "grey", "pink2", "red","lightblue"), labels = c("Birdcliff", "Control", "Cassiope", "Dryas", "Snowbed")) +
  labs(x = "Trait values", y = "Density") +
  facet_wrap(~Trait, scales = "free") +
  theme_minimal()

ggsave("Trait_distribution.jpeg", trait_dist, dpi = 150)





