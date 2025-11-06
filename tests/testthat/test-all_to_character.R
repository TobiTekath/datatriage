test_that("character conversion works", {
  df <- data.frame(a = c(1, 2, 3), b = c("a", "b", "c"), c = c(TRUE, FALSE, NA), d = factor(c(1, 2, 1)))

  new_df <- all_to_character(df)
  expect_s3_class(new_df, "data.frame")
  expect_identical(dim(df), dim(new_df))
  expect_identical(unique(sapply(new_df, class)), "character")
})


test_that("argument checks work", {
  expect_error(all_to_character(df = ""), regexp = "'df'", class = "expectation_failure")
  expect_error(all_to_character(df = 1), regexp = "'df'", class = "expectation_failure")
  expect_error(all_to_character(df = NA), regexp = "'df'", class = "expectation_failure")
  expect_error(all_to_character(df = NULL), regexp = "'df'", class = "expectation_failure")
  expect_error(all_to_character(df = matrix(1)), regexp = "'df'", class = "expectation_failure")
})
