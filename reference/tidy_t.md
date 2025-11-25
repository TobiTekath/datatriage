# Transpose a data.frame or tibble

Allow transposing a data.frame or tibble in a "tidy" way. Instead of row
names, the column names of the transposed object are taken from a
specified `id_col`.  
**Note**: The input `df` should **not contain** row names, as they would
be discarded.

## Usage

``` r
tidy_t(
  df,
  id_col = 1,
  exclude_cols = NULL,
  new_id_colname = NULL,
  reguess_coltypes = FALSE,
  name_repair = "unique",
  verbose = FALSE
)
```

## Arguments

- df:

  The to-be-transposed data.frame or tibble.

- id_col:

  Which column of `df` shall be used as new column names? Can be either
  an index or a column name.

- exclude_cols:

  Exclude specified columns before transposing. Can be either one or
  multiple indices or a column names, or `NULL`.

- new_id_colname:

  Rename the first column of the transposed object. If `NULL`, carry
  over the selected `id_col` column name.

- reguess_coltypes:

  Shall a re-guessing of column types be performed after transposing?
  Allows to correctly retrieve e.g. numeric or logical columns by
  utilizing
  [`reguess_coltypes()`](https://tobitekath.github.io/datatriage/reference/reguess_coltypes.md).

- name_repair:

  Choose strategy to potentially repair 'id_col', e.g. for uniqueness.
  Is passed on to
  [`vctrs::vec_as_names()`](https://vctrs.r-lib.org/reference/vec_as_names.html),
  supporting among else the following strategies:

  - "minimal": No name repair or checks, beyond basic existence of names
    and replacing NA's.

  - "unique": Make sure names are unique and not empty. A suffix is
    appended to duplicate names to make them unique.

  - "universal": Make the names unique and syntactic, meaning that you
    can safely use the names as variables without causing a syntax
    error.

- verbose:

  Set verbosity of potential name_repair.

## Value

A transposed object - keeps object type of `df` input (data.frame or
tibble).

## Examples

``` r
df <- data.frame(a = c("x1", "1", "FALSE"), b = c("x2", "2", "TRUE"))

tidy_t(df)
#>   a x1 1 FALSE
#> 1 b x2 2  TRUE

# reguessing column types
tidy_t(df, reguess_coltypes = TRUE)
#>   a x1 1 FALSE
#> 1 b x2 2  TRUE

# using second column as id column
tidy_t(df, id_col = "b")
#>   b x2 2  TRUE
#> 1 a x1 1 FALSE

# excluding columns
tidy_t(df, exclude_cols = "b")
#> [1] a     x1    1     FALSE
#> <0 rows> (or 0-length row.names)

# renaming id column
tidy_t(df, new_id_colname = "var")
#>   var x1 1 FALSE
#> 1   b x2 2  TRUE
```
