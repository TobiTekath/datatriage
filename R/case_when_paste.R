#' case_when variant that pastes results of matched formulas.
#'
#' Drop-in replacement for [case_when()][dplyr::case_when()], when you want combined output from the provided formulas.
#' Evaluates each formula separately, then combines the result per entry.
#' Drops `NA` results before pasting - `NA` should only be supplied in `.default` if necessary.
#'
#' @inheritParams dplyr::case_when
#' @param .sep The string separator for the different results when being combined.
#'
#' @returns A vector with the same size as the inputs.
#' @export
#'
#' @examples
#' x <- data.frame(a = c(1, 2, 3), b = c(1, 2, 4))
#' x
#'
#' dplyr::mutate(x,
#'   class = case_when_paste(
#'     a == b ~ "equal",
#'     a == 1 ~ "special",
#'     .default = "not equal",
#'     .sep = " - "
#'   )
#' )
#' @importFrom rlang !!!
case_when_paste <- function(..., .default = "", .sep = "") {
  checkmate::expect_string(.default, na.ok = TRUE)
  checkmate::expect_string(.sep, na.ok = FALSE)

  formulas <- rlang::list2(...)
  if (length(formulas) == 0) {
    # Mimic case_when()
    rlang::abort("At least one condition must be supplied.")
  }

  # apply formulas one by one
  pieces <- sapply(formulas, function(x) {
    dplyr::case_when(!!!rlang::enquos(x), .default = .default)
  }, simplify = TRUE)

  # paste together
  out <- apply(pieces, 1, function(row) {
    vals <- row[!is.na(row) & !(row %in% .default)]
    if (length(vals) == 0) {
      .default
    } else {
      stringr::str_c(vals, collapse = .sep)
    }
  })
  return(out)
}
