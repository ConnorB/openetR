# Work with OpenET polygons

Use
[`openet_polygon_timeseries()`](https://connorb.github.io/openetR/reference/openet_polygon_timeseries.md)
to summarize an OpenET raster collection for a simple polygon.
Coordinates must use WGS84 (EPSG:4326) and are supplied as alternating
longitude/latitude values.

Code

``` r

library(openetR)
```

## Define a polygon

This rectangle does not repeat its first coordinate because OpenET
accepts a simple sequence of vertex pairs. Use a closed ring only if
your source data requires it; `openetR` passes coordinates to OpenET
unchanged.

Code

``` r

field <- c(
  -121.00747, 44.24420,
  -121.00747, 44.24742,
  -121.00295, 44.24742,
  -121.00295, 44.24422
)
```

## Request an aggregated time series

Choose the pixel aggregation with `reducer`. `"mean"` is appropriate for
an average depth across an area. Use `"sum"` only when its units and
interpretation are appropriate for the selected variable.

Code

``` r

field_et <- openet_polygon_timeseries(
  geometry = field,
  start = "2021-01-01",
  end = "2021-12-31",
  interval = "monthly",
  model = "ensemble",
  variable = "et",
  reference_et = "gridmet",
  reducer = "mean",
  units = "mm"
)
```

## Prevent common input errors

`openetR` checks coordinate bounds, requires an even number of
coordinate values, and verifies that dates are ordered before making a
request.

> **Start with metadata**
>
> Call `openet_metadata(field)` before a long analysis to confirm the
> selected model, variable, reference ET source, and collection version.

For larger collections of fields, use OpenET’s multipolygon or export
endpoints directly until a high-level client is added to `openetR`.
