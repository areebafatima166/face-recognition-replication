# ============================================================
# 04_network_stability.R
# Case-dropping stability of centrality, primary network (gamma = .10)
# Recomputes from the raw data; no saved objects are loaded.
# ============================================================

library(readxl)
library(bootnet)
library(qgraph)

TUNING <- 0.10   # primary network, as reported in the README

s2 <- read_excel("data/raw/Additional_file_1.xlsx", sheet = "Study 2")
face_cols  <- c("GFMT Accuracy (%)", "CFMT Accuracy (%)", "BTWF Accuracy (%)",
                "Face Detection (%)", "Mooney Faces (%)")
other_cols <- names(s2)[7:23]
dat <- as.data.frame(s2[, c(face_cols, other_cols)])
colnames(dat) <- make.names(colnames(dat))

net <- estimateNetwork(dat, default = "EBICglasso",
                       corMethod = "spearman", tuning = TUNING)

set.seed(2026)
boot_case <- bootnet(net, nBoots = 1000, type = "case",
                     statistics = c("strength", "closeness", "betweenness"))

cs <- corStability(boot_case)

dir.create("outputs", showWarnings = FALSE)
cs_df <- data.frame(Centrality     = names(cs),
                    CS_Coefficient = as.numeric(cs))
write.csv(cs_df, "outputs/centrality_stability_gamma010.csv", row.names = FALSE)

cat("\nCase-dropping stability saved. CS values:\n")
print(cs_df)
