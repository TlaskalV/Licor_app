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
library(broom)

fluidPage(
  theme = shinytheme("sandstone"),
  title = "Soil gas flux data",
  plotOutput("CH4_plot", brush = brushOpts(id = "plot_brush", direction = "x")) %>% withSpinner(type = getOption("spinner.type", default = 4)),
  plotOutput("CO2_plot") %>% withSpinner(type = getOption("spinner.type", default = 4)),
  hr(),
  fluidRow(
    column(3,
           h3("Soil gas flux data"),
           h4("1. upload"),
           fileInput('csv_data', 
                     label = list(icon("table"), "Upload csv file"),
                     accept = c('sheetName', 'header'), 
                     multiple = FALSE),
           p(a(list(icon("github"), "Source code"), href = "https://github.com/TlaskalV/Licor_app", target="_blank"))
    ),
    column(4, 
           h4("2. select linear part of the upper plot"),
           tableOutput("test")
    ),
    column(4,
           h4("3. linear model"),
           uiOutput("ui"),
           tableOutput("lm")
    )
  )
)
