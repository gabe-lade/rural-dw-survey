**************************************************************
*Improving Private Well Testing Programs: Experimental Evidence from Iowa
* THIS FILE:
*	1) PRODUCES ALL SUPPLEMENTARY INFORMATION FIGURES AND TABLES
* Last Updated: 5/10/2024
**************************************************************
frame copy main si
frame change si
keep if sample_main==1
	
***********************
*FIGURE S2- 1-Year Testing-Demographic Correlations

****
*Panel a - Income and Testing
reg test_1year0 income_25 income_2550 income_50100  income_100200  income_200 , nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3 
replace x=4 in 4 
replace x=5 in 5 

gen b=.
	replace b=_b[income_25] in 1
	replace b=_b[income_2550] in 2
	replace b=_b[income_50100] in 3
	replace b=_b[income_100200] in 4
	replace b=_b[income_200] in 5
gen ub=.
	replace ub=_b[income_25]+1.96*_se[income_25] in 1
	replace ub=_b[income_2550]+1.96*_se[income_2550] in 2
	replace ub=_b[income_50100]+1.96*_se[income_50100] in 3
	replace ub=_b[income_100200]+1.96*_se[income_100200] in 4
	replace ub=_b[income_200]+1.96*_se[income_200] in 5
gen lb=.
	replace lb=_b[income_25]-1.96*_se[income_25] in 1
	replace lb=_b[income_2550]-1.96*_se[income_2550] in 2
	replace lb=_b[income_50100]-1.96*_se[income_50100] in 3
	replace lb=_b[income_100200]-1.96*_se[income_100200] in 4
	replace lb=_b[income_200]-1.96*_se[income_200] in 5

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "<$25K" 2 "$25K-$50K"3 "$50K-$100K"  4 "$100K-$200K" 5 ">$200K", angle(45) nogrid) ///
	ylabel(0 (0.05) 0.25,nogrid) legend(off) ///
	xtit("") ytit("Tested in Last Year (Baseline Survey)"))
graph export $output\fig-s2a.png, width(4000) replace	
drop x-lb

	
****
*Panel b - Education and Testing
reg test_1year0 educ_hs educ_bach_high , nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[educ_hs] in 1
	replace b=_b[educ_bach] in 2
gen ub=.
	replace ub=_b[educ_hs]+1.96*_se[educ_hs] in 1
	replace ub=_b[educ_bach]+1.96*_se[educ_bach] in 2
gen lb=.
	replace lb=_b[educ_hs]-1.96*_se[educ_hs] in 1
	replace lb=_b[educ_bach]-1.96*_se[educ_bach] in 2
	
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "HS or Less" 2 "BA or Higher",  angle(45) nogrid) ///
    xscale(range(0.8 2.2)) ///
    ylabel(0 (0.05) 0.25,nogrid) legend(off) ///
    xtit("") ytit("Tested in Last Year (Baseline Survey)"))
graph export $output\fig-s2b.png, width(4000) replace	
drop x-lb

	
****
*Panel c - Children and Testing
gen chilinf_ind = 0
	replace chilinf_ind = 1 if children_ind==1|infants_ind==1
	replace chilinf_ind=. if missing(children_ind) & missing(infants_ind)
gen no_chil_ind=0
replace no_chil_ind=1 if chilinf_ind==0

 
reg test_1year0 no_chil_ind chilinf_ind, nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[no_chil_ind] in 1
	replace b=_b[chilinf_ind] in 2
gen ub=.
	replace ub=_b[no_chil_ind]+1.96*_se[no_chil_ind] in 1
	replace ub=_b[chilinf_ind]+1.96*_se[chilinf_ind] in 2
gen lb=.
	replace lb=_b[no_chil_ind]-1.96*_se[no_chil_ind] in 1
	replace lb=_b[chilinf_ind]-1.96*_se[chilinf_ind] in 2
	
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "No Children/Infants" 2 "Children/Infants",  angle(45) nogrid ) ///
    xscale(range(0.8 2.2)) ///
    ylabel(0 (0.05) 0.25,nogrid) legend(off)  ///
    xtit("") ytit("Tested in Last Year (Baseline Survey)"))
graph export $output\fig-s2c.png, width(4000) replace	
drop x-lb

****
*Panel d - Retirees
gen no_retiree_ind=0
replace no_retiree_ind=1 if retiree_ind==0

reg test_1year0 no_retiree_ind retiree_ind, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[no_retiree_ind] in 1
	replace b=_b[retiree_ind] in 2
gen ub=.
	replace ub=_b[no_retiree_ind]+1.96*_se[no_retiree_ind] in 1
	replace ub=_b[retiree_ind]+1.96*_se[retiree_ind] in 2
gen lb=.
	replace lb=_b[no_retiree_ind]-1.96*_se[no_retiree_ind] in 1
	replace lb=_b[retiree_ind]-1.96*_se[retiree_ind] in 2
	
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "No Retirees" 2 "Retirees",  angle(45) nogrid ) ///
    xscale(range(0.8 2.2)) ///
    ylabel(0 (0.05) 0.25,nogrid) legend(off)  ///
    xtit("") ytit("Tested in Last Year (Baseline Survey)"))
graph export $output\fig-s2d.png, width(4000) replace	
drop x-lb
	
****
*Panel e - Well Depth
reg test_1year0 well_dpth_050 well_dpth_51150 well_dpth_ov150 well_dpth_notsure, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3
replace x=4 in 4

gen b=.
	replace b=_b[well_dpth_050] in 1
	replace b=_b[well_dpth_51150] in 2
	replace b=_b[well_dpth_ov150] in 3
	replace b=_b[well_dpth_notsure] in 4
gen ub=.
	replace ub=_b[well_dpth_050]+1.96*_se[well_dpth_050] in 1
	replace ub=_b[well_dpth_51150]+1.96*_se[well_dpth_51150] in 2
	replace ub=_b[well_dpth_ov150]+1.96*_se[well_dpth_ov150] in 3
	replace ub=_b[well_dpth_notsure]+1.96*_se[well_dpth_notsure] in 4
gen lb=.
	replace lb=_b[well_dpth_050]-1.96*_se[well_dpth_050] in 1
	replace lb=_b[well_dpth_51150]-1.96*_se[well_dpth_51150] in 2
	replace lb=_b[well_dpth_ov150]-1.96*_se[well_dpth_ov150] in 3
	replace lb=_b[well_dpth_notsure]-1.96*_se[well_dpth_notsure] in 4

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "<50 Feet" 2 "51-150 Feet" 3 ">150 Feet" 4 "Unsure", angle(45) nogrid) ///
    xtit("") ytit("Tested in Last Year (Baseline Survey)") ///
	ylabel(0 (0.05) 0.25,nogrid) legend(off))   
graph export $output\fig-s2e.png, width(4000) replace	
drop x-lb

	
****
*Panel f - Well Age
reg test_1year0 well_age_05 well_age_610 well_age_1120 well_age_ov20 well_age_notsure, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3
replace x=4 in 4
replace x=5 in 5

gen b=.
	replace b=_b[well_age_05] in 1
	replace b=_b[well_age_610] in 2
	replace b=_b[well_age_1120] in 3
	replace b=_b[well_age_ov20] in 4
	replace b=_b[well_age_notsure] in 5
	
gen ub=.
	replace ub=_b[well_age_05]+1.96*_se[well_age_05] in 1
	replace ub=_b[well_age_610]+1.96*_se[well_age_610] in 2
	replace ub=_b[well_age_1120]+1.96*_se[well_age_1120] in 3
	replace ub=_b[well_age_ov20]+1.96*_se[well_age_ov20] in 4
	replace ub=_b[well_age_notsure]+1.96*_se[well_age_notsure] in 5

gen lb=.
	replace lb=_b[well_age_05]-1.96*_se[well_age_05] in 1
	replace lb=_b[well_age_610]-1.96*_se[well_age_610] in 2
	replace lb=_b[well_age_1120]-1.96*_se[well_age_1120] in 3
	replace lb=_b[well_age_ov20]-1.96*_se[well_age_ov20] in 4
	replace lb=_b[well_age_notsure]-1.96*_se[well_age_notsure] in 5

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "0-5 Years" 2 "6-10 Years" 3 "11-20 Years" 4 ">20 Years" 5 "Unsure", angle(45) nogrid) ///
   	xtit("") ytit("Tested in Last Year (Baseline Survey)") ///
	ylabel(0 (0.05) 0.25,nogrid)  legend(off)) 
graph export $output\fig-s2f.png, width(4000) replace	
drop x-lb


***********************
*FIGURE S3- Avoidance-Demographic Correlations
gen test_filt2_wat=0
	replace test_filt2_wat=1 if test_1year0==1|wholehome_type_ro0==1|cooler_use0==1|bw_use0==1
	replace test_filt2_wat=. if well_drinking0==0

****
*Panel a - Income and Testing
reg test_filt2_wat income_25 income_2550 income_50100  income_100200  income_200 , nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3 
replace x=4 in 4 
replace x=5 in 5 

gen b=.
	replace b=_b[income_25] in 1
	replace b=_b[income_2550] in 2
	replace b=_b[income_50100] in 3
	replace b=_b[income_100200] in 4
	replace b=_b[income_200] in 5
gen ub=.
	replace ub=_b[income_25]+1.96*_se[income_25] in 1
	replace ub=_b[income_2550]+1.96*_se[income_2550] in 2
	replace ub=_b[income_50100]+1.96*_se[income_50100] in 3
	replace ub=_b[income_100200]+1.96*_se[income_100200] in 4
	replace ub=_b[income_200]+1.96*_se[income_200] in 5
gen lb=.
	replace lb=_b[income_25]-1.96*_se[income_25] in 1
	replace lb=_b[income_2550]-1.96*_se[income_2550] in 2
	replace lb=_b[income_50100]-1.96*_se[income_50100] in 3
	replace lb=_b[income_100200]-1.96*_se[income_100200] in 4
	replace lb=_b[income_200]-1.96*_se[income_200] in 5

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "<$25K" 2 "$25K-$50K"3 "$50K-$100K"  4 "$100K-$200K" 5 ">$200K", ///
    angle(45) nogrid) ///
	ylabel(0 (0.1) 0.8,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)") )
graph export $output\fig-s3a.png, width(4000) replace	
drop x-lb

	
****
*Panel b - Education and Testing
reg test_filt2_wat educ_hs educ_bach_high , nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[educ_hs] in 1
	replace b=_b[educ_bach] in 2
gen ub=.
	replace ub=_b[educ_hs]+1.96*_se[educ_hs] in 1
	replace ub=_b[educ_bach]+1.96*_se[educ_bach] in 2
gen lb=.
	replace lb=_b[educ_hs]-1.96*_se[educ_hs] in 1
	replace lb=_b[educ_bach]-1.96*_se[educ_bach] in 2
	
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xscale(range(0.8 2.2)) ///
    xlabel(1 "HS or Less" 2 "BA or Higher", angle(45) nogrid) ///
	ylabel(0 (0.1) 0.8,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)"))
graph export $output\fig-s3b.png, width(4000) replace	
drop x-lb

	
****
*Panel c - Children and Testing
reg test_filt2_wat no_chil_ind chilinf_ind, nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[no_chil_ind] in 1
	replace b=_b[chilinf_ind] in 2
gen ub=.
	replace ub=_b[no_chil_ind]+1.96*_se[no_chil_ind] in 1
	replace ub=_b[chilinf_ind]+1.96*_se[chilinf_ind] in 2
gen lb=.
	replace lb=_b[no_chil_ind]-1.96*_se[no_chil_ind] in 1
	replace lb=_b[chilinf_ind]-1.96*_se[chilinf_ind] in 2
	
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xscale(range(0.8 2.2)) ///
    xlabel(1 "No Children/Infants" 2 "Children/Infants", angle(45) nogrid) ///
    ylabel(0 (0.1) 0.8,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)") )
graph export $output\fig-s3c.png, width(4000) replace	
drop x-lb

****
*Panel d - Retirees
reg test_filt2_wat no_retiree_ind retiree_ind, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[no_retiree_ind] in 1
	replace b=_b[retiree_ind] in 2
gen ub=.
	replace ub=_b[no_retiree_ind]+1.96*_se[no_retiree_ind] in 1
	replace ub=_b[retiree_ind]+1.96*_se[retiree_ind] in 2
gen lb=.
	replace lb=_b[no_retiree_ind]-1.96*_se[no_retiree_ind] in 1
	replace lb=_b[retiree_ind]-1.96*_se[retiree_ind] in 2
	
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xscale(range(0.8 2.2)) ///
    xlabel(1 "No Retirees" 2 "Retirees", angle(45) nogrid) ///
    ylabel(0 (0.1) 0.8,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)"))
graph export $output\fig-s3d.png, width(4000) replace	
drop x-lb
	
****
*Panel e - Well Depth
reg test_filt2_wat well_dpth_050 well_dpth_51150 well_dpth_ov150 well_dpth_notsure, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3
replace x=4 in 4

gen b=.
	replace b=_b[well_dpth_050] in 1
	replace b=_b[well_dpth_51150] in 2
	replace b=_b[well_dpth_ov150] in 3
	replace b=_b[well_dpth_notsure] in 4
gen ub=.
	replace ub=_b[well_dpth_050]+1.96*_se[well_dpth_050] in 1
	replace ub=_b[well_dpth_51150]+1.96*_se[well_dpth_51150] in 2
	replace ub=_b[well_dpth_ov150]+1.96*_se[well_dpth_ov150] in 3
	replace ub=_b[well_dpth_notsure]+1.96*_se[well_dpth_notsure] in 4
gen lb=.
	replace lb=_b[well_dpth_050]-1.96*_se[well_dpth_050] in 1
	replace lb=_b[well_dpth_51150]-1.96*_se[well_dpth_51150] in 2
	replace lb=_b[well_dpth_ov150]-1.96*_se[well_dpth_ov150] in 3
	replace lb=_b[well_dpth_notsure]-1.96*_se[well_dpth_notsure] in 4

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "<50 Feet" 2 "51-150 Feet" 3 ">150 Feet" 4 "Unsure", angle(45) nogrid) ///
    xtit("") ytit("Any Avoidance (Baseline Survey)") ///
	ylabel(0 (0.1) 0.8,nogrid) legend(off))   
graph export $output\fig-s3e.png, width(4000) replace	
drop x-lb

	
****
*Panel f - Well Age
reg test_filt2_wat well_age_05 well_age_610 well_age_1120 well_age_ov20 well_age_notsure, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3
replace x=4 in 4
replace x=5 in 5

gen b=.
	replace b=_b[well_age_05] in 1
	replace b=_b[well_age_610] in 2
	replace b=_b[well_age_1120] in 3
	replace b=_b[well_age_ov20] in 4
	replace b=_b[well_age_notsure] in 5
	
gen ub=.
	replace ub=_b[well_age_05]+1.96*_se[well_age_05] in 1
	replace ub=_b[well_age_610]+1.96*_se[well_age_610] in 2
	replace ub=_b[well_age_1120]+1.96*_se[well_age_1120] in 3
	replace ub=_b[well_age_ov20]+1.96*_se[well_age_ov20] in 4
	replace ub=_b[well_age_notsure]+1.96*_se[well_age_notsure] in 5

gen lb=.
	replace lb=_b[well_age_05]-1.96*_se[well_age_05] in 1
	replace lb=_b[well_age_610]-1.96*_se[well_age_610] in 2
	replace lb=_b[well_age_1120]-1.96*_se[well_age_1120] in 3
	replace lb=_b[well_age_ov20]-1.96*_se[well_age_ov20] in 4
	replace lb=_b[well_age_notsure]-1.96*_se[well_age_notsure] in 5

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "0-5 Years" 2 "6-10 Years" 3 "11-20 Years" 4 ">20 Years" 5 "Unsure", angle(45) nogrid) ///
   	xtit("") ytit("Any Avoidance (Baseline Survey)") ///
	ylabel(0 (0.1) 0.8,nogrid)  legend(off)) 
graph export $output\fig-s3f.png, width(4000) replace	
drop x-lb



***********************
*FIGURE S4- Good/Great Perceptions-Demographic Correlations
gen rate_goodgr0=rate_great0+rate_good0 

****
*Panel a - Income and Testing
reg rate_goodgr0 income_25 income_2550 income_50100  income_100200  income_200 , nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3 
replace x=4 in 4 
replace x=5 in 5 

gen b=.
	replace b=_b[income_25] in 1
	replace b=_b[income_2550] in 2
	replace b=_b[income_50100] in 3
	replace b=_b[income_100200] in 4
	replace b=_b[income_200] in 5
gen ub=.
	replace ub=_b[income_25]+1.96*_se[income_25] in 1
	replace ub=_b[income_2550]+1.96*_se[income_2550] in 2
	replace ub=_b[income_50100]+1.96*_se[income_50100] in 3
	replace ub=_b[income_100200]+1.96*_se[income_100200] in 4
	replace ub=_b[income_200]+1.96*_se[income_200] in 5
gen lb=.
	replace lb=_b[income_25]-1.96*_se[income_25] in 1
	replace lb=_b[income_2550]-1.96*_se[income_2550] in 2
	replace lb=_b[income_50100]-1.96*_se[income_50100] in 3
	replace lb=_b[income_100200]-1.96*_se[income_100200] in 4
	replace lb=_b[income_200]-1.96*_se[income_200] in 5

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "<$25K" 2 "$25K-$50K"3 "$50K-$100K"  4 "$100K-$200K" 5 ">$200K", angle(45) nogrid) ///
	ylabel(0 (0.2) 1,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)"))
graph export $output\fig-s4a.png, width(4000) replace	
drop x-lb

	
****
*Panel b - Education and Testing
reg rate_goodgr0 educ_hs educ_bach_high , nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[educ_hs] in 1
	replace b=_b[educ_bach] in 2
gen ub=.
	replace ub=_b[educ_hs]+1.96*_se[educ_hs] in 1
	replace ub=_b[educ_bach]+1.96*_se[educ_bach] in 2
gen lb=.
	replace lb=_b[educ_hs]-1.96*_se[educ_hs] in 1
	replace lb=_b[educ_bach]-1.96*_se[educ_bach] in 2
	  
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
   xscale(range(0.8 2.2)) ///
   xlabel(1 "HS or Less" 2 "BA or Higher", angle(45) nogrid) ///
   ylabel(0 (0.2) 1,nogrid) legend(off) ///
   xtit("") ytit("Any Avoidance (Baseline Survey)") )
graph export $output\fig-s4b.png, width(4000) replace	
drop x-lb

	
****
*Panel c - Children and Testing
reg rate_goodgr0 no_chil_ind chilinf_ind, nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[no_chil_ind] in 1
	replace b=_b[chilinf_ind] in 2
gen ub=.
	replace ub=_b[no_chil_ind]+1.96*_se[no_chil_ind] in 1
	replace ub=_b[chilinf_ind]+1.96*_se[chilinf_ind] in 2
gen lb=.
	replace lb=_b[no_chil_ind]-1.96*_se[no_chil_ind] in 1
	replace lb=_b[chilinf_ind]-1.96*_se[chilinf_ind] in 2
	
 
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xscale(range(0.8 2.2)) ///
    xlabel(1 "No Children/Infants" 2 "Children/Infants", angle(45) nogrid) ///
    ylabel(0 (0.2) 1,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)") )	 
graph export $output\fig-s4c.png, width(4000) replace	
drop x-lb

****
*Panel d - Retirees
reg rate_goodgr0 no_retiree_ind retiree_ind, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[no_retiree_ind] in 1
	replace b=_b[retiree_ind] in 2
gen ub=.
	replace ub=_b[no_retiree_ind]+1.96*_se[no_retiree_ind] in 1
	replace ub=_b[retiree_ind]+1.96*_se[retiree_ind] in 2
gen lb=.
	replace lb=_b[no_retiree_ind]-1.96*_se[no_retiree_ind] in 1
	replace lb=_b[retiree_ind]-1.96*_se[retiree_ind] in 2
	 
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xscale(range(0.8 2.2)) ///
    xlabel(1 "No Retirees" 2 "Retirees", angle(45) nogrid)  ///
    ylabel(0 (0.2) 1,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)"))	 
graph export $output\fig-s4d.png, width(4000) replace	
drop x-lb
	
****
*Panel e - Well Depth
reg rate_goodgr0 well_dpth_050 well_dpth_51150 well_dpth_ov150 well_dpth_notsure, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3
replace x=4 in 4

gen b=.
	replace b=_b[well_dpth_050] in 1
	replace b=_b[well_dpth_51150] in 2
	replace b=_b[well_dpth_ov150] in 3
	replace b=_b[well_dpth_notsure] in 4
gen ub=.
	replace ub=_b[well_dpth_050]+1.96*_se[well_dpth_050] in 1
	replace ub=_b[well_dpth_51150]+1.96*_se[well_dpth_51150] in 2
	replace ub=_b[well_dpth_ov150]+1.96*_se[well_dpth_ov150] in 3
	replace ub=_b[well_dpth_notsure]+1.96*_se[well_dpth_notsure] in 4
gen lb=.
	replace lb=_b[well_dpth_050]-1.96*_se[well_dpth_050] in 1
	replace lb=_b[well_dpth_51150]-1.96*_se[well_dpth_51150] in 2
	replace lb=_b[well_dpth_ov150]-1.96*_se[well_dpth_ov150] in 3
	replace lb=_b[well_dpth_notsure]-1.96*_se[well_dpth_notsure] in 4

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge) mlwidth(medium) ///
    xlabel(1 "<50 Feet" 2 "51-150 Feet" 3 ">150 Feet" 4 "Unsure", angle(45) nogrid) ///
    xtit("") ytit("Any Avoidance (Baseline Survey)") ///
	ylabel(0 (0.2) 1,nogrid) legend(off))   
graph export $output\fig-s4e.png, width(4000) replace	
drop x-lb

	
****
*Panel f - Well Age
reg rate_goodgr0 well_age_05 well_age_610 well_age_1120 well_age_ov20 well_age_notsure, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3
replace x=4 in 4
replace x=5 in 5

gen b=.
	replace b=_b[well_age_05] in 1
	replace b=_b[well_age_610] in 2
	replace b=_b[well_age_1120] in 3
	replace b=_b[well_age_ov20] in 4
	replace b=_b[well_age_notsure] in 5
	
gen ub=.
	replace ub=_b[well_age_05]+1.96*_se[well_age_05] in 1
	replace ub=_b[well_age_610]+1.96*_se[well_age_610] in 2
	replace ub=_b[well_age_1120]+1.96*_se[well_age_1120] in 3
	replace ub=_b[well_age_ov20]+1.96*_se[well_age_ov20] in 4
	replace ub=_b[well_age_notsure]+1.96*_se[well_age_notsure] in 5

gen lb=.
	replace lb=_b[well_age_05]-1.96*_se[well_age_05] in 1
	replace lb=_b[well_age_610]-1.96*_se[well_age_610] in 2
	replace lb=_b[well_age_1120]-1.96*_se[well_age_1120] in 3
	replace lb=_b[well_age_ov20]-1.96*_se[well_age_ov20] in 4
	replace lb=_b[well_age_notsure]-1.96*_se[well_age_notsure] in 5

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge) mlwidth(medium) ///
    xlabel(1 "0-5 Years" 2 "6-10 Years" 3 "11-20 Years" 4 ">20 Years" 5 "Unsure", angle(45) nogrid) ///
   	xtit("") ytit("Any Avoidance (Baseline Survey)") ///
	ylabel(0 (0.2) 1,nogrid)  legend(off)) 
graph export $output\fig-s4f.png, width(4000) replace	
drop x-lb


***********************
*FIGURE S5- Local Nitrate Concerns-Demographic Correlations

****
*Panel a - Income and Testing
reg nit_concern_local0 income_25 income_2550 income_50100  income_100200  income_200 , nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3 
replace x=4 in 4 
replace x=5 in 5 

gen b=.
	replace b=_b[income_25] in 1
	replace b=_b[income_2550] in 2
	replace b=_b[income_50100] in 3
	replace b=_b[income_100200] in 4
	replace b=_b[income_200] in 5
gen ub=.
	replace ub=_b[income_25]+1.96*_se[income_25] in 1
	replace ub=_b[income_2550]+1.96*_se[income_2550] in 2
	replace ub=_b[income_50100]+1.96*_se[income_50100] in 3
	replace ub=_b[income_100200]+1.96*_se[income_100200] in 4
	replace ub=_b[income_200]+1.96*_se[income_200] in 5
gen lb=.
	replace lb=_b[income_25]-1.96*_se[income_25] in 1
	replace lb=_b[income_2550]-1.96*_se[income_2550] in 2
	replace lb=_b[income_50100]-1.96*_se[income_50100] in 3
	replace lb=_b[income_100200]-1.96*_se[income_100200] in 4
	replace lb=_b[income_200]-1.96*_se[income_200] in 5

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge) mlwidth(medium) ///
    xlabel(1 "<$25K" 2 "$25K-$50K"3 "$50K-$100K"  4 "$100K-$200K" 5 ">$200K", angle(45) nogrid) ///
	ylabel(0 (0.1) 0.4,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)"))
graph export $output\fig-s5a.png, width(4000) replace	
drop x-lb

	
****
*Panel b - Education and Testing
reg nit_concern_local0 educ_hs educ_bach_high , nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[educ_hs] in 1
	replace b=_b[educ_bach] in 2
gen ub=.
	replace ub=_b[educ_hs]+1.96*_se[educ_hs] in 1
	replace ub=_b[educ_bach]+1.96*_se[educ_bach] in 2
gen lb=.
	replace lb=_b[educ_hs]-1.96*_se[educ_hs] in 1
	replace lb=_b[educ_bach]-1.96*_se[educ_bach] in 2

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xscale(range(0.8 2.2)) ///
    xlabel(1 "HS or Less" 2 "BA or Higher", angle(45) nogrid)  ///
    ylabel(0 (0.1) 0.4,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)") )	 
graph export $output\fig-s5b.png, width(4000) replace	
drop x-lb

	
****
*Panel c - Children and Testing
reg nit_concern_local0 no_chil_ind chilinf_ind, nocons
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[no_chil_ind] in 1
	replace b=_b[chilinf_ind] in 2
gen ub=.
	replace ub=_b[no_chil_ind]+1.96*_se[no_chil_ind] in 1
	replace ub=_b[chilinf_ind]+1.96*_se[chilinf_ind] in 2
gen lb=.
	replace lb=_b[no_chil_ind]-1.96*_se[no_chil_ind] in 1
	replace lb=_b[chilinf_ind]-1.96*_se[chilinf_ind] in 2
	
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xscale(range(0.8 2.2)) ///
    xlabel(1 "No Children/Infants" 2 "Children/Infants", angle(45) nogrid)   ///
    ylabel(0 (0.1) 0.4,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)") )	 
graph export $output\fig-s5c.png, width(4000) replace	
drop x-lb

****
*Panel d - Retirees
reg nit_concern_local0 no_retiree_ind retiree_ind, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2

gen b=.
	replace b=_b[no_retiree_ind] in 1
	replace b=_b[retiree_ind] in 2
gen ub=.
	replace ub=_b[no_retiree_ind]+1.96*_se[no_retiree_ind] in 1
	replace ub=_b[retiree_ind]+1.96*_se[retiree_ind] in 2
gen lb=.
	replace lb=_b[no_retiree_ind]-1.96*_se[no_retiree_ind] in 1
	replace lb=_b[retiree_ind]-1.96*_se[retiree_ind] in 2
	
tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xscale(range(0.8 2.2)) ///
    xlabel(1 "No Retirees" 2 "Retirees", angle(45) nogrid)   ///
    ylabel(0 (0.1) 0.4,nogrid) legend(off) ///
	xtit("") ytit("Any Avoidance (Baseline Survey)"))	 
graph export $output\fig-s5d.png, width(4000) replace	
drop x-lb
	
****
*Panel e - Well Depth
reg nit_concern_local0 well_dpth_050 well_dpth_51150 well_dpth_ov150 well_dpth_notsure, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3
replace x=4 in 4

gen b=.
	replace b=_b[well_dpth_050] in 1
	replace b=_b[well_dpth_51150] in 2
	replace b=_b[well_dpth_ov150] in 3
	replace b=_b[well_dpth_notsure] in 4
gen ub=.
	replace ub=_b[well_dpth_050]+1.96*_se[well_dpth_050] in 1
	replace ub=_b[well_dpth_51150]+1.96*_se[well_dpth_51150] in 2
	replace ub=_b[well_dpth_ov150]+1.96*_se[well_dpth_ov150] in 3
	replace ub=_b[well_dpth_notsure]+1.96*_se[well_dpth_notsure] in 4
gen lb=.
	replace lb=_b[well_dpth_050]-1.96*_se[well_dpth_050] in 1
	replace lb=_b[well_dpth_51150]-1.96*_se[well_dpth_51150] in 2
	replace lb=_b[well_dpth_ov150]-1.96*_se[well_dpth_ov150] in 3
	replace lb=_b[well_dpth_notsure]-1.96*_se[well_dpth_notsure] in 4

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge) mlwidth(medium) ///
    xlabel(1 "<50 Feet" 2 "51-150 Feet" 3 ">150 Feet" 4 "Unsure", angle(45) nogrid) ///
    xtit("") ytit("Any Avoidance (Baseline Survey)") ///
	ylabel(0 (0.1) 0.4,nogrid) legend(off))   
graph export $output\fig-s5e.png, width(4000) replace	
drop x-lb
	
****
*Panel f - Well Age
reg nit_concern_local0 well_age_05 well_age_610 well_age_1120 well_age_ov20 well_age_notsure, nocons 
gen x=.
replace x=1 in 1 
replace x=2 in 2
replace x=3 in 3
replace x=4 in 4
replace x=5 in 5

gen b=.
	replace b=_b[well_age_05] in 1
	replace b=_b[well_age_610] in 2
	replace b=_b[well_age_1120] in 3
	replace b=_b[well_age_ov20] in 4
	replace b=_b[well_age_notsure] in 5
	
gen ub=.
	replace ub=_b[well_age_05]+1.96*_se[well_age_05] in 1
	replace ub=_b[well_age_610]+1.96*_se[well_age_610] in 2
	replace ub=_b[well_age_1120]+1.96*_se[well_age_1120] in 3
	replace ub=_b[well_age_ov20]+1.96*_se[well_age_ov20] in 4
	replace ub=_b[well_age_notsure]+1.96*_se[well_age_notsure] in 5

gen lb=.
	replace lb=_b[well_age_05]-1.96*_se[well_age_05] in 1
	replace lb=_b[well_age_610]-1.96*_se[well_age_610] in 2
	replace lb=_b[well_age_1120]-1.96*_se[well_age_1120] in 3
	replace lb=_b[well_age_ov20]-1.96*_se[well_age_ov20] in 4
	replace lb=_b[well_age_notsure]-1.96*_se[well_age_notsure] in 5

tw (rcap ub lb x, lcolor(erose) ) ///
   (scatter b x, m(diamond) mfcolor(edkblue) mlcolor(edkblue) msize(medlarge)  mlwidth(medium) ///
    xlabel(1 "0-5 Years" 2 "6-10 Years" 3 "11-20 Years" 4 ">20 Years" 5 "Unsure", angle(45) nogrid) ///
   	xtit("") ytit("Any Avoidance (Baseline Survey)") ///
	ylabel(0 (0.1) 0.4,nogrid)  legend(off)) 
graph export $output\fig-s5f.png, width(4000) replace	
drop x-lb


***********************
*FIGURE S6a- Mapping Intent to Treat Effects - Any Testing
preserve	
replace county="PALOALTO" if county=="PALO ALTO"
local cty BOONE BREMER BUTLER CEDAR CLAYTON CRAWFORD DALLAS EMMET FAYETTE ///
		  FREMONT IDA JONES MILLS PALOALTO
				
gen bet_county=.
gen cty_fips=.
gen st_fips=.
local i=1				
foreach c of local cty {
reg test_1year treat if county=="`c'"|treat==0
	replace bet_county=_b[treat] in `i'
	sum fips if county=="`c'"
	replace cty_fips=r(mean) in `i'
	replace st_fips=19 in `i'

	loc i=`i'+1
}
keep bet_county cty_fips st_fips
ren st_fips STATEFP
ren cty_fips GEOID
drop if missing(bet_county)
save $data_clean/county_betas.dta, replace

spshape2dta "$data_maps/cb_2018_us_state_500k.shp", replace saving(usa_state)
use usa_state, clear
use usa_state_shp, clear

sleep 1000 
merge m:1 _ID using usa_state  // to get the identifiers
destring STATEFP, replace 
keep if inlist(STATEFP,19)
geo2xy _Y _X, proj(albers) replace
drop _CX- _merge 
 sort _ID shape_order
save  $data_clean/usa_state_shp_clean.dta, replace

sleep 1000
use usa_state, clear
spshape2dta "$data_maps/cb_2018_us_county_500k.shp", replace saving(usa_county)
// clean up the boundaries 
use usa_county_shp, clear

sleep 1000
merge m:1 _ID using usa_county
destring STATEFP, replace 
keep if inlist(STATEFP,19)
drop _CX- _merge 
geo2xy _Y _X, proj(albers) replace
sort _ID shape_order
save  $data_clean/usa_county_shp_clean.dta, replace
use usa_county, clear
destring _all, replace

  
use usa_county, clear
destring _all, replace
sleep 1000
merge 1:1 STATEFP GEOID using $data_clean/county_betas.dta
keep if inlist(STATEFP,19)
drop _m

sum bet_county, det
colorpalette plasma, n(4) nograph reverse 
local colors `r(p)'
spmap bet_county using $data_clean/usa_county_shp_clean, id(_ID)   fcolor("`colors'") clm(custom) clb(0.15(0.05)0.35) ndfcolor(gs16) ndocolor(gs6 ..) ndsize(0.03 ..) ndlabel("No data")  ocolor(gs2 ..) osize(0.003 ..) legend(size(small))
graph export $output/s6a_het1.png, width(4000) replace	
restore
	
	
***********************
*FIGURE S6b- Mapping Intent to Treat Effects - G2C Testing
preserve
replace county="PALOALTO" if county=="PALO ALTO"
local cty BOONE BREMER BUTLER CEDAR CLAYTON CRAWFORD DALLAS EMMET FAYETTE ///
		  FREMONT IDA JONES MILLS PALOALTO		
gen bet_county=.
gen cty_fips=.
gen st_fips=.
local i=1				
foreach c of local cty {
reg test_g2c treat if county=="`c'"|treat==0
	replace bet_county=_b[treat] in `i'
	sum fips if county=="`c'"
	replace cty_fips=r(mean) in `i'
	replace st_fips=19 in `i'

	loc i=`i'+1
}
keep bet_county cty_fips st_fips
ren st_fips STATEFP
ren cty_fips GEOID
drop if missing(bet_county)
save $data_clean/county_betas.dta, replace

spshape2dta "$data_maps/cb_2018_us_state_500k.shp", replace saving(usa_state)
use usa_state, clear
use usa_state_shp, clear
  merge m:1 _ID using usa_state  // to get the identifiers
destring STATEFP, replace 
 keep if inlist(STATEFP,19)
geo2xy _Y _X, proj(albers) replace
drop _CX- _merge 
 sort _ID shape_order
save  $data_clean/usa_state_shp_clean.dta, replace

use usa_state, clear
spshape2dta "$data_maps/cb_2018_us_county_500k.shp", replace saving(usa_county)
// clean up the boundaries 
use usa_county_shp, clear
 merge m:1 _ID using usa_county
  destring STATEFP, replace 
  keep if inlist(STATEFP,19)
  drop _CX- _merge 
  geo2xy _Y _X, proj(albers) replace
  sort _ID shape_order
 save  $data_clean/usa_county_shp_clean.dta, replace
 use usa_county, clear
 destring _all, replace
  
use usa_county, clear
destring _all, replace
merge 1:1 STATEFP GEOID using $data_clean/county_betas.dta
  keep if inlist(STATEFP,19)
drop _m

sum bet_county, det
colorpalette plasma, n(3) nograph reverse 
local colors `r(p)'
spmap bet_county using $data_clean/usa_county_shp_clean, id(_ID)   fcolor("`colors'") clm(custom) clb(-0.05(0.05)0.1) ndfcolor(gs16) ndocolor(gs6 ..) ndsize(0.03 ..) ndlabel("No data")  ocolor(gs2 ..) osize(0.003 ..)  legend(size(small))
graph export $output/s6b_het2.png, width(4000) replace	
restore 
frame change main
frame drop si


***********************
*FIGURE S7 - Heterogeneity in WTP (Demographics)
frame copy main si
frame change si

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
cmset id_number descr

*Saving Results
gen wtp_demo_tr=.
gen wtp_demo_con=.
gen wtp_demo_tr_ub=.
gen wtp_demo_tr_lb=.
gen wtp_demo_con_ub=.
gen wtp_demo_con_lb=.

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
	
cmclogit choice value, casevars(treat educ_bach educ_mast educ_hs ///
                                income_25 income_2550 income_50100 ///
								income_100200 hh_size ///
								chilinf_ind retiree_ind) noconstant	
***
*HS Degree
*Control	   
nlcom (_b[strip:educ_hs]+ ///
	  _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 1
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 1
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 1
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
	  _b[strip:educ_hs]+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 1
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 1
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 1
									  									  
***
*Bachelor's Degree
*Control	   
nlcom (_b[strip:educ_bach]+ ///
	  _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 2
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 2
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 2
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 2
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 2
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 2
	
***
*Master's Degree
*Control	   
nlcom ( _b[strip:educ_mast]+ ///
	  _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 3
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 3
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 3
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_mast]+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 3
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 3
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 3						  
									  
***
*$25K or Less
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_25]+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 4
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 4
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 4
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_25]+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 4
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 4
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 4

***
*$25K-$50K
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_2550]+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 5
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 5
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 5
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_2550]+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 5
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 5
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 5									 

***
*$50K-$100K
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_50100]+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 6
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 6
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 6
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_50100]+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 6
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 6
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 6

***
*$100K-$200K
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_100200]+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 7
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 7
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 7
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_100200]+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 7
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 7
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 7
	
***
*>$200k
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 8
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 8
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 8
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 8
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 8
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 8
		
***
*Household Size==1
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 9
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 9
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 9
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 9
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 9
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 9

***
*HH Size==5
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*5+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 10
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 10
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 10
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*5+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 10
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 10
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 10
	
***
*No Children Infants
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 11
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 11
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 11
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 11
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 11
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 11

***
*Children/Infants in Home
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 12
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 12
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 12
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]+ ///
	   _b[strip:retiree_ind]*`ret_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 12
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 12
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 12	

***
*No Retirees 
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 13
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 13
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 13
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 13
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 13
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 13

***
*Retirees 
*Control	   
nlcom (_b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	  _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_con=mat[1,1] in 14
replace wtp_demo_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 14
replace wtp_demo_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 14
	   	   
*Treatment
nlcom (_b[strip:treat]+ ///
       _b[strip:educ_bach]*`edbs_mean'+ _b[strip:educ_mast]*`edms_mean'+ ///
	  _b[strip:educ_hs]*`edhs_mean'+ ///
	   _b[strip:income_25]*`inc25_mean'+_b[strip:income_2550]*`inc2550_mean'+ ///
	   _b[strip:income_50100]*`inc50100_mean'+_b[strip:income_100200]*`inc100200_mean'+ ///
	   _b[strip:hh_size]*`size_mean'+_b[strip:chilinf_ind]*`child_mean'+ ///
	   _b[strip:retiree_ind])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_demo_tr=mat[1,1] in 14
replace wtp_demo_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 14
replace wtp_demo_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 14

*Graphing
gen i=.
replace i=1 in 1
replace i=2 in 2
replace i=3 in 3
replace i=5 in 4
replace i=6 in 5
replace i=7 in 6
replace i=8 in 7
replace i=9 in 8
replace i=11 in 9
replace i=12 in 10
replace i=14 in 11
replace i=15 in 12
replace i=17 in 13
replace i=18 in 14
	
twoway (rspike wtp_demo_con_ub wtp_demo_con_lb i,  horizontal lcolor(erose) ) ///
		(scatter  i wtp_demo_con, color(edkblue)), ///
graphr(color(white)) ysc(reverse) ///
	xtit("Average Willingness to Pay") ///
	ytit("") legend(off) ///
	xline(10.11, lc(black) lp(dash)) ///
	xline(16.19, lc(black) lp(solid)) ///
	xlabel(0 (5) 30,nogrid)	///
	ylabel(1 "High School Degree or Less" 2 "Bachelor's Degree" ///
	       3 "Master's Degree or Higher" ///
	       5 "Income <$25K" 6 "Income $25K-$50K" 7 "Income $50K-$100K" ///
		   8 "Income $100K-$200K" 9 "Income >$200K" ///
		   11 "HH Size==1" 12 "HH Size==5" ///
		   14 "No Infants/Children" 15 "Infants/Children" ///
		   17 "No Retirees" 18 "Retirees" , ///
		   angle(horizontal)  labsize(small) nogrid) 
graph export $output\fig-s7a.png, width(4000) replace	

twoway (rspike wtp_demo_tr_ub wtp_demo_tr_lb i,  horizontal lcolor(erose) ) ///
		(scatter  i wtp_demo_tr, color(cranberry)  m(diamond)), ///
graphr(color(white)) ysc(reverse) ///
	xtit("Average Willingness to Pay") ///
	ytit("") legend(off) ///
	xline(10.11, lc(black) lp(dash)) ///
	xline(16.19, lc(black) lp(solid)) ///
	xlabel(0 (5) 30,nogrid)	///
	ylabel(1 "High School Degree or Less" 2 "Bachelor's Degree" ///
	       3 "Master's Degree or Higher" ///
	       5 "Income <$25K" 6 "Income $25K-$50K" 7 "Income $50K-$100K" ///
		   8 "Income $100K-$200K" 9 "Income >$200K" ///
		   11 "HH Size==1" 12 "HH Size==5" ///
		   14 "No Infants/Children" 15 "Infants/Children" ///
		   17 "No Retirees" 18 "Retirees" , ///
		   angle(horizontal)  labsize(small) nogrid) 
graph export $output\fig-s7b.png, width(4000) replace	
drop wtp_demo_tr-wtp_demo_con_lb i


***********************
*FIGURE S8 - Heterogeneity in WTP (Well Characteristics)
gen wtp_well_tr=.
gen wtp_well_con=.
gen wtp_well_tr_ub=.
gen wtp_well_tr_lb=.
gen wtp_well_con_ub=.
gen wtp_well_con_lb=.
sum treat
	local tr_mean=r(mean)
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
	
cmclogit choice value, casevars(treat well_age_05 well_age_610 ///
                                well_age_1120 well_age_ov20 ///
								well_age_notsure ///
								well_dpth_050 well_dpth_51150 ///
								well_dpth_ov150) noconstant	
										  
***
*Age 0-5 Years 
*Control	
nlcom (_b[strip:well_age_05]+ ///
	    _b[strip:well_dpth_050]*`welld050_mean'+ ///
		_b[strip:well_dpth_51150]*`welld501150_mean'+ ///
		_b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_con=mat[1,1] in 1
replace wtp_well_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 1
replace wtp_well_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 1

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:well_age_05]+ ///
	   _b[strip:well_dpth_050]*`welld050_mean'+ ///
	   _b[strip:well_dpth_51150]*`welld501150_mean'+ ///
	   _b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_tr=mat[1,1] in 1
replace wtp_well_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 1
replace wtp_well_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 1
									  
***
*Age 6-10 Years 
*Control	
nlcom (_b[strip:well_age_610]+ ///
	    _b[strip:well_dpth_050]*`welld050_mean'+ ///
		_b[strip:well_dpth_51150]*`welld501150_mean'+ ///
		_b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_con=mat[1,1] in 2
replace wtp_well_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 2
replace wtp_well_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 2

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:well_age_610]+ ///
	   _b[strip:well_dpth_050]*`welld050_mean'+ ///
	   _b[strip:well_dpth_51150]*`welld501150_mean'+ ///
	   _b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_tr=mat[1,1] in 2
replace wtp_well_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 2
replace wtp_well_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 2

***
*Age 11-20 Years 
*Control	
nlcom (_b[strip:well_age_1120]+ ///
	    _b[strip:well_dpth_050]*`welld050_mean'+ ///
		_b[strip:well_dpth_51150]*`welld501150_mean'+ ///
		_b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_con=mat[1,1] in 3
replace wtp_well_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 3
replace wtp_well_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 3

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:well_age_1120]+ ///
	   _b[strip:well_dpth_050]*`welld050_mean'+ ///
	   _b[strip:well_dpth_51150]*`welld501150_mean'+ ///
	   _b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_tr=mat[1,1] in 3
replace wtp_well_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 3
replace wtp_well_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 3

***
*Age >20 Years 
*Control	
nlcom (_b[strip:well_age_ov20]+ ///
	    _b[strip:well_dpth_050]*`welld050_mean'+ ///
		_b[strip:well_dpth_51150]*`welld501150_mean'+ ///
		_b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_con=mat[1,1] in 4
replace wtp_well_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 4
replace wtp_well_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 4

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:well_age_ov20]+ ///
	   _b[strip:well_dpth_050]*`welld050_mean'+ ///
	   _b[strip:well_dpth_51150]*`welld501150_mean'+ ///
	   _b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_tr=mat[1,1] in 4
replace wtp_well_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 4
replace wtp_well_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 4

***
*Age Unknown
*Control	
nlcom (_b[strip:well_age_notsure]+ ///
	    _b[strip:well_dpth_050]*`welld050_mean'+ ///
		_b[strip:well_dpth_51150]*`welld501150_mean'+ ///
		_b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_con=mat[1,1] in 5
replace wtp_well_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 5
replace wtp_well_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 5

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:well_age_notsure]+ ///
	   _b[strip:well_dpth_050]*`welld050_mean'+ ///
	   _b[strip:well_dpth_51150]*`welld501150_mean'+ ///
	   _b[strip:well_dpth_ov150]*`welld150_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_tr=mat[1,1] in 5
replace wtp_well_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 5
replace wtp_well_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 5

***
*Depth 0-50 Feet
*Control	
nlcom (_b[strip:well_age_05]*`wella05_mean'+ ///
      _b[strip:well_age_610]*`wella610_mean'+ ///
	  _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+ ///
	   _b[strip:well_age_notsure]*`wellans_mean'+ ///
	    _b[strip:well_dpth_050])/_b[value]	
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_con=mat[1,1] in 6
replace wtp_well_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 6
replace wtp_well_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 6

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:well_age_05]*`wella05_mean'+ ///
       _b[strip:well_age_610]*`wella610_mean'+ ///
	   _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+ ///
	   _b[strip:well_age_notsure]*`wellans_mean'+ ///
	   _b[strip:well_dpth_050])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_tr=mat[1,1] in 6
replace wtp_well_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 6
replace wtp_well_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 6

***
*Depth 51-150 Feet
*Control	
nlcom (_b[strip:well_age_05]*`wella05_mean'+ ///
      _b[strip:well_age_610]*`wella610_mean'+ ///
	  _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+ ///
	   _b[strip:well_age_notsure]*`wellans_mean'+ ///
	    _b[strip:well_dpth_51150])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_con=mat[1,1] in 7
replace wtp_well_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 7
replace wtp_well_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 7

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:well_age_05]*`wella05_mean'+ ///
       _b[strip:well_age_610]*`wella610_mean'+ ///
	   _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+ ///
	   _b[strip:well_age_notsure]*`wellans_mean'+ ///
	   _b[strip:well_dpth_51150])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_tr=mat[1,1] in 7
replace wtp_well_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 7
replace wtp_well_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 7

***
*Depth >150 Feet
*Control	
nlcom (_b[strip:well_age_05]*`wella05_mean'+ ///
      _b[strip:well_age_610]*`wella610_mean'+ ///
	  _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+ ///
	   _b[strip:well_age_notsure]*`wellans_mean'+ ///
	    _b[strip:well_dpth_ov150])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_con=mat[1,1] in 8
replace wtp_well_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 8
replace wtp_well_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 8

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:well_age_05]*`wella05_mean'+ ///
       _b[strip:well_age_610]*`wella610_mean'+ ///
	   _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+ ///
	   _b[strip:well_age_notsure]*`wellans_mean'+ ///
	   _b[strip:well_dpth_ov150])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_tr=mat[1,1] in 8
replace wtp_well_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 8
replace wtp_well_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 8

***
*Depth Unsure
*Control	
nlcom (_b[strip:well_age_05]*`wella05_mean'+ ///
      _b[strip:well_age_610]*`wella610_mean'+ ///
	  _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+ ///
	   _b[strip:well_age_notsure]*`wellans_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_con=mat[1,1] in 9
replace wtp_well_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 9
replace wtp_well_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 9

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:well_age_05]*`wella05_mean'+ ///
       _b[strip:well_age_610]*`wella610_mean'+ ///
	   _b[strip:well_age_1120]*`wella1120_mean'+ ///
	   _b[strip:well_age_ov20]*`wella20_mean'+ ///
	   _b[strip:well_age_notsure]*`wellans_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_well_tr=mat[1,1] in 9
replace wtp_well_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 9
replace wtp_well_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 9

*Graphing
gen i=.
replace i=1 in 1
replace i=2 in 2
replace i=3 in 3
replace i=4 in 4
replace i=5 in 5
replace i=7 in 6
replace i=8 in 7
replace i=9 in 8
replace i=10 in 9

twoway (rspike wtp_well_con_ub wtp_well_con_lb i,  horizontal lcolor(erose) ) ///
		(scatter  i wtp_well_con, color(edkblue)), ///
graphr(color(white)) ysc(reverse) ///
	xtit("Average Willingness to Pay") ///
	ytit("") legend(off) ///
	xline(10.20, lc(black) lp(dash)) ///
	xline(16.17, lc(black) lp(solid)) ///
	xlabel(0 (5) 30,nogrid)	///
	ylabel(1 "Age: 0-5 Years" 2 "Age: 6-10 Years" 3 "Age: 11-20 Years" ///
	       4 "Age: >20 Years" 5 "Age: Unknown" 7 "Depth: 0-50 Feet" ///
		   8 "Depth: 51-150 Feet" 9 "Depth: >150 Feet" ///
		   10 "Depth: Unknown", angle(horizontal)  labsize(small) nogrid) 
graph export $output\fig-s8a.png, width(4000) replace	

twoway (rspike wtp_well_tr_ub wtp_well_tr_lb i,  horizontal lcolor(erose) ) ///
		(scatter  i wtp_well_tr, color(cranberry)  m(diamond)), ///
graphr(color(white)) ysc(reverse) ///
	xtit("Average Willingness to Pay") ///
	ytit("") legend(off) ///
	xline(10.20, lc(black) lp(dash)) ///
	xline(16.17, lc(black) lp(solid)) ///
	xlabel(0 (5) 30,nogrid)	///
	ylabel(1 "Age: 0-5 Years" 2 "Age: 6-10 Years" 3 "Age: 11-20 Years" ///
	       4 "Age: >20 Years" 5 "Age: Unknown" 7 "Depth: 0-50 Feet" ///
		   8 "Depth: 51-150 Feet" 9 "Depth: >150 Feet" ///
		   10 "Depth: Unknown", angle(horizontal)  labsize(small) nogrid) 
graph export $output\fig-s8b.png, width(4000) replace	
drop wtp_well_tr-i


***********************
*FIGURE S9 - Heterogeneity in WTP (Baseline Perceptions)
gen wtp_per_tr=.
gen wtp_per_con=.
gen wtp_per_tr_ub=.
gen wtp_per_tr_lb=.
gen wtp_per_con_ub=.
gen wtp_per_con_lb=.
sum treat
	local tr_mean=r(mean)
sum nit_concern_any0
	local nita_mean=r(mean)
sum nit_concern_none0
	local nitn_mean=r(mean)
sum nit_concern_unsure0
	local nitu_mean=r(mean)
sum rate_goodgr0
	local rategr_mean=r(mean)
sum rate_neut0
	local raten_mean=r(mean)
sum rate_poor0
	local ratep_mean=r(mean)
sum rate_unsure0
	local rateu_mean=r(mean)
	
cmclogit choice value, casevars(treat nit_concern_any0 nit_concern_none0 ///
	  nit_concern_unsure0 rate_goodgr0 rate_neut0 rate_poor0 rate_unsure0) noconstant
	    
***
*Nitrate Concerns: Any
*Control	
nlcom (_b[strip:nit_concern_any0]+ ///
      _b[strip:rate_goodgr0]*`rategr_mean'+ ///
	   _b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean'+ ///
	    _b[strip:rate_unsure0]*`rateu_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_con=mat[1,1] in 1
replace wtp_per_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 1
replace wtp_per_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 1

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:nit_concern_any0]+ ///
      _b[strip:rate_goodgr0]*`rategr_mean'+ ///
	   _b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean'+ ///
	   _b[strip:rate_unsure0]*`rateu_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_tr=mat[1,1] in 1
replace wtp_per_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 1
replace wtp_per_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 1
  
***
*Nitrate Concerns: None
*Control	
nlcom (_b[strip:nit_concern_none0]+ ///
      _b[strip:rate_goodgr0]*`rategr_mean'+ ///
	   _b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean'+ ///
	    _b[strip:rate_unsure0]*`rateu_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_con=mat[1,1] in 2
replace wtp_per_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 2
replace wtp_per_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 2

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:nit_concern_none0]+ ///
      _b[strip:rate_goodgr0]*`rategr_mean'+ ///
	   _b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean'+ ///
	   _b[strip:rate_unsure0]*`rateu_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_tr=mat[1,1] in 2
replace wtp_per_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 2
replace wtp_per_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 2
  
***
*Nitrate Concerns: Unsure
*Control	
nlcom (_b[strip:nit_concern_unsure0]+ ///
      _b[strip:rate_goodgr0]*`rategr_mean'+ ///
	   _b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean'+ ///
	    _b[strip:rate_unsure0]*`rateu_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_con=mat[1,1] in 3
replace wtp_per_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 3
replace wtp_per_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 3

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:nit_concern_unsure0]+ ///
      _b[strip:rate_goodgr0]*`rategr_mean'+ ///
	   _b[strip:rate_neut0]*`raten_mean'+ ///
	   _b[strip:rate_poor0]*`ratep_mean'+ ///
	   _b[strip:rate_unsure0]*`rateu_mean')/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_tr=mat[1,1] in 3
replace wtp_per_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 3
replace wtp_per_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 3
  
***
*Rate Good/Great
*Control	
nlcom (_b[strip:nit_concern_any0]*`nita_mean'+ ///
       _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+  ///
      _b[strip:rate_goodgr0])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_con=mat[1,1] in 4
replace wtp_per_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 4
replace wtp_per_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 4

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:nit_concern_any0]*`nita_mean'+ ///
       _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+  ///
      _b[strip:rate_goodgr0])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_tr=mat[1,1] in 4
replace wtp_per_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 4
replace wtp_per_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 4

***
*Rate Neutral
*Control	
nlcom (_b[strip:nit_concern_any0]*`nita_mean'+ ///
       _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+  ///
      _b[strip:rate_neut0])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_con=mat[1,1] in 5
replace wtp_per_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 5
replace wtp_per_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 5

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:nit_concern_any0]*`nita_mean'+ ///
       _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+  ///
      _b[strip:rate_neut0])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_tr=mat[1,1] in 5
replace wtp_per_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 5
replace wtp_per_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 5

***
*Rate Poor
*Control	
nlcom (_b[strip:nit_concern_any0]*`nita_mean'+ ///
       _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+  ///
      _b[strip:rate_poor0])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_con=mat[1,1] in 6
replace wtp_per_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 6
replace wtp_per_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 6

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:nit_concern_any0]*`nita_mean'+ ///
       _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+  ///
      _b[strip:rate_poor0])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_tr=mat[1,1] in 6
replace wtp_per_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 6
replace wtp_per_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 6

***
*Rate Unsure
*Control	
nlcom (_b[strip:nit_concern_any0]*`nita_mean'+ ///
       _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+  ///
      _b[strip:rate_unsure0])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_con=mat[1,1] in 7
replace wtp_per_con_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 7
replace wtp_per_con_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 7

*Treatment
nlcom (_b[strip:treat] + /// 
       _b[strip:nit_concern_any0]*`nita_mean'+ ///
       _b[strip:nit_concern_none0]*`nitn_mean'+ ///
	   _b[strip:nit_concern_unsure0]*`nitu_mean'+  ///
      _b[strip:rate_unsure0])/_b[value]
matrix mat = r(b)
matrix vcv=r(V)
replace wtp_per_tr=mat[1,1] in 7
replace wtp_per_tr_ub=mat[1,1]+1.96*sqrt(vcv[1,1]) in 7
replace wtp_per_tr_lb=mat[1,1]-1.96*sqrt(vcv[1,1]) in 7

*Graphing
gen i=.
replace i=1 in 1
replace i=2 in 2
replace i=3 in 3
replace i=5 in 4
replace i=6 in 5
replace i=7 in 6
replace i=8 in 7

twoway (rspike wtp_per_con_ub wtp_per_con_lb i,  horizontal lcolor(erose) ) ///
		(scatter  i wtp_per_con, color(edkblue)), ///
graphr(color(white)) ysc(reverse) ///
	xtit("Average Willingness to Pay") ///
	ytit("") legend(off) ///
	xline(10.67, lc(black) lp(dash)) ///
	xline(16.82, lc(black) lp(solid)) ///
	xlabel(0 (5) 30,nogrid)	///
	ylabel(1 "Nitrate Concerns: Any" 2 "Nitrate Concerns: None" ///
	       3 "Nitrate Concerns: Unknown" ///
	       5 "Water Rating: Good/Great" 6 "Water Rating: Neutral" ///
		   7 "Water Rating: Poor" 8 "Water Rating: Unsure", ///
		   angle(horizontal)  labsize(small) nogrid) 
graph export $output\fig-s9a.png, width(4000) replace	

twoway (rspike wtp_per_tr_ub wtp_per_tr_lb i,  horizontal lcolor(erose) ) ///
		(scatter  i wtp_per_tr, color(cranberry)  m(diamond)), ///
graphr(color(white)) ysc(reverse) ///
	xtit("Average Willingness to Pay") ///
	ytit("") legend(off) ///
	xline(10.67, lc(black) lp(dash)) ///
	xline(16.82, lc(black) lp(solid)) ///
	xlabel(0 (5) 30,nogrid)	///
	ylabel(1 "Nitrate Concerns: Any" 2 "Nitrate Concerns: None" ///
	       3 "Nitrate Concerns: Unknown" ///
	       5 "Water Rating: Good/Great" 6 "Water Rating: Neutral" ///
		   7 "Water Rating: Poor" 8 "Water Rating: Unsure", ///
		   angle(horizontal)  labsize(small) nogrid)  
graph export $output\fig-s9b.png, width(4000) replace	
drop wtp_per_tr-i
frame change main
frame drop si


***********************
*TABLE S1- G2C Nearby Nitrate Test Results           
frame copy main si
frame change si
keep if sample_main==1
preserve

***
*All Years
gen hi_nit_own=0 if !missing(nit_own)
	replace hi_nit_own=1 if nit_own>=10 & !missing(nit_own)
gen hi_nit_p5mi=0 if !missing(nit_p5mi)
	replace hi_nit_p5mi=1 if nit_p5mi>=10 & !missing(nit_p5mi)
gen hi_nit_1mi=0 if !missing(nit_1mi)
	replace hi_nit_1mi=1 if nit_1mi>=10 & !missing(nit_1mi)
gen hi_nit_2mi=0 if !missing(nit_2mi)
	replace hi_nit_2mi=1 if nit_2mi>=10 & !missing(nit_2mi)
gen hi_nit_5mi=0 if !missing(nit_5mi)
	replace hi_nit_5mi=1 if nit_5mi>=10 & !missing(nit_5mi)
gen hi_nit_10mi=0 if !missing(nit_10mi)
	replace hi_nit_10mi=1 if nit_10mi>=10 & !missing(nit_10mi)
	
*Own Nitrate
sum nit_own
	scalar own = r(mean)	
sum hi_nit_own
	scalar own_v = r(mean)
sum nit_own if treat==0
	scalar own_cont = r(mean)	
sum hi_nit_own if treat==0
	scalar own_cont_v = r(mean)
sum nit_own if treat==1
	scalar own_treat = r(mean)
sum hi_nit_own if treat==1
	scalar own_treat_v = r(mean)
reg nit_own treat
	test treat
	scalar own_p=r(p)
reg hi_nit_own treat
	test treat
	scalar own_p_v=r(p)
	
*Nitrate <0.5 Miles
sum nit_p5mi
	scalar p5mi = r(mean)	
sum hi_nit_p5mi
	scalar p5mi_v = r(mean)	
sum nit_p5mi if treat==0
	scalar p5mi_cont = r(mean)	
sum hi_nit_p5mi if treat==0
	scalar p5mi_cont_v = r(mean)	
sum nit_p5mi if treat==1
	scalar p5mi_treat = r(mean)
sum hi_nit_p5mi if treat==1
	scalar p5mi_treat_v = r(mean)
reg nit_p5mi treat
	test treat
	scalar p5mi_p=r(p)
reg hi_nit_p5mi treat
	test treat
	scalar p5mi_p_v=r(p)
	
*Nitrate <1 Miles
sum nit_1mi
	scalar n1mi = r(mean)	
sum hi_nit_1mi
	scalar n1mi_v = r(mean)		
sum nit_1mi if treat==0
	scalar n1mi_cont = r(mean)	
sum hi_nit_1mi if treat==0
	scalar n1mi_cont_v = r(mean)	
sum nit_1mi if treat==1
	scalar n1mi_treat = r(mean)
sum hi_nit_1mi if treat==1
	scalar n1mi_treat_v = r(mean)
reg nit_1mi treat
	test treat
	scalar n1mi_p=r(p)
reg hi_nit_1mi treat
	test treat
	scalar n1mi_p_v=r(p)
	
*Nitrate <2 Miles
sum nit_2mi
	scalar n2mi = r(mean)	
sum hi_nit_2mi
	scalar n2mi_v = r(mean)	
sum nit_2mi if treat==0
	scalar n2mi_cont = r(mean)
sum hi_nit_2mi if treat==0
	scalar n2mi_cont_v = r(mean)
sum nit_2mi if treat==1
	scalar n2mi_treat = r(mean)
sum hi_nit_2mi if treat==1
	scalar n2mi_treat_v = r(mean)
reg nit_2mi treat
	test treat
	scalar n2mi_p=r(p)
reg hi_nit_2mi treat
	test treat
	scalar n2mi_p_v=r(p)
	
*Nitrate <5 Miles
sum nit_5mi
	scalar n5mi = r(mean)	
sum hi_nit_5mi
	scalar n5mi_v = r(mean)	
sum nit_5mi if treat==0
	scalar n5mi_cont = r(mean)	
sum hi_nit_5mi if treat==0
	scalar n5mi_cont_v = r(mean)	
sum nit_5mi if treat==1
	scalar n5mi_treat = r(mean)
sum hi_nit_5mi if treat==1
	scalar n5mi_treat_v = r(mean)	
reg nit_5mi treat
	test treat
	scalar n5mi_p=r(p)
reg hi_nit_5mi treat
	test treat
	scalar n5mi_p_v=r(p)
	
*Nitrate <10 Miles
sum nit_10mi
	scalar n10mi = r(mean)	
sum hi_nit_10mi
	scalar n10mi_v = r(mean)	
sum nit_10mi if treat==0
	scalar n10mi_cont = r(mean)	
sum hi_nit_10mi if treat==0
	scalar n10mi_cont_v = r(mean)	
sum nit_10mi if treat==1
	scalar n10mi_treat = r(mean)
sum hi_nit_10mi if treat==1
	scalar n10mi_treat_v = r(mean)
reg nit_10mi treat
	test treat
	scalar n10mi_p=r(p)
reg hi_nit_10mi treat
	test treat
	scalar n10mi_p_v=r(p)
*
***
*Previous 3 Years 
gen hi_nit_own_3yr=0 if !missing(nit_own_3yr)
	replace hi_nit_own_3yr=1 if nit_own_3yr>=10 & !missing(nit_own_3yr)
gen hi_nit_p5mi_3yr=0 if !missing(nit_p5mi_3yr)
	replace hi_nit_p5mi_3yr=1 if nit_p5mi_3yr>=10 & !missing(nit_p5mi_3yr)
gen hi_nit_1mi_3yr=0 if !missing(nit_1mi_3yr)
	replace hi_nit_1mi_3yr=1 if nit_1mi_3yr>=10 & !missing(nit_1mi_3yr)
gen hi_nit_2mi_3yr=0 if !missing(nit_2mi_3yr)
	replace hi_nit_2mi_3yr=1 if nit_2mi_3yr>=10 & !missing(nit_2mi_3yr)
gen hi_nit_5mi_3yr=0 if !missing(nit_5mi_3yr)
	replace hi_nit_5mi_3yr=1 if nit_5mi_3yr>=10 & !missing(nit_5mi_3yr)
gen hi_nit_10mi_3yr=0 if !missing(nit_10mi_3yr)
	replace hi_nit_10mi_3yr=1 if nit_10mi_3yr>=10 & !missing(nit_10mi_3yr)
		
*Own Nitrate - Previous 3 Years
sum nit_own_3yr
	scalar own_3yr = r(mean)	
sum hi_nit_own_3yr
	scalar own_3yr_v = r(mean)	
sum nit_own_3yr if treat==0
	scalar own_cont_3yr = r(mean)
sum hi_nit_own_3yr if treat==0
	scalar own_cont_3yr_v = r(mean)	
sum nit_own_3yr if treat==1
	scalar own_treat_3yr = r(mean)
sum hi_nit_own_3yr if treat==1
	scalar own_treat_3yr_v = r(mean)
reg nit_own_3yr treat
	test treat
	scalar own_p_3yr=r(p)
reg hi_nit_own_3yr treat
	test treat
	scalar own_p_3yr_v=r(p)
	
*Nitrate <0.5 Miles - Previous 3 Years
sum nit_p5mi_3yr
	scalar p5mi_3yr = r(mean)	
sum hi_nit_p5mi_3yr
	scalar p5mi_3yr_v = r(mean)	
sum nit_p5mi_3yr if treat==0
	scalar p5mi_cont_3yr = r(mean)	
sum hi_nit_p5mi_3yr if treat==0
	scalar p5mi_cont_3yr_v = r(mean)	
sum nit_p5mi_3yr if treat==1
	scalar p5mi_treat_3yr = r(mean)
sum hi_nit_p5mi_3yr if treat==1
	scalar p5mi_treat_3yr_v = r(mean)
reg nit_p5mi_3yr treat
	test treat
	scalar p5mi_p_3yr=r(p)
reg hi_nit_p5mi_3yr treat
	test treat
	scalar p5mi_p_3yr_v=r(p)
	
*Nitrate <1 Miles - Previous 3 Years
sum nit_1mi_3yr
	scalar n1mi_3yr = r(mean)	
sum hi_nit_1mi_3yr
	scalar n1mi_3yr_v = r(mean)		
sum nit_1mi_3yr if treat==0
	scalar n1mi_cont_3yr = r(mean)	
sum hi_nit_1mi_3yr if treat==0
	scalar n1mi_cont_3yr_v = r(mean)		
sum nit_1mi_3yr if treat==1
	scalar n1mi_treat_3yr = r(mean)
sum hi_nit_1mi_3yr if treat==1
	scalar n1mi_treat_3yr_v = r(mean)
reg nit_1mi_3yr treat
	test treat
	scalar n1mi_p_3yr=r(p)
reg hi_nit_1mi_3yr treat
	test treat
	scalar n1mi_p_3yr_v=r(p)
	
*Nitrate <2 Miles - Previous 3 Years
sum nit_2mi_3yr
	scalar n2mi_3yr = r(mean)	
sum hi_nit_2mi_3yr
	scalar n2mi_3yr_v = r(mean)	
sum nit_2mi_3yr if treat==0
	scalar n2mi_cont_3yr = r(mean)	
sum hi_nit_2mi_3yr if treat==0
	scalar n2mi_cont_3yr_v = r(mean)	
sum nit_2mi_3yr if treat==1
	scalar n2mi_treat_3yr = r(mean)
sum hi_nit_2mi_3yr if treat==1
	scalar n2mi_treat_3yr_v = r(mean) 
reg nit_2mi_3yr treat
	test treat
	scalar n2mi_p_3yr=r(p)
reg hi_nit_2mi_3yr treat
	test treat
	scalar n2mi_p_3yr_v=r(p)
	
*Nitrate <5 Miles - Previous 3 Years
sum nit_5mi_3yr
	scalar n5mi_3yr = r(mean)	
sum hi_nit_5mi_3yr
	scalar n5mi_3yr_v = r(mean)		
sum nit_5mi_3yr if treat==0
	scalar n5mi_cont_3yr = r(mean)	
sum hi_nit_5mi_3yr if treat==0
	scalar n5mi_cont_3yr_v = r(mean)	
sum nit_5mi_3yr if treat==1
	scalar n5mi_treat_3yr = r(mean)
sum hi_nit_5mi_3yr if treat==1
	scalar n5mi_treat_3yr_v = r(mean)
reg nit_5mi_3yr treat
	test treat
	scalar n5mi_p_3yr=r(p)
reg hi_nit_5mi_3yr treat
	test treat
	scalar n5mi_p_3yr_v=r(p)
	
*Nitrate <10 Miles - Previous 3 Years
sum nit_10mi_3yr
	scalar n10mi_3yr = r(mean)	
sum hi_nit_10mi_3yr
	scalar n10mi_3yr_v = r(mean)
sum nit_10mi_3yr if treat==0
	scalar n10mi_cont_3yr = r(mean)	
sum hi_nit_10mi_3yr if treat==0
	scalar n10mi_cont_3yr_v = r(mean)	
sum nit_10mi_3yr if treat==1
	scalar n10mi_treat_3yr = r(mean)
sum hi_nit_10mi_3yr if treat==1
	scalar n10mi_treat_3yr_v = r(mean)
reg nit_10mi_3yr treat
	test treat
	scalar n10mi_p_3yr=r(p)
reg hi_nit_10mi_3yr treat
	test treat
	scalar n10mi_p_3yr_v=r(p)
		
***	
*Creating matrix    
matrix A = (scalar(own),    scalar(own_cont),    scalar(own_treat),   scalar(own_p) \ ///
	        scalar(own_v),  scalar(own_cont_v),  scalar(own_treat_v), scalar(own_p_v) \ ///
			scalar(p5mi),    scalar(p5mi_cont),    scalar(p5mi_treat),   scalar(p5mi_p) \ ///
	        scalar(p5mi_v),  scalar(p5mi_cont_v),  scalar(p5mi_treat_v), scalar(p5mi_p_v) \ ///
			scalar(n1mi),    scalar(n1mi_cont),    scalar(n1mi_treat),   scalar(n1mi_p) \ ///
	        scalar(n1mi_v),  scalar(n1mi_cont_v),  scalar(n1mi_treat_v), scalar(n1mi_p_v) \ ///
			scalar(n2mi),    scalar(n2mi_cont),    scalar(n2mi_treat),   scalar(n2mi_p) \ ///
	        scalar(n2mi_v),  scalar(n2mi_cont_v),  scalar(n2mi_treat_v), scalar(n2mi_p_v) \ ///
			scalar(n5mi),    scalar(n5mi_cont),    scalar(n5mi_treat),   scalar(n5mi_p) \ ///
	        scalar(n5mi_v),  scalar(n5mi_cont_v),  scalar(n5mi_treat_v), scalar(n5mi_p_v) \ ///
			scalar(n10mi),    scalar(n10mi_cont),    scalar(n10mi_treat),   scalar(n10mi_p) \ ///
	        scalar(n10mi_v),  scalar(n10mi_cont_v),  scalar(n10mi_treat_v), scalar(n10mi_p_v) \ ///			
		    scalar(own_3yr),  scalar(own_cont_3yr),  scalar(own_treat_3yr), scalar(own_p_3yr) \ ///
		    scalar(own_3yr_v),  scalar(own_cont_3yr_v),  scalar(own_treat_3yr_v), scalar(own_p_3yr_v) \ ///
	        scalar(p5mi_3yr),   scalar(p5mi_cont_3yr),  scalar(p5mi_treat_3yr), scalar(p5mi_p_3yr) \ ///
	        scalar(p5mi_3yr_v),   scalar(p5mi_cont_3yr_v),  scalar(p5mi_treat_3yr_v), scalar(p5mi_p_3yr_v) \ ///
	        scalar(n1mi_3yr),   scalar(n1mi_cont_3yr), scalar(n1mi_treat_3yr),  scalar(n1mi_p_3yr) \ ///
	        scalar(n1mi_3yr_v),   scalar(n1mi_cont_3yr_v), scalar(n1mi_treat_3yr_v),  scalar(n1mi_p_3yr_v) \ ///
	        scalar(n2mi_3yr),   scalar(n2mi_cont_3yr),  scalar(n2mi_treat_3yr),  scalar(n2mi_p_3yr) \ ///
	        scalar(n2mi_3yr_v),   scalar(n2mi_cont_3yr_v),  scalar(n2mi_treat_3yr_v),  scalar(n2mi_p_3yr_v) \ ///
 	        scalar(n5mi_3yr),  scalar(n5mi_cont_3yr),  scalar(n5mi_treat_3yr), scalar(n5mi_p_3yr) \ ///
 	        scalar(n5mi_3yr_v),  scalar(n5mi_cont_3yr_v),  scalar(n5mi_treat_3yr_v), scalar(n5mi_p_3yr_v) \ ///
	        scalar(n10mi_3yr),     scalar(n10mi_cont_3yr),  scalar(n10mi_treat_3yr), scalar(n10mi_p_3yr)  \ ///
			scalar(n10mi_3yr_v),     scalar(n10mi_cont_3yr_v),  scalar(n10mi_treat_3yr_v), scalar(n10mi_p_3yr_v))
	
mat rownames A = "Own Nitrate"  ///
				 "Own Nitrate (Viol)"  ///
				 "Avg Nitrate <0.5 mi"  ///
				 "Avg Nitrate <0.5 mi (Viol)"  ///
				 "Avg Nitrate <1 mi"  ///
				 "Avg Nitrate <1 mi (Viol)"  ///
				 "Avg Nitrate <2 mi"  ///
				 "Avg Nitrate <2 mi (Viol)"  ///
				 "Avg Nitrate <5 mi"  ///
				 "Avg Nitrate <5 mi (Viol)"  ///
				 "Avg Nitrate <10 mi"  ///
				 "Avg Nitrate <10 mi (Viol)"  ///
				 "Own Nitrate"  ///
				 "Own Nitrate (Viol)"  ///
				 "Avg Nitrate <0.5 mi"  ///
				 "Avg Nitrate <0.5 mi (Viol)"  ///
				 "Avg Nitrate <1 mi"  ///
				 "Avg Nitrate <1 mi (Viol)"  ///
				 "Avg Nitrate <2 mi"  ///
				 "Avg Nitrate <2 mi (Viol)"  ///
				 "Avg Nitrate <5 mi"  ///
				 "Avg Nitrate <5 mi (Viol)"  ///
				 "Avg Nitrate <10 mi"   ///
				 "Avg Nitrate <10 mi (Viol)"  

mat colnames A = "All" "Control" "Treatment" "Difference"  
			
esttab matrix(A, fmt(2)) using $output/table_s1.csv, replace  ///
    b(a2) mlabels() 
restore
	
	
***********************
*TABLE S2 - Testing for Attrition Bias
preserve
use $data_clean/survey_clean_20240520.dta, clear
keep id test_1year0 test_g2c0  test_1year0 survey_response_type treat
gen treat_respond=0
	replace treat_respond=1 if treat==1 & survey_response_type==3
gen control_respond=0
	replace control_respond=1 if treat==0 & survey_response_type==3
gen treat_norespond=0
	replace treat_norespond=1 if treat==1 & survey_response_type==2
gen control_norespond=0
	replace control_norespond=1 if treat==0 & survey_response_type==2
	
est clear 
eststo: reg test_1year0 treat_respond control_respond treat_norespond control_norespond, nocon pformat(%9.2f) sformat(%9.2f)
	test  (treat_respond=control_respond) (treat_norespond=control_norespond)
	estadd scalar ivr=r(p)
	test  (treat_respond=control_respond=treat_norespond=control_norespond)
	estadd scalar ivp=r(p)
	
eststo: reg test_g2c0 treat_respond control_respond treat_norespond control_norespond, nocon pformat(%9.2f) sformat(%9.2f)
	test  (treat_respond=control_respond) (treat_norespond=control_norespond)
	estadd scalar ivr=r(p)
	test  (treat_respond=control_respond=treat_norespond=control_norespond)
	estadd scalar ivp=r(p)
	
esttab using "$output/table-s2.csv", replace  ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none)  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	label title(Testing for Attrition Bias) ///
 	scalars("ivr IV-R Test" "ivp IV-P Test") sfmt(%12.4f)  ///
	 coef(treat_respond "Treatment Group - Response" ///
	  control_respond "Control Group - Response" ///
	  treat_norespond  "Treatment Group - No Response" ///
	  control_norespond "Control Group - No Response") ///
	note("IV-P is the p-value for our test for internal validity for the respondent subpopulation. IV-R is the p-value for our test for  internal validity for the study population.")
restore
	
						 
***********************
*TABLE S3 - Alternativie Modeling Choices
preserve 
keep if sample_main==1
est clear 

eststo: probit test_1year treat 
	estadd local cty_fes "No"
	margins, dydx(treat) 
	matrix mat=r(b)
	estadd scalar m = mat[1,1]

eststo: logit test_1year treat 
	estadd local cty_fes "No"
	margins, dydx(treat) 
	matrix mat=r(b)
	estadd scalar m = mat[1,1]	

	eststo: probit test_g2c treat 
	estadd local cty_fes "No"
	margins, dydx(treat) 
	matrix mat=r(b)
	estadd scalar m = mat[1,1]

eststo: logit test_g2c treat 
	estadd local cty_fes "No"
	margins, dydx(treat) 
	matrix mat=r(b)
	estadd scalar m = mat[1,1]
	
esttab using "$output/table-s3.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none)  ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Testing Intent to Treat Effects - 1 Year) ///
	coef(treat "Mailed Test Strip") ///
	scalars("m Marginal Effect") ///	
	sfmt(%12.4f) mlabels(none)   
restore
	
		
***********************
*TABLE S4a - Testing Intent to Treat Effects - 1 Year, Heterogeneity
gen inc_high=income_100200+income_200
gen educ_high=educ_bach+educ_mast	
foreach var in well_age_ov20 well_age_notsure well_dpth_050 well_dpth_notsure ///
              retiree_ind children_ind educ_high inc_high  {
	gen treat_`var'=treat*`var'
}
label var treat_well_age_ov20 "Treat x Well Age>20 Years" 
label var treat_well_age_notsure "Treat x Unsure Well Age" 
label var treat_well_dpth_050 "Treat x Well Depth <50 Feet" 
label var treat_well_dpth_notsure "Treat x Unsure Well Depth" 
label var treat_retiree_ind "Treat x Retiree in Household" 
label var treat_children_ind "Treat x Children in Household" 
label var treat_educ_high "Treat x Bachelor's or Higher" 
label var treat_inc_high "Treat x Income >$200K" 

est clear 
eststo: reg test_1year treat treat_well_age_ov20 
estadd local cty_fes "No"

eststo: reg test_1year treat treat_well_age_notsure
estadd local cty_fes "No"

eststo: reg test_1year treat treat_well_dpth_050
estadd local cty_fes "No"

eststo: reg test_1year treat treat_well_dpth_notsure
estadd local cty_fes "No"

eststo: reg test_1year treat treat_retiree_ind
estadd local cty_fes "No"

eststo: reg test_1year treat treat_children_ind
estadd local cty_fes "No"

eststo: reg test_1year treat treat_educ_high
estadd local cty_fes "No"

eststo: reg test_1year treat treat_inc_high
estadd local cty_fes "No"

eststo: reg test_1year treat treat_well_age_ov20 treat_well_age_notsure ///
                             treat_well_dpth_050 treat_well_dpth_notsure ///
							 treat_retiree_ind treat_children_ind ///
							 treat_educ_high treat_inc_high
estadd local cty_fes "No"

eststo: reghdfe test_1year treat treat_well_age_ov20 treat_well_age_notsure ///
                             treat_well_dpth_050 treat_well_dpth_notsure ///
							 treat_retiree_ind treat_children_ind ///
							 treat_educ_high treat_inc_high, absorb(county_fips)
estadd local cty_fes "Yes"
	
esttab using "$output/table-s4a.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///	
	collabels(none)  ///
	title(Testing Intent to Treat Effects - 1 Year) ///
	coef(treat "Mailed Test Strip") ///
	scalars("cty_fes County FE") ///	
	sfmt(%12.4f) mlabels(none)  
	

***********************
*TABLE S4b - Testing Intent to Treat Effects - GTC, Heterogeneity
est clear 
eststo: reg test_g2c treat treat_well_age_ov20 
estadd local cty_fes "No"

eststo: reg test_g2c treat treat_well_age_notsure
estadd local cty_fes "No"

eststo: reg test_g2c treat treat_well_dpth_050
estadd local cty_fes "No"

eststo: reg test_g2c treat treat_well_dpth_notsure
estadd local cty_fes "No"

eststo: reg test_g2c treat treat_retiree_ind
estadd local cty_fes "No"

eststo: reg test_g2c treat treat_children_ind
estadd local cty_fes "No"

eststo: reg test_g2c treat treat_educ_high
estadd local cty_fes "No"

eststo: reg test_g2c treat treat_inc_high
estadd local cty_fes "No"

eststo: reg test_g2c treat treat_well_age_ov20 treat_well_age_notsure ///
                             treat_well_dpth_050 treat_well_dpth_notsure ///
							 treat_retiree_ind treat_children_ind ///
							 treat_educ_high treat_inc_high
estadd local cty_fes "No"

eststo: reghdfe test_g2c treat treat_well_age_ov20 treat_well_age_notsure ///
                             treat_well_dpth_050 treat_well_dpth_notsure ///
							 treat_retiree_ind treat_children_ind ///
							 treat_educ_high treat_inc_high, absorb(county_fips)
estadd local cty_fes "Yes"
	
esttab using "$output/table-s4b.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none)  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Testing Intent to Treat Effects - GTC) ///
	coef(treat "Mailed Test Strip") ///
	scalars("cty_fes County FE") ///	
	sfmt(%12.4f) mlabels(none)   
	

***********************
*TABLE S5 - Nearby Testing 3-Year Average Nitrate Concentrations

*3-Year Average Nitrate Concentration - Own Well
gen gtc_test_own=0
	replace gtc_test_own=1 if !missing(nit_own_3yr)
gen gtc_test_own_treat=0
	replace gtc_test_own_treat=1 if treat==1 & !missing(nit_own_3yr)
gen treat_hi_own=0
	replace treat_hi_own=1 if treat==1 & nit_own_3yr>=10 & !missing(nit_own_3yr)
	
*3-Year Average Nitrate Concentration - <0.5 Miles
gen gtc_test_p5mi=0
	replace gtc_test_p5mi=1 if !missing(nit_p5mi_3yr)
gen gtc_test_p5mi_treat=0
	replace gtc_test_p5mi_treat=1 if treat==1 & !missing(nit_p5mi_3yr)
gen treat_hi_p5mi=0
	replace treat_hi_p5mi=1 if treat==1 & nit_p5mi_3yr>=10 & !missing(nit_p5mi_3yr)
	
*3-Year Average Nitrate Concentration - <1 Mile
gen gtc_test_1mi=0
	replace gtc_test_1mi=1 if !missing(nit_1mi_3yr)
gen gtc_test_1mi_treat=0
	replace gtc_test_1mi_treat=1 if treat==1 & !missing(nit_1mi_3yr)
gen treat_hi_1mi=0
	replace treat_hi_1mi=1 if treat==1 & nit_1mi_3yr>=10 & !missing(nit_1mi_3yr)
	
*3-Year Average Nitrate Concentration - <2 Miles
gen gtc_test_2mi=0
	replace gtc_test_2mi=1 if !missing(nit_2mi_3yr)
gen gtc_test_2mi_treat=0
	replace gtc_test_2mi_treat=1 if treat==1 & !missing(nit_2mi_3yr)
gen treat_hi_2mi=0
	replace treat_hi_2mi=1 if treat==1 & nit_2mi_3yr>=10 & !missing(nit_2mi_3yr)
		
*3-Year Average Nitrate Concentration - <5 Miles	
gen gtc_test_5mi=0
	replace gtc_test_5mi=1 if !missing(nit_5mi_3yr)
gen gtc_test_5mi_treat=0
	replace gtc_test_5mi_treat=1 if treat==1 & !missing(nit_5mi_3yr)
gen treat_hi_5mi=0
	replace treat_hi_5mi=1 if treat==1 & nit_5mi_3yr>=10 & !missing(nit_5mi_3yr)	
	
*1-Year Testing
est clear 
eststo: reg test_1year gtc_test_own treat gtc_test_own_treat treat_hi_own  
eststo: reg test_1year gtc_test_p5mi treat gtc_test_p5mi_treat treat_hi_p5mi
eststo: reg test_1year gtc_test_1mi treat gtc_test_1mi_treat treat_hi_1mi
eststo: reg test_1year gtc_test_2mi treat gtc_test_2mi_treat treat_hi_2mi
eststo: reg test_1year treat treat_hi_5mi
esttab using "$output/table-s5a.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none)  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Testing Intent to Treat Effects - 1 Year) ///
	coef(gtc_test_own "GTC Test (Own)" ///
	     gtc_test_p5mi "GTC Test (0.5 miles)" ///
	     gtc_test_1mi "GTC Test (<1 mile)" ///
	     gtc_test_2mi "GTC Test (<2 miles)" ///
	     gtc_test_5mi "GTC Test (<5 miles)" ///
	     treat "Mailed Test Strip (Treated)" ///
		 gtc_test_own_treat "GTC Test (Own) + Treated" ///
	     gtc_test_p5mi_treat "GTC Test (0.5 miles) + Treated" ///
	     gtc_test_1mi_treat "GTC Test (<1 mile) + Treated" ///
	     gtc_test_2mi_treat "GTC Test (<2 miles) + Treated" ///
	     gtc_test_5mi_treat "GTC Test (<5 miles) + Treated" ///
		 treat_hi_own "GTC Test (Own) + Treated + Hi Test" ///
	     treat_hi_p5mi "GTC Test (0.5 miles) + Treated + Hi Test" ///
	     treat_hi_1mi "GTC Test (<1 mile) + Treated + Hi Test" ///
	     treat_hi_2mi "GTC Test (<2 miles) + Treated + Hi Test" ///
	     treat_hi_5mi "GTC Test (<5 miles) + Treated + Hi Test") ///
	sfmt(%12.4f) mlabels(none) ///
	order(gtc_test_own gtc_test_p5mi gtc_test_1mi gtc_test_2mi ///
	      treat gtc_test_own_treat gtc_test_p5mi_treat gtc_test_1mi_treat ///
		  gtc_test_2mi_treat ///
		  treat_hi_own treat_hi_p5mi treat_hi_1mi treat_hi_2mi treat_hi_5mi)
	
*GTC Testing
est clear 
eststo: reg test_g2c gtc_test_own treat gtc_test_own_treat treat_hi_own  
eststo: reg test_g2c gtc_test_p5mi treat gtc_test_p5mi_treat treat_hi_p5mi
eststo: reg test_g2c gtc_test_1mi treat gtc_test_1mi_treat treat_hi_1mi
eststo: reg test_g2c gtc_test_2mi treat gtc_test_2mi_treat treat_hi_2mi
eststo: reg test_g2c treat treat_hi_5mi
esttab using "$output/table-s5b.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none)  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Testing Intent to Treat Effects - GTC Testing) ///
	coef(gtc_test_own "GTC Test (Own)" ///
	     gtc_test_p5mi "GTC Test (0.5 miles)" ///
	     gtc_test_1mi "GTC Test (<1 mile)" ///
	     gtc_test_2mi "GTC Test (<2 miles)" ///
	     gtc_test_5mi "GTC Test (<5 miles)" ///
	     treat "Mailed Test Strip (Treated)" ///
		 gtc_test_own_treat "GTC Test (Own) + Treated" ///
	     gtc_test_p5mi_treat "GTC Test (0.5 miles) + Treated" ///
	     gtc_test_1mi_treat "GTC Test (<1 mile) + Treated" ///
	     gtc_test_2mi_treat "GTC Test (<2 miles) + Treated" ///
	     gtc_test_5mi_treat "GTC Test (<5 miles) + Treated" ///
		 treat_hi_own "GTC Test (Own) + Treated + Hi Test" ///
	     treat_hi_p5mi "GTC Test (0.5 miles) + Treated + Hi Test" ///
	     treat_hi_1mi "GTC Test (<1 mile) + Treated + Hi Test" ///
	     treat_hi_2mi "GTC Test (<2 miles) + Treated + Hi Test" ///
	     treat_hi_5mi "GTC Test (<5 miles) + Treated + Hi Test") ///
	sfmt(%12.4f) mlabels(none) ///
	order(gtc_test_own gtc_test_p5mi gtc_test_1mi gtc_test_2mi ///
	      treat gtc_test_own_treat gtc_test_p5mi_treat gtc_test_1mi_treat ///
		  gtc_test_2mi_treat ///
		  treat_hi_own treat_hi_p5mi treat_hi_1mi treat_hi_2mi treat_hi_5mi)
drop gtc_test_own-treat_hi_5mi


***********************
*TABLE S6 - Nearby Testing - Long-Run Average Nitrate Concentrations

*LR Average Nitrate Concentration - Own Well
gen gtc_test_own=0
	replace gtc_test_own=1 if !missing(nit_own)
gen gtc_test_own_treat=0
	replace gtc_test_own_treat=1 if treat==1 & !missing(nit_own)
gen treat_hi_own=0
	replace treat_hi_own=1 if treat==1 & nit_own>=10 & !missing(nit_own)
	
*LR Average Nitrate Concentration - <0.5 Miles
gen gtc_test_p5mi=0
	replace gtc_test_p5mi=1 if !missing(nit_p5mi)
gen gtc_test_p5mi_treat=0
	replace gtc_test_p5mi_treat=1 if treat==1 & !missing(nit_p5mi)
gen treat_hi_p5mi=0
	replace treat_hi_p5mi=1 if treat==1 & nit_p5mi>=10 & !missing(nit_p5mi)
	
*LR Average Nitrate Concentration - <1 Mile
gen gtc_test_1mi=0
	replace gtc_test_1mi=1 if !missing(nit_1mi)
gen gtc_test_1mi_treat=0
	replace gtc_test_1mi_treat=1 if treat==1 & !missing(nit_1mi)
gen treat_hi_1mi=0
	replace treat_hi_1mi=1 if treat==1 & nit_1mi>=10 & !missing(nit_1mi)
	
*LR Average Nitrate Concentration - <2 Miles
gen gtc_test_2mi=0
	replace gtc_test_2mi=1 if !missing(nit_2mi)
gen gtc_test_2mi_treat=0
	replace gtc_test_2mi_treat=1 if treat==1 & !missing(nit_2mi)
gen treat_hi_2mi=0
	replace treat_hi_2mi=1 if treat==1 & nit_2mi>=10 & !missing(nit_2mi)
		
*LR Average Nitrate Concentration - <5 Miles	
gen gtc_test_5mi=0
	replace gtc_test_5mi=1 if !missing(nit_5mi)
gen gtc_test_5mi_treat=0
	replace gtc_test_5mi_treat=1 if treat==1 & !missing(nit_5mi)
gen treat_hi_5mi=0
	replace treat_hi_5mi=1 if treat==1 & nit_5mi>=10 & !missing(nit_5mi)	
	
*1-Year Testing
est clear 
eststo: reg test_1year gtc_test_own treat gtc_test_own_treat treat_hi_own   
eststo: reg test_1year gtc_test_p5mi treat gtc_test_p5mi_treat treat_hi_p5mi
eststo: reg test_1year gtc_test_1mi treat gtc_test_1mi_treat treat_hi_1mi
eststo: reg test_1year gtc_test_2mi treat gtc_test_2mi_treat treat_hi_2mi
eststo: reg test_1year treat treat_hi_5mi
esttab using "$output/table-s6a.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none)  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Testing Intent to Treat Effects - 1 Year) ///
	coef(gtc_test_own "GTC Test (Own)" ///
	     gtc_test_p5mi "GTC Test (0.5 miles)" ///
	     gtc_test_1mi "GTC Test (<1 mile)" ///
	     gtc_test_2mi "GTC Test (<2 miles)" ///
	     gtc_test_5mi "GTC Test (<5 miles)" ///
	     treat "Mailed Test Strip (Treated)" ///
		 gtc_test_own_treat "GTC Test (Own) + Treated" ///
	     gtc_test_p5mi_treat "GTC Test (0.5 miles) + Treated" ///
	     gtc_test_1mi_treat "GTC Test (<1 mile) + Treated" ///
	     gtc_test_2mi_treat "GTC Test (<2 miles) + Treated" ///
	     gtc_test_5mi_treat "GTC Test (<5 miles) + Treated" ///
		 treat_hi_own "GTC Test (Own) + Treated + Hi Test" ///
	     treat_hi_p5mi "GTC Test (0.5 miles) + Treated + Hi Test" ///
	     treat_hi_1mi "GTC Test (<1 mile) + Treated + Hi Test" ///
	     treat_hi_2mi "GTC Test (<2 miles) + Treated + Hi Test" ///
	     treat_hi_5mi "GTC Test (<5 miles) + Treated + Hi Test") ///
	sfmt(%12.4f) mlabels(none) ///
	order(gtc_test_own gtc_test_p5mi gtc_test_1mi gtc_test_2mi ///
	      treat gtc_test_own_treat gtc_test_p5mi_treat gtc_test_1mi_treat ///
		  gtc_test_2mi_treat ///
		  treat_hi_own treat_hi_p5mi treat_hi_1mi treat_hi_2mi treat_hi_5mi)
	
*GTC Testing
est clear 
eststo: reg test_g2c gtc_test_own treat gtc_test_own_treat treat_hi_own  
eststo: reg test_g2c gtc_test_p5mi treat gtc_test_p5mi_treat treat_hi_p5mi
eststo: reg test_g2c gtc_test_1mi treat gtc_test_1mi_treat treat_hi_1mi
eststo: reg test_g2c gtc_test_2mi treat gtc_test_2mi_treat treat_hi_2mi
eststo: reg test_g2c treat treat_hi_5mi
esttab using "$output/table-s6b.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none)  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Testing Intent to Treat Effects - GTC Testing) ///
	coef(gtc_test_own "GTC Test (Own)" ///
	     gtc_test_p5mi "GTC Test (0.5 miles)" ///
	     gtc_test_1mi "GTC Test (<1 mile)" ///
	     gtc_test_2mi "GTC Test (<2 miles)" ///
	     gtc_test_5mi "GTC Test (<5 miles)" ///
	     treat "Mailed Test Strip (Treated)" ///
		 gtc_test_own_treat "GTC Test (Own) + Treated" ///
	     gtc_test_p5mi_treat "GTC Test (0.5 miles) + Treated" ///
	     gtc_test_1mi_treat "GTC Test (<1 mile) + Treated" ///
	     gtc_test_2mi_treat "GTC Test (<2 miles) + Treated" ///
	     gtc_test_5mi_treat "GTC Test (<5 miles) + Treated" ///
		 treat_hi_own "GTC Test (Own) + Treated + Hi Test" ///
	     treat_hi_p5mi "GTC Test (0.5 miles) + Treated + Hi Test" ///
	     treat_hi_1mi "GTC Test (<1 mile) + Treated + Hi Test" ///
	     treat_hi_2mi "GTC Test (<2 miles) + Treated + Hi Test" ///
	     treat_hi_5mi "GTC Test (<5 miles) + Treated + Hi Test") ///
	sfmt(%12.4f) mlabels(none) ///
	order(gtc_test_own gtc_test_p5mi gtc_test_1mi gtc_test_2mi ///
	      treat gtc_test_own_treat gtc_test_p5mi_treat gtc_test_1mi_treat ///
		  gtc_test_2mi_treat ///
		  treat_hi_own treat_hi_p5mi treat_hi_1mi treat_hi_2mi treat_hi_5mi)
drop gtc_test_own-treat_hi_5mi


***********************
*TABLE S7 - Impact on Other Testing
est clear 

eststo: reg test_nit treat 
    mhtreg (test_1year treat)(test_g2c treat) ///
	       (test_nit treat)(test_bact treat)(test_pest treat) ///
	       (test_metals treat)(test_hardness treat)(test_other treat)		
	matrix mat = r(results)
	estadd scalar pval_adj = mat[3,4]
	
eststo: reg test_bact treat 
	estadd scalar pval_adj = mat[4,4]

eststo: reg test_pest treat 
	estadd scalar pval_adj = mat[5,4]

eststo: reg test_metals treat 
	estadd scalar pval_adj = mat[6,4]

eststo: reg test_hardness treat 
	estadd scalar pval_adj = mat[7,4]

eststo: reg test_other treat 
	estadd scalar pval_adj = mat[8,4]

esttab using "$output/table-s7.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///	
	collabels(none)  ///
	title(Testing Intent to Treat Effects by Pollutant) ///
	coef(treat "Mailed Test Strip") ///
	scalars("pval_adj MHT Corrected p-value") ///	
	sfmt(%12.4f) mlabels(none) 	  
frame change main
frame drop si

***********************
*TABLE S8 - Extended WTP Results
frame copy main si
frame change si
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
								
esttab using "$output/table-s8.csv", replace label ///
	cells(b(fmt(3) star) se(fmt(3) par))  ///
	collabels(none) ///
    starlevels(* 0.10 ** 0.05 *** 0.01) ///
	title(Willingness to Pay) ///
	coef(strip "Chose Strip" ///
	     value  "Bid" ///
	     strip:treat "Mailed Test Strip" ///
		 strip:educ_bach "Bachelor's Degree" ///
		 strip:educ_mast "Master's Degree" ///
		 strip:income_25 "Income <$25K" ///
		 strip:income_2550 "Income $25K-$50K" ///
		 strip:income_50100 "Income $50K-$100K" ///
		 strip:income_100200 "Income $100K-$200K" ///
		 strip:hh_size "HH Size" ///
		 strip:chilinf_ind "Child/Infant in HH" ///
		 strip:retiree_ind "Retiree in HH" ///
		 strip:well_age_610 "Well Age 6-10 Years" ///
		 strip:well_age_1120 "Well Age 11-20 Years" ///
		 strip:well_age_ov20 "Well Age >20 Years" ///
		 strip:well_age_notsure "Well Age Unsure" ///
		 strip:well_dpth_51150 "Well Depth 51-150 Feet" ///
		 strip:well_dpth_ov150 "Well Depth >150 Feet" ///
		 strip:well_dpth_notsure "Well Depth Unsure" ///
		 strip:nit_concern_any0 "Nitrate Concerns: Any" ///
		 strip:nit_concern_none0 "Nitrate Concerns: None" ///
		 strip:nit_concern_unsure0 "Nitrate Concerns: Unsure" ///
		 strip:rate_goodgr0 "Rate Water: Good/Great" ///
		 strip:rate_neut0 "Rate Water: Neutral" ///
		 strip:rate_poor0 "Rate Water: Poor") ///
	sfmt(%12.2f) mlabels(none) 
frame change main
frame drop si