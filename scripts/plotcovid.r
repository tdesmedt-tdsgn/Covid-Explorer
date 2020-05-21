plotCovid <- function(covidPlot, caseType, xType, relative, daily, cumul, twentyone) {
  if(nrow(covidPlot) == 0) {
    return(NULL)
  }
  if(xType == 1) {
    covidPlot$xVar <- covidPlot$ObservationDate
    xAxisType <- "datetime"
    xTooltip <- "{point.x:%d %B %Y}"
    xMin <- NULL
  }
  if(xType == 2) {
    if(relative == 1) {
      covidPlot <- covidPlot[covidPlot$flag100,]
      covidPlot$xVar <- covidPlot$Days100
    }
    if(relative == 2) {
      covidPlot <- covidPlot[covidPlot$flag100E,]
      covidPlot$xVar <- covidPlot$Days100E
    }
    xAxisType <- "linear"
    xTooltip <- "{point.x}"
    xMin <- -20
  }
  if(xType == 3) {
    if(relative == 1) {
      covidPlot <- covidPlot[covidPlot$flag100D,]
      covidPlot$xVar <- covidPlot$Days100D
    }
    if(relative == 2) {
      covidPlot <- covidPlot[covidPlot$flag100DE,]
      covidPlot$xVar <- covidPlot$Days100DE
    }
    xAxisType <- "linear"
    xTooltip <- "{point.x}"
    xMin <- -20
  }
  
  if(relative == 1) {
    if(caseType == "Confirmed") {
      covidPlot$yVar <- covidPlot$Confirmed
      covidPlot$yVarNew <- covidPlot$ConfirmedNew
      covidPlot$yVar21 <- covidPlot$Confirmed21
    }
    if(caseType == "Deaths") {
      covidPlot$yVar <- covidPlot$Deaths
      covidPlot$yVarNew <- covidPlot$DeathsNew
      covidPlot$yVar21 <- covidPlot$Deaths21
    }
    if(caseType == "Recovered") {
      covidPlot$yVar <- covidPlot$Recovered
      covidPlot$yVarNew <- covidPlot$RecoveredNew
      covidPlot$yVar21 <- covidPlot$Recovered21
    }
  }
  
  # if(relative == 2) {
  #   if(caseType == "Confirmed") {
  #     covidPlot$yVar <- covidPlot$ConfirmedRel
  #     covidPlot$yVarNew <- covidPlot$ConfirmedNewRel
  #     covidPlot$yVar21 <- covidPlot$Confirmed21Rel
  #   }
  #   if(caseType == "Deaths") {
  #     covidPlot$yVar <- covidPlot$DeathsRel
  #     covidPlot$yVarNew <- covidPlot$DeathsNewRel
  #     covidPlot$yVar21 <- covidPlot$Deaths21Rel
  #   }
  #   if(caseType == "Recovered") {
  #     covidPlot$yVar <- covidPlot$RecoveredRel
  #     covidPlot$yVarNew <- covidPlot$RecoveredNewRel
  #     covidPlot$yVar21 <- covidPlot$Recovered21Rel
  #   }
  # } 
  
  if(relative == 2) {
    if(caseType == "Confirmed") {
      covidPlot$yVar <- covidPlot$ConfirmedRelExt
      covidPlot$yVarNew <- covidPlot$ConfirmedNewRelExt
      covidPlot$yVar21 <- covidPlot$Confirmed21RelExt
    }
    if(caseType == "Deaths") {
      covidPlot$yVar <- covidPlot$DeathsRelExt
      covidPlot$yVarNew <- covidPlot$DeathsNewRelExt
      covidPlot$yVar21 <- covidPlot$Deaths21RelExt
    }
    if(caseType == "Recovered") {
      covidPlot$yVar <- covidPlot$RecoveredRelExt
      covidPlot$yVarNew <- covidPlot$RecoveredNewRelExt
      covidPlot$yVar21 <- covidPlot$Recovered21RelExt
    }
  } 
  
  title_font <- list(
    family = "Courier New, monospace",
    size = 10
  )
  
  tempTitle <- paste0("<b>New", ifelse(xType == 2, " - Day from 100th Case", ""), ifelse(xType == 3, " - Day from 10th Death", ""),
                      ifelse(relative == 2, " / 10 M", ""), "</b>")
  # hc1 <- highchart()
  # hc1 <- hc_plotOptions(hc = hc1, column = list(stacking = "normal"), series = list(turboThreshold = 10000))
  # hc1 <- hc_chart(hc = hc1, zoomType = "xy", height = '100%')
  # hc1 <- hc_legend(hc = hc1, itemStyle =list(fontSize = "8px"))
  # hc1 <- hc_title(hc = hc1, text = tempTitle, style = list(fontSize = "12px"))
  # hc1 <- hc_add_series(hc = hc1, data = covidPlot, type = "scatter", hcaes(x = xVar, y = yVarNew, group = Country.Region), marker = list(radius = 2), tooltip = list(pointFormat = paste0("Date: ", xTooltip," <br>{series.name}: {point.y:.2f}")))
  # hc1 <- hc_xAxis(hc = hc1, type = xAxisType, min = xMin)
  # hc1 <- hc_yAxis(hc = hc1, min = 0)
  
  hc1 <- covidPlot %>% plot_ly(x=~xVar, y = ~yVarNew, type = "scatter", color=~Country.Region,
                 colors=c("#FFCD00", "#51DF86",  "#6BBBF4"),
                 text = ~yVarNew,
                 name=~Country.Region,
                 hovertemplate = paste('%{x}', '<br>lifeExp: %{text:.2s}<br>'),
                 texttemplate = '%{y:.2s}',
                 textposition = 'outside'
   ) %>%
    layout(title = list(text = tempTitle),
           titlefont = list(size = 12),
           xaxis = list(title = "", zeroline=F, showline=F, showgrid=T),
           yaxis = list(title = "", zeroline=F, showline=F, showgrid=T, min=0)) %>%
    config(displayModeBar = F)
  
  tempTitle <- paste0("<b>Cumulative", ifelse(xType == 2, " - Day from 100th Case", ""), ifelse(xType == 3, " - Day from 10th Death", ""),
                      ifelse(relative == 2, " / 10 M", ""), "</b>")
  # hc2 <- highchart()
  # hc2 <- hc_plotOptions(hc = hc2, column = list(stacking = "normal"), series = list(turboThreshold = 10000))
  # hc2 <- hc_chart(hc = hc2, zoomType = "xy", height = '100%')
  # hc2 <- hc_legend(hc = hc2, itemStyle =list(fontSize = "8px"))
  # hc2 <- hc_title(hc = hc2, text = tempTitle, style = list(fontSize = "12px"))
  # hc2 <- hc_add_series(hc = hc2, data = covidPlot, type = "line", hcaes(x = xVar, y = yVar, group = Country.Region), marker = list(enabled = FALSE), tooltip = list(pointFormat = paste0("Date: ", xTooltip," <br>{series.name}: {point.y:.2f}")))
  # hc2 <- hc_xAxis(hc = hc2, type = xAxisType, min = xMin)
  # hc2 <- hc_yAxis(hc = hc2, min = 0)
  
  hc2 <- plot_ly(data=covidPlot, x=~xVar, y = ~yVar, type = "scatter", mode="lines", color=~Country.Region,
                 colors=c("#FFCD00", "#51DF86",  "#6BBBF4"),
                 # text = ~paste0("Date: ", xTooltip, "<br>", Country.Region,": ", yVarNew),
                 # hoverinfo = "text",
                 text = ~Country.Region,
                 hovertemplate = paste(
                   "<b>%{text}</b><br><br>",
                   "%{yaxis.title.text}: %{y:$,.0f}<br>",
                   "%{xaxis.title.text}: %{x:.0%}<br>",
                   "<extra></extra>"
                 )
  ) %>%
    layout(title = list(text = tempTitle),
           titlefont = list(size = 12),
           xaxis = list(title = "", zeroline=F, showline=F, showgrid=T),
           yaxis = list(title = "", zeroline=F, showline=F, showgrid=T, min=0)) %>%
    config(displayModeBar = F)
  
  tempTitle <- paste0("<b>21-Day Window", ifelse(xType == 2, " - Day from 100th Case", ""), ifelse(xType == 3, " - Day from 10th Death", ""),
                      ifelse(relative == 2, " / 10 M", ""), "</b>")
  # hc3 <- highchart()
  # hc3 <- hc_plotOptions(hc = hc3, column = list(stacking = "normal"), series = list(turboThreshold = 10000))
  # hc3 <- hc_chart(hc = hc3, zoomType = "xy", style= list(height = "100%"))
  # hc3 <- hc_legend(hc = hc3, itemStyle =list(fontSize = "8px"))
  # hc3 <- hc_title(hc = hc3, text = tempTitle, style = list(fontSize = "12px"))
  # hc3 <- hc_add_series(hc = hc3, data = covidPlot, type = "column", hcaes(x = xVar, y = yVar21, group = Country.Region), marker = list(enabled = FALSE), tooltip = list(pointFormat = paste0("Date: ", xTooltip," <br>{series.name}: {point.y:.2f}")))
  # hc3 <- hc_xAxis(hc = hc3, type = xAxisType, min = xMin)
  # hc3 <- hc_yAxis(hc = hc3, min = 0)
  
  hc3 <- plot_ly(data=covidPlot, x=~xVar, y = ~yVar21, type = "bar", color=~Country.Region,
                 colors=c("#FFCD00", "#51DF86",  "#6BBBF4"),
                 # text = ~paste0("Date: ", xTooltip, "<br>", Country.Region,": ", yVarNew),
                 # hoverinfo = "text",
                 text = ~Country.Region,
                 hovertemplate = paste(
                   "<b>%{text}</b><br><br>",
                   "%{yaxis.title.text}: %{y:$,.0f}<br>",
                   "%{xaxis.title.text}: %{x:.0%}<br>",
                   "<extra></extra>"
                 )
  ) %>%
    layout(title = list(text = tempTitle),
           titlefont = list(size = 12),
           xaxis = list(title = "", zeroline=F, showline=F, showgrid=T),
           yaxis = list(title = "", zeroline=F, showline=F, showgrid=T, min=0),
           barmode = 'stack') %>%
    config(displayModeBar = F)
  
  return(list(hc1, hc2, hc3))
}