library(dplyr)
library(rio)
library(jsonlite)
library(ggplot2)
library(rCharts)

if(!file.exists("cached_data.tsv")) {

  dat0 <- fromJSON('https://services.arcgis.com/g1fRTDLeMgspWrYp/arcgis/rest/services/SAMHD_DailySurveillance_Data_Public/FeatureServer/0/query?where=1%3D1&outFields=*&returnGeometry=false&outSR=4326&f=json')
  dat1 <- dat0$features$attributes %>% subset(!is.na(total_case_cumulative)) %>% mutate(reporting_date = as.POSIXct(reporting_date/1000, origin = "1970-01-01"))

  rio::export(dat1, "cached_data.tsv")

} else {dat1 <- rio::import("cached_data.tsv")}