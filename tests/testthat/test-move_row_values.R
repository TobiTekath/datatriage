test_that("moving row values works", {
  df <- data.frame("id" = letters[1:5], "a" = c(5:1), "b" = c(5:4, NA, 2:1), "c" = c(1:5), "d" = c(1:2, 2, 4:5))

  df_mov <- move_row_values(df, select_rows = 3, from_col = "a", to_col = "b", clear_value = NA)
  expect_identical(dim(df_mov), dim(df))
  expect_equal(df_mov$a, df$b)
  expect_equal(df_mov$b, df$a)

  # multiple columns with tibble
  tbbl <- tibble::as_tibble(df)
  df_mov <- move_row_values(tbbl, select_rows = "id", select_rows_values = "c", from_col = c("a", "c"), to_col = c("b", "d"), clear_value = 3)
  expect_identical(dim(df_mov), dim(df))
  expect_equal(df_mov$d, df$c)
  expect_equal(df_mov$b, df$a)

  # exchange
  df_mov <- move_row_values(df, select_rows = c(FALSE, FALSE, TRUE), from_col = c("a", "b"), to_col = c("b", "a"), clear_value = NA)
  expect_identical(dim(df_mov), dim(df))
  expect_equal(df_mov$b, df$a)
  expect_equal(df_mov$a, df$b)

  # numeric id in select_row_values
  df_mov <- move_row_values(df, select_rows = "a", select_rows_values = 2, from_col = "b", to_col = "c", clear_value = NA)
  expect_identical(dim(df_mov), dim(df))
  expect_equal(df_mov$a, df$a)
  expect_equal(df_mov$b, c(5, 4, NA, NA, 1))
  expect_equal(df_mov$c, c(1:3, 2, 5))

  # moving to same column does not change anything
  df_mov <- move_row_values(df, select_rows = "a", select_rows_values = 2, from_col = "a", to_col = "a", clear_value = NA)
  expect_identical(dim(df_mov), dim(df))
  expect_equal(df, df_mov)

  # same id and from column
  df_mov <- move_row_values(df, select_rows = "a", select_rows_values = 2, from_col = "a", to_col = "c", clear_value = NA)
  expect_identical(dim(df_mov), dim(df))
  expect_equal(df_mov$a, c(5:3, NA, 1))
  expect_equal(df_mov$c, c(1:3, 2, 5))

  # same id and to column
  df_mov <- move_row_values(df, select_rows = "a", select_rows_values = 5, from_col = "c", to_col = "a", clear_value = NA)
  expect_identical(dim(df_mov), dim(df))
  expect_equal(df_mov$a, c(1, 4:1))
  expect_equal(df_mov$c, c(NA, 2:5))

  # selecting by NA value
  df_mov <- move_row_values(df, select_rows = "b", select_rows_values = NA, from_col = "a", to_col = "d", clear_value = NA)
  expect_identical(dim(df_mov), dim(df))
  expect_equal(df_mov$a, c(5:4, NA, 2:1))
  expect_equal(df_mov$c, df$c)

  # error when mixing data types
  expect_error(move_row_values(df, select_rows = 2, from_col = "id", to_col = "a"), regexp = "match type")
})


test_that("argument checks work", {
  df <- data.frame(x = 1)
  x <- "x"

  expect_error(move_row_values(df = 1), regexp = "'df'", class = "expectation_failure")
  expect_error(move_row_values(df = c(1)), regexp = "'df'", class = "expectation_failure")
  expect_error(move_row_values(df = "text"), regexp = "'df'", class = "expectation_failure")
  expect_error(move_row_values(df = NA), regexp = "'df'", class = "expectation_failure")
  expect_error(move_row_values(df = NULL), regexp = "'df'", class = "expectation_failure")
  expect_error(move_row_values(df = data.frame()), regexp = "'df'", class = "expectation_failure")

  expect_error(move_row_values(df = df, select_rows = "invalid_name", from_col = x, to_col = x), regexp = "'select_rows'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = c(1, 2), from_col = x, to_col = x), regexp = "'select_rows'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = NULL, from_col = x, to_col = x), regexp = "'select_rows'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = NA, from_col = x, to_col = x), regexp = "'select_rows'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = c(), from_col = x, to_col = x), regexp = "'select_rows'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1.2, from_col = x, to_col = x), regexp = "'select_rows'", class = "expectation_failure")

  expect_error(move_row_values(df = df, select_rows_values = 2, from_col = x, to_col = x), regexp = "'select_rows_values'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows_values = 1.2, from_col = x, to_col = x), regexp = "'select_rows_values'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows_values = NA, from_col = x, to_col = x), regexp = "'select_rows_values'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows_values = NULL, from_col = x, to_col = x), regexp = "'select_rows_values'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows_values = "x", from_col = x, to_col = x), regexp = "'select_rows_values'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows_values = c(), from_col = x, to_col = x), regexp = "'select_rows_values'", class = "expectation_failure")

  expect_error(move_row_values(df = df, select_rows = 1, from_col = "invalid_name", to_col = x), regexp = "'from_col'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1, from_col = c("x", "y"), to_col = x), regexp = "'from_col'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1, from_col = NA, to_col = x), regexp = "'from_col'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1, from_col = NULL, to_col = x), regexp = "'from_col'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1, from_col = 1, to_col = x), regexp = "'from_col'", class = "expectation_failure")

  expect_error(move_row_values(df = df, select_rows = 1, from_col = x, to_col = "invalid_name"), regexp = "'to_col'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1, from_col = x, to_col = c("x", "y")), regexp = "'to_col'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1, from_col = x, to_col = NA), regexp = "'to_col'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1, from_col = x, to_col = NULL), regexp = "'to_col'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1, from_col = x, to_col = 1), regexp = "'to_col'", class = "expectation_failure")

  expect_error(move_row_values(df = df, select_rows = 1, from_col = x, to_col = x, clear_value = c(1, 2)), regexp = "'clear_value'", class = "expectation_failure")
  expect_error(move_row_values(df = df, select_rows = 1, from_col = x, to_col = x, clear_value = NULL), regexp = "'clear_value'", class = "expectation_failure")
})
