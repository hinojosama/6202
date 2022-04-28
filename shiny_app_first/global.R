library(dplyr)
library(rio)
library(jsonlite)
library(ggplot2)
library(shiny)
library(colourpicker)
library(shinythemes)
library(shinyBS)
library(plotly)
library(gt)
library(rCharts)
library(gtExtras)
library(tidyr)
library(flashlight)

#if else function to check for local cache of the JSON scraped COVID data
#if it is not found use fromJSON function to create dat0
#then make a df from a subset of dat0 dropping out the NA's and change the
#the format of dates in column `reporting_date`.  Using just the export function
#from rio libary (?needed if rio library loaded above?) to save dat1 as a local
#file `cached_data`.  If the cached_data file is found it is imported using rio's
#import function as dat1
if(!file.exists("cached_data.tsv")) {

  dat0 <- fromJSON('https://services.arcgis.com/g1fRTDLeMgspWrYp/arcgis/rest/services/SAMHD_DailySurveillance_Data_Public/FeatureServer/0/query?where=1%3D1&outFields=*&returnGeometry=false&outSR=4326&f=json')
  dat1 <- dat0$features$attributes %>%
    subset(!is.na(total_case_cumulative)) %>%
    mutate(reporting_date = as.POSIXct(reporting_date/1000, origin = "1970-01-01"))

  rio::export(dat1, "cached_data.tsv")

} else {dat1 <- rio::import("cached_data.tsv")}

#make new df from dat1, arranging by date and pivoting using all the column
#names in dat1 except the first 3 as the rows and grouping the instances by
#the name of each row before using the summarize function to make new columns
#for median, stdv. Also across...  Then using mutate add a hist column and dense
# columns
dat2_pvt <- dat1 %>%
  arrange(reporting_date) %>%
  pivot_longer(any_of(colnames(dat1)[-(1:3)])) %>%
  group_by(name) %>%
  summarize(med = median(value, na.rm = T), stdv = sd(value, na.rm = T),
            across(.fns = ~list(na.omit(.x)))) %>%
  mutate(hist = value, dense = value) %>%
  rename(spark = value)

dat2_pvt$name

#make vectors of columns to later exclude from our tables.
hide <-c("globalid", "objectid")
hide_spark <- c(hide, "reporting_date")

#vector of models
model_vec <- c("lm", "loess")
