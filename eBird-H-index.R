# Load packages
library(readr)
library(dplyr)

# Read the eBird data from CSV downloaded from ebird.org
MyEBirdData <- read_csv(file.choose())

# Use the count() function to count occurrences of each value in the 'Submission ID' column
value_counts <- MyEBirdData %>% count(`Submission ID`)

# Rename the count column to 'count'
colnames(value_counts)[2] <- "count"

# Use the count() function again to count occurrences of each count value
species.totals <- value_counts %>% count(count)

# Rename the count column to 'species'
colnames(species.totals)[2] <- "species"

# Reverse the order of the dataframe
species.totals <- species.totals %>% arrange(desc(row_number()))

# Calculate the cumulative sum of 'species' column up to the nth row
species.totals$H.total <- cumsum(species.totals$species)

# Change the order of the dataframe back
species.totals <- species.totals %>% arrange(desc(row_number()))

# Change class of columns to numeric
species.totals$species <- as.numeric(species.totals$species)
species.totals$H.total <- as.numeric(species.totals$H.total)

# Find the index where 'H.total' is less than 'species'
checklist.h.index <- which(species.totals$H.total < species.totals$species)[1]

# Print the result
if (!is.na(checklist.h.index)) {
  cat("My eBird H-index is", checklist.h.index-1, "\n")
} else {
  cat("No such row found.\n")
}
