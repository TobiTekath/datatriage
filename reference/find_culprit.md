# Find not-fitting element (culprit) in vector

Find the element(s) in a vector, whose data type potentially deviates
from the majority data type or a specified one.

## Usage

``` r
find_culprit(
  vec,
  should_be = c("majority", "numeric", "double", "integer", "character", "logical",
    "Date", "hms", "POSIXct"),
  return_index = FALSE,
  na.rm = TRUE,
  verbose = TRUE,
  ...
)
```

## Arguments

- vec:

  Data vector to find the not-fitting element in.

- should_be:

  Expected data type of `vec`. `Numeric` is indifferent if double or
  integer is provided. If set to `majority`, expect the data type of
  most of the elements.

- return_index:

  Return index of culprit elements rather than their value.

- na.rm:

  Do not treat `NA` values as culprits, i.e. discard them from the
  culprit return.

- verbose:

  If guessed data type should be printed if `should_be` is `majority`.

- ...:

  Arguments passed on to
  [`minty::parse_guess`](http://gesistsa.github.io/minty/reference/parse_guess.md)

  `na`

  :   Character vector of strings to interpret as missing values. Set
      this option to
      [`character()`](https://rdrr.io/r/base/character.html) to indicate
      no missing values.

  `locale`

  :   The locale controls defaults that vary from place to place. The
      default locale is US-centric (like R), but you can use
      [`locale()`](http://gesistsa.github.io/minty/reference/locale.md)
      to create your own locale that controls things like the default
      time zone, encoding, decimal mark, big mark, and day/month names.

  `trim_ws`

  :   Should leading and trailing whitespace (ASCII spaces and tabs) be
      trimmed from each field before parsing it?

  `guess_max`

  :   Maximum number of data rows to use for guessing column types.
      `NA`: uses all data.

  `.return_problems`

  :   Whether to hide the `problems` tibble from the output

## Value

A named vector, with either the element values (default) or their index
(`return_index`) and the guessed data types as names.

## Details

This function can be used to find the culprit elements, which prevent
clean data type conversion. Utilizes
[`minty::parse_guess()`](http://gesistsa.github.io/minty/reference/parse_guess.md)
to guess type of every vector element. User can specify which data type
the vector `should_be`, or simply rely on the majority guess. By default
does not differentiate between double or integer values. Set `should_be`
to `integer` to enforce this differentiation. Ties in the majority guess
are resolved lexicographically by data type name, i.e. `character` \>
`double` \> `integer` \> `logical`. If `should_be` is `numeric`, the
data type is interpreted as `double` for lexicographic sorting. Flags
invalid `Date`, `hms`, or `POSIXct` values.

## Examples

``` r
long_data <- c(1, 2.2, ",4", 5)
long_data
#> [1] "1"   "2.2" ",4"  "5"  

# standard type conversion would convert ",4" to NA and give a warning
suppressWarnings(as.numeric(long_data))
#> [1] 1.0 2.2  NA 5.0

# for maximizing information content: find culprit element and treat it appropriately
find_culprit(long_data, should_be = "numeric")
#> character 
#>      ",4" 
as.numeric(gsub(",", "", long_data))
#> [1] 1.0 2.2 4.0 5.0

# other example: a supposed vector of integers
integer_vector <- c(1, 2, 2.99, 4, 5)

# straight integer conversion might not resolve deviations as intended
as.integer(integer_vector)
#> [1] 1 2 2 4 5

# better: identify deviation and handle it appropriately
find_culprit(integer_vector, should_be = "integer")
#> double 
#> "2.99" 
round(integer_vector)
#> [1] 1 2 3 4 5
```
