

# Preview and download hourly and daily data by specified stations and date ranges from API database


# SETUP -------------------------


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


# SHINY APP: UI  -------------------------


ui <- fluidPage(
  
  title = "Data Preview and Download | Arizona Meteorological Network", # Edit this based on individual web app
  
  shiny::tags$html(
    lang="en", dir="ltr", prefix="content: http://purl.org/rss/1.0/modules/content/  dc: http://purl.org/dc/terms/  foaf: http://xmlns.com/foaf/0.1/  og: http://ogp.me/ns#  rdfs: http://www.w3.org/2000/01/rdf-schema#  schema: http://schema.org/  sioc: http://rdfs.org/sioc/ns#  sioct: http://rdfs.org/sioc/types#  skos: http://www.w3.org/2004/02/skos/core#  xsd: http://www.w3.org/2001/XMLSchema#", class="sticky-footer"
  ),
  
  shiny::tags$head(
    htmltools::includeHTML("www/head.html")
  ),
  
  shiny::tags$body(
    htmltools::includeHTML("www/body1.html"), 
    class="exclude-node-title layout-no-sidebars path-node node--type-az-flexible-page"
  ),
  
  shiny::tags$header(
    htmltools::includeHTML("www/header.html"), 
    id="header", class="header", role="banner", `aria-label`="Site header"
  ),
  
  shiny::tags$body(
    htmltools::includeHTML("www/body2.html")
  ),
  
  # <body> : Shiny app start -----
  sidebarLayout(
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
  ), # sidebarLayout()
  # <body> : Shiny app end -----
  
  shiny::tags$body(
    htmltools::includeHTML("www/body3.html")
  ),
  
  shiny::tags$footer(
    htmltools::includeHTML("www/footer.html"), 
    class = "site-footer"
  ),
  
  shiny::tags$body(
    htmltools::includeHTML("www/body4.html")
  )
  
) # fluidPage()


# SHINY APP: SERVER  --------------------


server <- function(input, output, session) {
  
  # Reactive events -----
  
  # AZMet data ELT
  dfAZMetData <- eventReactive(input$previewData, {
    if (input$startDate > input$endDate) {
      validate(
        "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
        errorClass = "datepickerBlank"
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
    if (input$startDate > input$endDate) {
      validate(
        "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
        errorClass = "datepickerBlank"
      )
    }
    
    fxnAZMetDataPreview(
      inData = dfAZMetData(), 
      timeStep = input$timeStep
    )
  })
  
  # Build table caption
  tableCaption <- eventReactive(input$previewData, {
    if (input$startDate > input$endDate) {
      validate(
        "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
        errorClass = "datepickerBlank"
      )
    }
    
    tableCaption <- fxnTableCaption(timeStep = input$timeStep)
  })
  
  # Build table title
  tableTitle <- eventReactive(input$previewData, {
    if (input$startDate > input$endDate) {
      validate(
        "Please select a 'Start Date' that is earlier than or the same as the 'End Date'.",
        errorClass = "datepicker"
      )
    }
  
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
    downloadButton("downloadTSV", label = "Download .tsv")
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
    req(dfAZMetData())
    helpText(em("Click or tap the button below to download a file of the previewed data with tab-separated values."))
  })
  
  output$tableCaption <- renderUI({
    tableCaption()
  })
  
  output$tableTitle <- renderUI({
    tableTitle()
  })
}


# SHINY APP: RUN  --------------------


shinyApp(ui, server)


# FIN  --------------------

