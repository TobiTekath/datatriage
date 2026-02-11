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
check_trailing_rowwise <- function(df, cols, trail_value) {
  checkmate::expect_data_frame(df)
  checkmate::expect_subset(cols, colnames(df), empty.ok = FALSE)

  ret <- df |>
    dplyr::select(tidyselect::all_of(cols)) |>
    dplyr::rowwise() |>
    dplyr::mutate(.trail = check_trailing(vec = dplyr::c_across(tidyselect::everything()), trail_value = trail_value)) |>
    dplyr::pull(.trail)
  return(ret)
}
