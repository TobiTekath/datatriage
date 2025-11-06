test_that("decimal point conversion works", {
  df <- data.frame(x1 = c(1.1, 2.2), x2 = c("1,1", "2,2"))
  new_df <- all_decimal_points_to_dot(df)
  expect_identical(df$x1, as.numeric(new_df$x2))
})

test_that("using custom decimal point character works", {
  df <- data.frame(x1 = c(1.1, 2.2), x2 = c("1$1", "2$2"))
  new_df <- all_decimal_points_to_dot(df, convert_decimal_character = "$")
  expect_identical(df$x1, as.numeric(new_df$x2))
})

test_that("conversion safeguards work", {
  df <- data.frame(x1 = c("a,1", "1,1a", "a1,1", "1,a", " 1,1", "1,1 "))
  new_df <- all_decimal_points_to_dot(df)
  expect_identical(new_df$x1, df$x1)
})

test_that("trim_ws work", {
  df <- data.frame(x1 = c(1.1, 2.2, 3.3), x2 = c(" 1,1", "2,2 ", " 3,3 "))
  new_df <- all_decimal_points_to_dot(df, trim_ws = TRUE)
  expect_identical(df$x1, as.numeric(new_df$x2))
})

test_that("argument checks work", {
  expect_error(all_to_character(df = ""), regexp = "'df'", class = "expectation_failure")
  expect_error(all_to_character(df = 1), regexp = "'df'", class = "expectation_failure")
  expect_error(all_to_character(df = NA), regexp = "'df'", class = "expectation_failure")
  expect_error(all_to_character(df = NULL), regexp = "'df'", class = "expectation_failure")
  expect_error(all_to_character(df = matrix(1)), regexp = "'df'", class = "expectation_failure")
})
