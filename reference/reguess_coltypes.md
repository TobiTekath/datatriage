# Re-convert character columns in existing data frame

Convenience wrapper around
[`all_decimal_points_to_dot()`](https://tobitekath.github.io/datatriage/reference/all_decimal_points_to_dot.md)
and
[`readr::type_convert()`](https://readr.tidyverse.org/reference/type_convert.html).
Optionally converts numeric-like characters with a comma as decimal
point (as used in e.g. Germany) to dots, then performs a re-guessing of
column types of all character columns.

## Usage

``` r
reguess_coltypes(df, convert_comma_to_dot = FALSE, silent = TRUE, ...)
```

## Arguments

- df:

  A data.frame or tibble which character columns class shall be
  re-guessed.

- convert_comma_to_dot:

  Shall numeric-like characters with a comma as decimal point like '1,2'
  be converted to '1.2' before column type guessing?

- silent:

  Suppress column specification message from
  [`readr::type_convert()`](https://readr.tidyverse.org/reference/type_convert.html)
  column type guessing.

- ...:

  Arguments passed on to
  [`readr::type_convert`](https://readr.tidyverse.org/reference/type_convert.html)

  `col_types`

  :   One of `NULL`, a
      [`cols()`](https://readr.tidyverse.org/reference/cols.html)
      specification, or a string. See `vignette("readr")` for more
      details.

      If `NULL`, column types will be imputed using all rows.

  `na`

  :   Character vector of strings to interpret as missing values. Set
      this option to
      [`character()`](https://rdrr.io/r/base/character.html) to indicate
      no missing values.

  `trim_ws`

  :   Should leading and trailing whitespace (ASCII spaces and tabs) be
      trimmed from each field before parsing it?

  `locale`

  :   The locale controls defaults that vary from place to place. The
      default locale is US-centric (like R), but you can use
      [`locale()`](https://readr.tidyverse.org/reference/locale.html) to
      create your own locale that controls things like the default time
      zone, encoding, decimal mark, big mark, and day/month names.

  `guess_integer`

  :   If `TRUE`, guess integer types for whole numbers, if `FALSE` guess
      numeric type for all numbers.

## Value

A similar object as `df`, but column types potentially have been
changed.

## Examples

``` r
# create data frame of characters
df <- data.frame(a = c(1, 2, 3), b = c(TRUE, FALSE, NA), c = factor(c(1, 2, 1))) |>
  all_to_character()
df
#>   a     b c
#> 1 1  TRUE 1
#> 2 2 FALSE 2
#> 3 3  <NA> 1

reguess_coltypes(df)
#>   a     b c
#> 1 1  TRUE 1
#> 2 2 FALSE 2
#> 3 3    NA 1

# convert column b to numeric if convert_comma_to_dot is set.
df <- data.frame(a = c("a,b", "1,b", "c,0"), b = c("1,1", "1,2", "1,3"))
reguess_coltypes(df, convert_comma_to_dot = TRUE)
#>     a   b
#> 1 a,b 1.1
#> 2 1,b 1.2
#> 3 c,0 1.3
```
