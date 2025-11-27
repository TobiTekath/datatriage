#' Convert all columns to character
#'
#' Convert all columns of the provided object to `character`.
#'
#' @param df A data.frame or tibble which columns shall be converted.
#'
#' @returns A similar object as `df`, but all columns are of class `character()`.
#' @export
#'
#' @examples
#' df <- data.frame(a = c(1, 2, 3), b = c("a", "b", "c"))
#' df
#'
#' all_to_character(df)
all_to_character <- function(df) {
  checkmate::expect_data_frame(df, null.ok = FALSE)
  return(df |> dplyr::mutate(dplyr::across(tidyselect::everything(), ~ as.character(.))))
}
