# Try conversion to date representation

Try conversion of a date serial value to the respective date
representation. Return the date object or its character representation
if conversion succeeds, the original value if it does not. Allows to
only convert dates above and/or below a min/max date.

## Usage

``` r
try_date(
  x,
  origin = c("excel", "excel_off1", "excel_1904", "unix"),
  min_date = NULL,
  max_date = NULL,
  return_character = TRUE
)
```

## Arguments

- x:

  A single atomic value, i.e. one string, number or element.

- origin:

  The origin of the serial value, i.e. the day 0. See description for
  list of supported options.

- min_date:

  Set a minimum date for conversion. Use format `YYYY-MM-DD`.

- max_date:

  Set a maximum date for conversion. Use format `YYYY-MM-DD`.

- return_character:

  Return the character representation of the converted object, rather
  than the date object. Does not affect return of unsuccessful
  conversions. Returns in Format `YYYY-MM-DD`.

## Value

Potentially the date representation of `x`, `x` otherwise.

## Details

**Origin**: Correct conversion relies on the correct origin for the
serial value. Available options are:

- `excel`: Set the origin to `1899-12-30`. This is the default date
  origin in Excel for Windows and for Mac since 2011.

- `excel_off1`: Set the origin to `1899-12-31`. This might be useful to
  tackle Excel's 1900 Leap Year Bug for dates before before the 28th of
  February 1900.

- `excel_1904`: Set the origin to `1904-01-01`. This is the date origin
  for the Excel 1904 date system, which was default in early versions of
  Excel for Mac.

- `unix`: Set the origin to `1970-01-01`. This is Epoch time used by
  unix-based systems.

For more details about the date origin used in Excel, see
[Microsoft](https://support.microsoft.com/en-us/office/date-systems-in-excel-e7fe7167-48a9-4b96-bb53-5612a800b487).

## See also

[`try_dates()`](https://tobitekath.github.io/datatriage/reference/try_dates.md)

## Examples

``` r
# Excel has converted a date to a serial number, e.g. 40729

# convert to date representation
try_date("40729")
#> [1] "2011-07-05"
try_date(40729)
#> [1] "2011-07-05"

# no conversion for incompatible data types
try_date("hello")
#> [1] "hello"
try_date("1900-01-01")
#> [1] "1900-01-01"

# set min or max date to only convert values in range
try_date("40729", min_date = "2011-07-06")
#> [1] "40729"
```
