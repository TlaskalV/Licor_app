# Soil gas emission visualization
Plotting of soil CO<sub>2</sub> and CH<sub>4</sub> emission changes based on concentrations measured with [LI-COR LI-7810 Trace Gas Analyzer](https://www.licor.com/env/products/soil_flux/LI-7810).


<div align="left">
    <img src="/gif_app.gif?raw=true" width="700px"</img>
</div>


## Table of contents

* [Instructions](#instructions)
* [Example plot](#plot)
* [Where to try app](#where-to-try-app)

## Instructions
Simply just upload **.txt** file obtained from the Trace Gas Analyzer (see example txt file in this repo). Any further table formatting is not necessary.

1. Upload data
2. Select area of interest in the upper plot
3. See statistics of linear regression

## Plot

<div align="left">
    <img src="/example_plot.png?raw=true" width="600px"</img>
</div>

## Where to try app

There are two options to access the app:
* online web app hosted on [labenvmicro.shinyapps.io](https://labenvmicro.shinyapps.io/Licor_emissions_app/)
* or start your local installation of **R** language and paste following code which automatically downloads prerequisties and starts app:
```
install.packages(c("shiny", "shinythemes", "readr", "tidyverse", "Rmisc", "tools", "shinycssloaders", "showtext", "devtools", "svglite", "broom"))
library(shiny)
runGitHub("Licor_app", "TlaskalV")
```
