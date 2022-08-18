## 03: sequential vs parallelization (WDPA)
# Author: Om Prakash Bhandari
# Last Edit: 2022-06-10
# Note: contains scripts for sequential and parallel processing
# for single asset routine: refer to code 01 and 02

# required libraries
library(sf)
library(terra)
library(exactextractr)
library(pbmcapply)

## (A) terra zonal ----------------------------------------------------

r <- rast("../test/rasters/bolivia/rast_0-0005.tif")

# function only for pa polygons
pronow <- function(p, r, n) {
  t1 <- Sys.time()
  df <- pbmclapply(1:nrow(p), function(i) {
    v <- vect(p[i, ])
    mask <- terra::mask(r, v)
    rasterize <- terra::rasterize(v, mask, "WDPAID", touches=T)
    terra_zonal <- terra::zonal(mask, rasterize, 'mean', na.rm = T)
  },mc.cores = n)
  t2 <- Sys.time()
  dt <- as.numeric(t2-t1, units="secs")
  print(dt)
}

# function only for fishnet polygons
progrid <- function(r, n) {
  p <- read_sf("../sample_wdpa-fishnets.gpkg")
  t1 <- Sys.time()
  df <- pbmclapply(1:nrow(p), function(i) {
    v <- vect(p[i, ])
    mask <- terra::mask(r, v)
    rasterize <- terra::rasterize(v, mask, "poly_id", touches=T)
    terra_zonal <- terra::zonal(mask, rasterize, 'mean', na.rm = T)
  },mc.cores = n)
  t2 <- Sys.time()
  dt <- as.numeric(t2-t1, units="secs")
  print(dt)
}

# wdpa
p <- read_sf("../sample_wdpa.gpkg")
for (n in c(1,4,8,16)) {
  pronow(p, r, n)
}

# simplified wdpa
p <- read_sf("../sample_simp-wdpa.gpkg")
for (n in c(1,4,8,16)) {
  pronow(p, r, n)
}

# grid
for (n in c(1,4,8,16)) {
  progrid(r, n)
}


## (B) terra extract --------------------------------------------------

r <- rast("../test/rasters/bolivia/rast_0-0005.tif")

# function only for pa polygons
pronow <- function(p, r, n) {
  t1 <- Sys.time()
  df <- pbmclapply(1:nrow(p), function(i) {
    v <- vect(p[i, ])
    terra::extract(r, v, 'mean', na.rm = T)
  },mc.cores = n)
  t2 <- Sys.time()
  dt <- as.numeric(t2-t1, units="secs")
  print(dt)
}

# function only for fishnet polygons
progrid <- function(r, n) {
  p <- read_sf("../sample_wdpa-fishnets.gpkg")
  t1 <- Sys.time()
  df <- pbmclapply(1:nrow(p), function(i) {
    v <- vect(p[i, ])
    terra::extract(r, v, 'mean', na.rm = T)
  },mc.cores = n)
  t2 <- Sys.time()
  dt <- as.numeric(t2-t1, units="secs")
  print(dt)
}

# wdpa
p <- read_sf("../sample_wdpa.gpkg")
for (n in c(1,4,8,16)) {
  pronow(p, r, n)
}

# simplified wdpa
p <- read_sf("../sample_simp-wdpa.gpkg")
for (n in c(1,4,8,16)) {
  pronow(p, r, n)
}

# grid
for (n in c(1,4,8,16)) {
  progrid(r, n)
}


## (C) exact extract ----------------------------------------------------

r <- rast("../test/rasters/bolivia/rast_0-1.tif")

# function only for pa polygons
pronow <- function(p, r, n) {
  t1 <- Sys.time()
  df <- pbmclapply(1:nrow(p), function(i) {
    exact_extract(r, p[i, ], 'mean')
  },mc.cores = n)
  t2 <- Sys.time()
  dt <- as.numeric(t2-t1, units="secs")
  print(dt)
}

# function only for fishnet polygons
progrid <- function(r, n) {
  p <- read_sf("../sample_wdpa-fishnets.gpkg")
  t1 <- Sys.time()
  df <- pbmclapply(1:nrow(p), function(i) {
    exact_extract(r, p[i, ], 'mean')
  },mc.cores = n)
  t2 <- Sys.time()
  dt <- as.numeric(t2-t1, units="secs")
  print(dt)
}

# wdpa
p <- read_sf("../sample_wdpa.gpkg")
for (n in c(1,4,8,16)) {
  pronow(p, r, n)
}

# simplified wdpa
p <- read_sf("../sample_simp-wdpa.gpkg")
for (n in c(1,4,8,16)) {
  pronow(p, r, n)
}

# grid
for (n in c(1,4,8,16)) {
  progrid(r, n)
}
