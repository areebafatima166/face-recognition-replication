# Replication of face identity processing individual differences

Source: McCaffery, Robertson, Young & Burton (2018). Individual differences in face identity processing. Cognitive Research: Principles and Implications, 3:21. DOI 10.1186/s41235-018-0112-9.

Data: Additional file 1 (CC BY 4.0). Not included in this repository; download it from the DOI.

## Reproduced results (Study 2, n = 107)
- GFMT-CFMT r = .50; GFMT-BTWF r = .20; CFMT-BTWF r = .33. All match the paper.
- Eight face-to-other correlations reported in the text match to two decimals.

## Table 4 comparison (Study 2)
Of 85 correlations in Table 4, 77 reproduced the published values to two decimals. Five further cells differed by one hundredth or less, consistent with rounding. Three point estimates differed beyond rounding:
- Face-detection x Big 5 Extraversion: published r = -.05; reanalysis r = +.04 (.0445). The published 95% CI [-0.15, 0.23] matches ours.
- BTWF x Big 5 Openness: published r = .01; reanalysis r = .10 (.096).
- CFMT x IRI Personal Distress: published r = .01; reanalysis r = .00 (.0019).

We wrote to the corresponding author about these cells. He replied that he expects the differences to reflect transcription errors and will check the original data when able. The cells remain unresolved pending that check.

## Multiple comparisons
The paper does not state its correction family, so two families are reported:
- Face-face (3 tests): GFMT-BTWF survives Benjamini-Hochberg correction (p_BH = .039).
- All 88 tests: GFMT-CFMT and CFMT-BTWF survive; GFMT-BTWF does not (p_BH = .264).
This split is our reconstruction, not the authors' procedure.

## Factor analysis (preregistered and exploratory)
A one-factor confirmatory factor model of the five face measures did not meet the preregistered fit criteria: χ²(5) = 9.10, p = .105; CFI = .92; RMSEA = .087 [.000, .177]; SRMR = .069. The general factor was defined mainly by CFMT (loading .85) and GFMT (.58); face detection's loading did not differ from zero.

The preregistered variance-explained estimate was .265. It could not be evaluated reliably: 116 of 1000 bootstrap solutions (11.6%) were Heywood or out-of-range cases even with positive-variance bounds (`bounds = "pos.var"`), a deviation from the preregistration. The valid-solution interval [.22, .34] is a sensitivity check only and is not a test of H2.

A two-factor model separating identity from perception tasks fit better than the one-factor model (Δχ²(1) = 7.44, p = .006). This model was specified after the preregistered test failed and is exploratory. Its identity factor depends on CFMT: without CFMT, the two-factor structure is still estimable, but the identity factor is weak (GFMT .36, BTWF .56) and the factor correlation is uncertain (r = .50, 95% CI [-.02, 1.01]).

## Network analysis (exploratory)
A 22-measure Spearman partial-correlation network (n = 107; EBICglasso; tuning = 0) gave a GFMT-CFMT partial r of .30, 95% bootstrap CI [.14, .46], nonzero in all 1000 resamples. Tuning = 0 was chosen after tuning = 0.5 returned an empty network, so this choice is post hoc. The edge was present at tuning = 0.25 (r = .21) and in a reduced sample excluding three rows with zero-coded scores (n = 104, r = .27). It was absent at tuning = 0.5.

We treat this as a candidate association requiring confirmation in an independent sample, not as an established feature of the network. Two exploratory checks are not in the scripts: the tuning = 0.25 network (17 edges) and a case-dropping stability analysis (CS = 0.28).

## Files
- scripts/02_replication.R: correlations, correction families, face-to-other checks.
- scripts/03_network.R: network and bootstrap. Requires readxl, bootnet, qgraph.
- scripts/05_table4_comparison.R: comparison of reanalysis against published Table 4 values.
- scripts/06_cfa_preregistered.R: preregistered one-factor CFA and bounded bootstrap of variance explained (H1, H2).
- scripts/07_cfa_sensitivity.R: exploratory two-factor model and post hoc no-CFMT sensitivity check.
