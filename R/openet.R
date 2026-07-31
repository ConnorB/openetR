#' Get an OpenET API key
#'
#' Retrieves an API key from `OPENET_API_KEY`, unless `key` is supplied.
#' Create a key in the OpenET account dashboard (<https://account.etdata.org/
#' settings/api>). Keys are sent only in the request's `Authorization` header.
#'
#' @param key An OpenET API key. By default, read from `OPENET_API_KEY`.
#' @return A single API key string.
#' @export
openet_api_key <- function(key = Sys.getenv("OPENET_API_KEY")) {
  if (!is.character(key) || length(key) != 1L || is.na(key) || !nzchar(key)) {
    rlang::abort(
      "An OpenET API key is required. Set the OPENET_API_KEY environment variable or supply `key`."
    )
  }
  key
}

#' Retrieve an OpenET point time series
#'
#' Requests raster data summarized at one longitude/latitude point. Daily
#' requests are limited to ten years by the OpenET API.
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
#' @export
openet_point_timeseries <- function(
    longitude, latitude, start, end, interval = c("monthly", "daily"),
    model = "ensemble", variable = "et", reference_et = "gridmet",
    units = c("mm", "in"), version = 2.1, overpass = FALSE,
    key = Sys.getenv("OPENET_API_KEY")) {
  rlang::check_installed("httr2")
  interval <- match.arg(interval)
  units <- match.arg(units)
  .check_coordinate(longitude, "longitude", -180, 180)
  .check_coordinate(latitude, "latitude", -90, 90)

  body <- .timeseries_body(
    start, end, interval, model, variable, reference_et, units, version,
    overpass
  )
  body$geometry <- c(longitude, latitude)
  .openet_post("raster/timeseries/point", body, key)
}

#' Retrieve an OpenET polygon time series
#'
#' Requests raster data aggregated over a simple polygon. Supply a flattened
#' longitude/latitude vector, e.g. `c(-121, 44, -121, 45, -120, 45, -120, 44)`.
#' Daily requests are limited to ten years by the OpenET API.
#'
#' @inheritParams openet_point_timeseries
#' @param geometry An even-length numeric vector of longitude/latitude pairs.
#' @param reducer Pixel aggregation method.
#' @return A tibble when OpenET returns row-like JSON; otherwise the decoded
#'   response object.
#' @export
openet_polygon_timeseries <- function(
    geometry, start, end, interval = c("monthly", "daily"),
    model = "ensemble", variable = "et", reference_et = "gridmet",
    reducer = c("mean", "sum", "min", "max", "median", "mode"),
    units = c("mm", "in"), version = 2.1, overpass = FALSE,
    key = Sys.getenv("OPENET_API_KEY")) {
  rlang::check_installed("httr2")
  interval <- match.arg(interval)
  reducer <- match.arg(reducer)
  units <- match.arg(units)
  .check_polygon(geometry)

  body <- .timeseries_body(
    start, end, interval, model, variable, reference_et, units, version,
    overpass
  )
  body$geometry <- geometry
  body$reducer <- reducer
  .openet_post("raster/timeseries/polygon", body, key)
}

#' Retrieve OpenET raster metadata
#'
#' Retrieves processing metadata for an OpenET raster collection at a point or
#' polygon.
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
#' @export
openet_metadata <- function(
    geometry, interval = c("monthly", "daily"), model = "ensemble",
    variable = "et", reference_et = "gridmet", version = 2.1,
    key = Sys.getenv("OPENET_API_KEY")) {
  rlang::check_installed("httr2")
  interval <- match.arg(interval)
  if (length(geometry) == 2L) {
    .check_coordinate(geometry[[1]], "longitude", -180, 180)
    .check_coordinate(geometry[[2]], "latitude", -90, 90)
  } else {
    .check_polygon(geometry)
  }
  .openet_post(
    "raster/metadata",
    list(
      interval = interval, geometry = geometry, model = model,
      variable = variable, reference_et = reference_et, version = version
    ),
    key
  )
}

.timeseries_body <- function(
    start, end, interval, model, variable, reference_et, units, version,
    overpass) {
  start <- .date_string(start, "start")
  end <- .date_string(end, "end")
  if (start > end) rlang::abort("`start` must be on or before `end`.")
  list(
    date_range = c(start, end), interval = interval, overpass = overpass,
    model = tolower(model), variable = tolower(variable),
    reference_et = tolower(reference_et), version = version, units = units,
    file_format = "json"
  )
}

.openet_post <- function(path, body, key) {
  request <- httr2::request(paste0("https://openet-api.org/", path)) |>
    httr2::req_headers(Authorization = openet_api_key(key)) |>
    httr2::req_body_json(body) |>
    httr2::req_error(is_error = function(resp) httr2::resp_status(resp) >= 400)
  response <- httr2::req_perform(request)
  .as_tibble(httr2::resp_body_json(response, simplifyVector = FALSE))
}

.as_tibble <- function(x) {
  if (is.data.frame(x)) return(tibble::as_tibble(x))
  if (is.list(x) && length(x) && all(vapply(x, is.list, logical(1)))) {
    return(tibble::as_tibble(x))
  }
  x
}

.date_string <- function(x, name) {
  date <- as.Date(x)
  if (length(date) != 1L || is.na(date)) {
    rlang::abort(paste0("`", name, "` must be a valid date."))
  }
  format(date, "%Y-%m-%d")
}

.check_coordinate <- function(x, name, lower, upper) {
  if (!is.numeric(x) || length(x) != 1L || is.na(x) || x < lower || x > upper) {
    rlang::abort(paste0("`", name, "` must be between ", lower, " and ", upper, "."))
  }
}

.check_polygon <- function(geometry) {
  if (!is.numeric(geometry) || length(geometry) < 6L || length(geometry) %% 2L) {
    rlang::abort("`geometry` must contain at least three longitude/latitude pairs.")
  }
  if (anyNA(geometry)) rlang::abort("`geometry` cannot contain missing values.")
  longitude <- geometry[seq(1L, length(geometry), by = 2L)]
  latitude <- geometry[seq(2L, length(geometry), by = 2L)]
  if (any(longitude < -180 | longitude > 180) || any(latitude < -90 | latitude > 90)) {
    rlang::abort("`geometry` contains coordinates outside WGS84 bounds.")
  }
}
