if (require("rstanarm") && require("brms") && require("httr") && require("testthat")) {
  test_that("hdi", {
    expect_equal(hdi(distribution_normal(1000), ci = .90)$CI_low[1], -1.64, tolerance = 0.02)
    expect_equal(nrow(hdi(distribution_normal(1000), ci = c(.80, .90, .95))), 3, tolerance = 0.01)
    expect_equal(hdi(distribution_normal(1000), ci = 1)$CI_low[1], -3.09, tolerance = 0.02)
    expect_equal(length(capture.output(print(hdi(distribution_normal(1000))))), 6)
    expect_equal(length(capture.output(print(hdi(distribution_normal(1000), ci = c(.80, .90))))), 12)


    expect_warning(hdi(c(2, 3, NA)))
    expect_warning(hdi(c(2, 3)))
    expect_warning(hdi(distribution_normal(1000), ci = 0.0000001))
    expect_warning(hdi(distribution_normal(1000), ci = 950))
    expect_warning(hdi(c(distribution_normal(1000, 0, 1), distribution_normal(1000, 6, 1), distribution_normal(1000, 12, 1)), ci = .10))
  })



  .runThisTest <- Sys.getenv("RunAllbayestestRTests") == "yes"
  if (.runThisTest) {
    if (require("insight")) {
      m <- insight::download_model("stanreg_merMod_5")
      p <- insight::get_parameters(m, effects = "all")

      test_that("ci", {
        expect_equal(
          hdi(m, ci = c(.5, .8), effects = "all")$CI_low,
          hdi(p, ci = c(.5, .8))$CI_low,
          tolerance = 1e-3
        )
      })

      m <- insight::download_model("brms_zi_3")
      p <- insight::get_parameters(m, effects = "all", component = "all")

      test_that("rope", {
        expect_equal(
          hdi(m, ci = c(.5, .8), effects = "all", component = "all")$CI_low,
          hdi(p, ci = c(.5, .8))$CI_low,
          tolerance = 1e-3
        )
      })
    }
  }
}
