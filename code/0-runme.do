**************************************************************
*Improving Private Well Testing Programs: Experimental Evidence from Iowa
* Code by: Gabriel Lade (glade@macalester.edu)
* Last Updated: 5/20/2024
**************************************************************
clear all
set maxvar 20000
set more off
capture log close

*SELECT OUTPUT DATE
global outputdate = "20240520"		 

*SELECT USER
cd ""

*FOLDER DESIGNATIONS
global code "code/"
global output "output/"
global data_clean "dataClean/"
global data_temp "dataClean/temp"
global data_surv "dataRAW/survey-master/"
global data_add "dataRAW/survey-master/addresses"
global data_dnr "dataRAW/dnr-tests/"
global data_maps "dataRAW/maps/"
global data_ipums "dataRAW/ipums/"
 
 
*************************************
*I. SURVEY DATA CLEAN
*************************************
frame rename default main
do $code/1a-data-clean-survey
do $code/1b-data-clean-geospatial


*****************************************************************
*II. SUMMARY STATISTICS
*****************************************************************
use $data_clean/survey_clean.dta, clear
global RSCRIPT_PATH ""
capture noisily rscript using $code/2a-fig1a.R
do $code/2b-fig1b
do $code/3-tables_1_2


*****************************************************************
*III. RESULTS
*****************************************************************
do $code/4-table3
do $code/5-fig2
do $code/6-table4
do $code/7-si-app
