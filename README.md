# Soil flux visualization
Plotting of soil CO<sub>2</sub> flux changes based on concentrations measured with [eosFD device](http://www.eosense.com/products/eosFD/).

Simply just upload **.csv** file obtained from the eosFD device. Excel table formatting is not necessary. Data can be easily filtered by date directly in the app.

App produces nicely visualized plots. 

![example plot](/soil_flux_2018-10-24_2018-11-02.png) 
<img src="/soil_flux_2018-10-24_2018-11-02.png" width="300">

---
Try it on [shinyapps.io](https://labenvmicro.shinyapps.io/Soil_flux_app/) or start R and type:
```
install.packages(c("shiny", "shinythemes", "readr", "tidyverse", "Rmisc", "tools", "shinycssloaders"))
library(shiny)
runGitHub("Soil_flux_app", "Vojczech") 
```
---

 
