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
  dashboardSidebar(
    sidebarMenu(id = "tabs",
                menuItem("Nanopool",tabName = "nanopool", icon = tags$i(fa("tachometer-alt",fill = "white"))),
                menuItem("NiceHash",tabName = "nicehash", icon = tags$i(fa("tachometer-alt",fill = "white"))))
  ),
  dashboardBody(
    tabItems(
      tabItem("nicehash",
              box(tableOutput("view"))
      ),
      tabItem("nanopool",
              div(p("Nanopool Dashboard")),
              fluidRow(
                # A static infoBox
                infoBoxOutput("nanopoolWorkerCount"),
                # Dynamic infoBoxes
                infoBoxOutput("nanopoolHR"),
                infoBox("Total Watt", 10 * 2, icon = tags$i(fa("battery-full", fill = "white")))
                ),
              fluidRow(
                infoBoxOutput("nanopoolETHEUR"),
                infoBoxOutput("PerDay"),
                infoBox("Total Profit", 9001, icon = tags$i(fa("ethereum", fill = "white")))
                ),
              fluidRow(
                plotOutput("hrHistory")
                )
              )
    )
    
    )
)
