#' NA-aware str_c
#'
#' NA-aware drop-in replacement for [str_c()][stringr::str_c()].
#' Discards NAs when other strings are present. Reduces multiple NAs to a single one.
#'
#' @inheritParams stringr::str_c
#'
#' @inherit stringr::str_c return
#' @export
#'
#' @examples
#' vec <- c("a", NA, "b")
#'
#' # only returns NA
#' stringr::str_c(vec)
#'
#' # discards NA
#' str_c_na(vec)
#'
#' # collapse also discards NAs
#' str_c_na(c("a", NA), c(NA, "b"), collapse = ", ")
#'
#' @importFrom rlang !!!
str_c_na <- function(..., sep = "", collapse = NULL) {
  checkmate::expect_string(sep, na.ok = FALSE, null.ok = FALSE)
  checkmate::expect_string(collapse, na.ok = FALSE, null.ok = TRUE)

  args <- list(...)

  if (length(args) == 0) {
    return(stringr::str_c())
  }

  max_len <- max(lengths(args))
  # repeat args to have same length
  args <- lapply(args, function(x) rep_len(x, max_len))
  results <- character(max_len)

  for (i in seq_len(max_len)) {
    elements <- vapply(args, function(x) as.character(x[i]), character(1))

    if (all(is.na(elements))) {
      results[i] <- NA_character_
    } else {
      clean <- elements[!is.na(elements)]
      results[i] <- rlang::exec(stringr::str_c, !!!clean, sep = sep)
    }
  }

  if (!is.null(collapse)) {
    if (all(is.na(results))) {
      return(NA)
    } else {
      results <- results[!is.na(results)]
      results <- stringr::str_c(results, collapse = collapse)
    }
  }
  return(results)
}
