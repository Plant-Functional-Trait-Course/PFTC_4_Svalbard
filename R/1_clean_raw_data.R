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
library(tidyverse)
library(readxl)
library(lubridate)

pn <- . %>% print(n = Inf)

library(PFTCFunctions)
all_codes <- PFTCFunctions::get_PFTC_envelope_codes(seed = 32)

## Download all data from OSF
source("R/clean_raw_data/0_download_raw_data.R")

## Clean data and make clean files

# climate
source("R/Functions/Clean_ITEX_Climate.R")
source("R/Functions/Clean_Gradient_Climate.R")

# community
source("R/Functions/Clean_ITEX_Community.R")
source("R/Functions/Clean_Gradient_Community.R")

# traits
source("R/clean_raw_data/Functions/Clean_Traits.R")

# soil
source("R/Functions/Clean_Gradient_Soil_CN.R")
