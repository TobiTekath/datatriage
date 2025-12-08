test_that("column relocation works", {
  dummy_df <- data.frame("a" = 1:2, "b" = 3:4, "c" = 5:6, "d" = 7:8)
  dummy_reloc <- data.frame("b" = 3:4, "a" = 1:2, "d" = 7:8, "c" = 5:6)

  # return unchanged df when nothing provided.
  expect_identical(relocate_multi(dummy_df), dummy_df)

  # relocate by name
  reloc_df <- relocate_multi(dummy_df, move = c("a", "c"), after = c("b", "d"))
  expect_identical(reloc_df, dummy_reloc)

  # relocate by index
  reloc_df <- relocate_multi(dummy_df, move = c(1, 3), after = c(2, 4))
  expect_identical(reloc_df, dummy_reloc)

  # relocate by tidy select
  reloc_df <- dummy_df |> relocate_multi(move = tidyselect::all_of(c(1, 3)), after = tidyselect::all_of(c(2, 4)))
  expect_identical(reloc_df, dummy_reloc)

  # relocate by data masking
  reloc_df <- dummy_df |> relocate_multi(move = rlang::expr(a), after = rlang::expr(b))
  expect_identical(reloc_df[, 1:2], dummy_reloc[, 1:2])

  # more complex relocation
  reloc_df <- relocate_multi(dummy_df, move = c(1, 4), before = c(4, 2))
  expect_identical(colnames(reloc_df), c("d", "b", "c", "a"))

  # duplicate relocation
  reloc_df <- relocate_multi(dummy_df, move = c(3, 1, 1), after = c(4, 3, 4))
  expect_identical(colnames(reloc_df), c("b", "d", "a", "c"))
})


test_that("argument checks work", {
  dummy_df <- data.frame(1, 2)

  expect_error(relocate_multi(df = ""), regexp = "'df'", class = "expectation_failure")
  expect_error(relocate_multi(df = 1), regexp = "'df'", class = "expectation_failure")
  expect_error(relocate_multi(df = NA), regexp = "'df'", class = "expectation_failure")
  expect_error(relocate_multi(df = NULL), regexp = "'df'", class = "expectation_failure")
  expect_error(relocate_multi(df = matrix(1)), regexp = "'df'", class = "expectation_failure")

  expect_error(relocate_multi(df = dummy_df, move = "invalid_column", before = 1), regexp = "select columns")
  expect_error(relocate_multi(df = dummy_df, move = 5, before = 1), regexp = "Location")
  expect_error(relocate_multi(df = dummy_df, move = c(1, 2), before = 1), regexp = "same length")
  expect_error(relocate_multi(df = dummy_df, move = NA, before = 1), regexp = "missing values")

  expect_error(relocate_multi(df = dummy_df, move = 1, before = "invalid_column"), regexp = "select columns")
  expect_error(relocate_multi(df = dummy_df, move = 1, before = 5), regexp = "Location")
  expect_error(relocate_multi(df = dummy_df, move = 1, before = c(1, 2)), regexp = "same length")
  expect_error(relocate_multi(df = dummy_df, move = 1, before = NA), regexp = "missing values")

  expect_error(relocate_multi(df = dummy_df, move = 1, after = "invalid_column"), regexp = "select columns")
  expect_error(relocate_multi(df = dummy_df, move = 1, after = 5), regexp = "Location")
  expect_error(relocate_multi(df = dummy_df, move = 1, after = c(1, 2)), regexp = "same length")
  expect_error(relocate_multi(df = dummy_df, move = 1, after = NA), regexp = "missing values")

  expect_error(relocate_multi(df = dummy_df, move = 1, before = NULL, after = NULL), regexp = "must be supplied")
})
