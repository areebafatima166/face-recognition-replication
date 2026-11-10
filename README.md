# Replication of Individual Differences in Face Identity Processing

## Project overview

This project examines individual differences in face identity processing using supplementary data from McCaffery et al. (2018). It includes a reproduction of selected correlation analyses and exploratory network analyses.

**Scope:** The Table 4 script reproduces all 85 Pearson correlations between five face-processing measures and 17 additional measures in Study 2 (N = 107). This is a reproduction of the published correlation analysis, not a complete replication of the original study.

## Source publication

McCaffery, J. M., Robertson, D. J., Young, A. W., & Burton, A. M. (2018). Individual differences in face identity processing. *Cognitive Research: Principles and Implications, 3*, Article 21.

https://doi.org/10.1186/s41235-018-0112-9

The supplementary dataset is identified in the project materials as CC BY 4.0. Consult the source record and license before redistributing the data.

## Data

- Source file: `data/raw/Additional_file_1.xlsx`
- Worksheet: `Study 2`
- Sample size: 107 rows
- Dataset columns: 23
- Variables used in the Table 4 analysis: 22 (5 face measures and 17 comparison measures)

The source dataset is not reproduced in this README. The current script reports zero missing values among the 22 selected analysis variables. Potential zero-coded values elsewhere in the dataset have not been independently verified against the authors' codebook.

## Table 4 correlation analysis

Five face-processing measures are correlated with 17 additional measures, producing 85 Pearson correlation tests (`scripts/03_reproduce_table4.R`). For each test the script computes Pearson's r, a 95% confidence interval, a raw p-value, and a Benjamini-Hochberg adjusted p-value.

### Reproduction

All 85 correlations were recomputed. Compared with the published values (`scripts/05_table4_comparison.R`), 77 match to two decimals. Eight do not match to two decimals, described below.

### Current results (Study 2, n = 107)

| Summary | Result |
|---|---:|
| Participants | 107 |
| Correlation tests | 85 |
| Raw p-values below .05 | 10 |
| BH-adjusted p-values below .05 | 5 |
| BH-adjusted p-values below .20 | 8 |

The .20 threshold is reported alongside the conventional .05 threshold, following the original article's criterion. The eight correlations significant at BH < .20 are the eight marked as significant in the published table, and they are listed in `results/face_recognition_original_table4_corrected_findings.csv`.

### Multiple comparisons

The original article does not state its correction family, so two families are reported.

- **Table 4 correlations (85 tests):** Benjamini-Hochberg correction across all 85. Eight are significant at BH < .20 and five at BH < .05. Ten are significant before correction (p < .05).
- **Face-face pairs (10 tests):** Benjamini-Hochberg correction across the ten pairs. Three pairs are significant at BH < .05: GFMT–CFMT, CFMT–BTWF, and face detection–Mooney. Six are significant at BH < .20. The published text reports GFMT–CFMT and CFMT–BTWF, which matches the .05 threshold rather than .20.

## Table 4 discrepancies

Compared with the published values, 77 cells fall within the published two-decimal rounding band (the published value ± .005). Eight cells fall outside it:

| Pair | Published | Reanalysis | Outside band by |
|---|---|---|---|
| Face detection × Extraversion | −.05 | .0445 | .090 |
| BTWF × Openness | .01 | .0959 | .081 |
| CFMT × Personal Distress | .01 | .0019 | .003 |
| CFMT × MFFT | .02 | .0262 | .001 |
| CFMT × Navon Global | −.10 | −.0940 | .001 |
| CFMT × Perspective Taking | .08 | .0747 | .0003 |
| Face detection × Empathic Concern | −.06 | −.0547 | .0003 |
| CFMT × Agreeableness | −.07 | −.0650 | .00003 |

Two discrepancies are too large to be rounding: face detection × Extraversion and BTWF × Openness. The published 95% confidence intervals for these cells are centred on the reanalysis values (Extraversion [−0.15, 0.23], midpoint .04; Openness [−0.10, 0.28], midpoint about .09). This suggests the printed point estimates may be wrong. The other six cells lie within .003 of the rounding band and may reflect rounding or last-digit differences.

The corresponding author has been contacted about three cells (face detection × Extraversion, BTWF × Openness, and CFMT × Personal Distress). He suspects transcription errors and will check the original data when able. The cause of all eight discrepancies is unconfirmed.

## Exploratory network analysis

The primary network at γ = .10 retains 17 edges; the sensitivity network at γ = 0 retains 46. Three edges have bootstrap intervals excluding zero: Neuroticism–Personal Distress, Perspective Taking–Empathic Concern, and GFMT–CFMT. Case-dropping stability at γ = .10 gives strength CS = .206, but 350 of 1,000 draws produced an empty network, so this estimate partly reflects network collapse. Node rankings should not be interpreted.

The network results are exploratory: the tuning parameter was chosen after inspecting the sweep, and the network analysis is separate from the 85 Pearson correlations described above.

## Project structure

```text
face_recognition_replication/
├── data/raw/                                 (not published; see below)
│   └── Additional_file_1.xlsx
├── scripts/
│   ├── 02_replication.R                      correlations and correction families
│   ├── 03_network.R                          exploratory network and bootstrap
│   ├── 03_reproduce_table4.R                 85 Table 4 correlations
│   ├── 04_network_stability.R                case-dropping stability
│   ├── 05_table4_comparison.R                comparison with published values
│   ├── 06_cfa_one_factor.R                   one-factor CFA and bootstrap
│   └── 07_cfa_sensitivity.R                  exploratory two-factor model
├── verify_manuscript.R                       recomputes key manuscript values
├── results/                                  summary tables and verification output
├── outputs/                                  model fits, bootstrap files, network outputs
└── README.md
```

## How to reproduce the Table 4 analysis

1. Install R and RStudio.
2. Obtain the supplementary dataset from the source publication and place it at `data/raw/Additional_file_1.xlsx`.
3. Set the working directory to the project root.
4. Run the scripts in `scripts/` in order: `02` through `07`, then `verify_manuscript.R`.
5. Check the output with `verify_manuscript.R` (expected: 43 of 43 checks pass).
6. Review the generated CSV files in `results/`.

The script checks the required column names and numeric data types before calculating correlations. It uses the `readxl` package to import the workbook.

## Documentation

- `results/session_info.txt`: R session and package information from the analysis run.

## Limitations

- The current Table 4 script reproduces only a defined subset of the original study's analyses.
- Correlations are observational and do not establish causation.
- Multiple-comparison conclusions depend on the family of tests and correction threshold.
- Potential zero-coded values require verification against the original scoring documentation.
- Exploratory network results may be sensitive to tuning parameters and sample characteristics.

## Research integrity

This repository aims to make the analysis workflow transparent and reproducible. Claims of replication should be limited to analyses that have been checked against the original publication. The supplementary data should be redistributed only in accordance with its applicable license and attribution requirements.

## Author

Areeba Fatima, Riphah International University, Lahore, Pakistan (alumna). ORCID: https://orcid.org/0009-0002-3981-3319

## Licence

- **Code** (scripts in `scripts/` and `verify_manuscript.R`): MIT License. See `LICENSE`.
- **Documentation** (README and manuscript): Creative Commons Attribution 4.0 International (CC BY 4.0).
- **Data:** Additional file 1 of McCaffery et al. (2018) is distributed under CC BY 4.0 by the original authors. It is not redistributed in this repository.

## Citation

McCaffery, J. M., Robertson, D. J., Young, A. W., & Burton, A. M. (2018). Individual differences in face identity processing. *Cognitive Research: Principles and Implications*, 3, Article 21. https://doi.org/10.1186/s41235-018-0112-9

Analysis code and outputs: commit `c4d3d33d52b209af0fa07526adbe6590b3fb0ffd`.
