# Check one-hot encoding

Check if specified columns follow a one-hot coding scheme, i.e. only one
"positive" value per row across the columns.

## Usage

``` r
check_one_hot(df, cols, check_value = 1, allow_no_selection = FALSE)
```

## Arguments

- df:

  A `data.frame` or `tibble`.

- cols:

  Which columns of `df` shall be checked?

- check_value:

  Which value represents a `positive selection`?

- allow_no_selection:

  Shall rows without `check_value` be valid or not?

## Value

A logical vector indicating for every row of `df` if the selected
columns follow a one-hot encoding scheme.

## Details

You can specify if rows without selection, i.e. rows without "positive"
value, should be regarded as valid. Does not check the format of the
other "negative" values.

## Examples

``` r
df <- data.frame(a = c(1, 0, 0), b = c(0, 0, 1), c = c(0, NA, 1))
df
#>   a b  c
#> 1 1 0  0
#> 2 0 0 NA
#> 3 0 1  1

# every row must have a positive selection
check_one_hot(df, cols = colnames(df))
#> [1]  TRUE FALSE FALSE

# also allow empty rows
check_one_hot(df, cols = colnames(df), allow_no_selection = TRUE)
#> [1]  TRUE  TRUE FALSE

# also works with other "positive" values
df <- data.frame(a = c("one", "two"), b = c("two", "oneone"))
df
#>     a      b
#> 1 one    two
#> 2 two oneone

check_one_hot(df, cols = colnames(df), check_value = "one")
#> [1]  TRUE FALSE
```
