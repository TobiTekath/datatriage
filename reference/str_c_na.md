# NA-aware str_c

NA-aware drop-in replacement for
[str_c()](https://stringr.tidyverse.org/reference/str_c.html). Discards
NAs when other strings are present. Reduces multiple NAs to a single
one.

## Usage

``` r
str_c_na(..., sep = "", collapse = NULL)
```

## Arguments

- ...:

  One or more character vectors.

  `NULL`s are removed; scalar inputs (vectors of length 1) are recycled
  to the common length of vector inputs.

  Like most other R functions, missing values are "infectious": whenever
  a missing value is combined with another string the result will always
  be missing. Use
  [`dplyr::coalesce()`](https://dplyr.tidyverse.org/reference/coalesce.html)
  or
  [`str_replace_na()`](https://stringr.tidyverse.org/reference/str_replace_na.html)
  to convert to the desired value.

- sep:

  String to insert between input vectors.

- collapse:

  Optional string used to combine output into single string. Generally
  better to use
  [`str_flatten()`](https://stringr.tidyverse.org/reference/str_flatten.html)
  if you needed this behaviour.

## Value

If `collapse = NULL` (the default) a character vector with length equal
to the longest input. If `collapse` is a string, a character vector of
length 1.

## Examples

``` r
vec <- c("a", NA, "b")

# only returns NA
stringr::str_c(vec)
#> [1] "a" NA  "b"

# discards NA
str_c_na(vec)
#> [1] "a" NA  "b"

# collapse also discards NAs
str_c_na(c("a", NA), c(NA, "b"), collapse = ", ")
#> [1] "a, b"
```
