test_that("density_at", {
  testthat::expect_equal(density_at(distribution_normal(1000), 0), 0.389, tolerance = 0.01)
  testthat::expect_equal(density_at(distribution_normal(1000), c(0, 1))[1], 0.389, tolerance = 0.01)
})
