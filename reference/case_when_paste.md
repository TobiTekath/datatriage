# case_when variant that pastes results of matched formulas.

Drop-in replacement for
[case_when()](https://dplyr.tidyverse.org/reference/case-and-replace-when.html),
when you want combined output from the provided formulas. Evaluates each
formula separately, then combines the result per entry. Drops `NA`
results before pasting - `NA` should only be supplied in `.default` if
necessary.

## Usage

``` r
case_when_paste(..., .default = "", .sep = "")
```

## Arguments

- ...:

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>
  A sequence of two-sided formulas. The left hand side (LHS) determines
  which values match this case. The right hand side (RHS) provides the
  replacement value.

  For `case_when()`:

  - The LHS inputs must be logical vectors. For backwards compatibility,
    scalars are
    [recycled](https://vctrs.r-lib.org/reference/theory-faq-recycling.html),
    but we no longer recommend supplying scalars.

  - The RHS inputs will be
    [cast](https://vctrs.r-lib.org/reference/theory-faq-coercion.html)
    to their common type, and will be
    [recycled](https://vctrs.r-lib.org/reference/theory-faq-recycling.html)
    to the common size of the LHS inputs.

  For `replace_when()`:

  - The LHS inputs must be logical vectors the same size as `x`.

  - The RHS inputs will be
    [cast](https://vctrs.r-lib.org/reference/theory-faq-coercion.html)
    to the type of `x` and
    [recycled](https://vctrs.r-lib.org/reference/theory-faq-recycling.html)
    to the size of `x`.

  `NULL` inputs are ignored.

- .default:

  The value used when all of the LHS inputs return either `FALSE` or
  `NA`.

  - If `NULL`, the default, a missing value will be used.

  - If provided, `.default` will follow the same type and size rules as
    the RHS inputs.

  `NA` values in the LHS conditions are treated like `FALSE`, meaning
  that the result at those locations will be assigned the `.default`
  value. To handle missing values in the conditions differently, you
  must explicitly catch them with another condition before they fall
  through to the `.default`. This typically involves some variation of
  `is.na(x) ~ value` tailored to your usage of `case_when()`.

- .sep:

  The string separator for the different results when being combined.

## Value

A vector with the same size as the inputs.

## Examples

``` r
x <- data.frame(a = c(1, 2, 3), b = c(1, 2, 4))
x
#>   a b
#> 1 1 1
#> 2 2 2
#> 3 3 4

dplyr::mutate(x,
  class = case_when_paste(
    a == b ~ "equal",
    a == 1 ~ "special",
    .default = "not equal",
    .sep = " - "
  )
)
#>   a b           class
#> 1 1 1 equal - special
#> 2 2 2           equal
#> 3 3 4       not equal
```
