# Load packages
library(readr)
library(dplyr)

# Read the eBird data from CSV downloaded from ebird.org
MyEBirdData <- read_csv(file.choose())

# Use the count() function to count occurrences of each value in the 'Submission ID' column
value_counts <- MyEBirdData %>% count(`Submission ID`)

# Rename the count column to 'number of species'
colnames(value_counts)[2] <- "num.species"

# Use the count() function again to count occurrences of each count value
species.totals <- value_counts %>% count(num.species)

# Rename the count column to 'number of lists'
colnames(species.totals)[2] <- "num.lists"

# Reverse the order of the dataframe
species.totals <- species.totals %>% arrange(desc(row_number()))

# Calculate the cumulative sum of 'lists' up to the nth row, termed 'H.total'
species.totals$H.total <- cumsum(species.totals$num.lists)

# Change the order of the dataframe back
species.totals <- species.totals %>% arrange(desc(row_number()))

# Change class of columns to numeric
species.totals$num.species <- as.numeric(species.totals$num.species)
species.totals$H.total <- as.numeric(species.totals$H.total)

# Find the value where 'H.total' is less than 'number of species' observed
checklist.h.index <- which(species.totals$H.total < species.totals$num.species)[1] - 1

# Print the result
if (!is.na(checklist.h.index)) {
  cat("My eBird H-index is", checklist.h.index, "\n")
} else {
  cat("No such row found.\n")
}
