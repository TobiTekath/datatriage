#' Adds expectation_failure class to checkmate errors
#'
#' Adds class `expectation_failure` to errors of `checkmate::check_` functions.
#' Extends functionality of `checkmate::check_` functions to be systematically used in `testthat` unit tests.
#' Allows for multiple `checkmate::check_` via `combine`, like [checkmate::assert()].
#'
#' Allows to check for catched errors like that: `testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5)), class = "expectation_failure")`
#'
#'
#' @param ... Any number of `checkmate::check_` functions.
#' @param info Add additional information to the error message.
#' @inheritParams checkmate::assert
#'
#' @returns `TRUE` invisibly if check passes, the extended error otherwise.
#'
#' @examples
#' checkmate_wrapper(checkmate::check_integerish(5))
#'
#' x <- "hi"
#' checkmate_wrapper(checkmate::check_string(x), checkmate::check_choice(x, c("hi", "ho")))
#'
#' x <- TRUE
#' checkmate_wrapper(checkmate::check_string(x), checkmate::check_flag(x), combine = "or")
checkmate_wrapper <- function(..., combine = "and", info = "") {
  # allow check combinations like checkmate::assert()
  dots <- match.call(expand.dots = FALSE)$...
  if (!is.call(dots[[1L]])) {
    stop(errorCondition("checkmate_wrapper: A valid checkmate::check_ function call must be supplied.", class = "expectation_failure"))
  }
  if (!rlang::is_scalar_character(info)) {
    stop(errorCondition("checkmate_wrapper: Invalid 'info' argument. Must be a scalar character.", class = "expectation_failure"))
  }

  env <- parent.frame()
  call <- if (sys.nframe() > 1L) sys.call(-1L) else NULL

  if (combine == "and") {
    for (expr in dots) {
      res <- eval(expr, envir = env)
      if (!isTRUE(res)) {
        v_name <- deparse1(expr[[2L]])
        msg <- paste0("Assertion on '", v_name, "' failed: ", res, "\n", info)
        stop(errorCondition(msg, class = "expectation_failure", call = call))
      }
    }
    return(invisible(TRUE))
  }

  if (combine == "or") {
    msgs <- c()
    for (expr in dots) {
      res <- eval(expr, envir = env)
      if (isTRUE(res)) {
        return(invisible(TRUE))
      }
      v_name <- deparse1(expr[[2L]])
      msgs <- c(msgs, paste0("'", v_name, "' : ", res))
    }
    full_msg <- paste(c("Assertion failed. One of the following must apply:", paste0(" * ", msgs), info), collapse = "\n")
    stop(errorCondition(full_msg, class = "expectation_failure", call = call))
  }

  stop(errorCondition("checkmate_wrapper: Invalid 'combine' argument. Must be 'and' or 'or'.", class = "expectation_failure"))
}
