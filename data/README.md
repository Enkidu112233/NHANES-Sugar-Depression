# Download the original NHANES data

For rebuilding, download the 16 original SAS transport files listed below. The quick analysis route uses the supplied processed data and does not require these downloads. Raw XPT files are intentionally not bundled.

## Manual download steps

1. Choose the correct cycle in the tables below.
2. Click **Download XPT**. If the browser opens the file rather than saving it, use Save link as.
3. Keep the exact filename, including `.xpt`. Do not save an HTML webpage with an XPT extension.
4. Place the file in the destination shown. Do not place converted DTA files in the raw folder.
5. Repeat for all eight files in each cycle, then run `do code/00_master.do full` from the repository root.

The code reads the individual foods files DR1IFF and DR2IFF, not DR1TOT and DR2TOT. Smoking, alcohol, physical activity, and DBQ files are not required by these revised scripts.

## 2017–2018

Save these eight files under `data/raw/2017_2018/`.

| File | Module | Official download | Documentation |
|---|---|---|---|
| `BMX_J.xpt` | Body measures | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/BMX_J.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/BMX_J.htm) |
| `DEMO_J.xpt` | Demographics and sample weights | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DEMO_J.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DEMO_J.htm) |
| `DPQ_J.xpt` | Depression screener | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DPQ_J.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DPQ_J.htm) |
| `DR1IFF_J.xpt` | Individual foods, first day | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DR1IFF_J.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DR1IFF_J.htm) |
| `DR2IFF_J.xpt` | Individual foods, second day | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DR2IFF_J.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DR2IFF_J.htm) |
| `SLQ_J.xpt` | Sleep disorders | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/SLQ_J.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/SLQ_J.htm) |
| `FSQ_J.xpt` | Food security | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/FSQ_J.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/FSQ_J.htm) |
| `DIQ_J.xpt` | Diabetes | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DIQ_J.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2017/DataFiles/DIQ_J.htm) |

## August 2021–August 2023

Save these eight files under `data/raw/2021_2023/`.

| File | Module | Official download | Documentation |
|---|---|---|---|
| `BMX_L.xpt` | Body measures | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/BMX_L.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/BMX_L.htm) |
| `DEMO_L.xpt` | Demographics and sample weights | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DEMO_L.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DEMO_L.htm) |
| `DPQ_L.xpt` | Depression screener | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DPQ_L.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DPQ_L.htm) |
| `DR1IFF_L.xpt` | Individual foods, first day | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DR1IFF_L.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DR1IFF_L.htm) |
| `DR2IFF_L.xpt` | Individual foods, second day | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DR2IFF_L.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DR2IFF_L.htm) |
| `SLQ_L.xpt` | Sleep disorders | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/SLQ_L.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/SLQ_L.htm) |
| `FSQ_L.xpt` | Food security | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/FSQ_L.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/FSQ_L.htm) |
| `DIQ_L.xpt` | Diabetes | [Download XPT](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DIQ_L.xpt) | [Codebook](https://wwwn.cdc.gov/Nchs/Data/Nhanes/Public/2021/DataFiles/DIQ_L.htm) |

## Official cycle pages

- [NHANES 2017–2018](https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?Cycle=2017-2018)
- [NHANES August 2021–August 2023](https://wwwn.cdc.gov/nchs/nhanes/continuousnhanes/default.aspx?Cycle=2021-2023)
- [NHANES data user agreement](https://www.cdc.gov/nchs/policy/data-user-agreement.html)

If a direct link changes, use the official cycle page, select Demographics, Dietary, Examination, or Questionnaire, and locate the exact file code in the table. Click the Data XPT link, rather than the Doc link, to download data.

## Reference versions

`raw_manifest.csv` records filenames, destinations, documentation links, direct download links, byte sizes, and SHA-256 hashes for the author's existing local XPT files. The reference files were hashed on 25 November 2026; this is not an assertion about their original download dates. Official index pages and all 16 codebook pages were checked on the same date. The binaries currently served by CDC were not downloaded again or compared against the local reference files.

CDC may update data files. If a downloaded file differs from the recorded size or hash, investigate the official revision notes before rebuilding; do not assume a different version will reproduce identical results. Keep a private or institutional archive of the exact original input files when needed for long-term preservation.

An optional Python checksum tool is provided: from the repository root run `python tools/verify_package.py --raw` after downloading all files. No Python packages are required.

## Processed datasets

`processed/` contains the author's three revised DTA files unchanged. The two-cycle dataset is a value-level, row-order match to the 2021–2023 data followed by the 2017–2018 data. The source filenames are retained. Rebuilding writes to `work/`, keeping these distributed references intact.
