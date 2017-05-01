#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(dplyr)
library(data.table)
library(curl)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #data <- read.csv("https://performance.fultoncountyga.gov/resource/p3f6-ug7s.csv")
  data <- fread("https://performance.fultoncountyga.gov/resource/p3f6-ug7s.csv")
  
  filteredData <- reactive({
    data[data$Quarter == input$quarter,]
  })
  
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(data[which(data$Quarter == '2016 Q4'),]) %>% addProviderTiles(providers$OpenStreetMap.HOT, option = providerTileOptions(opacity = 0.7)) %>%
      addCircles(lng = ~Longitude, lat = ~Latitude, weight = 2, radius = ~sqrt(TotalValue / 50), popup = ~paste0("<b>Zip Code:</b> ", Zipcode, "</br>", "<b>Total Value:</b> ", "$", format(round(as.numeric(TotalValue), 0), nsmall=0, big.mark=","))
      )
    #leaflet(data[which(data$Quarter == '2016 Q4'),]) %>% addTiles(opacity = 0.5) %>%
    #  addCircles(lng = ~longitude, lat = ~latitude, weight = 2, radius = ~sqrt(TotalValue / 50), popup = ~paste0("<b>Zip Code:</b> ", zipcode, "</br>", "<b>Total Value:</b> ", "$", format(round(as.numeric(TotalValue), 0), nsmall=1, big.mark=","))
    #  )
  })
  
  observe({
    filteredData <- filteredData()
    
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(lng = ~Longitude, lat = ~Latitude, weight = 2, radius = ~sqrt(TotalValue / 50), popup = ~paste0("<b>Zip Code:</b> ", Zipcode, "</br>", "<b>Total Value:</b> ", "$", format(round(as.numeric(TotalValue),0), nsmall=1, big.mark=","))
      )
  })
  
})
