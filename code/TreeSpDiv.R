
# Tree Species Diversity Map for Bwindi
# 1 May 2026
# Laura Berman

# Data source: https://figshare.com/articles/dataset/The_global_map_of_tree_species_richness/17232491 


# set wd -----------------------------------------------------------------------
setwd("/Users/lauraberman/Library/CloudStorage/OneDrive-NationalUniversityofSingapore/Documents/Wisconsin/Townsend Lab/Bwindi")


# define bbox of Bwindi in WGS84 -----------------------------------------------
ext <- st_as_sfc(st_bbox(c(
  xmin = 29.50, xmax = 29.90,
  ymin = -1.20, ymax = -0.80
), crs = 4326))


# load raster data -------------------------------------------------------------
TreeSp <- rast("Bwindi_GIT/rasters/TreeSpeciesDiversity/S_mean_raster.tif")

# load Bwindi shapefile
Bwindi <- st_read("Bwindi_GIT/shapefiles/WDPA_WDOECM_May2026_Public_61609_shp/WDPA_WDOECM_May2026_Public_61609_shp_0")
mapview(Bwindi)

# Transform extent object to match raster
ext <- st_transform(ext, crs(TreeSp))

# crop the raster
TreeSp_crop <- crop(TreeSp, ext)
mapview(TreeSp_crop) + mapview(Bwindi)

# Plot tree species richness
ggplot() +
  geom_spatraster(data = TreeSp_crop$S_mean_raster) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "Mean Tree Species Richness")





