# Library calls -----------------------------------------------------------

pacman::p_load(dplyr, lubridate, magrittr, readr)

# Import Uncertainty Indexes ----------------------------------------------

# Economic Policy Uncertainty ---------------------------------------------

economic_policy_uncertainty <- read_csv(
  "./Data/Input/EPU.csv",
  col_names = c("Year", "Month", "EPU3C", "EPUNews"),
  col_types = "?ddd",
  skip = 1,
  n_max = 417
)

# Monetary Policy Uncertainty ---------------------------------------------

monetary_policy_uncertainty_BBD <- read_csv(
  "./Data/Input/MPU-BBD.csv",
  col_names = c("Date", "MPU_BBD_AWN", "MPU_BBD_10"),
  col_types = "?dd",
  skip = 1,
  n_max = 393
)

monetary_policy_uncertainty_HRS <- read_csv(
  "./Data/Input/MPU-HRS.csv",
  col_names = c("Date", "MPU_HRS"),
  col_types = "?d",
  skip = 1,
  n_max = 391
)

# Geopolitical Risk -------------------------------------------------------

geopolitical_risk_index <- read_csv(
  "./Data/Input/GeopoliticalRiskIndex.csv",
  col_names = c("Date", "GPR", "GPT", "GPA"),
  col_types = "?ddd",
  skip = 1,
  n_max = 417
)

# Survey-Based Macroeconomic Uncertainty ----------------------------------

# survey_based_uncertainty <- read_csv(
#   "./Data/Input/SurveyBaseUncertainty.csv",
#   col_names = c("Date", "SB"),
#   col_types = "?d",
#   skip = 1,
#   n_max = 5889
# )

# Econometric Measures of Uncertainty -------------------------------------

macro_uncertainty_JLN <- read_csv(
  "./Data/Input/MacroUncertaintyJLN.csv",
  col_names = c("Date", paste0("MU_JLN_h", c(1, 3, 12))),
  col_types = "?ddd",
  skip = 1,
  n_max = 702
)

real_uncertainty_JLN <- read_csv(
  "./Data/Input/RealUncertaintyJLN.csv",
  col_names = c("Date", paste0("RU_JLN_h", c(1, 3, 12))),
  col_types = "?ddd",
  skip = 1,
  n_max = 702
)

financial_uncertainty_JLN <- read_csv(
  "./Data/Input/FinancialUncertaintyJLN.csv",
  col_names = c("Date", paste0("FU_JLN_h", c(1, 3, 12))),
  col_types = "?ddd",
  skip = 1,
  n_max = 702
)

# Change format of date column --------------------------------------------

# Economic policy uncertainty ---------------------------------------------

economic_policy_uncertainty %<>%
  mutate(Date = seq(ymd(19850201), ymd(20191001), by = "1 month") - 1) %>%
  select(Date, EPU3C, EPUNews)

# Monetary policy uncertainty ---------------------------------------------

monetary_policy_uncertainty_BBD %<>%
  mutate(Date = seq(ymd(19850201), ymd(20171001), by = "1 month") - 1)

monetary_policy_uncertainty_HRS %<>%
  mutate(Date = seq(ymd(19850201), ymd(20170801), by = "1 month") - 1)

# Geopolitical risk -------------------------------------------------------

geopolitical_risk_index %<>%
  mutate(Date = seq(ymd(19850201), ymd(20191001), by = "1 month") - 1)

# Survey-based macroeconomic uncertainty ----------------------------------

# survey_based_uncertainty %<>% mutate(Date = ymd(Date))

# Econometric measures of uncertainty -------------------------------------

macro_uncertainty_JLN %<>%
  mutate(Date = seq(ymd(19600801), ymd(20190101), by = "1 month") - 1)

real_uncertainty_JLN %<>%
  mutate(Date = seq(ymd(19600801), ymd(20190101), by = "1 month") - 1)

financial_uncertainty_JLN %<>%
  mutate(Date = seq(ymd(19600801), ymd(20190101), by = "1 month") - 1)
