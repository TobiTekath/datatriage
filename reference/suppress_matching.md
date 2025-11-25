# Selectively suppress messages, warnings, cat and print

Selectively suppress messages, warnings, cat and/or print whose output
matches given regex pattern.

## Usage

``` r
suppress_matching(
  expr,
  pattern = NULL,
  suppress_messages = TRUE,
  suppress_warnings = TRUE,
  suppress_cat_print = TRUE,
  ...
)
```

## Arguments

- expr:

  An expression that potentially produces some output.

- pattern:

  Provide a regex-string to only suppress matching output. If `NULL`,
  suppresses all output.

- suppress_messages:

  If output from [`message()`](https://rdrr.io/r/base/message.html)
  shall be suppressed.

- suppress_warnings:

  If output from [`warning()`](https://rdrr.io/r/base/warning.html)
  shall be suppressed.

- suppress_cat_print:

  If output from [`cat()`](https://rdrr.io/r/base/cat.html) and
  [`print()`](https://rdrr.io/r/base/print.html) shall be suppressed.

- ...:

  Arguments passed on to
  [`base::grepl`](https://rdrr.io/r/base/grep.html)

  `ignore.case`

  :   logical. if `FALSE`, the pattern matching is *case sensitive* and
      if `TRUE`, case is ignored during matching.

  `perl`

  :   logical. Should Perl-compatible regexps be used?

  `fixed`

  :   logical. If `TRUE`, `pattern` is a string to be matched as is.
      Overrides all conflicting arguments.

  `useBytes`

  :   logical. If `TRUE` the matching is done byte-by-byte rather than
      character-by-character. See ‘Details’.

## Value

The return value of the `expr`.

## Details

Utilizes [`grepl()`](https://rdrr.io/r/base/grep.html) for matching
output with given regex pattern. Selective suppression of
[`cat()`](https://rdrr.io/r/base/cat.html) and
[`print()`](https://rdrr.io/r/base/print.html) is tricky, as
differentiation of single output is not trivial. This function applies a
simple heuristic to at least separate
[`print()`](https://rdrr.io/r/base/print.html) output from each other
and [`cat()`](https://rdrr.io/r/base/cat.html). Two consecutive
[`cat()`](https://rdrr.io/r/base/cat.html) outputs can not be
differentiated at the moment, potentially leading to unwanted selective
suppression behavior.

## Examples

``` r
noisy_fun <- function() {
  message("I am a message")
  warning("I am a warning")
  cat("I am a cat")
  print("I am a print")
  return(TRUE)
}

# suppress all
result <- suppress_matching(noisy_fun())

# suppress by matching regex
result <- suppress_matching(noisy_fun(), pattern = ".*am A.*", ignore.case = TRUE)
```
