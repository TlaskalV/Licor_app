library(shiny)
library(shinythemes)
library(readr)
library(tidyverse)
library(Rmisc)
library(tools)
library(gridExtra)
library(grid)

function(input, output) {
  
  dataset_flux <- reactive({
    validate(
      need(input$csv_data != "", "Please upload a csv file with temperature data")
    )
    infile = input$csv_data  
    
    if (is.null(infile))
      return(NULL)
    
    read_delim(infile$datapath, delim = ",", escape_double = FALSE, col_names = TRUE, na = "NA", trim_ws = TRUE, locale = locale( tz = "UTC"))
  })

# get name of uploaded file
  file_name <- reactive({
    inFile <- input$csv_data
    
    if (is.null(inFile))
      return(NULL) else return (tools::file_path_sans_ext(inFile$name))
  })
  
# merge daytime columns  
  dataset_date_joined <- reactive({
    dataset_flux <- dataset_flux()
    dataset_date_joined <- mutate(dataset_flux, date_joined = paste(dataset_flux$Month, dataset_flux$Day, dataset_flux$Year, dataset_flux$Time))
  })
  
# lubridate merged column
  dataset_date_lubridated <- reactive({
    dataset_date_joined <- dataset_date_joined()
    dataset_date_lubridated <- mutate(dataset_date_joined, date_joined_lubridated = lubridate::mdy_hms(dataset_date_joined$date_joined, tz = "UTC"))
  })
  
# filter by date, +1 is important due to issues with timezone setting
# filtering is based only on days
 dataset_date_filtered <- reactive({
   dataset_date_lubridated <- dataset_date_lubridated()
    dataset_date_filtered <- dplyr::filter(dataset_date_lubridated, date_joined_lubridated >= input$date_range[1] & date_joined_lubridated <= (input$date_range[2]+1)) %>%
      select(-date_joined)
  })
  
# rendering  
  output$contents3 <- renderTable({
    tail(dataset_date_filtered(), 5)
  })
  
# download  
  
  
}