test_that("table summarizing works", {
  df <- data.frame(
    a = c(1L, 2L, 3L), b = c("a", "b", "c"), c = c(TRUE, FALSE, NA),
    d = factor(c(2, 3, 1), levels = c(2, 3, 1)), e = c(1.1, 1.2, 1.3),
    f = c(-0.9, -1, Inf), g = c(1, 1, 1), h = c("1|2", "3", "2|3")
  )

  sum_df <- summarize_table(df, find_outliers = FALSE, custom_funs = list(n_multi = ~ sum(stringr::str_detect(.x, "\\|"), na.rm = TRUE)))
  expect_true(is.data.frame(sum_df))
  expect_identical(sum_df$variable, colnames(df))
  expect_identical(sum_df$type, unname(sapply(df, class)))
  expect_equal(sum_df$n_observed, unname(sapply(df, function(x) sum(!is.na(x)))))
  expect_equal(sum_df$n_unique, unname(sapply(df, function(x) length(unique(stats::na.omit(x))))))
  expect_identical(sum_df$min[sum_df$variable == "d"], "2")
  expect_identical(sum_df$max[sum_df$variable == "d"], "1")
  expect_identical(sum_df$n_multi[sum_df$variable == "h"], 2)

  # rownames are ignored
  df <- data.frame(x1 = c(1, 2, 3), row.names = c("a", "b", "c"))
  sum_df <- summarize_table(df)
  expect_true(is.data.frame(sum_df))
  expect_identical(sum_df$variable, colnames(df))
})

test_that("finding culprits works", {
  df <- data.frame(x1 = c(1, 2, 3, "a", NA, "b"), x2 = c("a", 1, "b", NA, 2, "c"))
  sum_df <- summarize_table(df, base_summaries = FALSE, find_culprits = TRUE)
  expect_true(is.data.frame(sum_df))
  expect_identical(sum_df$variable, colnames(df))
  expect_identical(sum_df$culprits, c("'a', 'b'", "'1', '2'"))
})

test_that("finding outliers works", {
  df <- data.frame(x1 = c(rep(1, 30), 998, 999))

  sum_df <- summarize_table(df, base_summaries = FALSE, find_outliers = TRUE, find_outlier_opts = list(minimal_unique_values = 1))
  expect_true(is.data.frame(sum_df))
  expect_identical(sum_df$variable, colnames(df))
  expect_identical(sum_df$outlier, c("999, 998"))
})

test_that("duplicate function names works", {
  df <- data.frame(x1 = c(1, 2, 3), x2 = c("a", "b", "c"))

  expect_warning(sum_df <- summarize_table(df, custom_funs = list(min = ~1)), regexp = "Enforcing unique")
  expect_true(is.data.frame(sum_df))
  expect_identical(sum_df$variable, colnames(df))
  expect_true("min.1" %in% colnames(sum_df))
})

test_that("empty functions throws error", {
  df <- data.frame(x1 = 1)
  expect_error(summarize_table(df, base_summaries = FALSE, find_culprits = FALSE, find_outliers = FALSE), regexp = "Supply at least")
})


test_that("argument checks work", {
  df <- data.frame(x1 = 1)
  fun <- function(X) TRUE

  expect_error(summarize_table(df = NULL), regexp = "'df'", class = "expectation_failure")
  expect_error(summarize_table(df = NA), regexp = "'df'", class = "expectation_failure")
  expect_error(summarize_table(df = 1), regexp = "'df'", class = "expectation_failure")
  expect_error(summarize_table(df = "str"), regexp = "'df'", class = "expectation_failure")
  expect_error(summarize_table(df = TRUE), regexp = "'df'", class = "expectation_failure")
  expect_error(summarize_table(df = list(1)), regexp = "'df'", class = "expectation_failure")

  expect_error(summarize_table(df, custom_funs = c()), regexp = "'custom_funs'", class = "expectation_failure")
  expect_error(summarize_table(df, custom_funs = TRUE), regexp = "'custom_funs'", class = "expectation_failure")
  expect_error(summarize_table(df, custom_funs = NA), regexp = "'custom_funs'", class = "expectation_failure")
  expect_error(summarize_table(df, custom_funs = NULL), regexp = "'custom_funs'", class = "expectation_failure")
  expect_error(summarize_table(df, custom_funs = 1), regexp = "'custom_funs'", class = "expectation_failure")
  expect_error(summarize_table(df, custom_funs = "a"), regexp = "'custom_funs'", class = "expectation_failure")
  expect_error(summarize_table(df, custom_funs = list(fun())), regexp = "'custom_funs'", class = "expectation_failure")

  expect_error(summarize_table(df, base_summaries = NA), regexp = "'base_summaries'", class = "expectation_failure")
  expect_error(summarize_table(df, base_summaries = NULL), regexp = "'base_summaries'", class = "expectation_failure")
  expect_error(summarize_table(df, base_summaries = 1), regexp = "'base_summaries'", class = "expectation_failure")
  expect_error(summarize_table(df, base_summaries = "invalid"), regexp = "'base_summaries'", class = "expectation_failure")

  expect_error(summarize_table(df, find_culprits = NA), regexp = "'find_culprits'", class = "expectation_failure")
  expect_error(summarize_table(df, find_culprits = NULL), regexp = "'find_culprits'", class = "expectation_failure")
  expect_error(summarize_table(df, find_culprits = 1), regexp = "'find_culprits'", class = "expectation_failure")
  expect_error(summarize_table(df, find_culprits = "invalid"), regexp = "'find_culprits'", class = "expectation_failure")

  expect_error(summarize_table(df, find_outliers = NA), regexp = "'find_outliers'", class = "expectation_failure")
  expect_error(summarize_table(df, find_outliers = NULL), regexp = "'find_outliers'", class = "expectation_failure")
  expect_error(summarize_table(df, find_outliers = 1), regexp = "'find_outliers'", class = "expectation_failure")
  expect_error(summarize_table(df, find_outliers = "invalid"), regexp = "'find_outliers'", class = "expectation_failure")

  expect_error(summarize_table(df, find_outlier_opts = NA), regexp = "'find_outlier_opts'", class = "expectation_failure")
  expect_error(summarize_table(df, find_outlier_opts = NULL), regexp = "'find_outlier_opts'", class = "expectation_failure")
  expect_error(summarize_table(df, find_outlier_opts = c()), regexp = "'find_outlier_opts'", class = "expectation_failure")
  expect_error(summarize_table(df, find_outlier_opts = 1), regexp = "'find_outlier_opts'", class = "expectation_failure")
  expect_error(summarize_table(df, find_outlier_opts = "invalid"), regexp = "'find_outlier_opts'", class = "expectation_failure")
  expect_error(summarize_table(df, find_outlier_opts = list(fun())), regexp = "'find_outlier_opts'", class = "expectation_failure")
})
