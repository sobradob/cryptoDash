#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "CryptoDash"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
    box(tableOutput("view"))
    )
    )
)