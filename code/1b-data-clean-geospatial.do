**************************************************************
*Improving Private Well Testing Programs: Experimental Evidence from Iowa
* THIS FILE:
*   1) PREPARES MAILING LIST AND IOWA DNR DATA FOR SMARTY ADDRESS STANDARDIZATION
*   2) CALCULATES DISTANCE BETWEEN ALL CONTROL AND TREATMENT HOUSEHOLDS
*   3) MERGES IOWA DNR PWTS DATA WITH SURVEY MAILING ADDRESS DATA
* NOTE: ADDRESS DATA IS CONFIDENTIAL.
* Last Updated: 5/10/2024
**************************************************************

/*
*******************************
*1) PREPARING ADDRESS DATA FOR SMARTY ADDRESS STANDARDIZATION

***
*Round 1 Addresses
import excel "$data_add\round-1-mailing-list.xlsx", sheet("Samples") firstrow clear
drop FirstName LastName township
rename address street
rename ID id
gen id_nam = substr(id, 1, 2) 
gen id_num = substr(id, 3, .) 
	replace id_num = "0" + id_num if length(id_num)<4
	replace id_num = "0" + id_num if length(id_num)<4
	replace id_num = "0" + id_num if length(id_num)<4
drop id
gen id=id_nam+id_num
order id street city state zip
save $data_clean/survey_addresses.dta, replace

***
*Round 2 Addresses
import excel "$data_add\round-2-mailing-list.xlsx",  firstrow clear
keep DATASERVICESID DeliveryAddress CityStZIP4
gen zip=substr(CityStZIP4, -11, 11)
gen state= "IA"
gen city1 = regexs(1) if regexm(CityStZIP4, "([a-zA-Z]+)[ ]*([a-zA-Z]+)")
gen city2 = regexs(2) if regexm(CityStZIP4, "([a-zA-Z]+)[ ]*([a-zA-Z]+)")
replace city2="" if city2=="IA"
gen city=city1+ " " + city2
drop city1 city2 CityStZIP4
rename DeliveryAddress street
rename DATASERVICESID id
order id street city state zip
append using $data_clean/survey_addresses.dta
save $data_clean/survey_addresses.dta, replace


***
*Round 2 Addresses- Update
import delimited "$data_add\round-2-mailing-list-update.csv", clear 
keep dataservicesid deliveryaddress citystzip4

gen zip=substr(citystzip4, -11, 11)
gen state= "IA"
gen city1 = regexs(1) if regexm(citystzip4, "([a-zA-Z]+)[ ]*([a-zA-Z]+)")
gen city2 = regexs(2) if regexm(citystzip4, "([a-zA-Z]+)[ ]*([a-zA-Z]+)")
replace city2="" if city2=="IA"
gen city=city1+ " " + city2
drop city1 city2 citystzip4
rename deliveryaddress street
rename dataservicesid id
order id street city state zip
append using $data_clean/survey_addresses.dta
duplicates drop id, force
save $data_clean/survey_addresses.dta, replace
merge 1:1 id using $data_clean/survey_clean_20231103.dta
keep if _merge==3
keep id street city state zip 
export excel using "$data_add\survey-addresses-smarty-1.xlsx", firstrow(variables) replace


***
*Prepare DNR Data for Smarty
import delimited "$data_dnr\PWTSallnitrate_20220511.csv", clear 
keep pwtswellid vchaddress vchcity vchcity county nitrateasn
drop if missing(nitrateasn)
drop nitrateasn
rename vchaddress street 
rename vchcity city
gen state= "IA"
duplicates drop 
gen n=_n
preserve
keep if n<=20000
drop n
export excel using "$data_add\dnr-addresses-smarty-1.xlsx", firstrow(variables) replace
restore
preserve
keep if n>20000 & n<=40000
drop n
export excel using "$data_add\dnr-addresses-smarty-2.xlsx", firstrow(variables) replace
restore
preserve
keep if n>40000 & n<=60000
drop n
export excel using "$data_add\dnr-addresses-smarty-3.xlsx", firstrow(variables) replace
restore
preserve
keep if n>60000 
drop n
export excel using "$data_add\dnr-addresses-smarty-4.xlsx", firstrow(variables) replace
restore
*/


*******************************
*2) CALCULATING DISTANCES BETWEEN CONTROL AND TREATMENT HOUSEHOLDS

***
*Smarty Data
import excel "$data_add\survey-addresses-smarty-1-output-new.xlsx", firstrow clear
keep id delivery_line_1 city_name state_abbreviation full_zipcode latitude longitude 
gen n=_n 

*Convert latitude and longitude from degrees to radians
gen d2r = 3.141592653589793 / 180
gen lat_rad = latitude * d2r
gen lon_rad = longitude * d2r
gen R = 6371

*Loop to calculate distances (miles) for all pairs of locations
forval i = 1/`=_N' {
	gen lat=lat_rad[`i']
	gen lon=lon_rad[`i']
    gen dlat = lat_rad - lat
    gen dlon = lon_rad - lon
    gen a = sin(dlat/2)^2 + cos(lat)*cos(lat_rad)*sin(dlon/2)^2
    gen c = 2 * atan2(sqrt(a), sqrt(1-a))
    gen dist`i'= R*c*0.6214
	replace dist`i'=. in `i'
	drop lat lon dlat dlon a c 
}
*Merge with treatment assignment
merge 1:1 id using $data_clean/id_treat
keep if _merge==3
drop _merge

*****
*Radius neighbor metrics
gen min_dist=9999
gen min_dist_tr=9999
gen closest=.
gen closest_tr=.

gen neigh1_dir=0
gen neigh1_p5mi=0
gen neigh1_1mi=0
gen neigh1_2mi=0
gen neigh1_5mi=0
gen neigh1_10mi=0
gen neigh1_15mi=0
gen neigh1_20mi=0

gen neigh1_dir_tr=0
gen neigh1_p5mi_tr=0
gen neigh1_1mi_tr=0
gen neigh1_2mi_tr=0
gen neigh1_5mi_tr=0
gen neigh1_10mi_tr=0
gen neigh1_15mi_tr=0
gen neigh1_20mi_tr=0
		
forval i = 1/`=_N' {
	gen treat_`i'=treat[`i']

	*Updating minmimum distance measures and closest firm indicators
	replace closest=`i' if (dist`i'<min_dist & !missing(dist`i'))
	replace closest_tr=`i' if (dist`i'<min_dist_tr & !missing(dist`i') & treat_`i'==1)
	replace min_dist=dist`i' if (dist`i'<min_dist & !missing(dist`i'))
	replace min_dist_tr=dist`i' if (dist`i'<min_dist_tr & !missing(dist`i') & treat_`i'==1)
	
	replace neigh1_dir=neigh1_dir+1 if (dist`i'<=0.01 & !missing(dist`i'))	
	replace neigh1_p5mi=neigh1_p5mi+1 if (dist`i'<=0.5 & !missing(dist`i'))
	replace neigh1_1mi=neigh1_1mi+1 if (dist`i'<=1 & !missing(dist`i'))
	replace neigh1_2mi=neigh1_2mi+1 if (dist`i'<=2 & !missing(dist`i'))
	replace neigh1_5mi=neigh1_5mi+1 if (dist`i'<=5 & !missing(dist`i'))
	replace neigh1_10mi=neigh1_10mi+1 if (dist`i'<=10 & !missing(dist`i'))
	replace neigh1_15mi=neigh1_15mi+1 if (dist`i'<=15 & !missing(dist`i'))
	replace neigh1_20mi=neigh1_20mi+1 if (dist`i'<=20 & !missing(dist`i'))
	
	replace neigh1_dir_tr=neigh1_dir_tr+1 if (dist`i'<=0.01 & !missing(dist`i') & treat_`i'==1)	
	replace neigh1_p5mi_tr=neigh1_p5mi_tr+1 if (dist`i'<=0.5 & !missing(dist`i') & treat_`i'==1)
	replace neigh1_1mi_tr=neigh1_1mi_tr+1 if (dist`i'<=1 & !missing(dist`i') & treat_`i'==1)
	replace neigh1_2mi_tr=neigh1_2mi_tr+1 if (dist`i'<=2 & !missing(dist`i') & treat_`i'==1)
	replace neigh1_5mi_tr=neigh1_5mi_tr+1 if (dist`i'<=5 & !missing(dist`i') & treat_`i'==1)
	replace neigh1_10mi_tr=neigh1_10mi_tr+1 if (dist`i'<=10 & !missing(dist`i') & treat_`i'==1)
	replace neigh1_15mi_tr=neigh1_15mi_tr+1 if (dist`i'<=15 & !missing(dist`i') & treat_`i'==1)
	replace neigh1_20mi_tr=neigh1_20mi_tr+1 if (dist`i'<=20 & !missing(dist`i') & treat_`i'==1)
	
	drop treat_`i'	
}
save $data_clean/survey_dists, replace


*******************************
*3) MERGING IOWA DNR PWTS DATA WITH SURVEY MAILING ADDRESS DATA
import excel "$data_add\dnr-addresses-smarty-output.xlsx", sheet("batch-1") firstrow clear
drop if summary=="No Match" //Dropping tests that had no match in Smarty registries
keep pwtswellid delivery_line_1 delivery_line_2 city_name state_abbreviation full_zipcode latitude longitude
save $data_clean/dnr_tests_summary, replace

import excel "$data_add\dnr-addresses-smarty-output.xlsx", sheet("batch-2") firstrow clear
drop if summary=="No Match" //Dropping tests that had no match in Smarty registries
keep pwtswellid delivery_line_1 delivery_line_2 city_name state_abbreviation full_zipcode latitude longitude
append using $data_clean/dnr_tests_summary
save $data_clean/dnr_tests_summary, replace

import excel "$data_add\dnr-addresses-smarty-output.xlsx", sheet("batch-3") firstrow clear
drop if summary=="No Match" //Dropping tests that had no match in Smarty registries
keep pwtswellid delivery_line_1 delivery_line_2 city_name state_abbreviation full_zipcode latitude longitude
append using $data_clean/dnr_tests_summary
save $data_clean/dnr_tests_summary, replace

import excel "$data_add\dnr-addresses-smarty-output.xlsx", sheet("batch-4") firstrow clear
drop if summary=="No Match" //Dropping tests that had no match in Smarty registries
keep pwtswellid delivery_line_1 delivery_line_2 city_name state_abbreviation full_zipcode latitude longitude
append using $data_clean/dnr_tests_summary
collapse (first) delivery_line_1-longitude, by(pwtswellid) //Once duplicate with different addresses - very close
save $data_clean/dnr_tests_summary, replace

use $data_clean\dnr_tests_clean, clear
keep pwtswellid nit year-yq
destring pwtswellid, replace
merge m:1 pwtswellid using $data_clean/dnr_tests_summary
keep if _merge==3 //Analysis based only on clean DNR data with a valid postal address
drop _merge
drop if year>=2021 //Dropping years after the study period
save $data_clean/dnr_tests_summary, replace

*
forval i = 1/8190 {
use $data_clean/survey_dists, clear
keep id delivery_line_1 city_name state_abbreviation full_zipcode latitude longitude n

keep if n==`i'
append using $data_clean/dnr_tests_summary
gen d2r = 3.141592653589793 / 180
gen lat_rad = latitude * d2r
gen lon_rad = longitude * d2r
gen R = 6371

gen lat=lat_rad[1]
gen lon=lon_rad[1]
gen dlat = lat_rad - lat
gen dlon = lon_rad - lon
gen a = sin(dlat/2)^2 + cos(lat)*cos(lat_rad)*sin(dlon/2)^2
gen c = 2 * atan2(sqrt(a), sqrt(1-a))
gen dist1= R*c*0.6214
replace dist1=. in 1

gen address=delivery_line_1[1]
replace address="" in 1
gen zip=full_zipcode[1]
replace zip="" in 1
gen exact_match=1 if (address==delivery_line_1 & zip==full_zipcode)

*Average Concentrations
gen nit_own=nit if exact_match==1
gen nit_p5mi=nit if dist<=0.5
gen nit_1mi=nit if dist<=1
gen nit_2mi=nit if dist<=2
gen nit_5mi=nit if dist<=5
gen nit_10mi=nit if dist<=10
gen nit_15mi=nit if dist<=15
gen nit_20mi=nit if dist<=20

gen nit_own_3yr=nit if (exact_match==1 & year>=2018)
gen nit_p5mi_3yr=nit if (dist<=0.5 & year>=2018)
gen nit_1mi_3yr=nit if (dist<=1 & year>=2018)
gen nit_2mi_3yr=nit if (dist<=2 & year>=2018)
gen nit_5mi_3yr=nit if (dist<=5 & year>=2018)
gen nit_10mi_3yr=nit if (dist<=10 & year>=2018)
gen nit_15mi_3yr=nit if (dist<=15 & year>=2018)
gen nit_20mi_3yr=nit if (dist<=20 & year>=2018)

gen nit_own_5yr=nit if (exact_match==1 & year>2015)
gen nit_p5mi_5yr=nit if (dist<=0.5 & year>2015)
gen nit_1mi_5yr=nit if (dist<=1 & year>2015)
gen nit_2mi_5yr=nit if (dist<=2 & year>2015)
gen nit_5mi_5yr=nit if (dist<=5 & year>2015)
gen nit_10mi_5yr=nit if (dist<=10 & year>2015)
gen nit_15mi_5yr=nit if (dist<=15 & year>2015)
gen nit_20mi_5yr=nit if (dist<=20 & year>2015)
 
*Max Concentrations
gen nit_own_max=nit if exact_match==1
gen nit_p5mi_max=nit if dist<=0.5
gen nit_1mi_max=nit if dist<=1
gen nit_2mi_max=nit if dist<=2
gen nit_5mi_max=nit if dist<=5
gen nit_10mi_max=nit if dist<=10
gen nit_15mi_max=nit if dist<=15
gen nit_20mi_max=nit if dist<=20

gen nit_own_3yr_max=nit if (exact_match==1 & year>=2018)
gen nit_p5mi_3yr_max=nit if (dist<=0.5 & year>=2018)
gen nit_1mi_3yr_max=nit if (dist<=1 & year>=2018)
gen nit_2mi_3yr_max=nit if (dist<=2 & year>=2018)
gen nit_5mi_3yr_max=nit if (dist<=5 & year>=2018)
gen nit_10mi_3yr_max=nit if (dist<=10 & year>=2018)
gen nit_15mi_3yr_max=nit if (dist<=15 & year>=2018)
gen nit_20mi_3yr_max=nit if (dist<=20 & year>=2018)

gen nit_own_5yr_max=nit if (exact_match==1 & year>2015)
gen nit_p5mi_5yr_max=nit if (dist<=0.5 & year>2015)
gen nit_1mi_5yr_max=nit if (dist<=1 & year>2015)
gen nit_2mi_5yr_max=nit if (dist<=2 & year>2015)
gen nit_5mi_5yr_max=nit if (dist<=5 & year>2015)
gen nit_10mi_5yr_max=nit if (dist<=10 & year>2015)
gen nit_15mi_5yr_max=nit if (dist<=15 & year>2015)
gen nit_20mi_5yr_max=nit if (dist<=20  & year>2015)

collapse (first) id (mean) nit_own-nit_20mi_5yr (max) nit_own_max-nit_20mi_5yr_max
merge 1:1 id using $data_clean/survey_dists
drop _merge 
sleep 1000
save $data_clean/survey_dists, replace 
display `i'
} 

*Merge with main dataset
keep id-nit_20mi_5yr_max min_dist-neigh1_20mi_tr
save $data_clean/survey_dists_clean, replace
use $data_clean\survey_clean_$outputdate, clear
merge 1:1 id using $data_clean/survey_dists_clean
drop _merge
save $data_clean\survey_clean_$outputdate, replace