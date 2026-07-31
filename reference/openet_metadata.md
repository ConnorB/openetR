# Retrieve OpenET raster metadata

Retrieves processing metadata for an OpenET raster collection at a point
or polygon. Use this to confirm a collection's processing details before
interpreting a time series.

## Usage

``` r
openet_metadata(
  geometry,
  interval = c("monthly", "daily"),
  model = "ensemble",
  variable = "et",
  reference_et = "gridmet",
  version = 2.1,
  key = Sys.getenv("OPENET_API_KEY")
)
```

## Arguments

- geometry:

  A longitude/latitude vector. Two values identify a point; an
  even-length vector with at least six values identifies a polygon.

- interval:

  One of `"monthly"` or `"daily"`.

- model:

  OpenET model.

- variable:

  OpenET variable.

- reference_et:

  Reference ET source.

- version:

  OpenET image collection version.

- key:

  API key, by default from `OPENET_API_KEY`.

## Value

A decoded response list.

## Examples

``` r
if (FALSE) { # \dontrun{
openet_metadata(c(-121.36322, 38.87626))
} # }
```
