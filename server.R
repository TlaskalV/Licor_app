library(shiny)
library(shinythemes)
library(readr)
library(tidyverse)
library(Rmisc)
library(tools)

function(input, output) {
  
  dataset_flux <- reactive({
    validate(
      need(input$csv_data != "", "Please upload a csv file with soil flux data")
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

# timepoints with Mode=0 filtered  
 dataset_date_filtered_mode_ok <- reactive({
   dataset_date_filtered <- dataset_date_filtered()
   dataset_date_filtered_mode_ok <- dplyr::filter(dataset_date_filtered, Mode == 0) %>% gather(data_type, CO2_ppm, `CO2 Soil (ppm)`, `CO2 ATM (ppm)`) %>% mutate(flux_type = case_when(data_type == "CO2 Soil (ppm)" ~ "soil", data_type == "CO2 ATM (ppm)" ~ "atmospheric"))
 })
 
# timepoints with Mode!=0 filtered
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
 
 # ggplot  
 ggplot_final <- reactive({
   dataset_date_filtered_mode_ok <- dataset_date_filtered_mode_ok()
   dataset_date_filtered_mode_ok$flux_type <- factor(dataset_date_filtered_mode_ok$flux_type, levels = c("soil", "atmospheric"))
   flux_average_atm <- flux_average_atm()
   flux_average_soil <- flux_average_soil()
   #temperature_average <- temperature_average()
   ggplot(data = dataset_date_filtered_mode_ok, aes(y = CO2_ppm, x = date_joined_lubridated)) +
   {if (input$plot_type == "atmospheric") {
     geom_line(aes(colour = flux_type), size = 1, alpha = 0.75, subset(dataset_date_filtered_mode_ok, flux_type == "atmospheric"))   
   } else {}} +
   {if (input$plot_type == "soil") {
     geom_line(aes(colour = flux_type), size = 1, alpha = 0.75, subset(dataset_date_filtered_mode_ok, flux_type == "soil"))   
   } else {}} +
   {if (input$plot_type == c("atmospheric", "soil")) {
     geom_line(aes(colour = flux_type), size = 1, alpha = 0.75, subset(dataset_date_filtered_mode_ok, flux_type == "atmospheric" | flux_type == "soil"))   
   } else {}} +
  scale_color_viridis_d() +
  {if (input$x_scale == "day") {
    scale_x_datetime(date_breaks = "1 day")
  } else {}} +
  {if (input$x_scale == "week") {
    scale_x_datetime(date_breaks = "1 week")
  } else {}} +
  {if (input$x_scale == "month") {
    scale_x_datetime(date_breaks = "1 month")
  } else {}} +
  {if (input$x_scale == "year") {
    scale_x_datetime(date_breaks = "1 year")
  } else {}} +
  labs(title = input$plot_title, subtitle = paste("mean atmospheric concentration - ", round(flux_average_atm, digits = 1), "ppm\n", "mean soil flux concentration - ", round(flux_average_soil, digits = 1), "ppm"), x = "date", y = expression("CO"[2]^{}*" (ppm)")) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, size = 10, colour = "black"), axis.text.y = element_text(size = 13, colour = "black"), axis.title = element_text(size = 14, face = "bold", colour = "black"), plot.title = element_text(size = 14, face = "bold", colour = "black"),  plot.subtitle = element_text(colour = "black"), panel.grid.minor.y = element_blank(), legend.position = "top", legend.text = element_text(size = 11, colour = "black", face = "plain"), legend.title = element_text(size = 12, colour = "black", face = "bold"), legend.key.size = unit(3, 'lines'), legend.spacing.x = unit(0.3, 'cm'), legend.direction = "horizontal")
 })
  
# rendering plot 
 output$contents1 <- renderPlot({
   ggplot_final()
 })
 
# download, name of the file according to the date  
 output$download_plot <- downloadHandler(
     filename = function() {
       paste("soil_flux_", input$date_range[1], "_", input$date_range[2], sep = "", ".pdf")
     },
   content = function(file) {
     ggsave(file, plot = ggplot_final(), device = "pdf", dpi = 300, height = 210, width = 297, units = "mm")
   }
 )
  
}