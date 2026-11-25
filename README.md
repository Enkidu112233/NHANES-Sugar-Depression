# NHANES sugar intake and depressive symptoms

Stata code and processed datasets for analyses of NHANES 2017–2018 and August 2021–August 2023. The three supplied datasets are included as received. The repository covers data preparation and statistical analysis. Manuscript table formatting and export are outside its scope.

## Stata and the required extension

The workflow was tested with Stata/MP 18 on Windows and `gologit2` 3.2.8. The fourth robustness check requires the `gologit2` extension and its companion command `gsvy`. They are distributed together.

1. Download [Richard Williams's gologit2 3.2.8 ZIP](https://academicweb.nd.edu/~rwilliam/gologit2/gologit2_ver3.2.8.zip).
2. Extract its contents. Put the extracted files directly in `vendor/gologit2/` so that `gologit2.ado` and `gsvy.ado` are both immediately inside that folder. Keep the other files from the same distribution alongside them.
3. Start Stata and run the workflow below. The master entry adds this folder to the current Stata session's search path, refreshes cached commands, and records the versions in the run log.

The extension is obtained separately from the author. If version 3.2.8 is already installed and discoverable by Stata, the project-local setup is optional. In that case `which gologit2` and `which gsvy` should both identify the tested version. Older installations such as 2.1.4 do not supply `gsvy`. See the [author's troubleshooting page](https://academicweb.nd.edu/~rwilliam/gologit2/tsfaq.html).

## Run the analysis

In Stata, change to the extracted repository folder containing this README. Replace the example path with your own.

```stata
cd "C:/path/to/NHANES-Sugar-Depression"
do code/00_master.do
```

The default entry uses `data/processed/final_two_cycles.dta` and writes results to `output/logs/analysis.log`. It runs the baseline models, robustness checks, subgroup analyses, and exploratory pathways, including four sets of 2,000 bootstrap replications. Each mode replaces its own log on rerun.

The fourth robustness check fits a survey-weighted partial proportional odds model with `gsvy` and `npl(avg_sugar)`. The coefficient for average dietary sugar intake can vary at the four cumulative PHQ-9 thresholds. Each adjustment variable, including cycle, has a common coefficient across thresholds. The analysis subpopulation and survey design come from the pooled main analysis. See [validation](docs/VALIDATION.md) for the estimation results used to check the workflow.

## Rebuild from original NHANES data

The [raw data guide](data/README.md) specifies the eight official XPT downloads for each cycle and their destination folders. Once those inputs are in place, run one of these commands from the repository root.

| Command | Result |
|---|---|
| `do code/00_master.do rebuild` | Rebuilds and appends both cycles. `do code/00_rebuild.do` is a shortcut. This mode uses Stata's built-in commands. |
| `do code/00_master.do full` | Rebuilds both cycles and runs the analysis on the rebuilt pooled file. Set up `gologit2` first. |

Rebuild and full modes use double precision for newly created numeric variables and restore the previous setting on exit. The rebuilt pooled file is `work/2021_2023/final_two_cycles.dta`. The three distributed files in `data/processed/` serve as reference datasets.

## Repository layout

```text
code/
  00_master.do                    analysis, rebuild, and full modes
  00_check_dependencies.do        Stata extension check
  00_rebuild.do                   shortcut for rebuilding data
  01_cleaning_2017_2018.do         first-cycle cleaning
  02_cleaning_2021_2023.do         second-cycle cleaning and append
  04_statistical_analysis.do      supplied statistical analysis
data/
  README.md                       original NHANES data download guide
  raw_manifest.csv                official links and reference XPT checksums
  raw/                            local destination for the 16 XPT files
  processed/                      three supplied Stata datasets
docs/                             validation, change audit, and upload guidance
output/logs/                      Stata logs generated during a run
tools/                            optional checksum verification
vendor/gologit2/                  optional local destination for the Stata extension
work/                             generated cleaning intermediates and rebuilt data
```

The second-cycle cleaning script contains the append step. The original filename `2022final_analysis_data.dta` refers to the August 2021–August 2023 cycle.

| Dataset | Rows | Variables | Baseline analysis subpopulation |
|---|---:|---:|---:|
| `17_18final_analysis_data.dta` | 9,254 | 24 | 1,383 |
| `2022final_analysis_data.dta` | 11,933 | 24 | 1,084 |
| `final_two_cycles.dta` | 21,187 | 24 | 2,467 |

Run `python tools/verify_package.py` to verify the distributed files. Add `--raw` to check downloaded XPT files against the reference hashes. See the [Chinese upload guide](docs/UPLOAD_GUIDE_zh.md) for GitHub instructions.
