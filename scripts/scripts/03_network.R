# Network analysis, McCaffery et al. (2018) Study 2 data
> # 22 measures, Spearman correlations, EBICglasso
> # TUNING = 0 was chosen after tuning = 0.5 returned an empty network (post hoc)
> # Bootstrap: 1000 nonparametric resamples, seed 2026
> 
> library(readxl); library(bootnet); library(qgraph)
> s2 <- read_excel('data/raw/Additional_file_1.xlsx', sheet = 'Study 2')
> face_cols  <- c('GFMT Accuracy (%)', 'CFMT Accuracy (%)', 'BTWF Accuracy (%)',
+                 'Face Detection (%)', 'Mooney Faces (%)')
> other_cols <- names(s2)[7:23]
> dat <- as.data.frame(s2[, c(face_cols, other_cols)])
> colnames(dat) <- make.names(colnames(dat))
> TUNING <- 0
> net <- estimateNetwork(dat, default = 'EBICglasso', corMethod = 'spearman', tuning = TUNING)
Estimating Network. Using package::function:
  - qgraph::EBICglasso for EBIC model selection
    - using glasso::glasso
> cat('edges:', sum(net$graph != 0) / 2, '\n')
edges: 46 
> set.seed(2026)
> boot_np <- bootnet(net, nBoots = 1000, type = 'nonparametric', statistics = 'edge')
Note: bootnet will store only the following statistics:  edge
Bootstrapping...
  |====================================================================| 100%
Computing statistics...
  |====================================================================| 100%
> bs <- summary(boot_np, statistics = 'edge')
> subset(bs, node1 == 'GFMT.Accuracy....' & node2 == 'CFMT.Accuracy....')
# A tibble: 1 × 17
# Groups:   type, node1, node2 [1]
  type  id         node1 node2 sample  mean     sd CIlower CIupper  q2.5 q97.5
  <chr> <chr>      <chr> <chr>  <dbl> <dbl>  <dbl>   <dbl>   <dbl> <dbl> <dbl>
1 edge  GFMT.Accu… GFMT… CFMT…  0.299 0.291 0.0791   0.141   0.457 0.130 0.434
# ℹ 6 more variables: q2.5_non0 <dbl>, mean_non0 <dbl>, q97.5_non0 <dbl>,
#   var_non0 <dbl>, sd_non0 <dbl>, prop0 <dbl>
> drop <- which(dat$Silhouettes.Total.... == 0 | dat$Mooney.Faces.... == 0)
> dat2 <- dat[-drop, ]
> net2 <- estimateNetwork(dat2, default = 'EBICglasso', corMethod = 'spearman', tuning = 0)
Estimating Network. Using package::function:
  - qgraph::EBICglasso for EBIC model selection
    - using glasso::glasso
> net2$graph[1, 2]
[1] 0.2711035
