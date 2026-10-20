file.edit("scripts/05_table4_comparison.R")
> # Table 4 comparison: McCaffery et al. (2018), Study 2
> # Compares reanalysis correlations with published values
> 
> library(readxl)
> 
> faces <- c('GFMT Accuracy (%)', 'CFMT Accuracy (%)', 'BTWF Accuracy (%)',
+            'Face Detection (%)', 'Mooney Faces (%)')
> others <- c('VOSP PD (%)', 'BORB Total (%)', 'Letter Detection (%)',
+             'Navon Global (%)', 'Navon Local (%)', 'MFFT (%)',
+             'Silhouettes Total (%)', 'BADS Card Sorting (%)',
+             'Big Five Extraversion', 'Big Five Agreeableness',
+             'Big Five Conscientousness', 'Big Five Neuroticism',
+             'Big Five Openness', 'IRI Perspective Taking',
+             'IRI Fantasy Scale', 'IRI Empathic Concern',
+             'IRI Personal Distress')
> 
> pub_mat <- rbind(
+   c( .10,  .14,  .06, -.03,  .09),
+   c( .13, -.05,  .06,  .01,  .33),
+   c( .14,  .07,  .08,  .27,  .06),
+   c(-.01, -.10,  .09,  .16, -.00),
+   c( .27,  .03,  .03,  .16, -.01),
+   c( .37,  .02, -.00,  .06,  .08),
+   c( .14,  .29,  .29,  .12,  .50),
+   c( .20,  .12,  .14, -.13,  .06),
+   c( .03,  .00,  .04, -.05,  .07),
+   c(-.05, -.07,  .02, -.14, -.01),
+   c( .17,  .08, -.03, -.07, -.05),
+   c( .02, -.05, -.04,  .02, -.01),
+   c( .23,  .11,  .01,  .12,  .13),
+   c( .17,  .08,  .13,  .03,  .03),
+   c( .16,  .07,  .15,  .05, -.05),
+   c( .20,  .06,  .06, -.06,  .10),
+   c(-.10,  .01, -.06,  .03, -.02)
+ )
> 
> published <- data.frame(
+   face_measure = rep(faces, times = length(others)),
+   comparison_measure = rep(others, each = length(faces)),
+   r_published = as.vector(t(pub_mat)),
+   stringsAsFactors = FALSE
+ )
> 
> cmp <- merge(
+   read.csv('results/face_recognition_table4_complete_85.csv'),
+   published, by = c('face_measure', 'comparison_measure'), all.x = TRUE
+ )
> cmp$match <- round(cmp$r, 2) == round(cmp$r_published, 2)
> table(cmp$match, useNA = 'ifany')

FALSE  TRUE 
    8    77 
> cmp[which(!cmp$match), c('face_measure', 'comparison_measure', 'r', 'r_published')]
         face_measure     comparison_measure            r r_published
6   BTWF Accuracy (%)      Big Five Openness  0.095946106        0.01
19  CFMT Accuracy (%) Big Five Agreeableness -0.064966667       -0.07
27  CFMT Accuracy (%)  IRI Personal Distress  0.001895277        0.01
28  CFMT Accuracy (%) IRI Perspective Taking  0.074720239        0.08
30  CFMT Accuracy (%)               MFFT (%)  0.026181267        0.02
31  CFMT Accuracy (%)       Navon Global (%) -0.094015645       -0.10
38 Face Detection (%)  Big Five Extraversion  0.044509424       -0.05
42 Face Detection (%)   IRI Empathic Concern -0.054736725       -0.06
