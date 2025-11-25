# A general vectorised switch() that keeps unaffected values

A convenience wrapper around
[`dplyr::case_match()`](https://dplyr.tidyverse.org/reference/case_match.html),
with `.default` set to the input parameter `.x` (i.e. keeping values
unaffected by any switch statements as they are)

## Usage

``` r
case_modify(.x, ...)
```

## Arguments

- .x:

  A vector to match against.

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  A sequence of two-sided formulas: `old_values ~ new_value`. The right
  hand side (RHS) determines the output value for all values of `.x`
  that match the left hand side (LHS).

  The LHS must evaluate to the same type of vector as `.x`. It can be
  any length, allowing you to map multiple `.x` values to the same RHS
  value. If a value is repeated in the LHS, i.e. a value in `.x` matches
  to multiple cases, the first match is used.

  The RHS inputs will be coerced to their common type. Each RHS input
  will be
  [recycled](https://vctrs.r-lib.org/reference/theory-faq-recycling.html)
  to the size of `.x`.

## Value

A vector with the same size as .x.

## Examples

``` r
dummy_df <- data.frame("a" = c(1:3))
# only replace 3 by 4, keep the rest
dplyr::mutate(dummy_df, a = case_modify(a, 3 ~ 4))
#>   a
#> 1 1
#> 2 2
#> 3 4
```
