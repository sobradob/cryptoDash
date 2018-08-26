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
  
  # nicehash data
  
  ## write API data to google sheet
  ## token loaded previously via global.R
  autoInvalidate <- reactiveTimer(10000)
  
  observe({
    # Invalidate and re-execute this reactive expression every time the
    # timer fires.
    autoInvalidate()
    
    # Do something each time this is invalidated.
    api_input <- niceHashWrapper(addr, "stats.provider")
    api_input_stats <- api_input$result$stats %>% 
      bind_rows() %>% 
      mutate(timeStamp = as.character(Sys.time()))
    niceHashGs <- gs_title("niceHash")
    niceHashGs %>%
      gs_add_row(input = api_input_stats)
    
  })
  

  
  # nanopool data
  
  nanopool_user <- reactive({
    invalidateLater(1000*60*10)
    currentUser<- nanopoolWrapper(addr = ethAddr,coin = "eth", func = "user")
  })
  

  output$nanopoolHR <- renderInfoBox({
    userNanopool <- nanopool_user()
    infoBox(
      "Current Hashrate (MH/s)",userNanopool$data$hashrate, icon = tags$i(fa("tachometer-alt", fill = "white")),
      color = "purple"
    )
  })
  
  output$nanopoolWorkerCount <- renderInfoBox({
    userNanopool <- nanopool_user()
    infoBox(
      "Workers Online",length(userNanopool$data), icon = tags$i(fa("briefcase", fill = "white")),
      color = "blue"
    )
  })
  
  output$nanopoolETHEUR <- renderInfoBox({
    invalidateLater(1000*60*10)
    prices <- nanopoolWrapper(addr = "",coin = "eth", func = "prices")
    infoBox(
      "EUR/ETH",prices$data$price_eur, icon = tags$i(fa("ethereum", fill = "white")),
      color = "green"
    )
  })
  
  output$PerDay <- renderInfoBox({
    invalidateLater(1000*60*10)
    userNanopool <- nanopool_user()
    func <- paste("approximated_earnings/", userNanopool$data$avgHashrate$h24)
    calcEarn<- nanopoolWrapper(addr = "",coin = "eth", func = func)
  
    infoBox(
      "Monthly Income EUR",calcEarn$data$month$euros, icon = tags$i(fa("euro-sign",fill = "white")),
      color = "green"
    )
  })
  
  output$hrHistory <- renderPlot({
    invalidateLater(60*1000)
    hist <- nanopoolWrapper(addr = ethAddr,coin = "eth", func = "history")
    histDf<- bind_rows(hist$data)
    meanHr <- mean(histDf$hashrate)
    histDf %>%
      mutate(date2 = as.POSIXct(date, origin = "1970-01-01"),
             hr2   = rollmean(hashrate,6,na.pad = T)
      ) %>%
      ggplot(.,aes(x = date2, y = hashrate)) +
      geom_point(shape=1, colour = "grey")+
      geom_line(aes( x = date2, y = hr2))+
      geom_hline(yintercept = meanHr,colour = "red")+
      theme_bw()+
      xlab("Date") + ylab("Hashrate in MH/s")
    
  })
})
