#' @export
run_converter_app <- function() {
  required_packages <- c("shiny", "fs", "tools", "shinyFiles")
  new_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]
  if (length(new_packages) > 0) {
    install.packages(new_packages)
  }
  lapply(required_packages, library, character.only = TRUE)


  ffmpeg_path <- download_ffmpeg()
  user_name <- Sys.getenv("USERNAME")
  user_home <- normalizePath(file.path("C:/Users", user_name), winslash = "/")

  ui <- fluidPage(
    titlePanel("Video to MP3 Converter"),
    sidebarLayout(
      sidebarPanel(
        shinyDirButton("input_folder", "Select Input Folder", "Choose input folder"),
        shinyDirButton("output_folder", "Select Output Folder", "Choose output folder"),
        actionButton("convert", "Start Conversion")
      ),
      mainPanel(
        verbatimTextOutput("status")
      )
    )
  )

  server <- function(input, output, session) {
    # 🌍 Start from the current working directory
    roots <- c("User Home" = user_home, "C:" = "C:/", "D:" = "D:/", "E:" = "E:/")
    shinyFiles::shinyDirChoose(input, "input_folder", roots = roots, session = session)
    shinyFiles::shinyDirChoose(input, "output_folder", roots = roots, session = session)

    input_folder_path <- reactiveVal(user_home)
    output_folder_path <- reactiveVal(user_home)

    # 🔄 Handle input folder selection
    observeEvent(input$input_folder, {
      parsed_path <- tryCatch({
        shinyFiles::parseDirPath(roots, input$input_folder)
      }, error = function(e) {
        message("Error parsing input folder: ", e$message)
        return(NULL)
      })

      # 🔍 Debugging: Print the received input folder path
      print("Received input folder path:")
      print(parsed_path)

      # 🔥 FIX: Ensure parsed_path is valid before checking dir.exists()
      if (!is.null(parsed_path) && length(parsed_path) > 0 && nzchar(parsed_path[1])) {
        if (dir.exists(parsed_path)) {
          input_folder_path(parsed_path)
          output$status <- renderText(paste("Selected input folder:", parsed_path))
        } else {
          output$status <- renderText("⚠ Error: Selected input folder does not exist.")
        }
      } else {
        output$status <- renderText("⚠ Error: Invalid folder selection. Please try again.")
      }
    })

    # 🔄 Handle output folder selection
    observeEvent(input$output_folder, {
      parsed_path <- tryCatch({
        shinyFiles::parseDirPath(roots, input$output_folder)
      }, error = function(e) {
        message("Error parsing output folder: ", e$message)
        return(NULL)
      })

      # 🔍 Debugging: Print the received output folder path
      print("Received output folder path:")
      print(parsed_path)

      if (!is.null(parsed_path) && length(parsed_path) > 0 && nzchar(parsed_path[1])) {
        if (dir.exists(parsed_path)) {
          output_folder_path(parsed_path)
          output$status <- renderText(paste("Selected output folder:", parsed_path))
        } else {
          output$status <- renderText("⚠ Error: Selected output folder does not exist.")
        }
      } else {
        output$status <- renderText("⚠ Error: Invalid output folder selection. Please try again.")
      }
    })

    # 🔄 Handle conversion
    observeEvent(input$convert, {
      req(input_folder_path(), output_folder_path())

      media_files <- list.files(input_folder_path(), pattern = "\\.(mp4|mkv|avi|mov|wmv|flv|mpeg|mpg|webm|m4a)$",
                                full.names = TRUE, ignore.case = TRUE)

      if (length(media_files) == 0) {
        output$status <- renderText("⚠ No media files found in the selected input folder.")
        return()
      }

      if (!dir.exists(output_folder_path())) {
        dir.create(output_folder_path(), recursive = TRUE)
      }

      for (media in media_files) {
        output_file <- file.path(output_folder_path(), paste0(tools::file_path_sans_ext(basename(media)), ".mp3"))

        tryCatch({
          system2(ffmpeg_path, args = c("-i", shQuote(media), "-q:a", "2", "-map", "a", shQuote(output_file)), wait = TRUE)
        }, error = function(e) {
          output$status <- renderText(paste("⚠ Error converting:", media))
        })
      }

      output$status <- renderText("✅ Conversion complete!")
    })
  }

  shinyApp(ui = ui, server = server)
}
