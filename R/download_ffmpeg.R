#' @title Download and Set Up 'FFmpeg'
#' @description This function downloads the latest 'FFmpeg' executable and sets it up for the user.
#' It ensures compliance with MIT licensing by not bundling 'FFmpeg' within the package.
#'
#' @return A string containing the path to the downloaded 'FFmpeg' executable.
#'
#' @export

download_ffmpeg <- function() {
  # Store old timeout value and ensure it's restored on exit
  old_timeout <- getOption("timeout")
  on.exit(options(timeout = old_timeout))
  options(timeout = 3000)

  ffmpeg_dir <- file.path(Sys.getenv("USERPROFILE"), "ffmpeg")
  ffmpeg_exe <- file.path(ffmpeg_dir, "ffmpeg.exe")

  # Check if FFmpeg is already installed
  if (file.exists(ffmpeg_exe)) {
    message("FFmpeg is already installed at: ", ffmpeg_exe)
    return(ffmpeg_exe)
  }

  # FFmpeg download link (may change over time)
  ffmpeg_url <- "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
  ffmpeg_zip <- file.path(ffmpeg_dir, "ffmpeg.zip")

  # Ensure the directory exists
  if (!dir.exists(ffmpeg_dir)) {
    dir.create(ffmpeg_dir, recursive = TRUE)
  }

  # Check if the URL is reachable before attempting to download
  url_is_valid <- tryCatch({
    response <- httr::HEAD(ffmpeg_url)
    httr::status_code(response) == 200
  }, error = function(e) FALSE)

  if (!url_is_valid) {
    message("FFmpeg download URL may be outdated or unreachable.")
    message("Please check for the latest version here:")
    message("https://ffmpeg.org/download.html")
    message("https://github.com/BtbN/FFmpeg-Builds/releases")
    return(NULL)
  }

  # Try downloading FFmpeg and handle errors
  tryCatch({
    utils::download.file(ffmpeg_url, destfile = ffmpeg_zip, mode = "wb")
    utils::unzip(ffmpeg_zip, exdir = ffmpeg_dir)

    # Move FFmpeg binary to the correct location
    extracted_folder <- list.dirs(ffmpeg_dir, full.names = TRUE, recursive = FALSE)
    ffmpeg_exe_path <- file.path(extracted_folder, "bin", "ffmpeg.exe")
    file.rename(ffmpeg_exe_path, ffmpeg_exe)

    unlink(ffmpeg_zip)
    unlink(extracted_folder, recursive = TRUE)

    message("FFmpeg installed successfully at: ", ffmpeg_exe)
  }, error = function(e) {
    message("FFmpeg download failed. Please download manually from:")
    message("https://ffmpeg.org/download.html")
    message("https://github.com/BtbN/FFmpeg-Builds/releases")
    message("Download the file: ffmpeg-master-latest-win64-gpl.zip")
    message("Extract it and place 'ffmpeg.exe' in the following directory:")
    message(ffmpeg_dir)
  })

  return(ffmpeg_exe)
}


