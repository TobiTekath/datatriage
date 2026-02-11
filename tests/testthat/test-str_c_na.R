test_that("NA-aware string combining works", {
  expect_identical(str_c_na("a", NA, "b", sep = "-"), "a-b")
  expect_identical(str_c_na(c("a", NA), c(NA, "b"), collapse = ","), "a,b")
  expect_identical(str_c_na(c("a", NA), c("b"), sep = "-", collapse = ","), "a-b,b")
  expect_identical(str_c_na(c(NA, NA), collapse = ", "), NA)

  expect_identical(str_c_na(), stringr::str_c())
})

test_that("argument checks work", {
  vec <- c("")

  expect_error(str_c_na(vec, sep = 1), regexp = "'sep'", class = "expectation_failure")
  expect_error(str_c_na(vec, sep = NA), regexp = "'sep'", class = "expectation_failure")
  expect_error(str_c_na(vec, sep = NULL), regexp = "'sep'", class = "expectation_failure")
  expect_error(str_c_na(vec, sep = TRUE), regexp = "'sep'", class = "expectation_failure")
  expect_error(str_c_na(vec, sep = list()), regexp = "'sep'", class = "expectation_failure")

  expect_error(str_c_na(vec, collapse = 1), regexp = "'collapse'", class = "expectation_failure")
  expect_error(str_c_na(vec, collapse = NA), regexp = "'collapse'", class = "expectation_failure")
  expect_error(str_c_na(vec, collapse = TRUE), regexp = "'collapse'", class = "expectation_failure")
  expect_error(str_c_na(vec, collapse = list()), regexp = "'collapse'", class = "expectation_failure")
})
