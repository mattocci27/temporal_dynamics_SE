###
### code for data pre-processing
###
source("https://raw.githubusercontent.com/mattocci27/TurnoverBCImain/master/source.R")

library(picante)

d1 <- readsample("~/Dropbox/MS/nate_com/data/samp76n.txt") %>% as.matrix
d2 <- readsample("~/Dropbox/MS/nate_com/data/samp96n.txt") %>% as.matrix
d3 <- readsample("~/Dropbox/MS/nate_com/data/samp06n.txt") %>% as.matrix

trait_raw <- read.csv("~/Dropbox/MS/nate_com/data/SE_TRAITS.csv")
rownames(trait_raw) <- trait_raw$name
trait <- trait_raw %>% select(-name)

# list
d <- list(d1, d2 ,d3)

## community means
ab_lapply <- function(samp, trait, trait_name) {
    lapply(samp, function(x)com.mean.ab(x, trait, trait_name)) %>%
          unlist
}

ab_lapply(d, trait, "SEED")

res <- NULL
trait_var <- trait %>% names

before <- proc.time()
for (i in 1:length(trait_var)){
  res <- cbind(res, ab_lapply(d, trait, trait_var[i]))
}

after <- proc.time()
after - before

colnames(res) <- trait_var

n_samp <- sapply(d, dim)[1,]

trait_com <- res %>%
  as_data_frame %>%
  mutate(site = sapply(d, rownames) %>% unlist) %>%
  mutate(time = c(rep(1976, n_samp[1]),
                rep(1996, n_samp[2]),
                rep(2006, n_samp[3]))) %>%
  mutate(gx = strsplit(site, "_") %>% sapply("[", 1) %>% as.numeric) %>%
  mutate(gy = strsplit(site, "_") %>% sapply("[", 2) %>% as.numeric) %>%
  mutate(year_site = paste(time, site, sep = "_"))

year_site <- paste(rep(c(1976, 1996, 2006), each = length(trait_com$site %>% unique)),
                   trait_com$site %>% unique %>% rep(3),
                   sep = "_")

temp <- data_frame(year_site, temp = 1)

trait_com2 <- full_join(trait_com, temp, by = "year_site")

## all
sp_ab <- lapply(d, function(x)apply(x, 2, mean))

#ab_lapply(sp_ab, trait, "SEED")
res <- NULL
for (i in 1:length(trait_var)){
  res <- cbind(res, lapply(sp_ab, function(x)com.mean.ab(x %>% as.matrix %>% t, trait, trait_var[i])))
}

colnames(res) <- trait_var
rownames(res) <- c(1976, 1996, 2006)
com_t_mean <- res
rm(res)

## sp-level
#ab_dat <- as.data.frame(sapply(d,function(x)apply(x,2,sum)))
#ab_dat$sp <- rownames(ab_dat)

ab_list <- lapply(d,function(x)apply(x,2,sum)) %>%
  lapply(., function(x){data.frame(name = names(x), abund = x)})


# check years and abund.x,y
ab_dat <- full_join(ab_list[[1]], ab_list[[2]], by = "name") %>%
  full_join(., ab_list[[3]]) %>%
  rename(abund1976 = abund.x) %>%
  rename(abund1996 = abund.y) %>%
  rename(abund2006 = abund)

# replace NA with 0
ab_dat[is.na(ab_dat)] <- 0

# merge with trait
ab_t_dat <- full_join(ab_dat, trait_raw, by = "name")

save.image("~/Dropbox/MS/nate_com/data/SE_dat.rda")
