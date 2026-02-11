test_that("case_when pasting works", {
  df <- data.frame(a = c(1, 2, 3, 4), b = c(1, 2, 4, NA))

  # NA is dropped
  res <- dplyr::mutate(df,
    x = case_when_paste(a == b ~ "hi",
      b == 2 ~ "ho",
      is.na(b) ~ NA,
      .default = "",
      .sep = "."
    )
  )
  expect_identical(res$x, c("hi", "hi.ho", "", ""))

  res <- dplyr::mutate(df,
    x = case_when_paste(a == 1 ~ "hi",
      .default = NA
    )
  )
  expect_identical(res$x, c("hi", rep(NA, nrow(df) - 1)))
})

test_that("argument checks work", {
  x <- data.frame()

  expect_error(dplyr::mutate(x, a = case_when_paste()), regexp = "one condition")

  expect_error(dplyr::mutate(x, a = case_when_paste(a ~ 1, .default = 1)), regexp = "'.default'", class = "expectation_failure")
  expect_error(dplyr::mutate(x, a = case_when_paste(a ~ 1, .default = TRUE)), regexp = "'.default'", class = "expectation_failure")
  expect_error(dplyr::mutate(x, a = case_when_paste(a ~ 1, .default = list())), regexp = "'.default'", class = "expectation_failure")
  expect_error(dplyr::mutate(x, a = case_when_paste(a ~ 1, .default = NULL)), regexp = "'.default'", class = "expectation_failure")

  expect_error(dplyr::mutate(x, a = case_when_paste(a ~ 1, .sep = 1)), regexp = "'.sep'", class = "expectation_failure")
  expect_error(dplyr::mutate(x, a = case_when_paste(a ~ 1, .sep = TRUE)), regexp = "'.sep'", class = "expectation_failure")
  expect_error(dplyr::mutate(x, a = case_when_paste(a ~ 1, .sep = list())), regexp = "'.sep'", class = "expectation_failure")
  expect_error(dplyr::mutate(x, a = case_when_paste(a ~ 1, .sep = NULL)), regexp = "'.sep'", class = "expectation_failure")
  expect_error(dplyr::mutate(x, a = case_when_paste(a ~ 1, .sep = NA)), regexp = "'.sep'", class = "expectation_failure")
})
