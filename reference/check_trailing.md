# Check for trailing elements

Check if the provided vector has a consistently trailing element. If a
certain trailing value has been reached, all subsequent vector elements
should be this value.

## Usage

``` r
check_trailing(vec, trail_value)
```

## Arguments

- vec:

  The to-be-checked vector.

- trail_value:

  The trailing value to check for.

## Value

A single logical if the provided trailing is fulfilled.

## Details

If the trailing value does not occur in the vector, returns `TRUE`.

## Examples

``` r
# 3 is trailing
vec <- c(1, 2, 3, 3, 3)
check_trailing(vec, trail_value = 3)
#> [1] TRUE

# c is not trailing (interrupted by b)
vec <- c("b", "c", "b", "c", "c")
check_trailing(vec, trail_value = "c")
#> [1] FALSE

# trailing value does not occur - trailing rule is not violated
check_trailing(vec, trail_value = "d")
#> [1] TRUE

# also works with NA
check_trailing(c(1, NA, NA), trail_value = NA)
#> [1] TRUE
```
