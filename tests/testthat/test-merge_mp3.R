test_that("merge_mp3() runs without error", {
  skip_if_not(interactive(), "Skipping in non-interactive mode")

  expect_error(merge_mp3(), NA)
})
