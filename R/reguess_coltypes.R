#' Re-convert character columns in existing data frame
#'
#' Convenience wrapper around [all_decimal_points_to_dot()] and [minty::type_convert()].
#' Optionally converts numeric-like characters with a comma as decimal point (as used in e.g. Germany) to dots,
#' then performs a re-guessing of column types of all character columns.
#'
#' @param df A data.frame or tibble which character columns class shall be re-guessed.
#' @param convert_comma_to_dot Shall numeric-like characters with a comma as decimal point like '1,2' be converted to '1.2' before column type guessing?
#' @param silent Suppress column specification message from [minty::type_convert()] column type guessing.
#' @inheritDotParams minty::type_convert -df
#'
#' @returns A similar object as `df`, but column types potentially have been changed.
#' @export
#'
#' @examples
#' # create data frame of characters
#' df <- data.frame(a = c(1, 2, 3), b = c(TRUE, FALSE, NA), c = factor(c(1, 2, 1))) |>
#'   all_to_character()
#' df
#'
#' reguess_coltypes(df)
#'
#' # convert column b to numeric if convert_comma_to_dot is set.
#' df <- data.frame(a = c("a,b", "1,b", "c,0"), b = c("1,1", "1,2", "1,3"))
#' reguess_coltypes(df, convert_comma_to_dot = TRUE)
reguess_coltypes <- function(df, convert_comma_to_dot = FALSE, silent = TRUE, ...) {
  checkmate_wrapper(checkmate::check_data_frame(df, null.ok = FALSE))
  checkmate_wrapper(checkmate::check_flag(convert_comma_to_dot))
  checkmate_wrapper(checkmate::check_flag(silent))

  if (convert_comma_to_dot) {
    df <- df |> all_decimal_points_to_dot(trim_ws = TRUE)
  }

  df <- minty::type_convert(df = df, verbose = !silent, ...)

  return(df)
}
