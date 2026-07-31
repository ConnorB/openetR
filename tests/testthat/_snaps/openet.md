# openet_api_key validates its input

    Code
      openet_api_key("")
    Condition
      Error in `openet_api_key()`:
      ! An OpenET API key is required. Set the OPENET_API_KEY environment variable or supply `key`.

# point requests validate coordinates before making a request

    Code
      openet_point_timeseries(181, 40, "2020-01-01", "2020-12-31", key = "abc")
    Condition
      Error in `.check_coordinate()`:
      ! `longitude` must be between -180 and 180.

# polygon requests require longitude latitude pairs

    Code
      openet_polygon_timeseries(c(-121, 44, -120), "2020-01-01", "2020-12-31", key = "abc")
    Condition
      Error in `.check_polygon()`:
      ! `geometry` must contain at least three longitude/latitude pairs.

# dates are ordered

    Code
      openet_point_timeseries(-121, 44, "2020-12-31", "2020-01-01", key = "abc")
    Condition
      Error in `.timeseries_body()`:
      ! `start` must be on or before `end`.

