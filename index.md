# openetR

`openetR` is a tidy R client for the [OpenET
API](https://openet.gitbook.io/docs/). It supports point and polygon
raster time-series queries plus raster metadata.

## Installation

This package is currently under development. Install it from a local
checkout with `pak::pak(".")` or `devtools::install()`.

## Usage

Create an API key in the [OpenET account
dashboard](https://account.etdata.org/%20settings/api), then store it
outside your source code:

``` r

Sys.setenv(OPENET_API_KEY = "your-api-key")
library(openetR)

openet_point_timeseries(
  longitude = -121.36322,
  latitude = 38.87626,
  start = "2020-01-01",
  end = "2020-12-31",
  interval = "monthly"
)
```

For an area query, provide alternating longitude/latitude coordinates:

``` r

openet_polygon_timeseries(
  geometry = c(-121.00747, 44.24420, -121.00747, 44.24742,
               -121.00295, 44.24742, -121.00295, 44.24422),
  start = "2021-01-01",
  end = "2021-12-31"
)
```

OpenET limits daily point and polygon queries to ten years. Consult the
[OpenET API
documentation](https://openet.gitbook.io/docs/reference/api-reference/raster)
for supported models, variables, and quotas.
