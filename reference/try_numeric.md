# Try conversion to numeric

Try conversion of input element to numeric. Return the numeric
representation if it succeeds, the initial value if it does not.

## Usage

``` r
try_numeric(x)
```

## Arguments

- x:

  A single atomic value, i.e. one string, number or element.

## Value

Potentially the numeric representation of `x`, `x` otherwise.

## Examples

``` r
# convert string representation of a number
try_numeric("5")
#> [1] 5
try_numeric("1e5")
#> [1] 1e+05
try_numeric("Inf")
#> [1] Inf

# also converts logicals
try_numeric(TRUE)
#> [1] 1

# does not alter elements without proper representation
try_numeric("one")
#> [1] "one"
try_numeric(NA)
#> [1] NA
try_numeric(NULL)
#> NULL
```
