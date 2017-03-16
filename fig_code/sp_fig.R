###
### sp figures
###

load("~/Dropbox/MS/nate_com/data/SE_dat.rda")

fig_sp <- ab_t_dat %>%
# make sure that all communites have some values
  filter(is.na(abund1976) == FALSE) %>%
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


png("~/Dropbox/MS/nate_com/figs/abund_1976_2006_plus.png", width = 800, height = 600)
ggplot(fig_sp, aes(x = val, y = (abund2006 + 1) / (abund1976 + 1))) +
  facet_wrap(~ trait_long, nrow = 3, scale = "free_x",
  labeller = labeller(trait_long = label_parsed)) +
  geom_point() +
  scale_y_log10() +
  geom_hline(yintercept = 1, lty = 2) +
  ylab("(No. of individual in 2006 + 1) / \n (No. of individual in 1976 + 1)") +
  xlab("Trait values") +
  theme_bw()
dev.off()

png("~/Dropbox/MS/nate_com/figs/abund_1976_1996_plus.png", width = 800, height = 600)
ggplot(fig_sp, aes(x = val, y = (abund1996 + 1) / (abund1976 + 1))) +
  facet_wrap(~ trait_long, nrow = 3, scale = "free_x",
  labeller = labeller(trait_long = label_parsed)) +
  geom_point() +
  scale_y_log10() +
  geom_hline(yintercept = 1, lty = 2) +
  ylab("(No. of individual in 1996 + 1) / \n (No. of individual in 1976 + 1)") +
  xlab("Trait values") +
  theme_bw()
dev.off()

png("~/Dropbox/MS/nate_com/figs/abund_1976_2006.png", width = 800, height = 600)
ggplot(fig_sp, aes(x = val, y = abund2006 / abund1976)) +
  facet_wrap(~ trait_long, nrow = 3, scale = "free_x",
  labeller = labeller(trait_long = label_parsed)) +
  geom_point() +
  scale_y_log10() +
  geom_hline(yintercept = 1, lty = 2) +
  ylab("(No. of individual in 2006) / \n (No. of individual in 1976)") +
  xlab("Trait values") +
  theme_bw()
dev.off()

png("~/Dropbox/MS/nate_com/figs/abund_1976_1996.png", width = 800, height = 600)
ggplot(fig_sp, aes(x = val, y = (abund1996) / (abund1976))) +
  facet_wrap(~ trait_long, nrow = 3, scale = "free_x",
  labeller = labeller(trait_long = label_parsed)) +
  geom_point() +
  scale_y_log10() +
  geom_hline(yintercept = 1, lty = 2) +
  ylab("(No. of individual in 1996) / \n (No. of individual in 1976)") +
  xlab("Trait values") +
  theme_bw()
dev.off()



fig_sp %>% filter(trait == "LA") %>%
  ggplot(., aes(x = val, y = (abund1996) / (abund1976))) +
  geom_point() +
  scale_y_log10()

fig_sp %>% filter(trait == "LA") %>% summary
