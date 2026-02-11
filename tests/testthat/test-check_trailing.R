test_that("trailing element detection works", {
  expect_true(check_trailing(c(1, 2, 3, 3), trail_value = 3))
  expect_false(check_trailing(c(1, 2, 3, 2, 3), trail_value = 3))
  expect_true(check_trailing(c("a", "b", "c"), trail_value = "c"))
  expect_true(check_trailing(c("a", "b", "c"), trail_value = "d"))
  expect_true(check_trailing(c(TRUE, FALSE, FALSE), trail_value = FALSE))
  expect_true(check_trailing(c(1, 2, NA, NA), trail_value = NA))
})

test_that("argument checks work", {
  vec <- c("")
  trail <- "a"

  expect_error(check_trailing(vec = list(), trail_value = trail), regexp = "'vec'", class = "expectation_failure")
  expect_error(check_trailing(vec = NULL, trail_value = trail), regexp = "'vec'", class = "expectation_failure")
  expect_error(check_trailing(vec = data.frame(), trail_value = trail), regexp = "'vec'", class = "expectation_failure")

  expect_error(check_trailing(vec = vec, trail_value = NULL), regexp = "'trail_value'", class = "expectation_failure")
  expect_error(check_trailing(vec = vec, trail_value = list()), regexp = "'trail_value'", class = "expectation_failure")
  expect_error(check_trailing(vec = vec, trail_value = data.frame()), regexp = "'trail_value'", class = "expectation_failure")
  expect_error(check_trailing(vec = vec, trail_value = c()), regexp = "'trail_value'", class = "expectation_failure")
})
