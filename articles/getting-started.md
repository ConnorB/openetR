# Get started with openetR

`openetR` provides a compact interface to the [OpenET raster
API](https://openet.gitbook.io/docs/reference/api-reference/raster).
Retrieve evapotranspiration (ET) time series for a point or polygon,
then use metadata to understand the selected raster collection.

Code

``` r

library(openetR)
```

## Authenticate

Create an API key in the [OpenET account
dashboard](https://account.etdata.org/settings/api). Store it in an
environment variable so it stays out of scripts, Git history, and
rendered reports.

Code

``` r

Sys.setenv(OPENET_API_KEY = "your-api-key")
```

All request functions read this variable automatically. For temporary or
programmatic credentials, supply `key` directly instead.

> **Keep keys private**
>
> Do not commit an API key to a repository. Prefer environment variables
> or a secret-management system for deployed work.

## Retrieve a point time series

OpenET uses WGS84 longitude and latitude coordinates. The following
request retrieves monthly ensemble ET at a point in California. It is
shown but not run so this article can build without credentials.

Code

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

Use `interval = "daily"` for daily values. Daily point and polygon
requests are limited to ten years by OpenET. See the API documentation
for supported models, variables, reference ET sources, and quotas.

## Inspect collection metadata

Use
[`openet_metadata()`](https://connorb.github.io/openetR/reference/openet_metadata.md)
to inspect a collection at a location before interpreting a result.

Code

``` r

metadata <- openet_metadata(
  geometry = c(-121.36322, 38.87626),
  model = "ensemble",
  variable = "et"
)
```

For area summaries, continue to the [polygon
workflow](https://connorb.github.io/openetR/articles/polygon-workflows.md).
