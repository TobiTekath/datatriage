#' Transpose a data.frame or tibble
#'
#' Allow transposing a data.frame or tibble in a "tidy" way.
#' Instead of row names, the column names of the transposed object are taken from a specified `id_col`.
#' \cr**Note**: The input `df` should **not contain** row names, as they would be discarded.
#'
#' @param df The to-be-transposed data.frame or tibble.
#' @param id_col Which column of `df` shall be used as new column names? Can be either an index or a column name.
#' @param exclude_cols Exclude specified columns before transposing. Can be either one or multiple indices or a column names, or `NULL`.
#' @param new_id_colname Rename the first column of the transposed object. If `NULL`, carry over the selected `id_col` column name.
#' @param reguess_coltypes Shall a re-guessing of column types be performed after transposing?
#' Allows to correctly retrieve e.g. numeric or logical columns by utilizing [reguess_coltypes()].
#'
#' @returns A transposed object - keeps object type of `df` input (data.frame or tibble).
#' @export
#'
#' @examples
#'
#' df <- data.frame(a = c("x1", "1", "FALSE"), b = c("x2", "2", "TRUE"))
#'
#' tidy_t(df)
#'
#' # reguessing column types
#' tidy_t(df, reguess_coltypes = TRUE)
#'
#' # using second column as id column
#' tidy_t(df, id_col = "b")
#'
#' # excluding columns
#' tidy_t(df, exclude_cols = "b")
#'
#' # renaming id column
#' tidy_t(df, new_id_colname = "var")
tidy_t <- function(df, id_col = 1, exclude_cols = NULL, new_id_colname = NULL, reguess_coltypes = FALSE) {
  checkmate::expect_data_frame(df, null.ok = FALSE)
  checkmate::assert(
    checkmate::check_integerish(id_col, len = 1, any.missing = FALSE, null.ok = FALSE, lower = 1, upper = ncol(df)),
    checkmate::check_choice(id_col, choices = colnames(df), null.ok = FALSE)
  )
  checkmate::assert(
    checkmate::check_integerish(exclude_cols, any.missing = FALSE, null.ok = TRUE, lower = 1, upper = ncol(df)),
    checkmate::check_subset(exclude_cols, choices = colnames(df), empty.ok = FALSE)
  )
  checkmate::expect_string(new_id_colname, na.ok = FALSE, min.chars = 1, null.ok = TRUE)
  checkmate::expect_flag(reguess_coltypes)

  stopifnot("'df' must be a data frame without row names." = !tibble::has_rownames(df))

  if (is.character(id_col)) {
    id_col <- which(colnames(df) == id_col)
  }
  if (is.character(exclude_cols)) {
    exclude_cols <- which(colnames(df) %in% exclude_cols)
  }
  checkmate::expect_disjunct(id_col, exclude_cols, info = "id_col can not part of exclude_cols.")

  trans <- df |>
    dplyr::select(-dplyr::all_of(colnames(df)[exclude_cols])) |>
    tibble::column_to_rownames(var = colnames(df)[[id_col]]) |>
    t() |>
    tibble::as_tibble(rownames = colnames(df)[[id_col]])

  if (!is.null(new_id_colname)) {
    colnames(trans)[[1]] <- new_id_colname
  }

  if (!tibble::is_tibble(df)) {
    trans <- as.data.frame(trans) |>
      tibble::remove_rownames()
  }

  if (reguess_coltypes) {
    trans <- reguess_coltypes(trans)
  }

  return(trans)
}
