test_that("rowwise comparison works", {
  df <- data.frame(a = c(1:5), b = as.character(c(1:5)))

  res <- apply_rowwise(vec1 = df$a, vec2 = df$b, apply_fun = "+", wrap_fun_vec2 = try_numeric)
  expect_identical(res, c(1:5) * 2)

  res <- apply_rowwise(vec1 = df$b, vec2 = df$a, apply_fun = sum, wrap_fun_vec1 = "try_numeric")
  expect_identical(res, c(1:5) * 2)

  res <- apply_rowwise(vec1 = df$b, vec2 = df$b, apply_fun = "==", wrap_fun_vec1 = try_numeric, wrap_fun_vec2 = "try_numeric")
  expect_true(all(res))

  res <- apply_rowwise(vec1 = df$a, vec2 = df$a, apply_fun = identical)
  expect_true(all(res))
})

test_that("argument checks work", {
  vec1 <- character(1)
  vec2 <- integer(1)
  fun <- function() {}

  expect_error(apply_rowwise(vec1 = list(), vec2 = vec2, apply_fun = fun), regexp = "'vec1'", class = "expectation_failure")
  expect_error(apply_rowwise(vec1 = data.frame(), vec2 = vec2, apply_fun = fun), regexp = "'vec1'", class = "expectation_failure")
  expect_error(apply_rowwise(vec1 = NULL, vec2 = vec2, apply_fun = fun), regexp = "'vec1'", class = "expectation_failure")
  expect_error(apply_rowwise(vec1 = fun, vec2 = vec2, apply_fun = fun), regexp = "'vec1'", class = "expectation_failure")

  expect_error(apply_rowwise(vec1 = vec1, vec2 = list(), apply_fun = fun), regexp = "'vec2'", class = "expectation_failure")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = data.frame(), apply_fun = fun), regexp = "'vec2'", class = "expectation_failure")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = NULL, apply_fun = fun), regexp = "'vec2'", class = "expectation_failure")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = fun, apply_fun = fun), regexp = "'vec2'", class = "expectation_failure")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = integer(0), apply_fun = fun), regexp = "'vec2'", class = "expectation_failure")

  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = "invalid_function"), regexp = "'invalid_function'")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = NULL), regexp = "apply_fun")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = NA), regexp = "apply_fun")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = TRUE), regexp = "apply_fun")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = 1), regexp = "apply_fun")

  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = fun, wrap_fun_vec1 = "invalid_function"), regexp = "'invalid_function'")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = fun, wrap_fun_vec1 = NA), regexp = "wrap_fun_vec1")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = fun, wrap_fun_vec1 = TRUE), regexp = "wrap_fun_vec1")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = fun, wrap_fun_vec1 = 1), regexp = "wrap_fun_vec1")

  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = fun, wrap_fun_vec2 = "invalid_function"), regexp = "'invalid_function'")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = fun, wrap_fun_vec2 = NA), regexp = "wrap_fun_vec2")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = fun, wrap_fun_vec2 = TRUE), regexp = "wrap_fun_vec2")
  expect_error(apply_rowwise(vec1 = vec1, vec2 = vec2, apply_fun = fun, wrap_fun_vec2 = 1), regexp = "wrap_fun_vec2")
})
