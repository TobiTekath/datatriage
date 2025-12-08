# Relocate multiple columns

Re-position multiple data frame columns at once. Extended wrapper around
[`dplyr::relocate()`](https://dplyr.tidyverse.org/reference/relocate.html)
to support relocation of multiple columns to multiple respective
positions at once.

## Usage

``` r
relocate_multi(df, move = NULL, before = NULL, after = NULL)
```

## Arguments

- df:

  A data.frame or tibble with columns that shall be relocated.

- move:

  The columns that shall be moved. Can be column names, indices,
  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  or
  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expressions.

- before:

  The columns, where the respective `move` column shall be placed
  **before**. Can be column names, indices,
  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  or
  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expressions.

- after:

  The columns, where the respective `move` column shall be placed
  **after**. Can be column names, indices,
  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  or
  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expressions.

## Value

`df` with re-positioned columns.

## Details

All column (selection) indices are converted to names, to allow multiple
relocation operations for the same column without index confusion.

## Examples

``` r
df <- data.frame("a" = 1:2, "b" = 3:4, "c" = 5:6, "d" = 7:8)
df
#>   a b c d
#> 1 1 3 5 7
#> 2 2 4 6 8

# Move column "a" after "b" and column "c" after "d"
relocate_multi(df, move = c("a", "c"), after = c("b", "d"))
#>   b a d c
#> 1 3 1 7 5
#> 2 4 2 8 6

# The same operation with indices
relocate_multi(df, move = c(1, 3), after = c(2, 4))
#>   b a d c
#> 1 3 1 7 5
#> 2 4 2 8 6

# The same operation with tidy-select expression
df |> relocate_multi(move = tidyselect::all_of(c(1, 3)), after = tidyselect::all_of(c(2, 4)))
#>   b a d c
#> 1 3 1 7 5
#> 2 4 2 8 6

# Use data masking to move "b" before "a"
df |> relocate_multi(move = rlang::expr(b), before = rlang::expr(a))
#>   b a c d
#> 1 3 1 5 7
#> 2 4 2 6 8

# Relocation operations are sequential:
# Move "c" after "d" -> abdc
# Move "a" after "c" -> bdca
# Move "a" after "d" -> bdac
relocate_multi(df, move = c("c", "a", "a"), after = c("d", "c", "d"))
#>   b d a c
#> 1 3 7 1 5
#> 2 4 8 2 6
```
