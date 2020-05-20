shinyServer(function(input, output, session) {
  
  observeEvent(input$compare,{
    addClass("deathrow", "compareheight")
    addClass("confirmedrow", "compareheight")
    addClass("recoveredrow", "compareheight")
    addClass("filterrow", "filternone")
    addClass("compare", "compareactive")
    addClass("filter", "filterwhite")
    addClass("deatPlot_New", "testclass")
    addClass("deathrowtitle", "nonedisplay")
    addClass("recoveredtitle", "nonedisplay")
    addClass("confirmedtitle", "nonedisplay")
    removeClass("deathrowtitle", "titlemargin")
    runjs("$(window).trigger('resize')")
    })
  
  observeEvent(input$filter,{                                                                                                                                 
    removeClass("deathrow", "compareheight")
    removeClass("confirmedrow", "compareheight")
    removeClass("recoveredrow", "compareheight")
    removeClass("filterrow", "filternone")
    removeClass("compare", "compareactive")
    removeClass("filter", "filterwhite")
    removeClass("deathrowtitle", "nonedisplay")
    removeClass("recoveredtitle", "nonedisplay")
    removeClass("confirmedtitle", "nonedisplay")
    addClass("deathrowtitle", "titlemargin")
    runjs("$(window).trigger('resize')")
  })
    
  output$selCountry <- renderUI({
      choicesTemp <- sort(unique(covidByCountry$Country.Region))
      selChoices <- c("Belgium", "France", "Germany")
      return(selectizeInput(inputId = "selCountry", label = HTML("Countries<span style = 'font-size: 75%;padding-left:5px;'>Select max. 3 countries</span>"), choices = choicesTemp, selected =  selChoices, multiple = TRUE, options = list(maxItems = 3)))  # c("Belgium", "China", "Italy")
  })
  
  output$selDate <- renderUI({
      if(input$selRel == 1) {
          tempRadio <- radioButtons(inputId = "selDate", label = "Date", choices = list("Calendar Date" = 1, "Day Zero = Day of 100th Case " = 2, "Day Zero = Day of 10th Deaths"= 3), selected = 3, inline = TRUE)
      } else {
          tempRadio <- radioButtons(inputId = "selDate", label = "Date", choices = list("Calendar Date" = 1, "Day Zero = Day of 100th Case / 10M" = 2, "Day Zero = Day of 10th Deaths / 10M"= 3), selected = 3, inline = TRUE)
      }
      return(tempRadio)
  })
  
   covidPlot <- reactive({
       covidPlot <- covidByCountry[covidByCountry$Country.Region %in% input$selCountry,]
       return(covidPlot)
   })
  
   deatPlot <- reactive({
     return(plotCovid(covidPlot = covidPlot(), caseType = "Deaths", xType = input$selDate, relative = input$selRel, daily = TRUE, cumul = FALSE, twentyone = FALSE))
   })
   
   output$deatPlot_New <- renderPlotly({
     return(deatPlot()[[1]])
   })
   output$deatPlot_Cum <- renderPlotly({
     return(deatPlot()[[2]])
   })
   output$deatPlot_21 <- renderHighchart({
     return(deatPlot()[[3]])
   })
   
   confPlot <- reactive({
       return(plotCovid(covidPlot = covidPlot(), caseType = "Confirmed", xType = input$selDate, relative = input$selRel, daily = TRUE, cumul = FALSE, twentyone = FALSE))
   })
   output$confPlot_New <- renderPlotly({
       return(confPlot()[[1]])
   })
   output$confPlot_Cum <- renderPlotly({
       return(confPlot()[[2]])
   })
   output$confPlot_21 <- renderPlotly({
       return(confPlot()[[3]])
   })
  
   recoPlot <- reactive({
     return(plotCovid(covidPlot = covidPlot(), caseType = "Recovered", xType = input$selDate, relative = input$selRel, daily = TRUE, cumul = FALSE, twentyone = FALSE))
   })
   output$recoPlot_New <- renderPlotly({
     return(recoPlot()[[1]])
   })
   output$recoPlot_Cum <- renderPlotly({
     return(recoPlot()[[2]])
   })
   output$recoPlot_21 <- renderHighchart({
       return(recoPlot()[[3]])
   })
}) 
