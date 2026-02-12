# Summarize metrics of a data.frame or tibble

Summarize metric for every column in `df`. Collects basic metrics, but
can also be extend by custom summary functions (`custom_funs`).
Optionally detects
[culprits](https://tobitekath.github.io/datatriage/reference/find_culprit.md)
or
[outliers](https://tobitekath.github.io/datatriage/reference/summarize_outlier.md).

## Usage

``` r
summarize_table(
  df,
  custom_funs = list(),
  find_culprits = TRUE,
  find_outliers = TRUE,
  find_outlier_opts = list()
)
```

## Arguments

- df:

  A 'data.frame' of 'tibble'.

- custom_funs:

  A named list of custom summary functions.

- find_culprits:

  Shall culprit detection be performed via
  [`find_culprit()`](https://tobitekath.github.io/datatriage/reference/find_culprit.md)?

- find_outliers:

  Shall outlier detection be performed via
  [`summarize_outlier()`](https://tobitekath.github.io/datatriage/reference/summarize_outlier.md)?

- find_outlier_opts:

  If `find_outliers`, specify a named list of non-default options for
  the
  [`summarize_outlier()`](https://tobitekath.github.io/datatriage/reference/summarize_outlier.md)
  call.

## Value

A summary tibble with as many rows as `df` has columns.

## Examples

``` r
# TODO
```
