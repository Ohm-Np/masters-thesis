## 01: terraZonal vs terraExtract vs exactExtractr (WDPA)
# Author: Om Prakash Bhandari
# Last Edit: 2022-06-10

# required libraries
library(sf)
library(terra)
library(exactextractr)

# load raster
raster <- rast("../../datalake/mapme.protectedareas/input/world_pop/global_mosaic2020.tif")

## (A): terraZonal --------------------------------------

# load wdpa polygons
pa.sf <-
  read_sf("../../datalake/mapme.protectedareas/input/wdpa_kfw/wdpa_kfw_spatial_latinamerica_2021-04-22_allPAs_valid.gpkg")
pop_crop <- terra::crop(raster, pa.sf)
t1 <- Sys.time()
pa.v <- vect(pa.sf)
mask <- terra::mask(pop_crop, pa.v)
rasterize <- terra::rasterize(pa.v, mask, "WDPA_PID")
terra_zonal <- terra::zonal(mask, rasterize, "mean", na.rm = T)
t2 <- Sys.time()
dt_tz <- as.numeric(t2-t1, units = "secs")

# load simplified WDPA polygons
spa.sf <-
  read_sf("../../datalake/mapme.protectedareas/input/wdpa_kfw/wdpa_kfw_spatial_latinamerica_2021-04-22_allPAs_valid_simplified.gpkg")
pop_crop <- terra::crop(raster, spa.sf)
t1 <- Sys.time()
spa.v <- vect(spa.sf)
mask <- terra::mask(pop_crop, spa.v)
rasterize <- terra::rasterize(spa.v, mask, "WDPA_PID")
terra_zonal <- terra::zonal(mask, rasterize, "mean", na.rm = T)
t2 <- Sys.time()
dts_tz <- as.numeric(t2-t1, units = "secs")

# load fishnet polygons
fishnet.sf <-
  read_sf("../../datalake/mapme.protectedareas/processing/fishnet/honeycomb_5_sqkm_kfw.gpkg")
fishnet.sf <- st_transform(fishnet.sf, 4326)
pop_crop <- terra::crop(raster, fishnet.sf)
t1 <- Sys.time()
fishnet.v <- vect(fishnet.sf)
mask <- terra::mask(pop_crop, fishnet.v)
rasterize <- terra::rasterize(fishnet.v, mask, "poly_id")
terra_zonal <- terra::zonal(mask, rasterize, "mean", na.rm = T)
t2 <- Sys.time()
dtfs_tz <- as.numeric(t2-t1, units = "secs")


## (B): terraExtract --------------------------------------

# load wdpa polygons
pa.sf <-
  read_sf("../../datalake/mapme.protectedareas/input/wdpa_kfw/wdpa_kfw_spatial_latinamerica_2021-04-22_allPAs_valid.gpkg")
pop_crop <- terra::crop(raster, pa.sf)
t1 <- Sys.time()
pa.v <- vect(pa.sf)
terra_extract <- terra::extract(pop_crop,pa.v,"mean",na.rm = T)
t2 <- Sys.time()
dt_te <- as.numeric(t2-t1, units = "secs")

# load simplified WDPA polygons
spa.sf <-
  read_sf("../../datalake/mapme.protectedareas/input/wdpa_kfw/wdpa_kfw_spatial_latinamerica_2021-04-22_allPAs_valid_simplified.gpkg")
pop_crop <- terra::crop(raster, spa.sf)
t1 <- Sys.time()
spa.v <- vect(spa.sf)
terra_extract <- terra::extract(pop_crop,spa.v,"mean",na.rm = T)
t2 <- Sys.time()
dts_te <- as.numeric(t2-t1, units = "secs")

# load fishnet polygons
fishnet.sf <-
  read_sf("../../datalake/mapme.protectedareas/processing/fishnet/honeycomb_5_sqkm_kfw.gpkg")
fishnet.sf <- st_transform(fishnet.sf, 4326)
pop_crop <- terra::crop(raster, fishnet.sf)
t1 <- Sys.time()
fishnet.v <- vect(fishnet.sf)
terra_extract <- terra::extract(pop_crop,fishnet.v,"mean",na.rm = T)
t2 <- Sys.time()
dtfs_te <- as.numeric(t2-t1, units = "secs")


## (C): exactExtractr --------------------------------------

# load wdpa polygons
pa.sf <-
  read_sf("../../datalake/mapme.protectedareas/input/wdpa_kfw/wdpa_kfw_spatial_latinamerica_2021-04-22_allPAs_valid.gpkg")
pop_crop <- terra::crop(raster, pa.sf)
t1 <- Sys.time()
exact_extract <- exact_extract(pop_crop,pa.sf,"mean")
t2 <- Sys.time()
dtfs_ee <- as.numeric(t2-t1, units = "secs")

# load simplified WDPA polygons
spa.sf <-
  read_sf("../../datalake/mapme.protectedareas/input/wdpa_kfw/wdpa_kfw_spatial_latinamerica_2021-04-22_allPAs_valid_simplified.gpkg")
pop_crop <- terra::crop(raster, spa.sf)
t1 <- Sys.time()
exact_extract <- exact_extract(pop_crop,spa.sf,"mean")
t2 <- Sys.time()
dts_ee <- as.numeric(t2-t1, units = "secs")

# load fishnet polygons
fishnet.sf <-
  read_sf("../../datalake/mapme.protectedareas/processing/fishnet/honeycomb_5_sqkm_kfw.gpkg")
fishnet.sf <- st_transform(fishnet.sf, 4326)
pop_crop <- terra::crop(raster, fishnet.sf)
t1 <- Sys.time()
exact_extract <- exact_extract(pop_crop,fishnet.sf,"mean")
t2 <- Sys.time()
dtfs_ee <- as.numeric(t2-t1, units = "secs")
