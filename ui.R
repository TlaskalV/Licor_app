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
  plotOutput("contents1", brush = "plot_brush") %>% withSpinner(type = getOption("spinner.type", default = 4)),
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
           tableOutput("info")
    ),
    column(4,
           h4("3."),
           uiOutput("ui"),
           tableOutput("table1")
    )
  )
)
