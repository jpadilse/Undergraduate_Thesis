# R packages --------------------------------------------------------------

if (!require(pacman)) install.packages("pacman")

library(pacman)

p_load(readxl)
p_load(readr)

# Transform uncertainty indexes from .xlsx to .csv ------------------------

## Economic Policy Uncertainty

economic_policy_uncertainty <- read_xlsx(
  "./Data/Input/US_Policy_Uncertainty_Data.xlsx",
  col_names = c("Year", "Month", "EPU3C", "EPUNews"),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 417
)

## Monetary Policy Uncertainty

monetary_policy_uncertainty_BBD <- read_xlsx(
  "./Data/Input/US_MPU_monthly.xlsx",
  col_names = c("Date", "MPU_BBD_AWN", "MPU_BBD_10"),
  col_types = c("date", rep("numeric", 2), "skip"),
  skip = 1,
  n_max = 393
)

monetary_policy_uncertainty_HRS <- read_xlsx(
  "./Data/Input/HRS_MPU_monthly.xlsx",
  col_names = c("Date", "MPU_HRS"),
  col_types = c("guess", "numeric"),
  skip = 1,
  n_max = 391
)

## Geopolitical Risk

geopolitical_risk_index <- read_xlsx(
  "./Data/Input/gpr_web_latest.xlsx",
  col_names = c("Date", "GPR", "GPT", "GPA"),
  col_types = c("guess", rep("numeric", 3), rep("skip", 9)),
  skip = 1,
  n_max = 417
)

## Survey-Based Macroeconomic Uncertainty

survey_based_uncertainty <- read_xls(
  "./Data/Input/Scotti_data28june2019.xls",
  sheet = 4,
  col_names = c("Date", "SB"),
  col_types = c("guess", "numeric", rep("skip", 4)),
  skip = 1,
  n_max = 5889
)

## Econometric Measures of Uncertainty

macro_uncertainty_JLN <- read_xlsx(
  "./Data/Input/MacroUncertaintyToCirculate.xlsx",
  col_names = c("Date", paste0("MU_JLN_h", c(1, 3, 12))),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 702
)

real_uncertainty_JLN <- read_xlsx(
  "./Data/Input/RealUncertaintyToCirculate.xlsx",
  col_names = c("Date", paste0("RU_JLN_h", c(1, 3, 12))),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 702
)

financial_uncertainty_JLN <- read_xlsx(
  "./Data/Input/FinancialUncertaintyToCirculate.xlsx",
  col_names = c("Date", paste0("FU_JLN_h", c(1, 3, 12))),
  col_types = c("guess", rep("numeric", 3)),
  skip = 1,
  n_max = 702
)

write_csv(economic_policy_uncertainty, "./Data/Input/EPU.csv")
write_csv(monetary_policy_uncertainty_BBD, "./Data/Input/MPU-BBD.csv")
write_csv(monetary_policy_uncertainty_HRS, "./Data/Input/MPU-HRS.csv")
write_csv(geopolitical_risk_index, "./Data/Input/GeopoliticalRiskIndex.csv")
write_csv(survey_based_uncertainty, "./Data/Input/SurveyBaseUncertainty.csv")
write_csv(macro_uncertainty_JLN, "./Data/Input/MacroUncertaintyJLN.csv")
write_csv(real_uncertainty_JLN, "./Data/Input/RealUncertaintyJLN.csv")
write_csv(financial_uncertainty_JLN, "./Data/Input/FinancialUncertaintyJLN.csv")
