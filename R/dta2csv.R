# Library calls -----------------------------------------------------------

pacman::p_load(dplyr, haven, magrittr, readr)

# Transform U.S. Call Report data from .dta to .csv -----------------------

call.reports.usa <- read_dta("./Data/Input/callreports_final.dta")

call.reports.usa %<>% select(
  rssdid,
  date,
  name,
  assets,
  reloans,
  persloans,
  agloans,
  equity,
  ciloans,
  loans,
  securities,
  liabilities
)

write_csv(call.reports.usa, "./Data/Input/CallReportsUSA.csv")
