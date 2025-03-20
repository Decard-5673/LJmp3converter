# LJmp3converter 1.0.5

## Changes in this version:
- Fully removed `shiny` dependency and replaced it with `rstudioapi` and `utils` for file selection.
- Added required web service URL (`<https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip>`) in `DESCRIPTION`.
- Fixed documentation issues:
  - Added `@return` to exported functions (`run_converter_app.R`, `download_ffmpeg.R`).
  - Ensured compliance with CRAN policies for `.Rd` files.
- Performance improvements:
  - Replaced `installed.packages()` with `requireNamespace()`.
  - Removed `install.packages()` calls inside functions.
- Ensured `on.exit()` restores options after changes (`options(timeout = 3000)`).
- Updated README to clarify 'FFmpeg' download process.
- Fixed CRAN test failure by skipping `download_ffmpeg()` test on CRAN.  
- Improved test handling for non-interactive environments.  
- Ensured package compliance with CRAN’s testing policies.
