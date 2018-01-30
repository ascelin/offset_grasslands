library(rgdal)
library(raster)
library(rgeos)
library(maptools)
library(abind)
library(pixmap)
library(offsetsim)

find_disjoint_weights <- function(pool_mask, land_parcels){
  
  pool_mask = as.matrix(pool_mask)
  weights_list = lapply(seq_along(land_parcels), 
                        function(i) as.numeric(sum(pool_mask[land_parcels[[i]]]) > 0))
  scale_factor = sum(unlist(weights_list))
  weights_list = lapply(seq_along(weights_list), function(i) weights_list[[i]]/scale_factor)
  
  return(weights_list)
}

data_type = 'grassland'
offset_into_disjoint_region = TRUE

max_eco_val = 100
mean_decline_rate = -0.02
decline_rate_std = 0.005

save_site_data = TRUE
save_ecology = TRUE
save_decline_rates = TRUE
save_offset_region = TRUE

simulation_inputs_folder = ('simulation_inputs/')

objects_to_save = list()

#LGA_array <- read_pnm_layer('data/planning.units.uid_20ha.pgm')
LGA_array = raster_to_array(raster('data/planning.units.uid_20ha.asc'))
parcels <- LGA_to_parcel_list(LGA_array)

if (save_site_data == TRUE){
  objects_to_save$LGA_array <- LGA_array
  objects_to_save$parcels <- parcels
}

if (save_ecology == TRUE){
  #landscape_ecology <- list(read_pnm_layer('data/hab.map.master.zo1.pgm'))
  landscape_ecology <- list(raster_to_array(raster('data/hab.map.master.zo1.asc')))
  landscape_ecology <- scale_ecology(landscape_ecology, max_eco_val, dim(landscape_ecology[[1]]))
  objects_to_save$landscape_ecology <- landscape_ecology
  objects_to_save$parcel_ecology <- split_ecology(landscape_ecology, parcels$land_parcels)
}

if (save_offset_region == TRUE){
  if (offset_into_disjoint_region == TRUE){
    dev_pool_mask = raster('data/dev_pool_mask.asc')
    dev_weights = find_disjoint_weights(pool_mask = dev_pool_mask, land_parcels = parcels$land_parcels)
    offset_pool_mask = raster('data/offset_pool_mask_random.asc')
    offset_weights = find_disjoint_weights(pool_mask = offset_pool_mask, land_parcels = parcels$land_parcels)
  } else {
    dev_weights = rep(list(1/length(parcels$land_parcels)), length(parcels$land_parcels))
    offset_weights = dev_weights
  }
  objects_to_save$dev_weights <- dev_weights
  objects_to_save$offset_weights <- offset_weights
}

if (save_decline_rates == TRUE){
  objects_to_save$decline_rates_initial = simulate_decline_rates(parcel_num = length(parcels$land_parcels), 
                                                       sample_decline_rate = TRUE, 
                                                       mean_decline_rate, 
                                                       decline_rate_std, 
                                                       feature_num = 1)       # set up array of decline rates that are eassociated with each cell
}
save_simulation_inputs(objects_to_save, simulation_inputs_folder)