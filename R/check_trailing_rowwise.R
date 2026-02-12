#' Check rowwise for trailing elements
#'
#' Check rowwise for the provided data.frame columns if a value is trailing.
#'
#' @param df A `data.frame` or `tibble`.
#' @param cols Which columns of `df` shall be checked rowwise?
#' @param trail_value Which trailing value to check for?
#'
#' @returns A logical vector of the same size as `df` has rows.
#' @export
#'
#' @examples
#' df <- data.frame(a = c(1, 2, 3), b = c(2, 3, 2), c = c(3, 3, 3))
#' df
#'
#' # check over all columns rowwise for trailing 3s
#' check_trailing_rowwise(df, cols = colnames(df), trail_value = 3)
check_trailing_rowwise <- function(df, cols, trail_value) {
  checkmate::expect_data_frame(df)
  checkmate::expect_subset(cols, colnames(df), empty.ok = FALSE)

  ret <- df |>
    dplyr::select(tidyselect::all_of(cols)) |>
    dplyr::rowwise() |>
    dplyr::mutate(".trail" = check_trailing(vec = dplyr::c_across(tidyselect::everything()), trail_value = trail_value)) |>
    dplyr::pull(".trail")
  return(ret)
}
