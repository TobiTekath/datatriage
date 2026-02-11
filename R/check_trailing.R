#' Check for trailing elements
#'
#' Check if the provided vector has a consistently trailing element.
#' If a certain trailing value has been reached, all subsequent vector elements should be this value.
#'
#' If the trailing value does not occur in the vector, returns `TRUE`.
#'
#' @param vec The to-be-checked vector.
#' @param trail_value The trailing value to check for.
#'
#' @returns A single logical if the provided trailing is fulfilled.
#' @export
#'
#' @examples
#'
#' # 3 is trailing
#' vec <- c(1, 2, 3, 3, 3)
#' check_trailing(vec, trail_value = 3)
#'
#' # c is not trailing (interrupted by b)
#' vec <- c("b", "c", "b", "c", "c")
#' check_trailing(vec, trail_value = "c")
#'
#' # trailing value does not occur - trailing rule is not violated
#' check_trailing(vec, trail_value = "d")
#'
#' # also works with NA
#' check_trailing(c(1, NA, NA), trail_value = NA)
#'
check_trailing <- function(vec, trail_value) {
  checkmate::expect_atomic_vector(vec, any.missing = TRUE, all.missing = TRUE)
  checkmate::expect_atomic_vector(trail_value, len = 1, all.missing = TRUE)

  if (is.na(trail_value)) {
    pos <- which(is.na(vec))
  } else {
    pos <- which(vec == trail_value)
  }
  if (length(pos) == 0 | length(pos) == length(vec)) {
    return(TRUE)
  }
  not_pos <- setdiff(seq_along(vec), pos)
  if (max(not_pos) > min(pos)) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}
