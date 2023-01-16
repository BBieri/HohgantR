testplot <- HohgantR::indicators_long |>
  dplyr::filter(indicator == "Indicator") |>
  ggslope(year, value, DisaggregationLevel)

test_that("ggslope() works", {
  expect_equal(class(testplot[[1]]), c("tbl_df", "tbl", "data.frame"))
  expect_equal(length(testplot), 9)
})
