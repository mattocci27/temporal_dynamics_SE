###
### contribution index
###

load("~/Dropbox/MS/nate_com/data/SE_dat.rda")

dat <- ab_t_dat %>%
# make sure that all communites have some values
  filter(is.na(abund1976) == FALSE)

dat2 <- dat %>%
  mutate(ab_d = abund2006 / sum(abund2006) - abund1976 / sum(abund1976)) %>%
  mutate(ab_d_s = scale(ab_d) %>% as.numeric)

# function to add contribution index
cont_make <- function(data, name) {
  trait_d <- paste(name, "_d", sep = "")
  ind_s <- paste(name, "_ind_s", sep = "")
  ind <- paste(name, "_ind", sep = "")
  data[, trait_d] <- data[, name] - mean(data[, name], na.rm = TRUE)

  # raw contribution index
  data[, ind] <- data[, "ab_d"] * data[, trait_d]

  # scaled ver. to compare each trait
  data[, ind_s] <- data[, "ab_d_s"] * as.numeric(scale(data[, trait_d]))
  data
}

cont_dat <- cont_make(dat2, "LA") %>%
  cont_make("SLA") %>%
  cont_make("LS") %>%
  cont_make("SEED") %>%
  cont_make("HEIGHT") %>%
  cont_make("DENSITY") %>%
  cont_make("Comp.1") %>%
  cont_make("Comp.2")

#dat2 <- cont_dat %>%
#  # remove col ending with "ind_s" to make table
#  select(matches("[^ind_s$]")) # this does not work

write.csv(cont_dat,
          "~/Dropbox/MS/nate_com/data/cont_index.csv",
          row.names = FALSE)

cont_dat %>%
  select(-c(LA, SLA, LS, SEED, HEIGHT, DENSITY, Comp.1, Comp.2)) %>%
  write.csv(
          "~/Dropbox/MS/nate_com/data_pub/cont_index_small.csv",
          row.names = FALSE)


#moge <- sum(cont_dat$DENSITY_ind)
#
#cont_dat %>% 
#  arrange(desc(DENSITY_ind))%>%
#  select(name, DENSITY_ind) %>%
#  mutate(cum = cumsum(DENSITY_ind)) %>%
#  filter(DENSITY_ind > 0) %>%
#  filter(cum < moge)


## funtion to find species that contirubutes trait shifts
cont_check <- function(cont_name) {
  com_change <- sum(cont_dat[, cont_name])

  if (com_change < 0) {
    cont_dat[, cont_name] <- -cont_dat[, cont_name]
    com_change2 <- -com_change
  } else com_change2 <- com_change 

  temp <- cont_dat[order(-cont_dat[, cont_name]), c("name", cont_name)] 
  temp[, "cum"] <- cumsum(temp[, cont_name])
  n_row <- temp %>% 
    filter(cum < com_change2) %>%
    nrow
  
  # to include one more species
  temp2 <- temp[1:(n_row + 1), ]

  if (com_change < 0) {
    temp2[, cont_name] <- - temp2[, cont_name]
    temp2[, "cum"] <- - temp2[, "cum"]
  }
  return(temp2)
}

# check how it works
cont_check("SLA_ind")
cont_check("DENSITY_ind")
cont_check("LS_ind")


cont_name <- paste(names(trait), "ind", sep = "_")
for (i in 1:length(cont_name)) {
  cont_check(cont_name[i]) %>% .$name %>% print
} 


# select only scaled contribuion index
fig_dat <- cont_dat %>%
  select(name, ends_with("_ind_s")) %>%
  tidyr::gather(trait, val, 2:9) %>%
  mutate(val_abs = abs(val)) %>%
  mutate(sig = ifelse(val < 0, "Negative", "Positive") %>% as.factor) %>%
  mutate(trait_sig = paste(trait, sig, sep = "_"))

# sum of scaled contriubtion index
x_val <- fig_dat %>%
  group_by(trait, sig) %>%
  summarise(mean = sum(val_abs, na.rm = T)) %>%
  mutate(trait_sig = paste(trait, sig, sep = "_")) %>%
  as_data_frame %>% # need to be data frame to remove trait col
  select(trait_sig, mean)

fig_dat2 <- full_join(fig_dat, x_val, by = "trait_sig")

ggplot(fig_dat2) +
  # without x = mean/2, pie chart will have holes in the midle
  geom_bar(aes(y = val_abs, x = mean/2,
               fill = as.factor(name), width = mean),
           position = "fill", stat = "identity") +
  facet_wrap(sig ~ trait) +
  coord_polar(theta="y") +
  #scale_fill_manual(values = c(cols_hex, "gray"),
  #  guide = guide_legend(title.position = "top",
  #    title = "Species",)) +
  guides(fill = FALSE) +
  theme_bw() +
  theme(axis.text.x = element_blank(),
     axis.text.y = element_blank(),
     axis.ticks = element_blank()) +
  xlab("") + ylab("") +
  theme(legend.position = "bottom",
    legend.margin = unit(-0.2, "cm"),
    panel.grid = element_blank())
