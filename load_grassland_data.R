library(rgdal)
library(raster)
library(rgeos)
library(maptools)
library(abind)
library(pixmap)
library(offsetsim)

find_disjoint_probabilty_list <- function(pool_mask, land_parcels){
  
  pool_mask = as.matrix(pool_mask)
  probability_list = lapply(seq_along(land_parcels), 
                        function(i) as.numeric(sum(pool_mask[land_parcels[[i]]]) > 0))
  scale_factor = sum(unlist(probability_list))
  probability_list = lapply(seq_along(probability_list), function(i) probability_list[[i]]/scale_factor)
  
  return(probability_list)
}

offset_into_disjoint_region = TRUE

max_eco_val = 100

save_site_planning_units = FALSE
save_ecology = TRUE
save_decline_rates = TRUE
save_offset_region = TRUE

simulation_inputs_folder = ('simulation_inputs/')

objects_to_save = list()

planning_units_array = raster_to_array(raster('data/planning.units.uid_20ha.asc'))
site_characteristics <- define_planning_units(planning_units_array)

if (save_site_planning_units == TRUE){
  objects_to_save$planning_units_array <- planning_units_array
  objects_to_save$site_characteristics <- site_characteristics
}


if (offset_into_disjoint_region == TRUE){
  dev_pool_mask = raster('data/dev_pool_mask.asc')
  dev_probabilty_list = find_disjoint_probabilty_list(pool_mask = dev_pool_mask, land_parcels = site_characteristics$land_parcels)
  offset_pool_mask = raster('data/offset_pool_mask_random.asc')
  offset_probabilty_list = find_disjoint_probabilty_list(pool_mask = offset_pool_mask, land_parcels = site_characteristics$land_parcels)
} else {
  dev_probabilty_list = rep(list(1/length(site_characteristics$land_parcels)), length(site_characteristics$land_parcels))
  offset_probabilty_list = dev_probabilty_list
}

dev_probabilty_list[[4]] = 0 #set probability of particular site to zero to exclude from offset group
offset_probabilty_list[[4]] = 0 #set probability of particular site to zero to exclude from development group
objects_to_save$dev_probabilty_list <- dev_probabilty_list
objects_to_save$offset_probabilty_list <- offset_probabilty_list

save_simulation_inputs(objects_to_save, simulation_inputs_folder)