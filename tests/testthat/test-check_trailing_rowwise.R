test_that("rowwise trailing value check works", {
  df <- data.frame(a = c(1, 2, 3), b = c(2, 3, 2), c = c(3, 3, 3))

  check_trailing_rowwise(df, cols = colnames(df), trail_value = 3)

  # TODO
})
