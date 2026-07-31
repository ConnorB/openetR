#' Get an OpenET API key
#'
#' Retrieves an API key from `OPENET_API_KEY`, unless `key` is supplied.
#' Create a key in the OpenET account dashboard (<https://account.etdata.org/
#' settings/api>). Keys are sent only in the request's `Authorization` header.
#'
#' @param key An OpenET API key. By default, read from `OPENET_API_KEY`.
#' @return A single API key string.
#' @examples
#' openet_api_key("your-api-key")
#' @export
openet_api_key <- function(key = Sys.getenv("OPENET_API_KEY")) {
  if (
    !is.character(key) ||
      length(key) != 1L ||
      is.na(key) ||
      !nzchar(trimws(key))
  ) {
    cli::cli_abort(c(
      "An OpenET API key is required.",
      "i" = "Set {.var OPENET_API_KEY} or supply {.arg key}."
    ))
  }
  key
}
