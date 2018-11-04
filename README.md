# Soil flux visualization
Plotting of soil CO~2~ flux changes based on concentrations measured with [eosFD device](http://www.eosense.com/products/eosFD/).

Simply just upload **.csv** file obtained from the eosFD device. Excel table formatting is not necessary. Data can be easily fileterd by date directly in the app.

App produces nicely edited plots. 

![example plot](/soil_flux_2018-10-24_2018-11-02.pdf) 

---
Try it on [shinyapps.io](https://labenvmicro.shinyapps.io/Soil_flux_app/) or start R and type:
```
install.packages(c("shiny", "shinythemes", "readr", "tidyverse", "Rmisc", "tools", "shinycssloaders"))
library(shiny)
runGitHub("Soil_flux_app", "Vojczech") 
```
---

 
