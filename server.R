#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  
  live_data_stats_provider <- reactive({
    invalidateLater(30000)
    apiGet<- GET(niceApi,path = "api", query= list(method = "stats.provider", addr = addr))
    responseList <- content(apiGet,type = "application/json")
    data <- extractStatsNH(responseList)
  })
  
  output$view <- renderTable({ live_data_stats_provider()} , digits = 10)
  
  
})
