# Retrieve an OpenET point time series

Requests raster data summarized at one longitude/latitude point. Daily
requests are limited to ten years by the OpenET API. See the
[getting-started
article](https://connorb.github.io/openetR/articles/getting-started.html)
for a complete example.

## Usage

``` r
openet_point_timeseries(
  longitude,
  latitude,
  start,
  end,
  interval = c("monthly", "daily"),
  model = "ensemble",
  variable = "et",
  reference_et = "gridmet",
  units = c("mm", "in"),
  version = 2.1,
  overpass = FALSE,
  key = Sys.getenv("OPENET_API_KEY")
)
```

## Arguments

- longitude, latitude:

  Numeric coordinates in WGS84 (EPSG:4326).

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
openet_point_timeseries(
  longitude = -121.36322, latitude = 38.87626,
  start = "2020-01-01", end = "2020-12-31"
)
} # }
```
