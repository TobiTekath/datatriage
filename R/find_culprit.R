# todo
find_culprit <- function(vec, should_be = c("numeric", "double", "integer", "character", "logical"), return_id = FALSE, na.rm = TRUE) {
  should_be <- match.arg(should_be)
  guess <- sapply(as.character(vec), FUN = function(x) readr::guess_parser(x, guess_integer = ifelse(should_be == "integer", TRUE, FALSE)))

  if (should_be == "numeric") {
    should_be <- "double"
  }

  culprit <- which(guess != should_be)
  if (na.rm) {
    culprit <- culprit[!is.na(names(culprit))]
  }
  if (return_id) {
    return(stats::setNames(culprit, guess[culprit]))
  } else {
    return(stats::setNames(names(culprit), guess[culprit]))
  }
}
