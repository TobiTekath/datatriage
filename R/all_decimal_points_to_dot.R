#' Convert given decimal character to dot
#'
#' Convert specified decimal character in numeric-like character to dot.
#'
#' Has safeguards to only convert numeric-like characters - any non-numeric character will prevent conversion.
#'
#'
#' @param df A data.frame or tibble.
#' @param convert_decimal_character Specify the decimal point character that shall be converted to a dot.
#' @param trim_ws Trim white space from both ends before trying conversion?
#'
#' @returns A similar object as `df`, but with potentially replaced decimal characters.
#' @export
#'
#' @examples
#' df <- data.frame(x1 = c("1,1", "2,2", " 3,3", "4,4 ", "1,1a"))
#' all_decimal_points_to_dot(df)
#'
#' # also trim white space
#' all_decimal_points_to_dot(df, trim_ws = TRUE)
all_decimal_points_to_dot <- function(df, convert_decimal_character = ",", trim_ws = FALSE) {
  checkmate::expect_data_frame(df, null.ok = FALSE)
  checkmate::expect_string(convert_decimal_character)

  regex <- stringr::str_c("^([0-9+])", stringr::str_escape(convert_decimal_character), "([0-9+])$")

  df <- df |>
    dplyr::mutate(dplyr::across(
      tidyselect::where(is.character),
      .fns = function(x) {
        if (trim_ws) {
          x <- stringr::str_trim(x)
        }
        x <- stringr::str_replace(x, regex, "\\1.\\2")
        return(x)
      }
    ))
  return(df)
}
