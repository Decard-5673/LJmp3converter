#' @title Merge Multiple Audio Files into a Single MP3
#' @name merge_mp3
#' @description This function merges multiple audio files (MP3, WAV, AAC, FLAC, OGG, M4A) into a single MP3 file using FFmpeg.
#'
#' @return No return value, called for side effects.
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   merge_mp3()
#' }
#' }
#'
#' @export
merge_mp3 <- function() {
  ffmpeg_path <- download_ffmpeg()
  user_name <- Sys.getenv("USERNAME")
  user_home <- normalizePath(file.path("C:/Users", user_name), winslash = "/")
  
  # Ask user to select the input folder
  if (interactive() && .Platform$GUI == "RStudio") {
    audio_folder <- rstudioapi::selectDirectory()
  } else {
    audio_folder <- utils::choose.dir()
  }
  
  if (is.null(audio_folder)) {
    message("Input folder must be selected.")
    return()
  }
  
  # Set output folder to be the same as the input folder
  output_folder <- audio_folder
  
  audio_files <- list.files(audio_folder, pattern = "\\.(mp3|wav|aac|flac|ogg|m4a)$", full.names = TRUE, ignore.case = TRUE)
  if (length(audio_files) < 2) {
    message("Not enough audio files found in the folder. At least two are required.")
    return()
  }
  
  converted_files <- c()
  
  for (file in audio_files) {
    if (tolower(tools::file_ext(file)) != "mp3") {
      mp3_file <- file.path(audio_folder, paste0(tools::file_path_sans_ext(basename(file)), "_converted.mp3"))
      cmd_convert <- sprintf('"%s" -i "%s" -acodec libmp3lame -q:a 4 "%s"', ffmpeg_path, file, mp3_file)
      system(cmd_convert, ignore.stderr = TRUE)
      converted_files <- c(converted_files, mp3_file)
    }
  }
  
  mp3_files <- c(audio_files[tolower(tools::file_ext(audio_files)) == "mp3"], converted_files)
  if (length(mp3_files) < 2) {
    message("After conversion, there are still not enough MP3 files for merging.")
    return()
  }
  
  file_list_path <- file.path(audio_folder, "file_list.txt")
  writeLines(sprintf("file '%s'", normalizePath(mp3_files, winslash = "/")), file_list_path)
  
  output_path <- file.path(audio_folder, "merged_output.mp3")
  cmd_merge <- sprintf('"%s" -f concat -safe 0 -i "%s" -acodec libmp3lame -q:a 4 "%s"', ffmpeg_path, file_list_path, output_path)
  system(cmd_merge, ignore.stderr = TRUE)
  
  file.remove(file_list_path)
  if (length(converted_files) > 0) {
    file.remove(converted_files)
  }
  
  message("\nAudio files merged successfully!")
  message("Saved as: ", output_path, "\n")
}
