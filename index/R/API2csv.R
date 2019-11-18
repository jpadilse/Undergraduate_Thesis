# R packages --------------------------------------------------------------

if (!require(pacman)) install.packages("pacman")

library(pacman)

p_load(dplyr)
p_load(here)
p_load(magrittr)
p_load(neverhpfilter)
p_load(purrr)
p_load(readr)
p_load(stringr)
p_load(tidyr)
p_load(tidyquant)
p_load(timetk)

# Declare preferences -----------------------------------------------------

conflicted::conflict_prefer("here", "here")
conflicted::conflict_prefer("lag", "dplyr")

# Import series through FED, Yahoo Finance and Quandl API -----------------

# FRED API ----------------------------------------------------------------

FRED_data <- c(
  "INDPRO",
  # Industrial Production Index
  # - Seasonally adjusted
  # - Index 2012 = 100
  "IPMAN",
  # Industrial Production in manufacturing (NAICS)
  # - Seasonally adjusted
  # - Index 2012 = 100
  "IPMANSICS",
  # Industrial Production in manufacturing (SIC)
  # - Seasonally adjusted
  # - Index 2012 = 100
  "PAYEMS",
  # Total number of employees in the non-farm sector
  # - Seasonally adjusted
  # - Thousands of persons
  "MANEMP",
  # Total number of employees in manufacturing
  # - Seasonally adjusted
  # - Thousands of persons
  "DPCERA3M086SBEA",
  # Real Personal Consumption Expenditures
  # - Seasonally adjusted
  # - Index 2012 = 100
  "PCEPI",
  # Personal Consumption Expenditures Price Index
  # - Seasonally adjusted
  # - Index 2012 = 100
  "CPIAUCSL",
  # Consumer Price Index (all urban consumers)
  # - Seasonally adjusted
  # - Index 1982-1984 = 100
  "AHETPI",
  # Average hourly earnings of production and nonsupervisory employees for
  # all-sectors
  # - Seasonally adjusted
  # - Dollars per hour
  "CES3000000008",
  # Average hourly earnings of production and nonsupervisory employees in
  # manufacturing
  # - Seasonally adjusted
  # - Dollars per hour
  "AWHNONAG",
  # Average weekly hours of production and nonsupervisory employees for
  # all-sectors
  # - Seasonally adjusted
  # - Hours
  "AWHMAN",
  # Average weekly hours of production and nonsupervisory employees in
  # manufacturing
  # - Seasonally adjusted
  # - Hours
  "FEDFUNDS",
  # Effective Federal Funds Rate
  # - Not seasonally adjusted
  # - Percent
  "M2SL"
  # M2 Money Stock in billions of dollars
  # - Seasonally adjusted
  # - Billions of Dollars
) %>%
  tq_get(get = "economic.data", from = "1972-01-01")

# All series of which units are measured in prices need to be given the
# 100 * log() treatment. Also, the M2 money stock and inflation enter as
# continuously compounded annual rate of change.

FRED_data %<>%
  spread(symbol, price) %>%
  transmute(
    Date = date,
    Production_all_log = 100 * log(INDPRO),
    Production_NAICS_log = 100 * log(IPMAN),
    Production_SIC_log = 100 * log(IPMANSICS),
    Employment_all_lin = PAYEMS,
    Employment_manu_lin = MANEMP,
    Consumption_log = 100 * log(DPCERA3M086SBEA),
    Inflation = 12 * 100 * log(PCEPI / lag(PCEPI)),
    Inflation_urban = 12 * 100 * log(CPIAUCSL / lag(CPIAUCSL)),
    Wages_all_log = 100 * log(AHETPI),
    Wages_manu_log = 100 * log(CES3000000008),
    Labor_all_lin = AWHNONAG,
    Labor_manu_lin = AWHMAN,
    FederalFundsRate_lin = FEDFUNDS,
    M2_cca = 12 * 100 * log(M2SL / lag(M2SL))
  ) %>%
  drop_na()

# Quandl API --------------------------------------------------------------

ISM <- tq_get(
  "ISM/MAN_NEWORDERS",
  # New Orders Index
  # - Seasonally adjusted
  get = "quandl",
  from = "1972-01-01",
  column_index = 5
)

ISM %<>% transmute(Date = date, NewOrders_log = 100 * log(index))

# Yahoo Finance API -------------------------------------------------------

SP500 <- tq_get(
  "^gspc",
  # Standard and Poor's 500 index
  # - Not seasonally adjusted
  get = "stock.prices",
  from = "1972-01-01",
  periodicity = "monthly"
)

SP500 %<>% transmute(Date = date, StockMarketIndex_log = 100 * log(adjusted))

# Merge data from APIs ----------------------------------------------------

USA_Data <- list(FRED_data, ISM, SP500) %>%
  reduce(inner_join) %>%
  select(
    Date,
    Production_all_log,
    Production_NAICS_log,
    Production_SIC_log,
    Employment_all_lin,
    Employment_manu_lin,
    Consumption_log,
    Inflation,
    Inflation_urban,
    NewOrders_log,
    Wages_all_log,
    Wages_manu_log,
    Labor_all_lin,
    Labor_manu_lin,
    FederalFundsRate_lin,
    StockMarketIndex_log,
    M2_cca
  )

# Hamilton's filter -------------------------------------------------------

USA_Data_detrend <- do.call(
  merge,
  map(
    as.list(tk_xts(USA_Data)),
    yth_filter,
    h = 24,
    p = 12,
    output = "cycle"
  )
)

USA_Data_detrend %<>%
  tk_tbl() %>%
  rename(Date = index)

# Merge raw and cycle series ----------------------------------------------

USA_Data %<>%
  inner_join(USA_Data_detrend) %>%
  rename_all(~ str_replace(., "\\.", "_"))


# Rename all variables for labels of tables and plots ---------------------

USA_Data %>%
  rename(
    Production = Production_all_log_cycle,
    `Production (manufacturing)` = Production_NAICS_log_cycle,
    Employment = Employment_all_lin_cycle,
    `Employment (manufacturing)` = Employment_manu_lin_cycle,
    Consumption = Consumption_log_cycle,
    Inflation = Inflation_cycle,
    `Inflation (urban)` = Inflation_urban_cycle,
    `New Orders` = NewOrders_log_cycle,
    Wages = Wages_all_log_cycle,
    `Wages (manufacturing)` = Wages_manu_log_cycle,
    Labor = Labor_all_lin_cycle,
    `Labor (manufacturing)` = Labor_manu_lin_cycle,
    `Federal funds rate` = FederalFundsRate_lin_cycle,
    `Stock market index` = StockMarketIndex_log_cycle,
    `M2 growth rate` = M2_cca_cycle
  )

# Write data to csv -------------------------------------------------------

write_csv(USA_Data, here("index", "Data", "Input", "USA-data.csv"))
