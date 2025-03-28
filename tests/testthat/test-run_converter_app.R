test_that("run_converter_app() runs without error", {
  skip_if_not(interactive(), "Skipping in non-interactive mode")

  expect_error(run_converter_app(), NA)
})
