# Library calls -----------------------------------------------------------

pacman::p_load(dplyr, lubridate, magrittr, readr)

# Import USA's data -------------------------------------------------------

USA.data <- read_csv(
  "./Data/Input/USA-data.csv",
  col_types = str_c(c("D", rep("d", 32)), collapse = ""),
  skip = 0,
  n_max = 537
)

# Change format of date column --------------------------------------------
USA.data %<>%
  mutate(Date = seq(ymd(19750201), ymd(20190901), by = "1 month") - 1)
