test_that("column type guessing works", {
  df <- data.frame(a = c(1, 2, 3), b = c("a", "b", "c"), c = c(TRUE, FALSE, NA), d = factor(c(1, 2, 1)), e = c(1.1, 1.2, 1.3))

  char_df <- all_to_character(df)

  new_df <- reguess_coltypes(char_df) |>
    dplyr::mutate(d = factor(d))
  expect_identical(df, new_df)
})

test_that("convert_comma_to_dot works", {
  df <- data.frame(a = c(1.1, 1.2, 1.3), b = c(" 1,1", "1,2 ", " 1,3 "))

  new_df <- reguess_coltypes(df, convert_comma_to_dot = TRUE)
  expect_identical(df$a, new_df$b)
})

test_that("silent works", {
  df <- data.frame(a = c(1, 2, 3), b = c("a", "b", "c"), c = c(TRUE, FALSE, NA), d = factor(c(1, 2, 1)), e = c(1.1, 1.2, 1.3))

  expect_message(reguess_coltypes(all_to_character(df), silent = FALSE), regexp = "Column specification")
})

test_that("ellipsis works", {
  df <- data.frame(a = c(1, 2, 3), b = c("a", "b", "c"), c = c(TRUE, FALSE, NA), d = factor(c(1, 2, 1)), e = c(1.1, 1.2, 1.3))

  new_df <- reguess_coltypes(all_to_character(df), na = "a", guess_integer = TRUE)
  expect_identical(class(new_df$a), "integer")
  expect_identical(class(new_df$d), "integer")
  expect_identical(new_df$b, c(NA, "b", "c"))
})


test_that("argument checks work", {
  dummy_df <- data.frame(1)

  expect_error(reguess_coltypes(df = ""), regexp = "'df'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = 1), regexp = "'df'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = NA), regexp = "'df'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = NULL), regexp = "'df'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = matrix(1)), regexp = "'df'", class = "expectation_failure")

  expect_error(reguess_coltypes(df = dummy_df, convert_comma_to_dot = "TRUE"), regexp = "'convert_comma_to_dot'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = dummy_df, convert_comma_to_dot = 1), regexp = "'convert_comma_to_dot'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = dummy_df, convert_comma_to_dot = NA), regexp = "'convert_comma_to_dot'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = dummy_df, convert_comma_to_dot = NULL), regexp = "'convert_comma_to_dot'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = dummy_df, convert_comma_to_dot = c(TRUE, TRUE)), regexp = "'convert_comma_to_dot'", class = "expectation_failure")

  expect_error(reguess_coltypes(df = dummy_df, silent = "TRUE"), regexp = "'silent'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = dummy_df, silent = 1), regexp = "'silent'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = dummy_df, silent = NA), regexp = "'silent'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = dummy_df, silent = NULL), regexp = "'silent'", class = "expectation_failure")
  expect_error(reguess_coltypes(df = dummy_df, silent = c(TRUE, TRUE)), regexp = "'silent'", class = "expectation_failure")
})
