# Table 4 comparison: McCaffery et al. (2018), Study 2
# Compares reanalysis correlations with published values

library(readxl)

faces <- c('GFMT Accuracy (%)', 'CFMT Accuracy (%)', 'BTWF Accuracy (%)',
           'Face Detection (%)', 'Mooney Faces (%)')
others <- c('VOSP PD (%)', 'BORB Total (%)', 'Letter Detection (%)',
            'Navon Global (%)', 'Navon Local (%)', 'MFFT (%)',
            'Silhouettes Total (%)', 'BADS Card Sorting (%)',
            'Big Five Extraversion', 'Big Five Agreeableness',
            'Big Five Conscientousness', 'Big Five Neuroticism',
            'Big Five Openness', 'IRI Perspective Taking',
            'IRI Fantasy Scale', 'IRI Empathic Concern',
            'IRI Personal Distress')

pub_mat <- rbind(
  c( .10,  .14,  .06, -.03,  .09),
  c( .13, -.05,  .06,  .01,  .33),
  c( .14,  .07,  .08,  .27,  .06),
  c(-.01, -.10,  .09,  .16, -.00),
  c( .27,  .03,  .03,  .16, -.01),
  c( .37,  .02, -.00,  .06,  .08),
  c( .14,  .29,  .29,  .12,  .50),
  c( .20,  .12,  .14, -.13,  .06),
  c( .03,  .00,  .04, -.05,  .07),
  c(-.05, -.07,  .02, -.14, -.01),
  c( .17,  .08, -.03, -.07, -.05),
  c( .02, -.05, -.04,  .02, -.01),
  c( .23,  .11,  .01,  .12,  .13),
  c( .17,  .08,  .13,  .03,  .03),
  c( .16,  .07,  .15,  .05, -.05),
  c( .20,  .06,  .06, -.06,  .10),
  c(-.10,  .01, -.06,  .03, -.02)
)

published <- data.frame(
  face_measure = rep(faces, times = length(others)),
  comparison_measure = rep(others, each = length(faces)),
  r_published = as.vector(t(pub_mat)),
  stringsAsFactors = FALSE
)

cmp <- merge(
  read.csv('results/face_recognition_table4_complete_85.csv'),
  published, by = c('face_measure', 'comparison_measure'), all.x = TRUE
)
cmp$match <- round(cmp$r, 2) == round(cmp$r_published, 2)
table(cmp$match, useNA = 'ifany')
cmp[which(!cmp$match), c('face_measure', 'comparison_measure', 'r', 'r_published')]

# Distance of each reanalysis value from the published rounding band
# (published value +/- .005). Zero means the reanalysis rounds to the published value.
cmp$dist_outside <- pmax(0, abs(cmp$r - cmp$r_published) - 0.005)
cmp$in_band <- cmp$dist_outside == 0
table(cmp$in_band, useNA = "ifany")
write.csv(cmp[!cmp$in_band, c("face_measure", "comparison_measure", "r", "r_published", "dist_outside")],
          "results/table4_discrepancies.csv", row.names = FALSE)
