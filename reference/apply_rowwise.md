# Apply a function itemwise to two vectors

Apply a function rowwise to two same length vectors, e.g. comparison
functions. Optionally apply wrap functions to each item before the apply
function. Functions can also be function names (e.g. "sum" or "+").

## Usage

``` r
apply_rowwise(
  vec1,
  vec2,
  apply_fun,
  wrap_fun_vec1 = NULL,
  wrap_fun_vec2 = NULL
)
```

## Arguments

- vec1:

  Atomic vector 1.

- vec2:

  Atomic vector 2.

- apply_fun:

  The function that should be applied to both elements from `vec1` and
  `vec2` at the same index. Can be a function or a function name.

- wrap_fun_vec1:

  Optionally, a function that shall be applied to every `vec1` element
  before applying `apply_fun`. Can be a function or a function name.

- wrap_fun_vec2:

  Optioanlly, a function that shall be applied to every `vec2` element
  before applying `apply_fun`. Can be a function or a function name.

## Value

A result of the same length as the input vectors.

## Examples

``` r
# Can be useful for comparing vectors of potentially different data types.
vec1 <- c(1:5)
vec2 <- c(0:2, "a", "b")

apply_rowwise(vec1, vec2, apply_fun = ">", wrap_fun_vec2 = try_numeric)
#> [1]  TRUE  TRUE  TRUE FALSE FALSE
```
