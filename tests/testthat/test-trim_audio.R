test_that("trim_audio() runs without error", {
  skip_if_not(interactive(), "Skipping in non-interactive mode")
  
  expect_error(trim_audio(), NA)
})