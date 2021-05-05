####################################
#### CLEAN DATA ####
####################################

# Install packages and load libraries
library("tidyverse")
library("lubridate")
library("readxl")
library("data.table")
library("stringr")
library("R.utils")
#devtools::install_github("gustavobio/tpldata")
#devtools::install_github("gustavobio/tpl")
library("tpl")
library("taxize")
library("googlesheets4")
library("broom")

pn <- . %>% print(n = Inf)

## Download all data from OSF
source("R/clean_raw_data/0_download_raw_data.R")

## Clean data and make clean files

# climate
source("R/clean_raw_data/Functions/Clean_ITEX_Climate.R")

# community
source("R/clean_raw_data/Functions/Clean_ITEX_Community.R")

# traits
source("R/clean_raw_data/Functions/Clean_Traits.R")
