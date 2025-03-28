#' @title Trim an Audio File
#' @name trim_audio
#' @description This function trims an audio file based on user-provided start and end times using FFmpeg.
#'
#' @return No return value, called for side effects.
#'
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   trim_audio()
#' }
#' }
#'
#' @export
trim_audio <- function() {
  ffmpeg_path <- download_ffmpeg()
  user_name <- Sys.getenv("USERNAME")
  user_home <- normalizePath(file.path("C:/Users", user_name), winslash = "/")

  if (interactive() && .Platform$GUI == "RStudio") {
    audio_file <- rstudioapi::selectFile(caption = "Select an Audio File",
                                         filter = "Audio Files (*.mp3;*.wav;*.aac;*.flac;*.ogg;*.m4a)",
                                         existing = TRUE)
  } else {
    audio_file <- file.choose()
  }

  if (is.null(audio_file) || audio_file == "") {
    message("Input file must be selected.")
    return()
  }

  message("\nSelected file: ", audio_file)

  message("\nEnter the start time to trim:")
  start_h <- as.numeric(readline("Hours: "))
  start_m <- as.numeric(readline("Minutes: "))
  start_s <- as.numeric(readline("Seconds: "))

  message("\nEnter the end time to trim:")
  end_h <- as.numeric(readline("Hours: "))
  end_m <- as.numeric(readline("Minutes: "))
  end_s <- as.numeric(readline("Seconds: "))

  start_time <- start_h * 3600 + start_m * 60 + start_s
  end_time <- end_h * 3600 + end_m * 60 + end_s

  if (is.na(start_time) || is.na(end_time) || end_time <= start_time) {
    message("Invalid start or end time. Exiting function.")
    return()
  }

  original_extension <- tools::file_ext(audio_file)
  base_filename <- tools::file_path_sans_ext(basename(audio_file))

  message("\nWould you like to keep the original format (", original_extension, ")? press Enter to keep the original")
  message("Or enter a new format (e.g., mp3, wav, aac, flac, ogg, m4a)")
  new_extension <- tolower(readline("New extension: "))

  if (new_extension == "" || new_extension == original_extension) {
    output_extension <- original_extension
  } else {
    output_extension <- new_extension
  }

  output_file <- file.path(dirname(audio_file), paste0("trimmed_", base_filename, ".", output_extension))

  temp_trimmed_file <- file.path(dirname(audio_file), paste0("temp_trimmed_", base_filename, ".", original_extension))
  cmd_trim <- sprintf('"%s" -i "%s" -ss %d -to %d -acodec copy "%s"',
                      ffmpeg_path, audio_file, start_time, end_time, temp_trimmed_file)
  system(cmd_trim, ignore.stderr = TRUE)

  if (output_extension != original_extension) {
    message("\nConverting trimmed file to ", output_extension, " format...")
    cmd_convert <- sprintf('"%s" -i "%s" "%s"', ffmpeg_path, temp_trimmed_file, output_file)
    system(cmd_convert, ignore.stderr = TRUE)
    file.remove(temp_trimmed_file)
  } else {
    file.rename(temp_trimmed_file, output_file)
  }

  message("\nAudio successfully trimmed!")
  message("Saved as: ", output_file, "\n")
}

