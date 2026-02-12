test_that("rowwise trailing value check works", {
  df <- data.frame(a = c(1, 2, 3), b = c(2, 3, 2), c = c(3, 3, 3))
  expect_identical(check_trailing_rowwise(df, cols = colnames(df), trail_value = 3), c(TRUE, TRUE, FALSE))

  tbbl <- tibble::as_tibble(df)
  expect_identical(check_trailing_rowwise(tbbl, cols = colnames(tbbl), trail_value = 3), c(TRUE, TRUE, FALSE))

  df <- data.frame(a = c("a", "b", "c"), b = c("b", "a", NA), c = c(NA, "b", "b"))
  expect_identical(check_trailing_rowwise(df, cols = colnames(df), trail_value = "b"), c(FALSE, FALSE, TRUE))
})

test_that("argument checks work", {
  df <- data.frame(a = c(1))
  col <- "a"
  trail <- "a"

  expect_error(check_trailing_rowwise(df = 1, cols = col, trail_value = trail), regexp = "'df'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = NA, cols = col, trail_value = trail), regexp = "'df'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = "a", cols = col, trail_value = trail), regexp = "'df'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = list(), cols = col, trail_value = trail), regexp = "'df'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = NULL, cols = col, trail_value = trail), regexp = "'df'", class = "expectation_failure")

  expect_error(check_trailing_rowwise(df = df, cols = 1, trail_value = trail), regexp = "'cols'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = df, cols = NA, trail_value = trail), regexp = "'cols'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = df, cols = NULL, trail_value = trail), regexp = "'cols'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = df, cols = "invalid_name", trail_value = trail), regexp = "'cols'", class = "expectation_failure")

  expect_error(check_trailing_rowwise(df = df, cols = col, trail_value = NULL), regexp = "'trail_value'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = df, cols = col, trail_value = c()), regexp = "'trail_value'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = df, cols = col, trail_value = list()), regexp = "'trail_value'", class = "expectation_failure")
  expect_error(check_trailing_rowwise(df = df, cols = col, trail_value = data.frame()), regexp = "'trail_value'", class = "expectation_failure")
})
