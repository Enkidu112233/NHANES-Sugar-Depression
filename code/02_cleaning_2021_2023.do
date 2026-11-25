* Called by 00_master.do; $root is the repository directory.
cd "$root/work/2021_2023"
import sasxport5 "$root/data/raw/2021_2023/BMX_L.xpt", clear
save "$root/work/2021_2023/BMX_L.dta", replace

import sasxport5 "$root/data/raw/2021_2023/DEMO_L.xpt", clear
save "$root/work/2021_2023/DEMO_L.dta", replace

import sasxport5 "$root/data/raw/2021_2023/DPQ_L.xpt", clear
save "$root/work/2021_2023/DPQ_L.dta", replace

import sasxport5 "$root/data/raw/2021_2023/DR1IFF_L.xpt", clear
save "$root/work/2021_2023/DR1IFF_L.dta", replace

import sasxport5 "$root/data/raw/2021_2023/DR2IFF_L.xpt", clear
save "$root/work/2021_2023/DR2IFF_L.dta", replace

import sasxport5 "$root/data/raw/2021_2023/SLQ_L.xpt", clear
save "$root/work/2021_2023/SLQ_L.dta", replace

import sasxport5 "$root/data/raw/2021_2023/FSQ_L.xpt", clear
save "$root/work/2021_2023/FSQ_L.dta", replace

import sasxport5 "$root/data/raw/2021_2023/DIQ_L.xpt", clear
save "$root/work/2021_2023/DIQ_L.dta", replace

cd "$root/work/2021_2023"
*Prepare PHQ9 and PHQ8 outcomes
use DPQ_L.dta, clear
foreach var of varlist dpq010-dpq090 {
    replace `var' = . if `var' == 7 | `var' == 9
}

egen phq9 = rowtotal(dpq010-dpq090)
gen phq8 = phq9 - dpq030
keep seqn phq9 phq8
save mental_final.dta, replace


*Prepare exposure variables
use DR1IFF_L.dta, clear
collapse (sum) dr1isugr dr1ikcal ///
    (firstnm) wtdr2d wtdrd1, by(seqn)
rename dr1isugr day1_sugar
rename dr1ikcal dr1tkcal
save day1_nutri.dta, replace

* Day 2 dietary data
use DR2IFF_L.dta, clear
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
use DEMO_L.dta, clear
keep seqn dmdeduc2 dmdhhsiz indfmpir riagendr ridageyr sddsrvyr ridreth3 sdmvstra sdmvpsu
rename riagendr gender
rename ridageyr age
rename indfmpir pir    
rename dmdeduc2 edu
rename dmdhhsiz famsize
rename sddsrvyr cycle
rename ridreth3 race
save demo_final.dta, replace

*BMI and sleep pathway variables
use BMX_L.dta, clear
keep seqn bmxbmi
rename bmxbmi bmi
save bmi_final.dta, replace
use SLQ_L.dta, clear
keep seqn sld012
rename sld012 sleep
save sleep_final.dta, replace
*Food security
use FSQ_L.dta, clear
keep seqn fsdad
save fsq_final.dta, replace
*Diabetes
use DIQ_L.dta, clear
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
save 2022final_analysis_data.dta, replace


*Combined-cycle preparation
*Combine cycles
use 2022final_analysis_data.dta, clear
append using "$root/work/2017_2018/17_18final_analysis_data.dta"

* Save combined data
save final_two_cycles.dta, replace


