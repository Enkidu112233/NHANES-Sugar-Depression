# Validation

## Source preservation

The package was built from the six latest supplied files. SHA-256 confirms that the three Stata datasets in the package are identical to the supplied datasets. Both cleaning scripts match the previous release after the same path and comment edits. The supplied analysis differs from the previous release in the fourth robustness check and adjacent blank lines. The packaged scripts preserve all executable source lines after normalizing input and output paths and excluding working-directory commands. See `source_manifest.json`, `code_preservation.json`, and `code_changes.diff`. Original absolute paths in the diff have been redacted.

## Stata runs

The default analysis and full rebuild-and-analysis routes were executed in Stata/MP 18 on Windows, with `gologit2` and `gsvy` 3.2.8 in `vendor/gologit2/`. Both runs deliberately loaded an older `gologit2` first to verify that the entry's refresh loads the project-local version instead. The dependency check also stopped the analysis early with an actionable error when the new extension was absent.

Both routes ran the fourth robustness check and completed all four sets of 2,000 bootstrap replications. The three regenerated datasets match the distributed references in variable names, row order, values including missing values, and data types. Comparison of file metadata, labels, and display formats was outside this check. The two routes gave the same baseline and partial proportional odds sugar estimates at Stata's printed precision. The baseline analysis subpopulation was 1,383 in cycle 10 and 1,084 in cycle 12, with 2,467 pooled. The two routes' printed bootstrap results for the indirect estimates also agreed.

## Partial proportional odds model

The model uses the pooled design with 30 strata and 60 primary sampling units and an analysis subpopulation of 2,467. `npl(avg_sugar)` permits four threshold-specific sugar coefficients and constrains the other coefficients across thresholds. The table reports log-odds coefficients from the validation run. The results have not been compared with typeset manuscript tables.

| Cumulative PHQ-9 threshold | Sugar coefficient | Standard error | 95% CI | p-value |
|---|---:|---:|---:|---:|
| ≥5 | 0.0020536 | 0.0014406 | [−0.0008885, 0.0049957] | 0.164 |
| ≥10 | 0.0027483 | 0.0014713 | [−0.0002564, 0.0057530] | 0.072 |
| ≥15 | 0.0033941 | 0.0017305 | [−0.0001400, 0.0069282] | 0.059 |
| ≥20 | 0.0027893 | 0.0027593 | [−0.0028459, 0.0084244] | 0.320 |

## Rebuild and methodological context

The 16 XPT inputs used for rebuilding match the reference hashes in `data/raw_manifest.csv`. Current CDC binary files were not re-downloaded for comparison. The code retains the pooled weights `wtdr2d/2` and `wtdrd1/2` and the authors' exploratory interpretation of cross-pandemic pooling. The nutrition stage retains matched dietary days. The PHQ-8 variable uses `phq9 - dpq030` as in the supplied cleaning scripts. The original merging, model covariates, sample rules, and bootstrap settings are preserved.
