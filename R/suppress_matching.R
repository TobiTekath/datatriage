#' Selectively suppress messages, warnings, cat and print
#'
#' Selectively suppress messages, warnings, cat and/or print whose output matches given regex pattern.
#'
#' Utilizes [grepl()] for matching output with given regex pattern.
#' Selective suppression of [cat()] and [print()] is tricky, as differentiation of single output is not trivial.
#' This function applies a simple heuristic to at least separate [print()] output from each other and [cat()].
#' Two consecutive [cat()] outputs can not be differentiated at the moment, potentially leading to unwanted selective suppression behavior.
#'
#' @param expr An expression that potentially produces some output.
#' @param pattern Provide a regex-string to only suppress matching output. If `NULL`, suppresses all output.
#' @param suppress_messages If output from [message()] shall be suppressed.
#' @param suppress_warnings If output from [warning()] shall be suppressed.
#' @param suppress_cat_print If output from [cat()] and [print()] shall be suppressed.
#' @inheritDotParams base::grepl -x -pattern
#'
#' @returns The return value of the `expr`.
#' @export
#'
#' @examples
#' noisy_fun <- function() {
#'   message("I am a message")
#'   warning("I am a warning")
#'   cat("I am a cat")
#'   print("I am a print")
#'   return(TRUE)
#' }
#'
#' # suppress all
#' result <- suppress_matching(noisy_fun())
#'
#' # suppress by matching regex
#' result <- suppress_matching(noisy_fun(), pattern = ".*am A.*", ignore.case = TRUE)
suppress_matching <- function(expr,
                              pattern = NULL,
                              suppress_messages = TRUE,
                              suppress_warnings = TRUE,
                              suppress_cat_print = TRUE,
                              ...) {
  checkmate::expect_string(pattern, null.ok = TRUE)
  checkmate::expect_flag(suppress_messages)
  checkmate::expect_flag(suppress_warnings)
  checkmate::expect_flag(suppress_cat_print)

  # helper pattern matching function
  pattern_match <- function(msg, pattern, ...) {
    if (is.null(pattern)) {
      return(TRUE)
    } else {
      return(grepl(pattern, msg, ...))
    }
  }

  output_text <- utils::capture.output(result <- withCallingHandlers(
    expr,
    message = function(m) {
      if (suppress_messages && pattern_match(conditionMessage(m), pattern, ...)) {
        invokeRestart("muffleMessage")
      }
    },
    warning = function(w) {
      if (suppress_warnings && pattern_match(conditionMessage(w), pattern, ...)) {
        invokeRestart("muffleWarning")
      }
    }
  ), type = "output")

  # heuristic to split output_text
  output_text <- unlist(stringr::str_split(output_text, pattern = "(?=\\[1\\])"))
  ## drop empty strings
  output_text <- output_text[nzchar(output_text, keepNA = TRUE)]

  if (suppress_cat_print) {
    output_text <- output_text[!pattern_match(output_text, pattern, ...)]
  }
  if (!rlang::is_empty(output_text)) {
    cat(output_text, sep = "\n")
  }

  return(result)
}
