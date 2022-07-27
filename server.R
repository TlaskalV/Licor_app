# load up the packages
library(shiny)
library(shinythemes)
library(readr)
library(tidyverse)
library(Rmisc)
library(tools)
require(showtext)
library(svglite)


function(input, output) {
  
  dataset_flux <- reactive({
    validate(
      need(input$csv_data != "", "Please upload a csv file with soil flux data")
    )
    infile = input$csv_data  
    
    if (is.null(infile))
      return(NULL)
    
    read_delim(infile$datapath, delim = "\t", escape_double = FALSE, 
               col_names = FALSE, skip = 7) %>% 
      setNames(c("DATAH",	"SECONDS",	"NANOSECONDS",	"NDX",	'DIAG',	'REMARK',	'DATE',	'TIME',	'H2O',	'CO2',	'CH4',	'CAVITY_P',	'CAVITY_T',	'LASER_PHASE_P',	'LASER_T',	'RESIDUAL',	'RING_DOWN_TIME',	'THERMAL_ENCLOSURE_T',	'PHASE_ERROR',	'LASER_T_SHIFT',	'INPUT_VOLTAGE',	'CHK'))
  })

# get name of uploaded file
  file_name <- reactive({
    inFile <- input$csv_data
    
    if (is.null(inFile))
      return(NULL) else return (tools::file_path_sans_ext(inFile$name))
  })
  
# merge daytime columns  
  dataset_date_lubridated <- reactive({
    dataset_flux <- dataset_flux()
    dataset_date_lubridated <- mutate(dataset_flux, date_joined_lubridated = lubridate::ymd_hms(paste(DATE, TIME), tz = "UTC"))
  })
  
# filter by date, +1 is important due to issues with timezone setting
# filtering is based only on days
  dataset_date_filtered_mode_ok <- reactive({
   dataset_date_lubridated <- dataset_date_lubridated()
   dataset_date_filtered_mode_ok <- dplyr::filter(dataset_date_lubridated, DATE >= as.vector(paste(input$date_range[1], input$time_range[1], sep = " ")) & DATE <= as.vector(paste((input$date_range[2]+1), input$time_range[2], sep = " ")))
  })
 
 # ggplot  
 ggplot_final <- reactive({
   dataset_date_filtered_mode_ok <- dataset_date_filtered_mode_ok()
   ggplot(data = dataset_date_filtered_mode_ok, aes(y = CH4, x = date_joined_lubridated)) +
     geom_point(size = 1, aes(colour = REMARK)) +
     theme(axis.text.x = element_text(angle = 90))
   })
  
# rendering plot 
 output$contents1 <- renderPlot({
   ggplot_final()
 })
 
output$table1 <- renderTable({ dataset_date_filtered_mode_ok() })

}