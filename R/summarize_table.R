#' Summarize metrics of a data.frame or tibble
#'
#' Summarize metric for every column in `df`.
#' Collects basic summary metrics, but can also be extend by custom summary functions (`custom_funs`).
#' Optionally detects [culprits][find_culprit()] or [outliers][summarize_outlier()].
#'
#' Basic summary metrics are:
#' - type: Column class
#' - n_observed: # of non-NA values
#' - n_unique: # of unique values (without NA)
#' - min: The minimum of the variable. Is lexicographic for character columns.
#' - max: The maximum of the variable. Is lexicographic for character columns.
#'
#' @param df A 'data.frame' of 'tibble'.
#' @param custom_funs A named list of custom summary functions. Can use formula style or proper functions.
#' @param base_summaries Perform basic summary functions? (see dsetails)
#' @param find_culprits Shall culprit detection be performed via [find_culprit()]?
#' @param find_outliers Shall outlier detection be performed via [summarize_outlier()]?
#' @param find_outlier_opts If `find_outliers`, specify a named list of non-default options for the [summarize_outlier()] call.
#'
#' @returns A summary tibble with as many rows as `df` has columns.
#' @export
#'
#' @examples
#' df <- data.frame(a = c(1L, 2L, 3L), b = c("a", "b", "c"), c = c(TRUE, FALSE, NA))
#' df
#'
#' # summarize basic metrics
#' summarize_table(df)
#'
#' # add censored column
#' df$censored <- c("<5", "7", ">10")
#' df
#'
#' # add custom censored counting metric
#' summarize_table(df, custom_funs = list(n_censored = ~ length(grep("<|>", .x))))
#'
#' # has build-in function to also summarize culprits and outliers
#' df <- data.frame(out = c(rep(1, 10), 998, 999), culp = c(rep(1, 10), "a", "b"))
#' df
#'
#' summarize_table(df,
#'   base_summaries = FALSE, find_culprits = TRUE,
#'   find_outliers = TRUE, find_outlier_opts = list(minimal_unique_values = 1)
#' )
summarize_table <- function(df, custom_funs = list(), base_summaries = TRUE, find_culprits = FALSE, find_outliers = FALSE, find_outlier_opts = list()) {
  checkmate::expect_data_frame(df, min.rows = 1, min.cols = 1)
  checkmate::expect_list(custom_funs, names = "named", any.missing = FALSE)
  checkmate::expect_flag(base_summaries)
  checkmate::expect_flag(find_culprits)
  checkmate::expect_flag(find_outliers)
  checkmate::expect_list(find_outlier_opts, names = "named", any.missing = FALSE)

  funs <- list()

  if (base_summaries) {
    base_funs <- list(
      type = ~ class(.x)[1],
      n_observed = ~ sum(!is.na(.x)),
      n_unique = ~ length(unique(stats::na.omit(.x))),
      min = ~ (if (is.factor(.x)) levels(.x)[1] else as.character(min(.x, na.rm = TRUE))),
      max = ~ (if (is.factor(.x)) levels(.x)[length(levels(.x))] else as.character(max(.x, na.rm = TRUE)))
    )
    funs <- c(funs, base_funs)
  }


  if (find_culprits) {
    funs$culprits <- ~ stringr::str_flatten_comma(sQuote(stringr::str_c(find_culprit(.x, verbose = FALSE))))
  }

  if (find_outliers) {
    find_outlier_opts <- utils::modifyList(formals(summarize_outlier), find_outlier_opts, keep.null = FALSE)
    find_outlier_opts$vec <- NULL

    funs$outlier <- function(x) do.call(summarize_outlier, c(list("vec" = x), find_outlier_opts))
  }

  all_funs <- c(funs, custom_funs)
  checkmate::expect_list(all_funs, min.len = 1, info = "Supply at least one summary function.")
  if (anyDuplicated(names(all_funs)) != 0) {
    rlang::warn("summarize_table: Enforcing unique summary column names.")
    names(all_funs) <- make.unique(names(all_funs))
  }

  summ_df <- df |>
    dplyr::summarise(dplyr::across(tidyselect::everything(), .fns = all_funs, .names = "{.col}__{.fn}")) |>
    tidyr::pivot_longer(cols = tidyselect::everything(), names_to = c("variable", "metric"), names_sep = "__", values_to = "value", values_transform = as.character) |>
    tidyr::pivot_wider(id_cols = "variable", names_from = "metric", values_from = "value") |>
    reguess_coltypes()

  return(summ_df)
}
