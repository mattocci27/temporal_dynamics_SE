### Models: [sp_glm.R]()
- model1 - GLM (all traits)
- model2 - GLM (PCA)
- model3 - LM (all traits)
- model4 - LM (PCA)

Note:
- Only best models were shown (based on AIC).
- Ten-folds cross-validatio was applied for each (best) model.
- I added one to abudance to eleminate zero values.
#### model1:
abundance_2006 ~ NB(mu, theta)

mu = exp(LA + LS + HEIGHT + DENSITY) * abudance_1976

| Variables   | Estimate | Std. Error | z value | P |
|-------------|----------|------------|---------|----------|
| (Intercept) | 3.365    | 1.332      | 2.526   | 0.012    |
| LA          | -0.860   | 0.230      | -3.747  | 0.000    |
| LS          | 1.104    | 0.612      | 1.806   | 0.071    |
| HEIGHT      | 1.223    | 0.455      | 2.690   | 0.007    |
| DENSITY     | 2.361    | 0.924      | 2.555   | 0.011    |

R2_CV = -0.98 [-2.37, 0.39]

#### model2:
abundance_2006 ~ NB(mu, theta)

mu = exp(PCA1 + PCA2) * abudance_1976


|Variables    |Estimate |Std. Error |z value |Pr |
|:------------|---------|-----------|--------|---------|
| (Intercept) | 0.538   | 0.108      | 4.964   | 0.000    |
| PCA1      | -0.325  | 0.084      | -3.877  | 0.000    |
| PCA2      | -0.727  | 0.200      | -3.642  | 0.000    |

R2_CV = -2.14 [-5.82, 1.53]

#### model3:
log(rate)
= log(abudance_2006)/(abudance_1976)
= beta1 + beta2 * SEED + beta3 * LA * beta4 * HEIGHT + N(0, sigma)


| Variables   | Estimate | Std. Error | t value | P |
|-------------|----------|------------|---------|----------|
| (Intercept) | -0.909   | 0.608      | -1.495  | 0.137    |
| SEED        | 0.271    | 0.137      | 1.972   | 0.051    |
| LA          | -0.637   | 0.255      | -2.497  | 0.014    |
| HEIGHT      | 1.054    | 0.543      | 1.942   | 0.054    |

R2_CV = -1.09 [-1.67, -0.52]

#### model4:
log(rate)
= log(abudance_2006)/(abudance_1976)
= beta1 + beta2 * PCA1 + beta3 * PCA2 * beta4 * PCA1 * PCA2 + N(0, sigma)

| Variables     | Estimate | Std. Error | t value | P |
|---------------|----------|------------|---------|----------|
| (Intercept)   | -0.310   | 0.126      | -2.459  | 0.015    |
| PCA1        | -0.145   | 0.097      | -1.487  | 0.139    |
| PCA2        | -0.564   | 0.232      | -2.430  | 0.016    |
| PCA1:PCA2 | 0.362    | 0.221      | 1.639   | 0.104    |


R2_CV = -1.74 [-2.87, -0.62]
