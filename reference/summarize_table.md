# Summarize metrics of a data.frame or tibble

Summarize metric for every column in `df`. Collects basic summary
metrics, but can also be extend by custom summary functions
(`custom_funs`). Optionally detects
[culprits](https://tobitekath.github.io/datatriage/reference/find_culprit.md)
or
[outliers](https://tobitekath.github.io/datatriage/reference/summarize_outlier.md).

## Usage

``` r
summarize_table(
  df,
  custom_funs = list(),
  base_summaries = TRUE,
  find_culprits = FALSE,
  find_outliers = FALSE,
  find_outlier_opts = list()
)
```

## Arguments

- df:

  A 'data.frame' of 'tibble'.

- custom_funs:

  A named list of custom summary functions. Can use formula style or
  proper functions.

- base_summaries:

  Perform basic summary functions? (see dsetails)

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

## Details

Basic summary metrics are:

- type: Column class

- n_observed: \# of non-NA values

- n_unique: \# of unique values (without NA)

- min: The minimum of the variable. Is lexicographic for character
  columns.

- max: The maximum of the variable. Is lexicographic for character
  columns.

## Examples

``` r
df <- data.frame(a = c(1L, 2L, 3L), b = c("a", "b", "c"), c = c(TRUE, FALSE, NA))
df
#>   a b     c
#> 1 1 a  TRUE
#> 2 2 b FALSE
#> 3 3 c    NA

# summarize basic metrics
summarize_table(df)
#> # A tibble: 3 × 6
#>   variable type      n_observed n_unique min   max  
#>   <chr>    <chr>          <dbl>    <dbl> <chr> <chr>
#> 1 a        integer            3        3 1     3    
#> 2 b        character          3        3 a     c    
#> 3 c        logical            2        2 0     1    

# add censored column
df$censored <- c("<5", "7", ">10")
df
#>   a b     c censored
#> 1 1 a  TRUE       <5
#> 2 2 b FALSE        7
#> 3 3 c    NA      >10

# add custom censored counting metric
summarize_table(df, custom_funs = list(n_censored = ~ length(grep("<|>", .x))))
#> # A tibble: 4 × 7
#>   variable type      n_observed n_unique min   max   n_censored
#>   <chr>    <chr>          <dbl>    <dbl> <chr> <chr>      <dbl>
#> 1 a        integer            3        3 1     3              0
#> 2 b        character          3        3 a     c              0
#> 3 c        logical            2        2 0     1              0
#> 4 censored character          3        3 7     >10            2

# has build-in function to also summarize culprits and outliers
df <- data.frame(out = c(rep(1, 10), 998, 999), culp = c(rep(1, 10), "a", "b"))
df
#>    out culp
#> 1    1    1
#> 2    1    1
#> 3    1    1
#> 4    1    1
#> 5    1    1
#> 6    1    1
#> 7    1    1
#> 8    1    1
#> 9    1    1
#> 10   1    1
#> 11 998    a
#> 12 999    b

summarize_table(df,
  base_summaries = FALSE, find_culprits = TRUE,
  find_outliers = TRUE, find_outlier_opts = list(minimal_unique_values = 1)
)
#> # A tibble: 2 × 3
#>   variable culprits outlier 
#>   <chr>    <chr>    <chr>   
#> 1 out      NA       999, 998
#> 2 culp     ‘a’, ‘b’ NA      
```
