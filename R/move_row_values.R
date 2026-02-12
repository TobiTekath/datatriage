#' Move specific values to other column
#'
#' Move specific values in a `data.frame` or `tibble` to other column(s).
#' Specify which rows shall be affected by either providing row indices or a logical vector to `select_rows`.
#' A column name can also be supplied to `select_rows`, then the matching values of rows have to be supplied in `select_rows_values`.
#' It is possible to specify more than one `from_col` and `to_col` - but always the same number of columns.
#' Moved values in `from_col` are replaced with `clear_value`.
#'
#' @param df A `data.frame` or `tibble`.
#' @param select_rows Which rows of `df` shall be selected for moving? Can be indices, logical values or a column name of `df`.
#' @param select_rows_values If a column name was supplied in `select_rows`, specify the column values of the rows you want to select.
#' @param from_col From which columns of `df` shall the values of selected entries be moved?
#' @param to_col To which columns of `df` shall the values of selected entries be moved?
#' @param clear_value With what value shall the moved values in `from_col` be replaced?
#'
#' @returns An object with same shape and class as `df`.
#' @export
#'
#' @examples
#' df <- data.frame(
#'   "id" = letters[1:5], "a" = c(5:1), "b" = c(5:4, NA, 2:1),
#'   "c" = c(1:5), "d" = c(1:2, 2, 4:5)
#' )
#' df
#'
#' # move for row 3, column a to b - replace with NA
#' df_mov <- move_row_values(df, select_rows = 3, from_col = "a", to_col = "b", clear_value = NA)
#' df_mov
#'
#' # move multiple columns and rows
#' df_mov <- move_row_values(df,
#'   select_rows = "id", select_rows_values = c("c", "d"),
#'   from_col = c("a", "c"), to_col = c("b", "d"), clear_value = 3
#' )
#' df_mov
#'
#' # switching values is also possible e.g. by moving from a to b and b to a.
#' df_mov <- move_row_values(df,
#'   select_rows = c(FALSE, FALSE, TRUE),
#'   from_col = c("a", "b"), to_col = c("b", "a"), clear_value = NA
#' )
#' df_mov
#' @importFrom rlang !!
move_row_values <- function(df, select_rows = colnames(df)[1], select_rows_values = NULL, from_col, to_col, clear_value = NA) {
  checkmate::expect_data_frame(df, min.cols = 1, min.rows = 1)
  checkmate::expect_atomic_vector(select_rows, any.missing = FALSE, min.len = 1, max.len = nrow(df))
  checkmate::expect_subset(from_col, choices = colnames(df), empty.ok = FALSE)
  checkmate::expect_subset(to_col, choices = colnames(df), empty.ok = FALSE)
  checkmate::expect_character(to_col, len = length(from_col))
  checkmate::expect_atomic_vector(clear_value, len = 1)

  if (!is.character(select_rows)) {
    if (!is.null(select_rows_values)) {
      rlang::warn("move_row_values: Discarding provided 'select_row_values' as 'select_rows' is not a column name.")
    }
    if (is.logical(select_rows)) {
      select_rows_values <- df[[1]][which(select_rows)]
    } else if (rlang::is_integerish(select_rows)) {
      select_rows_values <- df[[1]][select_rows]
    } else {
      rlang::abort("Please provide a valid integer, logical or character vector for 'select_rows'", class = "expectation_failure")
    }
    select_rows <- colnames(df)[1]
  }

  checkmate::expect_subset(select_rows, colnames(df), empty.ok = FALSE)
  checkmate::expect_subset(select_rows_values, df[[select_rows]], empty.ok = FALSE, info = "Please select the rows thats should be affected.")

  new_colnames <- stats::setNames(from_col, to_col)

  # insert .tmp id column if select column is in from_col or to_col
  if (select_rows %in% from_col | select_rows %in% to_col) {
    df <- df |>
      dplyr::mutate(.tmp = !!rlang::sym(select_rows))
    select_rows <- ".tmp"
  }

  df_up <- df |>
    dplyr::filter(!!rlang::sym(select_rows) %in% select_rows_values) |>
    dplyr::select(tidyselect::all_of(c(select_rows, from_col)))

  df_clear <- df_up |>
    dplyr::mutate(dplyr::across(!tidyselect::all_of({{ select_rows }}), ~clear_value))

  df_up <- df_up |>
    dplyr::rename(tidyselect::all_of(new_colnames))

  if (select_rows == ".tmp") {
    df_ret <- df |>
      dplyr::rows_update(y = df_clear, by = select_rows) |>
      dplyr::rows_update(y = df_up, by = select_rows) |>
      dplyr::select(-".tmp")
  } else {
    df_ret <- df |>
      dplyr::rows_update(y = df_clear, by = select_rows) |>
      dplyr::rows_update(y = df_up, by = select_rows)
  }


  return(df_ret)
}
