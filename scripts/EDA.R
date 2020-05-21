### EDA

# LIBRARY LOAD
# library(checkpoint)
# checkpoint("2020-03-15")
library(highcharter)

# DATA LOAD
covid <- read.csv("DATA/covid_19_data.csv", stringsAsFactors = FALSE)
covid_list <- read.csv("DATA/COVID19_line_list_data.csv", stringsAsFactors = FALSE)
covid3_openlist <- read.csv("DATA/COVID19_open_line_list.csv", stringsAsFactors = FALSE)
covid_time_conf <- read.csv("DATA/time_series_covid_19_confirmed.csv", stringsAsFactors = FALSE)
covid_time_deat <- read.csv("DATA/time_series_covid_19_deaths.csv", stringsAsFactors = FALSE)
covid_time_reco <- read.csv("DATA/time_series_covid_19_recovered.csv", stringsAsFactors = FALSE)
pop <- read.csv("DATA/API_SP.POP.TOTL_DS2_en_csv_v2_866861.csv", stringsAsFactors = FALSE, skip = 3)

# COVID DATASET EDA
covid$ObservationDate <- as.Date(x = covid$ObservationDate, format = "%m/%d/%Y")

covidPlot <- covid[covid$Country.Region == "Belgium",]
hc <- highchart()
hc <- hc_chart(hc = hc, zoomType = "xy")
hc <- hc_add_series(hc = hc, data = covidPlot, type = "column", hcaes(x = ObservationDate, y = Confirmed, group = Province.State), stacking = "normal")
hc <- hc_xAxis(hc = hc, type ="datetime")

hc
