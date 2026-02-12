#' Summarize metrics of a data.frame or tibble
#'
#' Summarize metric for every column in `df`.
#' Collects basic metrics, but can also be extend by custom summary functions (`custom_funs`).
#' Optionally detects [culprits][find_culprit()] or [outliers][summarize_outlier()].
#'
#' @param df A 'data.frame' of 'tibble'.
#' @param custom_funs A named list of custom summary functions.
#' @param find_culprits Shall culprit detection be performed via [find_culprit()]?
#' @param find_outliers Shall outlier detection be performed via [summarize_outlier()]?
#' @param find_outlier_opts If `find_outliers`, specify a named list of non-default options for the [summarize_outlier()] call.
#'
#' @returns A summary tibble with as many rows as `df` has columns.
#' @export
#'
#' @examples
#' # TODO
summarize_table <- function(df, custom_funs = list(), find_culprits = TRUE, find_outliers = TRUE, find_outlier_opts = list()) {
  checkmate::expect_data_frame(df, min.rows = 1, min.cols = 1)
  checkmate::expect_list(custom_funs, names = "named", any.missing = FALSE)
  checkmate::expect_flag(find_culprits)
  checkmate::expect_flag(find_outliers)
  checkmate::expect_list(find_outlier_opts, names = "named", any.missing = FALSE)

  base_funs <- list(
    type = ~ class(.x)[1],
    n_observed = ~ sum(!is.na(.x)),
    n_unique = ~ length(unique(stats::na.omit(.x))),
    min = ~ (if (is.factor(.x)) levels(.x)[1] else as.character(min(.x, na.rm = TRUE))),
    max = ~ (if (is.factor(.x)) levels(.x)[length(levels(.x))] else as.character(max(.x, na.rm = TRUE)))
  )

  if (find_culprits) {
    base_funs$culprits <- ~ stringr::str_flatten_comma(sQuote(stringr::str_c(find_culprit(.x, verbose = FALSE))))
  }

  if (find_outliers) {
    find_outlier_opts <- utils::modifyList(formals(summarize_outlier), find_outlier_opts, keep.null = FALSE)
    find_outlier_opts$vec <- NULL

    base_funs$outlier <- function(x) do.call(summarize_outlier, c(list("vec" = x), find_outlier_opts))
  }

  all_funs <- c(base_funs, custom_funs)

  summ_df <- df |>
    dplyr::summarise(dplyr::across(tidyselect::everything(), .fns = all_funs, .names = "{.col}__{.fn}")) |>
    tidyr::pivot_longer(cols = tidyselect::everything(), names_to = c("variable", "metric"), names_sep = "__", values_to = "value", values_transform = as.character) |>
    tidyr::pivot_wider(id_cols = "variable", names_from = "metric", values_from = "value") |>
    reguess_coltypes()

  return(summ_df)
}
