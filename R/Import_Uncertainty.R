# Library calls -----------------------------------------------------------

pacman::p_load(dplyr, lubridate, magrittr, readr)

# Import Uncertainty Indexes ----------------------------------------------

# Economic Policy Uncertainty ---------------------------------------------

economic.policy.uncertainty <- read_csv(
  "./Data/Input/EPU.csv",
  col_names = c("Year", "Month", "EPU3C", "EPUNews"),
  col_types = "?ddd",
  skip = 1,
  n_max = 417
)

# Monetary Policy Uncertainty ---------------------------------------------

monetary.policy.uncertainty.BBD <- read_csv(
  "./Data/Input/MPU-BBD.csv",
  col_names = c("Date", "MPU-BBD-AWN", "MPU-BBD-10"),
  col_types = "?dd",
  skip = 1,
  n_max = 393
)

monetary.policy.uncertainty.HRS <- read_csv(
  "./Data/Input/MPU-HRS.csv",
  col_names = c("Date", "MPU-HRS"),
  col_types = "?d",
  skip = 1,
  n_max = 391
)

# Geopolitical Risk -------------------------------------------------------

geopolitical.risk.index <- read_csv(
  "./Data/Input/GeopoliticalRiskIndex.csv",
  col_names = c("Date", "GPR", "GPT", "GPA"),
  col_types = "?ddd",
  skip = 1,
  n_max = 417
)

# Survey-Based Macroeconomic Uncertainty ----------------------------------

# survey.based.uncertainty <- read_csv(
#   "./Data/Input/SurveyBaseUncertainty.csv",
#   col_names = c("Date", "SB"),
#   col_types = "?d",
#   skip = 1,
#   n_max = 5889
# )

# Econometric Measures of Uncertainty -------------------------------------

macro.uncertainty.JLN <- read_csv(
  "./Data/Input/MacroUncertaintyJLN.csv",
  col_names = c("Date", paste0("MU-JLN-h", c(1, 3, 12))),
  col_types = "?ddd",
  skip = 1,
  n_max = 702
)

real.uncertainty.JLN <- read_csv(
  "./Data/Input/RealUncertaintyJLN.csv",
  col_names = c("Date", paste0("RU-JLN-h", c(1, 3, 12))),
  col_types = "?ddd",
  skip = 1,
  n_max = 702
)

financial.uncertainty.JLN <- read_csv(
  "./Data/Input/FinancialUncertaintyJLN.csv",
  col_names = c("Date", paste0("FU_JLN_h", c(1, 3, 12))),
  col_types = "?ddd",
  skip = 1,
  n_max = 702
)

# Change format of date column --------------------------------------------

# Economic policy uncertainty ---------------------------------------------

economic.policy.uncertainty %<>%
  mutate(Date = seq(ymd(19850201), ymd(20191001), by = "1 month") - 1) %>%
  select(Date, EPU3C, EPUNews)

# Monetary policy uncertainty ---------------------------------------------

monetary.policy.uncertainty.BBD %<>%
  mutate(Date = seq(ymd(19850201), ymd(20171001), by = "1 month") - 1)

monetary.policy.uncertainty.HRS %<>%
  mutate(Date = seq(ymd(19850201), ymd(20170801), by = "1 month") - 1)

# Geopolitical risk -------------------------------------------------------

geopolitical.risk.index %<>%
  mutate(Date = seq(ymd(19850201), ymd(20191001), by = "1 month") - 1)

# Survey-based macroeconomic uncertainty ----------------------------------

# survey.based.uncertainty %<>% mutate(Date = ymd(Date))

# Econometric measures of uncertainty -------------------------------------

macro.uncertainty.JLN %<>%
  mutate(Date = seq(ymd(19600801), ymd(20190101), by = "1 month") - 1)

real.uncertainty.JLN %<>%
  mutate(Date = seq(ymd(19600801), ymd(20190101), by = "1 month") - 1)

financial.uncertainty.JLN %<>%
  mutate(Date = seq(ymd(19600801), ymd(20190101), by = "1 month") - 1)
