#' Summarize outlier values for numeric vectors
#'
#' Utilize [check_outliers()][performance::check_outliers()] to determine which values are determined as outliers.
#' Summarizes the result to a comma-separated, decreasing string.
#' Allows to specify a minimal amount of unique values in `vec` to perform outlier detection.
#'
#'
#' @param vec The vector to be checked for outliers.
#' @param minimal_unique_values Amount of unique values in `vec` before the outlier detection is performed. Set to `1` to always perform detection.
#' @inheritParams performance::check_outliers
#'
#' @returns A summary string of outliers, an empty string if not outliers where detected.
#' @export
#'
#' @examples
#' norm <- rnorm(n = 100)
#' shift_norm <- rnorm(n = 10, mean = 999)
#' vec <- sample(c(norm, shift_norm))
#'
#' summarize_outlier(vec)
summarize_outlier <- function(vec, minimal_unique_values = 10, method = c("iqr", "zscore_robust"), threshold = list(zscore_robust = 7, iqr = 5)) {
  checkmate::expect_atomic_vector(vec, all.missing = TRUE)
  checkmate::expect_int(minimal_unique_values, na.ok = FALSE, lower = 1)
  checkmate::expect_character(method, min.len = 1, any.missing = FALSE)
  checkmate::expect_list(threshold, types = "numeric", any.missing = FALSE, len = length(method), names = "named")

  if (is.numeric(vec)) {
    if (length(unique(vec)) >= minimal_unique_values) {
      outlier <- performance::check_outliers(vec, method = method, threshold = threshold, verbose = FALSE)
      if (length(which(outlier)) > 0) {
        return(stringr::str_flatten_comma(sort(vec[which(outlier)], decreasing = TRUE)))
      }
    }
  }
  return("")
}
