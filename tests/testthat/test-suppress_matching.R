test_that("all suppression works", {
  noisy_fun <- function() {
    message("I am a message")
    warning("I am a warning")
    cat("I am a cat")
    print("I am a print")
    return(TRUE)
  }

  # all filtered
  out <- expect_no_message(expect_no_warning(utils::capture.output(res <- suppress_matching(noisy_fun()))))
  expect_true(rlang::is_empty(out))
  expect_true(res)

  # all filtered with regex
  out <- expect_no_message(expect_no_warning(utils::capture.output(res <- suppress_matching(noisy_fun(), pattern = ".*am a.*"))))
  expect_true(rlang::is_empty(out))
  expect_true(res)

  # all filtered with case-insensitive regex
  out <- expect_no_message(expect_no_warning(utils::capture.output(res <- suppress_matching(noisy_fun(), pattern = ".*am A.*", ignore.case = TRUE))))
  expect_true(rlang::is_empty(out))
  expect_true(res)
})

test_that("message suppression works", {
  noisy_fun <- function() {
    message("first message")
    message("second message")
    return(TRUE)
  }

  # all allowed
  expect_message(expect_message(res <- suppress_matching(noisy_fun(), suppress_messages = FALSE), regexp = "first"), regexp = "second")
  expect_true(res)

  # selective suppress
  expect_no_message(expect_message(res <- suppress_matching(noisy_fun(), pattern = "second"), regexp = "first"))
  expect_true(res)
})

test_that("warning suppression works", {
  noisy_fun <- function() {
    warning("first warning")
    warning("second warning")
    return(TRUE)
  }

  # all allowed
  expect_warning(expect_warning(res <- suppress_matching(noisy_fun(), suppress_warnings = FALSE), regexp = "first"), regexp = "second")
  expect_true(res)

  # selective suppress
  expect_no_warning(expect_warning(res <- suppress_matching(noisy_fun(), pattern = "second"), regexp = "first"))
  expect_true(res)
})

test_that("output suppression works", {
  noisy_fun <- function() {
    cat("first output")
    print("second output")
    return(TRUE)
  }

  # all allowed
  out <- utils::capture.output(res <- suppress_matching(noisy_fun(), suppress_cat_print = FALSE))
  expect_identical(out, c("first output", "[1] \"second output\""))
  expect_true(res)

  # selective suppress
  out <- utils::capture.output(res <- suppress_matching(noisy_fun(), pattern = "second"))
  expect_identical(out, "first output")
  expect_true(res)


  # selective suppression for consecutive print calls
  noisy_fun <- function() {
    print("first output")
    print("second output")
    return(TRUE)
  }
  out <- utils::capture.output(res <- suppress_matching(noisy_fun(), pattern = "first"))
  expect_identical(out, "[1] \"second output\"")
  expect_true(res)

  # selective suppression for consecutive cat calls
  noisy_fun <- function() {
    cat("first output")
    cat("second output")
    return(TRUE)
  }
  out <- utils::capture.output(res <- suppress_matching(noisy_fun(), pattern = "first"))
  ## can not differentiate cat calls.
  expect_failure(expect_identical(out, "second output"))
  expect_true(res)
})


test_that("argument checks work", {
  dummy_fun <- function() {}

  expect_error(suppress_matching(dummy_fun, pattern = 1), regexp = "'pattern'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, pattern = NA), regexp = "'pattern'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, pattern = TRUE), regexp = "'pattern'", class = "expectation_failure")

  expect_error(suppress_matching(dummy_fun, suppress_messages = 1), regexp = "'suppress_messages'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_messages = "TRUE"), regexp = "'suppress_messages'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_messages = NA), regexp = "'suppress_messages'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_messages = NULL), regexp = "'suppress_messages'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_messages = c(TRUE, FALSE)), regexp = "'suppress_messages'", class = "expectation_failure")

  expect_error(suppress_matching(dummy_fun, suppress_warnings = 1), regexp = "'suppress_warnings'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_warnings = "TRUE"), regexp = "'suppress_warnings'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_warnings = NA), regexp = "'suppress_warnings'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_warnings = NULL), regexp = "'suppress_warnings'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_warnings = c(TRUE, FALSE)), regexp = "'suppress_warnings'", class = "expectation_failure")

  expect_error(suppress_matching(dummy_fun, suppress_cat_print = 1), regexp = "'suppress_cat_print'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_cat_print = "TRUE"), regexp = "'suppress_cat_print'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_cat_print = NA), regexp = "'suppress_cat_print'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_cat_print = NULL), regexp = "'suppress_cat_print'", class = "expectation_failure")
  expect_error(suppress_matching(dummy_fun, suppress_cat_print = c(TRUE, FALSE)), regexp = "'suppress_cat_print'", class = "expectation_failure")
})
