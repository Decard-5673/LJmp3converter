test_that("download_ffmpeg() returns a valid path", {
  if (Sys.getenv("NOT_CRAN") != "true") {
    skip("Skipping FFmpeg download test on CRAN")
  }

  ffmpeg_path <- download_ffmpeg()

  if (!file.exists(ffmpeg_path)) {
    skip("FFmpeg not found. Skipping test.")
  }

  expect_true(file.exists(ffmpeg_path))
})
