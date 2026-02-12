test_that("table summarizing works", {
  df <- data.frame(
    a = c(1L, 2L, 3L), b = c("a", "b", "c"), c = c(TRUE, FALSE, NA),
    d = factor(c(2, 3, 1), levels = c(2, 3, 1)), e = c(1.1, 1.2, 1.3),
    f = c(-0.9, -1, Inf), g = c(1, 1, 1), h = c("1|2", "3", "2|3")
  )

  summarize_table(df, custom_funs = list(n_multi = ~ sum(stringr::str_detect(.x, "\\|"), na.rm = TRUE)))
})

test_that("argument checks work", {
  # TODO
})
