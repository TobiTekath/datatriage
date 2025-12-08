#' Relocate multiple columns
#'
#' Re-position multiple data frame columns at once.
#' Extended wrapper around [dplyr::relocate()] to support relocation of multiple columns to multiple respective positions at once.
#'
#' All column (selection) indices are converted to names, to allow multiple relocation operations for the same column without index confusion.
#'
#' @param df A data.frame or tibble with columns that shall be relocated.
#' @param move The columns that shall be moved. Can be column names, indices, <[`tidy-select`][dplyr_tidy_select]> or <[`data-masking`][rlang::args_data_masking]> expressions.
#' @param before The columns, where the respective `move` column shall be placed **before**. Can be column names, indices, <[`tidy-select`][dplyr_tidy_select]> or <[`data-masking`][rlang::args_data_masking]> expressions.
#' @param after The columns, where the respective `move` column shall be placed **after**. Can be column names, indices, <[`tidy-select`][dplyr_tidy_select]> or <[`data-masking`][rlang::args_data_masking]> expressions.
#'
#' @returns `df` with re-positioned columns.
#' @export
#'
#' @examples
#' df <- data.frame("a" = 1:2, "b" = 3:4, "c" = 5:6, "d" = 7:8)
#' df
#'
#' # Move column "a" after "b" and column "c" after "d"
#' relocate_multi(df, move = c("a", "c"), after = c("b", "d"))
#'
#' # The same operation with indices
#' relocate_multi(df, move = c(1, 3), after = c(2, 4))
#'
#' # The same operation with tidy-select expression
#' df |> relocate_multi(move = tidyselect::all_of(c(1, 3)), after = tidyselect::all_of(c(2, 4)))
#'
#' # Use data masking to move "b" before "a"
#' df |> relocate_multi(move = rlang::expr(b), before = rlang::expr(a))
#'
#' # Relocation operations are sequential:
#' # Move "c" after "d" -> abdc
#' # Move "a" after "c" -> bdca
#' # Move "a" after "d" -> bdac
#' relocate_multi(df, move = c("c", "a", "a"), after = c("d", "c", "d"))
#'
relocate_multi <- function(df, move = NULL, before = NULL, after = NULL) {
  checkmate::expect_data_frame(df, null.ok = FALSE)

  # do not throw warning for potentially evaluating tidy-select expression
  if (rlang::quo_is_null(rlang::enquo(move))) {
    return(df)
  }
  rlang::check_exclusive(before, after)

  move_eval <- names(tidyselect::eval_select(expr = move, data = df))
  # in case of duplicated values
  if (length(move) != length(move_eval)) {
    move_eval <- move_eval[match(move, unique(move))]
  }

  # coalesce does not handle data mask variables
  if (rlang::quo_is_null(rlang::enquo(before))) {
    to_eval <- names(tidyselect::eval_select(expr = after, data = df))
    # in case of duplicated values
    if (length(after) != length(to_eval)) {
      to_eval <- to_eval[match(after, unique(after))]
    }
  } else {
    to_eval <- names(tidyselect::eval_select(expr = before, data = df))
    # in case of duplicated values
    if (length(before) != length(to_eval)) {
      to_eval <- to_eval[match(before, unique(before))]
    }
  }
  stopifnot("relocate_multi: `move` and `before` or `after` must have same length." = length(move_eval) == length(to_eval))

  df_reloc <- purrr::reduce2(
    .x = move_eval,
    .y = to_eval,
    .f = function(x, y, z) {
      if (is.null(before)) {
        dplyr::relocate(.data = x, tidyselect::all_of(y), .before = NULL, .after = tidyselect::all_of(z))
      } else {
        dplyr::relocate(.data = x, tidyselect::all_of(y), .before = tidyselect::all_of(z), .after = NULL)
      }
    },
    .init = df
  )
  return(df_reloc)
}
