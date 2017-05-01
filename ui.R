#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(data.table)
library(curl)

#data <- read.csv("Z:\\PerformanceManagement\\PriorityAreaKPIs\\PerformanceData\\AllPeopleHaveEconomicOpportunities\\BuildingPermits\\Data\\BuildingPermitsByZipCodeGeo.csv")
data <- fread("https://performance.fultoncountyga.gov/resource/p3f6-ug7s.csv")
zipcodelist <- sort(unique(data$Quarter))

ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                selectInput("quarter", "Quarter", zipcodelist)

  )
)
