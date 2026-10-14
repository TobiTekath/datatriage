# Adds expectation_failure class to checkmate errors

Adds class `expectation_failure` to errors of `checkmate::check_`
functions. Extends functionality of `checkmate::check_` functions to be
systematically used in `testthat` unit tests. Allows for multiple
`checkmate::check_` via `combine`, like
[`checkmate::assert()`](https://mllg.github.io/checkmate/reference/assert.html).

## Usage

``` r
checkmate_wrapper(..., combine = "and", info = "")
```

## Arguments

- ...:

  Any number of `checkmate::check_` functions.

- combine:

  \[`character(1)`\]  
  “or” or “and” to combine the check functions with an OR or AND,
  respectively.

- info:

  Add additional information to the error message.

## Value

`TRUE` invisibly if check passes, the extended error otherwise.

## Details

Allows to check for catched errors like that:
`testthat::expect_error(checkmate_wrapper(checkmate::check_integerish(5)), class = "expectation_failure")`
