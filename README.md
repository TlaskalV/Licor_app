# Soil gas emission visualization
Plotting of soil CO<sub>2</sub> and CH<sub>4</sub> emission changes based on concentrations measured with [LI-COR LI-7810 Trace Gas Analyzer](https://www.licor.com/env/products/soil_flux/LI-7810).


<div align="right">
    <img src="/licor.jpg?raw=true" width="300px"</img>
</div>


## Table of contents

* [How to upload data](#data-upload)
* [Example plot](#example-plot)
* [Where to try app](#where-to-try-app)

## Data upload
Simply just upload **.txt** file obtained from the Trace Gas Analyzer ([see example txt file here](https://github.com/TlaskalV/Licor_app/blob/main/test_raw_data)). Any further table formatting is not necessary. Data can be easily filtered by date directly in the app.

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
