#' Retrieve an OpenET point time series
#'
#' Requests raster data summarized at one longitude/latitude point. Daily
#' requests are limited to ten years by the OpenET API. See the
#' [getting-started article](https://connorb.github.io/openetR/articles/getting-started.html)
#' for a complete example.
#'
#' @param longitude,latitude Numeric coordinates in WGS84 (EPSG:4326).
#' @param start,end Inclusive dates, coercible to `Date`.
#' @param interval One of `"monthly"` or `"daily"`.
#' @param model OpenET model, such as `"ensemble"` or `"ssebop"`.
#' @param variable OpenET variable, such as `"et"`, `"eto"`, or `"ndvi"`.
#' @param reference_et Reference ET source.
#' @param units Output depth units.
#' @param version OpenET image collection version.
#' @param overpass Return only satellite-observed scenes for daily requests?
#' @param key API key, by default from `OPENET_API_KEY`.
#' @return A tibble when OpenET returns row-like JSON; otherwise the decoded
#'   response object.
#' @examples
#' \dontrun{
#' openet_point_timeseries(
#'   longitude = -121.36322, latitude = 38.87626,
#'   start = "2020-01-01", end = "2020-12-31"
#' )
#' }
#' @export
openet_point_timeseries <- function(
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
) {
  rlang::check_installed("httr2")
  interval <- match.arg(interval)
  units <- match.arg(units)
  .check_coordinate(longitude, "longitude", -180, 180)
  .check_coordinate(latitude, "latitude", -90, 90)

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
  body$geometry <- c(longitude, latitude)
  .openet_post("raster/timeseries/point", body, key)
}
