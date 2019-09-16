
# Transform database of FED factors from .txt to .csv ---------------------------------

factors.FED <- readr::read_csv(
  "./Data/FactorsFED.txt",
  col_names = c(paste0(rep("F", 7), 1:7)), 
  col_types = stringr::str_c(rep("d", 7), collapse = ""), 
  n_max = 715
)

readr::write_csv(factors.FED, "./Data/FactorsFED.csv")
