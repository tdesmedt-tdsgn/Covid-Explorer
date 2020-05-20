# DATA EXTRACTION
### DO GIT PULL FIRST!
rawFiles <- list.files(path = "DATA/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/", pattern = ".csv")

dataCovid <- data.frame(
  ObservationDate = character(),
  Province.State = character(),
  Country.Region = character(),
  Last.Update = character(),
  Confirmed = numeric(),
  Deaths = numeric(),
  Recovered = numeric(),
  stringsAsFactors = FALSE
)
for(i in rawFiles) {
  rawTemp <- read.csv(file = paste0("DATA/COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/", i), stringsAsFactors = FALSE)
  dateTemp <- gsub(pattern = ".csv", replacement = "", x = i)
  # print(dateTemp)
  rawTemp$ObservationDate <- rep(dateTemp, nrow(rawTemp))
  # # print(str(rawTemp))
  # if("Latitude" %in%  names(rawTemp) | "Longitude" %in%  names(rawTemp)) {
  #   rawTemp <- rawTemp[,-which(names(rawTemp) %in% c("Latitude","Longitude"))]
  # }
  # if("FIPS" %in%  names(rawTemp)) {
  #   rawTemp <- rawTemp[,-which(names(rawTemp) %in% c("FIPS"))]
  # }
  if("Province_State" %in%  names(rawTemp)) {
    rawTemp$Province.State <- rawTemp$Province_State
  }
  if("Country_Region" %in%  names(rawTemp)) {
    rawTemp$Country.Region <- rawTemp$Country_Region
  }
  if("Last_Update" %in%  names(rawTemp)) {
    rawTemp$Last.Update <- rawTemp$Last_Update
  }
  rawTemp <- rawTemp[,names(dataCovid)]
  dataCovid <- rbind(dataCovid, rawTemp) 
  # print(str(dataCovid))
}
dataCovid <- dataCovid[!(dataCovid$Country.Region == "Mainland China" & as.Date(dataCovid$ObservationDate, format = "%m-%d-%y") > as.Date("2020-03-10")),]
write.csv(x = dataCovid, file = "DATA/covid_19_data.csv", row.names = FALSE)
