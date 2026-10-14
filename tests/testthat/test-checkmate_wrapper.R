test_that("checkmate extension works", {
  testthat::expect_no_error(checkmate_wrapper(checkmate::check_string("test")))
  testthat::expect_error(checkmate_wrapper(checkmate::check_string(5)), regexp = "'5'", class = "expectation_failure")
  x <- 5
  testthat::expect_error(checkmate_wrapper(checkmate::check_string(x)), regexp = "'x'", class = "expectation_failure")
})

test_that("checkmate extension 'and' works", {
  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5), checkmate::check_string(5)), regexp = "Must be of type 'string'", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish("5"), checkmate::check_string("5")), regexp = "Must be of type 'integerish'", class = "expectation_failure")
  testthat::expect_no_error(checkmate_wrapper(checkmate::check_string("hi"), checkmate::check_choice("hi", c("hi", "ho"))))
})

test_that("checkmate extension 'or' works", {
  testthat::expect_no_error(checkmate_wrapper(checkmate::check_integerish(5), checkmate::check_string(5), combine = "or"))
  testthat::expect_no_error(checkmate_wrapper(checkmate::check_integerish("5"), checkmate::check_string("5"), , combine = "or"))
  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(TRUE), checkmate::check_string(TRUE), combine = "or"), regexp = "Must be of type 'integerish'.*Must be of type 'string'", class = "expectation_failure")
})

test_that("checkmate extension 'info' works", {
  testthat::expect_error(checkmate_wrapper(checkmate::check_string(5), info = "add_info"), regexp = "add_info", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(checkmate::check_string(5), checkmate::check_string(6), combine = "or", info = "add_info"), regexp = "add_info", class = "expectation_failure")
})

test_that("argument checks work", {
  testthat::expect_error(checkmate_wrapper(1), regexp = "checkmate::check_ function call", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper("test"), regexp = "checkmate::check_ function call", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(NULL), regexp = "checkmate::check_ function call", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(TRUE), regexp = "checkmate::check_ function call", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(FALSE), regexp = "checkmate::check_ function call", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(), regexp = "checkmate::check_ function call", class = "expectation_failure")

  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5), combine = "invalid_option"), regexp = "'combine'", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5), combine = 5), regexp = "'combine'", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5), combine = TRUE), regexp = "'combine'", class = "expectation_failure")

  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5), info = 5), regexp = "'info'", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5), info = TRUE), regexp = "'info'", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5), info = c("a", "b")), regexp = "'info'", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5), info = NULL), regexp = "'info'", class = "expectation_failure")
  testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5), info = NA), regexp = "'info'", class = "expectation_failure")
})
