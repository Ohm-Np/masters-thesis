## 02: terraZonal vs terraExtract vs exactExtractr (Fishnets)
# Author: Om Prakash Bhandari
# Last Edit: 2022-06-10

# required libraries
library(sf)
library(terra)
library(exactextractr)

# load raster
raster <- rast("../../datalake/mapme.protectedareas/input/world_pop/global_mosaic2020.tif")

for (i in c(5,10,25,50,100,200,500,1000,5000,10000)) {

  fishnet <- read_sf(paste0("data/fishnet_polygons/fishnet_",i,"_sqkm.gpkg"))
  fishnet <- st_transform(fishnet, 4326)
  fishnet <-
    tibble::rowid_to_column(fishnet, "UID")
  pop_crop <- terra::crop(raster,
                          fishnet)

  # terra::extract
  t1 <- Sys.time()
  pa.v <- vect(fishnet)
  terra_extract <- terra::extract(pop_crop, pa.v, 'mean', na.rm = T)
  t2 <- Sys.time()
  dt_te <- as.numeric(t2-t1, units="secs")

  # terra::zonal
  t1 <- Sys.time()
  pa.v <- vect(fishnet)
  mask <- terra::mask(pop_crop, pa.v)
  rasterize <- terra::rasterize(pa.v, mask, "UID")
  terra_zonal <- terra::zonal(mask, rasterize, 'mean', na.rm = T)
  t2 <- Sys.time()
  dt_tz <- as.numeric(t2-t1, units="secs")

  # exact extract
  t1 <- Sys.time()
  exact_extract <- exact_extract(pop_crop, fishnet, 'mean')
  t2 <- Sys.time()
  dt_ee <- as.numeric(t2-t1, units="secs")

  df <- data.frame(polygon = paste0("fishnet_",i,"*",i),
                   terra_extract = dt_te,
                   terra_zonal = dt_tz,
                   exact_extract = dt_ee)
  write.csv(df,
            paste0("data/results/02_fishnet_benchmarks/time",i,".csv"),
            row.names = F)
}

