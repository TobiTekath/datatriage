test_that("case_modify works", {
  dummy_df <- data.frame("a" = c(1:3), "b" = letters[1:3])

  res <- case_modify(dummy_df$a, 3 ~ 4)
  expect_identical(res, c(1, 2, 4))

  res <- case_modify(dummy_df$b, "a" ~ "c", "c" ~ "d")
  expect_identical(res, c("c", "b", "d"))
})

test_that("case_modify versions work", {
  skip_if_not_installed("dplyr", minimum_version = "1.2.0")
  # ensure case_match and recode_values both work

  dummy_df <- data.frame("a" = c(1:3), "b" = letters[1:3])

  suppress_matching(res <- dummy_df |>
    dplyr::mutate(a = dplyr::case_match(a, 3 ~ 4, .default = a)), pattern = "was deprecated")
  expect_identical(res$a, c(1, 2, 4))
  suppress_matching(res <- dummy_df |>
    dplyr::mutate(b = dplyr::case_match(b, "a" ~ "c", "c" ~ "d", .default = b)), pattern = "was deprecated")
  expect_identical(res$b, c("c", "b", "d"))


  res <- dummy_df |>
    dplyr::mutate(a = dplyr::recode_values(a, 3 ~ 4, default = a))
  expect_identical(res$a, c(1, 2, 4))
  res <- dummy_df |>
    dplyr::mutate(b = dplyr::recode_values(b, "a" ~ "c", "c" ~ "d", default = b))
  expect_identical(res$b, c("c", "b", "d"))
})
