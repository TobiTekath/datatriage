test_that("case_modify works", {
  dummy_df <- data.frame("a" = c(1:3))

  res <- dummy_df |>
    dplyr::mutate(a = case_modify(a, 3 ~ 4))
  expect_identical(res[["a"]], c(1, 2, 4))
})
