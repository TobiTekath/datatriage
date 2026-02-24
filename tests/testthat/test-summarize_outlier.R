test_that("outlier summary creation works", {
  norm <- rnorm(n = 100)
  shift_norm <- rnorm(n = 10, mean = 999)

  vec <- sample(c(norm, shift_norm))

  res <- summarize_outlier(vec)
  expect_length(res, 1)
  expect_identical(res, stringr::str_flatten_comma(sort(shift_norm, decreasing = TRUE)))
})


test_that("minimal unique threshold works", {
  vec <- c(rep(1, 100), rep(990:999, 2))

  res <- summarize_outlier(vec, minimal_unique_values = length(unique(vec)) + 1)
  expect_identical(res, "")
  res <- summarize_outlier(vec, minimal_unique_values = length(unique(vec)))
  expect_failure(expect_identical(res, ""))
})

test_that("sorting works", {
  vec <- c(rep(1, 100), 999, 997, 998)

  res <- summarize_outlier(vec, minimal_unique_values = 1, sort = FALSE)
  expect_identical(res, "999, 997, 998")
  res <- summarize_outlier(vec, minimal_unique_values = 1, sort = TRUE)
  expect_identical(res, "999, 998, 997")
  res <- summarize_outlier(vec, minimal_unique_values = 1, sort = "descending")
  expect_identical(res, "999, 998, 997")
  res <- summarize_outlier(vec, minimal_unique_values = 1, sort = "ascending")
  expect_identical(res, "997, 998, 999")
})


test_that("argument checks work", {
  vec <- c(1:10, 999)

  expect_error(summarize_outlier(vec = NULL), regexp = "'vec'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = list()), regexp = "'vec'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = data.frame()), regexp = "'vec'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = c()), regexp = "'vec'", class = "expectation_failure")

  expect_error(summarize_outlier(vec = vec, minimal_unique_values = 0), regexp = "'minimal_unique_values'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, minimal_unique_values = 1.2), regexp = "'minimal_unique_values'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, minimal_unique_values = NA), regexp = "'minimal_unique_values'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, minimal_unique_values = NULL), regexp = "'minimal_unique_values'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, minimal_unique_values = "text"), regexp = "'minimal_unique_values'", class = "expectation_failure")

  expect_error(summarize_outlier(vec = vec, method = list()), regexp = "'method'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, method = NA), regexp = "'method'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, method = NULL), regexp = "'method'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, method = 1), regexp = "'method'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, method = "invalid_option", threshold = list("a" = 1)), regexp = "'arg' should be")

  expect_error(summarize_outlier(vec = vec, threshold = c()), regexp = "'threshold'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, threshold = NA), regexp = "'threshold'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, threshold = NULL), regexp = "'threshold'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, threshold = 1), regexp = "'threshold'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, threshold = list(1)), regexp = "'threshold'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, threshold = list("iqr" = "text")), regexp = "'threshold'", class = "expectation_failure")
  expect_error(summarize_outlier(vec = vec, method = "iqr", threshold = list("iqr" = 1, "z-score" = 2)), regexp = "'threshold'", class = "expectation_failure")

  expect_error(summarize_outlier(vec = vec, sort = 1), regexp = "sort")
  expect_error(summarize_outlier(vec = vec, sort = NA), regexp = "sort")
  expect_error(summarize_outlier(vec = vec, sort = "invalid_option"), regexp = "sort")
  expect_error(summarize_outlier(vec = vec, sort = NULL), regexp = "sort")
  expect_error(summarize_outlier(vec = vec, sort = c(TRUE, FALSE)), regexp = "sort")
})
