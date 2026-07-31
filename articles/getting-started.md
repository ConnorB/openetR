# Get started with openetR

``` r

library(openetR)
```

`openetR` provides a small, consistent interface to OpenET’s raster API.
It uses [httr2](https://httr2.r-lib.org/) for HTTP requests and returns
decoded JSON responses without requiring a web browser or an Earth
Engine client.

## Authenticate

Create an API key in the [OpenET account
dashboard](https://account.etdata.org/%20settings/api), then set it as
an environment variable. This keeps credentials out of scripts, Git
history, and rendered reports.

``` r

Sys.setenv(OPENET_API_KEY = "your-api-key")
```

The request functions read this variable automatically. For temporary or
programmatic credentials, pass `key` directly instead.

## Retrieve a point time series

OpenET uses WGS84 longitude and latitude coordinates. The following
request retrieves monthly ensemble ET at a point in California. API
requests are not run while building this vignette, so the example
remains reproducible without credentials.

``` r

et <- openet_point_timeseries(
  longitude = -121.36322,
  latitude = 38.87626,
  start = "2020-01-01",
  end = "2020-12-31",
  interval = "monthly",
  model = "ensemble",
  variable = "et",
  reference_et = "gridmet",
  units = "mm"
)
```

Use `interval = "daily"` for daily data. OpenET currently limits daily
point and polygon requests to ten years. Available model, variable, and
reference ET values are documented by
[OpenET](https://openet.gitbook.io/docs/reference/api-reference).

## Inspect collection metadata

Use
[`openet_metadata()`](https://connorb.github.io/openetR/reference/openet_metadata.md)
to inspect the processing metadata for a location and collection before
interpreting a result.

``` r

metadata <- openet_metadata(
  geometry = c(-121.36322, 38.87626),
  model = "ensemble",
  variable = "et"
)
```
