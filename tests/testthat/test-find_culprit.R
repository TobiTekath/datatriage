test_that("culprit identification works", {
  df <- data.frame(numeric = c(1.1, 2.2, 3.3, "a"), logical = c(TRUE, FALSE, "TURE", 1), int = c(1, 2.1, 3, 4), char = c(1, "a", "b", "c"))

  expect_message(culp <- find_culprit(df$numeric, verbose = TRUE), regexp = "majority guess")
  expect_identical(unname(culp), "a")
  culp <- find_culprit(df$logical, verbose = FALSE)
  expect_identical(unname(culp), c("TURE", "1"))
  culp <- find_culprit(df$int, verbose = FALSE)
  expect_identical(unname(culp), "2.1")

  # set should_be to numeric for column int -> no culprit
  culp <- find_culprit(df$int, should_be = "numeric", verbose = FALSE)
  expect_null(culp)

  culp <- find_culprit(df$char, verbose = FALSE)
  expect_identical(unname(culp), "1")

  # empty vec should return NULL
  expect_null(find_culprit(character(0)))
})

test_that("NA handling works", {
  df <- data.frame(mixed = c(1, 2, NA, NA, "."))

  # NA's are excluded by default - guessing integer
  culp <- find_culprit(df$mixed, verbose = FALSE)
  expect_identical(unname(culp), ".")

  # NA's are not excluded - tie between logical and integer, guessing integer
  culp <- find_culprit(df$mixed, verbose = FALSE, na.rm = FALSE)
  expect_identical(unname(culp), c(NA, NA, "."))

  # Treat "." like NA - more logical than integer, guessing logical
  culp <- find_culprit(df$mixed, verbose = FALSE, na.rm = FALSE, na = ".")
  expect_identical(unname(culp), c("1", "2"))
})

test_that("Index return works", {
  df <- data.frame(one = c("a", 1, 2, 3), two = c(TRUE, FALSE, "TURE", 1))

  culp <- find_culprit(df$one, return_index = TRUE, verbose = FALSE)
  expect_identical(unname(culp), 1L)

  culp <- find_culprit(df$two, return_index = TRUE, verbose = FALSE)
  expect_identical(unname(culp), c(3L, 4L))
})

test_that("argument checks work", {
  expect_error(find_culprit(vec = list()), regexp = "'vec'", class = "expectation_failure")
  expect_error(find_culprit(vec = NULL), regexp = "'vec'", class = "expectation_failure")
  expect_error(find_culprit(vec = data.frame()), regexp = "'vec'", class = "expectation_failure")
  expect_error(find_culprit(vec = matrix()), regexp = "'vec'", class = "expectation_failure")

  expect_error(find_culprit(vec = 1, should_be = "invalid_choice"), regexp = "'should_be'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, should_be = 1), regexp = "'should_be'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, should_be = NA), regexp = "'should_be'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, should_be = NULL), regexp = "'should_be'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, should_be = TRUE), regexp = "'should_be'", class = "expectation_failure")

  expect_error(find_culprit(vec = 1, return_index = "TRUE"), regexp = "'return_index'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, return_index = 1), regexp = "'return_index'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, return_index = NA), regexp = "'return_index'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, return_index = NULL), regexp = "'return_index'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, return_index = c(TRUE, FALSE)), regexp = "'return_index'", class = "expectation_failure")

  expect_error(find_culprit(vec = 1, na.rm = "TRUE"), regexp = "'na.rm'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, na.rm = 1), regexp = "'na.rm'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, na.rm = NA), regexp = "'na.rm'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, na.rm = NULL), regexp = "'na.rm'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, na.rm = c(TRUE, FALSE)), regexp = "'na.rm'", class = "expectation_failure")

  expect_error(find_culprit(vec = 1, verbose = "TRUE"), regexp = "'verbose'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, verbose = 1), regexp = "'verbose'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, verbose = NA), regexp = "'verbose'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, verbose = NULL), regexp = "'verbose'", class = "expectation_failure")
  expect_error(find_culprit(vec = 1, verbose = c(TRUE, FALSE)), regexp = "'verbose'", class = "expectation_failure")
})
