
# XENOCANTO data availability

# I know that BirdNET can ID 690 species with ranges overlapping Bwindi.
# But I don't know how many of those 690 are likely to be usable
# Rule of thumb, species classifiers with ~100 training recordings tend to be alright
# so, how many of these 690 classes have at least 100 xenocanto examples?

library(httr)
library(jsonlite)
library(dplyr)
library(readr)
library(purrr)

# set wd -----------------------------------------------------------------------
setwd("/Users/lauraberman/Library/CloudStorage/OneDrive-NationalUniversityofSingapore/Documents/Wisconsin/Townsend Lab/Bwindi")

# read species list ------------------------------------------------------------
sp <- read_csv("chirpity_species_list.csv", col_names = c("scientific_name", "common_name"))

# set xenocanto api key --------------------------------------------------------
#Sys.setenv(XC_KEY = "") secret
key <- Sys.getenv("XC_KEY")

# function to query xenocanto --------------------------------------------------
get_xc_count <- function(species, key){
  q <- paste0('sp:"', species, '"')
  res <- GET(url = "https://xeno-canto.org/api/3/recordings",
             query = list(query = q, key = key))
  stop_for_status(res)
  dat <- fromJSON(content(res, "text", encoding="UTF-8"))
  as.numeric(dat$numRecordings)
}

# get the recordings count for each species ------------------------------------
sp <- sp %>%
  mutate(xc_recordings = map_dbl(scientific_name, ~{
    Sys.sleep(0.5)
    get_xc_count(.x, key)
  }))

# save result ------------------------------------------------------------------
write_csv(sp, "species_with_xc_counts.csv")
