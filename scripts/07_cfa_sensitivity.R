# ============================================================
# 07_cfa_sensitivity.R
# Exploratory two-factor model and no-CFMT sensitivity check
# Post hoc: fitted after the one-factor model failed H1
# Requires fit1 from 06_cfa_preregistered.R
# ============================================================

library(readxl)
library(lavaan)

s2 <- read_excel('data/raw/Additional_file_1.xlsx', sheet = 'Study 2')
vars <- c('GFMT Accuracy (%)', 'CFMT Accuracy (%)', 'BTWF Accuracy (%)',
          'Face Detection (%)', 'Mooney Faces (%)')
d <- as.data.frame(s2[, vars])
colnames(d) <- c('GFMT', 'CFMT', 'BTWF', 'FaceDet', 'Mooney')
d <- na.omit(d)
dz <- as.data.frame(scale(d))

m1 <- 'g =~ GFMT + CFMT + BTWF + FaceDet + Mooney'
fit1 <- cfa(m1, data = dz, estimator = 'ML', std.lv = TRUE)

# ---- Exploratory: two-factor model (identity vs perception) ----
m2 <- '
  identity   =~ GFMT + CFMT + BTWF
  perception =~ FaceDet + Mooney
'
fit2 <- cfa(m2, data = dz, estimator = 'ML', std.lv = TRUE)
summary(fit2, standardized = TRUE, fit.measures = TRUE)
pe2 <- parameterEstimates(fit2, standardized = TRUE, ci = TRUE)
pe2[pe2$op == '~~' & pe2$lhs == 'identity' & pe2$rhs == 'perception', ]
anova(fit1, fit2)

# ---- Post hoc sensitivity: two-factor model without CFMT ----
m3 <- '
  identity   =~ GFMT + BTWF
  perception =~ FaceDet + Mooney
'
fit3 <- cfa(m3, data = dz, estimator = 'ML', std.lv = TRUE)
summary(fit3, standardized = TRUE, fit.measures = TRUE)
pe3 <- parameterEstimates(fit3, standardized = TRUE, ci = TRUE)
pe3[pe3$op == '~~' & pe3$lhs == 'identity' & pe3$rhs == 'perception', ]
pe3[pe3$op == '=~', c('lhs', 'rhs', 'std.all', 'ci.lower', 'ci.upper', 'pvalue')]

dir.create('outputs', showWarnings = FALSE)
writeLines(capture.output(summary(fit2, standardized = TRUE, fit.measures = TRUE)),
           'outputs/cfa_two_factor.txt')
writeLines(capture.output(anova(fit1, fit2)), 'outputs/cfa_model_comparison.txt')
writeLines(capture.output(summary(fit3, standardized = TRUE, fit.measures = TRUE)),
           'outputs/cfa_two_factor_noCFMT.txt')
