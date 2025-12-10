test_that("potential date conversion works", {
  date_string <- "2011-07-05"
  # date conversion
  expect_identical(try_date(40729, origin = "excel"), date_string)
  expect_identical(try_date("40729", origin = "excel", return_character = FALSE), as.Date(date_string))
  expect_identical(try_date(39267, origin = "excel_1904"), date_string)

  # Leap year bug
  expect_identical(try_date(59, origin = "excel_off1"), "1900-02-28")

  # UNIX time
  expect_identical(try_date(1309867200, origin = "unix"), date_string)

  # perform no conversion here
  expect_identical(try_date("invalid"), "invalid")
  expect_identical(try_date(NA), NA)
  expect_identical(try_date(NULL), NULL)

  # min and max date
  expect_identical(try_date("40728", min_date = date_string), "40728")
  expect_identical(try_date("40730", min_date = date_string), "2011-07-06")

  expect_identical(try_date("40730", max_date = date_string), "40730")
  expect_identical(try_date("40728", max_date = date_string), "2011-07-04")
})

test_that("argument checks work", {
  expect_error(try_date(x = c(1, 1)), regexp = "'x'", class = "expectation_failure")
  expect_error(try_date(x = function() print("")), regexp = "'x'", class = "expectation_failure")

  expect_error(try_date(x = 1, origin = "invalid_option"), regexp = "should be one of")
  expect_error(try_date(x = 1, origin = NA), regexp = "NULL")
  expect_error(try_date(x = 1, origin = 1), regexp = "NULL")
  expect_error(try_date(x = 1, origin = TRUE), regexp = "NULL")

  expect_error(try_date(x = 1, min_date = "invalid_option"), regexp = "'min_date'", class = "expectation_failure")
  expect_error(try_date(x = 1, min_date = "01-01-1900"), regexp = "'min_date'", class = "expectation_failure")
  expect_error(try_date(x = 1, min_date = NA), regexp = "'min_date'", class = "expectation_failure")
  expect_error(try_date(x = 1, min_date = TRUE), regexp = "'min_date'", class = "expectation_failure")
  expect_error(try_date(x = 1, min_date = 1), regexp = "'min_date'", class = "expectation_failure")

  expect_error(try_date(x = 1, max_date = "invalid_option"), regexp = "'max_date'", class = "expectation_failure")
  expect_error(try_date(x = 1, max_date = "01-01-1900"), regexp = "'max_date'", class = "expectation_failure")
  expect_error(try_date(x = 1, max_date = NA), regexp = "'max_date'", class = "expectation_failure")
  expect_error(try_date(x = 1, max_date = TRUE), regexp = "'max_date'", class = "expectation_failure")
  expect_error(try_date(x = 1, max_date = 1), regexp = "'max_date'", class = "expectation_failure")

  expect_error(try_date(x = 1, return_character = 1), regexp = "'return_character'", class = "expectation_failure")
  expect_error(try_date(x = 1, return_character = "TRUE"), regexp = "'return_character'", class = "expectation_failure")
  expect_error(try_date(x = 1, return_character = NA), regexp = "'return_character'", class = "expectation_failure")
  expect_error(try_date(x = 1, return_character = NULL), regexp = "'return_character'", class = "expectation_failure")
})
