# fxnTableTitle: Build title for HTML table based on user input
# 
# @param: station - station selection by user
# @param: timeStep - AZMet data time step
# @return: tableTitle - table title for HTML table based on user input


fxnTableTitle <- function(station, timeStep) {
  tableTitle <- 
    htmltools::h4(
      htmltools::HTML(
        paste(
          "Preview of", timeStep, "Data from the AZMet", station, "station", 
          sep = " "
        ),
      ),
      
      class = "table-title"
    )
  
  return(tableTitle)
}