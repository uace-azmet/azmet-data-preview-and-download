

# Preview and download hourly and daily data by specified stations and date ranges from API database


# Libraries
library(azmetr)
library(dplyr)
library(htmltools)
library(lubridate)
library(shiny)
library(vroom)

# Functions 
#source("./R/fxnABC.R", local = TRUE)

# Scripts
#source("./R/scr##DEF.R", local = TRUE)


# UI --------------------

ui <- htmltools::htmlTemplate(
  "azmet-shiny-template.html",
  
  sidebarLayout = sidebarLayout(
    position = "left",
    
    sidebarPanel(
      id = "sidebarPanel",
      width = 4,
      
      verticalLayout(
        helpText(em(
          "Select an AZMet station, specify the time step, and set dates for the period of interest. Then, click or tap 'Preview Data'."
        )),
        
        br(),
        selectInput(
          inputId = "station", 
          label = "AZMet Station",
          choices = stns[order(stns$stationName), ]$stationName,
          selected = "Aguila"
        ),
        
        selectInput(
          inputId = "timeStep", 
          label = "Time Step",
          choices = timeSteps,
          selected = "Hourly"
        ),
        
        dateInput(
          inputId = "startDate",
          label = "Start Date",
          value = Sys.Date() - 1,
          min = apiStartDate,
          max = Sys.Date() - 1,
          format = "MM d, yyyy",
          startview = "month",
          weekstart = 0, # Sunday
          width = "100%",
          autoclose = TRUE
        ),
        
        dateInput(
          inputId = "endDate",
          label = "End Date",
          value = Sys.Date() - 1,
          min = apiStartDate,
          max = Sys.Date() - 1,
          format = "MM d, yyyy",
          startview = "month",
          weekstart = 0, # Sunday
          width = "100%",
          autoclose = TRUE
        ),
        
        br(),
        actionButton(
          inputId = "previewData", 
          label = "Preview Data",
          class = "btn btn-block btn-blue"
        )
      )
    ), # sidebarPanel()
    
    mainPanel(
      id = "mainPanel",
      width = 8,
      
      fluidRow(
        column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "tableTitle"))
      ), 
      
      br(),
      fluidRow(
        column(width = 11, align = "left", offset = 1, tableOutput(outputId = "dataTablePreview"))
      ), 
      
      fluidRow(
        column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "tableFooter"))
      ),
      
      br(),
      fluidRow(
        column(width = 11, align = "left", offset = 1, uiOutput(outputId = "downloadButtonTSV"))
      ),
      
      br(), br(),
      fluidRow(
        column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "tableCaption"))
      ),
      br()
    ) # mainPanel()
  ) # sidebarLayout()
) # htmltools::htmlTemplate()


# Server --------------------

server <- function(input, output, session) {
  
  # Reactive events -----
  
  # AZMet data ELT
  dfAZMetData <- eventReactive(input$previewData, {
    if (input$startDate > input$endDate) {
      validate(
        "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
        errorClass = "datepicker"
      )
    }
    
    idPreview <- showNotification(
      ui = "Preparing data preview . . .", 
      action = NULL, 
      duration = NULL, 
      closeButton = FALSE, 
      type = "message"
    )
    
    on.exit(removeNotification(idPreview), add = TRUE)
    
    fxnAZMetDataELT(
      station = input$station, 
      timeStep = input$timeStep, 
      startDate = input$startDate, 
      endDate = input$endDate
    )
  })
  
  # Format AZMet data for HTML table preview
  dfAZMetDataPreview <- eventReactive(input$previewData, {
    #if (input$startDate > input$endDate) {
    #  validate(
    #    "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
    #    errorClass = "datepickerBlank"
    #  )
    #}
    
    fxnAZMetDataPreview(
      inData = dfAZMetData(), 
      timeStep = input$timeStep
    )
  })
  
  # Build table caption
  tableCaption <- eventReactive(input$previewData, {
  #  if (input$startDate > input$endDate) {
  #    validate(
  #      "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
  #      errorClass = "datepickerBlank"
  #    )
  #  }
    
    tableCaption <- fxnTableCaption(timeStep = input$timeStep)
  })
  
  # Build table title
  tableTitle <- eventReactive(input$previewData, {
  #  if (input$startDate > input$endDate) {
  #    validate(
  #      "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
  #      errorClass = "datepicker"
  #    )
  #  }
  
    tableTitle <- fxnTableTitle(
      station = input$station,
      timeStep = input$timeStep,
      startDate = input$startDate,
      endDate = input$endDate
    )
  })
  
  # Outputs -----
  
  output$dataTablePreview <- renderTable(
    expr = dfAZMetDataPreview(), 
    striped = TRUE, 
    hover = TRUE, 
    bordered = FALSE, 
    spacing = "xs", 
    width = "auto", 
    align = "c", 
    rownames = FALSE, 
    colnames = TRUE, 
    digits = NULL, 
    na = "na"
  )
  
  output$downloadButtonTSV <- renderUI({
    req(dfAZMetData())
    downloadButton("downloadTSV", label = "Download .tsv", class = "btn btn-default btn-blue", type = "button")
  })
  
  output$downloadTSV <- downloadHandler(
    filename = function() {
      paste0(input$station, input$timeStep, input$startDate, "to", input$endDate, ".tsv")
    },
    content = function(file) {
      vroom::vroom_write(x = dfAZMetData(), file = file, delim = "\t")
    }
  )
  
  output$tableFooter <- renderUI({
    #req(dfAZMetData())
    helpText(em("Scroll over the table to view additional rows and columns. Click or tap the button below to download a file of the previewed data with tab-separated values."))
  })
  
  output$tableCaption <- renderUI({
    req(dfAZMetData())#
    tableCaption()
  })
  
  output$tableTitle <- renderUI({
    #req(dfAZMetData())#
    tableTitle()
  })
}


# Run --------------------

shinyApp(ui, server)