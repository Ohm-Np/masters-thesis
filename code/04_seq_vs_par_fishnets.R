## 04: sequential vs parallelization (Fishnets)
# Author: Om Prakash Bhandari
# Last Edit: 2022-06-10
# Note: contains scripts for parallel processing
# for sequential routine: refer to code 01 and 02

# required libraries
library(sf)
library(terra)
library(exactextractr)
library(pbmcapply)

# load raster
r <- rast("../test/rasters/rast_0-1.tif")

## (A) terra zonal ----------------------------------------------------------

# function only for fishnet polygons
progrid <- function(i, r, n) {

  fishnet <- read_sf(paste0("data/fishnet_polygons/fishnet_",i,"_sqkm.gpkg"))
  fishnet <- st_transform(fishnet, 4326)
  fishnet <- tibble::rowid_to_column(fishnet, "UID")
  r_crop <- terra::crop(r, fishnet)
  t1 <- Sys.time()
  df <- pbmclapply(1:nrow(fishnet), function(j) {
    v <- vect(fishnet[j, ])
    mask <- terra::mask(r_crop, v)
    rasterize <- terra::rasterize(v, mask, "UID", touches=T)
    terra_zonal <- terra::zonal(mask, rasterize, 'mean', na.rm = T)
  },mc.cores = n)
  t2 <- Sys.time()
  dt <- as.numeric(t2-t1, units="secs")
  print(dt)
}

# test run
progrid(i=10000, r=r, n=4)


## (B) terra extract ----------------------------------------------------------

# function only for fishnet polygons
progrid <- function(i, r, n) {

  fishnet <- read_sf(paste0("data/fishnet_polygons/fishnet_",i,"_sqkm.gpkg"))
  fishnet <- st_transform(fishnet, 4326)
  fishnet <- tibble::rowid_to_column(fishnet, "UID")
  r_crop <- terra::crop(r, fishnet)
  t1 <- Sys.time()
  df <- pbmclapply(1:nrow(fishnet), function(j) {
    v <- vect(fishnet[j, ])
    terra::extract(r_crop, v, 'mean', na.rm = T)
  },mc.cores = n)
  t2 <- Sys.time()
  dt <- as.numeric(t2-t1, units="secs")
  print(dt)
}

# test run
progrid(i=10000, r=r, n=4)


## (C) exact extract ----------------------------------------------------------

# function only for fishnet polygons
progrid <- function(i, r, n) {

  fishnet <- read_sf(paste0("data/fishnet_polygons/fishnet_",i,"_sqkm.gpkg"))
  fishnet <- st_transform(fishnet, 4326)
  fishnet <- tibble::rowid_to_column(fishnet, "UID")
  r_crop <- terra::crop(r, fishnet)
  t1 <- Sys.time()
  df <- pbmclapply(1:nrow(fishnet), function(j) {
    exact_extract(r_crop, fishnet[j, ], 'mean')
  },mc.cores = n)
  t2 <- Sys.time()
  dt <- as.numeric(t2-t1, units="secs")
  print(dt)
}

# test run
progrid(i=10000, r=r, n=4)
