# Library calls -----------------------------------------------------------

pacman::p_load(dplyr, magrittr, readr)

# # Clean and reduce FRED-MD ----------------------------------------------

FRED.MD <- read_csv(
  "./Data/Input/current.csv",
  col_types = str_c(c("c", rep("d", 128)), collapse = "")
)

FRED.MD %>%
  filter(sasdate != "Transform:") %>%
  select(
    AWHMAN,
    DPCERA3M086SBEA,
    FEDFUNDS,
    INDPRO,
    M2SL,
    PAYEMS,
    PCEPI,
    sasdate,
    `S&P 500`
  ) %>%
  rename(
    Labor = AWHMAN,
    Consumption = DPCERA3M086SBEA,
    FederalFundsRate = FEDFUNDS,
    Production = INDPRO,
    M2 = M2SL,
    Employment = PAYEMS,
    Prices = PCEPI,
    Date = sasdate,
    StockMarketIndex = `S&P 500`
  ) %>%
  select(
    Date,
    Production,
    Employment,
    Consumption,
    Prices,
  )
