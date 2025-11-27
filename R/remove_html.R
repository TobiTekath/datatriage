#' Strip html tags
#'
#' Strip html tags from vec and potentially [stringr::str_squish()] to remove excessive newlines and whitespace.
#'
#' @param vec Character vector where html tags shall be removed from.
#' @param squish If excessive newlines and whitespace shall be removed from stripped text. Uses [stringr::str_squish()].
#'
#' @returns A character vector without html tags.
#' @export
#'
#' @examples
#' text <- "text with <p> some tags </p>"
#' text
#'
#' remove_html(text)
remove_html <- function(vec, squish = TRUE) {
  checkmate::expect_character(vec, null.ok = FALSE)
  checkmate::expect_flag(squish)

  stripped <- stringr::str_remove_all(vec, "<([a-z]+|/|\\!).*?>")
  if (squish) {
    stripped <- stringr::str_squish(stripped)
  }
  return(stripped)
}
