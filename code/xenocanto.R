
# XENOCANTO data availability

# I know that BirdNET can ID 690 species with ranges overlapping Bwindi.
# But I don't know how many of those 690 are likely to be usable
# Rule of thumb, species classifiers with ~100 training recordings tend to be alright
# so, how many of these 690 classes have at least 100 xenocanto examples?

library(httr)
library(jsonlite)
library(dplyr)
library(readr)

# set wd -----------------------------------------------------------------------
setwd("/Users/lauraberman/Library/CloudStorage/OneDrive-NationalUniversityofSingapore/Documents/Wisconsin/Townsend Lab/Bwindi")

# read species list ------------------------------------------------------------
sp <- read_csv("chirpity_species_list.csv", col_names = c("scientific_name", "common_name"))

# function to query xenocanto --------------------------------------------------
get_xc_count <- function(species){
  q <- paste0('species:"', species, '"')
  url <- paste0("https://xeno-canto.org/api/2/recordings?query=", URLencode(q))
  res <- GET(url)
  dat <- fromJSON(content(res, "text", encoding="UTF-8"))
  return(as.numeric(dat$numRecordings))
}

# apply to all species (slow) --------------------------------------------------
sp$xc_recordings <- sapply(sp$scientific_name, get_xc_count)

# save result ------------------------------------------------------------------
write_csv(sp, "species_with_xc_counts.csv")
