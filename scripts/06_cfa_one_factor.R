# ============================================================
# 06_cfa_one_factor.R
# One-factor CFA of five face measures, with bootstrap of variance explained.
# Not preregistered. Fitted after the published results were examined.
# Requires data/raw/Additional_file_1.xlsx (not in repository).
# ============================================================

library(readxl)
library(lavaan)

set.seed(2026)

s2 <- read_excel("data/raw/Additional_file_1.xlsx", sheet = "Study 2")
vars <- c("GFMT Accuracy (%)", "CFMT Accuracy (%)", "BTWF Accuracy (%)",
          "Face Detection (%)", "Mooney Faces (%)")
d <- as.data.frame(s2[, vars])
colnames(d) <- c("GFMT", "CFMT", "BTWF", "FaceDet", "Mooney")
dz <- as.data.frame(scale(d))

model1 <- "g =~ GFMT + CFMT + BTWF + FaceDet + Mooney"
fit1 <- cfa(model1, data = dz, std.lv = TRUE)

dir.create("outputs", showWarnings = FALSE)
writeLines(capture.output(summary(fit1, fit.measures = TRUE, standardized = TRUE)),
           "outputs/cfa_one_factor.txt")

sl <- standardizedSolution(fit1)
point_ve <- mean(sl$est.std[sl$op == "=~"]^2)

B <- 1000
ve <- numeric(B)
zero_var <- logical(B)
neg_var  <- logical(B)
for (b in seq_len(B)) {
  idx <- sample(nrow(dz), replace = TRUE)
  fb <- tryCatch(cfa(model1, data = dz[idx, ], std.lv = TRUE,
                     bounds = "pos.var"), error = function(e) NULL)
  if (is.null(fb)) { ve[b] <- NA; next }
  pe <- parameterEstimates(fb)
  zero_var[b] <- any(pe$op == "~~" & pe$lhs == pe$rhs & pe$est == 0)
  neg_var[b]  <- any(pe$op == "~~" & pe$lhs == pe$rhs & pe$est < 0)
  s <- standardizedSolution(fb)
  ve[b] <- mean(s$est.std[s$op == "=~"]^2)
}

cond <- data.frame(zero_var = zero_var, neg_var = neg_var)
saveRDS(list(cond = cond, ve = ve, point = point_ve),
        "outputs/cfa_boot_conditions_rerun.rds")
cat("Point variance explained:", round(point_ve, 4), "\n")
cat("Boundary resamples:", sum(zero_var | neg_var), "\n")
