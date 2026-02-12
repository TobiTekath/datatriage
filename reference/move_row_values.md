# Move specific values to other column

Move specific values in a `data.frame` or `tibble` to other column(s).
Specify which rows shall be affected by either providing row indices or
a logical vector to `select_rows`. A column name can also be supplied to
`select_rows`, then the matching values of rows have to be supplied in
`select_rows_values`. It is possible to specify more than one `from_col`
and `to_col` - but always the same number of columns. Moved values in
`from_col` are replaced with `clear_value`.

## Usage

``` r
move_row_values(
  df,
  select_rows = colnames(df)[1],
  select_rows_values = NULL,
  from_col,
  to_col,
  clear_value = NA
)
```

## Arguments

- df:

  A `data.frame` or `tibble`.

- select_rows:

  Which rows of `df` shall be selected for moving? Can be indices,
  logical values or a column name of `df`.

- select_rows_values:

  If a column name was supplied in `select_rows`, specify the column
  values of the rows you want to select.

- from_col:

  From which columns of `df` shall the values of selected entries be
  moved?

- to_col:

  To which columns of `df` shall the values of selected entries be
  moved?

- clear_value:

  With what value shall the moved values in `from_col` be replaced?

## Value

An object with same shape and class as `df`.

## Examples

``` r
df <- data.frame(
  "id" = letters[1:5], "a" = c(5:1), "b" = c(5:4, NA, 2:1),
  "c" = c(1:5), "d" = c(1:2, 2, 4:5)
)
df
#>   id a  b c d
#> 1  a 5  5 1 1
#> 2  b 4  4 2 2
#> 3  c 3 NA 3 2
#> 4  d 2  2 4 4
#> 5  e 1  1 5 5

# move for row 3, column a to b - replace with NA
df_mov <- move_row_values(df, select_rows = 3, from_col = "a", to_col = "b", clear_value = NA)
df_mov
#>   id  a b c d
#> 1  a  5 5 1 1
#> 2  b  4 4 2 2
#> 3  c NA 3 3 2
#> 4  d  2 2 4 4
#> 5  e  1 1 5 5

# move multiple columns and rows
df_mov <- move_row_values(df,
  select_rows = "id", select_rows_values = c("c", "d"),
  from_col = c("a", "c"), to_col = c("b", "d"), clear_value = 3
)
df_mov
#>   id a b c d
#> 1  a 5 5 1 1
#> 2  b 4 4 2 2
#> 3  c 3 3 3 3
#> 4  d 3 2 3 4
#> 5  e 1 1 5 5

# switching values is also possible e.g. by moving from a to b and b to a.
df_mov <- move_row_values(df,
  select_rows = c(FALSE, FALSE, TRUE),
  from_col = c("a", "b"), to_col = c("b", "a"), clear_value = NA
)
df_mov
#>   id  a b c d
#> 1  a  5 5 1 1
#> 2  b  4 4 2 2
#> 3  c NA 3 3 2
#> 4  d  2 2 4 4
#> 5  e  1 1 5 5
```
