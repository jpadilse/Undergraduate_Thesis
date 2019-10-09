# Library calls -----------------------------------------------------------

pacman::p_load(readxl, readr)

# Transform uncertainty indexes from .xlsx to .csv ------------------------

## Economic Policy Uncertainty

economic.policy.uncertainty <- read_xlsx(
  "./Data/Input/US_Policy_Uncertainty_Data.xlsx",
  col_names = c("Year", "Month", "EPU-3C", "EPU-News"),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 417
)

## Monetary Policy Uncertainty

monetary.policy.uncertainty.BBD <- read_xlsx(
  "./Data/Input/US_MPU_monthly.xlsx",
  col_names = c("Date", "MPU-BBD-AWN", "MPU-BBD-10"),
  col_types = c("date", rep("numeric", 2), "skip"),
  skip = 1,
  n_max = 393
)

monetary.policy.uncertainty.HRS <- read_xlsx(
  "./Data/Input/HRS_MPU_monthly.xlsx",
  col_names = c("Date", "MPU-HRS"),
  col_types = c("guess", "numeric"),
  skip = 1,
  n_max = 391
)

## Geopolitical Risk

geopolitical.risk.index <- read_xlsx(
  "./Data/Input/gpr_web_latest.xlsx",
  col_names = c("Date", "GPR", "GPT", "GPA"),
  col_types = c("guess", rep("numeric", 3), rep("skip", 9)),
  skip = 1,
  n_max = 417
)

## Survey-Based Macroeconomic Uncertainty

survey.based.uncertainty <- read_xls(
  "./Data/Input/Scotti_data28june2019.xls",
  sheet = 4,
  col_names = c("Date", "SB"),
  col_types = c("guess", "numeric", rep("skip", 4)),
  skip = 1,
  n_max = 5889
)

## Econometric Measures of Uncertainty

macro.uncertainty.JLN <- read_xlsx(
  "./Data/Input/MacroUncertaintyToCirculate.xlsx",
  col_names = c("Date", paste0("MU-JLN-h", c(1, 3, 12))),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 702
)

real.uncertainty.JLN <- read_xlsx(
  "./Data/Input/RealUncertaintyToCirculate.xlsx",
  col_names = c("Date", paste0("RU-JLN-h", c(1, 3, 12))),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 702
)

financial.uncertainty.JLN <- read_xlsx(
  "./Data/Input/FinancialUncertaintyToCirculate.xlsx",
  col_names = c("Date", paste0("FU-JLN-h", c(1, 3, 12))),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 702
)

write_csv(economic.policy.uncertainty, "./Data/Input/EPU.csv")
write_csv(monetary.policy.uncertainty.BBD, "./Data/Input/MPU-BBD.csv")
write_csv(monetary.policy.uncertainty.HRS, "./Data/Input/MPU-HRS.csv")
write_csv(geopolitical.risk.index, "./Data/Input/GeopoliticalRiskIndex.csv")
write_csv(survey.based.uncertainty, "./Data/Input/SurveyBaseUncertainty.csv")
write_csv(macro.uncertainty.JLN, "./Data/Input/MacroUncertaintyJLN.csv")
write_csv(real.uncertainty.JLN, "./Data/Input/RealUncertaintyJLN.csv")
write_csv(financial.uncertainty.JLN, "./Data/Input/FinancialUncertaintyJLN.csv")
