#' Retrieve an OpenET polygon time series
#'
#' Requests raster data aggregated over a simple polygon. Supply a flattened
#' longitude/latitude vector, e.g. `c(-121, 44, -121, 45, -120, 45, -120, 44)`.
#' Daily requests are limited to ten years by the OpenET API. See the
#' [polygon workflow article](https://connorb.github.io/openetR/articles/polygon-workflows.html)
#' for guidance on geometry and reducers.
#'
#' @inheritParams openet_point_timeseries
#' @param geometry An even-length numeric vector of longitude/latitude pairs.
#' @param reducer Pixel aggregation method.
#' @return A tibble when OpenET returns row-like JSON; otherwise the decoded
#'   response object.
#' @examples
#' \dontrun{
#' openet_polygon_timeseries(
#'   geometry = c(-121.01, 44.24, -121.01, 44.25, -121.00, 44.25),
#'   start = "2020-01-01", end = "2020-12-31"
#' )
#' }
#' @export
openet_polygon_timeseries <- function(
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
) {
  rlang::check_installed("httr2")
  interval <- match.arg(interval)
  reducer <- match.arg(reducer)
  units <- match.arg(units)
  .check_polygon(geometry)

  body <- .timeseries_body(
    start,
    end,
    interval,
    model,
    variable,
    reference_et,
    units,
    version,
    overpass
  )
  body$geometry <- geometry
  body$reducer <- reducer
  .openet_post("raster/timeseries/polygon", body, key)
}
