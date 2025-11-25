#' Find not-fitting element (culprit) in vector
#'
#' Find the element(s) in a vector, whose data type potentially deviates from the majority data type or a specified one.
#'
#' This function can be used to find the culprit element, which prevents clean data type conversion.
#' Utilizes [readr::guess_parser()] to guess type of every vector element.
#' User can specify which data type the vector `should_be`, or simply rely on the majority guess.
#' Ties in the majority guess are resolved lexicographically by data type name, i.e. `character` > `double` > `integer` > `logical`.
#' If `should_be` is `numeric`, the data type is interpreted as `double` for lexicographic sorting.
#'
#' @param vec Data vector to find the not-fitting element in.
#' @param should_be Expected data type of `vec`. `Numeric` is indifferent if double or integer is provided. If set to `majority`, expect the data type of most of the elements.
#' @param return_index Return index of culprit elements rather than their value.
#' @param na.rm Do not treat `NA` values as culprits, i.e. discard them from the culprit return.
#' @param verbose If guessed data type should be printed if `should_be` is `majority`.
#' @inheritDotParams readr::guess_parser -x -guess_integer
#'
#' @returns A named vector, with either the element values (default) or their index (`return_index`) and the guessed data types as names.
#' @export
#'
#' @examples
#' long_data <- c(1, 2.2, "4,", 5)
#'
#' # standard type conversion would convert "4," to NA
#' \dontrun{
#' as.numeric(long_data)
#' }
#'
#' # better for maximizing information content: find culprit element and treat it appropriately
#' find_culprit(long_data, should_be = "numeric")
#' as.numeric(gsub(",", "", long_data))
find_culprit <- function(vec, should_be = c("majority", "numeric", "double", "integer", "character", "logical"), return_index = FALSE, na.rm = TRUE, verbose = TRUE, ...) {
  checkmate::expect_atomic_vector(vec)
  checkmate::expect_subset(should_be, choices = c("majority", "numeric", "double", "integer", "character", "logical"), empty.ok = FALSE)
  checkmate::expect_flag(return_index)
  checkmate::expect_flag(na.rm)
  checkmate::expect_flag(verbose)

  should_be <- match.arg(should_be)

  if (rlang::is_empty(vec)) {
    return(NULL)
  }

  guess <- vapply(as.character(vec),
    FUN = function(x) readr::guess_parser(x = x, guess_integer = ifelse(should_be == "numeric", FALSE, TRUE), ...),
    FUN.VALUE = character(1)
  )

  if (should_be == "majority") {
    should_be <- names(which.max(table(guess)))
    if (verbose) {
      message("Supplied data should be '", should_be, "' by majority guess.")
    }
  } else if (should_be == "numeric") {
    should_be <- "double"
  }

  culprit <- which(guess != should_be)
  if (na.rm) {
    culprit <- culprit[!is.na(names(culprit))]
  }
  if (return_index) {
    ret <- stats::setNames(culprit, guess[culprit])
  } else {
    ret <- stats::setNames(names(culprit), guess[culprit])
  }

  if (rlang::is_empty(ret)) {
    return(NULL)
  } else {
    return(ret)
  }
}
