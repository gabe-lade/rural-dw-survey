###########################################################################
#Improving Private Well Testing Programs: Experimental Evidence from Iowa
# THIS FILE:
# 	1) PRODUCES FIGURE 1A
# Last Updated: 11/20/2023
###########################################################################
#  Clear memory
rm(list = ls())

#Load packages
library(data.table)
library(viridis)
library(sf)
library(raster)
library(dplyr)
library(tidyverse)
library(tidycensus)
library(modelsummary)
library(sp)


###
#Fig 1A - NO3 IA MAP
test_data <- fread("dataRAW/dnr-tests/PWTSallnitrate_20220511.csv")
ia_acs_cty <- get_acs(geography = "county", 
                      variables = "S0101_C01_002", 
                      state = "IA", 
                      year=2018,
                      geometry = TRUE)
ia_cty_study<-ia_acs_cty[ia_acs_cty$NAME=="Bremer County, Iowa"|ia_acs_cty$NAME=="Butler County, Iowa"|ia_acs_cty$NAME=="Cedar County, Iowa"|
                           ia_acs_cty$NAME=="Fremont County, Iowa"|ia_acs_cty$NAME=="Jones County, Iowa"|ia_acs_cty$NAME=="Mills County, Iowa"|
                           ia_acs_cty$NAME=="Boone County, Iowa"|ia_acs_cty$NAME=="Clayton County, Iowa"|ia_acs_cty$NAME=="Crawford County, Iowa"|
                           ia_acs_cty$NAME=="Dallas County, Iowa"|ia_acs_cty$NAME=="Emmet County, Iowa"|ia_acs_cty$NAME=="Fayette County, Iowa"|
                           ia_acs_cty$NAME=="Ida County, Iowa"|ia_acs_cty$NAME=="Palo Alto County, Iowa", ]

#Dropping missing data 
setDT(test_data)
test_data<-test_data[!(is.na(test_data$fUTM_X) | test_data$fUTM_X==""| test_data$fUTM_X=="NULL"| test_data$fUTM_X==0| test_data$fUTM_X<0), ]
test_data<-test_data[test_data$NitrateasN!="NULL", ]
test_data$NitrateasN=as.numeric(test_data$NitrateasN)
test_data<-test_data[!(is.na(test_data$NitrateasN)), ]
test_data<-test_data[!(is.infinite(test_data$NitrateasN)), ]
test_data$dtEntry <-  as.Date(test_data$dtEntry,'%m/%d/%Y')
test_data$year <- as.numeric(format(as.Date(test_data$dtEntry, format="%m/%d/%Y"),"%Y"))
test_data$month <- as.numeric(format(as.Date(test_data$dtEntry, format="%m/%d/%Y"),"%m"))
datasummary_skim(test_data$year)

#Dropping <0 Readings and Replacing High values with 10
quantile(test_data$NitrateasN, c(.95, .975, .99), na.rm = TRUE) #95%=19.333, 97.5%=33.70, 99%=68.40
test_data<- test_data[test_data$NitrateasN<=68,]
test_data<- test_data[test_data$NitrateasN>=0,]
test_data$no3<-ifelse(test_data$NitrateasN>10,10,test_data$NitrateasN)


test_data <- st_as_sf(x=test_data,
                      coords = c('fUTM_X','fUTM_Y'),
                      crs="+proj=utm +zone=15 +datum=WGS84  +units=m")
test_data <- st_transform(test_data, CRS("+proj=longlat +datum=WGS84"))
test_data <- test_data %>% add_column(do.call(rbind, st_geometry(test_data)) %>% 
                                        as_tibble() %>% setNames(c("lon","lat")))

#Bounding coordinates for Iowa (Source: https://pathindependence.wordpress.com/2018/11/23/bounding-boxes-for-all-us-states/)
#19	19	IA	Iowa	-96.639704	40.375501	-90.140061	43.501196
test_data<- test_data[test_data$lat>=40.375501,]
test_data<- test_data[test_data$lat<=43.501196,]
test_data<- test_data[test_data$lon<=-90.140061,]
test_data<- test_data[test_data$lon>=-96.639704,]
bs <- seq(2,10,2)
datasummary_skim(test_data$PWTSwellid)
write.csv(test_data, "dataClean/test_data_clean.csv", row.names=TRUE)

 
#Maps
test_data_g2<-test_data[test_data$no3>=2, ]
test_data_l2<-test_data[test_data$no3<2, ]
 
map_no3_ia<-ggplot() +
  geom_sf(data = ia_acs_cty, colour = "grey", fill = "transparent") + 
  labs(x="", y="")+ #labels
  theme(axis.ticks.y = element_blank(),axis.text.y = element_blank(), # get rid of x ticks/text
        axis.ticks.x = element_blank(),axis.text.x = element_blank(), # get rid of y ticks/text
        plot.title = element_text(size = 12, face = "bold",hjust = 0.5))+
  geom_point(aes(x=lon, y=lat), shape=1, size=1, color="grey", data=test_data_l2, na.rm = TRUE) + 
  geom_point(aes(x=lon, y=lat, color=no3, size=no3), data=test_data_g2, na.rm = TRUE, show.legend = TRUE) + 
  scale_color_viridis("NO3 Concentrations", option="magma", breaks=as.vector(bs))+ scale_size(range=c(0,1), breaks=as.vector(bs), guide = "none")+
  geom_sf(data = ia_cty_study, colour = "darkred", fill = "transparent", linewidth = 1) +
  theme_bw()+  theme_void() +
  theme(legend.position = "bottom", legend.direction = "horizontal") +
  annotate("text", x =-96.5, y =43.7, size = 10, label = "A", fontface = "bold")
ggsave("output/fig-1a.png", dpi=300, dev='png', height=4.5, width=6, units="in")


