test_that("potential numeric conversion works", {
  # nothing happens
  expect_identical(try_numeric(4), 4)
  expect_identical(try_numeric("hi"), "hi")
  expect_identical(try_numeric("1,2"), "1,2")
  expect_identical(try_numeric(NA), NA)
  expect_identical(try_numeric(NULL), NULL)

  # conversion to numeric
  expect_identical(try_numeric(TRUE), 1)
  expect_identical(try_numeric("-1"), -1)
  expect_identical(try_numeric("1.2"), 1.2)
  expect_identical(try_numeric("Inf"), Inf)
  expect_identical(try_numeric("1e4"), 1e4)
})

test_that("argument checks work", {
  expect_error(try_numeric(x = c(1, 1)), regexp = "'x'", class = "expectation_failure")
  expect_error(try_numeric(x = function() print("")), regexp = "'x'", class = "expectation_failure")
})
