
## Reproduced results (Study 2, n = 107)

GFMT–CFMT r = .50; GFMT–BTWF r = .20; CFMT–BTWF r = .33. All match the paper at two decimals.

Of the 85 correlations between face measures and other measures in Table 4, 77 reproduced to two decimals.

## Table 4 discrepancies

Eight cells differ from the published values:

| Pair | Published | Reanalysis | Note |
|---|---|---|---|
| Face detection × Extraversion | −.05 | .04 (.0445) | Published CI [−0.15, 0.23] is centred on .04 |
| BTWF × Openness | .01 | .10 (.0959) | Published CI [−0.10, 0.28] is centred on about .09 |
| CFMT × Personal Distress | .01 | .00 (.0019) | Difference of .008 |
| CFMT × Perspective Taking | .08 | .07 (.0747) | Difference of .005 |
| CFMT × MFFT | .02 | .03 (.0262) | Difference of .006 |
| CFMT × Navon Global | −.10 | −.09 (−.0940) | Difference of .006 |
| CFMT × Agreeableness | −.07 | −.06 (−.0650) | Difference of .005 |
| Face detection × Empathic Concern | −.06 | −.05 (−.0547) | Difference of .005 |

The corresponding author was contacted about the first three cells. He replied that he suspects transcription errors and will check the original data when able. The cause of all eight discrepancies remains unconfirmed.

## Multiple comparisons

The original article does not state its correction family, so two families are reported.

- **85 non-face correlations:** BH correction across all 85. At FDR .20, eight correlations are significant. These are the eight findings marked "d" in the published Table 4, and they are reproduced exactly. At FDR .05, five remain significant.
- **Face–face pairs:** BH correction across the ten pairs. At BH < .05, three pairs are significant: GFMT–CFMT, CFMT–BTWF, and face detection–Mooney. At BH < .20, six are significant. The published text reports only GFMT–CFMT and CFMT–BTWF, which matches the .05 threshold, not .20.

## One-factor confirmatory factor analysis (not preregistered)

A one-factor model of the five face measures tests the general face-factor account proposed by McCaffery et al. (2018) and Verhallen et al. (2017). It was fitted with lavaan 0.7.3 (`scripts/06_cfa_one_factor.R`), using maximum likelihood, standardised variables, and the latent variance fixed at 1. Fit is judged against conventional cutoffs (CFI ≥ .95, RMSEA ≤ .06, SRMR ≤ .08; Hu & Bentler, 1999).

**Fit:** χ²(5) = 9.10, p = .105; CFI = .920; TLI = .841; RMSEA = .087, 90% CI [.000, .177]; SRMR = .069. CFI and RMSEA fall short of the cutoffs. SRMR meets its cutoff.

**Loadings:** CFMT .85, GFMT .58, BTWF .39, Mooney .27, face detection .19. The general factor is defined mainly by CFMT and GFMT.

**Variance explained:** .265, the mean of the squared standardised loadings. This matches the original authors' estimate of about 25% of variance.

**Bootstrap:** 1,000 resamples, fitted with `bounds = "pos.var"`. In 193 resamples (19.3%), at least one residual variance was exactly zero, which is a boundary solution. No resample failed to converge, produced an error, or had a loading above 1. The 807 resamples without a boundary solution gave a 95% interval of [.213, .333]. This interval is a sensitivity check and is not a reliable estimate of the sampling distribution.

**Output files:**
- `outputs/cfa_one_factor.txt`, `outputs/cfa_two_factor.txt`, `outputs/cfa_model_comparison.txt`, `outputs/cfa_two_factor_noCFMT.txt`
- `outputs/cfa_boot_conditions_rerun.rds`: per-resample conditions (error, non-convergence, loading above 1, negative variance, zero variance), variance-explained values, and the boundary-solution flag.

The earlier file `outputs/cfa_boot_1000_bounded.rds` reported 116 invalid resamples. Its procedure cannot be reproduced from the current code, so it is not used for any reported result.

## Exploratory two-factor model (post hoc)

After the one-factor results were examined, a two-factor model separated identity measures (GFMT, CFMT, BTWF) from perception measures (face detection, Mooney faces). It fits better than the one-factor model, Δχ²(1) = 7.44, p = .006. Because it was specified after inspecting the one-factor results, it is exploratory. Its identity factor depends heavily on CFMT. Without CFMT, the identity factor is weak (GFMT .35, BTWF .56), and the factor correlation is imprecise (r = .50, 95% CI [−.02, 1.01]).

## Exploratory network analysis

A Spearman-correlation network of all 22 variables was estimated with EBICglasso (qgraph, bootnet).

- The primary network at γ = .10 retains 17 edges. It was chosen after inspecting the sweep and is not preregistered.
- A sensitivity network at γ = 0 retains 46 edges.
- At γ = .05 through .30, the same 17 edges are retained. At γ = .50, none are retained.
- Of the 17 primary-network edges, three have bootstrap intervals excluding zero: Neuroticism–Personal Distress, Perspective Taking–Empathic Concern, and GFMT–CFMT, all positive. Bootstrap statistics for all 17 edges are in `outputs/edge_accuracy_gamma010.csv`.

**Case-dropping centrality stability** at γ = .10 (`outputs/centrality_stability_gamma010.csv`): strength CS = .206, closeness CS = 0, betweenness CS = 0. Node rankings should not be interpreted.

## Known limitations and open items

- BTWF contains 19 zero scores (17.8%). The published text reports 20%, about 21 participants. The difference is unresolved.
- The network tuning parameter was selected after inspecting the sweep.
- The CFA bootstrap uses positive-variance bounds, and 19.3% of resamples are boundary solutions.
- Table 4 discrepancies are unconfirmed pending the author's check of the original data.

## Citation

McCaffery, J. M., Robertson, D. J., Young, A. W., & Burton, A. M. (2018). Individual differences in face identity processing. *Cognitive Research: Principles and Implications*, 3, Article 21. https://doi.org/10.1186/s41235-018-0112-9

Reanalysis code commit: `2a9a9636958bbdcf9098dc5ecdd569cb6368a88f`

## Author

Areeba Fatima, Riphah International University, Lahore, Pakistan (alumna). ORCID: https://orcid.org/0009-0002-3981-3319

## Licence

- **Code** (scripts in `scripts/` and `verify_manuscript.R`): MIT License. See `LICENSE`.
- **Documentation** (README and manuscript): Creative Commons Attribution 4.0 International (CC BY 4.0).
- **Data:** Additional file 1 of McCaffery et al. (2018) is distributed under CC BY 4.0 by the original authors. It is not redistributed in this repository.
