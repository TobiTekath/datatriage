test_that("one hot encoding checking works", {
  df <- data.frame(a = c(1, 0, 0), b = c(0, 0, 1), c = c(0, NA, 1))

  expect_identical(check_one_hot(df, cols = colnames(df)), c(TRUE, FALSE, FALSE))
  expect_identical(check_one_hot(df, cols = colnames(df), allow_no_selection = TRUE), c(TRUE, TRUE, FALSE))
})

test_that("other positive values work", {
  df <- data.frame(id = c(1:3), a = c(FALSE, TRUE, TRUE), b = c(TRUE, FALSE, NA), c = c(TRUE, FALSE, TRUE))

  expect_identical(check_one_hot(df, cols = c("a", "b", "c"), check_value = 2), c(FALSE, FALSE, FALSE))
  expect_identical(check_one_hot(df, cols = c("a", "b", "c"), check_value = FALSE), c(TRUE, FALSE, FALSE))

  df <- data.frame(a = c("one", "two"), b = c("two", "oneone"))
  expect_identical(check_one_hot(df, cols = colnames(df), check_value = "one"), c(TRUE, FALSE))

  tbl <- tibble::tibble(a = c(2, 1), b = c(1, 3))
  expect_identical(check_one_hot(tbl, cols = colnames(tbl), check_value = 2), c(TRUE, FALSE))

  # special case: NA
  tbl <- tibble::tibble(a = c(2, 1), b = c(1, NA))
  expect_identical(check_one_hot(tbl, cols = colnames(tbl), check_value = NA), c(FALSE, TRUE))
})

test_that("argument checks work", {
  df <- data.frame(x1 = 1)
  cl <- "x1"

  expect_error(check_one_hot(df = NULL), regexp = "'df'", class = "expectation_failure")
  expect_error(check_one_hot(df = NA), regexp = "'df'", class = "expectation_failure")
  expect_error(check_one_hot(df = 1), regexp = "'df'", class = "expectation_failure")
  expect_error(check_one_hot(df = "str"), regexp = "'df'", class = "expectation_failure")
  expect_error(check_one_hot(df = TRUE), regexp = "'df'", class = "expectation_failure")
  expect_error(check_one_hot(df = list(1)), regexp = "'df'", class = "expectation_failure")

  expect_error(check_one_hot(df, cols = "invalid_col"), regexp = "'cols'", class = "expectation_failure")
  expect_error(check_one_hot(df, cols = TRUE), regexp = "'cols'", class = "expectation_failure")
  expect_error(check_one_hot(df, cols = 1), regexp = "'cols'", class = "expectation_failure")
  expect_error(check_one_hot(df, cols = NULL), regexp = "'cols'", class = "expectation_failure")
  expect_error(check_one_hot(df, cols = NA), regexp = "'cols'", class = "expectation_failure")

  expect_error(check_one_hot(df, cols = cl, check_value = function(x) x), regexp = "'check_value'", class = "expectation_failure")
  expect_error(check_one_hot(df, cols = cl, check_value = NULL), regexp = "'check_value'", class = "expectation_failure")

  expect_error(check_one_hot(df, cols = cl, allow_no_selection = "TRUE"), regexp = "'allow_no_selection'", class = "expectation_failure")
  expect_error(check_one_hot(df, cols = cl, allow_no_selection = 1), regexp = "'allow_no_selection'", class = "expectation_failure")
  expect_error(check_one_hot(df, cols = cl, allow_no_selection = c(TRUE, FALSE)), regexp = "'allow_no_selection'", class = "expectation_failure")
  expect_error(check_one_hot(df, cols = cl, allow_no_selection = NA), regexp = "'allow_no_selection'", class = "expectation_failure")
  expect_error(check_one_hot(df, cols = cl, allow_no_selection = NULL), regexp = "'allow_no_selection'", class = "expectation_failure")
})
