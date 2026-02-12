# Summarize outlier values for numeric vectors

Utilize
[check_outliers()](https://easystats.github.io/performance/reference/check_outliers.html)
to determine which values are determined as outliers. Summarizes the
result to a comma-separated, decreasing string. Allows to specify a
minimal amount of unique values in `vec` to perform outlier detection.

## Usage

``` r
summarize_outlier(
  vec,
  minimal_unique_values = 10,
  method = c("iqr", "zscore_robust"),
  threshold = list(zscore_robust = 7, iqr = 5)
)
```

## Arguments

- vec:

  The vector to be checked for outliers.

- minimal_unique_values:

  Amount of unique values in `vec` before the outlier detection is
  performed. Set to `1` to always perform detection.

- method:

  The outlier detection method(s). Can be `"all"` or some of `"cook"`,
  `"pareto"`, `"zscore"`, `"zscore_robust"`, `"iqr"`, `"ci"`, `"eti"`,
  `"hdi"`, `"bci"`, `"mahalanobis"`, `"mahalanobis_robust"`, `"mcd"`,
  `"ics"`, `"optics"` or `"lof"`.

- threshold:

  A list containing the threshold values for each method (e.g.
  `list('mahalanobis' = 7, 'cook' = 1)`), above which an observation is
  considered as outlier. If `NULL`, default values will be used (see
  'Details'). If a numeric value is given, it will be used as the
  threshold for any of the method run. For EFA/PCA/Omega, indicates the
  threshold for correlation of residuals (by default, 0.05).

## Value

A summary string of outliers, an empty string if not outliers where
detected.

## Examples

``` r
norm <- rnorm(n = 100)
shift_norm <- rnorm(n = 10, mean = 999)
vec <- sample(c(norm, shift_norm))

summarize_outlier(vec)
#> [1] "1001.12685045903, 1001.0393692625, 1000.39181404564, 1000.07283825182, 999.568599861215, 999.44945377806, 999.426566546904, 999.424858441314, 999.249401783969, 997.31571846775"
```
