**************************************************************
*Improving Private Well Testing Programs: Experimental Evidence from Iowa
* THIS FILE:
*	1) PRODUCES TABLE 4
* Last Updated: 5/10/2024
**************************************************************.
frame copy main regs
frame change regs

*Cleaning
gen chilinf_ind = 0
	replace chilinf_ind = 1 if children_ind==1|infants_ind==1
	replace chilinf_ind=. if missing(children_ind) & missing(infants_ind)
gen rate_goodgr0=rate_great0+rate_good0 
keep id_number grouping_for_strip choice__strip treat ///
      income_25 income_2550 income_50100 income_100200 income_200 ///
	  educ_hs educ_bach educ_mast hh_size chilinf_ind retiree_ind ///
	  well_age_05 well_age_610 well_age_1120 well_age_ov20 ///
	  well_age_notsure well_dpth_050 well_dpth_51150 well_dpth_ov150 ///
	  well_dpth_notsure nit_concern_any0 nit_concern_none0 ///
	  nit_concern_unsure0 nit_concern_local0 nit_concern_cnty0 ///
	  nit_concern_state0 rate_goodgr0 rate_neut0 rate_poor0 ///
	  rate_unsure0
drop if missing(grouping_for_strip)
drop if choice__strip=="$ + strip"
drop if choice__strip=="missing choice"
drop if choice__strip=="neither"
replace choice__strip="$5" if choice__strip=="$50"

gen descr="strip"
gen strip=1
gen cash=0
gen value=0
gen choice=0
	replace choice=1 if choice__strip=="strip"
save $data_temp/wtp.dta, replace
replace descr="cash"
replace strip=0
replace cash=1
gen v1=subinstr(grouping_for_strip, "$", "",.)
destring v1, replace
replace value=v1
drop v1
replace choice=1 if choice__strip==grouping_for_strip
replace choice=0 if choice__strip=="strip"
append using $data_temp/wtp.dta
sort id_number

*Average of all controls 
sum treat
	local tr_mean=r(mean)
sum income_25 
	local inc25_mean=r(mean)	
sum income_2550 
	local inc2550_mean=r(mean)	
sum income_50100 
	local inc50100_mean=r(mean)	
sum income_100200 
	local inc100200_mean=r(mean)	
sum income_200 
	local inc200_mean=r(mean)	
sum educ_hs 
	local edhs_mean=r(mean)
sum educ_bach 
	local edbs_mean=r(mean)
sum educ_mast
	local edms_mean=r(mean)
sum hh_size
	local size_mean=r(mean)
sum chilinf_ind
	local child_mean=r(mean)
sum retiree_ind
	local ret_mean=r(mean)
sum well_age_05
	local wella05_mean=r(mean)
sum well_age_610
	local wella610_mean=r(mean)
sum well_age_1120
	local wella1120_mean=r(mean)
sum well_age_ov20
	local wella20_mean=r(mean)
sum well_age_notsure
	local wellans_mean=r(mean)
sum well_dpth_050
	local welld050_mean=r(mean)
sum well_dpth_51150
	local welld501150_mean=r(mean)
sum well_dpth_ov150
	local welld150_mean=r(mean)
sum well_dpth_notsure
	local welldns_mean=r(mean)
sum nit_concern_any0
	local nita_mean=r(mean)
sum nit_concern_none0
	local nitn_mean=r(mean)
sum nit_concern_unsure0
	local nitu_mean=r(mean)	
sum rate_goodgr0
	local rateg_mean=r(mean)
sum rate_neut0
	local raten_mean=r(mean)	
sum rate_poor0
	local ratep_mean=r(mean)
sum rate_unsure0
	local rateu_mean=r(mean)	
 																																	
*Table 3 - McFadden Conditional Logit Choice Model
cmset id_number descr
est clear 

*No Controls
eststo: cmclogit choice strip value, noconstant
nlcom _b[strip]/_b[value]
	matrix mat = r(b)
	estadd scalar wtp = mat[1,1]
nlcom _b[strip]/_b[value]-5
	matrix b = r(b)
	matrix V = r(V)
	local std_err = sqrt(V[1,1])
	local z = b[1,1]/`std_err'
	estadd scalar wtp_cba = 2*normal(-abs(`z'))
	estadd local demo "No"
	estadd local well "No"
	estadd local perc "No"
	
*Treated vs. Untreated
eststo: cmclogit choice strip value, casevars(treat) noconstant
nlcom (_b[strip]+_b[strip:treat]*`tr_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp = mat[1,1]
nlcom _b[strip]/_b[value]
	matrix mat = r(b)
	estadd scalar wtp_cont = mat[1,1]
nlcom (_b[strip]+_b[strip:treat])/_b[value]
	matrix mat = r(b)
	estadd scalar wtp_treat = mat[1,1]
nlcom (_b[strip]+_b[strip:treat])/_b[value]-5
	matrix b = r(b)
	matrix V = r(V)
	local std_err = sqrt(V[1,1])
	local z = b[1,1]/`std_err'
	estadd scalar wtp_cba = 2*normal(-abs(`z'))
	estadd local demo "No"
	estadd local well "No"
	estadd local perc "No"
	
*Demographics
eststo: cmclogit choice strip value, casevars(treat educ_bach educ_mast ///
                                      income_25 income_2550 income_50100 ///
									  income_100200 hh_size ///
									  chilinf_ind retiree_ind) noconstant
nlcom (_b[strip]+_b[strip:treat]*`tr_mean'+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp = mat[1,1]
nlcom (_b[strip]+_b[strip:treat]*`tr_mean'+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]-5
	matrix b = r(b)
	matrix V = r(V)
	local std_err = sqrt(V[1,1])
	local z = b[1,1]/`std_err'
	estadd scalar wtp_cba = 2*normal(-abs(`z'))
nlcom (_b[strip]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp_cont = mat[1,1]
nlcom (_b[strip]+_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp_treat = mat[1,1]	   
	estadd local demo "Yes"
	estadd local well "No"
	estadd local perc "No"
	
*Well Characteristics
eststo: cmclogit choice strip value, casevars(treat well_age_610 ///
                                              well_age_1120 well_age_ov20 ///
								              well_age_notsure ///
											  well_dpth_51150 well_dpth_ov150 ///
											  well_dpth_notsure) noconstant	
nlcom (_b[strip]+_b[strip:treat]*`tr_mean'+ ///
       _b[strip:well_age_610]*`wella610_mean'+ _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+_b[strip:well_age_notsure]*`wellans_mean'+ ///
	   _b[strip:well_dpth_51150]*`welld501150_mean'+_b[strip:well_dpth_ov150]*`welld150_mean'+ ///
	   _b[strip:well_dpth_notsure]*`welldns_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp = mat[1,1]
nlcom (_b[strip]+_b[strip:treat]*`tr_mean'+ ///
       _b[strip:well_age_610]*`wella610_mean'+ _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+_b[strip:well_age_notsure]*`wellans_mean'+ ///
	   _b[strip:well_dpth_51150]*`welld501150_mean'+_b[strip:well_dpth_ov150]*`welld150_mean'+ ///
	   _b[strip:well_dpth_notsure]*`welldns_mean')/_b[value]-5
	matrix b = r(b)
	matrix V = r(V)
	local std_err = sqrt(V[1,1])
	local z = b[1,1]/`std_err'
	estadd scalar wtp_cba = 2*normal(-abs(`z'))
nlcom (_b[strip]+ ///
       _b[strip:well_age_610]*`wella610_mean'+ _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+_b[strip:well_age_notsure]*`wellans_mean'+ ///
	   _b[strip:well_dpth_51150]*`welld501150_mean'+_b[strip:well_dpth_ov150]*`welld150_mean'+ ///
	   _b[strip:well_dpth_notsure]*`welldns_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp_cont = mat[1,1]
nlcom (_b[strip]+_b[strip:treat]+ ///
       _b[strip:well_age_610]*`wella610_mean'+ _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+_b[strip:well_age_notsure]*`wellans_mean'+ ///
	   _b[strip:well_dpth_51150]*`welld501150_mean'+_b[strip:well_dpth_ov150]*`welld150_mean'+ ///
	   _b[strip:well_dpth_notsure]*`welldns_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp_treat = mat[1,1]
	estadd local demo "No"
	estadd local well "Yes"
	estadd local perc "No"
	
*Perceptions
eststo: cmclogit choice strip value, casevars(treat nit_concern_any0 ///
											  nit_concern_none0 nit_concern_unsure0 ///
											  rate_goodgr0 rate_neut0 rate_poor0) ///
											  noconstant	

nlcom (_b[strip]+_b[strip:treat]*`tr_mean'+ ///
       _b[strip:nit_concern_any0]*`nita_mean'+ ///
	   _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+ ///
	   _b[strip:rate_goodgr0]*`rateg_mean' +_b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp = mat[1,1]
nlcom (_b[strip]+_b[strip:treat]*`tr_mean'+ ///
       _b[strip:nit_concern_any0]*`nita_mean'+ ///
	   _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+ ///
	   _b[strip:rate_goodgr0]*`rateg_mean' +_b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean')/_b[value]-5
	matrix b = r(b)
	matrix V = r(V)
	local std_err = sqrt(V[1,1])
	local z = b[1,1]/`std_err'
	estadd scalar wtp_cba = 2*normal(-abs(`z'))
nlcom (_b[strip]+ ///
       _b[strip:nit_concern_any0]*`nita_mean'+ ///
	   _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+ ///
	   _b[strip:rate_goodgr0]*`rateg_mean' +_b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp_cont = mat[1,1]
nlcom (_b[strip]+_b[strip:treat]+ ///
       _b[strip:nit_concern_any0]*`nita_mean'+ ///
	   _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+ ///
	   _b[strip:rate_goodgr0]*`rateg_mean' +_b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean')/_b[value]
	matrix mat = r(b)
	estadd scalar wtp_treat = mat[1,1]											  
	estadd local demo "No"
	estadd local well "No"
	estadd local perc "Yes"
esttab using "$output/table-4.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Willingness to Pay) ///
	drop(strip:rate_* strip:nit_* strip:well_* strip:income_* strip:educ_* ///
	     strip:hh_size strip:chilinf_ind strip:retiree_ind) ///
	coef(strip "Chose Strip" ///
	     value  "Bid" ///
	     strip:treat "Mailed Test Strip") ///
	scalars("wtp WTP" ///
	        "wtp_cont WTP Control" ///
	        "wtp_treat WTP Treated" ///
			"wtp_cba H0: WTP=5" ///
			"demo Demographic Interactions"  ///
			"well Well Characteristic Interactions" ///
			"perc Perception Interactions") ///
	sfmt(%12.2f) mlabels(none) 

frame change main
frame drop regs