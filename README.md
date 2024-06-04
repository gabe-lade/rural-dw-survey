# Replication code for "Improving Private Well Testing Programs: Experimental Evidence from Iowa."
### Gabriel E. Lade , Jacqueline Comito, Jamie Benning, Catherine Kling, and David Keiser
### Contact: glade@macalester.edu

<i>  We are unable to share data from our survey per our IRB protocol. Interested researchers may contact the authors if they wish to explore alternative impacts of the treatment. </i>

<i> DNR PWTS are available by contacting the [Iowa Department of of Health and Human Services](https://hhs.iowa.gov/public-health/environmental-health/grants-counties-water-well-program). We provide a clean file to reproduce Figure 1 under "dataClean/dnr_tests_clean.dta". </i>

**Software Requirements:**
1. Stata 18
2. R 4.3.2

**Description of programs:**
1.	“0-runme” is the main script that sets the directory and calls all subsequent code.
2.	"1a-data-clean-survey" imports and cleans survey data. Most data are confidential and not provided here.
3.	"1b-data-clean-geospatial" matches PWTS and survey data and computes distance measures between households and nearby tests. Note that the survey and Iowa PWTS addresses were pre-processed using the API from Smarty.com and described in the supplementary material.
4.	"2a-fig1a" uses PWTS data to create Figure 1a.
5.	"2b-fig1b" uses PWTS data to create Figure 2a.
6.	"3-tables_1_2" uses survey data to createa summary tables 1 and 2.
7.	"4-table3" uses survey data to estimate the impact of treatment on testing and produces table 3.
8.	"5-fig2" uses survey data to estimate LATE impact of treatment on household behaviors and perceptions and produces figure 2.
9.	"6-table4" uses survey data and experimental WTP assignments to estimate households willingness to pay for a nitrate testing program and produces table 4.
10.	"7-si-app" uses survey data to produce all tables and figures in the supplementary material. 

Note: All figures and tables will be saved in the folder **output**.
