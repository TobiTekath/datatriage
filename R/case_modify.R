#' A general vectorised switch() that keeps unaffected values
#'
#' A convenience wrapper around [dplyr::case_match()], with `.default` set to the input parameter `.x` (i.e. keeping values unaffected by any switch statements as they are)
#'
#' @param .x A vector to match against.
#' @inherit dplyr::case_match params
#'
#' @returns A vector with the same size as .x.
#' @export
#'
#' @examples
#' dummy_df <- data.frame("a" = c(1:3))
#' # only replace 3 by 4, keep the rest
#' dplyr::mutate(dummy_df, a = case_modify(a, 3 ~ 4))
case_modify <- function(.x, ...) {
  return(dplyr::case_match(.x = .x, .default = .x, ...))
}
