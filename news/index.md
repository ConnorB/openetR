# Changelog

## openetR 0.0.0.9000

- Documentation now includes native Quarto articles, a clearer quick
  start, and links between package functions and common OpenET
  workflows.

- Errors now use ‘cli’ formatting with clearer argument names and
  actionable guidance.

- [`openet_metadata()`](https://connorb.github.io/openetR/reference/openet_metadata.md),
  [`openet_point_timeseries()`](https://connorb.github.io/openetR/reference/openet_point_timeseries.md),
  and
  [`openet_polygon_timeseries()`](https://connorb.github.io/openetR/reference/openet_polygon_timeseries.md)
  now validate collection options locally before submitting a request.

- [`openet_api_key()`](https://connorb.github.io/openetR/reference/openet_api_key.md),
  [`openet_metadata()`](https://connorb.github.io/openetR/reference/openet_metadata.md),
  [`openet_point_timeseries()`](https://connorb.github.io/openetR/reference/openet_point_timeseries.md),
  and
  [`openet_polygon_timeseries()`](https://connorb.github.io/openetR/reference/openet_polygon_timeseries.md)
  provide authenticated access to core OpenET raster endpoints.
