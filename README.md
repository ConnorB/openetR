# openetR

`openetR` is a small R client for the
[OpenET raster API](https://openet.gitbook.io/docs/reference/api-reference/raster).
Use it to retrieve evapotranspiration time series for a point or polygon and
to inspect the metadata for an OpenET raster collection. Responses that contain
rows are returned as tibbles, ready for analysis in R.

## Installation

Install the development version from GitHub:

```r
pak::pak("ConnorB/openetR")
```

To install from a local checkout, use `pak::pak(".")`.

## Quick start

Create an API key in the [OpenET account dashboard](https://account.etdata.org/
settings/api), then store it outside your source code:

```r
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

The package reads `OPENET_API_KEY` for every request. You can instead supply a
`key` argument when credentials are managed outside the environment. Never
commit an API key to a script or repository.

## Choose a workflow

| Task | Function | Geometry |
| --- | --- | --- |
| Retrieve ET at one location | `openet_point_timeseries()` | `longitude`, `latitude` |
| Summarize ET over an area | `openet_polygon_timeseries()` | Alternating longitude/latitude pairs |
| Inspect a collection | `openet_metadata()` | A point or polygon |

For an area query, provide alternating longitude/latitude coordinates:

```r
openet_polygon_timeseries(
  geometry = c(-121.00747, 44.24420, -121.00747, 44.24742,
               -121.00295, 44.24742, -121.00295, 44.24422),
  start = "2021-01-01",
  end = "2021-12-31"
)
```

Coordinates must use WGS84 (EPSG:4326). `openetR` validates coordinate bounds,
date order, and request options locally before making an API request.

## Learn more

The package site contains a [getting-started guide](https://connorb.github.io/openetR/articles/getting-started.html)
and a [polygon workflow](https://connorb.github.io/openetR/articles/polygon-workflows.html).
OpenET limits daily point and polygon requests to ten years. Consult the
[OpenET API documentation](https://openet.gitbook.io/docs/reference/api-reference/raster)
for supported models, variables, quota limits, and collection details.

## Contributing

Bug reports and feature requests are welcome at
[GitHub Issues](https://github.com/ConnorB/openetR/issues). To work on a local
checkout, run `devtools::test()` before submitting a change.
