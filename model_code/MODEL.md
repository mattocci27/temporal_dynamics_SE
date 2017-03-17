## Liner models: [sp_glm.R](https://github.com/mattocci27/temporal_dynamics_SE/blob/master/model_code/sp_glm.R)
- model1 - GLM (abundacne2006 ~ all traits)
- model2 - GLM (abudance2006 ~ PCA)
- model3 - LM (rate ~ all traits)
- model4 - LM (rate ~ PCA)

Note:
- Only best models were shown (based on AIC).
- Ten-folds cross-validation was applied for each (best) model.
- I added one to abudance to eleminate zero values.

### Some Results
- There are significant (p < 0.05) relationships between relative species
    abudance changes and tratis, but these are due to overfitting. 
- Cross-validated R2 values were negative for all the models, which suggets
    there are no predicive linear relationships between abudance changs and
    traits used in this analysis.


#### model1:
abundance_2006 ~ NB(mu, theta)  
mu = exp(LA + LS + HEIGHT + DENSITY) * abudance_1976

Note: abudance_1976 is offset term (baseline intercept)


| Variables   | Estimate | Std. Error | z value | P |
|-------------|----------|------------|---------|----------|
| (Intercept) | 3.365    | 1.332      | 2.526   | 0.012    |
| LA          | -0.860   | 0.230      | -3.747  | 0.000    |
| LS          | 1.104    | 0.612      | 1.806   | 0.071    |
| HEIGHT      | 1.223    | 0.455      | 2.690   | 0.007    |
| DENSITY     | 2.361    | 0.924      | 2.555   | 0.011    |

R2_CV = -0.563 [-0.837, -0.290]

#### model2:
abundance_2006 ~ NB(mu, theta)  
mu = exp(PCA1 + PCA2) * abudance_1976


|Variables    |Estimate |Std. Error |z value |Pr |
|:------------|---------|-----------|--------|---------|
| (Intercept) | 0.538   | 0.108      | 4.964   | 0.000    |
| PCA1      | -0.325  | 0.084      | -3.877  | 0.000    |
| PCA2      | -0.727  | 0.200      | -3.642  | 0.000    |

R2_CV = -0.732 [-1.147, -0.318]

#### model3:
log(rate)  
= log(abudance_2006)/(abudance_1976))  
= beta1 + beta2 * SEED + beta3 * LA * beta4 * HEIGHT + N(0, sigma)


| Variables   | Estimate | Std. Error | t value | P |
|-------------|----------|------------|---------|----------|
| (Intercept) | -0.909   | 0.608      | -1.495  | 0.137    |
| SEED        | 0.271    | 0.137      | 1.972   | 0.051    |
| LA          | -0.637   | 0.255      | -2.497  | 0.014    |
| HEIGHT      | 1.054    | 0.543      | 1.942   | 0.054    |

R2_CV = -0.138 [-0.404, -0.128]

#### model4:
log(rate)  
= log(abudance_2006)/(abudance_1976))  
= beta1 + beta2 * PCA1 + beta3 * PCA2 * beta4 * PCA1 * PCA2 + N(0, sigma)

| Variables     | Estimate | Std. Error | t value | P |
|---------------|----------|------------|---------|----------|
| (Intercept)   | -0.310   | 0.126      | -2.459  | 0.015    |
| PCA1        | -0.145   | 0.097      | -1.487  | 0.139    |
| PCA2        | -0.564   | 0.232      | -2.430  | 0.016    |
| PCA1:PCA2 | 0.362    | 0.221      | 1.639   | 0.104    |


R2_CV = -0.0377 [-0.165, 0.090]

## Binomial test: [com_binom.R](https://github.com/mattocci27/temporal_dynamics_SE/blob/master/model_cjode/comm.)
- Binomial test (one-tail) for numbers of plots in which community mean values incresed (or decrease) twice in a row (1976 -> 1996 -> 2006).
- LA, LS and PCA1 were not tested because they deceased first then incrased from
    1996 to 2006.
- Since there are only 3 data points, I don't have any good ideas to test something
    different for now.

### Results
- HEIGHT and DENSITY seem to be increased and PCA2 seems to be decreased from 1976 to 2006.

|         | n_success | n_sample | p       | note     |
|---------|-----------|----------|---------|----------|
| SLA     | 109       | 381      | 0.060   | decrease |
| HEIGHT  | 124       | 381      | < 0.001 | increase |
| SEED    | 78        | 381      | 0.98    | increase |
| DENSITY | 164       | 381      | < 0.001 | increase |
| PCA2    | 148       | 381      | < 0.001 | decrease |

## Contributon index: [cont_index.R](https://github.com/mattocci27/temporal_dynamics_SE/blob/master/fig_code/cont_index.R)
The follwoing species are largely responsible for the community
mean trait shifts. For example, the contribution of "verti" to SEED is larger
than the total community mean shift.

"**SEED**"   "vertri"  
"**LA**"     "capind" "cecpel" "tricun"  
"**SLA**"    "capind" "manchi" "vertri"  
"**LS**"     "astgra"  
"**HEIGHT**" "manchi" "acacol" "exomex" "astgra" "procru" "cascor" "hemexc"  
"**DENSITY**" "manchi"  "astgra"  "cocvit"  "cecpel"  "exomex"  "malarb" "capind"  "pismac"  "taboch"  "spopur"  "corall"  "calcan"  "swacub"  "ransub"  
"**Comp.1**" "capind" "cecpel"  
"**Comp.2**" "manchi" "hemexc" "acacol" "exomex" "cascor" "procru" "allocc" "vertri" "casarg" "cocvit" "pismac"
