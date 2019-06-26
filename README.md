# Soil flux visualization
Plotting of soil CO<sub>2</sub> flux changes based on concentrations measured with [eosFD device](http://www.eosense.com/products/eosFD/) from [Eosense](http://www.eosense.com/).


<div align="right">
    <img src="/eosFD.jpg?raw=true" width="300px"</img> 
</div>


## Table of contents

* [How to upload data](#data-upload)
* [Example plots](#example-plots)
* [Where to try app](#where-to-try-app)

## Data upload
Simply just upload **.csv** file obtained from the eosFD device ([see example csv file here](https://github.com/Vojczech/Soil_flux_app/blob/master/test_raw_data.csv)). Any further table formatting is not necessary. Data can be easily filtered by date directly in the app.

App produces [hrbrthemes flavoured](https://github.com/hrbrmstr/hrbrthemes) plots of either CO<sub>2</sub> concentration in soil/atmosphere or CO<sub>2</sub> flux.

## Plot types

<div align="left">
    <img src="/soil_flux_2018-10-24_2018-11-02_flux.png?raw=true" width="600px"</img> 
</div>


<div align="left">
    <img src="/soil_flux_2018-10-24_2018-11-02_conc.png?raw=true" width="600px"</img> 
</div>


## Where to try app

There are two options to access the app:
* online web app hosted on [labenvmicro.shinyapps.io](https://labenvmicro.shinyapps.io/Soil_flux_app/) 
* or start your local installation of **R** language and paste following code which automatically downloads prerequisties and starts app:
```
install.packages(c("shiny", "shinythemes", "readr", "tidyverse", "Rmisc", "tools", "shinycssloaders", "showtext", "hrbrthemes", "devtools", "svglite"))
devtools::install_github("rstudio/fontawesome")
library(shiny)
runGitHub("Soil_flux_app", "Vojczech") 
```