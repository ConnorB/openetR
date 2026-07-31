# Get an OpenET API key

Retrieves an API key from `OPENET_API_KEY`, unless `key` is supplied.
Create a key in the OpenET account dashboard
(\<https://account.etdata.org/ settings/api\>). Keys are sent only in
the request's `Authorization` header.

## Usage

``` r
openet_api_key(key = Sys.getenv("OPENET_API_KEY"))
```

## Arguments

- key:

  An OpenET API key. By default, read from `OPENET_API_KEY`.

## Value

A single API key string.

## Examples

``` r
openet_api_key("your-api-key")
#> [1] "your-api-key"
```
