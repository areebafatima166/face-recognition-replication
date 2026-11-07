# ============================================================
# 06_cfa_preregistered.R
# Preregistered one-factor CFA and bootstrap of variance explained
# Bootstrap uses bounds = "pos.var", a deviation from the preregistration
# Input:  data/raw/Additional_file_1.xlsx
# Output: outputs/cfa_one_factor.txt
#         outputs/cfa_boot_conditions_rerun.rds
# ============================================================

library(readxl)
library(lavaan)
set.seed(2018)

s2 <- read_excel("data/raw/Additional_file_1.xlsx", sheet = "Study 2")
nm <- names(s2)
pick <- function(p) { h <- nm[grepl(p, nm)]; stopifnot(length(h) == 1); h }
d <- data.frame(
  GFMT = s2[[pick("^GFMT")]], CFMT = s2[[pick("^CFMT")]],
  BTWF = s2[[pick("^BTWF")]], FaceDet = s2[[pick("^Face Detection")]],
  Mooney = s2[[pick("^Mooney")]]
)
dz <- as.data.frame(scale(d))
m1 <- "g =~ GFMT + CFMT + BTWF + FaceDet + Mooney"

fit1 <- cfa(m1, data = dz, estimator = "ML", std.lv = TRUE)
summary(fit1, standardized = TRUE, fit.measures = TRUE)

ve_of <- function(f) {
  sl <- standardizedSolution(f)
  mean(sl$est.std[sl$op == "=~"]^2)
}
ve_point <- ve_of(fit1)

B <- 1000
cond <- data.frame(
  error     = logical(B),
  nonconv   = logical(B),
  load_gt1  = logical(B),
  neg_var   = logical(B),
  zero_var  = logical(B),
  postcheck = logical(B)
)
ve <- rep(NA_real_, B)

for (b in 1:B) {
  idx <- sample(nrow(dz), replace = TRUE)
  fb <- tryCatch(
    cfa(m1, data = dz[idx, ], estimator = "ML", std.lv = TRUE, bounds = "pos.var"),
    error = function(e) NULL
  )
  if (is.null(fb)) { cond$error[b] <- TRUE; next }
  cond$nonconv[b] <- !lavInspect(fb, "converged")
  sl  <- standardizedSolution(fb)
  lam <- sl$est.std[sl$op == "=~"]
  cond$load_gt1[b] <- any(abs(lam) > 1)
  th <- diag(lavInspect(fb, "est")$theta)
  cond$neg_var[b]  <- any(th < 0)
  cond$zero_var[b] <- any(abs(th) < 1e-8)
  ve[b] <- mean(lam^2)
}

dir.create("outputs", showWarnings = FALSE)
writeLines(capture.output(summary(fit1, standardized = TRUE, fit.measures = TRUE)),
           "outputs/cfa_one_factor.txt")
saveRDS(list(cond = cond, ve = ve, point = ve_point),
        "outputs/cfa_boot_conditions_rerun.rds")

cat("Point estimate:", round(ve_point, 3), "\n")
cat("Boundary solutions (zero variance):", sum(cond$zero_var), "of", B, "\n")
cat("Valid 2.5%, 97.5%:",
    round(quantile(ve[!(cond$zero_var | cond$neg_var)], c(.025, .975), na.rm = TRUE), 3), "\n")
