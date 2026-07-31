test_that("openet_api_key validates its input", {
  expect_equal(openet_api_key("abc"), "abc")
  expect_snapshot(error = TRUE, openet_api_key(""))
  expect_snapshot(error = TRUE, openet_api_key("   "))
})

test_that("point requests validate coordinates before making a request", {
  expect_snapshot(
    error = TRUE,
    openet_point_timeseries(181, 40, "2020-01-01", "2020-12-31", key = "abc")
  )
})

test_that("polygon requests require longitude latitude pairs", {
  expect_snapshot(
    error = TRUE,
    openet_polygon_timeseries(
      c(-121, 44, -120),
      "2020-01-01",
      "2020-12-31",
      key = "abc"
    )
  )
})

test_that("dates are ordered", {
  expect_snapshot(
    error = TRUE,
    openet_point_timeseries(-121, 44, "2020-12-31", "2020-01-01", key = "abc")
  )
})

test_that("request options are validated before making a request", {
  expect_snapshot(
    error = TRUE,
    openet_point_timeseries(
      -121,
      44,
      "2020-01-01",
      "2020-12-31",
      overpass = "no",
      key = "abc"
    )
  )
  expect_snapshot(
    error = TRUE,
    openet_metadata(c(-121, 44), version = Inf, key = "abc")
  )
})
