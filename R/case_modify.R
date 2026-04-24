#' A general vectorised switch() that keeps unaffected values
#'
#' A convenience wrapper around [dplyr::case_match()], with `.default` set to the input parameter `.x` (i.e. keeping values unaffected by any switch statements as they are). See **Warning** below.
#'
#' **Warning**
#' This function was only useful before release of dplyr 1.2.0 - since then [dplyr::case_match()] has been deprecated and the whole recode and replace system overhauled.
#' Use [dplyr::replace_values()] as a direct substitute of this function.
#'
#' @param .x A vector to match against.
#' @inherit dplyr::case_match params
#'
#' @returns A vector with the same size as .x.
#' @export
#'
#' @examples
#' dummy_df <- data.frame("a" = c(1:3))
#' dummy_df
#'
#' # only replace 3 by 4, keep the rest
#' dplyr::mutate(dummy_df, a = case_modify(a, 3 ~ 4))
case_modify <- function(.x, ...) {
  if (utils::packageVersion("dplyr") < "1.2.0") {
    return(dplyr::case_match(.x = .x, .default = .x, ...))
  } else {
    # use recode_values instead of replace_values to mimic case_match ability to potentially adjust ptype.
    return(dplyr::recode_values(x = .x, default = .x, ...))
  }
}
