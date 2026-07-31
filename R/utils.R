.timeseries_body <- function(
  start,
  end,
  interval,
  model,
  variable,
  reference_et,
  units,
  version,
  overpass
) {
  start <- .date_string(start, "start")
  end <- .date_string(end, "end")
  if (start > end) {
    cli::cli_abort("{.arg start} must be on or before {.arg end}.")
  }
  .check_collection_args(model, variable, reference_et, version)
  .check_flag(overpass, "overpass")
  list(
    date_range = c(start, end),
    interval = interval,
    overpass = overpass,
    model = tolower(model),
    variable = tolower(variable),
    reference_et = tolower(reference_et),
    version = version,
    units = units,
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
  if (is.data.frame(x)) {
    return(tibble::as_tibble(x))
  }
  if (is.list(x) && length(x) && all(vapply(x, is.list, logical(1)))) {
    return(tibble::as_tibble(x))
  }
  x
}

.date_string <- function(x, name) {
  date <- as.Date(x)
  if (length(date) != 1L || is.na(date)) {
    cli::cli_abort("{.arg {name}} must be a valid date.")
  }
  format(date, "%Y-%m-%d")
}

.check_coordinate <- function(x, name, lower, upper) {
  if (!is.numeric(x) || length(x) != 1L || is.na(x) || x < lower || x > upper) {
    cli::cli_abort("{.arg {name}} must be between {lower} and {upper}.")
  }
}

.check_polygon <- function(geometry) {
  if (
    !is.numeric(geometry) || length(geometry) < 6L || length(geometry) %% 2L
  ) {
    cli::cli_abort(
      "{.arg geometry} must contain at least three longitude/latitude pairs."
    )
  }
  if (anyNA(geometry)) {
    cli::cli_abort("{.arg geometry} cannot contain missing values.")
  }
  longitude <- geometry[seq(1L, length(geometry), by = 2L)]
  latitude <- geometry[seq(2L, length(geometry), by = 2L)]
  if (
    any(longitude < -180 | longitude > 180) ||
      any(latitude < -90 | latitude > 90)
  ) {
    cli::cli_abort("{.arg geometry} contains coordinates outside WGS84 bounds.")
  }
}

.check_collection_args <- function(model, variable, reference_et, version) {
  .check_string(model, "model")
  .check_string(variable, "variable")
  .check_string(reference_et, "reference_et")
  if (
    !is.numeric(version) ||
      length(version) != 1L ||
      is.na(version) ||
      !is.finite(version)
  ) {
    cli::cli_abort("{.arg version} must be a single finite number.")
  }
}

.check_string <- function(x, name) {
  if (!is.character(x) || length(x) != 1L || is.na(x) || !nzchar(trimws(x))) {
    cli::cli_abort("{.arg {name}} must be a single non-empty string.")
  }
}

.check_flag <- function(x, name) {
  if (!is.logical(x) || length(x) != 1L || is.na(x)) {
    cli::cli_abort("{.arg {name}} must be {.code TRUE} or {.code FALSE}.")
  }
}
