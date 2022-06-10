## Processing rasters/vectors using package mapme.biodiversity
# Author: Om Prakash Bhandari
# Last Edit: 2022-06-10

# required libraries
library(sf)
library(terra)
library(mapme.biodiversity)

## ESA Landcover ----------------------------------------------------------------
# to change: number of cores ...
# to change: engine ...
t1 <- Sys.time()
result <- sf::read_sf("../sample_wdpa.gpkg") %>%
  st_cast(to = "POLYGON") %>%
  init_portfolio(
    years = 2015:2016,
    add_resources = FALSE,
    cores = 1,
    verbose = FALSE
  ) %>%
  get_resources(resources = "esalandcover") %>%
  calc_indicators(indicators = "landcover", engine = "exactextract") %>%
  tidyr::unnest(landcover)
t2 <- Sys.time()
td <- t2-t1
td

## Terrain Ruggedness Index ------------------------------------------------------
## Net Forest Carbon Flux---------------------------------------------------------
## Mangrove Extent----------------------------------------------------------------
## Terrestrial Ecoregions of the World--------------------------------------------
