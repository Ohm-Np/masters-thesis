## Processing vectors
# Author: Om Prakash Bhandari
# Last Edit: 2022-06-10

# required libraries
library(sf)
library(terra)

# load polygons
pa <- read_sf("../sample_wdpa.gpkg")
eco <- read_sf("../sample_eco.gpkg")

## terra -------------------------------------------------------------

# ecoregions first
t1 <- Sys.time()
pa <- vect("../sample_wdpa.gpkg")
eco <- vect("../sample_eco.gpkg")
terra_ep <- terra::intersect(eco, pa)
t2 <- Sys.time()
dt_terra_eco_pa <- as.numeric(t2 - t1, units = "secs")

# pa polygons first
t1 <- Sys.time()
pa <- vect("../sample_wdpa.gpkg")
eco <- vect("../sample_eco.gpkg")
terra_pe <- terra::intersect(pa, eco)
t2 <- Sys.time()
dt_terra_pa_eco <- as.numeric(t2 - t1, units = "secs")


## sf ----------------------------------------------------------------

# pa polygons first
t1 <- Sys.time()
pa <- read_sf("../sample_wdpa.gpkg")
eco <- read_sf("../sample_eco.gpkg")
sf_pe <- st_intersection(pa, eco)
t2 <- Sys.time()
dt_sf_pa_eco <- as.numeric(t2 - t1, units = "secs")

# ecoregions first
t1 <- Sys.time()
pa <- read_sf("../sample_wdpa.gpkg")
eco <- read_sf("../sample_eco.gpkg")
sf_ep <- st_intersection(eco, pa)
t2 <- Sys.time()
dt_sf_eco_pa <- as.numeric(t2 - t1, units = "secs")
