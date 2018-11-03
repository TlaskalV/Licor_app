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
 
 dataset_date_filtered_mode_ok <- reactive({
   dataset_date_filtered <- dataset_date_filtered()
   dataset_date_filtered_mode_ok <- dplyr::filter(dataset_date_filtered, Mode == 0) %>% gather(data_type, CO2_ppm, `CO2 Soil (ppm)`, `CO2 ATM (ppm)`) %>% mutate(flux_type = case_when(data_type == "CO2 Soil (ppm)" ~ "soil", data_type == "CO2 ATM (ppm)" ~ "atmospheric"))
 })
 
 dataset_date_filtered_mode_bad <- reactive({
   dataset_date_filtered <- dataset_date_filtered()
   dataset_date_filtered_mode_bad <- dplyr::filter(dataset_date_filtered, Mode != 0) %>% select(date_joined_lubridated, Mode)
 })
 
 # average flux atmospheric  
 flux_average_atm <- reactive({
   flux <- summarySE(dataset_date_filtered_mode_ok(), measurevar = "CO2_ppm", groupvars = "flux_type", conf.interval = 0.95)
   temp_upper <- flux[[1,3]]
 })
 
 # average flux soil  
 flux_average_soil <- reactive({
   flux <- summarySE(dataset_date_filtered_mode_ok(), measurevar = "CO2_ppm", groupvars = "flux_type", conf.interval = 0.95)
   temp_upper <- flux[[2,3]]
 })
 
 # average temperature  
 temperature_average <- reactive({
   dataset_date_filtered_mode_ok <- dataset_date_filtered_mode_ok()
   temp <- mean(dataset_date_filtered_mode_ok$`Temperature (C)`)
 })
 
 # flux type switch  
 sensor <- renderText({
   input$sensor
 })
 
 # ggplot  
 ggplot_final <- reactive({
   dataset_date_filtered_mode_ok <- dataset_date_filtered_mode_ok()
   dataset_date_filtered_mode_ok$flux_type <- factor(dataset_date_filtered_mode_ok$flux_type, levels = c("soil", "atmospheric"))
   flux_average_atm <- flux_average_atm()
   flux_average_soil <- flux_average_soil()
   #temperature_average <- temperature_average()
   sensor <- sensor()
   ggplot(data = dataset_date_filtered_mode_ok, aes(y = CO2_ppm, x = date_joined_lubridated)) +
   {if (input$plot_type == "soil") {
     geom_line(aes(colour = flux_type), size = 1.5, alpha = 0.75, subset(dataset_date_filtered_mode_ok, flux_type == "soil"))   
   } else {}} +
   {if (input$plot_type == "atmospheric") {
     geom_line(aes(colour = flux_type), size = 1.5, alpha = 0.75, subset(dataset_date_filtered_mode_ok, flux_type == "atmospheric"))   
   } else {}} +
   {if (input$plot_type == c("soil", "atmospheric")) {
     geom_line(aes(colour = flux_type), size = 1.5, alpha = 0.75, subset(dataset_date_filtered_mode_ok, flux_type == "soil" | flux_type == "atmospheric"))   
   } else {}} +
  scale_color_viridis_d()
 })
  
# rendering  
 output$contents1 <- renderPlot({
   ggplot_final()
 })
 output$contents2 <- renderText({
   temperature_average()
 })
# download  
  
  
}