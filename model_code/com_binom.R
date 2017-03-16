###
### simple binomial test
###

load("~/Dropbox/MS/nate_com/data/SE_dat.rda")

d1 <- trait_com2 %>% filter(time == 1976)
d2 <- trait_com2 %>% filter(time == 1996)
d3 <- trait_com2 %>% filter(time == 2006)

# 0.25 <- increase or decrease twice
binom_test <- function(trait_name, test_for = c("inc", "dec")) {

  a1 <- d2[,trait_name] - d1[,trait_name]
  a2 <- d3[,trait_name] - d2[,trait_name]

  n_test <- nrow(d1)

  if (test_for == "inc") {
  temp <- data.frame(a1, a2) %>%
    mutate(sig = ifelse(a1 > 0 & a2 > 0, 1, 0))
  } else if (test_for == "dec") {
  temp <- data.frame(a1, a2) %>%
    mutate(sig = ifelse(a1 < 0 & a2 < 0, 1, 0))
  }

  n_success <- sum(temp$sig, na.rm = TRUE)
  res <- binom.test(n_success, n_test, 0.25, "greater") 
  data.frame(n_success, n_test, p = res$p.value)
}

binom_test("SLA", test_for = "dec")
binom_test("HEIGHT", test_for = "inc")
binom_test("SEED", test_for = "inc")
binom_test("DENSITY", test_for = "inc")
binom_test("Comp.2", test_for = "dec")


## test
## temporal autocor does not create false positive
sig <- NULL
for (j in 1:400) {
  n <- 3
  y <- NULL
  y[1] <- 0
  for (i in 2:n){
    y[i] <- rnorm(1, 1 * y[i-1], 0.1)
  }
  if((y[3] - y[2] > 0) & (y[2] -y[1] > 0)) {
   sig[j] <- 1} else sig[j] <- 0 
}

sum(sig)
