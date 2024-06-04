**************************************************************
*Improving Private Well Testing Programs: Experimental Evidence from Iowa
* THIS FILE:
*	1) PRODUCES FIGURE 1B - AVERAGE NITRATE CONCENTRATIONS OVER TIME
* Last Updated: 1/30/2024
**************************************************************
frame copy main sum_stats
frame change sum_stats

use $data_clean\dnr_tests_clean, clear

*Treatment
gen treat_cty=0
	replace treat_cty=1 if county=="BREMER"
	replace treat_cty=1 if county=="BUTLER"
	replace treat_cty=1 if county=="CEDAR"
	replace treat_cty=1 if county=="FREMONT"
	replace treat_cty=1 if county=="JONES"
	replace treat_cty=1 if county=="MILLS"
	replace treat_cty=1 if county=="BOONE"
	replace treat_cty=1 if county=="CLAYTON"
	replace treat_cty=1 if county=="CRAWFORD"
	replace treat_cty=1 if county=="DALLAS"
	replace treat_cty=1 if county=="EMMET"
	replace treat_cty=1 if county=="FAYETTE"
	replace treat_cty=1 if county=="IDA"
	replace treat_cty=1 if county=="PALO ALTO"
gen yq_treat = yq*treat_cty

*Nitrate violations - quarterly
gen viol=0
replace viol=1 if nit>=10

forvalues t = 168/249 {
	gen yq`t' = 0
		replace yq`t' = 1 if yq==`t'
}
*
forvalues t = 168/249 {
	gen yq_treat`t' = 0
		replace yq_treat`t' = 1 if yq==`t' & treat==1	
}
*
reg viol yq168-yq249 yq_treat168-yq_treat249, nocons vce(cluster county)

gen q=.
gen avg=.
gen avg_treat=.
gen ub=.
gen lb=.

forvalues i=168/249{
	local j=`i'-167
	replace q=`i' in `j'
	replace avg=_b[yq`i'] in `j'
	replace ub=_b[yq`i']+1.96*_se[yq`i'] in `j'
	replace lb=_b[yq`i']-1.96*_se[yq`i'] in `j'
	qui lincom yq`i'+yq_treat`i'
	replace avg_treat=`r(estimate)' in `j'
}
format q %tq
tw (rarea ub lb q, color(gs13)) ///
   (line avg q, lcolor(edkblue) lw(0.4)) ///
	(line avg_treat q,  lcolor(cranberry) lw(0.4) ///
	yscale(noline) ///
	xtit("") ///
	ytit("Average Nitrate Exceedances") ///
	text(0.4 168 "{bf:B}", place(e) size(huge)) ///	
	legend(order(2 "State Average" 3 "Treated County Average")  ///
	       region(lcolor(white)) cols(1) ring(0) position(2)) ///  
	ylabel(0 (0.1) 0.4, angle(0)) ///
	xlabel(168(8)249, angle(45))) 
graph export $output\fig-1b.png, width(4000) replace		

drop yq168-lb

frame change main
frame drop sum_stats
