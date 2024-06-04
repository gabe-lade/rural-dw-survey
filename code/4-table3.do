**************************************************************
*Improving Private Well Testing Programs: Experimental Evidence from Iowa
* THIS FILE:
*	1) PRODUCES TABLE 3 
* Last Updated: 11/20/2023
**************************************************************
frame copy main regs
frame change regs
keep if sample_main==1

gen missing_test_1year0=0
	replace missing_test_1year0=1 if missing(test_1year0)
replace test_1year0=0 if missing(test_1year0)	
gen missing_test_g2c0=0
	replace missing_test_g2c0=1 if missing(test_g2c0)
replace test_g2c0=0 if missing(test_g2c0)	
gen round1=0
	replace round1=1 if round==1
gen round2=0
	replace round2=1 if round==2
gen treatr1=treat*round1
gen treatr2=treat*round2
local seed=8675309

***********************
*TABLE 2a - Testing Intent to Treat Effects - Tested in the Last Year
est clear 

eststo: reg test_1year treat 
	estadd local cty_fes "No"
    mhtreg (test_1year treat) (test_g2c treat), seed(`seed') 
	matrix mat = r(results)
	estadd scalar pval_adj = mat[1,4]

eststo: reghdfe test_1year treat, absorb(county_fips)
	estadd local cty_fes "Yes"
    mhtreg (test_1year treat i.county_fips)(test_g2c treat i.county_fips), seed(`seed') 	
	matrix mat = r(results)
	estadd scalar pval_adj = mat[1,4]

eststo: reghdfe test_1year treat test_1year0 missing_test_1year0, absorb(county_fips)
	estadd local cty_fes "Yes"
    mhtreg (test_1year treat test_1year0 missing_test_1year0 i.county_fips) (test_g2c treat test_g2c0 missing_test_g2c0 i.county_fips), seed(`seed') 
	matrix mat = r(results)
	estadd scalar pval_adj = mat[1,4]
	
eststo: reg test_1year round1 round2 treatr1 treatr2, nocons
	estadd local cty_fes "No"
    mhtreg (test_1year treatr1 treatr2 round1) (test_g2c treatr1 treatr2 round1), seed(`seed') 	
	matrix mat = r(results)
	estadd scalar pval_adj_r1 = mat[1,4]
    mhtreg (test_1year treatr2 treatr1 round1) (test_g2c treatr2 treatr1 round1), seed(`seed') 
	matrix mat = r(results)
	estadd scalar pval_adj_r2 = mat[1,4]
	
esttab using "$output/table-3a.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none)  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Testing Intent to Treat Effects - 1 Year) ///
	coef(treat "Mailed Test Strip" ///
	     treatr1 "Mailed Test Strip (Round 1)" ///
	     treatr2 "Mailed Test Strip (Round 2)" ///		
		 test_1year0  "Baseline Testing" ///
		 missing_test_1year0 "Missing Baseline Testing" ///
		 round1 "Round 1" ///
		 round2 "Round 2" ) ///
	scalars("cty_fes County FE" ///
			"pval_adj MHT Corrected p-value" ///
			"pval_adj_r1 MHT Round 1" ///
			"pval_adj_r2 MHT Round 2") ///	
	sfmt(%12.4f) mlabels(none) 
	
	
***********************
*TABLE 2b - Testing Intent to Treat Effects - Used Grants to Counties Program
est clear 

eststo: reg test_g2c treat 
	estadd local cty_fes "No"
    mhtreg (test_1year treat)(test_g2c treat), seed(`seed') 
	matrix mat = r(results)
	estadd scalar pval_adj = mat[2,4]

eststo: reghdfe test_g2c treat, absorb(county_fips)
	estadd local cty_fes "Yes"
    mhtreg (test_1year treat i.county_fips)(test_g2c treat i.county_fips), seed(`seed') 
	matrix mat = r(results)
	estadd scalar pval_adj = mat[2,4]

eststo: reghdfe test_g2c treat test_1year0 missing_test_1year0, absorb(county_fips)
	estadd local cty_fes "Yes"
    mhtreg (test_1year treat test_1year0 missing_test_1year0 i.county_fips) (test_g2c treat test_g2c0 missing_test_g2c0 i.county_fips), seed(`seed') 
	matrix mat = r(results)
	estadd scalar pval_adj = mat[2,4]
	
eststo: reg test_g2c round1 round2 treatr1 treatr2, nocons
	estadd local cty_fes "No"
    mhtreg (test_1year treatr1 treatr2 round1)(test_g2c treatr1 treatr2 round1), seed(`seed') 
	matrix mat = r(results)
	estadd scalar pval_adj_r1 = mat[2,4]
    mhtreg (test_1year treatr2 treatr1 round1)(test_g2c treatr2 treatr1 round1), seed(`seed') 
	matrix mat = r(results)
	estadd scalar pval_adj_r2 = mat[2,4]
	
	
esttab using "$output/table-3b.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none)  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Testing Intent to Treat Effects - G2C) ///
	coef(treat "Mailed Test Strip" ///
	     test_g2c0  "Baseline Testing" ///
	     missing_test_g2c0 "Missing Baseline Testing") ///
	scalars("cty_fes County FE" ///
			"pval_adj MHT Corrected p-value" ///
			"pval_adj_r1 MHT Round 1" ///
			"pval_adj_r2 MHT Round 2") ///
	sfmt(%12.4f) mlabels(none)  
	
frame change main
frame drop regs