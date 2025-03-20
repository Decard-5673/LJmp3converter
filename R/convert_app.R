#' @title Launch the Video to MP3 Converter App
#' @name run_converter_app
#' @description This function converts video files to MP3. It provides a simple interface for selecting an input folder
#' and processing the files, with the converted MP3 files saved in the same input folder.
#'
#' @return No return value, called for side effects.
#'
#' @examples
#' \dontrun{
#' if (interactive()) {
#'   run_converter_app()
#' }
#' }
#'
#' @export

run_converter_app <- function() {
  ffmpeg_path <- download_ffmpeg()
  user_name <- Sys.getenv("USERNAME")
  user_home <- normalizePath(file.path("C:/Users", user_name), winslash = "/")

  # Ask user to select the input folder
  if (interactive() && .Platform$GUI == "RStudio") {
    input_folder <- rstudioapi::selectDirectory()
  } else {
    input_folder <- utils::choose.dir()
  }

  if (is.null(input_folder)) {
    message("Input folder must be selected.")
    return()
  }

  # Set output folder to be the same as the input folder
  output_folder <- input_folder

  # Process files
  media_files <- list.files(input_folder, pattern = "\\.(mp4|mkv|avi|mov|wmv|flv|mpeg|mpg|webm|m4a)$",
                            full.names = TRUE, ignore.case = TRUE)

  if (length(media_files) == 0) {
    message("No media files found in the selected input folder.")
    return()
  }

  if (!fs::dir_exists(output_folder)) {
    fs::dir_create(output_folder, recurse = TRUE)
  }

  for (media in media_files) {
    output_file <- file.path(output_folder, paste0(tools::file_path_sans_ext(basename(media)), ".mp3"))

    tryCatch({
      system2(ffmpeg_path, args = c("-i", shQuote(media), "-q:a", "2", "-map", "a", shQuote(output_file)), wait = TRUE)
      message(paste("Converted:", basename(media)))
    }, error = function(e) {
      message(paste("Error converting:", media))
    })
  }
  message("Conversion complete!")
}

