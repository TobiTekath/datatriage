#' Re-convert character columns in existing data frame
#'
#' Convenience wrapper around [all_decimal_points_to_dot()] and [readr::type_convert()].
#' Optionally converts numeric-like characters with a comma as decimal point (as used in e.g. Germany) to dots,
#' then performs a re-guessing of column types of all character columns.
#'
#' @param df A data.frame or tibble which character columns class shall be re-guessed.
#' @param convert_comma_to_dot Shall numeric-like characters with a comma as decimal point like '1,2' be converted to '1.2' before column type guessing?
#' @param silent Suppress messages from [readr::type_convert()] column type guessing.
#' @inheritDotParams readr::type_convert -df
#'
#' @returns A similar object as `df`, but column types potentially have been changed.
#' @export
#'
#' @examples
#' df <- data.frame(a = c(1, 2, 3), b = c(TRUE, FALSE, NA), c = factor(c(1, 2, 1)))
#' char_df <- all_to_character(df)
#' reguess_coltypes(char_df)
#'
#' # convert column b to numeric if convert_comma_to_dot is set.
#' df <- data.frame(a = c("a,b", "1,b", "c,0"), b = c("1,1", "1,2", "1,3"))
#' reguess_coltypes(df, convert_comma_to_dot = TRUE)
reguess_coltypes <- function(df, convert_comma_to_dot = FALSE, silent = TRUE, ...) {
  checkmate::expect_data_frame(df, null.ok = FALSE)
  checkmate::expect_flag(convert_comma_to_dot)
  checkmate::expect_flag(silent)

  if (convert_comma_to_dot) {
    df <- df |> all_decimal_points_to_dot(trim_ws = TRUE)
  }

  if (silent) {
    suppressMessages(df <- readr::type_convert(df = df, ...))
  } else {
    df <- readr::type_convert(df = df, ...)
  }

  return(df)
}
