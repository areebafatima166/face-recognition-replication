setwd("C:/Users/PMLS/Documents/face_recognition_replication")

library(readxl)

# Load Study 2
s2 <- read_excel("data/raw/Additional_file_1.xlsx", sheet = "Study 2")

# Define the five face-processing measures
face_vars <- c(
  "GFMT Accuracy (%)",
  "CFMT Accuracy (%)",
  "BTWF Accuracy (%)",
  "Face Detection (%)",
  "Mooney Faces (%)"
)

# Define the 13 comparison measures from Table 4
other_vars <- c(
  "VOSP PD (%)",
  "BORB Total (%)",
  "Letter Detection (%)",
  "Navon Global (%)",
  "Navon Local (%)",
  "MFFT (%)",
  "Silhouettes Total (%)",
  "BADS Card Sorting (%)",
  "Big Five Extraversion",
  "Big Five Agreeableness",
  "Big Five Conscientousness",
  "Big Five Neuroticism",
  "Big Five Openness",
  "IRI Perspective Taking",
  "IRI Fantasy Scale",
  "IRI Empathic Concern",
  "IRI Personal Distress"
)

# Check that all required columns exist
required_vars <- c(face_vars, other_vars)
missing_vars <- setdiff(required_vars, names(s2))

if (length(missing_vars) > 0) {
  stop("Missing columns: ", paste(missing_vars, collapse = ", "))
}

# Check that the selected columns are numeric
non_numeric <- required_vars[!vapply(s2[required_vars], is.numeric, logical(1))]

if (length(non_numeric) > 0) {
  stop("These columns are not numeric: ", paste(non_numeric, collapse = ", "))
}

# Calculate descriptive statistics for the five face measures
descriptives <- do.call(rbind, lapply(face_vars, function(v) {
  x <- s2[[v]]
  data.frame(
    variable = v,
    N = sum(!is.na(x)),
    Mean = mean(x, na.rm = TRUE),
    SD = sd(x, na.rm = TRUE),
    Minimum = min(x, na.rm = TRUE),
    Maximum = max(x, na.rm = TRUE)
  )
}))

# Calculate Pearson correlations, confidence intervals, and p-values
results <- list()
k <- 1

for (face in face_vars) {
  for (other in other_vars) {
    x <- s2[[face]]
    y <- s2[[other]]
    keep <- complete.cases(x, y)
    x <- x[keep]
    y <- y[keep]
    n <- length(x)

    if (n < 4) {
      stop("Too few complete observations for: ", face, " and ", other)
    }

    test <- cor.test(x, y, method = "pearson")
    r <- unname(test$estimate)
    ci <- unname(test$conf.int)

    results[[k]] <- data.frame(
      face_measure = face,
      comparison_measure = other,
      N = n,
      r = r,
      CI_lower = ci[1],
      CI_upper = ci[2],
      p_value = test$p.value
    )
    k <- k + 1
  }
}

correlations <- do.call(rbind, results)

# Adjust the 65 p-values using the Benjamini-Hochberg procedure
correlations$p_adjusted_BH <- p.adjust(correlations$p_value, method = "BH")

# Save the results
dir.create("results", showWarnings = FALSE)
write.csv(descriptives,
          "results/face_recognition_descriptive_statistics.csv",
          row.names = FALSE)
write.csv(correlations,
          "results/face_recognition_original_table4_all_correlations.csv",
          row.names = FALSE)

# Findings using the original Table 4 adjusted-p threshold of .20
findings <- correlations[correlations$p_adjusted_BH < .20, ]
findings <- findings[order(findings$p_adjusted_BH), ]
write.csv(findings,
          "results/face_recognition_original_table4_corrected_findings.csv",
          row.names = FALSE)

# Print a summary
cat("Participants/rows:", nrow(s2), "\n")
cat("Number of correlations:", nrow(correlations), "\n")
cat("Raw p < .05:", sum(correlations$p_value < .05), "\n")
cat("BH-adjusted p < .05:", sum(correlations$p_adjusted_BH < .05), "\n")
cat("BH-adjusted p < .20:", sum(correlations$p_adjusted_BH < .20), "\n")

print(findings)

# Record the R environment
writeLines(capture.output(sessionInfo()), "results/session_info.txt")
