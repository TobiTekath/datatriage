# Strip html tags

Strip html tags from vec and potentially
[`stringr::str_squish()`](https://stringr.tidyverse.org/reference/str_trim.html)
to remove excessive newlines and whitespace.

## Usage

``` r
remove_html(vec, squish = TRUE)
```

## Arguments

- vec:

  Character vector where html tags shall be removed from.

- squish:

  If excessive newlines and whitespace shall be removed from stripped
  text. Uses
  [`stringr::str_squish()`](https://stringr.tidyverse.org/reference/str_trim.html).

## Value

A character vector without html tags.

## Examples

``` r
text <- "text with <p> some tags </p>"
remove_html(text)
#> [1] "text with some tags"
```
