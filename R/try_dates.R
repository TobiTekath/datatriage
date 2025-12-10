#' Try conversion to date representation
#'
#' Wrapper around [try_date()] for multiple values.
#' Try conversion of date serial values to their respective date representation.
#'
#' @inherit try_date details
#' @inheritDotParams try_date -x -return_character
#'
#' @param vec Vector containing values to try conversion.
#'
#' @returns A character vector with potentially converted dates.
#' @export
#'
#' @examples
#' serial_values <- c(10000, 20000, 30000)
#'
#' # convert with minimal date set - first value is not converted
#' try_dates(serial_values, min_date = "1950-01-01")
#'
#' @seealso [try_date()]
try_dates <- function(vec, ...) {
  checkmate::expect_atomic_vector(vec, any.missing = TRUE, all.missing = TRUE)
  return(sapply(vec, FUN = function(x) as.character(try_date(x, ...)), USE.NAMES = FALSE))
}
