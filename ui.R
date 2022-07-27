# load up the packages
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(readr)
library(tidyverse)
library(Rmisc)
library(tools)
require(showtext)
library(fontawesome)

fluidPage(
  theme = shinytheme("sandstone"),
  title = "Soil CO\u2082 flux data",
  plotOutput("contents1") %>% withSpinner(type = getOption("spinner.type", default = 4)),
  hr(),
  fluidRow(
    column(3,
           h3("Soil CO\u2082 flux data"),
           h4("1."),
           fileInput('csv_data', 
                     label = list(icon("table"), "Upload csv file"),
                     accept = c('sheetName', 'header'), 
                     multiple = FALSE),
           p(a(list(icon("github"), "Source code"), href = "https://github.com/Vojczech/Soil_flux_app", target="_blank"))
    ),
    column(4, 
           h4("2."),
           offset = 1,
           dateRangeInput('date_range',
                          label = list(icon("calendar-alt"), "Filter by date"),
                          start = Sys.Date() - 3, end = Sys.Date(),
                          separator = " to ", format = "yy-mm-dd",
                          startview = 'month', language = 'en', weekstart = 1
           ),
           sliderInput(
             "time_range",
             label = "Select time",
             min = lubridate::origin,
             max = lubridate::origin + lubridate::days(1) - lubridate::seconds(1),
             value = c(lubridate::origin, lubridate::origin + lubridate::days(1) - lubridate::seconds(1)),
             step = 5 * 60,
             timeFormat = "%H:%M",
             timezone = "UTC",
             ticks = TRUE
           ),
    ),
    column(4,
           h4("3."),
           uiOutput("ui"),
           tableOutput("table1")
    )
  )
)
