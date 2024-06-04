**************************************************************
*Improving Private Well Testing Programs: Experimental Evidence from Iowa
* THIS FILE:
*   1) CLEAN ANONYMIZED SURVEY DATA AND MERGES WITH GEOSPATIAL DATA
*   2) CLEAN CENSUS DATA
*   3) CLEAN IOWA DNR PWTS DATA
* Last Updated: 1/30/2024
**************************************************************
frame create clean
frame change clean

********************************
* 1) CLEAN ANONYMIZED SURVEY DATA AND MERGES WITH GEOSPATIAL DATA

*****
*WTP Survey 1: Round 1, Period 1
import excel "$data_surv\WTP1 (4245) testkit.xlsx", sheet("WTP1 (4245) testkit") firstrow case(lower) clear

*Dropping missing or irrelevant data 
drop if missing(id) //Drop if missing ID
gen private_well=0
	replace private_well=1 if q2_privatewell=="Yes"
drop q2*

*Survey Round
gen round=1
	label var round "Survey Round"
	
*Own Home Indicator
* Notes: - If don't own home, then rent home
gen own_home=0 if !missing(q1_own)|!missing(q1_rent)
	replace own_home=1 if q1_own=="Yes"
	label var own_home "Owns Home"
gen rent_home=0 if !missing(q1_own)|!missing(q1_rent)
	replace rent_home=1 if q1_rent=="Yes"
	label var rent_home "Rents Home"
drop q1_own q1_rent	
	
*Well Age
gen well_age_05=0 if !missing(q3_age)
	replace well_age_05=1 if q3_age=="0-5 years"
	label var well_age_05 "Age of Well 0-5 Years"
gen well_age_610=0 if !missing(q3_age) 
	replace well_age_610=1 if q3_age=="6-10 years"
	label var well_age_610 "Age of Well 6-10 Years"
gen well_age_1120=0 if !missing(q3_age) 
	replace well_age_1120=1 if q3_age=="11-20 years"
	label var well_age_1120 "Age of Well 11-20 Years"	
gen well_age_ov20=0 if !missing(q3_age) 
	replace well_age_ov20=1 if q3_age=="More than 20 years"
	label var well_age_ov20 "Age of Well >20 Years"		
gen well_age_notsure=0 if !missing(q3_age)  
	replace well_age_notsure=1 if q3_age=="Not Sure"
	label var well_age_notsure "Not Sure Age of Well"
gen well_age=2.5 if well_age_05==1
	replace well_age=8 if well_age_610==1
	replace well_age=15 if well_age_1120==1
	replace well_age=25 if well_age_ov20==1
	label var well_age "Well Age Category"
drop q3_age

*Well Depth
gen well_dpth_050=0 if !missing(q3_depth)  
	replace well_dpth_050=1 if q3_depth=="Less than 50 feet"
	label var well_dpth_050 "Depth of Well <50 Feet"
gen well_dpth_51150=0 if !missing(q3_depth)  
	replace well_dpth_51150=1 if q3_depth=="51-150 feet"
	label var well_dpth_51150 "Depth of Well 50-150 Feet"
gen well_dpth_ov150=0 if !missing(q3_depth)  
	replace well_dpth_ov150=1 if q3_depth=="More than 150 feet"
	label var well_dpth_ov150 "Depth of Well >150 Feet"
gen well_dpth_notsure=0 if !missing(q3_depth)  
	replace well_dpth_notsure=1 if q3_depth=="Not Sure"
	label var well_dpth_notsure "Not Sure Depth of Well"
gen well_depth=25 if well_dpth_050==1
	replace well_depth=100 if well_dpth_51150==1
	replace well_depth=150 if well_dpth_ov150==1	
	label var well_depth "Well Depth Category"
drop q3_depth
	
*Well Uses - Drinking Water
gen well_drinking0=0 if !missing(q4_drinkingwater)|!missing(q4_cooking)|!missing(q4_showering)|!missing(q4_landscaping)
	replace well_drinking0=1 if q4_drinkingwater=="All" 
	replace well_drinking0=1 if q4_drinkingwater=="Most"
	replace well_drinking0=1 if q4_drinkingwater=="Some"
	label var well_drinking0 "Uses Well for Drinking Water"
gen well_drinking_all0=0 if !missing(well_drinking0)
	replace well_drinking_all0=1 if q4_drinkingwater=="All" 
	label var well_drinking_all0 "Uses Well for Drinking Water All of Time"
gen well_drinking_most0=0 if !missing(well_drinking0)
	replace well_drinking_most0=1 if q4_drinkingwater=="Most"
	label var well_drinking_most0 "Uses Well for Drinking Water Most of Time"	
gen well_drinking_some0=0 if !missing(well_drinking0)
	replace well_drinking_some0=1 if q4_drinkingwater=="Some"
	label var well_drinking_some0 "Uses Well for Drinking Water Some of Time"
gen well_drinking_none0=0 if !missing(well_drinking0)
	replace well_drinking_none0=1 if q4_drinkingwater=="None"
	label var well_drinking_none0 "Doesn't Use Well for Drinking Water"

*Well Uses - Cooking
gen well_cook0=0 if !missing(well_drinking0)
	replace well_cook0=1 if q4_cooking=="All" 
	replace well_cook0=1 if q4_cooking=="Most"
	replace well_cook0=1 if q4_cooking=="Some"
	label var well_cook0 "Uses Well for Cooking"
gen well_cook_all0=0 if !missing(well_drinking0)
	replace well_cook_all0=1 if q4_cooking=="All" 
	label var well_cook_all0 "Uses Well for Cooking All of Time"
gen well_cook_most0=0 if !missing(well_drinking0)
	replace well_cook_most0=1 if q4_cooking=="Most"
	label var well_cook_most0 "Uses Well for Cooking Most of Time"	
gen well_cook_some0=0 if !missing(well_drinking0)
	replace well_cook_some0=1 if q4_cooking=="Some"
	label var well_cook_some0 "Uses Well for Cooking Some of Time"
gen well_cook_none0=0 if !missing(well_drinking0)
	replace well_cook_none0=1 if q4_cooking=="None"
	label var well_cook_none0 "Doesn't Use Well for Cooking"	
drop q4_drinkingwater q4_cooking q4_laundry q4_landscaping q4_showering
*NOTE - DROPPING WELL USES FOR LAUNDRY, LANDSCAPING, AND SHOWERING

*Other Sources Water - Bottled Water
gen bw_use0=0 if !missing(q5_bottled)|!missing(q5_cooler)|!missing(q5_others)|!missing(well_drinking0)
	replace bw_use0=1 if q5_bottled=="Yes"
	label var bw_use0 "Uses Bottled Water"
gen bw_none0=0 if !missing(bw_use0)  
	replace bw_none0=1 if q5_bottled=="No"
	label var bw_none0 "Doesn't Use Bottled Water"

*Other Sources Water - Water Cooler
gen cooler_use0=0 if !missing(bw_use0) 
	replace cooler_use0=1 if q5_cooler=="Yes"
	label var cooler_use0 "Uses Water Cooler"
gen cooler_none0=0 if !missing(bw_use0)  
	replace cooler_none0=1 if q5_cooler=="No"
	label var cooler_none0 "Doesn't Use Water Cooler"
	
*Other Sources Water - Bottled Water or Cooler
gen bwc_use0=0 if !missing(bw_use0) 
	replace bwc_use0=1 if q5_bottled=="Yes"|q5_cooler=="Yes" 
	label var bwc_use0 "Uses Bottled Water or Cooler"

*Other Sources Water  
gen oth_source0=0 if !missing(bw_use0) 
	replace oth_source0=1 if q5_others=="Yes" 
	replace oth_source0=0 if strpos(q5_others_text, "animals")
	replace oth_source0=0 if strpos(q5_others_text, "Farm Well")
	replace oth_source0=0 if strpos(q5_others_text, "Ice")
	replace oth_source0=0 if strpos(q5_others_text, "Friend's well water")
	replace oth_source0=0 if strpos(q5_others_text, "C pap machine, iron")
	replace oth_source0=0 if strpos(q5_others_text, "Just the well")
	replace oth_source0=0 if strpos(q5_others_text, "Pasture Creek")
	replace oth_source0=0 if strpos(q5_others_text, "Pets")
	replace oth_source0=0 if strpos(q5_others_text, "Private well")
	replace oth_source0=0 if strpos(q5_others_text, "Separate Well")
	replace oth_source0=0 if strpos(q5_others_text, "Water from a Different Well")
	replace oth_source0=0 if strpos(q5_others_text, "Well Water to Wash Cars")
	replace oth_source0=0 if strpos(q5_others_text, "Well water")
	replace oth_source0=0 if strpos(q5_others_text, "coffee machine")
	replace oth_source0=0 if strpos(q5_others_text, "dehumidifier")
	replace oth_source0=0 if strpos(q5_others_text, "lawn")
	replace oth_source0=0 if strpos(q5_others_text, "Britta")
	replace oth_source0=0 if strpos(q5_others_text, "Reverse Osmosis")
	replace oth_source0=0 if strpos(q5_others_text, "RO system")
	replace oth_source0=0 if strpos(q5_others_text, "Reverse osmosis")
	replace oth_source0=0 if strpos(q5_others_text, "filter")
	replace oth_source0=0 if strpos(q5_others_text, "Filter")
	replace oth_source0=0 if strpos(q5_others_text, "water softener")
	replace oth_source0=0 if strpos(q5_others_text, "Refridgerator")
	replace oth_source0=0 if strpos(q5_others_text, "Water Softener")
	replace oth_source0=0 if strpos(q5_others_text, "bottled")
	replace oth_source0=0 if strpos(q5_others_text, "water purifier")
	replace oth_source0=0 if strpos(q5_others_text, "fridge")
	replace oth_source0=0 if strpos(q5_others_text, "water system")
	replace oth_source0=0 if strpos(q5_others_text, "Refrigerator")
	replace oth_source0=0 if strpos(q5_others_text, "ZeroWater")
	label var oth_source0 "Other Water Source"

*Any alternative source use
gen alt_source_use0=0 if !missing(bw_use0) 
	replace alt_source_use0=1 if q5_bottled=="Yes"|q5_cooler=="Yes"|oth_source0==1
	label var alt_source_use0 "Uses BW/Cooler/Other Drinking Water Source"
drop q5_bottled q5_cooler q5_others q5_bottle_gal ///
     q5_cooler_gal q5_other_gal q5_other_txt_gal q5_bottle_year ///
	 q5_cooler_year q5_other_year q5_other_txt_year
*NOTE - DROPPING INFORMATION ON VOLUME OF WATER USE, OTHER SOURCES, AND YEAR 
*        STARTED USING ALTERNATIVE WATER SOURCES

*Water Filter Use - Any
gen filter_any0=0 if !missing(q6_pitcher)|!missing(q6_ontap)|!missing(q6_infridge)|!missing(q6_wholehome)|!missing(q6_pitcher_howmuch)|!missing(q6_ontap_howmuch)|!missing(q6_infridge_howmuch)|!missing(q6_wholehome_howmuch)|!missing(well_drinking0)
	replace filter_any0=1 if q6_pitcher=="Yes"|q6_ontap=="Yes"|q6_infridge=="Yes"|q6_wholehome=="Yes"
	replace filter_any0=1 if !missing(q6_pitcher_howmuch)|!missing(q6_ontap_howmuch)|!missing(q6_infridge_howmuch)|!missing(q6_wholehome_howmuch)
	label var filter_any0 "Uses Pitcher, On Tap, In Fridge, or Whole Home Filter"
gen filter_none0=0 if !missing(filter_any0)  
	replace filter_none0=1 if q6_pitcher=="No" & q6_ontap=="No" & q6_infridge=="No" & q6_wholehome=="No" 
	label var filter_none0 "Doesn't Filter'"
	
*Filter Use Intensity
gen filter_all0=0 if !missing(filter_any0)
	replace filter_all0=1 if q6_pitcher_howmuch=="All"|q6_ontap_howmuch=="All"|q6_infridge_howmuch=="All"|q6_wholehome_howmuch=="All" 
	label var filter_all0 "Filters All Water"
gen filter_most0=0 if !missing(filter_any0)
	replace filter_most0=1 if q6_pitcher_howmuch=="Most"|q6_ontap_howmuch=="Most"|q6_infridge_howmuch=="Most"|q6_wholehome_howmuch=="Most"
	label var filter_most0 "Filters Most Water"
gen filter_some0=0 if !missing(filter_any0)
	replace filter_some0=1 if q6_pitcher_howmuch=="Some"|q6_ontap_howmuch=="Some"|q6_infridge_howmuch=="Some"|q6_wholehome_howmuch=="Some" & filter_any0==1
	replace filter_some0=1 if q6_pitcher_howmuch=="Very Little"|q6_ontap_howmuch=="Very Little"|q6_infridge_howmuch=="Very Little"|q6_wholehome_howmuch=="Very Little" & filter_any0==1
	label var filter_some0 "Filters Some Water"
	
*Filter Use Type
gen filter_pitch0=0 if !missing(filter_any0)
	replace filter_pitch0=1 if q6_pitcher=="Yes"
	label var filter_pitch0 "Filter - Pitcher"
gen filter_tap0=0 if !missing(filter_any0)
	replace filter_tap0=1 if q6_ontap=="Yes"
 	label var filter_tap0 "Filter - Tap"
gen filter_fridge0=0 if !missing(filter_any0)
	replace filter_fridge0=1 if q6_infridge=="Yes"
 	label var filter_fridge0 "Filter - Fridge"
gen filter_whhome0=0 if !missing(filter_any0)
	replace filter_whhome0=1 if q6_wholehome=="Yes"
 	label var filter_whhome0 "Filter - Whole Home"
	
gen wholehome_type_ro0=0 if !missing(filter_any0) 
	replace wholehome_type_ro0=1 if strpos(q5_others_text, "Osmosis")
	replace wholehome_type_ro0=1 if strpos(q5_others_text, "RO")
	replace wholehome_type_ro0=1 if strpos(q5_others_text, "osmosis")
	label var wholehome_type_ro0 "Whole Home - Reverse Osmosis System"
drop q6_pitcher q6_ontap q6_infridge q6_wholehome q6_pitcher_howmuch ///
     q6_ontap_howmuch q6_infridge_howmuch q6_wholehome_howmuch q5_others_text
*NOTE - NOT CONSIDERING USE OF PITCHER/ON-TAP/IN-FRIDGE FILTER SEPERATELY	

*Any Avoidance Behavior
gen avoidance_any0=0 if !missing(filter_any0)|!missing(bw_use0)
	replace avoidance_any0=1 if alt_source_use0==1|filter_any0==1
	label var avoidance_any0 "Any Avoidance Behavior"

*Known Nitrate Avoidance 
gen avoidance_nitrate0=0 if !missing(filter_any0)|!missing(bw_use0)
	replace avoidance_nitrate0=1 if bwc_use0==1
	label var avoidance_nitrate0 "Known Nitrate Avoidance Behavior"
	
*Testing - Any Reported Testing
gen test_any0=0 if !missing(q7_tested_primary)|!missing(q7_tested_nitrate)|!missing(q7_primary_when)|!missing(q7_nitrate_when)|!missing(q71_lasttest_when)
	replace test_any0=1 if q7_tested_primary=="Yes"
	replace test_any0=1 if q7_tested_nitrate=="Yes"
	replace test_any0=1 if !missing(q7_primary_when)|!missing(q7_nitrate_when)
	replace test_any0=1 if !missing(q71_lasttest_when) & q71_lasttest_when!="Never"
	replace test_any0=0 if q71_lasttest_when=="Never"
	label var test_any0 "Any Reported Testing"

*Testing - Tested Primary Water Source for Nitrate
gen test_nit0=0 if !missing(test_any0)
	replace test_nit0=1 if q7_tested_nitrate=="Yes"
	label var test_nit0 "Tested Primary Water Source for Nitrate"

*Testing - Unsure if Tested Primary Water Source 
gen test_unsure0=0 if !missing(test_any0)
	replace test_unsure0=1 if q7_tested_primary=="Unsure"
	label var test_unsure0 "Unsure if Tested Primary Water Source"
	
*Testing - Didn't Test Primary Water Source 
gen test_none0=0 if !missing(test_any0)
	replace test_none0=1 if q7_tested_primary=="No"
	replace test_none0=1 if q71_lasttest_when=="Never"	
	label var test_none0 "Didn't Test Primary Water Source"
	
*Testing - In Last Year
gen test_1year0=0 if !missing(test_any0)
	replace test_1year0=1 if q71_lasttest_when=="In the last year"
	label var test_1year0 "Last Water Test in Last Year"
	
*Testing - In Last 2 Years
gen test_2year0=0 if !missing(test_any0)
	replace test_2year0=1 if test_1year0==1
	replace test_2year0=1 if q71_lasttest_when=="In the last two years"
	label var test_2year0 "Last Water Test in Last Two Years"
drop q7_tested_primary q7_tested_nitrate q7_primary_when q7_nitrate_when q71_lasttest_when
	
*Water Quality Rating - Great
gen rate_great0=0 if !missing(q8_rate)
	replace rate_great0=1 if q8_rate=="Great"
	label var rate_great0 "Rates Drinking Water Quality Great"	
 
*Water Quality Rating - Good
gen rate_good0=0 if !missing(rate_great0)
	replace rate_good0=1 if q8_rate=="Good"
	label var rate_good0 "Rates Drinking Water Quality Good"	

*Water Quality Rating - Neutral
gen rate_neut0=0 if !missing(rate_great0)
	replace rate_neut0=1 if q8_rate=="Neutral"
	label var rate_neut0 "Rates Drinking Water Quality Neutral"	
 	
*Water Quality Rating - Poor
gen rate_poor0=0 if !missing(rate_great0)
	replace rate_poor0=1 if q8_rate=="Poor"
	label var rate_poor0 "Rates Drinking Water Quality Poor"	

*Water Quality Rating - Unsure
gen rate_unsure0=0 if !missing(rate_great0)
	replace rate_unsure0=1 if q8_rate=="Unsure"
	label var rate_unsure0 "Unsure Drinking Water Quality"	
drop q8_rate

*Water Quality News - Heard of Any Concerns
gen news_concerns_any0=0 if !missing(q9_news_local)|!missing(q9_news_county)|!missing(q9_news_state)
	replace news_concerns_any0=1 if q9_news_local=="Yes"|q9_news_county=="Yes"|q9_news_state=="Yes"
	label var news_concerns_any0 "Heard of DW Quality in Local, County or State"	

*Water Quality News - No Concerns
gen news_concerns_none0=0 if !missing(news_concerns_any0) 
	replace news_concerns_none0=1 if q9_news_local=="No" & q9_news_county=="No" & q9_news_state=="No"
	label var news_concerns_none0 "Has NOT Heard of DW Quality in Local, County or State"	
	
*Water Quality News - Unsure
gen news_concerns_unsure0=0 if !missing(news_concerns_any0)
	replace news_concerns_unsure0=1 if q9_news_local=="Not Sure" & q9_news_county=="Not Sure" & q9_news_state=="Not Sure"
	label var news_concerns_unsure0 "Unsure of DW Quality in Local, County or State"		
	
*Water Quality News - Local Concerns
gen news_concerns_local0=0 if !missing(news_concerns_any0)
	replace news_concerns_local0=1 if q9_news_local=="Yes" 
	label var news_concerns_local0 "Heard of DW Quality in Local Area"	

*Water Quality News - County Concerns
gen news_concerns_cnty0=0 if !missing(news_concerns_any0)
	replace news_concerns_cnty0=1 if q9_news_county=="Yes" 
	label var news_concerns_cnty0 "Heard of DW Quality in County"	

*Water Quality News - State Concerns
gen news_concerns_state0=0 if !missing(news_concerns_any0)
	replace news_concerns_state0=1 if q9_news_state=="Yes" 
	label var news_concerns_state0 "Heard of DW Quality in State"	
drop q9_news_local q9_news_county q9_news_state
	
*Nitrates in DW Concern - Any
gen nit_concern_any0=0 if !missing(q10_nitrate_local)|!missing(q10_nitrate_county)|!missing(q10_nitrate_state)
	replace nit_concern_any0=1 if q10_nitrate_local=="Yes"|q10_nitrate_county=="Yes"|q10_nitrate_state=="Yes"
	label var nit_concern_any0 "Believes Nitrate Problems in Local, County or State"	

*Nitrates in DW Concern - None
gen nit_concern_none0=0 if !missing(nit_concern_any0)  
	replace nit_concern_none0=1 if q10_nitrate_local=="No" & q10_nitrate_county=="No" & q10_nitrate_state=="No"
	label var nit_concern_none0 "Believes No Nitrate Problems"	
	
*Nitrates in DW Concern - Unsure
gen nit_concern_unsure0=0 if !missing(nit_concern_any0)
	replace nit_concern_unsure0=1 if q10_nitrate_local=="Not Sure" & q10_nitrate_county=="Not Sure" & q10_nitrate_state=="Not Sure"
	label var nit_concern_unsure0 "Unsure of Any Nitrate Problems"	
	
*Nitrates in DW Concern - Local
gen nit_concern_local0=0 if !missing(nit_concern_any0)
	replace nit_concern_local0=1 if q10_nitrate_local=="Yes"
	label var nit_concern_local0 "Believes Nitrate Problems in Local Area"	

*Nitrates in DW Concern - County
gen nit_concern_cnty0=0 if !missing(nit_concern_any0)
	replace nit_concern_cnty0=1 if q10_nitrate_county=="Yes"
	label var nit_concern_cnty0 "Believes Nitrate Problems in County"			
	
*Nitrates in DW Concern - State
gen nit_concern_state0=0 if !missing(nit_concern_any0)
	replace nit_concern_state0=1 if q10_nitrate_state=="Yes"
	label var nit_concern_state0 "Believes Nitrate Problems in State"	
drop q10_nitrate_local q10_nitrate_county q10_nitrate_state
		
*Infants in Home
replace q11_infants="5" if strpos(q11_infants, ">5")
destring q11_infants, replace
gen infants_ind=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace infants_ind=1 if !missing(q11_infants) & q11_infants>0
	label var infants "Any Infants in Home (Indicator)"	
gen infants=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace infants=q11_infants if !missing(q11_infants) 

*Children in Home
replace q11_children="5" if strpos(q11_children, ">5")
destring q11_children, replace
gen children_ind=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace children_ind=1 if !missing(q11_children) & q11_children>0
	label var children "Any Children in Home (Indicator)"	
gen children=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace children=q11_children if !missing(q11_children) 

*Adults in Home
replace q11_adults="5" if strpos(q11_adults, ">5")
destring q11_adults, replace
replace q11_retired="5" if strpos(q11_retired, ">5")
destring q11_retired, replace
gen adults_ind=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace adults_ind=1 if !missing(q11_adults) & q11_adults>0
	label var adults_ind "Any Adults In Home (Indicator)"	
replace q11_adults=0 if missing(q11_adults)
replace q11_retired=0 if missing(q11_retired)	
gen adults=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace adults=q11_adults if !missing(adults_ind) & q11_adults>0
	replace adults=. if missing(adults_ind)

*Retirement Eligible Adults in Home
gen retiree_ind=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace retiree_ind=1 if !missing(q11_retired) & q11_retired>0 
	label var retiree_ind "Any Retirement Eligible in Home (Indicator)"	
gen retiree=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace retiree=q11_retired if !missing(retiree_ind) & q11_retired>0
gen chil_inf=children+infants
gen hh_size=infants+children+adults+retiree  

*Education - Masters or Higher
gen educ_mast=0 if !missing(q11_education)
	replace educ_mast=1 if q11_education=="Master’s degree or higher"
	label var educ_mast "Education - Master's Degree or Higher"	

*Education - Bachelors 
gen educ_bach=0 if !missing(q11_education)
	replace educ_bach=1 if q11_education=="Bachelor’s degree"
	label var educ_bach "Education - Bachelor's Degree"	
gen educ_bach_high=educ_mast+educ_bach
	label var educ_bach "Education - Bachelor's or Higher"	

*Education - High School or Less
gen educ_hs=0 if !missing(q11_education)
	replace educ_hs=1 if q11_education=="High school diploma or equivalent"|q11_education=="Some college, no degree"|q11_education=="No formal educational credential"
	label var educ_hs "Education - High School Degree or Less"	

*Income - Greater than $200,000
gen income_200=0 if !missing(q11_income)
	replace income_200=1 if q11_income==">$200,000"
	label var income_200 "Income - >$200,000"
	
*Income - $100,000-$200,000
gen income_100200=0 if !missing(q11_income)
	replace income_100200=1 if q11_income=="$100,000- $200,000"
	label var income_100200 "Income - $100,000- $200,000"
	
*Income - $50,000- $100,000
gen income_50100=0 if !missing(q11_income)
	replace income_50100=1 if q11_income=="$50,000- $100,000"
	label var income_50100 "Income - $50,000- $100,0000"			

*Income - $25,000- $50,000
gen income_2550=0 if !missing(q11_income)
	replace income_2550=1 if q11_income=="$25,000 -$50,000"
	label var income_2550 "Income - $25,000 -$50,000"		
	
*Income - Less Than $25,000 
gen income_25=0 if !missing(q11_income)
	replace income_25=1 if q11_income=="<$25,000"
	label var income_25 "Income - <$25,000"		
drop q11_infants q11_children q11_adults q11_retired q11_education q11_income comments

*Test Kit?
gen test_kit=0
	replace test_kit=1 if testkit=="yes"
	label var test_kit "Mailed Nitrate Test Kit"
drop testkit
save $data_clean\survey1, replace


*****
*WTP Survey 2: Round 1, Period 2
import excel "$data_surv\WTP2.xlsx", sheet("WTP2") firstrow case(lower) clear
rename id2 id
rename county_abbr2 county_abbr

*Survey Round
gen round=1
	label var round "Survey Round"
	
*Well Uses - Drinking Water
gen well_drinking=0 if !missing(q1_drinkingwater)|!missing(q1_cooking)|!missing(q1_laundry)|!missing(q1_landscaping)|!missing(q1_showering)
	replace well_drinking=1 if q1_drinkingwater=="All" 
	replace well_drinking=1 if q1_drinkingwater=="Most"
	replace well_drinking=1 if q1_drinkingwater=="Some"
	label var well_drinking "Uses Well for Drinking Water"
gen well_drinking_all=0 if !missing(well_drinking)
	replace well_drinking_all=1 if q1_drinkingwater=="All" 
	label var well_drinking_all "Uses Well for Drinking Water All of Time"
gen well_drinking_most=0 if !missing(well_drinking)
	replace well_drinking_most=1 if q1_drinkingwater=="Most"
	label var well_drinking_most "Uses Well for Drinking Water Most of Time"	
gen well_drinking_some=0 if !missing(well_drinking)
	replace well_drinking_some=1 if q1_drinkingwater=="Some"
	label var well_drinking_some "Uses Well for Drinking Water Some of Time"
gen well_drinking_none=0 if !missing(well_drinking)
	replace well_drinking_none=1 if q1_drinkingwater=="None"
	label var well_drinking_none "Doesn't Use Well for Drinking Water"
	
*Well Uses - Cooking
gen well_cook=0 if !missing(well_drinking)
	replace well_cook=1 if q1_cooking=="All" 
	replace well_cook=1 if q1_cooking=="Most"
	replace well_cook=1 if q1_cooking=="Some"
	label var well_cook "Uses Well for Cooking"
gen well_cook_all=0 if !missing(well_drinking)
	replace well_cook_all=1 if q1_cooking=="All" 
	label var well_cook_all "Uses Well for Cooking All of Time"
gen well_cook_most=0 if !missing(well_drinking)
	replace well_cook_most=1 if q1_cooking=="Most"
	label var well_cook_most "Uses Well for Cooking Most of Time"	
gen well_cook_some=0 if !missing(well_drinking)
	replace well_cook_some=1 if q1_cooking=="Some"
	label var well_cook_some "Uses Well for Cooking Some of Time"
gen well_cook_none=0 if !missing(well_drinking)
	replace well_cook_none=1 if q1_cooking=="None"
	label var well_cook_none "Doesn't Use Well for Cooking"	
drop q1_drinkingwater q1_cooking q1_laundry q1_landscaping q1_showering
*NOTE - DROPPING WELL USES FOR LAUNDRY, LANDSCAPING, AND SHOWERING

*Other Sources Water - Bottled Water
gen bw_use=0 if !missing(q2_bottled)|!missing(q2_cooler)|!missing(q2_others2)|!missing(well_drinking)
	replace bw_use=1 if q2_bottled=="Yes"
	label var bw_use "Uses Bottled Water"
gen bw_none=0 if !missing(bw_use)  
	replace bw_none=1 if q2_bottled=="No"
	label var bw_none "Doesn't Use Bottled Water"

*Other Sources Water - Water Cooler
gen cooler_use=0 if !missing(bw_use)
	replace cooler_use=1 if q2_cooler=="Yes"
	label var cooler_use "Uses Water Cooler"
gen cooler_none=0 if !missing(bw_use)  
	replace cooler_none=1 if q2_cooler=="No"
	label var cooler_none "Doesn't Use Water Cooler"
	
*Other Sources Water - Bottled Water or Cooler
gen bwc_use=0 if !missing(bw_use)
	replace bwc_use=1 if q2_bottled=="Yes"|q2_cooler=="Yes"
	label var bwc_use "Uses Bottled Water or Cooler"

*Other sources
gen oth_source=0 if !missing(bw_use) 
	replace oth_source=1 if q2_others2=="Yes" 
	replace oth_source=0 if strpos(q2_others_text2, "shower")
	replace oth_source=0 if strpos(q2_others_text2, "Reverse Osmosis")
	replace oth_source=0 if strpos(q2_others_text2, "Filter")
	replace oth_source=0 if strpos(q2_others_text2, "Brita")
	replace oth_source=0 if strpos(q2_others_text2, "City")
	replace oth_source=0 if strpos(q2_others_text2, "city")
	replace oth_source=0 if strpos(q2_others_text2, "RO")
	replace oth_source=0 if strpos(q2_others_text2, "CPAP")
	replace oth_source=0 if strpos(q2_others_text2, "Keurig")
	replace oth_source=0 if strpos(q2_others_text2, "Rofiltration")
	replace oth_source=0 if strpos(q2_others_text2, "Soft")
	replace oth_source=0 if strpos(q2_others_text2, "Tap")
	replace oth_source=0 if strpos(q2_others_text2, "coffee")
	replace oth_source=0 if strpos(q2_others_text2, "ironing")
	replace oth_source=0 if strpos(q2_others_text2, "osmosis")
	replace oth_source=0 if strpos(q2_others_text2, "ecoli")
	replace oth_source=0 if strpos(q2_others_text2, "homewater")
	replace oth_source=0 if strpos(q2_others_text2, "flower")
	replace oth_source=0 if strpos(q2_others_text2, "pond")
	replace oth_source=0 if strpos(q2_others_text2, "well")
	label var oth_source "Other Water Source"

*Any alternative source use
gen alt_source_use=0 if !missing(bw_use) 
	replace alt_source_use=1 if q2_bottled=="Yes"|q2_cooler=="Yes"|oth_source==1
	label var alt_source_use "Uses BW/Cooler/Other Drinking Water Source"
drop q2_bottled q2_cooler q2_others2 q2_bottled_gallon ///
     q2_cooler_gallon q2_other__gallon_text
*NOTE - DROPPING INFORMATION ON VOLUME OF WATER USE, OTHER SOURCES, AND YEAR 
*        STARTED USING ALTERNATIVE WATER SOURCES

*Water Filter Use - Any  
gen filter_any=0 if !missing(q3_pitcher)|!missing(q3_ontap)|!missing(q3_infridge)|!missing(q3_wholehome)|!missing(q3_pitcher_howmuch)|!missing(q3_ontap_howmuch)|!missing(q3_infridge_howmuch)|!missing(q3_wholehome_howmuch)|!missing(well_drinking)
	replace filter_any=1 if q3_pitcher=="Yes"|q3_ontap=="Yes"|q3_infridge=="Yes"|q3_wholehome=="Yes"
	replace filter_any=1 if !missing(q3_pitcher_howmuch)|!missing(q3_ontap_howmuch)|!missing(q3_infridge_howmuch)|!missing(q3_wholehome_howmuch)
	label var filter_any "Uses Pitcher, On Tap, In Fridge, or Whole Home Filter"
 
*Water Filter Use - None
gen filter_none=0 if !missing(filter_any) 
	replace filter_none=1 if q3_pitcher=="No" & q3_ontap=="No" & q3_infridge=="No" & q3_wholehome=="No"
	label var filter_none "No Filter Use"

*Filter Use Intensity
gen filter_all=0 if !missing(filter_any)
	replace filter_all=1 if q3_pitcher_howmuch=="All"|q3_ontap_howmuch=="All"|q3_infridge_howmuch=="All"|q3_wholehome_howmuch=="All" 
	label var filter_all "Filters All Water"
gen filter_most=0 if !missing(filter_any)
	replace filter_most=1 if q3_pitcher_howmuch=="Most"|q3_ontap_howmuch=="Most"|q3_infridge_howmuch=="Most"|q3_wholehome_howmuch=="Most"
	label var filter_most "Filters Most Water"
gen filter_some=0 if !missing(filter_any)
	replace filter_some=1 if q3_pitcher_howmuch=="Some"|q3_ontap_howmuch=="Some"|q3_infridge_howmuch=="Some"|q3_wholehome_howmuch=="Some" 
	replace filter_some=1 if q3_pitcher_howmuch=="Very Little"|q3_ontap_howmuch=="Very Little"|q3_infridge_howmuch=="Very Little"|q3_wholehome_howmuch=="Very Little"  
	label var filter_some "Filters Some Water"
	
*Filter Use Type
gen filter_pitch=0 if !missing(filter_any)
	replace filter_pitch=1 if q3_pitcher=="Yes"
	label var filter_pitch "Filter - Pitcher"
gen filter_tap=0 if !missing(filter_any)
	replace filter_tap=1 if q3_ontap=="Yes"
 	label var filter_tap "Filter - Tap"
gen filter_fridge=0 if !missing(filter_any)
	replace filter_fridge=1 if q3_infridge=="Yes"
 	label var filter_fridge "Filter - Fridge"
gen filter_whhome=0 if !missing(filter_any)
	replace filter_whhome=1 if q3_wholehome=="Yes"
 	label var filter_whhome "Filter - Whole Home"
drop q3_pitcher q3_ontap q3_infridge  q3_pitcher_howmuch ///
     q3_ontap_howmuch q3_infridge_howmuch 
*NOTE - NOT CONSIDERING USE OF PITCHER/ON-TAP/IN-FRIDGE FILTER SEPERATELY	

*Type of Whole Home Filtration Sytem - Reverse Osmosis
*NOTE - NEW QUESTION IN PERIOD 2 - A
gen wholehome_type_ro=0 if !missing(q3_wholehome)|!missing(q3_wholehome_howmuch)|!missing(q4_osmosis)|!missing(q4_carbon)|!missing(q4_softener)|!missing(q4_other)|!missing(q4_osmosis_date)|!missing(q4_carbon_date)|!missing(q4_softener_date)|!missing(q4_other_date)|!missing(well_drinking)
	replace wholehome_type_ro=1 if q4_osmosis=="Yes"
	replace wholehome_type_ro=1 if !missing(q4_osmosis_date)	
	replace wholehome_type_ro=1 if strpos(q2_others_text2, "RO")
	replace wholehome_type_ro=1 if strpos(q2_others_text2, "Reverse Osmosis")
	label var wholehome_type_ro "Whole Home - Reverse Osmosis System"

*Type of Whole Home Filtration Sytem - Activated Carbon
gen wholehome_type_carbon=0 if !missing(wholehome_type_ro) 
	replace wholehome_type_carbon=1 if q4_carbon=="Yes"
	replace wholehome_type_carbon=1 if !missing(q4_carbon_date)	
	label var wholehome_type_carbon "Whole Home - Activated Carbon System"

*Type of Whole Home Filtration Sytem - Water Softener
gen wholehome_type_softener=0 if !missing(wholehome_type_ro) 
	replace wholehome_type_softener=1 if q4_softener=="Yes"
	replace wholehome_type_softener=1 if !missing(q4_softener_date)	
	label var wholehome_type_softener "Whole Home - Water Softener System"
drop q3_wholehome q3_wholehome_howmuch q4_osmosis q4_carbon q4_softener ///
     q4_other q4_osmosis_date q4_carbon_date q4_softener_date q4_other_date ///
	 q4_other_text q4_other_text_date q2_others_text2
*NOTE - NOT TAKING ADVANTAGE OF INSTALLATION DATE DATA FOR WHOLE HOME FILTER SYSTEMS

*Any Avoidance Behavior
gen avoidance_any=0 if !missing(filter_any)|!missing(bw_use)
	replace avoidance_any=1 if alt_source_use==1|filter_any==1
	label var avoidance_any "Any Avoidance Behavior"

*Known Nitrate Avoidance 
gen avoidance_nitrate=0 if !missing(filter_any)|!missing(bw_use)
	replace avoidance_nitrate=1 if bwc_use==1|wholehome_type_ro==1
	label var avoidance_nitrate "Known Nitrate Avoidance Behavior"
  
*Testing - Tested Primary Water Source
gen test_any=0 if !missing(q5_tested)|!missing(q51_grants)|!missing(q51_private)|!missing(q51_inhome)|!missing(q51_other)|!missing(q52_nitrate)|!missing(q52_metals)|!missing(q52_bacteria)|!missing(q52_pesticide)|!missing(q52_hardness)|!missing(q52_other)|!missing(q52_other_text)
   	replace test_any=1 if q5_tested=="Yes"
   	replace test_any=1 if q51_grants=="Yes"
   	replace test_any=1 if q51_private=="Yes"
   	replace test_any=1 if q51_inhome=="Yes"
   	replace test_any=1 if q51_other=="Yes"
   	replace test_any=1 if q52_nitrate=="Yes"
   	replace test_any=1 if q52_metals=="Yes"
   	replace test_any=1 if q52_bacteria=="Yes"
   	replace test_any=1 if q52_pesticide=="Yes"
   	replace test_any=1 if q52_hardness=="Yes"
   	replace test_any=1 if q52_other=="Yes"
   	replace test_any=1 if !missing(q52_other_text)
	label var test_any "Tested Primary Water Source (Any Type)"

*Testing - Tested in the Last Year
gen test_1year=test_any 
	label var test_1year "Last Water Test in Last Year"
	
*Testing - Provided By Grants to County Program 
gen test_g2c=0 if !missing(test_any)
	replace test_g2c=1 if q51_grants=="Yes"
	label var test_g2c "Tested Provided By Grants 2 Counties"	
	
*Testing - Provided By Private Provider 
gen test_priv=0 if !missing(test_any)
	replace test_priv=1 if q51_private=="Yes"
	label var test_priv "Tested Using Private Provider"	
	
*Testing - Provided By In-Home Kit 
gen test_inhome=0 if !missing(test_any)
	replace test_inhome=1 if q51_inhome=="Yes"
	label var test_inhome "Tested Using In Home Kit"
	
*Testing - Tested Primary Water Source for Nitrate
gen test_nit=0 if !missing(test_any)
	replace test_nit=1 if q52_nitrate=="Yes"
	label var test_nit "Tested Primary Water Source for Nitrate"
	
*Testing - Tested Primary Water Source for Bacteria
gen test_bact=0 if !missing(test_any)
	replace test_bact=1 if q52_bacteria=="Yes"
	label var test_bact "Tested Primary Water Source for Bacteria"
	
*Testing - Tested Primary Water Source for Pesticide
gen test_pest=0 if !missing(test_any)
	replace test_pest=1 if q52_pesticide=="Yes"
	label var test_pest "Tested Primary Water Source for Pesticide"
	
*Testing - Tested Primary Water Source for Metals
gen test_metals=0 if !missing(test_any)
	replace test_metals=1 if q52_metals=="Yes"
	label var test_metals "Tested Primary Water Source for Metals"
	
*Testing - Tested Primary Water Source for Hardness
gen test_hardness=0 if !missing(test_any)
	replace test_hardness=1 if q52_hardness=="Yes"
	label var test_hardness "Tested Primary Water Source for Hardness"
	
*Testing - Tested Primary Water Source for Other
gen test_other=0 if !missing(test_any)
	replace test_other=1 if q52_other=="Yes"
	label var test_other "Tested Primary Water Source for Other"
	
*NOTE - NOT TAKING ADVANTAGE OF INFORMATION ON WHICH PRIVATE OR OTHER COMPANY PROVIDED TEST OR WHETHER THEY TESTED FOR BACTERIA/HEAVY METALS/OTHER CONTAMINANTS
drop q51_grants q51_private q51_inhome q51_other q52_nitrate q52_nitrate q52_metals q52_bacteria q52_pesticide q52_hardness q52_other q52_other_text q5_tested
	
*Water Quality Rating - Great
gen rate_great=0 if !missing(q6_rate)
	replace rate_great=1 if q6_rate=="Great"
	label var rate_great "Rates Drinking Water Quality Great"	
 
*Water Quality Rating - Good
gen rate_good=0 if !missing(q6_rate)
	replace rate_good=1 if q6_rate=="Good"
	label var rate_good "Rates Drinking Water Quality Good"	

*Water Quality Rating - Neutral
gen rate_neut=0 if !missing(q6_rate)
	replace rate_neut=1 if q6_rate=="Neutral"
	label var rate_neut "Rates Drinking Water Quality Neutral"	
 	
*Water Quality Rating - Poor
gen rate_poor=0 if !missing(q6_rate)
	replace rate_poor=1 if q6_rate=="Poor"
	label var rate_poor "Rates Drinking Water Quality Poor"	

*Water Quality Rating - Unsure
gen rate_unsure=0 if !missing(q6_rate)
	replace rate_unsure=1 if q6_rate=="Unsure"
	label var rate_unsure "Unsure Drinking Water Quality"	
drop q6_rate
*NOTE - NOT TAKING ADVANTAGE OF CONCERN ABOUT NITRATE/METALS/BACTERIA/PESTICIDES/HARDNESS/TASTE/OTHER 
drop q7_nitrate q7_metals q7_bacteria q7_pesticide q7_hardness q7_taste q7_other q7_other_text	
	
*Water Quality News - Heard of Any Concerns
gen news_concerns_any=0 if !missing(q8_news_local)|!missing(q8_news_county)|!missing(q8_news_state)
	replace news_concerns_any=1 if q8_news_local=="Yes"|q8_news_county=="Yes"|q8_news_state=="Yes"
	label var news_concerns_any "Heard of DW Quality in Local, County or State"	

*Water Quality News - No Concerns
gen news_concerns_none=0 if !missing(news_concerns_any)
	replace news_concerns_none=1 if q8_news_local=="No" & q8_news_county=="No" & q8_news_state=="No"
	label var news_concerns_none "Has NOT Heard of DW Quality in Local, County or State"	
	
*Water Quality News - Unsure
gen news_concerns_unsure=0 if !missing(news_concerns_any)
	replace news_concerns_unsure=1 if q8_news_local=="Not Sure" & q8_news_county=="Not Sure" & q8_news_state=="Not Sure"
	label var news_concerns_unsure "Unsure of DW Quality in Local, County or State"		
*Water Quality News - Local Concerns
gen news_concerns_local=0 if !missing(news_concerns_any)
	replace news_concerns_local=1 if q8_news_local=="Yes" 
	label var news_concerns_local "Heard of DW Quality in Local Area"	

*Water Quality News - County Concerns
gen news_concerns_cnty=0 if !missing(news_concerns_any)
	replace news_concerns_cnty=1 if q8_news_county=="Yes" 
	label var news_concerns_cnty "Heard of DW Quality in County"	

*Water Quality News - State Concerns
gen news_concerns_state=0 if !missing(news_concerns_any)
	replace news_concerns_state=1 if q8_news_state=="Yes" 
	label var news_concerns_state "Heard of DW Quality in State"	
drop q8_news_local q8_news_county q8_news_state
	
*Nitrates in DW Concern - Any
gen nit_concern_any=0 if !missing(q9_nitrate_local)|!missing(q9_nitrate_county)|!missing(q9_nitrate_state)
	replace nit_concern_any=1 if q9_nitrate_local=="Yes"|q9_nitrate_county=="Yes"|q9_nitrate_state=="Yes"
	label var nit_concern_any "Believes Nitrate Problems in Local, County or State"	

*Nitrates in DW Concern - None
gen nit_concern_none=0 if !missing(nit_concern_any)
	replace nit_concern_none=1 if q9_nitrate_local=="No" & q9_nitrate_county=="No" & q9_nitrate_state=="No"
	label var nit_concern_none "Believes No Nitrate Problems"	
	
*Nitrates in DW Concern - Unsure
gen nit_concern_unsure=0 if !missing(nit_concern_any)
	replace nit_concern_unsure=1 if q9_nitrate_local=="Not Sure" & q9_nitrate_county=="Not Sure" & q9_nitrate_state=="Not Sure"
	label var nit_concern_unsure "Unsure of Any Nitrate Problems"
	
*Nitrates in DW Concern - Local
gen nit_concern_local=0 if !missing(nit_concern_any)
	replace nit_concern_local=1 if q9_nitrate_local=="Yes"
	label var nit_concern_local "Believes Nitrate Problems in Local Area"	

*Nitrates in DW Concern - County
gen nit_concern_cnty=0 if !missing(nit_concern_any)
	replace nit_concern_cnty=1 if q9_nitrate_county=="Yes"
	label var nit_concern_cnty "Believes Nitrate Problems in County"			
	
*Nitrates in DW Concern - State
gen nit_concern_state=0 if !missing(nit_concern_any)
	replace nit_concern_state=1 if q9_nitrate_state=="Yes"
	label var nit_concern_state "Believes Nitrate Problems in State"	
drop q9_nitrate_local q9_nitrate_county q9_nitrate_state

*NOTE - NOT TAKING ADVANTAGE OF QUESTION ON WHO THEY DISCUSS WATER QUALITY CONCERNS WITH
*Infants in Home
drop q10_family q10_private q10_govt q10_extension q10_other q10_other_txt comments2

merge 1:1 id_number using $data_clean\survey1
rename _merge survey_response_type
label var survey_response_type "2 First Only, 3 Both"

*Drop houses that don't rely on private well for primary drinking water source
drop if private_well==0 

*Update baseline avoidance and whole home filter types
replace avoidance_nitrate0=1 if wholehome_type_ro==1 & filter_whhome0==1 
replace wholehome_type_ro0=1 if wholehome_type_ro==1 & filter_whhome0==1 
	label var wholehome_type_ro0 "Whole Home - Reverse Osmosis System"
gen wholehome_type_carbon0=0 if !missing(filter_any0) 
	replace wholehome_type_carbon0=1 if wholehome_type_carbon==1 & filter_whhome0==1 
	label var wholehome_type_carbon0 "Whole Home - Activated Carbon System"
gen wholehome_type_softener0=0 if !missing(filter_any0) 
	replace wholehome_type_softener0=1 if wholehome_type_softener==1 & filter_whhome0==1 
	label var wholehome_type_softener0 "Whole Home - Water Softener System"
drop private_well  
save $data_clean\survey1, replace

*Merging zip code data
import excel "$data_surv\WTP1 (4245)TestKit_zip(6 counties).xlsx", sheet("WTP1 (4245)TestKit_zip(6 counti") firstrow case(lower) clear
keep id_number zip
drop if missing(id_number)
merge 1:1 id_number using $data_clean\survey1
drop if _merge==1
drop _merge
save $data_clean\survey1, replace


*****
*WTP Survey 3: Round 2, Period 1
import excel "$data_surv\WTP3.xlsx", sheet("WTP3") firstrow case(lower) clear

*ID Number
gen id_number=substr(id,3,5)

*Dropping missing or irrelevant data 
drop if missing(id) //Drop if missing ID
gen private_well=0
	replace private_well=1 if q2_privatewell=="Yes"
drop q2*

*Survey Round
gen round=2
	label var round "Survey Round"

*Test Kit?
gen test_kit=0
	replace test_kit=1 if testkit_sample=="yes - received testkit"
	label var test_kit "Mailed Nitrate Test Kit"
drop testkit_sample

*Own Home Indicator
* Notes: - If don't own home, then rent home
gen own_home=0 if !missing(q1_own)|!missing(q1_rent)
	replace own_home=1 if q1_own=="Yes"
	label var own_home "Owns Home"
gen rent_home=0 if !missing(q1_own)|!missing(q1_rent)
	replace rent_home=1 if q1_rent=="Yes"
	label var rent_home "Rents Home"
drop q1_own q1_rent	
	
*Well Age
gen well_age_05=0 if !missing(q3_age)
	replace well_age_05=1 if q3_age=="0-5 years"
	label var well_age_05 "Age of Well 0-5 Years"
gen well_age_610=0 if !missing(q3_age)
	replace well_age_610=1 if q3_age=="6-10 years"
	label var well_age_610 "Age of Well 6-10 Years"
gen well_age_1120=0 if !missing(q3_age)
	replace well_age_1120=1 if q3_age=="11-20 years"
	label var well_age_1120 "Age of Well 11-20 Years"	
gen well_age_ov20=0 if !missing(q3_age)
	replace well_age_ov20=1 if q3_age=="More than 20 years"
	label var well_age_ov20 "Age of Well >20 Years"		
gen well_age_notsure=0 if !missing(q3_age)
	replace well_age_notsure=1 if q3_age=="Not Sure"
	label var well_age_notsure "Not Sure Age of Well"
gen well_age=2.5 if well_age_05==1
	replace well_age=8 if well_age_610==1
	replace well_age=15 if well_age_1120==1
	replace well_age=25 if well_age_ov20==1	
	label var well_age "Well Age Category"	
drop q3_age

*Well Depth
gen well_dpth_050=0 if !missing(q3_depth)
	replace well_dpth_050=1 if q3_depth=="Less than 50 feet"
	label var well_dpth_050 "Depth of Well <50 Feet"
gen well_dpth_51150=0 if !missing(q3_depth)
	replace well_dpth_51150=1 if q3_depth=="51-150 feet"
	label var well_dpth_51150 "Depth of Well 50-150 Feet"
gen well_dpth_ov150=0 if !missing(q3_depth)
	replace well_dpth_ov150=1 if q3_depth=="150-300 feet"|q3_depth=="More than 300 feet"
	label var well_dpth_ov150 "Depth of Well >150 Feet"
gen well_dpth_notsure=0 if !missing(q3_depth)
	replace well_dpth_notsure=1 if q3_depth=="Not Sure"
	label var well_dpth_notsure "Not Sure Depth of Well"
gen well_depth=25 if well_dpth_050==1
	replace well_depth=100 if well_dpth_51150==1
	replace well_depth=150 if well_dpth_ov150==1	
	label var well_depth "Well Depth Category"
drop q3_depth
	
*Well Uses - Drinking Water
gen well_drinking0=0 if !missing(q4_drinkingwater)|!missing(q4_cooking)|!missing(q4_showering)
	replace well_drinking0=1 if q4_drinkingwater=="All" 
	replace well_drinking0=1 if q4_drinkingwater=="Most"
	replace well_drinking0=1 if q4_drinkingwater=="Some"
	label var well_drinking0 "Uses Well for Drinking Water"
gen well_drinking_all0=0 if !missing(well_drinking0)
	replace well_drinking_all0=1 if q4_drinkingwater=="All" 
	label var well_drinking_all0 "Uses Well for Drinking Water All of Time"
gen well_drinking_most0=0 if !missing(well_drinking0)
	replace well_drinking_most0=1 if q4_drinkingwater=="Most"
	label var well_drinking_most0 "Uses Well for Drinking Water Most of Time"	
gen well_drinking_some0=0 if !missing(well_drinking0)
	replace well_drinking_some0=1 if q4_drinkingwater=="Some"
	label var well_drinking_some0 "Uses Well for Drinking Water Some of Time"
gen well_drinking_none0=0 if !missing(well_drinking0)
	replace well_drinking_none0=1 if q4_drinkingwater=="None"
	label var well_drinking_none0 "Doesn't Use Well for Drinking Water"
	
*Well Uses - Cooking
gen well_cook0=0 if !missing(well_drinking0)
	replace well_cook0=1 if q4_cooking=="All" 
	replace well_cook0=1 if q4_cooking=="Most"
	replace well_cook0=1 if q4_cooking=="Some"
	label var well_cook0 "Uses Well for Cooking"
gen well_cook_all0=0 if !missing(well_drinking0)
	replace well_cook_all0=1 if q4_cooking=="All" 
	label var well_cook_all0 "Uses Well for Cooking All of Time"
gen well_cook_most0=0 if !missing(well_drinking0)
	replace well_cook_most0=1 if q4_cooking=="Most"
	label var well_cook_most0 "Uses Well for Cooking Most of Time"	
gen well_cook_some0=0 if !missing(well_drinking0)
	replace well_cook_some0=1 if q4_cooking=="Some"
	label var well_cook_some0 "Uses Well for Cooking Some of Time"
gen well_cook_none0=0 if !missing(well_drinking0)
	replace well_cook_none0=1 if q4_cooking=="None"
	label var well_cook_none0 "Doesn't Use Well for Cooking"
drop q4_drinkingwater q4_cooking  q4_showering
*NOTE - DROPPING WELL USES FOR LAUNDRY, LANDSCAPING, AND SHOWERING

*Other Sources Water - Bottled Water
gen bw_use0=0 if !missing(q5_bottled)|!missing(q5_cooler)|!missing(q5_others)|!missing(well_drinking0)
	replace bw_use0=1 if q5_bottled=="Yes"
	label var bw_use0 "Uses Bottled Water"
gen bw_none0=0 if !missing(bw_use0)
	replace bw_none0=1 if q5_bottled=="No"
	label var bw_none0 "Doesn't Use Bottled Water"

*Other Sources Water - Water Cooler
gen cooler_use0=0 if !missing(bw_use0)
	replace cooler_use0=1 if q5_cooler=="Yes"
	label var cooler_use0 "Uses Water Cooler"
gen cooler_none0=0 if !missing(bw_use0)
	replace cooler_none0=1 if q5_cooler=="No"
	label var cooler_none0 "Doesn't Use Water Cooler"

*Other Sources Water - Bottled Water or Cooler
gen bwc_use0=0 if !missing(bw_use0) 
	replace bwc_use0=1 if q5_bottled=="Yes"|q5_cooler=="Yes" 
	label var bwc_use0 "Uses Bottled Water or Cooler"

*Other Water Sources
gen oth_source0=0 if !missing(bw_use0) 
	replace oth_source0=1 if q5_others=="Yes" 	
	replace oth_source0=0 if strpos(q5_others_text, "city")
	replace oth_source0=0 if strpos(q5_others_text, "coffee")
	replace oth_source0=0 if strpos(q5_others_text, "Brita")
	replace oth_source0=0 if strpos(q5_others_text, "City")
	replace oth_source0=0 if strpos(q5_others_text, "Culligan")
	replace oth_source0=0 if strpos(q5_others_text, "Reverse Osmosis")
	replace oth_source0=0 if strpos(q5_others_text, "filtration")
	replace oth_source0=0 if strpos(q5_others_text, "reverse osmosis")
	replace oth_source0=0 if strpos(q5_others_text, "filter")
	replace oth_source0=0 if strpos(q5_others_text, "Humidifier")
	replace oth_source0=0 if strpos(q5_others_text, "rural water")
	replace oth_source0=0 if strpos(q5_others_text, "tap")
	replace oth_source0=0 if strpos(q5_others_text, "Filtered")
	replace oth_source0=0 if strpos(q5_others_text, "Filtration")
	replace oth_source0=0 if strpos(q5_others_text, "Fridge")
	replace oth_source0=0 if strpos(q5_others_text, "softner")
	replace oth_source0=0 if strpos(q5_others_text, "Rural Water")
	replace oth_source0=0 if strpos(q5_others_text, "Osmosis")
	replace oth_source0=0 if strpos(q5_others_text, "R.O.")
	replace oth_source0=0 if strpos(q5_others_text, "RO")
	replace oth_source0=0 if strpos(q5_others_text, "R.O")	
	replace oth_source0=0 if strpos(q5_others_text, "R/o")	
	replace oth_source0=0 if strpos(q5_others_text, "pitcher")
	replace oth_source0=0 if strpos(q5_others_text, "fridge")
	replace oth_source0=0 if strpos(q5_others_text, "town")
	replace oth_source0=0 if strpos(q5_others_text, "pop")
	replace oth_source0=0 if strpos(q5_others_text, "acp")
	replace oth_source0=0 if strpos(q5_others_text, "carbonated beverages")
	replace oth_source0=0 if strpos(q5_others_text, "Zero")
	replace oth_source0=0 if strpos(q5_others_text, "Xenia")
	replace oth_source0=0 if strpos(q5_others_text, "Well")
	replace oth_source0=0 if strpos(q5_others_text, "Urbandale")
	replace oth_source0=0 if strpos(q5_others_text, "Rural water")
	replace oth_source0=0 if strpos(q5_others_text, "Reverse osmosis")
	replace oth_source0=0 if strpos(q5_others_text, "Municipal")
	replace oth_source0=0 if strpos(q5_others_text, "Iowa water")
	replace oth_source0=0 if strpos(q5_others_text, "Regional Water")
	replace oth_source0=0 if strpos(q5_others_text, "Logansport")
	replace oth_source0=0 if strpos(q5_others_text, "ILRW")
	label var oth_source0 "Other Water Source"
	
*Any alternative source use
gen alt_source_use0=0 if !missing(bw_use0) 
	replace alt_source_use0=1 if q5_bottled=="Yes"|q5_cooler=="Yes"|oth_source0==1
	label var alt_source_use0 "Uses BW/Cooler/Other Drinking Water Source"
drop q5_bottled q5_cooler q5_others q5_other_txt q5_bottle r 

*Water Filter Use - Any
gen filter_any0=0 if !missing(q6_pitcher)|!missing(q6_ontap)|!missing(q6_infridge)|!missing(q6_wholehome)|!missing(q6_pitcher_howmuch)|!missing(q6_ontap_howmuch)|!missing(q6_infridge_howmuch)|!missing(q6_wholehome_howmuch)|!missing(q61_osmosis)|!missing(q61_carbon)|!missing(q61_softener)|!missing(q61_other)|!missing(q61_other_text)|!missing(q61_osmosis_date)|!missing(q61_carbon_date)|!missing(q61_softener_date)|!missing(q6_2_4_text_date)|!missing(well_drinking0)
	replace filter_any0=1 if q6_pitcher=="Yes"|q6_ontap=="Yes"|q6_infridge=="Yes"|q6_wholehome=="Yes"
	replace filter_any0=1 if !missing(q6_pitcher_howmuch)|!missing(q6_ontap_howmuch)|!missing(q6_infridge_howmuch)|!missing(q6_wholehome_howmuch)
	replace filter_any0=1 if q61_osmosis=="Yes"|q61_carbon=="Yes"|q61_softener=="Yes"|q61_other=="Yes"
	label var filter_any0 "Uses Pitcher, On Tap, In Fridge, or Whole Home Filter"
gen filter_none0=0 if !missing(filter_any0) 
	replace filter_none0=1 if q6_pitcher=="No" & q6_ontap=="No" & q6_infridge=="No" & q6_wholehome=="No" 
	label var filter_none0 "Don't Filter'"
	
*Filter Use Intensity
gen filter_all0=0 if !missing(filter_any0) 
	replace filter_all0=1 if q6_pitcher_howmuch=="All"|q6_ontap_howmuch=="All"|q6_infridge_howmuch=="All"|q6_wholehome_howmuch=="All"
	label var filter_all0 "Filters All Water"
gen filter_most0=0 if !missing(filter_any0) 
	replace filter_most0=1 if q6_pitcher_howmuch=="Most"|q6_ontap_howmuch=="Most"|q6_infridge_howmuch=="Most"|q6_wholehome_howmuch=="Most"
	label var filter_most0 "Filters Most Water"
gen filter_some0=0 if !missing(filter_any0) 
	replace filter_some0=1 if q6_pitcher_howmuch=="Some"|q6_ontap_howmuch=="Some"|q6_infridge_howmuch=="Some"|q6_wholehome_howmuch=="Some"
	replace filter_some0=1 if q6_pitcher_howmuch=="Very Little"|q6_ontap_howmuch=="Very Little"|q6_infridge_howmuch=="Very Little"|q6_wholehome_howmuch=="Very Little"
	label var filter_some0 "Filters Some Water"

*Filter Use Type
gen filter_pitch0=0 if !missing(filter_any0) 
	replace filter_pitch0=1 if q6_pitcher=="Yes"
	label var filter_pitch0 "Filter - Pitcher"
gen filter_tap0=0 if !missing(filter_any0) 
	replace filter_tap0=1 if q6_ontap=="Yes"
	label var filter_tap0 "Filter - Tap"
gen filter_fridge0=0 if !missing(filter_any0) 
	replace filter_fridge0=1 if q6_infridge=="Yes"
	label var filter_fridge0 "Filter - Fridge"
gen filter_whhome0=0 if !missing(filter_any0) 
	replace filter_whhome0=1 if q6_wholehome=="Yes"
	label var filter_whhome0 "Filter - Whole Home"
	
*Type of Whole Home Filtration Sytem - Reverse Osmosis
*NOTE - NEW QUESTION IN PERIOD 2
gen wholehome_type_ro0=0 if !missing(filter_any0) 
	replace wholehome_type_ro0=1 if q61_osmosis=="Yes"
	replace wholehome_type_ro0=1 if strpos(q5_others_text, "Osmosis")
	replace wholehome_type_ro0=1 if strpos(q5_others_text, "osmosis")
	replace wholehome_type_ro0=1 if strpos(q5_others_text, "RO")
	replace wholehome_type_ro0=1 if strpos(q5_others_text, "R/o")
	replace wholehome_type_ro0=1 if strpos(q5_others_text, "R.O")
	label var wholehome_type_ro0 "Whole Home - Reverse Osmosis System"

*Type of Whole Home Filtration Sytem - Activated Carbon
gen wholehome_type_carbon0=0 if !missing(filter_any0) 
	replace wholehome_type_carbon0=1 if q61_carbon=="Yes"
	label var wholehome_type_carbon0 "Whole Home - Activated Carbon System"

*Type of Whole Home Filtration Sytem - Water Softener
gen wholehome_type_softener0=0 if !missing(filter_any0) 
	replace wholehome_type_softener0=1 if q61_softener=="Yes"
	label var wholehome_type_softener0 "Whole Home - Water Softener System"
drop q6_pitcher q6_ontap q6_infridge q6_wholehome q6_pitcher_howmuch ///
     q6_ontap_howmuch q6_infridge_howmuch q6_wholehome_howmuch q5_others_text
drop q61_osmosis q61_carbon q61_softener q61_other q61_other_text ///
     q61_osmosis_date q61_carbon_date q61_softener_date q6_2_4_text_date

*Any Avoidance Behavior
gen avoidance_any0=0 if !missing(filter_any0)|!missing(bw_use0)
	replace avoidance_any0=1 if alt_source_use0==1|filter_any0==1
	label var avoidance_any0 "Any Avoidance Behavior"

*Known Nitrate Avoidance 
gen avoidance_nitrate0=0 if !missing(filter_any0)|!missing(bw_use0)
	replace avoidance_nitrate0=1 if bwc_use0==1|wholehome_type_ro0==1
	label var avoidance_nitrate0 "Known Nitrate Avoidance Behavior"
	
*Testing - Tested Primary Water Source
gen test_any0=0 if !missing(q7_tested)|!missing(q71_county)|!missing(q71_private)|!missing(q71_inhome)|!missing(q71_other)|!missing(q72_more)|!missing(q72_once)|!missing(q72_every)|!missing(q72_only)|!missing(q72_other)
	replace test_any0=1 if q7_tested=="Yes"
	replace test_any0=1 if q71_county=="Yes"|q71_private=="Yes"|q71_inhome=="Yes"|q71_other=="Yes"
	replace test_any0=1 if q72_more=="Yes"|q72_once=="Yes"|q72_every=="Yes"|q72_only=="Yes"
	label var test_any0 "Tested Primary Water Source"

*Testing - Didn't Test Primary Water Source 
gen test_none0=0 if !missing(test_any0)
	replace test_none0=1 if q7_tested=="No"
	label var test_none0 "Didn't Test Primary Water Source"
	
*Testing - Unsure if Tested Primary Water Source 
gen test_unsure0=0 if !missing(test_any0)
	replace test_unsure0=1 if q7_tested=="Don't Know'"
	label var test_unsure0 "Unsure if Tested Primary Water Source"

*Testing - Provided By Grants to County Program 
gen test_g2c0=0 if !missing(test_any0)
	replace test_g2c0=1 if q71_county=="Yes"
	label var test_g2c0 "Tested Provided By Grants 2 Counties"	
	
*Testing - Provided By Private Provider 
gen test_priv0=0 if !missing(test_any0)
	replace test_priv0=1 if q71_private=="Yes"
	label var test_priv0 "Tested Using Private Provider"	
	
*Testing - Provided By In-Home Kit 
gen test_inhome0=0 if !missing(test_any0)
	replace test_inhome0=1 if q71_inhome=="Yes"
	label var test_inhome0 "Tested Using In Home Kit"
	
*Testing - Provided By In-Home Kit 
gen test_other0=0 if !missing(test_any0)
	replace test_other0=1 if q71_other=="Yes"
	label var test_other0 "Tested Using Other Method"
		
*Testing - Tested in the Last Year
gen test_1year0=0 if !missing(test_any0)
	replace test_1year0=1 if q72_more=="Yes"|q72_once=="Yes" 
	label var test_1year0 "Last Water Test in Last Year"
	
*Testing - In Last 2 Years
gen test_2year0=0 if !missing(test_any0)
	replace test_2year0=1 if q72_more=="Yes"|q72_once=="Yes"|q72_every=="Yes"
	label var test_2year0 "Last Water Test in Last Two Years"	
drop q7_tested q71_county q71_private q71_inhome q71_other q72_more ///
     q72_once q72_every q72_only q72_other q72_text
*NOTE - NOT TAKING ADVANTAGE OF OTHER TESTING FREQUENCY AND TEXT

*Water Quality Rating - Great
gen rate_great0=0 if !missing(q8_rate)
	replace rate_great0=1 if q8_rate=="Great"
	label var rate_great0 "Rates Drinking Water Quality Great"	
 
*Water Quality Rating - Good
gen rate_good0=0 if !missing(rate_great0)
	replace rate_good0=1 if q8_rate=="Good"
	label var rate_good0 "Rates Drinking Water Quality Good"	

*Water Quality Rating - Neutral
gen rate_neut0=0 if !missing(rate_great0)
	replace rate_neut0=1 if q8_rate=="Neutral"
	label var rate_neut0 "Rates Drinking Water Quality Neutral"	
 	
*Water Quality Rating - Poor
gen rate_poor0=0 if !missing(rate_great0)
	replace rate_poor0=1 if q8_rate=="Poor"
	label var rate_poor0 "Rates Drinking Water Quality Poor"	

*Water Quality Rating - Unsure
gen rate_unsure0=0 if !missing(rate_great0)
	replace rate_unsure0=1 if q8_rate=="Unsure"
	label var rate_unsure0 "Unsure Drinking Water Quality"	
drop q8_rate

*Water Quality News - Heard of Any Concerns
gen news_concerns_any0=0 if !missing(q9_news_local)|!missing(q9_news_county)|!missing(q9_news_state)
	replace news_concerns_any0=1 if q9_news_local=="Yes"|q9_news_county=="Yes"|q9_news_state=="Yes"
	label var news_concerns_any0 "Heard of DW Quality in Local, County or State"	

*Water Quality News - No Concerns
gen news_concerns_none0=0 if !missing(news_concerns_any0)
	replace news_concerns_none0=1 if q9_news_local=="No" & q9_news_county=="No" & q9_news_state=="No"
	label var news_concerns_none0 "Has NOT Heard of DW Quality in Local, County or State"
	
*Water Quality News - Unsure
gen news_concerns_unsure0=0 if !missing(news_concerns_any0)
	replace news_concerns_unsure0=1 if q9_news_local=="Not Sure" & q9_news_county=="Not Sure" & q9_news_state=="Not Sure"
	label var news_concerns_unsure0 "Unsure of DW Quality in Local, County or State"	
	
*Water Quality News - Local Concerns
gen news_concerns_local0=0 if !missing(news_concerns_any0)
	replace news_concerns_local0=1 if q9_news_local=="Yes" 
	label var news_concerns_local0 "Heard of DW Quality in Local Area"	

*Water Quality News - County Concerns
gen news_concerns_cnty0=0 if !missing(news_concerns_any0)
	replace news_concerns_cnty0=1 if q9_news_county=="Yes" 
	label var news_concerns_cnty0 "Heard of DW Quality in County"	

*Water Quality News - State Concerns
gen news_concerns_state0=0 if !missing(news_concerns_any0)
	replace news_concerns_state0=1 if q9_news_state=="Yes" 
	label var news_concerns_state0 "Heard of DW Quality in State"		
drop q9_news_local q9_news_county q9_news_state
	
*Nitrates in DW Concern - Any
gen nit_concern_any0=0 if !missing(q10_nitrate_local)|!missing(q10_nitrate_county)|!missing(q10_nitrate_state)
	replace nit_concern_any0=1 if q10_nitrate_local=="Yes"|q10_nitrate_county=="Yes"|q10_nitrate_state=="Yes"
	label var nit_concern_any0 "Believes Nitrate Problems in Local, County or State"	

*Nitrates in DW Concern - None
gen nit_concern_none0=0 if !missing(nit_concern_any0)
	replace nit_concern_none0=1 if q10_nitrate_local=="No" & q10_nitrate_county=="No" & q10_nitrate_state=="No"
	label var nit_concern_none0 "Believes No Nitrate Problems"	
	
*Nitrates in DW Concern - Unsure
gen nit_concern_unsure0=0 if !missing(nit_concern_any0)
	replace nit_concern_unsure0=1 if q10_nitrate_local=="Not Sure" & q10_nitrate_county=="Not Sure" & q10_nitrate_state=="Not Sure"
label var nit_concern_unsure0 "Unsure of Any Nitrate Problems"	

*Nitrates in DW Concern - Local
gen nit_concern_local0=0 if !missing(nit_concern_any0)
	replace nit_concern_local0=1 if q10_nitrate_local=="Yes"
	label var nit_concern_local0 "Believes Nitrate Problems in Local Area"	

*Nitrates in DW Concern - County
gen nit_concern_cnty0=0 if !missing(nit_concern_any0)
	replace nit_concern_cnty0=1 if q10_nitrate_county=="Yes"
	label var nit_concern_cnty0 "Believes Nitrate Problems in County"			
	
*Nitrates in DW Concern - State
gen nit_concern_state0=0  if !missing(nit_concern_any0)
	replace nit_concern_state0=1 if q10_nitrate_state=="Yes"
	label var nit_concern_state0 "Believes Nitrate Problems in State"	
drop q10_nitrate_local q10_nitrate_county q10_nitrate_state	

*Infants in Home
replace q11_infants="5" if strpos(q11_infants, ">5")
destring q11_infants, replace
gen infants_ind=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace infants_ind=1 if !missing(q11_infants) & q11_infants>0
	label var infants "Any Infants in Home (Indicator)"	
gen infants=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace infants=q11_infants if !missing(q11_infants) 

*Children in Home
replace q11_children="5" if strpos(q11_children, ">5")
destring q11_children, replace
gen children_ind=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace children_ind=1 if !missing(q11_children) & q11_children>0
	label var children "Any Children in Home (Indicator)"	
gen children=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace children=q11_children if !missing(q11_children) 

*Adults in Home
replace q11_adults="5" if strpos(q11_adults, ">5")
destring q11_adults, replace
replace q11_retired="5" if strpos(q11_retired, ">5")
destring q11_retired, replace
gen adults_ind=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace adults_ind=1 if !missing(q11_adults) & q11_adults>0
	label var adults_ind "Any Adults In Home (Indicator)"	
replace q11_adults=0 if missing(q11_adults)
replace q11_retired=0 if missing(q11_retired)	
gen adults=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace adults=q11_adults if !missing(adults_ind)
	replace adults=. if missing(adults_ind)

*Retirement Eligible Adults in Home
gen retiree_ind=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace retiree_ind=1 if !missing(q11_retired) & q11_retired>0 
	label var retiree_ind "Any Retirement Eligible in Home (Indicator)"	
gen retiree=0 if !missing(q11_infants)|!missing(q11_children)|!missing(q11_adults)|!missing(q11_retired)
	replace retiree=q11_retired if !missing(retiree_ind)
gen chil_inf=children+infants
gen hh_size=infants+children+adults+retiree  

*Education - Masters or Higher
gen educ_mast=0 if !missing(q11_education)
	replace educ_mast=1 if q11_education=="Master's degree or higher"
	label var educ_mast "Education - Master's Degree or Higher"	

*Education - Bachelors 
gen educ_bach=0 if !missing(q11_education)
	replace educ_bach=1 if q11_education=="Bachelor's degree"|q11_education=="Associate's degree"
	label var educ_bach "Education - Bachelor's Degree"	
gen educ_bach_high=educ_mast+educ_bach
	label var educ_bach "Education - Bachelor's or Higher"	

*Education - High School or Less
gen educ_hs=0 if !missing(q11_education)
	replace educ_hs=1 if q11_education=="HS diploma or equivalent"|q11_education=="Some college no degree"|q11_education=="No formal education credential"
	label var educ_hs "Education - High School Degree or Less"		
	
*Income - Greater than $200,000
gen income_200=0 if !missing(q11_income)
	replace income_200=1 if q11_income==">$200,000"
	label var income_200 "Income - >$200,000"
	
*Income - $100,000-$200,000
gen income_100200=0 if !missing(q11_income)
	replace income_100200=1 if q11_income=="$100,000 - $200,000"
	label var income_100200 "Income - $100,000- $200,000"
	
*Income - $50,000- $100,000
gen income_50100=0 if !missing(q11_income)
	replace income_50100=1 if q11_income=="$50,000 - $100,000"
	label var income_50100 "Income - $50,000- $100,0000"			

*Income - $25,000- $50,000
gen income_2550=0 if !missing(q11_income)
	replace income_2550=1 if q11_income=="$25,000 - $50,000"
	label var income_2550 "Income - $25,000 -$50,000"		
	
*Income - Less Than $25,000 
gen income_25=0 if !missing(q11_income)
	replace income_25=1 if q11_income=="<$25,000"
	label var income_25 "Income - <$25,000"		
drop q11_infants q11_children q11_adults q11_retired q11_education q11_income comments
save $data_clean\survey2, replace


*****
*WTP Survey 4: Round 2, Period 2
import excel "$data_surv\WTP4.xlsx", sheet("WTP4") firstrow case(lower) clear
drop county_folllowup id_wtp4

*ID Number
gen id_number=substr(id,3,5)

*Survey Round
gen round=2
	label var round "Survey Round"

*Well Uses - Drinking Water
gen well_drinking=0 if !missing(q1_drinkingwater)|!missing(q1_cooking)|!missing(q1_laundry)|!missing(q1_landscaping)|!missing(q1_showering)
	replace well_drinking=1 if q1_drinkingwater=="All" 
	replace well_drinking=1 if q1_drinkingwater=="Most"
	replace well_drinking=1 if q1_drinkingwater=="Some"	
	label var well_drinking "Uses Well for Drinking Water"
gen well_drinking_all=0 if !missing(well_drinking)
	replace well_drinking_all=1 if q1_drinkingwater=="All" 
	label var well_drinking_all "Uses Well for Drinking Water All of Time"
gen well_drinking_most=0 if !missing(well_drinking)
	replace well_drinking_most=1 if q1_drinkingwater=="Most"
	label var well_drinking_most "Uses Well for Drinking Water Most of Time"	
gen well_drinking_some=0 if !missing(well_drinking)
	replace well_drinking_some=1 if q1_drinkingwater=="Some"
	label var well_drinking_some "Uses Well for Drinking Water Some of Time"
gen well_drinking_none=0 if !missing(well_drinking)
	replace well_drinking_none=1 if q1_drinkingwater=="None"
	label var well_drinking_none "Doesn't Use Well for Drinking Water"
	
*Well Uses - Cooking
gen well_cook=0 if !missing(well_drinking)
	replace well_cook=1 if q1_cooking=="All" 
	replace well_cook=1 if q1_cooking=="Most"
	replace well_cook=1 if q1_cooking=="Some"
	label var well_cook "Uses Well for Cooking"
gen well_cook_all=0 if !missing(well_drinking)
	replace well_cook_all=1 if q1_cooking=="All" 
	label var well_cook_all "Uses Well for Cooking All of Time"
gen well_cook_most=0 if !missing(well_drinking)
	replace well_cook_most=1 if q1_cooking=="Most"
	label var well_cook_most "Uses Well for Cooking Most of Time"	
gen well_cook_some=0 if !missing(well_drinking)
	replace well_cook_some=1 if q1_cooking=="Some"
	label var well_cook_some "Uses Well for Cooking Some of Time"
gen well_cook_none=0 if !missing(well_drinking)
	replace well_cook_none=1 if q1_cooking=="None"
	label var well_cook_none "Doesn't Use Well for Cooking"
drop q1_drinkingwater q1_cooking q1_laundry q1_landscaping q1_showering
*NOTE - DROPPING WELL USES FOR SHOWERING/LAUNDRY/LANDSCAPING

*Other Sources Water - Bottled Water
gen bw_use=0 if !missing(q2_bottled)|!missing(q2_cooler)|!missing(q2_bottled_gallon)|!missing(q2_cooler_gallon)|!missing(well_drinking)
	replace bw_use=1 if q2_bottled=="Yes"
	label var bw_use "Uses Bottled Water"
gen bw_none=0 if !missing(bw_use)
	replace bw_none=1 if q2_bottled=="No"
	label var bw_none "Doesn't Use Bottled Water"

*Other Sources Water - Water Cooler
gen cooler_use=0 if !missing(bw_use)
	replace cooler_use=1 if q2_cooler=="Yes"
	label var cooler_use "Uses Water Cooler"
gen cooler_none=0 if !missing(bw_use)
	replace cooler_none=1 if q2_cooler=="No"
	label var cooler_none "Doesn't Use Water Cooler"
	
*Other Sources Water - Bottled Water or Cooler
gen bwc_use=0 if !missing(bw_use)
	replace bwc_use=1 if q2_cooler=="Yes"|q2_bottled=="Yes"
	label var bwc_use "Uses Bottled Water or Cooler"

*Other Sources Water - Bottled Water or Cooler
gen oth_source=0 if !missing(bw_use) 
	replace oth_source=1 if q2_others4=="Yes" 
	replace oth_source=0 if strpos(q2_others_text4, "Filter")
	replace oth_source=0 if strpos(q2_others_text4, "filter")
	replace oth_source=0 if strpos(q2_others_text4, "City")
	replace oth_source=0 if strpos(q2_others_text4, "Brita")
	replace oth_source=0 if strpos(q2_others_text4, "Coffee")
	replace oth_source=0 if strpos(q2_others_text4, "Municipal")
	replace oth_source=0 if strpos(q2_others_text4, "Filtration")
	replace oth_source=0 if strpos(q2_others_text4, "coffee")
	replace oth_source=0 if strpos(q2_others_text4, "ILRW")
	replace oth_source=0 if strpos(q2_others_text4, "Rural Water")
	replace oth_source=0 if strpos(q2_others_text4, "Regional Water")
	replace oth_source=0 if strpos(q2_others_text4, "well")
	replace oth_source=0 if strpos(q2_others_text4, "Pet")
	replace oth_source=0 if strpos(q2_others_text4, "R.O")
	replace oth_source=0 if strpos(q2_others_text4, "RO")
	replace oth_source=0 if strpos(q2_others_text4, "Osmosis")
	replace oth_source=0 if strpos(q2_others_text4, "WCIRWA")
	replace oth_source=0 if strpos(q2_others_text4, "Xenia")
	replace oth_source=0 if strpos(q2_others_text4, "WCRWA")
	replace oth_source=0 if strpos(q2_others_text4, "Waukee")
	replace oth_source=0 if strpos(q2_others_text4, "xenia")
	replace oth_source=0 if strpos(q2_others_text4, "traveling")
	replace oth_source=0 if strpos(q2_others_text4, "Town")
	replace oth_source=0 if strpos(q2_others_text4, "town")
	replace oth_source=0 if strpos(q2_others_text4, "rural water")
	label var oth_source "Other Water Source"
	 
*Any alternative source use
gen alt_source_use=0 if !missing(bw_use)
	replace alt_source_use=1 if q2_bottled=="Yes"|q2_cooler=="Yes"|oth_source==1
	label var alt_source_use "Uses BW/Cooler/Other Drinking Water Source"	
drop q2_bottled q2_cooler q2_others4 q2_bottled_gallon q2_cooler_gallon q2_other_gallon
*NOTE - DROPPING INFORMATION ON OTHER WATER SOURCES AND HOW MUCH PER WEEK FOR EACH

*Water Filter Use - Any
gen filter_any=0 if !missing(q3_pitcher)|!missing(q3_ontap)|!missing(q3_infridge)|!missing(q3_wholehome)|!missing(q3_pitcher_howmuch)|!missing(q3_ontap_howmuch)|!missing(q3_infridge_howmuch)|!missing(q3_wholehome_howmuch)|!missing(q31_osmosis)|!missing(q31_carbon)|!missing(q31_softener)|!missing(q31_other)|!missing(q31_other_text)|!missing(q31_osmosis_date)|!missing(q31_carbon_date)|!missing(q31_other_date)|!missing(q31_softener_date)|!missing(q31_other_text_date)|!missing(well_drinking)
 	replace filter_any=1 if q3_pitcher=="Yes"|q3_ontap=="Yes"|q3_infridge=="Yes"|q3_wholehome=="Yes"
	replace filter_any=1 if !missing(q3_pitcher_howmuch)|!missing(q3_ontap_howmuch)|!missing(q3_infridge_howmuch)|!missing(q3_wholehome_howmuch)
	replace filter_any=1 if q31_osmosis=="Yes"|q31_carbon=="Yes"|q31_softener=="Yes"|q31_other=="Yes"
	label var filter_any "Uses Pitcher, On Tap, In Fridge, or Whole Home Filter"
	
*Water Filter Use - None
gen filter_none=0 if !missing(filter_any)
	replace filter_none=1 if q3_pitcher=="No" & q3_ontap=="No" & q3_infridge=="No" & q3_wholehome=="No"
	label var filter_none "No Filter Use"

*Filter Use Intensity
gen filter_all=0 if !missing(filter_any) 
	replace filter_all=1 if q3_pitcher_howmuch=="All"|q3_ontap_howmuch=="All"|q3_infridge_howmuch=="All"|q3_wholehome_howmuch=="All"
	label var filter_all "Filters All Water"
gen filter_most=0 if !missing(filter_any) 
	replace filter_most=1 if q3_pitcher_howmuch=="Most"|q3_ontap_howmuch=="Most"|q3_infridge_howmuch=="Most"|q3_wholehome_howmuch=="Most"
	label var filter_most "Filters Most Water"
gen filter_some=0 if !missing(filter_any) 
	replace filter_some=1 if q3_pitcher_howmuch=="Some"|q3_ontap_howmuch=="Some"|q3_infridge_howmuch=="Some"|q3_wholehome_howmuch=="Some"
	replace filter_some=1 if q3_pitcher_howmuch=="Very Little"|q3_ontap_howmuch=="Very Little"|q3_infridge_howmuch=="Very Little"|q3_wholehome_howmuch=="Very Little"
	label var filter_some "Filters Some Water"

*Filter Use Type
gen filter_pitch=0 if !missing(filter_any) 
	replace filter_pitch=1 if q3_pitcher=="Yes"
	label var filter_pitch "Filter - Pitcher"
gen filter_tap=0 if !missing(filter_any) 
	replace filter_tap=1 if q3_ontap=="Yes"
	label var filter_tap "Filter - Tap"
gen filter_fridge=0 if !missing(filter_any) 
	replace filter_fridge=1 if q3_infridge=="Yes"
	label var filter_fridge "Filter - Fridge"
gen filter_whhome=0 if !missing(filter_any) 
	replace filter_whhome=1 if q3_wholehome=="Yes"
	label var filter_whhome "Filter - Whole Home"

*Type of Whole Home Filtration Sytem - Reverse Osmosis
gen wholehome_type_ro=0 if !missing(filter_any)
	replace wholehome_type_ro=1 if q31_osmosis=="Yes"
	replace wholehome_type_ro=1 if strpos(q2_others_text4, "Osmosis")
	replace wholehome_type_ro=1 if strpos(q2_others_text4, "osmosis")
	replace wholehome_type_ro=1 if strpos(q2_others_text4, "RO")
	replace wholehome_type_ro=1 if strpos(q2_others_text4, "R/o")
	replace wholehome_type_ro=1 if strpos(q2_others_text4, "R.O")
	label var wholehome_type_ro "Whole Home - Reverse Osmosis System"

*Type of Whole Home Filtration Sytem - Activated Carbon
gen wholehome_type_carbon=0 if !missing(filter_any)
	replace wholehome_type_carbon=1 if q31_carbon=="Yes"
	label var wholehome_type_carbon "Whole Home - Activated Carbon System"

*Type of Whole Home Filtration Sytem - Water Softener
gen wholehome_type_softener=0 if !missing(filter_any)
	replace wholehome_type_softener=1 if q31_softener=="Yes"
	label var wholehome_type_softener "Whole Home - Water Softener System"	
	
*Any Avoidance Behavior
gen avoidance_any=0 if !missing(filter_any)|!missing(bw_use)
	replace avoidance_any=1 if alt_source_use==1|filter_any==1
	label var avoidance_any "Any Avoidance Behavior"

*Known Nitrate Avoidance 
gen avoidance_nitrate=0 if !missing(filter_any)|!missing(bw_use)
	replace avoidance_nitrate=1 if bwc_use==1|wholehome_type_ro==1
	label var avoidance_nitrate "Known Nitrate Avoidance Behavior"

drop q3_pitcher q3_ontap q3_infridge q3_wholehome q3_pitcher_howmuch ///
     q3_ontap_howmuch q3_infridge_howmuch q3_wholehome_howmuch
drop q31_osmosis q31_carbon q31_softener q31_other q31_other_text ///
     q31_osmosis_date q31_carbon_date q31_softener_date q31_other_date ///
	 q31_other_text_date
*NOTE - NOT TAKING ADVANTAGE OF INSTALLATION DATE DATA FOR WHOLE HOME FILTER SYSTEMS

*Testing - Tested Primary Water Source
gen test_any=0 if !missing(q4_tested)|!missing(q41_grants)|!missing(q41_private)|!missing(q4_1_private_text)|!missing(q41_inhomekit)|!missing(q41_other)|!missing(q41_other_text)|!missing(q42_nitrate)|!missing(q42_metals)|!missing(q42_bacteria)|!missing(q42_pesticide)|!missing(q42_hardness)|!missing(q42_other)|!missing(q42_other_text)
	replace test_any=1 if q4_tested=="Yes"
	replace test_any=1 if q41_grants=="Yes"|q41_private=="Yes"|q41_inhomekit=="Yes"|q41_other=="Yes"
	replace test_any=1 if q42_nitrate=="Yes"|q42_metals=="Yes"|q42_bacteria=="Yes"|q42_pesticide=="Yes"|q42_hardness=="Yes"|q42_other=="Yes"
	replace test_any=1 if !missing(q4_1_private_text)|!missing(q41_other_text)|!missing(q42_other_text)
	label var test_any "Tested Primary Water Source"

*Testing - Tested in the Last Year
gen test_1year=test_any
	label var test_1year "Last Water Test in Last Year"
	
*Testing - Provided By Grants to County Program 
gen test_g2c=0 if !missing(test_any)
	replace test_g2c=1 if q41_grants=="Yes"
	label var test_g2c "Tested Provided By Grants 2 Counties"	
	
*Testing - Provided By Private Provider 
gen test_priv=0 if !missing(test_any)
	replace test_priv=1 if q41_private=="Yes"
	label var test_priv "Tested Using Private Provider"	
	
*Testing - Provided By In-Home Kit 
gen test_inhome=0 if !missing(test_any)
	replace test_inhome=1 if q41_inhomekit=="Yes"
	label var test_inhome "Tested Using In Home Kit"
	
*Testing - Tested Primary Water Source for Nitrate
gen test_nit=0 if !missing(test_any)
	replace test_nit=1 if q42_nitrate=="Yes"
	label var test_nit "Tested Primary Water Source for Nitrate"

*Testing - Tested Primary Water Source for Bacteria
gen test_bact=0 if !missing(test_any)
	replace test_bact=1 if q42_bacteria=="Yes"
	label var test_bact "Tested Primary Water Source for Bacteria"
	
*Testing - Tested Primary Water Source for Pesticide
gen test_pest=0 if !missing(test_any)
	replace test_pest=1 if q42_pesticide=="Yes"
	label var test_pest "Tested Primary Water Source for Pesticide"
	
*Testing - Tested Primary Water Source for Metals
gen test_metals=0 if !missing(test_any)
	replace test_metals=1 if q42_metals=="Yes"
	label var test_metals "Tested Primary Water Source for Metals"
	
*Testing - Tested Primary Water Source for Hardness
gen test_hardness=0 if !missing(test_any)
	replace test_hardness=1 if q42_hardness=="Yes"
	label var test_hardness "Tested Primary Water Source for Hardness"
	
*Testing - Tested Primary Water Source for Other
gen test_other=0 if !missing(test_any)
	replace test_other=1 if q42_other=="Yes"
	label var test_other "Tested Primary Water Source for Other"
	
*NOTE - NOT TAKING ADVANTAGE OF OTHER CONTAMINANT TESTING 
drop q4_tested q41_grants q41_private q4_1_private_text q41_inhomekit ///
     q41_other q41_other_text q42_nitrate q42_metals q42_bacteria ///
	 q42_pesticide q42_hardness q42_other q42_other_text	
	
*Water Quality Rating - Great
gen rate_great=0 if !missing(q5_rate)
	replace rate_great=1 if q5_rate=="Great"
	label var rate_great "Rates Drinking Water Quality Great"	
 
*Water Quality Rating - Good
gen rate_good=0 if !missing(q5_rate)
	replace rate_good=1 if q5_rate=="Good"
	label var rate_good "Rates Drinking Water Quality Good"	

*Water Quality Rating - Neutral
gen rate_neut=0 if !missing(q5_rate)
	replace rate_neut=1 if q5_rate=="Neutral"
	label var rate_neut "Rates Drinking Water Quality Neutral"	
 	
*Water Quality Rating - Poor
gen rate_poor=0 if !missing(q5_rate)
	replace rate_poor=1 if q5_rate=="Poor"
	label var rate_poor "Rates Drinking Water Quality Poor"	

*Water Quality Rating - Unsure
gen rate_unsure=0 if !missing(q5_rate)
	replace rate_unsure=1 if q5_rate=="Unsure"
	label var rate_unsure "Unsure Drinking Water Quality"	
drop q5_rate q6_nitrate q6_metals q6_bacteria q6_pesticide q6_hardness ///
     q6_taste q6_other q6_other_text
*NOTE - NOT TAKING ADVANTAGE OF QUESTION ON HOW CONCERNED THEY ARE ABOUT NITRATES VERSUS
*  METALS/BACTERIA/PESTICIDES/HARDNESS/TASTE/OTHER

*Water Quality News - Heard of Any Concerns
gen news_concerns_any=0 if !missing(q7_news_local)|!missing(q7_news_county)|!missing(q7_news_state)
	replace news_concerns_any=1 if q7_news_local=="Yes"|q7_news_county=="Yes"|q7_news_state=="Yes"
	label var news_concerns_any "Heard of DW Quality in Local, County or State"	

*Water Quality News - No Concerns
gen news_concerns_none=0 if !missing(news_concerns_any)
	replace news_concerns_none=1 if q7_news_local=="No" & q7_news_county=="No" & q7_news_state=="No"
	label var news_concerns_none "Has NOT Heard of DW Quality in Local, County or State"	
	
*Water Quality News - Unsure
gen news_concerns_unsure=0 if !missing(news_concerns_any)
	replace news_concerns_unsure=1 if q7_news_local=="Not Sure" & q7_news_county=="Not Sure" & q7_news_state=="Not Sure"
	label var news_concerns_unsure "Unsure of DW Quality in Local, County or State"	
	
*Water Quality News - Local Concerns
gen news_concerns_local=0 if !missing(news_concerns_any)
	replace news_concerns_local=1 if q7_news_local=="Yes" 
	label var news_concerns_local "Heard of DW Quality in Local Area"	

*Water Quality News - County Concerns
gen news_concerns_cnty=0 if !missing(news_concerns_any)
	replace news_concerns_cnty=1 if q7_news_county=="Yes" 
	label var news_concerns_cnty "Heard of DW Quality in County"	

*Water Quality News - State Concerns
gen news_concerns_state=0 if !missing(news_concerns_any)
	replace news_concerns_state=1 if q7_news_state=="Yes" 
	label var news_concerns_state "Heard of DW Quality in State"	
drop q7_news_local q7_news_county q7_news_state
	
*Nitrates in DW Concern - Any
gen nit_concern_any=0 if !missing(q8_nitrate_local)|!missing(q8_nitrate_county)|!missing( q8_nitrate_state)
	replace nit_concern_any=1 if q8_nitrate_local=="Yes"|q8_nitrate_county=="Yes"|q8_nitrate_state=="Yes"
	label var nit_concern_any "Believes Nitrate Problems in Local, County or State"	

*Nitrates in DW Concern - None
gen nit_concern_none=0 if !missing(nit_concern_any)
	replace nit_concern_none=1 if q8_nitrate_local=="No" & q8_nitrate_county=="No" & q8_nitrate_state=="No"
	label var nit_concern_none "Believes No Nitrate Problems"
	
*Nitrates in DW Concern - Unsure
gen nit_concern_unsure=0 if !missing(nit_concern_any)
	replace nit_concern_unsure=1 if q8_nitrate_local=="Not Sure" & q8_nitrate_county=="Not Sure" & q8_nitrate_state=="Not Sure"
	label var nit_concern_unsure "Unsure of Any Nitrate Problems"

*Nitrates in DW Concern - Local
gen nit_concern_local=0 if !missing(nit_concern_any)
	replace nit_concern_local=1 if q8_nitrate_local=="Yes"
	label var nit_concern_local "Believes Nitrate Problems in Local Area"	

*Nitrates in DW Concern - County
gen nit_concern_cnty=0 if !missing(nit_concern_any)
	replace nit_concern_cnty=1 if q8_nitrate_county=="Yes"
	label var nit_concern_cnty "Believes Nitrate Problems in County"			
	
*Nitrates in DW Concern - State
gen nit_concern_state=0 if !missing(nit_concern_any)
	replace nit_concern_state=1 if q8_nitrate_state=="Yes"
	label var nit_concern_state "Believes Nitrate Problems in State"	
drop q8_nitrate_local q8_nitrate_county q8_nitrate_state
	
*NOTE - NOT TAKING ADVANTAGE OF QUESTION ON WHO THEY TALK TO ABOUT WATER QUALITY ISSUES
drop q9_family q9_private q9_govt q9_extension q9_other q9_other_txt comments4

merge 1:1 id_number using $data_clean\survey2
drop if _merge==1 //2 second-round responses that don't match with any in 1st round
rename _merge survey_response_type
label var survey_response_type "2 First Only, 3 Both"
drop if private_well==0 //Drop houses that don't rely on private well for primary drinking water source
drop private_well  
destring id_number, replace
save $data_clean\survey2, replace

*Merging zip code data
import excel "$data_surv\WTP3 (6396)TestKit_zip(8counties).xlsx", sheet("WTP3 (6396)TestKit_zip(8countie") firstrow case(lower) clear
rename numbersinuniquei id_number
keep id_number zip
drop if missing(id_number)
duplicates drop
merge 1:1 id_number using $data_clean\survey2 //Don't have zip for 1 household
drop if _merge==1
drop _merge
save $data_clean\survey2, replace
replace id_number=id_number+1e6 //ensure unique id's across surveys
append using  $data_clean\survey1

*Treatment Variable
gen treat=0
	replace treat=1 if test_kit==1  
	
*Sample - HHs that answered all outcomes of interest
gen sample_main=0
	replace sample_main=1 if !missing(test_1year) & !missing(test_g2c) & !missing(well_drinking) & !missing(well_cook) & !missing(bw_use) & !missing(cooler_use) & !missing(filter_any) & !missing(rate_good) & !missing(nit_concern_any)

*Sample - HHs that answered all outcomes of interest + demographics
gen sample_main_demo=0
	replace sample_main_demo=1 if !missing(test_1year) & !missing(test_g2c) & !missing(well_drinking) & !missing(well_cook) & !missing(bw_use) & !missing(cooler_use) & !missing(filter_any) & !missing(rate_good) & !missing(nit_concern_any) & !missing(infants) & !missing(educ_mast) & !missing(income_200)		
	
*Sample - HHs that answered demographics
gen sample_demo=1
	///replace sample_demo=0 if missing(infants)|missing(educ_mast)|missing(income_200)
			replace sample_demo=0 if missing(infants) & missing(educ_mast) & missing(income_200)
	
save $data_clean\survey_clean_$outputdate, replace


*************
*Cleaning some id entries

gen id_nam = substr(id, 1, 2) 
	replace id_nam="Cl" if id_nam=="C1"
	replace id_nam="Cl" if id_nam=="CI"
	replace id_nam="Ce" if id_nam=="CE"
	replace id_nam="Ce" if id_nam=="ce"
	replace id_nam="Fa" if id_nam=="FA"
	replace id_nam="Jo" if id_nam=="J0"
	replace id_nam="Jo" if id_nam=="jo"
gen id_num = substr(id, 3, .) 
	replace id_num = "0" + id_num if length(id_num)<4
drop id
gen id=id_nam+id_num
order id


*************
*County FIPs
gen stfips=19
rename county cty
gen county = upper(cty)
drop cty
countyfips, name(county) statefips(stfips)
drop if _merge==2
drop _merge
save $data_clean\survey_clean_$outputdate, replace

*************
*Keeping id and treatment status for geospatial stats
keep id treat
save $data_clean/id_treat, replace

********************************
* 2) CLEAN CENSUS DATA
 
**************
*IPUMS Data
import delimited "$data_ipums\nhgis0034_ds248_2020_county.csv", clear
keep if statea==19 
keep if countya==17|countya==23|countya==31|countya==71|countya==105|countya==129|countya==15|countya==43|countya==47|countya==49|countya==63|countya==65|countya==93|countya==147
gen occ_housing=u7g002
keep year state statea county countya occ_housing
save $data_clean\ipums, replace

import delimited "$data_ipums\nhgis0034_ds249_20205_county.csv", clear
keep if statea==19 
keep if countya==17|countya==23|countya==31|countya==71|countya==105|countya==129|countya==15|countya==43|countya==47|countya==49|countya==63|countya==65|countya==93|countya==147
egen educ_hs=rowtotal(amrze002-amrze020)
	replace educ_hs=educ_hs/amrze001
egen educ_bach=rowtotal(amrze021-amrze022)
	replace educ_bach=educ_bach/amrze001
egen educ_mast=rowtotal(amrze023-amrze025)
	replace educ_mast=educ_bach/amrze001
egen educ_bamast=rowtotal(amrze021-amrze025)
	replace educ_bamast=educ_bamast/amrze001
egen inc_25=rowtotal(amr7e002-amr7e005)
	replace inc_25=inc_25/amr7e001
egen inc_2550=rowtotal(amr7e006-amr7e010)
	replace inc_2550=inc_2550/amr7e001
egen inc_50100=rowtotal(amr7e011-amr7e013)
	replace inc_50100=inc_50100/amr7e001	
egen inc_100200=rowtotal(amr7e014-amr7e016)
	replace inc_100200=inc_100200/amr7e001		
gen inc_200=amr7e017
	replace inc_200=inc_200/amr7e001		
keep state statea county countya educ_* inc_*
merge 1:1 statea countya using $data_clean\ipums
drop _merge
save $data_clean\ipums, replace

import delimited "$data_ipums\nhgis0036_ds249_20205_county.csv", clear
keep if statea==19 
keep if countya==17|countya==23|countya==31|countya==71|countya==105|countya==129|countya==15|countya==43|countya==47|countya==49|countya==63|countya==65|countya==93|countya==147
gen hh_size=amuue001
keep state statea county countya hh_size
merge 1:1 statea countya using $data_clean\ipums
drop _merge
save $data_clean\ipums, replace



********************************
* 3) CLEAN DNR PWTS DATA
//import delimited "$data_dnr\PWTSallnitrate_20220511.csv", clear 
import delimited "$data_clean\test_data_clean.csv", clear varnames(1) 
destring nitrateasn, replace force
rename nitrateasn nit
drop if missing(nit)

drop geom lon
rename v22 lon

*Sample date
drop year
drop month
gen year=substr(smpl_dte,-4,4)
gen month=substr(smpl_dte,1,2)
replace month = subinstr(month, "/", "", .)
gen day=substr(smpl_dte, -7,2 )
replace day = subinstr(day, "/", "", .)
destring day, replace
destring month, replace
destring year, replace
gen date = mdy(month, day, year)
format date %td

*Entry date
gen year_ent=substr(dtentry,1,4)
gen month_ent=substr(dtentry,6,2)
gen day_ent=substr(dtentry,9,2)
destring year_ent, replace
destring month_ent, replace
destring day_ent, replace
gen date_ent= mdy(month_ent, day_ent, year_ent)
format date_ent %td
gen week=week(date)
gen yw=yw(year,week)
gen ym=ym(year,month)
gen quarter=quarter(date)
gen yq=yq(year,quarter)
format yq %tq


*Dropping weird gaps between sample and entry date (Check with erik day about these eventually)
gen gap_entry=date_ent-date
drop if gap_entry<-30
drop if gap_entry>365
drop if year<2002
drop if ym>747
save $data_clean\dnr_tests_clean, replace


frame change main
frame drop clean