#' Try conversion to numeric
#'
#' Try conversion of input element to numeric. Return the numeric representation if it succeeds, the initial value if it does not.
#'
#' @param x A single atomic value, i.e. one string, number or element.
#'
#' @returns Potentially the numeric representation of `x`, `x` otherwise.
#' @export
#'
#' @examples
#'
#' # convert string representation of a number
#' try_numeric("5")
#' try_numeric("1e5")
#' try_numeric("Inf")
#'
#' # also converts logicals
#' try_numeric(TRUE)
#'
#' # does not alter elements without proper representation
#' try_numeric("one")
#' try_numeric(NA)
#' try_numeric(NULL)
#'
try_numeric <- function(x) {
  checkmate::expect_atomic(x, max.len = 1)

  test <- suppress_matching(as.numeric(x), suppress_messages = FALSE, suppress_cat_print = FALSE, pattern = "NAs")
  if (is.null(x) || is.na(test)) {
    return(x)
  } else {
    return(test)
  }
}
