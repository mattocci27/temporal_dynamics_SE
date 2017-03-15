
fig_sp <- ab_t_dat %>%
  tidyr::gather(trait, val, 5:12) %>%
  mutate(trait_long = factor(trait,
                        levels = c("LA",
                                   "SLA",
                                   "LS",
                                   "HEIGHT",
                                   "SEED",
                                   "DENSITY",
                                   "Comp.1",
                                   "Comp.2"),
                        labels = c("LA",
                                   "SLA",
                                   "LS",
                                   "Maximum~height",
                                   "Seed~mass",
                                   "Wood~density",
                                   "PCA1",
                                   "PCA2")))

ggplot(fig_sp, aes(x = val, y = (abund2006 + 1) / (abund1976 + 1))) +
  facet_wrap(~ trait_long, nrow = 3, scale = "free",
  labeller = labeller(trait_long = label_parsed)) +
  geom_point() +
  scale_y_log10() +
  geom_hline(yintercept = 1, lty = 2) +
  ylab("(No. of individual in 2006 + 1) / \n (No. of individual in 1976 + 1)") +
  xlab("Trait values") +
  theme_bw()
