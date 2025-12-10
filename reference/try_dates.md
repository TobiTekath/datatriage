# Try conversion to date representation

Wrapper around
[`try_date()`](https://tobitekath.github.io/datatriage/reference/try_date.md)
for multiple values. Try conversion of date serial values to their
respective date representation.

## Usage

``` r
try_dates(vec, ...)
```

## Arguments

- vec:

  Vector containing values to try conversion.

- ...:

  Arguments passed on to
  [`try_date`](https://tobitekath.github.io/datatriage/reference/try_date.md)

  `origin`

  :   The origin of the serial value, i.e. the day 0. See description
      for list of supported options.

  `min_date`

  :   Set a minimum date for conversion. Use format `YYYY-MM-DD`.

  `max_date`

  :   Set a maximum date for conversion. Use format `YYYY-MM-DD`.

## Value

A character vector with potentially converted dates.

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

[`try_date()`](https://tobitekath.github.io/datatriage/reference/try_date.md)

## Examples

``` r
serial_values <- c(10000, 20000, 30000)

# convert with minimal date set - first value is not converted
try_dates(serial_values, min_date = "1950-01-01")
#> [1] "10000"      "1954-10-03" "1982-02-18"
```
