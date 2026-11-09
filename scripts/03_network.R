# Network analysis, McCaffery et al. (2018) Study 2 data
# 22 measures, Spearman correlations, EBICglasso
# TUNING = 0 was chosen after tuning = 0.5 returned an empty network (post hoc)
# Bootstrap: 1000 nonparametric resamples, seed 2026

library(readxl); library(bootnet); library(qgraph)
s2 <- read_excel('data/raw/Additional_file_1.xlsx', sheet = 'Study 2')
face_cols  <- c('GFMT Accuracy (%)', 'CFMT Accuracy (%)', 'BTWF Accuracy (%)',
                'Face Detection (%)', 'Mooney Faces (%)')
other_cols <- names(s2)[7:23]
dat <- as.data.frame(s2[, c(face_cols, other_cols)])
colnames(dat) <- make.names(colnames(dat))
TUNING <- 0.10
net <- estimateNetwork(dat, default = 'EBICglasso', corMethod = 'spearman', tuning = TUNING)
cat('edges:', sum(net$graph != 0) / 2, '\n')
set.seed(2026)
boot_np <- bootnet(net, nBoots = 1000, type = 'nonparametric', statistics = 'edge')
bs <- summary(boot_np, statistics = 'edge')
subset(bs, node1 == 'GFMT.Accuracy....' & node2 == 'CFMT.Accuracy....')
drop <- which(dat$Silhouettes.Total.... == 0 | dat$Mooney.Faces.... == 0)
dat2 <- dat[-drop, ]
net2 <- estimateNetwork(dat2, default = 'EBICglasso', corMethod = 'spearman', tuning = 0)
net2$graph[1, 2]
file.show("scripts/04_network_stability.R")

# Save the primary (gamma = .10) edge bootstrap
dir.create("outputs", showWarnings = FALSE)
eg <- summary(boot_np, statistics = "edge")
write.csv(eg, "outputs/edge_accuracy_gamma010.csv", row.names = FALSE)
