**************************************************************
*Improving Private Well Testing Programs: Experimental Evidence from Iowa
* THIS FILE:
*	1) PRODUCES FIGURE 2
* Last Updated: 11/20/2023
**************************************************************
frame copy main regs
frame change regs
keep if sample_main==1

****************
*Creating Variables
gen rate_goodgr=rate_great+rate_good
gen filt=filter_pitch+filter_tap
replace filt=1 if filt>1 & !missing(filt)

gen i=.
replace i=1 in 1
replace i=2 in 2
replace i=3 in 3
replace i=4 in 4
replace i=5 in 5
replace i=6 in 6
replace i=7 in 7
replace i=8 in 8
replace i=9 in 9

gen beta_1yr=.
gen ub_1yr=.
gen lb_1yr=.
gen ub_1yr_a=.
gen lb_1yr_a=.
gen beta_g2c=.
gen ub_g2c=.
gen lb_g2c=.
gen ub_g2c_a=.
gen lb_g2c_a=.
gen beta_g2c_r1=.
gen ub_g2c_r1=.
gen lb_g2c_r1=.
gen ub_g2c_r1_a=.
gen lb_g2c_r1_a=.

****************
*Tested in Last Year

*Well Drinking
ivregress 2sls well_drinking (test_1year=treat) 
weakivtest
replace beta_1yr= _b[test_1year] in 1
replace ub_1yr= _b[test_1year] + 1.96*_se[test_1year] in 1
replace lb_1yr=_b[test_1year] - 1.96*_se[test_1year] in 1
replace ub_1yr_a= _b[test_1year] + 1.645*_se[test_1year] in 1
replace lb_1yr_a=_b[test_1year] - 1.645*_se[test_1year] in 1

*Bottled Water Use
ivregress 2sls bw_use (test_1year=treat)
replace beta_1yr= _b[test_1year] in 2
replace ub_1yr= _b[test_1year] + 1.96*_se[test_1year] in 2
replace lb_1yr=_b[test_1year] - 1.96*_se[test_1year] in 2
replace ub_1yr_a= _b[test_1year] + 1.645*_se[test_1year] in 2
replace lb_1yr_a=_b[test_1year] - 1.645*_se[test_1year] in 2

*Water Cooler Use
ivregress 2sls cooler_use (test_1year=treat)  
replace beta_1yr= _b[test_1year] in 3
replace ub_1yr= _b[test_1year] + 1.96*_se[test_1year] in 3
replace lb_1yr=_b[test_1year] - 1.96*_se[test_1year] in 3
replace ub_1yr_a= _b[test_1year] + 1.645*_se[test_1year] in 3
replace lb_1yr_a=_b[test_1year] - 1.645*_se[test_1year] in 3

*Any Filter Use
ivregress 2sls filt (test_1year=treat)  
replace beta_1yr= _b[test_1year] in 4
replace ub_1yr= _b[test_1year] + 1.96*_se[test_1year] in 4
replace lb_1yr=_b[test_1year] - 1.96*_se[test_1year] in 4
replace ub_1yr_a= _b[test_1year] + 1.645*_se[test_1year] in 4
replace lb_1yr_a=_b[test_1year] - 1.645*_se[test_1year] in 4

*RO Filter Use
ivregress 2sls wholehome_type_ro (test_1year=treat)  
replace beta_1yr= _b[test_1year] in 5
replace ub_1yr= _b[test_1year] + 1.96*_se[test_1year] in 5
replace lb_1yr=_b[test_1year] - 1.96*_se[test_1year] in 5
replace ub_1yr_a= _b[test_1year] + 1.645*_se[test_1year] in 5
replace lb_1yr_a=_b[test_1year] - 1.645*_se[test_1year] in 5

*Rates Water Quality Great/Good
ivregress 2sls rate_goodgr (test_1year=treat)  
replace beta_1yr= _b[test_1year] in 6
replace ub_1yr= _b[test_1year] + 1.96*_se[test_1year] in 6
replace lb_1yr=_b[test_1year] - 1.96*_se[test_1year] in 6
replace ub_1yr_a= _b[test_1year] + 1.645*_se[test_1year] in 6
replace lb_1yr_a=_b[test_1year] - 1.645*_se[test_1year] in 6

*Rates Water Quality Poor 
ivregress 2sls rate_poor (test_1year=treat)  
replace beta_1yr= _b[test_1year] in 7
replace ub_1yr= _b[test_1year] + 1.96*_se[test_1year] in 7
replace lb_1yr=_b[test_1year] - 1.96*_se[test_1year] in 7
replace ub_1yr_a= _b[test_1year] + 1.645*_se[test_1year] in 7
replace lb_1yr_a=_b[test_1year] - 1.645*_se[test_1year] in 7

*Perceives Local Nitrate Problem
ivregress 2sls nit_concern_local (test_1year=treat)  
replace beta_1yr= _b[test_1year] in 8
replace ub_1yr= _b[test_1year] + 1.96*_se[test_1year] in 8
replace lb_1yr=_b[test_1year] - 1.96*_se[test_1year] in 8
replace ub_1yr_a= _b[test_1year] + 1.645*_se[test_1year] in 8
replace lb_1yr_a=_b[test_1year] - 1.645*_se[test_1year] in 8

*Perceives State Nitrate Problem
ivregress 2sls nit_concern_state (test_1year=treat)  
replace beta_1yr= _b[test_1year] in 9
replace ub_1yr= _b[test_1year] + 1.96*_se[test_1year] in 9
replace lb_1yr=_b[test_1year] - 1.96*_se[test_1year] in 9
replace ub_1yr_a= _b[test_1year] + 1.645*_se[test_1year] in 9
replace lb_1yr_a=_b[test_1year] - 1.645*_se[test_1year] in 9

twoway (rcap ub_1yr_a lb_1yr_a i,  horizontal lcolor(erose) ) ///
       (rspike ub_1yr lb_1yr i,  horizontal lcolor(erose) ) ///
       (scatter  i beta_1yr, color(cranberry)), ///
graphr(color(white)) ysc(reverse) ///
	xtit("Local Average Treatment Effect (%)") ///
	ytit("") ///
	xlabel(-0.2 (0.1) 0.2,nogrid) ///
	text(1 -0.2 "{bf:A}", place(e) size(huge)) ///
	xline(0, lc(black)) ///
	ylabel(1 "Well Drinking" 2 "BW Use" 3 "Cooler Use" 4 "Tap/Pitcher Filter" 5 "RO Filter" 6 "Great/Good Quality" 7 "Poor Quality" 8 "Local Nitrate Problem" 9 "State Nitrate Problem", angle(horizontal)  labsize(small) nogrid) ///
	legend(off) 
graph export $output\fig-2a.png, width(4000) replace		


****************
*Tested using Grants to Counties

*Well Drinking
ivregress 2sls well_drinking (test_g2c=treat) 
weakivtest
replace beta_g2c= _b[test_g2c] in 1
replace ub_g2c= _b[test_g2c] + 1.96*_se[test_g2c] in 1
replace lb_g2c=_b[test_g2c] - 1.96*_se[test_g2c] in 1
replace ub_g2c_a= _b[test_g2c] + 1.645*_se[test_g2c] in 1
replace lb_g2c_a=_b[test_g2c] - 1.645*_se[test_g2c] in 1

*Bottled Water Use
ivregress 2sls bw_use (test_g2c=treat)
replace beta_g2c= _b[test_g2c] in 2
replace ub_g2c= _b[test_g2c] + 1.96*_se[test_g2c] in 2
replace lb_g2c=_b[test_g2c] - 1.96*_se[test_g2c] in 2
replace ub_g2c_a= _b[test_g2c] + 1.645*_se[test_g2c] in 2
replace lb_g2c_a=_b[test_g2c] - 1.645*_se[test_g2c] in 2

*Water Cooler Use
ivregress 2sls cooler_use (test_g2c=treat)  
replace beta_g2c= _b[test_g2c] in 3
replace ub_g2c= _b[test_g2c] + 1.96*_se[test_g2c] in 3
replace lb_g2c=_b[test_g2c] - 1.96*_se[test_g2c] in 3
replace ub_g2c_a= _b[test_g2c] + 1.645*_se[test_g2c] in 3
replace lb_g2c_a=_b[test_g2c] - 1.645*_se[test_g2c] in 3

*Any Filter Use
ivregress 2sls filt (test_g2c=treat)  
replace beta_g2c= _b[test_g2c] in 4
replace ub_g2c= _b[test_g2c] + 1.96*_se[test_g2c] in 4
replace lb_g2c=_b[test_g2c] - 1.96*_se[test_g2c] in 4
replace ub_g2c_a= _b[test_g2c] + 1.645*_se[test_g2c] in 4
replace lb_g2c_a=_b[test_g2c] - 1.645*_se[test_g2c] in 4

*RO Filter Use
ivregress 2sls wholehome_type_ro (test_g2c=treat)  
replace beta_g2c= _b[test_g2c] in 5
replace ub_g2c= _b[test_g2c] + 1.96*_se[test_g2c] in 5
replace lb_g2c=_b[test_g2c] - 1.96*_se[test_g2c] in 5
replace ub_g2c_a= _b[test_g2c] + 1.645*_se[test_g2c] in 5
replace lb_g2c_a=_b[test_g2c] - 1.645*_se[test_g2c] in 5

*Rates Water Quality Great/Good
ivregress 2sls rate_goodgr (test_g2c=treat)  
replace beta_g2c= _b[test_g2c] in 6
replace ub_g2c= _b[test_g2c] + 1.96*_se[test_g2c] in 6
replace lb_g2c=_b[test_g2c] - 1.96*_se[test_g2c] in 6
replace ub_g2c_a= _b[test_g2c] + 1.645*_se[test_g2c] in 6
replace lb_g2c_a=_b[test_g2c] - 1.645*_se[test_g2c] in 6

*Rates Water Quality Poor 
ivregress 2sls rate_poor (test_g2c=treat)  
replace beta_g2c= _b[test_g2c] in 7
replace ub_g2c= _b[test_g2c] + 1.96*_se[test_g2c] in 7
replace lb_g2c=_b[test_g2c] - 1.96*_se[test_g2c] in 7
replace ub_g2c_a= _b[test_g2c] + 1.645*_se[test_g2c] in 7
replace lb_g2c_a=_b[test_g2c] - 1.645*_se[test_g2c] in 7

*Perceives Local Nitrate Problem
ivregress 2sls nit_concern_local (test_g2c=treat)  
replace beta_g2c= _b[test_g2c] in 8
replace ub_g2c= _b[test_g2c] + 1.96*_se[test_g2c] in 8
replace lb_g2c=_b[test_g2c] - 1.96*_se[test_g2c] in 8
replace ub_g2c_a= _b[test_g2c] + 1.645*_se[test_g2c] in 8
replace lb_g2c_a=_b[test_g2c] - 1.645*_se[test_g2c] in 8

*Perceives State Nitrate Problem
ivregress 2sls nit_concern_state (test_g2c=treat)  
replace beta_g2c= _b[test_g2c] in 9
replace ub_g2c= _b[test_g2c] + 1.96*_se[test_g2c] in 9
replace lb_g2c=_b[test_g2c] - 1.96*_se[test_g2c] in 9
replace ub_g2c_a= _b[test_g2c] + 1.645*_se[test_g2c] in 9
replace lb_g2c_a=_b[test_g2c] - 1.645*_se[test_g2c] in 9

****************
*Tested using Grants to Counties (Round 1)

*Well Drinking
ivregress 2sls well_drinking (test_g2c=treat) if round==1
weakivtest
replace beta_g2c_r1= _b[test_g2c] in 1
replace ub_g2c_r1= _b[test_g2c] + 1.96*_se[test_g2c] in 1
replace lb_g2c_r1=_b[test_g2c] - 1.96*_se[test_g2c] in 1
replace ub_g2c_r1_a= _b[test_g2c] + 1.645*_se[test_g2c] in 1
replace lb_g2c_r1_a=_b[test_g2c] - 1.645*_se[test_g2c] in 1

*Bottled Water Use
ivregress 2sls bw_use (test_g2c=treat) if round==1
replace beta_g2c_r1= _b[test_g2c] in 2
replace ub_g2c_r1= _b[test_g2c] + 1.96*_se[test_g2c] in 2
replace lb_g2c_r1=_b[test_g2c] - 1.96*_se[test_g2c] in 2
replace ub_g2c_r1_a= _b[test_g2c] + 1.645*_se[test_g2c] in 2
replace lb_g2c_r1_a=_b[test_g2c] - 1.645*_se[test_g2c] in 2

*Water Cooler Use
ivregress 2sls cooler_use (test_g2c=treat) if round==1
replace beta_g2c_r1= _b[test_g2c] in 3
replace ub_g2c_r1= _b[test_g2c] + 1.96*_se[test_g2c] in 3
replace lb_g2c_r1=_b[test_g2c] - 1.96*_se[test_g2c] in 3
replace ub_g2c_r1_a= _b[test_g2c] + 1.645*_se[test_g2c] in 3
replace lb_g2c_r1_a=_b[test_g2c] - 1.645*_se[test_g2c] in 3

*Any Filter Use
ivregress 2sls filt (test_g2c=treat) if round==1
replace beta_g2c_r1= _b[test_g2c] in 4
replace ub_g2c_r1= _b[test_g2c] + 1.96*_se[test_g2c] in 4
replace lb_g2c_r1=_b[test_g2c] - 1.96*_se[test_g2c] in 4
replace ub_g2c_r1_a= _b[test_g2c] + 1.645*_se[test_g2c] in 4
replace lb_g2c_r1_a=_b[test_g2c] - 1.645*_se[test_g2c] in 4

*RO Filter Use
ivregress 2sls wholehome_type_ro (test_g2c=treat) if round==1
replace beta_g2c_r1= _b[test_g2c] in 5
replace ub_g2c_r1= _b[test_g2c] + 1.96*_se[test_g2c] in 5
replace lb_g2c_r1=_b[test_g2c] - 1.96*_se[test_g2c] in 5
replace ub_g2c_r1_a= _b[test_g2c] + 1.645*_se[test_g2c] in 5
replace lb_g2c_r1_a=_b[test_g2c] - 1.645*_se[test_g2c] in 5

*Rates Water Quality Great/Good
ivregress 2sls rate_goodgr (test_g2c=treat) if round==1
replace beta_g2c_r1= _b[test_g2c] in 6
replace ub_g2c_r1= _b[test_g2c] + 1.96*_se[test_g2c] in 6
replace lb_g2c_r1=_b[test_g2c] - 1.96*_se[test_g2c] in 6
replace ub_g2c_r1_a= _b[test_g2c] + 1.645*_se[test_g2c] in 6
replace lb_g2c_r1_a=_b[test_g2c] - 1.645*_se[test_g2c] in 6

*Rates Water Quality Poor 
ivregress 2sls rate_poor (test_g2c=treat) if round==1
replace beta_g2c_r1= _b[test_g2c] in 7
replace ub_g2c_r1= _b[test_g2c] + 1.96*_se[test_g2c] in 7
replace lb_g2c_r1=_b[test_g2c] - 1.96*_se[test_g2c] in 7
replace ub_g2c_r1_a= _b[test_g2c] + 1.645*_se[test_g2c] in 7
replace lb_g2c_r1_a=_b[test_g2c] - 1.645*_se[test_g2c] in 7

*Perceives Local Nitrate Problem
ivregress 2sls nit_concern_local (test_g2c=treat) if round==1
replace beta_g2c_r1= _b[test_g2c] in 8
replace ub_g2c_r1= _b[test_g2c] + 1.96*_se[test_g2c] in 8
replace lb_g2c_r1=_b[test_g2c] - 1.96*_se[test_g2c] in 8
replace ub_g2c_r1_a= _b[test_g2c] + 1.645*_se[test_g2c] in 8
replace lb_g2c_r1_a=_b[test_g2c] - 1.645*_se[test_g2c] in 8

*Perceives State Nitrate Problem
ivregress 2sls nit_concern_state (test_g2c=treat) if round==1
replace beta_g2c_r1= _b[test_g2c] in 9
replace ub_g2c_r1= _b[test_g2c] + 1.96*_se[test_g2c] in 9
replace lb_g2c_r1=_b[test_g2c] - 1.96*_se[test_g2c] in 9
replace ub_g2c_r1_a= _b[test_g2c] + 1.645*_se[test_g2c] in 9
replace lb_g2c_r1_a=_b[test_g2c] - 1.645*_se[test_g2c] in 9

replace i=i-0.1
gen i_r1=i+0.2
twoway (rcap ub_g2c_a lb_g2c_a i,  horizontal lcolor(erose) ) ///
        (rspike ub_g2c lb_g2c i,  horizontal lcolor(erose) ) ///
		(scatter  i beta_g2c, color(cranberry)) ///
		 (rcap ub_g2c_r1_a lb_g2c_r1_a i_r1,  horizontal lcolor(erose) ) ///
		 (rspike ub_g2c_r1 lb_g2c_r1 i_r1,  horizontal lcolor(erose) ) ///
        (scatter  i_r1 beta_g2c_r1, color(edkblue) m(diamond)), ///
graphr(color(white)) ysc(reverse) ///
	xtit("Local Average Treatment Effect (%)") ///
	ytit("") ///
	text(1 -2 "{bf:B}", place(e) size(huge)) ///
	xlabel(-2 (0.5) 2,nogrid) ///
	xline(0, lc(black)) ///
	ylabel(1 "Well Drinking" 2 "BW Use" 3 "Cooler Use" 4 "Tap/Pitcher Filter" 5 "RO Filter" 6 "Great/Good Quality" 7 "Poor Quality" 8 "Local Nitrate Problem" 9 "State Nitrate Problem", angle(horizontal)  labsize(small) nogrid) ///
	legend(off) 
graph export $output\fig-2b.png, width(4000) replace		

frame change main
frame drop regs