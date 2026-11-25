* Called by 00_master.do; $root is the repository directory.
cd "$root/work/2017_2018"
import sasxport5 "$root/data/raw/2017_2018/BMX_J.xpt", clear
save "$root/work/2017_2018/BMX_J.dta", replace

import sasxport5 "$root/data/raw/2017_2018/DEMO_J.xpt", clear
save "$root/work/2017_2018/DEMO_J.dta", replace

import sasxport5 "$root/data/raw/2017_2018/DPQ_J.xpt", clear
save "$root/work/2017_2018/DPQ_J.dta", replace

import sasxport5 "$root/data/raw/2017_2018/DR1IFF_J.xpt", clear
save "$root/work/2017_2018/DR1IFF_J.dta", replace

import sasxport5 "$root/data/raw/2017_2018/DR2IFF_J.xpt", clear
save "$root/work/2017_2018/DR2IFF_J.dta", replace

import sasxport5 "$root/data/raw/2017_2018/SLQ_J.xpt", clear
save "$root/work/2017_2018/SLQ_J.dta", replace

import sasxport5 "$root/data/raw/2017_2018/FSQ_J.xpt", clear
save "$root/work/2017_2018/FSQ_J.dta", replace

import sasxport5 "$root/data/raw/2017_2018/DIQ_J.xpt", clear
save "$root/work/2017_2018/DIQ_J.dta", replace


cd "$root/work/2017_2018"
*Prepare PHQ9 and PHQ8 outcomes (PHQ8 for the sleep pathway)
use DPQ_J.dta, clear
foreach var of varlist dpq010-dpq090 {
    replace `var' = . if `var' == 7 | `var' == 9
}

egen phq9 = rowtotal(dpq010-dpq090)
gen phq8 = phq9 - dpq030
keep seqn phq9 phq8
save mental_final.dta, replace


*Prepare exposure variables
use DR1IFF_J.dta, clear
collapse (sum) dr1isugr dr1ikcal ///
    (firstnm) wtdr2d wtdrd1, by(seqn)
rename dr1isugr day1_sugar
rename dr1ikcal dr1tkcal
save day1_nutri.dta, replace

* Day 2 dietary data
use DR2IFF_J.dta, clear
collapse (sum) dr2isugr dr2ikcal, by(seqn)
rename dr2isugr day2_sugar
rename dr2ikcal dr2tkcal

* Merge the two dietary days
merge 1:1 seqn using day1_nutri.dta
keep if _merge == 3
drop _merge

* Compute mean daily total sugar
gen avg_sugar = (day1_sugar + day2_sugar)/2
* Compute mean daily total energy
gen avg_energy = (dr1tkcal + dr2tkcal)/2
* Retain identifiers, sugar, weights, and energy
keep seqn day1_sugar day2_sugar avg_sugar ///
    wtdr2d wtdrd1 dr1tkcal dr2tkcal avg_energy

save nutrition_final.dta, replace

*Control variables
use DEMO_J.dta, clear
keep seqn dmdeduc2 dmdhhsiz indfmpir riagendr ridageyr sddsrvyr ridreth3 sdmvstra sdmvpsu
rename riagendr gender
rename ridageyr age
rename indfmpir pir      // Income-to-poverty ratio
rename dmdeduc2 edu
rename dmdhhsiz famsize
rename sddsrvyr cycle
rename ridreth3 race
save demo_final.dta, replace

*BMI and sleep pathway variables
use BMX_J.dta, clear
keep seqn bmxbmi
rename bmxbmi bmi
save bmi_final.dta, replace
use SLQ_J.dta, clear
keep seqn sld012
rename sld012 sleep
save sleep_final.dta, replace
*Food security
use FSQ_J.dta, clear
keep seqn fsdad
save fsq_final.dta, replace
*Diabetes
use DIQ_J.dta, clear
keep seqn diq010
save diq_final.dta, replace

use demo_final.dta, clear

* Merge component files sequentially (original merge options retained)
merge 1:1 seqn using mental_final.dta, nogen
merge 1:1 seqn using nutrition_final.dta, nogen
merge 1:1 seqn using sleep_final.dta, nogen
merge 1:1 seqn using bmi_final.dta, nogen
merge 1:1 seqn using fsq_final.dta, nogen
merge 1:1 seqn using diq_final.dta, nogen
save 17_18final_analysis_data.dta, replace
