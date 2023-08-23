# fxnTableTitle: Build title for HTML table based on user input
# 
# @param: station - station selection by user
# @param: timeStep - AZMet data time step
# @param: startDate - data download start date selection by user
# @param: endDate - data download end date selection by user
# @return: tableTitle - table title for HTML table based on user input
# 
fxnTableTitle <- function(station, timeStep, startDate, endDate) {
  tableTitle <- HTML(
    "<h3 style='color: #343a40; font-weight: bold; margin-top: 0; margin-bottom: 0;'>", 
    paste("Preview of", timeStep, "Data from the AZMet", station, "station", sep = " "), 
    "</h3>", 
    "<p style='color: #343a40; font-weight: plain; margin-top: 0;'>", 
    paste("From", gsub(" 0", " ", format(startDate, "%B %d, %Y")), "through", gsub(" 0", " ", format(endDate, "%B %d, %Y")), sep = " "), 
    "</p>"
  )
  
  return(tableTitle)
}