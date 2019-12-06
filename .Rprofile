# Set common options
options(
  digits = 4,
  prompt = "R> ",
  show.signif.stars = FALSE
  #warnPartialMatchArgs = TRUE,
  #warnPartialMatchDollar = TRUE
)

# Startup functions
.First <- function() {
  if (interactive()) {
    require(conflicted)
  }
  
  cat("\nWelcome at", format(Sys.time(), '%B %Y'), "\n")
}

# Session end function
.Last <- function() {
  cat("\nGoodbye at", format(Sys.time(), '%B %Y'), "\n")
}
