# Library calls -----------------------------------------------------------

pacman::p_load(dplyr, magrittr, purrr, tidyr, tidyquant)

# Import series through FED, Yahoo Finance and Quandl API -----------------

# FRED API ----------------------------------------------------------------

FRED.data <- c(
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
# 100 * log() treatment

FRED.data %<>%
  spread(symbol, price) %>%
  transmute(
    Date = date,
    Production.all.log = 100 * log(INDPRO),
    Production.NAICS.log = 100 * log(IPMAN),
    Production.SIC.log = 100 * log(IPMANSICS),
    Employment.all.lin = PAYEMS,
    Employment.manu.lin = MANEMP,
    Consumption.log = 100 * log(DPCERA3M086SBEA),
    Prices.log = 100 * log(PCEPI),
    Prices.urban.log = 100 * log(CPIAUCSL),
    Wages.all.log = 100 * log(AHETPI),
    Wages.manu.log = 100 * log(CES3000000008),
    Labor.all.lin = AWHNONAG,
    Labor.manu.lin = AWHMAN,
    FederalFundsRate.lin = FEDFUNDS,
    M2.cca = 12 * 100 * log(M2SL / lag(M2SL))
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

ISM %<>% transmute(Date = date, NewOrders.log = 100 * log(index))

# Yahoo Finance API -------------------------------------------------------

SP500 <- tq_get(
  "^gspc",
  # Standard and Poor's 500 index
  # - Not seasonally adjusted
  get = "stock.prices",
  from = "1972-01-01",
  periodicity = "monthly"
)

SP500 %<>% transmute(Date = date, StockMarketIndex.log = 100 * log(adjusted))

# Merge data from APIs ----------------------------------------------------

USA.Data <- list(FRED.data, ISM, SP500) %>%
  reduce(inner_join) %>%
  select(
    Date,
    Production.all.log,
    Production.NAICS.log,
    Production.SIC.log,
    Employment.all.lin,
    Employment.manu.lin,
    Consumption.log,
    Prices.log,
    Prices.urban.log,
    NewOrders.log,
    Wages.all.log,
    Wages.manu.log,
    Labor.all.lin,
    Labor.manu.lin,
    FederalFundsRate.lin,
    StockMarketIndex.log,
    M2.cca
  )

# Hamilton's filter -------------------------------------------------------

USA.Data.detrend <- do.call(
  merge,
  map(
    as.list(timetk::tk_xts(USA.Data)),
    neverhpfilter::yth_filter,
    h = 24,
    p = 12,
    output = "cycle"
  )
)

USA.Data.detrend %<>%
  timetk::tk_tbl() %>%
  rename(Date = index)

# Merge raw and cycle series ----------------------------------------------

USA.Data %<>% inner_join(USA.Data.detrend)

# Write data to csv -------------------------------------------------------

readr::write_csv(USA.Data, "./Data/Input/USA-data.csv")
