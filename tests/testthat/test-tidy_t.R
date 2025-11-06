test_that("transposing data.frame works", {
  vec1 <- c(1, 2, 3)
  vec2 <- c("a", "b", "c")
  dummy_df <- data.frame(x1 = vec1, x2 = vec2)

  transposed <- tidy_t(dummy_df)
  expect_s3_class(transposed, "data.frame")
  expect_failure(expect_s3_class(transposed, "tbl_df"))
  expect_identical(colnames(transposed), c("x1", vec1))
  expect_identical(dim(transposed), c(ncol(dummy_df) - 1L, nrow(dummy_df) + 1L))

  revert <- tidy_t(transposed)
  expect_s3_class(revert, "data.frame")
  expect_failure(expect_s3_class(revert, "tbl_df"))
  expect_identical(all_to_character(dummy_df), revert)
})

test_that("transposing tibble works", {
  vec1 <- c(1, 2, 3)
  vec2 <- c("a", "b", "c")
  dummy_df <- tibble::tibble(x1 = vec1, x2 = vec2)

  transposed <- tidy_t(dummy_df)
  expect_s3_class(transposed, "tbl_df")
  expect_identical(colnames(transposed), c("x1", vec1))
  expect_identical(dim(transposed), c(ncol(dummy_df) - 1L, nrow(dummy_df) + 1L))

  revert <- tidy_t(transposed)
  expect_s3_class(revert, "tbl_df")
  expect_identical(all_to_character(dummy_df), revert)
})

test_that("row names raise error", {
  vec1 <- c(1, 2, 3)
  vec2 <- c("a", "b", "c")
  dummy_df <- tibble::tibble(x1 = vec1, x2 = vec2) %>%
    tibble::column_to_rownames("x1")

  expect_error(tidy_t(dummy_df, id_col = 1), regexp = "without row names")
})

test_that("id_col selection works", {
  vec1 <- c(1, 2, 3)
  vec2 <- c("a", "b", "c")
  dummy_df <- data.frame(x1 = vec1, x2 = vec2)
  dummy_tbl <- tibble::tibble(x1 = vec1, x2 = vec2)

  transposed_df <- tidy_t(dummy_df, id_col = 2)
  transposed_tbl <- tidy_t(dummy_df, id_col = 2)
  expect_identical(colnames(transposed_df), c("x2", vec2))
  expect_identical(dim(transposed_df), c(ncol(dummy_df) - 1L, nrow(dummy_df) + 1L))
  expect_identical(colnames(transposed_tbl), c("x2", vec2))
  expect_identical(dim(transposed_tbl), c(ncol(dummy_df) - 1L, nrow(dummy_df) + 1L))
})

test_that("exclude column selection works", {
  vec1 <- c(1, 2, 3)
  vec2 <- c("a", "b", "c")
  dummy_df <- data.frame(x1 = vec1, x2 = vec2)
  dummy_tbl <- tibble::tibble(x1 = vec1, x2 = vec2)

  transposed_df <- tidy_t(dummy_df, exclude_cols = 2)
  transposed_tbl <- tidy_t(dummy_df, exclude_cols = 2)
  expect_identical(colnames(transposed_df), c("x1", vec1))
  expect_identical(dim(transposed_df), c(ncol(dummy_df) - 2L, nrow(dummy_df) + 1L))
  expect_identical(colnames(transposed_tbl), c("x1", vec1))
  expect_identical(dim(transposed_df), c(ncol(dummy_df) - 2L, nrow(dummy_df) + 1L))
})

test_that("specifying new column name works", {
  vec1 <- c(1, 2, 3)
  vec2 <- c("a", "b", "c")
  dummy_df <- data.frame(x1 = vec1, x2 = vec2)
  dummy_tbl <- tibble::tibble(x1 = vec1, x2 = vec2)

  transposed_df <- tidy_t(dummy_df, new_id_colname = "test")
  transposed_tbl <- tidy_t(dummy_df, new_id_colname = "test")
  expect_identical(colnames(transposed_df), c("test", vec1))
  expect_identical(colnames(transposed_tbl), c("test", vec1))
})


test_that("reguess column types works", {
  vec1 <- c(1, "a", TRUE)
  vec2 <- c(2, "b", FALSE)
  vec3 <- c(3, "c", TRUE)
  dummy_df <- data.frame(x1 = vec1, x2 = vec2, x3 = vec3)

  expect_true((all(sapply(dummy_df, class) == "character")))
  transposed <- tidy_t(dummy_df, id_col = 1, new_id_colname = "test", reguess_coltypes = TRUE)
  expect_identical(unname(sapply(transposed, class)), c("character", "numeric", "character", "logical"))
})


test_that("argument checks work", {
  dummy_df <- data.frame(1)

  expect_error(tidy_t(df = ""), regexp = "'df'", class = "expectation_failure")
  expect_error(tidy_t(df = c()), regexp = "'df'", class = "expectation_failure")
  expect_error(tidy_t(df = NA), regexp = "'df'", class = "expectation_failure")
  expect_error(tidy_t(df = NULL), regexp = "'df'", class = "expectation_failure")
  expect_error(tidy_t(df = 1), regexp = "'df'", class = "expectation_failure")
  expect_error(tidy_t(df = matrix(1)), regexp = "'df'", class = "expectation_failure")

  expect_error(tidy_t(df = dummy_df, id_col = NA), regexp = "id_col")
  expect_error(tidy_t(df = dummy_df, id_col = NULL), regexp = "id_col")
  expect_error(tidy_t(df = dummy_df, id_col = -1), regexp = "id_col")
  expect_error(tidy_t(df = dummy_df, id_col = c("invalid_column")), regexp = "id_col")
  expect_error(tidy_t(df = dummy_df, id_col = 10), regexp = "id_col")
  expect_error(tidy_t(df = dummy_df, id_col = c(1, 1)), regexp = "id_col")

  expect_error(tidy_t(df = dummy_df, id_col = 1, exclude_cols = NA), regexp = "exclude_cols")
  expect_error(tidy_t(df = dummy_df, id_col = 1, exclude_cols = -1), regexp = "exclude_cols")
  expect_error(tidy_t(df = dummy_df, id_col = 1, exclude_cols = c("invalid_column")), regexp = "exclude_cols")
  expect_error(tidy_t(df = dummy_df, id_col = 1, exclude_cols = 10), regexp = "exclude_cols")

  expect_error(tidy_t(df = dummy_df, id_col = 1, new_id_colname = 1), regexp = "new_id_colname", class = "expectation_failure")
  expect_error(tidy_t(df = dummy_df, id_col = 1, new_id_colname = c("a", "b")), regexp = "new_id_colname", class = "expectation_failure")
  expect_error(tidy_t(df = dummy_df, id_col = 1, new_id_colname = NA), regexp = "new_id_colname", class = "expectation_failure")
  expect_error(tidy_t(df = dummy_df, id_col = 1, new_id_colname = ""), regexp = "new_id_colname", class = "expectation_failure")

  expect_error(tidy_t(df = dummy_df, id_col = 1, reguess_coltypes = "TRUE"), regexp = "reguess_coltypes", class = "expectation_failure")
  expect_error(tidy_t(df = dummy_df, id_col = 1, reguess_coltypes = 1), regexp = "reguess_coltypes", class = "expectation_failure")
  expect_error(tidy_t(df = dummy_df, id_col = 1, reguess_coltypes = c(TRUE, FALSE)), regexp = "reguess_coltypes", class = "expectation_failure")
  expect_error(tidy_t(df = dummy_df, id_col = 1, reguess_coltypes = NA), regexp = "reguess_coltypes", class = "expectation_failure")
  expect_error(tidy_t(df = dummy_df, id_col = 1, reguess_coltypes = NULL), regexp = "reguess_coltypes", class = "expectation_failure")

  expect_error(tidy_t(df = dummy_df, id_col = 1, exclude_cols = 1), regexp = "exclude_cols", class = "expectation_failure")
})
