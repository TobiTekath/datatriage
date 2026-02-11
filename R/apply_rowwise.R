#' Apply a function itemwise to two vectors
#'
#' Apply a function rowwise to two same length vectors, e.g. comparison functions.
#' Optionally apply wrap functions to each item before the apply function.
#' Functions can also be function names (e.g. "sum" or "+").
#'
#' @param vec1 Atomic vector 1.
#' @param vec2 Atomic vector 2.
#' @param apply_fun The function that should be applied to both elements from `vec1` and `vec2` at the same index. Can be a function or a function name.
#' @param wrap_fun_vec1 Optionally, a function that shall be applied to every `vec1` element before applying `apply_fun`. Can be a function or a function name.
#' @param wrap_fun_vec2 Optioanlly, a function that shall be applied to every `vec2` element before applying `apply_fun`. Can be a function or a function name.
#'
#' @returns A result of the same length as the input vectors.
#' @export
#'
#' @examples
#' # Can be useful for comparing vectors of potentially different data types.
#' vec1 <- c(1:5)
#' vec2 <- c(0:2, "a", "b")
#'
#' apply_rowwise(vec1, vec2, apply_fun = ">", wrap_fun_vec2 = try_numeric)
#'
apply_rowwise <- function(vec1, vec2, apply_fun, wrap_fun_vec1 = NULL, wrap_fun_vec2 = NULL) {
  checkmate::expect_atomic_vector(vec1)
  checkmate::expect_atomic_vector(vec2, len = length(vec1))
  checkmate::assert(
    checkmate::check_function(apply_fun),
    checkmate::check_string(apply_fun),
    combine = "or"
  )
  checkmate::assert(
    checkmate::check_function(wrap_fun_vec1),
    checkmate::check_string(wrap_fun_vec1, null.ok = TRUE),
    combine = "or"
  )
  checkmate::assert(
    checkmate::check_function(wrap_fun_vec2),
    checkmate::check_string(wrap_fun_vec2, null.ok = TRUE),
    combine = "or"
  )

  # get matching function if name is provided.
  apply_fun <- match.fun(apply_fun)
  if (!is.null(wrap_fun_vec1)) {
    wrap_fun_vec1 <- match.fun(wrap_fun_vec1)
  }
  if (!is.null(wrap_fun_vec2)) {
    wrap_fun_vec2 <- match.fun(wrap_fun_vec2)
  }

  if (is.null(wrap_fun_vec1) & is.null(wrap_fun_vec2)) {
    ret <- sapply(seq_along(vec1), function(i) apply_fun(vec1[[i]], vec2[[i]]))
  } else if (is.null(wrap_fun_vec2)) {
    ret <- sapply(seq_along(vec1), function(i) apply_fun(wrap_fun_vec1(vec1[[i]]), vec2[[i]]))
  } else if (is.null(wrap_fun_vec1)) {
    ret <- sapply(seq_along(vec1), function(i) apply_fun(vec1[[i]], wrap_fun_vec2(vec2[[i]])))
  } else {
    ret <- sapply(seq_along(vec1), function(i) apply_fun(wrap_fun_vec1(vec1[[i]]), wrap_fun_vec2(vec2[[i]])))
  }
  return(ret)
}
