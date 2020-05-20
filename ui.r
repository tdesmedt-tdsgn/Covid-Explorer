shinyUI(
  fluidPage(
    shinyjs::useShinyjs(),
    sidebarLayout(
    sidebarPanel(class="sidebarpanel", width = 1,
                 tags$div(class="sidebar", (tags$a(href="https://www.datahive.be", img(id="logo", class="logo", src="Datahive-Icon.png"))),
                 bsButton(class="filteractive", icon = icon("filter"), "filter", label = "Filters", block = F),
                 bsButton(icon = icon("compress"), "compare", label = "Compare", block = F),
                 tags$a(href="#deathrow", tags$div(tags$span(fa(name = "cross")), tags$span(class="menutext"),"Deaths")), 
                 tags$a(href="#confirmedrow", tags$div(tags$span(fa(name = "check")), tags$span(class="menutext"),"Confirmed Cases")), 
                 tags$a(href="#recoveredrow", tags$div(tags$span(fa(name = "redo-alt")), tags$span(class="menutext"),"Recovered Cases")),
                 tags$div(class="Bottomtitle","COVID-19"))
                 ),
    mainPanel(width = 11, skin = "blue",   # Skin blue is used as a placeholder name, extensively customized in the BI.css file (in www folder)
                      dashboardSidebar(disable = TRUE),
                      dashboardBody(
                        tags$head(
                          tags$link(rel = "stylesheet", 
                                    type = "text/css", 
                                    href = "dashboard.css")
                        ),
                        fluidRow(id="filterrow", class="filterrow",
                          tags$div(class="title col-sm-12", "Filters"),
                          box(id="countries", class="boxcontent", width = 4, uiOutput("selCountry")),
                          box(class="boxcontent", width = 4, radioButtons(inputId = "selRel", label = "Numbers", choices = list("Absolute" = 1, "Extrapolated to population of 10M" = 2), selected = 2, inline = TRUE)),  # "Relative"= 2,
                          box(class="boxcontent", width = 4, uiOutput("selDate"))
                          ),
                        fluidRow(id="deathrow", class="deathrow",
                          tags$div(id="deathrowtitle", class="titlemargin col-sm-12", "Deaths"),
                          box(width = 4, plotlyOutput("deatPlot_New")),
                          box(width = 4, title = "", plotlyOutput("deatPlot_Cum")),
                          box(width = 4, title = "", plotlyOutput("deatPlot_21"))
                        ),
                        fluidRow(id="confirmedrow", class="confirmedrow",
                          tags$div(id="confirmedtitle", class="titlemargin col-sm-12", "Confirmed Cases"),
                          box(width = 4, plotlyOutput("confPlot_New")),
                          box(width = 4, title = "", plotlyOutput("confPlot_Cum")),
                          box(width = 4, title = "", plotlyOutput("confPlot_21"))
                        ),
                        fluidRow(id="recoveredrow", class="recoveredrow",
                          tags$div(id="recoveredtitle", class="titlemargin col-sm-12", "Recovered Cases"),
                          box(width = 4, plotlyOutput("recoPlot_New")),
                          box(width = 4, title = "", plotlyOutput("recoPlot_Cum")),
                          box(width = 4, title = "", plotlyOutput("recoPlot_21"))
                        ),
                        fluidRow(class="creditsrow",
                          box(width = 12, title = "Data Source",
                              div(HTML("Covid-19 Data: <a href='https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data'>2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository by Johns Hopkins CSSE</a> & <a href='https://www.kaggle.com/sudalairajkumar/novel-corona-virus-2019-dataset'>Novel Corona Virus 2019 Dataset</a>")),
                              div(HTML("Population Data: <a href='https://data.worldbank.org/indicator/SP.POP.TOTL'>The World Bank Total Population Data</a> (2018 population data was used)")),
                              div(HTML("<br>Created by <a href='https://www.datahive.be'>Datahive</a>"))
                              )
                        )
                      ) )))  # CLOSE DASHBOARDBODY
)   # CLOSE DASHBOARDPAGE AND SHINYUI

