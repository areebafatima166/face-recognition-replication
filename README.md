# Replication of Individual Differences in Face Identity Processing

## Project overview

This project examines individual differences in face identity processing using supplementary data from McCaffery et al. (2018). It includes a reproduction of selected correlation analyses and exploratory network analyses.

**Scope:** The current Table 4 script reproduces 65 Pearson correlations between five face-processing measures and 13 additional measures in Study 2 (N = 107). This is a partial reproduction of the published analyses, not a complete replication of the original study.

## Source publication

McCaffery, J. M., Robertson, D. J., Young, A. W., & Burton, A. M. (2018). Individual differences in face identity processing. *Cognitive Research: Principles and Implications, 3*, Article 21.

https://doi.org/10.1186/s41235-018-0112-9

The supplementary dataset is identified in the project materials as CC BY 4.0. Consult the source record and license before redistributing the data.

## Data

- Source file: `data/raw/Additional_file_1.xlsx`
- Worksheet: `Study 2`
- Sample size: 107 rows
- Dataset columns: 23
- Variables used in the Table 4 analysis: 18

The source dataset is not reproduced in this README. The current script reports zero missing values among the 18 selected analysis variables. Potential zero-coded values elsewhere in the dataset have not been independently verified against the authors' codebook.

## Table 4 correlation analysis

Five face-processing measures are correlated with 17 additional measures, producing 85 Pearson correlation tests (`scripts/03_reproduce_table4.R`).

The script calculates Pearson's r, 95% confidence intervals, raw p-values, and Benjamini-Hochberg adjusted p-values across all 85 tests.

### Current results

| Summary | Result |
|---|---:|
| Participants | 107 |
| Correlation tests | 85 |
| Raw p-values below .05 | 10 |
| BH-adjusted p-values below .05 | 5 |
| BH-adjusted p-values below .20 | 8 |

The .20 threshold is reported separately from the conventional .05 threshold, matching the original article's criterion. The eight results meeting the .20 threshold are listed in `results/face_recognition_original_table4_corrected_findings.csv`.

The reanalysis was compared with the published Table 4 values in `scripts/05_table4_comparison.R`. See the discrepancy section below.

The calculated results should be checked pair by pair against the original publication before being described as exact replications of its findings.

## Table 4 discrepancies

The reanalysis reproduces all 85 correlations in Table 4 (`scripts/03_reproduce_table4.R`). Compared with the published values (`scripts/05_table4_comparison.R`), 77 cells fall within the published rounding band (the published two-decimal value ± .005). Eight cells fall outside it:

| Pair | Published | Reanalysis | Outside band by |
|---|---|---|---|
| Face detection × Extraversion | −.05 | .0445 | .090 |
| BTWF × Openness | .01 | .0959 | .081 |
| CFMT × Personal Distress | .01 | .0019 | .003 |
| CFMT × Perspective Taking | .08 | .0747 | .0003 |
| CFMT × MFFT | .02 | .0262 | .001 |
| CFMT × Navon Global | −.10 | −.0940 | .001 |
| CFMT × Agreeableness | −.07 | −.0650 | .00003 |
| Face detection × Empathic Concern | −.06 | −.0547 | .0003 |

Two discrepancies are too large to be rounding: Face detection × Extraversion and BTWF × Openness. In the published table, the confidence intervals for both cells are centred on the reanalysis values (about .04 and .09), which suggests the printed point estimates may be wrong. The other six cells lie within 0.003 of the band and may reflect rounding or last-digit differences.

The cause of all eight discrepancies is unconfirmed. The corresponding author has been contacted about some of these cells, and he suspects transcription errors and will check the original data when able.

## Exploratory network analysis

The repository also contains an exploratory partial-correlation network analysis. The existing project notes report that the estimated network changed under alternative tuning settings. Therefore, network findings are considered exploratory and require cautious interpretation and independent confirmation.

See the existing analysis scripts and outputs for details. The network analysis is separate from the 65 Pearson correlations described above.

## Project structure

```text
face_recognition_replication/
├── data/
│   └── raw/
│       └── Additional_file_1.xlsx
├── scripts/
│   ├── 02_replication.R
│   ├── 03_network.R
│   ├── 03_reproduce_table4.R
│   └── 04_network_stability.R
├── results/
│   ├── face_recognition_descriptive_statistics.csv
│   ├── face_recognition_original_table4_all_correlations.csv
│   ├── face_recognition_original_table4_corrected_findings.csv
│   └── session_info.txt
├── docs/
│   └── replication_report.md
├── outputs/
└── README.md
```

## How to reproduce the Table 4 analysis

1. Install R and RStudio.
2. Obtain the supplementary dataset from the source publication and place it at `data/raw/Additional_file_1.xlsx`.
3. Open the project file `face_recognition_replication.Rproj` in RStudio.
4. Open `scripts/03_reproduce_table4.R`.
5. Run the script using the **Source** button.
6. Review the generated CSV files in `results/`.

The script checks the required column names and numeric data types before calculating correlations. It uses the `readxl` package to import the workbook.

## Documentation

- `docs/replication_report.md`: methods, results, reproducibility notes, and limitations.
- `results/session_info.txt`: R session and package information from the analysis run.
- `README_backup_before_update.md`: backup of the README that preceded this update, if retained in the project.

## Limitations

- The current Table 4 script reproduces only a defined subset of the original study's analyses.
- Correlations are observational and do not establish causation.
- Multiple-comparison conclusions depend on the family of tests and correction threshold.
- Potential zero-coded values require verification against the original scoring documentation.
- Exploratory network results may be sensitive to tuning parameters and sample characteristics.

## Research integrity

This repository aims to make the analysis workflow transparent and reproducible. Claims of replication should be limited to analyses that have been checked against the original publication. The supplementary data should be redistributed only in accordance with its applicable license and attribution requirements.
