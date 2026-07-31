# Retrieve an OpenET polygon time series

Requests raster data aggregated over a simple polygon. Supply a
flattened longitude/latitude vector, e.g.
`c(-121, 44, -121, 45, -120, 45, -120, 44)`. Daily requests are limited
to ten years by the OpenET API.

## Usage

``` r
openet_polygon_timeseries(
  geometry,
  start,
  end,
  interval = c("monthly", "daily"),
  model = "ensemble",
  variable = "et",
  reference_et = "gridmet",
  reducer = c("mean", "sum", "min", "max", "median", "mode"),
  units = c("mm", "in"),
  version = 2.1,
  overpass = FALSE,
  key = Sys.getenv("OPENET_API_KEY")
)
```

## Arguments

- geometry:

  An even-length numeric vector of longitude/latitude pairs.

- start, end:

  Inclusive dates, coercible to `Date`.

- interval:

  One of `"monthly"` or `"daily"`.

- model:

  OpenET model, such as `"ensemble"` or `"ssebop"`.

- variable:

  OpenET variable, such as `"et"`, `"eto"`, or `"ndvi"`.

- reference_et:

  Reference ET source.

- reducer:

  Pixel aggregation method.

- units:

  Output depth units.

- version:

  OpenET image collection version.

- overpass:

  Return only satellite-observed scenes for daily requests?

- key:

  API key, by default from `OPENET_API_KEY`.

## Value

A tibble when OpenET returns row-like JSON; otherwise the decoded
response object.

## Examples

``` r
if (FALSE) { # \dontrun{
openet_polygon_timeseries(
  geometry = c(-121.01, 44.24, -121.01, 44.25, -121.00, 44.25),
  start = "2020-01-01", end = "2020-12-31"
)
} # }
```
