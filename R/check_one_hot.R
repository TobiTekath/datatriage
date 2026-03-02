#' Check one-hot encoding
#'
#' Check if specified columns follow a one-hot coding scheme, i.e. only one "positive" value per row across the columns.
#'
#' You can specify if rows without selection, i.e. rows without "positive" value, should be regarded as valid.
#' Does not check the format of the other "negative" values.
#'
#' @param df A `data.frame` or `tibble`.
#' @param cols Which columns of `df` shall be checked?
#' @param check_value Which value represents a `positive selection`?
#' @param allow_no_selection Shall rows without `check_value` be valid or not?
#'
#' @returns A logical vector indicating for every row of `df` if the selected columns follow a one-hot encoding scheme.
#' @export
#'
#' @examples
#' df <- data.frame(a = c(1, 0, 0), b = c(0, 0, 1), c = c(0, NA, 1))
#' df
#'
#' # every row must have a positive selection
#' check_one_hot(df, cols = colnames(df))
#'
#' # also allow empty rows
#' check_one_hot(df, cols = colnames(df), allow_no_selection = TRUE)
#'
#' # also works with other "positive" values
#' df <- data.frame(a = c("one", "two"), b = c("two", "oneone"))
#' df
#'
#' check_one_hot(df, cols = colnames(df), check_value = "one")
#'
check_one_hot <- function(df, cols, check_value = 1, allow_no_selection = FALSE) {
  checkmate::expect_data_frame(df, min.cols = 1, min.rows = 1)
  checkmate::expect_subset(cols, choices = colnames(df), empty.ok = FALSE)
  checkmate::expect_atomic(check_value, len = 1)
  checkmate::expect_flag(allow_no_selection)

  if (is.na(check_value)) {
    # always pass two values to check function
    check_fun <- function(x, y) is.na(x)
  } else {
    check_fun <- `==`
  }

  df <- df |>
    dplyr::select(tidyselect::all_of(cols)) |>
    dplyr::mutate(dplyr::across(tidyselect::everything(), ~ check_fun(.x, check_value)))
  if (allow_no_selection) {
    res <- df |>
      dplyr::mutate(.res = rowSums(dplyr::across(tidyselect::everything()), na.rm = TRUE) < 2)
  } else {
    res <- df |>
      dplyr::mutate(.res = rowSums(dplyr::across(tidyselect::everything()), na.rm = TRUE) == 1)
  }
  return(dplyr::pull(res, ".res"))
}
