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

  The LHS inputs must evaluate to logical vectors.

  The RHS inputs will be coerced to their common type.

  All inputs will be recycled to their common size. That said, we
  encourage all LHS inputs to be the same size. Recycling is mainly
  useful for RHS inputs, where you might supply a size 1 input that will
  be recycled to the size of the LHS inputs.

  `NULL` inputs are ignored.

- .default:

  The value used when all of the LHS inputs return either `FALSE` or
  `NA`.

  `.default` must be size 1 or the same size as the common size computed
  from `...`.

  `.default` participates in the computation of the common type with the
  RHS inputs.

  `NA` values in the LHS conditions are treated like `FALSE`, meaning
  that the result at those locations will be assigned the `.default`
  value. To handle missing values in the conditions differently, you
  must explicitly catch them with another condition before they fall
  through to the `.default`. This typically involves some variation of
  `is.na(x) ~ value` tailored to your usage of `case_when()`.

  If `NULL`, the default, a missing value will be used.

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
