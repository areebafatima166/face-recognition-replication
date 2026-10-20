file.exists(c("scripts/02_replication.R", "scripts/03_network.R"))
[1] TRUE TRUE
> library(readxl)
> s2 <- read_excel('data/raw/Additional_file_1.xlsx', sheet = 'Study 2')
> face <- s2[, c('GFMT Accuracy (%)', 'CFMT Accuracy (%)', 'BTWF Accuracy (%)')]
> names(face) <- c('GFMT', 'CFMT', 'BTWF')
> cor.test(face$GFMT, face$CFMT)

	Pearson's product-moment correlation

data:  face$GFMT and face$CFMT
t = 5.9872, df = 105, p-value = 3.017e-08
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.3479546 0.6336523
sample estimates:
      cor 
0.5044856 

> cor.test(face$GFMT, face$BTWF)

	Pearson's product-moment correlation

data:  face$GFMT and face$BTWF
t = 2.0903, df = 105, p-value = 0.039
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.01041665 0.37548880
sample estimates:
      cor 
0.1998798 

> cor.test(face$CFMT, face$BTWF)

	Pearson's product-moment correlation

data:  face$CFMT and face$BTWF
t = 3.6216, df = 105, p-value = 0.0004528
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.1530523 0.4919616
sample estimates:
      cor 
0.3332276 

> 
