# Convert all columns to character

Convert all columns of the provided object to `character`.

## Usage

``` r
all_to_character(df)
```

## Arguments

- df:

  A data.frame or tibble which columns shall be converted.

## Value

A similar object as `df`, but all columns are of class
[`character()`](https://rdrr.io/r/base/character.html).

## Examples

``` r
df <- data.frame(a = c(1, 2, 3), b = c("a", "b", "c"))
df
#>   a b
#> 1 1 a
#> 2 2 b
#> 3 3 c

all_to_character(df)
#>   a b
#> 1 1 a
#> 2 2 b
#> 3 3 c
```
