#' @title Download and Set Up FFmpeg
#' @description This function downloads the latest FFmpeg executable and sets it up for the user.
#' It ensures compliance with MIT licensing by not bundling FFmpeg within the package.
#' @return A string containing the path to the downloaded FFmpeg executable.
#' @export
download_ffmpeg <- function() {
  options(timeout = 3000)
  
  ffmpeg_url <- "https://github.com/BtbN/FFmpeg-Builds/releases/latest/download/ffmpeg-master-latest-win64-gpl.zip"

  ffmpeg_dir <- file.path(Sys.getenv("USERPROFILE"), "ffmpeg")
  ffmpeg_zip <- file.path(ffmpeg_dir, "ffmpeg.zip")
  
  ffmpeg_exe <- file.path(ffmpeg_dir, "ffmpeg.exe")
  if (file.exists(ffmpeg_exe)) {
    message("FFmpeg is already installed at: ", ffmpeg_exe)
    return(ffmpeg_exe)
  }
  
  if (!dir.exists(ffmpeg_dir)) {
    dir.create(ffmpeg_dir, recursive = TRUE)
  }
  
  message("Downloading FFmpeg (this may take a few minutes)...")
  download.file(ffmpeg_url, destfile = ffmpeg_zip, mode = "wb")
  
  message("Extracting FFmpeg...")
  unzip(ffmpeg_zip, exdir = ffmpeg_dir)
  
  extracted_folder <- list.dirs(ffmpeg_dir, full.names = TRUE, recursive = FALSE)
  ffmpeg_exe_path <- file.path(extracted_folder, "bin", "ffmpeg.exe")
  
  file.rename(ffmpeg_exe_path, ffmpeg_exe)
  
  unlink(ffmpeg_zip)
  unlink(extracted_folder, recursive = TRUE)
  
  message("FFmpeg installed successfully at: ", ffmpeg_exe)
  return(ffmpeg_exe)
}
