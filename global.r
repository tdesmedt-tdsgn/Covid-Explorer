# CONFIGURE SHINY
options(scipen = 999)

# LOAD LIBRARIES
library(shinydashboard)
library(shinyWidgets)
library(DT)
library(highcharter)
library(fontawesome)
library(shinyjs)
library(shinyBS)
library(plotly)

# LOAD AUX. FUNCTIONS
source("scripts/plotcovid.r")  # Plotting function

# LOAD DATA
covidByCountry <- readRDS(file = "data/covid_19_data.rds")  # covid data









