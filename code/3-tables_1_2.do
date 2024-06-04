**************************************************************
*Improving Private Well Testing Programs: Experimental Evidence from Iowa
* THIS FILE:
*	PRODUCES TABLES 1 AND 2 SUMMARY STATISTICS
* Last Updated: 5/10/2024
**************************************************************
frame copy main sum_stats
frame change sum_stats
keep if sample_demo==1

********************************
*BALANCE TESTS - TABLE
********************************

*Fixing retiree indicator
replace retiree=. if missing(infants_ind)
drop if missing(retiree)

*Own Home 
sum own_home
	scalar own = r(mean)	
sum own_home if treat==0
	scalar own_cont = r(mean)	
sum own_home if treat==1
	scalar own_treat = r(mean)
reg own_home treat
	test treat
	scalar own_p=r(p)

*Income 0-25
sum income_25  
	scalar inc025 = r(mean)	
sum income_25 if treat==0
	scalar inc025_cont = r(mean)	
sum income_25 if treat==1
	scalar inc025_treat = r(mean)
reg income_25 treat
	test treat
	scalar inc025_p=r(p)

*Income 25-50
sum income_2550  
	scalar inc2550 = r(mean)	
sum income_2550 if treat==0
	scalar inc2550_cont = r(mean)	
sum income_2550 if treat==1
	scalar inc2550_treat = r(mean)
reg income_2550 treat
	test treat
	scalar inc2550_p=r(p)

*Income 50-100
sum income_50100 
	scalar inc50100 = r(mean)	
sum income_50100 if treat==0
	scalar inc50100_cont = r(mean)	
sum income_50100 if treat==1
	scalar inc50100_treat = r(mean)
reg income_50100 treat
	test treat
	scalar inc50100_p=r(p)

*Income 100-200
sum income_100200
	scalar inc100200 = r(mean)	
sum income_100200 if treat==0
	scalar inc100200_cont = r(mean)	
sum income_100200 if treat==1
	scalar inc100200_treat = r(mean)
reg income_100200 treat
	test treat
	scalar inc100200_p=r(p)
	
*Income >200
sum income_200
	scalar inc200 = r(mean)	
sum income_200 if treat==0
	scalar inc200_cont = r(mean)	
sum income_200 if treat==1
	scalar inc200_treat = r(mean)
reg income_200 treat
	test treat
	scalar inc200_p=r(p)
	
*Education - HS
sum educ_hs 
	scalar educhs = r(mean)	
sum educ_hs if treat==0
	scalar educhs_cont = r(mean)	
sum educ_hs if treat==1
	scalar educhs_treat = r(mean)
reg educ_hs treat
	test treat
	scalar educhs_p=r(p)

*Education - Associates or Higher
sum educ_bach_high 
	scalar educbs = r(mean)
sum educ_bach_high if treat==0
	scalar educbs_cont = r(mean)	
sum educ_bach_high if treat==1
	scalar educbs_treat = r(mean)
reg educ_bach_high treat
	test treat
	scalar educbs_p=r(p)

*HH Size
sum hh_size
	scalar hhs = r(mean)	
sum hh_size if treat==0
	scalar hhs_cont = r(mean)	
sum hh_size if treat==1
	scalar hhs_treat = r(mean)
reg hh_size treat
	test treat
	scalar hhs_p=r(p)

*HH Size - Children and Infants
gen chilinf_ind = 0
	replace chilinf_ind = 1 if children_ind==1|infants_ind==1
	replace chilinf_ind=. if missing(children_ind) & missing(infants_ind)
sum chilinf_ind 
	scalar child = r(mean)		
sum chilinf_ind if treat==0
	scalar child_cont = r(mean)	
sum chilinf_ind if treat==1
	scalar child_treat = r(mean)
reg chilinf_ind treat
	test treat
	scalar child_p=r(p)

*HH Size - Retiree
sum retiree_ind 
	scalar ret = r(mean)
sum retiree_ind if treat==0
	scalar ret_cont = r(mean)	
sum retiree_ind if treat==1
	scalar ret_treat = r(mean)
reg retiree_ind treat
	test treat
	scalar ret_p=r(p)

*Well Age 0-5 
sum well_age_05 
	scalar wella05 = r(mean)
sum well_age_05 if treat==0
	scalar wella05_cont = r(mean)	
sum well_age_05 if treat==1
	scalar wella05_treat = r(mean)
reg well_age_05 treat
	test treat
	scalar wella05_p=r(p)
	
*Well Age 6-10
sum well_age_610 
	scalar wella610 = r(mean)	
sum well_age_610 if treat==0
	scalar wella610_cont = r(mean)	
sum well_age_610 if treat==1
	scalar wella610_treat = r(mean)
reg well_age_610 treat
	test treat
	scalar wella610_p=r(p)
	
*Well Age 11-20
sum well_age_1120 
	scalar wella1120 = r(mean)	
sum well_age_1120 if treat==0
	scalar wella1120_cont = r(mean)	
sum well_age_1120 if treat==1
	scalar wella1120_treat = r(mean)
reg well_age_1120 treat
	test treat
	scalar wella1120_p=r(p)

*Well Age >20
sum well_age_ov20 
	scalar wella20 = r(mean)
sum well_age_ov20 if treat==0
	scalar wella20_cont = r(mean)	
sum well_age_ov20 if treat==1
	scalar wella20_treat = r(mean)
reg well_age_ov20 treat
	test treat
	scalar wella20_p=r(p)

*Well Age Unsure
sum well_age_notsure 
	scalar wellauns = r(mean)	
sum well_age_notsure if treat==0
	scalar wellauns_cont = r(mean)	
sum well_age_notsure if treat==1
	scalar wellauns_treat = r(mean)
reg well_age_notsure treat
	test treat
	scalar wellauns_p=r(p)

*Well Depth 0-50
sum well_dpth_050
	scalar welld050 = r(mean)	
sum well_dpth_050 if treat==0
	scalar welld050_cont = r(mean)	
sum well_dpth_050 if treat==1
	scalar welld050_treat = r(mean)
reg well_dpth_050 treat
	test treat
	scalar welld050_p=r(p)

*Well Depth 51-150
sum well_dpth_51150
	scalar welld51150 = r(mean)
sum well_dpth_51150 if treat==0
	scalar welld51150_cont = r(mean)	
sum well_dpth_51150 if treat==1
	scalar welld51150_treat = r(mean)
reg well_dpth_51150 treat
	test treat
	scalar welld51150_p=r(p)

*Well Depth >150
sum well_dpth_ov150
	scalar welld150 = r(mean)	
sum well_dpth_ov150 if treat==0
	scalar welld150_cont = r(mean)	
sum well_dpth_ov150 if treat==1
	scalar welld150_treat = r(mean)
reg well_dpth_ov150 treat
	test treat
	scalar welld150_p=r(p)

*Well Depth Unsure
sum well_dpth_notsure 
	scalar wellduns = r(mean)	
sum well_dpth_notsure if treat==0
	scalar wellduns_cont = r(mean)	
sum well_dpth_notsure if treat==1
	scalar wellduns_treat = r(mean)
reg well_dpth_notsure treat
	test treat
	scalar wellduns_p=r(p)	
	

*****
*Demographics - Census
frame create census
frame change census 
use $data_clean\ipums, clear
		
sum inc_25 
	scalar cen_inc25 = r(mean)
sum inc_2550 
	scalar cen_inc2550 = r(mean)
sum inc_50100 
	scalar cen_inc50100 = r(mean)
sum inc_100200 
	scalar cen_inc100200 = r(mean)
sum inc_200 
	scalar cen_inc200 = r(mean)
sum educ_hs 
	scalar cen_eduhs = r(mean)
sum educ_bamast
	scalar cen_eduba = r(mean)	
//sum educ_mast
//	scalar cen_eduma = r(mean)	
sum hh_size
	scalar cen_size = r(mean)	
frame change sum_stats

*
reg treat own_home income_25 income_2550 income_50100 income_100200 ///
		income_200 educ_hs educ_bach_high hh_size chilinf_ind ///
		retiree_ind well_age_05 well_age_610 well_age_1120 well_age_ov20 ///
		well_age_notsure well_dpth_050 well_dpth_51150 well_dpth_ov150 ///
		well_dpth_notsure
scalar f= e(F)  

***	
*Creating matrix  wuse1_dif_ws  
matrix A = (scalar(own),     scalar(own_cont),    scalar(own_treat), scalar(own_p), 999 \ ///
	        scalar(inc025),     scalar(inc025_cont),    scalar(inc025_treat), scalar(inc025_p), scalar(cen_inc25) \ ///
	        scalar(inc2550),     scalar(inc2550_cont),    scalar(inc2550_treat), scalar(inc2550_p), scalar(cen_inc2550) \ ///
	        scalar(inc50100),     scalar(inc50100_cont),    scalar(inc50100_treat), scalar(inc50100_p), scalar(cen_inc50100) \ ///
	        scalar(inc100200),     scalar(inc100200_cont),    scalar(inc100200_treat), scalar(inc100200_p), scalar(cen_inc100200) \ ///
	        scalar(inc200),     scalar(inc200_cont),    scalar(inc200_treat), scalar(inc200_p), scalar(cen_inc200) \ ///
	        scalar(educhs),     scalar(educhs_cont),    scalar(educhs_treat), scalar(educhs_p), scalar(cen_eduhs) \ ///
	        scalar(educbs),     scalar(educbs_cont),    scalar(educbs_treat), scalar(educbs_p), scalar(cen_eduba) \ ///
	        scalar(hhs),     scalar(hhs_cont),    scalar(hhs_treat), scalar(hhs_p), scalar(cen_size) \ ///
	        scalar(child),     scalar(child_cont),    scalar(child_treat), scalar(child_p), 999  \ ///
	        scalar(ret),     scalar(ret_cont),    scalar(ret_treat), scalar(ret_p), 999  \ ///
	        scalar(wella05),     scalar(wella05_cont),    scalar(wella05_treat), scalar(wella05_p), 999  \ ///
	        scalar(wella610),     scalar(wella610_cont),    scalar(wella610_treat), scalar(wella610_p), 999  \ ///
	        scalar(wella1120),     scalar(wella1120_cont),    scalar(wella1120_treat), scalar(wella1120_p), 999  \ ///
	        scalar(wella20),     scalar(wella20_cont),    scalar(wella20_treat), scalar(wella20_p), 999  \ ///
	        scalar(wellauns),     scalar(wellauns_cont),    scalar(wellauns_treat), scalar(wellauns_p), 999  \ ///
	        scalar(welld050),     scalar(welld050_cont),    scalar(welld050_treat), scalar(welld050_p), 999  \ ///
	        scalar(welld51150),     scalar(welld51150_cont),    scalar(welld51150_treat), scalar(welld51150_p), 999  \ ///
	        scalar(welld150),     scalar(welld150_cont),    scalar(welld150_treat), scalar(welld150_p), 999  \ ///
	        scalar(wellduns),     scalar(wellduns_cont),    scalar(wellduns_treat), scalar(wellduns_p), 999  \ ///
			scalar(f), 999 , 999 , 999 , 999 )  		
				
		
mat rownames A = "Owns Home"  ///
				 "Income <$25K"  ///
				 "Income $25K-$50K"  ///
				 "Income $50K-$100K"  ///
				 "Income $100K-$200K"  ///
				 "Income >$200K"  ///
				 "High School or Lower"  ///
				 "Associates or Higher"  ///
				 "HH Size"  ///
				 "Children/Infants"  ///
				 "Retirees"  ///
				 "Well Age (0-5)" ///
				 "Well Age (6-10)" ///
				 "Well Age (11-20)" ///
				 "Well Age (ov20)" ///
				 "Wall Age - Unsure" ///
				 "Well Dep (0-50)" ///
				 "Well Dep (51-150)" ///
				 "Well Dep (ov150)"  ///
				 "Well Dep Unsure" ///
				 "F-Test"

mat colnames A = "All" "Control" "Treatment" "Difference" "Census" 
			
esttab matrix(A, fmt(3)) using $output/table_1.csv, replace  ///
    b(a2) mlabels() 

	
		
***********************************
*Testing, Avoidance, and Perceptions
	
*Uses Well for Drinking Water
sum well_drinking0 
	scalar drink = r(mean)	
sum well_drinking0 if treat==0
	scalar drink_cont = r(mean)	
sum well_drinking0 if treat==1
	scalar drink_treat = r(mean)
reg well_drinking0 treat
	test treat
	scalar drink_p=r(p)	
	
*Tests - Ever
sum test_any0 
	scalar testany = r(mean)	
sum test_any0 if treat==0
	scalar testany_cont = r(mean)	
sum test_any0 if treat==1
	scalar testany_treat = r(mean)
reg test_any0 treat
	test treat
	scalar testany_p=r(p)	

*Tests - Grants to County (Ever)
sum test_g2c0 
	scalar testg2c = r(mean)	
sum test_g2c0 if treat==0
	scalar testg2c_cont = r(mean)	
sum test_g2c0 if treat==1
	scalar testg2c_treat = r(mean)
reg test_g2c0 treat
	test treat
	scalar testg2c_p=r(p)	

*Tests - Past Year
sum test_1year0
	scalar test1yr = r(mean)	
sum test_1year0 if treat==0
	scalar test1yr_cont = r(mean)	
sum test_1year0 if treat==1
	scalar test1yr_treat = r(mean)
reg test_1year0 treat
	test treat
	scalar test1yr_p=r(p)	

*Bottled Water Use
sum bw_use0 
	scalar bw = r(mean)	
sum bw_use0 if treat==0
	scalar bw_cont = r(mean)	
sum bw_use0 if treat==1
	scalar bw_treat = r(mean)
reg bw_use0 treat
	test treat
	scalar bw_p=r(p)
	
*Water Cooler Use
sum cooler_use0  
	scalar cool = r(mean)	
sum cooler_use0 if treat==0
	scalar cool_cont = r(mean)	
sum cooler_use0 if treat==1
	scalar cool_treat = r(mean)
reg cooler_use0 treat
	test treat
	scalar cool_p=r(p)

*Filter Use
gen filt0=filter_pitch0+filter_tap0
replace filt0=1 if filt0>1 & !missing(filt0)
sum filt0 
	scalar filt = r(mean)	
sum filt0 if treat==0
	scalar filt_cont = r(mean)	
sum filt0 if treat==1
	scalar filt_treat = r(mean)
reg filt0 treat
	test treat
	scalar filt_p=r(p)

*RO Filter Use
sum wholehome_type_ro0 
	scalar filtro = r(mean)
sum wholehome_type_ro0 if treat==0
	scalar filtro_cont = r(mean)	
sum wholehome_type_ro0 if treat==1
	scalar filtro_treat = r(mean)
reg wholehome_type_ro0 treat
	test treat
	scalar filtro_p=r(p)

*Any Avoidance/Testing (Any Filter)
gen test_filt1_wat=0
	replace test_filt1_wat=1 if test_1year0==1|filt0==1|cooler_use0==1|bw_use0==1
	replace test_filt1_wat=. if well_drinking0==0
sum test_filt1_wat 
	scalar avert1 = r(mean)
sum test_filt1_wat if treat==0
	scalar avert1_cont = r(mean)	
sum test_filt1_wat if treat==1
	scalar avert1_treat = r(mean)
reg test_filt1_wat treat
	test treat
	scalar avert1_p=r(p)	

*Any Avoidance/Testing (Any Filter)
gen test_filt2_wat=0
	replace test_filt2_wat=1 if test_1year0==1|wholehome_type_ro0==1|cooler_use0==1|bw_use0==1
	replace test_filt2_wat=. if well_drinking0==0
sum test_filt2_wat 
	scalar avert2 = r(mean)
sum test_filt2_wat if treat==0
	scalar avert2_cont = r(mean)	
sum test_filt2_wat if treat==1
	scalar avert2_treat = r(mean)
reg test_filt2_wat treat
	test treat
	scalar avert2_p=r(p)
	
*Rate Water Quatily Goood/Great
gen rate_goodgr0=rate_great0+rate_good0 
sum rate_goodgr0 
	scalar rategood = r(mean)	
sum rate_goodgr0 if treat==0
	scalar rategood_cont = r(mean)	
sum rate_goodgr0 if treat==1
	scalar rategood_treat = r(mean)
reg rate_goodgr0 treat
	test treat
	scalar rategood_p=r(p)
	
*Rate Water Quatily Poor
sum rate_poor0 
	scalar ratepoor = r(mean)	
sum rate_poor0 if treat==0
	scalar ratepoor_cont = r(mean)	
sum rate_poor0 if treat==1
	scalar ratepoor_treat = r(mean)
reg rate_poor0 treat
	test treat
	scalar ratepoor_p=r(p)
	
*Nitrate Concern - Local Area
sum nit_concern_local0
	scalar nitloc = r(mean)
sum nit_concern_local0 if treat==0
	scalar nitloc_cont = r(mean)	
sum nit_concern_local0 if treat==1
	scalar nitloc_treat = r(mean)
reg nit_concern_local0 treat
	test treat
	scalar nitloc_p=r(p)
		
*Nitrate Concern - State
sum nit_concern_state0 
	scalar nitst = r(mean)	
sum nit_concern_state0 if treat==0
	scalar nitst_cont = r(mean)	
sum nit_concern_state0 if treat==1
	scalar nitst_treat = r(mean)
reg nit_concern_state0 treat
	test treat
	scalar nitst_p=r(p)

***	
*Creating matrix  wuse1_dif_ws  
matrix A = (scalar(drink),   scalar(drink_cont),    scalar(drink_treat),    scalar(drink_p) \ ///
	        scalar(testany), scalar(testany_cont),  scalar(testany_treat),  scalar(testany_p) \ ///
	        scalar(testg2c), scalar(testg2c_cont),  scalar(testg2c_treat),  scalar(testg2c_p) \ ///
	        scalar(test1yr), scalar(test1yr_cont),  scalar(test1yr_treat),  scalar(test1yr_p) \ ///
	        scalar(bw), scalar(bw_cont),  scalar(bw_treat),  scalar(bw_p) \ ///
	        scalar(cool), scalar(cool_cont),  scalar(cool_treat),  scalar(cool_p) \ ///
	        scalar(filt), scalar(filt_cont),  scalar(filt_treat),  scalar(filt_p) \ ///
	        scalar(filtro), scalar(filtro_cont),  scalar(filtro_treat),  scalar(filtro_p) \ ///
	        scalar(avert1), scalar(avert1_cont),  scalar(avert1_treat),  scalar(avert1_p) \ ///
	        scalar(avert2), scalar(avert2_cont),  scalar(avert2_treat),  scalar(avert2_p) \ ///
	        scalar(rategood), scalar(rategood_cont),  scalar(rategood_treat),  scalar(rategood_p) \ ///
	        scalar(ratepoor), scalar(ratepoor_cont),  scalar(ratepoor_treat),  scalar(ratepoor_p) \ ///
	        scalar(nitloc), scalar(nitloc_cont),  scalar(nitloc_treat),  scalar(nitloc_p) \ ///
	        scalar(nitst), scalar(nitst_cont),  scalar(nitst_treat),  scalar(nitst_p))  		
				
		
mat rownames A = "Use Well for Drinking" ///
				 "Ever Tested Well" ///
				 "Tested Using GTC (Ever)" ///
				 "Tested in Last Year" ///
				 "Uses Bottled Water" ///
				 "Uses Water Cooler" ///
				 "Filters Water (Any)" ///
				 "Reverse Osmosis Filter" ///
				 "Any Averting (Any Filter)" ///
				 "Any Averting (RO Filter)" ///
				 "Rates Water Quality Good-Great " ///
				 "Rates Water Quality Poor" ///
				 "Perceives Local Nitrate Problem" ///
				 "Perceives State Nitrate Problem" 

mat colnames A = "All" "Control" "Treatment" "Difference"  
			
esttab matrix(A, fmt(3)) using $output/table_2.csv, replace  ///
    b(a2) mlabels() 

frame change main 
frame drop sum_stats