library(readxl)
s2 <- read_excel('data/raw/Additional_file_1.xlsx', sheet = 'Study 2')
face <- s2[, c('GFMT Accuracy (%)', 'CFMT Accuracy (%)', 'BTWF Accuracy (%)')]
names(face) <- c('GFMT', 'CFMT', 'BTWF')
cor.test(face$GFMT, face$CFMT)
cor.test(face$GFMT, face$BTWF)
cor.test(face$CFMT, face$BTWF)
