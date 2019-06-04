# load up the packages
library(shiny)
library(shinythemes)
library(shinycssloaders)
library(readr)
library(tidyverse)
library(Rmisc)
library(tools)
require(showtext)
library(hrbrthemes)
library(fontawesome)

# download a webfont
font_add_google(name = "Roboto Condensed", family = "Roboto Condensed",
                regular.wt = 400, bold.wt = 700)
showtext_auto()

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
           textInput("plot_title", 'Write plot title',
                     placeholder = "e.g. nitrogen addition treatment"),
           dateRangeInput('date_range',
                          label = list(icon("calendar-alt"), "Filter by date"),
                          start = Sys.Date() - 3, end = Sys.Date(),
                          separator = " to ", format = "yy/mm/dd",
                          startview = 'month', language = 'en', weekstart = 1
           ),
           radioButtons("x_scale", "Label X axis by:", 
                        c("day", "week", "month", "year"), 
                        inline = TRUE,
                        selected = "week")
    ),
    column(4,
           h4("3."),
           radioButtons("plot_type", 
                        label = list(icon("chart-area"), "Choose plot type"), 
                        choices = c("atmospheric/soil concentration" = "atmo_soil", "soil flux" = "flux"),
                        selected = c("flux")),
           uiOutput("ui"),
           br(),
           downloadButton("download_plot", 
                          "Download final plot")
    )
  )
)
