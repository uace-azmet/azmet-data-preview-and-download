# fxnTableCaption: Build caption for HTML table based on user input
# 
# @param: timeStep - AZMet data time step
# @return: tableCaption - table caption for HTML table based on user input


fxnTableCaption <- function(timeStep) {
  todayDate <- gsub(" 0", " ", format(lubridate::today(), "%B %d, %Y"))
  todayYear <- lubridate::year(lubridate::today())
  
  webpageAZMet <- a(
    "AZMet website", 
    href="https://staging.azmet.arizona.edu/", 
    target="_blank"
  )
  webpageCode <- a(
    "GitHub page", 
    href="https://github.com/uace-azmet/azmet-data-preview-and-download", 
    target="_blank"
  )
  webpageDataVariables <- a(
    "data variables", 
    href="https://staging.azmet.arizona.edu/about/data-variables", 
    target="_blank"
  )
  webpageNetworkMap <- a(
    "station locations", 
    href="https://staging.azmet.arizona.edu/about/network-map", 
    target="_blank"
  )
  webpageStationMetadata <- a(
    "station metadata", 
    href="https://staging.azmet.arizona.edu/station/az01", 
    target="_blank"
  )
 
  if (timeStep == "Hourly") {
    apiURL <- a(
      "api.azmet.arizona.edu", 
      href="https://api.azmet.arizona.edu/v1/observations/hourly", # Hourly data
      target="_blank"
    )
  } else {
      apiURL <- a(
        "api.azmet.arizona.edu", 
        href="https://api.azmet.arizona.edu/v1/observations/daily", # Daily data
        target="_blank"
      )
    }
  
  tableCaption <- htmltools::HTML(
    paste0(timeStep, " ", "AZMet data are from", " ", apiURL, ".", " ", "Table values from recent dates may be based on provisional data", ".", " ", "More information about", " ", webpageDataVariables, ",", " ", webpageNetworkMap, ",", " ", "and", " ", webpageStationMetadata, " ", "is available on the", " ", webpageAZMet, ".", " ", "Users of AZMet data and data applications assume all risks of its use", "."),
    "<br><br>",
    paste0("To cite the above AZMet data, please use: 'Arizona Meteorological Network (", todayYear, ") Arizona Meteorological Network (AZMet) Data. https:://azmet.arizona.edu. Accessed", " ", todayDate, "'"),
    "<br><br>",
    paste0("For information on how this webpage is put together, please visit the", " ", webpageCode, " ", "for this tool.")
    )
  
  return(tableCaption)
}