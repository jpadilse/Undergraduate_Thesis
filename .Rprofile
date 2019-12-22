# Set common options
options(
  digits = 4,
  prompt = "R> ",
  show.signif.stars = FALSE,
  continue = " ",
  warnPartialMatchArgs = TRUE,
  warnPartialMatchDollar = TRUE
)

# Python executable
Sys.setenv(RETICULATE_PYTHON = "C:\\Users\\jpadi\\Anaconda3\\python.exe")

# Quotes
if (interactive()) suppressWarnings(try(fortunes::fortune(), silent = TRUE))

# Startup functions
.First <- function() {
  if (interactive()) require(conflicted)
  
  message("\nWelcome at ", format(Sys.time(), '%B %Y'), "\n")
}

# Session end function
.Last <- function() {
  cond = suppressWarnings(!require(fortunes, quietly = TRUE))
  if (cond) try(install.packages("fortunes"), silent = TRUE)
  
  message("\nGoodbye at ", format(Sys.time(), '%B %Y'), "\n")
}
