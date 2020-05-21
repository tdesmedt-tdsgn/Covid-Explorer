# DATA PREPARATION

# DATA LOAD
covid <- read.csv("DATA/covid_19_data.csv", stringsAsFactors = FALSE)
covid$ObservationDate <- as.Date(x = covid$ObservationDate, format = "%m-%d-%y")
for(i in 1:nrow(covid)) {
  covid$Province.State[i] <- ifelse(covid$Province.State[i] == "", covid$Country.Region[i], covid$Province.State[i])
}
covidByCountry <- aggregate(x = covid[,c("Confirmed", "Deaths", "Recovered")], by = list(ObservationDate = covid$ObservationDate, Country.Region = covid$Country.Region), FUN = sum, na.rm = TRUE)

covidByCountry$Country.Region[covidByCountry$Country.Region == "Russia"] <- "Russian Federation"
covidByCountry$Country.Region[covidByCountry$Country.Region == "UK"] <- "United Kingdom"
covidByCountry$Country.Region[covidByCountry$Country.Region == "US"] <- "United States"
covidByCountry$Country.Region[covidByCountry$Country.Region == "Slovakia"] <- "Slovak Republic"
covidByCountry$Country.Region[covidByCountry$Country.Region == "South Korea"] <- "Korea, Rep."
covidByCountry$Country.Region[covidByCountry$Country.Region == "Egypt"] <- "Egypt, Arab Rep."
covidByCountry$Country.Region[covidByCountry$Country.Region == "Hong Kong"] <- "Hong Kong SAR, China"
covidByCountry$Country.Region[covidByCountry$Country.Region == "Mainland China"] <- "China"
covidByCountry$Country.Region[covidByCountry$Country.Region == "Iran"] <- "Iran, Islamic Rep."
covidByCountry$Country.Region[covidByCountry$Country.Region == "Republic of Ireland"] <- "Ireland"

# covidByCountry <- rbind(covidByCountry,
#                         data.frame(ObservationDate = as.Date("2020-03-16"),
#                                    Country.Region = "Belgium",
#                                    Confirmed = 886,
#                                    Deaths = 10,
#                                    Recovered = 1))
covidByCountry$ConfirmedNew <- covidByCountry$DeathsNew <- covidByCountry$RecoveredNew <- 0
covidByCountry$Confirmed21 <- covidByCountry$Deaths21 <- covidByCountry$Recovered21 <- 0
for(i in 1:nrow(covidByCountry)) {
  obsDateTemp <- covidByCountry$ObservationDate[i]
  pastDataTemp <- covidByCountry$Confirmed[covidByCountry$ObservationDate < obsDateTemp & covidByCountry$Country.Region == covidByCountry$Country.Region[i]]
  sumPast <- sum(pastDataTemp, na.rm = TRUE)
  if(sumPast == 0) {
    covidByCountry$ConfirmedNew[i] <- covidByCountry$Confirmed[i]
  } else {
    covidByCountry$ConfirmedNew[i] <- covidByCountry$Confirmed[i] - pastDataTemp[length(pastDataTemp)]
  }
  covidByCountry$Confirmed21[i] <- sum(covidByCountry$ConfirmedNew[covidByCountry$ObservationDate <= obsDateTemp & covidByCountry$ObservationDate > (obsDateTemp-21) & covidByCountry$Country.Region == covidByCountry$Country.Region[i]], na.rm = TRUE)
  pastDataTemp <- covidByCountry$Deaths[covidByCountry$ObservationDate < obsDateTemp & covidByCountry$Country.Region == covidByCountry$Country.Region[i]]
  sumPast <- sum(pastDataTemp, na.rm = TRUE)
  if(sumPast == 0) {
    covidByCountry$DeathsNew[i] <- covidByCountry$Deaths[i]
  } else {
    covidByCountry$DeathsNew[i] <- covidByCountry$Deaths[i] - pastDataTemp[length(pastDataTemp)]
  }
  covidByCountry$Deaths21[i] <- sum(covidByCountry$DeathsNew[covidByCountry$ObservationDate <= obsDateTemp & covidByCountry$ObservationDate > (obsDateTemp-21) & covidByCountry$Country.Region == covidByCountry$Country.Region[i]], na.rm = TRUE)
  pastDataTemp <- covidByCountry$Recovered[covidByCountry$ObservationDate < obsDateTemp & covidByCountry$Country.Region == covidByCountry$Country.Region[i]]
  sumPast <- sum(pastDataTemp, na.rm = TRUE)
  if(sumPast == 0) {
    covidByCountry$RecoveredNew[i] <- covidByCountry$Recovered[i]
  } else {
    covidByCountry$RecoveredNew[i] <- covidByCountry$Recovered[i] - pastDataTemp[length(pastDataTemp)]
  }
  covidByCountry$Recovered21[i] <- sum(covidByCountry$RecoveredNew[covidByCountry$ObservationDate <= obsDateTemp & covidByCountry$ObservationDate > (obsDateTemp-21) & covidByCountry$Country.Region == covidByCountry$Country.Region[i]], na.rm = TRUE)
}

pop <- read.csv("DATA/API_SP.POP.TOTL_DS2_en_csv_v2_866861.csv", stringsAsFactors = FALSE, skip = 3)

covidByCountry <- covidByCountry[covidByCountry$Country.Region %in% unique(pop$Country.Name),]
covidByCountry$ConfirmedRel <- covidByCountry$ConfirmedNewRel <- covidByCountry$Confirmed21Rel <- 0
covidByCountry$DeathsRel <- covidByCountry$DeathsNewRel <- covidByCountry$Deaths21Rel <- 0
covidByCountry$RecoveredRel <- covidByCountry$RecoveredNewRel <- covidByCountry$Recovered21Rel <- 0
for(i in 1:nrow(covidByCountry)) {
  covidByCountry$ConfirmedRel[i] <- covidByCountry$Confirmed[i] / pop$X2018[pop$Country.Name == covidByCountry$Country.Region[i]]
  covidByCountry$ConfirmedNewRel[i] <- covidByCountry$ConfirmedNew[i] / pop$X2018[pop$Country.Name == covidByCountry$Country.Region[i]]
  covidByCountry$Confirmed21Rel[i] <- covidByCountry$Confirmed21[i] / pop$X2018[pop$Country.Name == covidByCountry$Country.Region[i]]
  covidByCountry$DeathsRel[i] <- covidByCountry$Deaths[i] / pop$X2018[pop$Country.Name == covidByCountry$Country.Region[i]]
  covidByCountry$DeathsNewRel[i] <- covidByCountry$DeathsNew[i] / pop$X2018[pop$Country.Name == covidByCountry$Country.Region[i]]
  covidByCountry$Deaths21Rel[i] <- covidByCountry$Deaths21[i] / pop$X2018[pop$Country.Name == covidByCountry$Country.Region[i]]
  covidByCountry$RecoveredRel[i] <- covidByCountry$Recovered[i] / pop$X2018[pop$Country.Name == covidByCountry$Country.Region[i]]
  covidByCountry$RecoveredNewRel[i] <- covidByCountry$RecoveredNew[i] / pop$X2018[pop$Country.Name == covidByCountry$Country.Region[i]]
  covidByCountry$Recovered21Rel[i] <- covidByCountry$Recovered21[i] / pop$X2018[pop$Country.Name == covidByCountry$Country.Region[i]]
}
extPop <- 10e6
covidByCountry$ConfirmedRelExt <- covidByCountry$ConfirmedRel * extPop
covidByCountry$ConfirmedNewRelExt <- covidByCountry$ConfirmedNewRel * extPop
covidByCountry$Confirmed21RelExt <- covidByCountry$Confirmed21Rel * extPop
covidByCountry$DeathsRelExt <- covidByCountry$DeathsRel * extPop
covidByCountry$DeathsNewRelExt <- covidByCountry$DeathsNewRel * extPop
covidByCountry$Deaths21RelExt <- covidByCountry$Deaths21Rel * extPop
covidByCountry$RecoveredRelExt <- covidByCountry$RecoveredRel * extPop
covidByCountry$RecoveredNewRelExt <- covidByCountry$RecoveredNewRel * extPop
covidByCountry$Recovered21RelExt <- covidByCountry$Recovered21Rel * extPop

covidByCountry$Days100 <- 0
covidByCountry$flag100 <- F
for(i in 1:nrow(covidByCountry)) {
  tempCountry <- covidByCountry$Country.Region[i]
  tempData100 <- covidByCountry[covidByCountry$Country.Region == covidByCountry$Country.Region[i] & covidByCountry$Confirmed >= 100,]
  tempDate100 <- ifelse(nrow(tempData100) == 0, 0, min(tempData100$ObservationDate, na.rm = TRUE))
  covidByCountry$flag100[i] <- ifelse(nrow(tempData100) == 0, FALSE, TRUE)
  covidByCountry$Days100[i] <- covidByCountry$ObservationDate[i] - tempDate100
}

covidByCountry$Days100E <- 0
covidByCountry$flag100E <- F
for(i in 1:nrow(covidByCountry)) {
  tempCountry <- covidByCountry$Country.Region[i]
  tempData100 <- covidByCountry[covidByCountry$Country.Region == covidByCountry$Country.Region[i] & covidByCountry$ConfirmedRelExt >= 100,]
  tempDate100 <- ifelse(nrow(tempData100) == 0, 0, min(tempData100$ObservationDate, na.rm = TRUE))
  covidByCountry$flag100E[i] <- ifelse(nrow(tempData100) == 0, FALSE, TRUE)
  covidByCountry$Days100E[i] <- covidByCountry$ObservationDate[i] - tempDate100
}

covidByCountry$Days100D <- 0
covidByCountry$flag100D <- F
for(i in 1:nrow(covidByCountry)) {
  tempCountry <- covidByCountry$Country.Region[i]
  tempData100 <- covidByCountry[covidByCountry$Country.Region == covidByCountry$Country.Region[i] & covidByCountry$Deaths >= 10,]
  tempDate100 <- ifelse(nrow(tempData100) == 0, 0, min(tempData100$ObservationDate, na.rm = TRUE))
  covidByCountry$flag100D[i] <- ifelse(nrow(tempData100) == 0, FALSE, TRUE)
  covidByCountry$Days100D[i] <- covidByCountry$ObservationDate[i] - tempDate100
}

covidByCountry$Days100DE <- 0
covidByCountry$flag100DE <- F
for(i in 1:nrow(covidByCountry)) {
  tempCountry <- covidByCountry$Country.Region[i]
  tempData100 <- covidByCountry[covidByCountry$Country.Region == covidByCountry$Country.Region[i] & covidByCountry$DeathsRelExt >= 10,]
  tempDate100 <- ifelse(nrow(tempData100) == 0, 0, min(tempData100$ObservationDate, na.rm = TRUE))
  covidByCountry$flag100DE[i] <- ifelse(nrow(tempData100) == 0, FALSE, TRUE)
  covidByCountry$Days100DE[i] <- covidByCountry$ObservationDate[i] - tempDate100
}
covidByCountry <- covidByCountry[order(covidByCountry$ObservationDate),]
saveRDS(covidByCountry, file = "data/covid_19_data.rds", version = 3)
