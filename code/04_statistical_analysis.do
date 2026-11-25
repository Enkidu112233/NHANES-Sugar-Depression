cd "$root"
use "$analysis_data", clear

**************************************************
* PART 1. Basic variable preparation
**************************************************

* Retain the original gender coding
replace gender = 0 if gender == 2

* Define covariates for the fully adjusted model
local controls gender age edu famsize avg_energy pir i.race

**************************************************
* PART 2. Define the analysis sample
**************************************************

capture drop sample_full

gen byte sample_full = ///
    inrange(age,20,44) & ///
    !inlist(edu,7,9) & ///
    !missing(phq9,avg_sugar,gender,age,edu, ///
             famsize,avg_energy,pir,race,cycle, ///
             wtdr2d,sdmvstra,sdmvpsu) & ///
    wtdr2d > 0

* Inspect sample sizes by cycle
tab cycle if sample_full == 1

**************************************************
* PART 3. BASELINE
**************************************************

* 3.1 Run each cycle separately

levelsof cycle, local(cycles)

foreach c of local cycles {

    preserve

    keep if cycle == `c'

    display "================================"
    display "BASELINE - Cycle `c'"
    display "================================"

    svyset sdmvpsu [pweight=wtdr2d], ///
        strata(sdmvstra) singleunit(centered)

    svy, subpop(sample_full): regress ///
        phq9 avg_sugar `controls'

    display "Cycle Sample N = " e(N_sub)

    restore
}

**************************************************
* 3.2 Pooled baseline across both cycles
**************************************************

* Exploratory pooling across pre- and post-pandemic cycles
* These pooled survey weights have not been officially validated

capture drop weight_pool strata_pool

gen double weight_pool = wtdr2d/2

egen strata_pool = group(cycle sdmvstra)

svyset sdmvpsu [pweight=weight_pool], ///
    strata(strata_pool) singleunit(centered)

* Pooled baseline retaining i.cycle
svy, subpop(sample_full): regress ///
    phq9 avg_sugar `controls' i.cycle

display "Pooled Sample N = " e(N_sub)


**************************************************
* PART 4. ROBUSTNESS CHECK
* All following analyses use the pooled dataset
**************************************************

*** Robustness 1: LPM

capture drop phq9_binary

gen byte phq9_binary = .
replace phq9_binary = 1 if phq9 >= 10 & !missing(phq9)
replace phq9_binary = 0 if phq9 < 10

svy, subpop(sample_full): regress ///
    phq9_binary avg_sugar `controls' i.cycle


*** Robustness 2: Binary Logit

svy, subpop(sample_full): logit ///
    phq9_binary avg_sugar `controls' i.cycle

* Average marginal effect
margins, dydx(avg_sugar)


*** Robustness 3: Ordered Logit

capture drop phq9_level

gen byte phq9_level = .
replace phq9_level = 0 if inrange(phq9,0,4)
replace phq9_level = 1 if inrange(phq9,5,9)
replace phq9_level = 2 if inrange(phq9,10,14)
replace phq9_level = 3 if inrange(phq9,15,19)
replace phq9_level = 4 if inrange(phq9,20,27)

capture label drop phq9lbl

label define phq9lbl ///
    0 "Minimal depression" ///
    1 "Mild depression" ///
    2 "Moderate depression" ///
    3 "Moderately severe depression" ///
    4 "Severe depression"

label values phq9_level phq9lbl

tab phq9_level if sample_full == 1

svy, subpop(sample_full): ologit ///
    phq9_level avg_sugar `controls' i.cycle, or

	
*** Robustness 4: Partial Proportional Odds Logit
gsvy, subpop(sample_full): ///
    gologit2 phq9_level avg_sugar `controls' i.cycle, npl(avg_sugar)


**************************************************
* PART 5. HETEROGENEITY ANALYSIS
* Run subgroup regressions followed by interaction tests
* Use the pooled dataset
**************************************************

* Prerequisites:
* Parts 1-4 completed
* sample_full defined
* Pooled survey design declared


**************************************************
* 5.1 Diabetes
**************************************************

* Retain the original three groups
* 1 = Yes
* 2 = No
* 3 = Borderline

tab diq010 if sample_full == 1, missing

* Define the diabetes heterogeneity sample
capture drop sample_diabetes

gen byte sample_diabetes = ///
    sample_full == 1 & inlist(diq010,1,2,3)


* ---------- Group 1: Diabetes = Yes ----------

capture drop sample_diab1

gen byte sample_diab1 = ///
    sample_diabetes == 1 & diq010 == 1

display "Diabetes Group 1: Yes"

svy, subpop(sample_diab1): regress ///
    phq9 avg_sugar gender age edu famsize ///
    avg_energy pir i.race i.cycle


* ---------- Group 2: Diabetes = No ----------

capture drop sample_diab2

gen byte sample_diab2 = ///
    sample_diabetes == 1 & diq010 == 2

display "Diabetes Group 2: No"

svy, subpop(sample_diab2): regress ///
    phq9 avg_sugar gender age edu famsize ///
    avg_energy pir i.race i.cycle


* ---------- Group 3: Borderline ----------

capture drop sample_diab3

gen byte sample_diab3 = ///
    sample_diabetes == 1 & diq010 == 3

display "Diabetes Group 3: Borderline"

svy, subpop(sample_diab3): regress ///
    phq9 avg_sugar gender age edu famsize ///
    avg_energy pir i.race i.cycle


* ---------- Interaction Test ----------

display "Diabetes Interaction Test"

* Use diq010==2 (No) as reference

svy, subpop(sample_diabetes): regress ///
    phq9 c.avg_sugar##ib2.diq010 ///
    gender age edu famsize ///
    avg_energy pir i.race i.cycle

* Coefficient difference: diabetes Yes versus No
lincom 1.diq010#c.avg_sugar

* Coefficient difference: Borderline versus No
lincom 3.diq010#c.avg_sugar

* Joint interaction test across groups
testparm i.diq010#c.avg_sugar

* Marginal sugar slope by group
margins diq010, dydx(avg_sugar)


**************************************************
* 5.2 Income
**************************************************

* Retain the original income thresholds

capture drop pir_group

gen byte pir_group = .

replace pir_group = 1 if pir < 1.3
replace pir_group = 2 if ///
    pir >= 1.3 & pir < 3 & !missing(pir)
replace pir_group = 3 if ///
    pir >= 3 & !missing(pir)

tab pir_group if sample_full == 1


* ---------- Group 1: Low Income ----------

capture drop sample_low

gen byte sample_low = ///
    sample_full == 1 & pir_group == 1

display "Low Income Group"

svy, subpop(sample_low): regress ///
    phq9 avg_sugar gender age edu famsize ///
    avg_energy i.race i.cycle


* ---------- Group 2: Middle Income ----------

capture drop sample_middle

gen byte sample_middle = ///
    sample_full == 1 & pir_group == 2

display "Middle Income Group"

svy, subpop(sample_middle): regress ///
    phq9 avg_sugar gender age edu famsize ///
    avg_energy i.race i.cycle


* ---------- Group 3: High Income ----------

capture drop sample_high

gen byte sample_high = ///
    sample_full == 1 & pir_group == 3

display "High Income Group"

svy, subpop(sample_high): regress ///
    phq9 avg_sugar gender age edu famsize ///
    avg_energy i.race i.cycle


* ---------- Interaction Test ----------

display "Income Interaction Test"

* Match the original subgroup specification
* Do not additionally adjust for continuous pir

svy, subpop(sample_full): regress ///
    phq9 c.avg_sugar##ib1.pir_group ///
    gender age edu famsize ///
    avg_energy i.race i.cycle

* Middle vs Low
lincom 2.pir_group#c.avg_sugar

* High vs Low
lincom 3.pir_group#c.avg_sugar

* Joint test
testparm i.pir_group#c.avg_sugar

* Sugar slope by income group
margins pir_group, dydx(avg_sugar)


**************************************************
* 5.3 Gender
**************************************************

tab gender if sample_full == 1


* ---------- Group 1: Female ----------

capture drop sample_female

gen byte sample_female = ///
    sample_full == 1 & gender == 0

display "Female Group"

svy, subpop(sample_female): regress ///
    phq9 avg_sugar age edu famsize ///
    avg_energy pir i.race i.cycle


* ---------- Group 2: Male ----------

capture drop sample_male

gen byte sample_male = ///
    sample_full == 1 & gender == 1

display "Male Group"

svy, subpop(sample_male): regress ///
    phq9 avg_sugar age edu famsize ///
    avg_energy pir i.race i.cycle


* ---------- Interaction Test ----------

display "Gender Interaction Test"

svy, subpop(sample_full): regress ///
    phq9 c.avg_sugar##ib0.gender ///
    age edu famsize avg_energy pir ///
    i.race i.cycle

* Male vs Female
lincom 1.gender#c.avg_sugar

* Sugar slope by group
margins gender, dydx(avg_sugar)

**************************************************
* END OF HETEROGENEITY ANALYSIS
**************************************************



**************************************************
* PART 6. EXPLORATORY PATHWAY ANALYSIS
**************************************************

**************************************************
* PATH 1: avg_sugar -> sleep -> phq8
**************************************************

* Define the sleep analysis sample
capture drop sample_sleep

gen byte sample_sleep = ///
    sample_full == 1 & !missing(sleep,phq8)


* =========================================
* 1. Basic three-step regressions
* =========================================

display "PATH 1 - SLEEP BASIC ANALYSIS"

* Step 1: Total association
svy, subpop(sample_sleep): regress ///
    phq8 avg_sugar ///
    gender age edu famsize avg_energy ///
    pir i.race i.cycle


* Step 2: Path a
svy, subpop(sample_sleep): regress ///
    sleep avg_sugar ///
    gender age edu famsize avg_energy ///
    pir i.race i.cycle


* Step 3: Path b and direct association
svy, subpop(sample_sleep): regress ///
    phq8 avg_sugar sleep ///
    gender age edu famsize avg_energy ///
    pir i.race i.cycle


* =========================================
* 2. Bootstrap
* =========================================

* Encode strata and PSUs separately by cycle
capture drop boot_strata boot_psu

egen boot_strata = group(cycle sdmvstra)
egen boot_psu = group(cycle sdmvstra sdmvpsu)

* Drop the previously defined program
capture program drop med_sleep

* Define the bootstrap program
program define med_sleep, rclass

    * Path a
    quietly regress sleep avg_sugar ///
        gender age edu famsize avg_energy ///
        pir i.race i.cycle ///
        [pweight=weight_pool] ///
        if sample_sleep == 1

    local a = _b[avg_sugar]

    * Path b and direct association
    quietly regress phq8 avg_sugar sleep ///
        gender age edu famsize avg_energy ///
        pir i.race i.cycle ///
        [pweight=weight_pool] ///
        if sample_sleep == 1

    local b = _b[sleep]
    local cprime = _b[avg_sugar]

    * Total association
    quietly regress phq8 avg_sugar ///
        gender age edu famsize avg_energy ///
        pir i.race i.cycle ///
        [pweight=weight_pool] ///
        if sample_sleep == 1

    local ctotal = _b[avg_sugar]

    * Return estimates
    return scalar a = `a'
    return scalar b = `b'
    return scalar indirect = `a' * `b'
    return scalar direct = `cprime'
    return scalar total = `ctotal'

end


* =========================================
* 3. Test the bootstrap program
* =========================================

med_sleep
return list


* =========================================
* 4. Stratified PSU bootstrap
* =========================================

preserve

* Retain records with valid survey design information
keep if !missing(boot_strata,boot_psu,weight_pool)
keep if weight_pool > 0

bootstrap ///
    a=r(a) ///
    b=r(b) ///
    indirect=r(indirect) ///
    direct=r(direct) ///
    total=r(total), ///
    reps(2000) ///
    seed(12345) ///
    cluster(boot_psu) ///
    strata(boot_strata): med_sleep

* Bootstrap confidence intervals
estat bootstrap, percentile bc

restore

**************************************************
* END OF SLEEP PATHWAY
**************************************************




**************************************************
* PATH 2: Food Security -> Sugar -> PHQ9
* Exploratory food security analysis
**************************************************

* =========================================
* 1. Define food security categories
* =========================================

capture drop foodsec_cat

gen byte foodsec_cat = fsdad ///
    if inrange(fsdad,1,4)

label define foodlbl ///
    1 "Full food security" ///
    2 "Marginal food security" ///
    3 "Low food security" ///
    4 "Very low food security", replace

label values foodsec_cat foodlbl

* Define the valid analysis sample
capture drop sample_food

gen byte sample_food = ///
    sample_full == 1 & !missing(foodsec_cat)

* Inspect the sample
tab foodsec_cat if sample_food == 1
tab cycle if sample_food == 1


* =========================================
* 2. Basic three-step regressions
* =========================================

* Step 1: Food Security -> PHQ9
svy, subpop(sample_food): regress ///
    phq9 ib1.foodsec_cat ///
    gender age edu famsize avg_energy ///
    pir i.race i.cycle

* Step 2: Food Security -> Sugar
svy, subpop(sample_food): regress ///
    avg_sugar ib1.foodsec_cat ///
    gender age edu famsize avg_energy ///
    pir i.race i.cycle

* Step 3: Food Security + Sugar -> PHQ9
svy, subpop(sample_food): regress ///
    phq9 ib1.foodsec_cat avg_sugar ///
    gender age edu famsize avg_energy ///
    pir i.race i.cycle


* =========================================
* 3. Generate bootstrap sampling variables
* =========================================

capture drop boot_strata boot_psu

egen boot_strata = group(cycle sdmvstra)
egen boot_psu = group(cycle sdmvstra sdmvpsu)


* =========================================
* 4. Define the bootstrap program
* =========================================

capture program drop med_food

program define med_food, rclass

    syntax, Compare(integer)

    * Path a: Food Security -> Sugar
    quietly regress avg_sugar ///
        ib1.foodsec_cat ///
        gender age edu famsize avg_energy ///
        pir i.race i.cycle ///
        [pweight=weight_pool] ///
        if sample_food == 1

    local a = _b[`compare'.foodsec_cat]

    * Path b: Sugar -> PHQ9
    quietly regress phq9 avg_sugar ///
        ib1.foodsec_cat ///
        gender age edu famsize avg_energy ///
        pir i.race i.cycle ///
        [pweight=weight_pool] ///
        if sample_food == 1

    local b = _b[avg_sugar]
    local cprime = _b[`compare'.foodsec_cat]

    * Total association
    quietly regress phq9 ///
        ib1.foodsec_cat ///
        gender age edu famsize avg_energy ///
        pir i.race i.cycle ///
        [pweight=weight_pool] ///
        if sample_food == 1

    local ctotal = _b[`compare'.foodsec_cat]

    * Return results
    return scalar a = `a'
    return scalar b = `b'
    return scalar indirect = `a' * `b'
    return scalar direct = `cprime'
    return scalar total = `ctotal'

end


* =========================================
* 5. Bootstrap comparisons for three food security categories
* =========================================

preserve

* Retain observations with valid survey design information
keep if !missing(boot_strata,boot_psu,weight_pool)
keep if weight_pool > 0

* Sequential comparisons:
* 2 vs 1
* 3 vs 1
* 4 vs 1

foreach g in 2 3 4 {

    display "=================================="
    display "Food Security: Group `g' vs Group 1"
    display "=================================="

    * Check that both categories are present
    quietly count if sample_food == 1 ///
        & foodsec_cat == 1
    local nbase = r(N)

    quietly count if sample_food == 1 ///
        & foodsec_cat == `g'
    local ncomp = r(N)

    if `nbase' > 0 & `ncomp' > 0 {

        * First estimate on the original sample
        med_food, compare(`g')
        return list

        * Stratified PSU bootstrap
        bootstrap ///
            a=r(a) ///
            b=r(b) ///
            indirect=r(indirect) ///
            direct=r(direct) ///
            total=r(total), ///
            reps(2000) ///
            seed(12345) ///
            cluster(boot_psu) ///
            strata(boot_strata) ///
            reject(missing(r(indirect))): ///
            med_food, compare(`g')

        * Bootstrap confidence intervals
        estat bootstrap, percentile
    }
}

restore

**************************************************
* END OF FOOD SECURITY PATHWAY
**************************************************



**************************************************
* PART 7. Day 1 dietary robustness analysis
**************************************************

* Day 1 analysis should retain all valid Day 1 respondents
* If records missing Day 2 have already been removed,
* rebuild the dataset from the complete Day 1 sample

capture drop sample_day1

gen byte sample_day1 = ///
    inrange(age,20,44) & ///
    !inlist(edu,7,9) & ///
    !missing(phq9,day1_sugar,gender,age,edu, ///
             famsize,dr1tkcal,pir,race,cycle, ///
             wtdrd1,sdmvstra,sdmvpsu) & ///
    wtdrd1 > 0

* Exploratory pooled-cycle Day 1 analysis
* Cross-pandemic pooled weights still require methodological validation

capture drop weight_day1

gen double weight_day1 = wtdrd1/2

svyset sdmvpsu [pweight=weight_day1], ///
    strata(strata_pool) singleunit(centered)

svy, subpop(sample_day1): regress ///
    phq9 day1_sugar gender age edu ///
    famsize dr1tkcal pir i.race i.cycle


**************************************************
* END
**************************************************
