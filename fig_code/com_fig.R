###
### figures
###

load("~/Dropbox/MS/nate_com/data/SE_dat.rda")

fig_dat <- trait_com2 %>%
  tidyr::gather(trait, val, 1:8) %>%
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

# standardizing initial values
fig_dat2 <- fig_dat %>%
  arrange(year_site) %>%
  mutate(val_ctl_add = val - rep(.$val[1:3048], 3))
  #mutate(val_ctl_mlt = val / rep(.$val[1:3048], 3))

  # relative deviation does not make sense because they inlcude negative values

com_t_mean2 <- (t(com_t_mean) - com_t_mean[1,]) %>% t

fig_dat3 <- com_t_mean2 %>%
  as.data.frame %>%
  mutate(time = c(1976, 1996, 2006)) %>%
  tidyr::gather(trait, val, 1:8) %>%
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


png("~/Dropbox/MS/nate_com/figs/kernel_density.png", width = 800, height = 600)
ggplot(fig_dat, aes(x = val)) +
  facet_wrap(~ trait_long, nrow = 3, scale = "free",
  labeller = labeller(trait_long = label_parsed)) +
  #geom_blank(data = dummy) +
  geom_density(adjust = 1,
    aes(colour = as.factor(time))) +
  guides(colour = guide_legend(title = NULL), size = 21) +
  ylab("Density") +
  xlab("Trait values") +
  theme_bw()
dev.off()

png("~/Dropbox/MS/nate_com/figs/com_trends_addtive.png", width = 800, height = 600)
ggplot(fig_dat2, aes(x = time, y = val_ctl_add)) +
  facet_wrap(~ trait_long, nrow = 3, scale = "free",
  labeller = labeller(trait_long = label_parsed)) +
  geom_point() +
  xlab("Time") +
  ylab("Deviation from initial trait values") +
  geom_line(aes(fill = site), alpha = 0.2) +
  theme_bw()
dev.off()

#png("~/Dropbox/MS/nate_com/figs/com_trends_mutiple.png", width = 800, height = 600)
#ggplot(fig_dat2, aes(x = time, y = val_ctl_mlt)) +
#  facet_wrap(~ trait_long, nrow = 3, scale = "free",
#  labeller = labeller(trait_long = label_parsed)) +
#  geom_point() +
#  xlab("Time") +
#  ylab("Relative deviation from initial trait values") +
#  geom_line(aes(fill = site), alpha = 0.2) +
#  theme_bw()
#dev.off()

png("~/Dropbox/MS/nate_com/figs/com_trends_all.png", width = 800, height = 600)
ggplot(fig_dat3, aes(x = time, y = val)) +
  facet_wrap(~ trait_long, nrow = 3, scale = "free",
  labeller = labeller(trait_long = label_parsed)) +
  geom_point() +
  xlab("Time") +
  ylab("Deviation from initial trait values") +
  geom_line() +
  theme_bw()
dev.off()

