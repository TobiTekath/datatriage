# Convert given decimal character to dot

Convert specified decimal character in numeric-like character to dot.

## Usage

``` r
all_decimal_points_to_dot(df, convert_decimal_character = ",", trim_ws = FALSE)
```

## Arguments

- df:

  A data.frame or tibble.

- convert_decimal_character:

  Specify the decimal point character that shall be converted to a dot.

- trim_ws:

  Trim white space from both ends before trying conversion?

## Value

A similar object as `df`, but with potentially replaced decimal
characters.

## Details

Has safeguards to only convert numeric-like characters - any non-numeric
character will prevent conversion.

## Examples

``` r
df <- data.frame(x1 = c("1,1", "2,2", " 3,3", "4,4 ", "1,1a"))
all_decimal_points_to_dot(df)
#> Loading required namespace: testthat
#>     x1
#> 1  1.1
#> 2  2.2
#> 3  3,3
#> 4 4,4 
#> 5 1,1a

# also trim white space
all_decimal_points_to_dot(df, trim_ws = TRUE)
#>     x1
#> 1  1.1
#> 2  2.2
#> 3  3.3
#> 4  4.4
#> 5 1,1a
```
