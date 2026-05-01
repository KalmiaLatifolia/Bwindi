
# Forest Diversity Map
# Fabian made some excellent maps of Forest structural diversity from GEDI data
# lets see how it looks over Bwindi

library(terra)
library(dplyr)
library(mapview)
library(sf)
library(ggplot2)
library(basemaps)
library(ggspatial)
library(tidyterra)

# set wd -----------------------------------------------------------------------
setwd("/Users/lauraberman/Library/CloudStorage/OneDrive-NationalUniversityofSingapore/Documents/Wisconsin/Townsend Lab/Bwindi")


# define bbox of Bwindi in WGS84 -----------------------------------------------
ext <- st_as_sfc(st_bbox(c(
  xmin = 29.50, xmax = 29.90,
  ymin = -1.20, ymax = -0.80
), crs = 4326))

# Transform to EPSG:3857 (Web Mercator)
ext <- st_transform(ext, 3857)

# take a look ------------------------------------------------------------------
ggplot() +
  basemap_gglayer(ext, map_service = "esri", map_type = "world_imagery") +
  scale_fill_identity() +
  theme_minimal() +
  annotation_scale(location = "br", width_hint = 0.2) +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  coord_sf(xlim = st_bbox(ext)[c("xmin", "xmax")],
           ylim = st_bbox(ext)[c("ymin", "ymax")],
           crs = st_crs(3857),
           expand = FALSE) +
  theme(legend.position = "none") +
  xlab("") +
  ylab("")

# other map types: get_maptypes()
# "world_imagery"
# "natgeo_world_map"
# "world_topo_map"
# "world_hillshade"


# load raster data -------------------------------------------------------------
GEDI_mean <- rast("Bwindi_GIT/rasters/Forest_Diversity_CAF_WesternUS_2481_1-20260430_175616/ForStruc_GEDI_AFRICA_Mean_rh98_rh25_pai_cover_fhd_1km.tif")

# load Bwindi shapefile
Bwindi <- st_read("Bwindi_GIT/shapefiles/WDPA_WDOECM_May2026_Public_61609_shp/WDPA_WDOECM_May2026_Public_61609_shp_0")
mapview(Bwindi)

# Transform extent object to match raster
ext <- st_transform(ext, crs(GEDI_mean))

# crop the raster
GEDI_mean_crop <- crop(GEDI_mean, ext)


# Plot canopy height 
ggplot() +
  geom_spatraster(data = GEDI_mean_crop$`RH98 relative height 98th percentile`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "RH98 height (m)")

# Plot mid-canopy height 
ggplot() +
  geom_spatraster(data = GEDI_mean_crop$`RH25 relative height 25th percentile`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "RH25 height (m)")


# Plot PAI 
ggplot() +
  geom_spatraster(data = GEDI_mean_crop$`PAI plant area index`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "Plant Area Index")


# Plot Canopy cover 
ggplot() +
  geom_spatraster(data = GEDI_mean_crop$`canopy cover`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "Canopy Cover")


# Plot Foliage height diversity
ggplot() +
  geom_spatraster(data = GEDI_mean_crop$`foliage height diversity`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "Foliage height diversity")



# load std raster data -------------------------------------------------------------
GEDI_std <- rast("Bwindi_GIT/rasters/Forest_Diversity_CAF_WesternUS_2481_1-20260430_175616/ForStruc_GEDI_AFRICA_std_rh98_rh25_pai_cover_fhd_1km.tif")


# crop the raster
GEDI_std_crop <- crop(GEDI_std, ext)


# Plot canopy height 
ggplot() +
  geom_spatraster(data = GEDI_std_crop$`RH98 relative height 98th percentile`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "std RH98 height (m)")

# Plot mid-canopy height 
ggplot() +
  geom_spatraster(data = GEDI_std_crop$`RH25 relative height 25th percentile`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "std RH25 height (m)")

# Plot PAI
ggplot() +
  geom_spatraster(data = GEDI_std_crop$`PAI plant area index`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "std Plant area index")

# Plot PAI
ggplot() +
  geom_spatraster(data = GEDI_std_crop$`canopy cover`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "std canopy cover")

# Plot PAI
ggplot() +
  geom_spatraster(data = GEDI_std_crop$`foliage height diversity`) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "std foliage height diversity")


# load structural diversity raster data -------------------------------------------------------------
GEDI_FSTR <- rast("Bwindi_GIT/rasters/Forest_Diversity_CAF_WesternUS_2481_1-20260430_175616/ForStruc_GEDI_AFRICA_StructuralDiversity_1km.tif")

# crop the raster
GEDI_FSTR_crop <- crop(GEDI_FSTR, ext)

# Plot structural richness
ggplot() +
  geom_spatraster(data = GEDI_FSTR_crop$richness) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "structural richness")

# Plot structural richness
ggplot() +
  geom_spatraster(data = GEDI_FSTR_crop$evenness) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "evenness")

# Plot structural divergence
ggplot() +
  geom_spatraster(data = GEDI_FSTR_crop$divergence) +
  theme_minimal() +
  geom_sf(data = Bwindi, fill = NA, color = "black", linewidth = 1.2) +
  annotation_scale(location = "br") +
  annotation_north_arrow(location = "tr", which_north = "true", style = north_arrow_fancy_orienteering) +
  labs(fill = "divergence")


