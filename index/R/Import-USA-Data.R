# R packages --------------------------------------------------------------

if (!require(pacman)) install.packages("pacman")

library(pacman)

p_load(dplyr)
p_load(lubridate)
p_load(magrittr)
p_load(readr)

# Import USA's data -------------------------------------------------------

USA_data <- read_csv(
  "./Data/Input/USA-data.csv",
  col_types = str_c(c("D", rep("d", 32)), collapse = ""),
  skip = 0,
  n_max = 538
)

# Change format of date column --------------------------------------------
USA_data %<>%
  mutate(Date = seq(ymd(19750201), ymd(20191001), by = "1 month") - 1)
