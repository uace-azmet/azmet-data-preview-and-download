# fxnTableCaption: Build caption for HTML table based on user input
# 
# @param: timeStep - AZMet data time step
# @return: tableCaption - table caption for HTML table based on user input
# 
fxnTableCaption <- function(timeStep) {
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
  webpageAZMet <- a(
    "AZMet website", 
    href="https://staging.azmet.arizona.edu/", 
    target="_blank"
  )
  
  # Hourly
  if (timeStep == "Hourly") {
    apiURL <- a(
      "api.azmet.arizona.edu", 
      href="https://api.azmet.arizona.edu/v1/observations/hourly", 
      target="_blank"
    )
    
    tableCaption <- HTML(
      "<p style='color: #343a40; font-weight: plain; margin-top: 0;'>", 
      paste0(timeStep, " ", "AZMet data are from", " ", apiURL, ".", " ", "Table values from recent dates may be based on provisional data", ".", " ", "More information about", " ", webpageDataVariables, ",", " ", webpageNetworkMap, ",", " ", "and", " ", webpageStationMetadata, " ", "is available on the", " ", webpageAZMet, ".", " ", "Users of AZMet data and data applications assume all risks of its use", ".")
    )
  }
  
  # Daily
  if (timeStep == "Daily") {
    apiURL <- a(
      "api.azmet.arizona.edu", 
      href="https://api.azmet.arizona.edu/v1/observations/daily", 
      target="_blank"
    )
    
    tableCaption <- HTML(
      "<p style='color: #343a40; font-weight: plain; margin-top: 0;'>", 
      paste0(timeStep, " ", "AZMet data are from", " ", apiURL, ".", " ", "Table values from recent dates may be based on provisional data", ".", " ", "More information about", " ", webpageDataVariables, ",", " ", webpageNetworkMap, ",", " ", "and", " ", webpageStationMetadata, " ", "is available on the", " ", webpageAZMet, ".", " ", "Users of AZMet data and data applications assume all risks of its use", ".")
    )
  }
  
  return(tableCaption)
}