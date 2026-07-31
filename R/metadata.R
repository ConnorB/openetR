#' Retrieve OpenET raster metadata
#'
#' Retrieves processing metadata for an OpenET raster collection at a point or
#' polygon. Use this to confirm a collection's processing details before
#' interpreting a time series.
#'
#' @param geometry A longitude/latitude vector. Two values identify a point;
#'   an even-length vector with at least six values identifies a polygon.
#' @param interval One of `"monthly"` or `"daily"`.
#' @param model OpenET model.
#' @param variable OpenET variable.
#' @param reference_et Reference ET source.
#' @param version OpenET image collection version.
#' @param key API key, by default from `OPENET_API_KEY`.
#' @return A decoded response list.
#' @examples
#' \dontrun{
#' openet_metadata(c(-121.36322, 38.87626))
#' }
#' @export
openet_metadata <- function(
  geometry,
  interval = c("monthly", "daily"),
  model = "ensemble",
  variable = "et",
  reference_et = "gridmet",
  version = 2.1,
  key = Sys.getenv("OPENET_API_KEY")
) {
  rlang::check_installed("httr2")
  interval <- match.arg(interval)
  .check_collection_args(model, variable, reference_et, version)
  if (length(geometry) == 2L) {
    .check_coordinate(geometry[[1]], "longitude", -180, 180)
    .check_coordinate(geometry[[2]], "latitude", -90, 90)
  } else {
    .check_polygon(geometry)
  }
  .openet_post(
    "raster/metadata",
    list(
      interval = interval,
      geometry = geometry,
      model = model,
      variable = variable,
      reference_et = reference_et,
      version = version
    ),
    key
  )
}
