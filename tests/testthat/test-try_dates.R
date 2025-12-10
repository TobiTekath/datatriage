test_that("potential multiple date conversion works", {
  vec <- c(10000, 20000, 30000)
  excel_dates <- c("1927-05-18", "1954-10-03", "1982-02-18")
  expect_identical(try_dates(vec), excel_dates)

  # with min max - only convert middle element
  expect_identical(try_dates(vec, min_date = try_date(vec[1] + 1), max_date = try_date(vec[3] - 1)), c(vec[1], excel_dates[2], vec[3]))
})

test_that("argument checks work", {
  expect_error(try_dates(vec = list()), regexp = "'vec'", class = "expectation_failure")
  expect_error(try_dates(vec = NULL), regexp = "'vec'", class = "expectation_failure")
  expect_error(try_dates(vec = function() print("")), regexp = "'vec'", class = "expectation_failure")
})
