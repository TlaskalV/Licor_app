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
  dataset_date_filtered_mode_ok <- reactive({
    dataset_flux <- dataset_flux()
    dataset_date_filtered_mode_ok <- mutate(dataset_flux, date_joined_lubridated = lubridate::ymd_hms(paste(DATE, TIME), tz = "UTC")) %>% 
      dplyr::mutate(obs_count = dplyr::row_number())
  })

# rendering plot 
 output$contents1 <- renderPlot({
   dataset_date_filtered_mode_ok <- dataset_date_filtered_mode_ok()
   ggplot(data = dataset_date_filtered_mode_ok, aes(y = CH4, x = date_joined_lubridated)) +
     geom_point(size = 1, aes(colour = REMARK)) +
     theme(axis.text.x = element_text(angle = 90))
 })

  data <- reactive({
  dataset_date_filtered_mode_ok <- dataset_date_filtered_mode_ok()
   brushedPoints(dataset_date_filtered_mode_ok, input$plot_brush)
 })
  
### linear model
  linear_model_ch4 <- reactive({
    data <- data()
    model_ch4 <- lm(data = data, CH4~obs_count)
  })
  
  
  linear_model_co2 <- reactive({
    data <- data()
    model_co2 <- lm(data = data, CO2~obs_count)
  })
  
  out_linear_models <- reactive({
    model_ch4 <- linear_model_ch4()
    model_co2 <- linear_model_co2()
    slope <- tidy(model_ch4) %>% 
      filter(term == "obs_count") %>% 
      mutate(gas = "ch4") %>% 
      add_row(tidy(model_co2) %>% 
                filter(term == "obs_count") %>% 
                mutate(gas = "co2")) %>% 
      select(-term)
  })
 
 output$info <- renderTable({
   data()
   })
 
 output$lm <- renderTable({
   out_linear_models()
 })
 
 
output$table1 <- renderTable({ dataset_date_filtered_mode_ok() })

}