## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  rmarkdown.html_vignette.check_title = FALSE
)

## ---- eval=FALSE--------------------------------------------------------------
#  ## Published (CRAN) version
#  install.packages("rankrate")
#  
#  ## Development (Github) version
#  # install.packages("devtools") # uncomment if you haven't installed 'devtools' before
#  devtools::install_github("pearce790/rankrate")

## ----echo=FALSE,results='hide',message=FALSE,warning=FALSE--------------------
devtools::install_github("pearce790/rankrate")

## -----------------------------------------------------------------------------
library(rankrate)

