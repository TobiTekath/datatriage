# Check rowwise for trailing elements

Check rowwise for the provided data.frame columns if a value is
trailing.

## Usage

``` r
check_trailing_rowwise(df, cols, trail_value)
```

## Arguments

- df:

  A `data.frame` or `tibble`.

- cols:

  Which columns of `df` shall be checked rowwise?

- trail_value:

  Which trailing value to check for?

## Value

A logical vector of the same size as `df` has rows.

## Examples

``` r
df <- data.frame(a = c(1, 2, 3), b = c(2, 3, 2), c = c(3, 3, 3))
df
#>   a b c
#> 1 1 2 3
#> 2 2 3 3
#> 3 3 2 3

# check over all columns rowwise for trailing 3s
check_trailing_rowwise(df, cols = colnames(df), trail_value = 3)
#> [1]  TRUE  TRUE FALSE
```
