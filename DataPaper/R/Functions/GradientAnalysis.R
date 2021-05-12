
# Calculate Diversity Indices
Gradient_Diversity <- function(community_gradient){
  diversity_grad = community_gradient %>%
    group_by(Gradient, Site, PlotID, Elevation_m) %>%
    summarise(Richness = n(),
              Diversity = diversity(Cover),
              Evenness = Diversity/log(Richness),
              sumAbundance = sum(Cover)) %>%
    pivot_longer(cols = Richness:sumAbundance, names_to = "DiversityIndex", values_to = "Value")

  return(diversity_grad)
}


Gradient_Diversity_Figure <- function(diverstiy_gradient){
diversity_plot <- ggplot(diverstiy_gradient, aes(x = Elevation_m, y = Value, colour = Gradient, fill = Gradient)) +
  geom_point() +
  geom_smooth(method = "lm") +
  scale_colour_manual(values = c("green4", "grey"), labels = c("Birdcliff", "Control")) +
  scale_fill_manual(values = c("green4", "grey"), labels = c("Birdcliff", "Control")) +
  labs(x = "Elelvation in m a.s.l.", y = "") +
  facet_wrap(~ DiversityIndex, scales = "free")

  return(diversity_plot)
}

# Traits
Gradient_Trait_Figure <- function(traits_gradient){
trait_plot <- traits_gradient %>%
    mutate(Value = if_else(Trait %in% c("Dry_Mass_g", "Wet_Mass_g", "Leaf_Area_cm2", "Plant_Height_cm"), log(Value), Value),
          Trait = factor(Trait, levels = c("Plant_Height_cm", "Wet_Mass_g", "Dry_Mass_g", "Leaf_Area_cm2", "Leaf_Thickness_mm", "SLA_cm2_g", "LDMC", "C_percent", "N_percent", "P_percent", "CN_ratio", "dC13_permil", "dN15_permil"))) %>%
    ggplot(aes(x = Value, fill = Gradient, colour = Gradient)) +
    geom_density(alpha = 0.5) +
    scale_fill_manual(values = c("grey", "green4"), labels = c("Control", "Birdcliff")) +
    scale_colour_manual(values = c("grey", "green4"), labels = c("Control", "Birdcliff")) +
    labs(x = "Trait values", y = "Density") +
    facet_wrap(~Trait, scales = "free")

  return(trait_plot)
}

