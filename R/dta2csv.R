
# Library calls -----------------------------------------------------------

library(magrittr)

# Transform U.S. Call Report data from .dta to .csv -----------------------

call.reports.usa <- haven::read_dta("./Data/callreports_final.dta")

call.reports.usa %<>% dplyr::select(
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

readr::write_csv(call.reports.usa, "./Data/CallReportsUSA.csv")
