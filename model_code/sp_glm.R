###
### glm and CV
###
library(MASS)
library(cvTools)

load("~/Dropbox/MS/nate_com/data/SE_dat.rda")

dat <- ab_t_dat %>%
# make sure that all communites have some values
  filter(is.na(abund1976) == FALSE) %>%
  mutate(abund1976_1 = abund1976 + 1) %>%
  mutate(abund1996_1 = abund1996 + 1) %>%
  mutate(abund2006_1 = abund2006 + 1) %>%
  mutate(rate = abund2006_1 / abund1976_1)

cv_glm <- function(data, glmfit, K = 10){
  res_cv <- NULL
  SS <- NULL
  PREDS <- NULL
  temp <- cvFolds(nrow(data), K = K, type = "random")
  temp <- data.frame(ID = temp$subsets, gr = temp$which) %>%
    arrange(ID)
  temp <- data.frame(data, temp)

  Call <- glmfit$call

  for (i in 1:K){
    # train data
    Call$data <- filter(temp, gr != i)
    d_glm <- eval.parent(Call)

    # test data
    test_dat <- temp %>% filter(gr == i)

    # predicted abudance for test data
    fitted <- predict(d_glm, test_dat, type = "response")
    fitted2 <- fitted / test_dat$abund1976_1 # offset

    # observed abudance for test data (offset)
    yy <- test_dat$abund2006_1 / test_dat$abund1976_1

    SS[i] <- (yy - mean(yy, na.rm = T))^2 %>% mean
    PREDS[i] <- (yy - fitted2)^2 %>% mean(na.rm = T)
  }
  # 1 - mean(PREDS, na.rm = T) / mean(SS, na.rm = T)
  mean_ <- mean(1 - PREDS/SS, na.rm = T)
  se_ <- sd(1 - PREDS/SS, na.rm = T) / sqrt(K)
  upper <- mean_ + se_ * 1.96
  lower <- mean_ - se_ * 1.96
  data.frame(mean = mean_, lower = lower, upper = upper)
}


cv_lm <- function(data, glmfit, K){
  res_cv <- NULL
  SS <- NULL
  PREDS <- NULL
  temp <- cvFolds(nrow(data), K = 10, type = "random")
  temp <- data.frame(ID = temp$subsets, gr = temp$which) %>%
    arrange(ID)
  temp <- data.frame(data, temp)

  Call <- glmfit$call

  for (i in 1:K){
    # train data
    Call$data <- filter(temp, gr != i)
    d_glm <- eval.parent(Call)

    # test data
    test_dat <- temp %>% filter(gr == i)

    # predicted abudance for test data
    fitted <- predict(d_glm, test_dat, type = "response")

    # observed abundance for test data
    yy <- test_dat$rate

    SS[i] <- (yy - mean(yy, na.rm = T))^2 %>% mean
    PREDS[i] <- (yy - fitted)^2 %>% mean(na.rm = T)
  }
  mean_ <- mean(1 - PREDS/SS, na.rm = T)
  se_ <- sd(1 - PREDS/SS, na.rm = T) / sqrt(K)
  upper <- mean_ + se_ * 1.96
  lower <- mean_ - se_ * 1.96
  data.frame(mean = mean_, lower = lower, upper = upper)
}


set.seed(5)
m1 <- glm.nb(abund2006_1 ~
             SEED
           + LA
           + SLA
           + LS
           + HEIGHT
           + DENSITY
           + offset(log(abund1976_1)),
           data = dat)

res1 <- stepAIC(m1)
cv_glm(dat, m1, K = 10)

m2 <- glm.nb(abund2006_1 ~ Comp.1 * Comp.2
           + offset(log(abund1976_1)),
           data = dat)

res2 <- stepAIC(m2)
cv_glm(dat, m2, K = 10)


m3 <- lm(log(rate) ~
             SEED
           + LA
           + SLA
           + LS
           + HEIGHT
           + DENSITY,
           data = dat)

res3 <- stepAIC(m3)
res3 %>% summary %>% .$coefficient %>% write.csv("res3.csv")

cv_lm(dat, res3, K = 10)

m4 <- lm(log(rate) ~ Comp.1 * Comp.2,
           data = dat)

res4 <- stepAIC(m4)
res4 %>% summary %>% .$coefficient %>% write.csv("res4.csv")
cv_lm(dat, res4, K = 10)



