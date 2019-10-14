# Library calls -----------------------------------------------------------

pacman::p_load(dplyr, magrittr, tidyr)

# Import series through FED, Yahoo Finance and Quandl API -----------------

## FRED API

FRED.data <- purrr::map_dfr(
  c(
    "INDPRO", # Industrial Production Index
    # - Seasonally adjusted
    # - Index 2012 = 100
    "PAYEMS", # Total number of employees in the non-farm sector
    # - Seasonally adjusted
    # - Thousands of persons
    "DPCERA3M086SBEA", # Real Personal Consumption Expenditures
    # - Seasonally adjusted
    # - Index 2012 = 100
    "PCEPI", # Personal Consumption Expenditures Price Index
    # - Seasonally adjusted
    # - Index 2012 = 100
    "AHETPI", # Average hourly earnings of production and
    # nonsupervisory employees for all-sectors
    # - Seasonally adjusted
    # - Dollars per hour
    "AWHNONAG", # Average weekly hours of production and nonsupervisory
    # employees for all-sectors
    # - Seasonally adjusted
    # - Hours
    "FEDFUNDS", # Effective Federal Funds Rate
    # - Not seasonally adjusted
    # - Percent
    "M2SL" # M2 Money Stock in billions of dollars
    # - Seasonally adjusted
    # - Billions of Dollars
  ),
  fredr::fredr,
  observation_start = lubridate::ymd("1985-01-01")
)

FRED.data %<>%
  spread(series_id, value) %>%
  drop_na() %>%
  rename(
    Date = date,
    Production = INDPRO,
    Employment = PAYEMS,
    Consumption = DPCERA3M086SBEA,
    Prices = PCEPI,
    Wages = AHETPI,
    Labor = AWHNONAG,
    FederalFundsRate = FEDFUNDS,
    M2 = M2SL
  )

## Quandl API

ISM <- Quandl::Quandl(
  "ISM/MAN_NEWORDERS", # New Orders Index
  # - Seasonally adjusted
  order = "asc",
  start_date = "1985-01-01"
)

ISM %<>%
  as_tibble() %>%
  select(Date, Index) %>%
  rename(NewOrders = Index)

## Yahoo Finance API

SP500 <- pdfetch::pdfetch_YAHOO(
  "^gspc", # Standard and Poor's 500 index
  # - Not seasonally adjusted
  fields = "adjclose",
  from = "1985-01-01",
  interval = "1mo"
)

SP500 %<>%
  zoo::fortify.zoo() %>%
  as_tibble() %>%
  rename(Date = Index, StockMarketIndex = `^gspc`)

USA.Data <- list(FRED.data, ISM, SP500) %>%
  purrr::reduce(inner_join) %>%
  select(
    Date,
    Production,
    Employment,
    Consumption,
    Prices,
    NewOrders,
    Wages,
    Labor,
    FederalFundsRate,
    StockMarketIndex,
    M2
  )

readr::write_csv(USA.Data, "./Data/Input/USA-data.csv")
