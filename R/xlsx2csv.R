
# Transform financial uncertainty index (JLN) from .xlsx to .csv ----------

financial.uncertainty.JLN <- readxl::read_xlsx(
  "./Data/FinancialUncertaintyToCirculate.xlsx",
  col_names = c("Date", paste0("FU-JLN-h", c(1, 3, 12))),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 702
)

macro.uncertainty.JLN <- readxl::read_xlsx(
  "./Data/MacroUncertaintyToCirculate.xlsx",
  col_names = c("Date", paste0("MU-JLN-h", c(1, 3, 12))),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 702
)

readr::write_csv(financial.uncertainty.JLN, "./Data/FinancialUncertaintyJLN.csv")
readr::write_csv(macro.uncertainty.JLN, "./Data/MacroUncertaintyJLN.csv")
