# Library calls -----------------------------------------------------------

pacman::p_load(dplyr, magrittr, tidyr)

# Import series through FED, Yahoo Finance and Quandl API -----------------

FRED.data <- purrr::map_dfr(
  c(
    "INDPRO",
    "PAYEMS",
    "DPCERA3M086SBEA",
    "PCEPI",
    "AWHMAN",
    "FEDFUNDS",
    "M2SL"
  ),
  fredr::fredr,
  observation_start = lubridate::ymd("1960-07-01")
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
    Labor = AWHMAN,
    FederalFundsRate = FEDFUNDS,
    M2 = M2SL
  )

ISM <- Quandl::Quandl("ISM/MAN_NEWORDERS")

ISM %<>%
  as_tibble() %>%
  select(Date, Index) %>%
  rename(NewOrders = Index) %>%
  arrange(Date)

SP500 <- pdfetch::pdfetch_YAHOO(
  "^gspc",
  fields = "adjclose",
  from = "1960-07-01",
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
    Labor,
    FederalFundsRate,
    StockMarketIndex,
    M2
  )

readr::write_csv(USA.Data, "./Data/Input/USA-data.csv")
