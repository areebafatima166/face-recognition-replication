
# ============================================================
# verify_manuscript.R
# Recomputes the manuscript key numbers and checks them against
# stated values and saved repo outputs. Run from the project root.
# ============================================================

library(readxl)
library(lavaan)
library(qgraph)

set.seed(2018)
res <- data.frame(item = character(), expected = character(),
                  computed = character(), status = character(),
                  stringsAsFactors = FALSE)

chk <- function(item, expected, computed, tol = 0) {
  ok <- all(abs(as.numeric(computed) - as.numeric(expected)) <= tol)
  res[nrow(res) + 1, ] <<- list(item,
                                paste(expected, collapse = ", "),
                                paste(round(as.numeric(computed), 4), collapse = ", "),
                                ifelse(ok, "PASS", "FAIL"))
}

# ---- 1. Data integrity ----
s2 <- read_excel("data/raw/Additional_file_1.xlsx", sheet = "Study 2")
chk("rows", 107, nrow(s2))
chk("columns including ID", 23, ncol(s2))
chk("missing cells", 0, sum(is.na(s2)))
chk("duplicate IDs", 0, sum(duplicated(s2[["Participant ID"]])))

d <- as.data.frame(s2[, -1])
nm <- names(d)
pick <- function(p) { h <- nm[grepl(p, nm)]; stopifnot(length(h) == 1); h }
G <- pick("^GFMT"); C <- pick("^CFMT"); B <- pick("^BTWF")
F <- pick("^Face Detection"); M <- pick("^Mooney"); S <- pick("Silhouettes")

chk("BTWF exact zeros", 19, sum(d[[B]] == 0))
chk("rows with zero on Mooney or Silhouettes", 3,
    sum(d[[M]] == 0 | d[[S]] == 0))

# ---- 2. Table 4 reproduction (saved cell file) ----
x85 <- read.csv("results/face_recognition_table4_complete_85.csv")
chk("correlations in Table 4 audit", 85, nrow(x85))

t4 <- read.csv("results/table4_cell_verification.csv")
chk("cells matching published value at 2 dp", 77,
    sum(abs(round(t4$r, 2) - t4$published) < 1e-9, na.rm = TRUE))

p85 <- p.adjust(x85$p_value, method = "BH")
chk("BH < .20, 85-test family", 8, sum(p85 < .20))
chk("BH < .05, 85-test family", 5, sum(p85 < .05))

# ---- 3. Face-face correlations, N = 107 and N = 104 ----
face_pairs <- function(dat) {
  fv <- c(G, C, B, F, M)
  pr <- combn(fv, 2)
  r  <- apply(pr, 2, function(p) cor(dat[[p[1]]], dat[[p[2]]]))
  p  <- apply(pr, 2, function(p) cor.test(dat[[p[1]]], dat[[p[2]]])$p.value)
  names(r) <- names(p) <- apply(pr, 2, paste, collapse = "|")
  list(r = r, p = p, bh = p.adjust(p, "BH"))
}

ff <- face_pairs(d)
chk("GFMT-CFMT r", .50, ff$r[paste(G, C, sep = "|")], .005)
chk("GFMT-BTWF r", .20, ff$r[paste(G, B, sep = "|")], .005)
chk("CFMT-BTWF r", .33, ff$r[paste(C, B, sep = "|")], .005)
chk("CFMT-Mooney BH p (N = 107)", .055, ff$bh[paste(C, M, sep = "|")], .001)
chk("face-face pairs BH < .05 (N = 107)", 3, sum(ff$bh < .05))
chk("face-face pairs BH < .20 (N = 107)", 6, sum(ff$bh < .20))

keep <- !(d[[M]] == 0 | d[[S]] == 0)
ff104 <- face_pairs(d[keep, ])
chk("CFMT-Mooney r (N = 104)", .267, ff104$r[paste(C, M, sep = "|")], .0005)
chk("CFMT-Mooney BH p (N = 104)", .015, ff104$bh[paste(C, M, sep = "|")], .0005)
chk("face-face pairs BH < .05 (N = 104)", 4, sum(ff104$bh < .05))
chk("face-face pairs BH < .20 (N = 104)", 6, sum(ff104$bh < .20))

# ---- 4. One-factor CFA (refit) ----
dz <- as.data.frame(scale(d[, c(G, C, B, F, M)]))
colnames(dz) <- c("GFMT", "CFMT", "BTWF", "FaceDet", "Mooney")
fit1 <- cfa("g =~ GFMT + CFMT + BTWF + FaceDet + Mooney",
            data = dz, std.lv = TRUE)
fm <- fitMeasures(fit1, c("chisq", "df", "pvalue", "cfi", "tli", "rmsea", "srmr"))
chk("one-factor chi-square", 9.096, fm["chisq"], .001)
chk("one-factor df", 5, fm["df"])
chk("one-factor CFI", .920, fm["cfi"], .0005)
chk("one-factor TLI", .841, fm["tli"], .0005)
chk("one-factor RMSEA", .087, fm["rmsea"], .0005)
chk("one-factor SRMR", .069, fm["srmr"], .0005)

sl <- standardizedSolution(fit1)
lam <- sl$est.std[sl$op == "=~"]
chk("loading GFMT", .580, lam[1], .0005)
chk("loading CFMT", .853, lam[2], .0005)
chk("loading BTWF", .393, lam[3], .0005)
chk("loading Face detection", .185, lam[4], .0005)
chk("loading Mooney", .270, lam[5], .0005)
chk("variance explained (mean squared loading)", .265, mean(lam^2), .0005)

# ---- 5. Bootstrap of variance explained (saved rerun) ----
bt <- readRDS("outputs/cfa_boot_conditions_rerun.rds")
invalid <- bt$cond$zero_var | bt$cond$neg_var
chk("boundary-solution resamples", 193, sum(invalid))
chk("valid resamples", 807, sum(!invalid))
valid <- bt$ve[!invalid]
chk("valid-resample 2.5th percentile", .213, quantile(valid, .025), .0005)
chk("valid-resample 97.5th percentile", .333, quantile(valid, .975), .0005)

# ---- 6. Network edge counts ----
R <- cor(d, method = "spearman", use = "pairwise.complete.obs")
n_edges <- function(g) {
  net <- suppressWarnings(EBICglasso(R, n = nrow(d), gamma = g))
  sum(net[upper.tri(net)] != 0)
}
chk("edges at gamma = 0", 46, n_edges(0))
chk("edges at gamma = .10", 17, n_edges(.10))

net10 <- suppressWarnings(EBICglasso(R, n = nrow(d), gamma = .10))
idx <- which(upper.tri(net10), arr.ind = TRUE)
ed <- data.frame(node1 = colnames(net10)[idx[, 1]],
                 node2 = colnames(net10)[idx[, 2]],
                 weight = net10[upper.tri(net10)])
ed <- ed[ed$weight != 0, ]

# ---- 7. Centrality stability (saved output) ----
cs <- read.csv("outputs/centrality_stability_gamma010.csv")
chk("CS strength", .206, cs$CS_Coefficient[cs$Centrality == "strength"], .0005)
chk("CS closeness", 0, cs$CS_Coefficient[cs$Centrality == "closeness"])
chk("CS betweenness", 0, cs$CS_Coefficient[cs$Centrality == "betweenness"])

# ---- 8. Edge bootstrap at gamma = .10 (saved output) ----
norm <- function(x) gsub("[^A-Za-z0-9]", "", x)
ed$key <- paste(norm(ed$node1), norm(ed$node2), sep = "|")
eg <- read.csv("outputs/edge_accuracy_gamma010.csv", stringsAsFactors = FALSE)
eg$key <- paste(norm(eg$node1), norm(eg$node2), sep = "|")
eg_idx <- match(ed$key, eg$key)
chk("retained edges matched to bootstrap", 17, sum(!is.na(eg_idx)))
m3 <- cbind(ed, eg[eg_idx, c("q2.5", "q97.5", "prop0")])
chk("edges with CI excluding zero", 3, sum(m3$q2.5 > 0 | m3$q97.5 < 0))

# ---- Report ----
print(res, right = FALSE)
cat("\nPASS:", sum(res$status == "PASS"), " FAIL:", sum(res$status == "FAIL"), "\n")
write.csv(res, "results/manuscript_verification.csv", row.names = FALSE)
