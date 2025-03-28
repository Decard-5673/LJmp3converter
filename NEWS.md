# LJmp3converter Package Updates

## Version 1.0.7
### Changes:
- Removed the incorrectly formatted "The package includes" section from the DESCRIPTION file to comply with CRAN formatting requirements.

---

## Version 1.0.6
### New Features:
- Added `merge_mp3()` function to merge multiple audio files into a single 'MP3'.
  - Uses `ffmpeg` for audio merging.
  - Supports interactive folder selection via `rstudioapi` and `utils`.
  - Converts non-MP3 audio files to MP3 before merging.
- Added `trim_audio()` function to trim audio files based on user-defined start and end times.
  - Uses `ffmpeg` for precise audio trimming.
  - Supports interactive file selection via `rstudioapi` and `utils`.
  - Allows input in hours, minutes, and seconds for accurate trimming.
  - Users can choose output format when trimming audio.

### Improvements:
- Updated documentation:
  - Added `@return` details for `merge_mp3()` and `trim_audio()`.
  - Updated `NAMESPACE` to export `merge_mp3()` and `trim_audio()`.
- Enhanced error handling and user messages.
- Refactored code for better consistency within the package.

---

## Version 1.0.5
### Changes:
- Removed dependency on `shiny` and replaced it with `rstudioapi` and `utils` for file selection.
- Ensured compliance with CRAN policies:
  - Added required web service URL in `DESCRIPTION`.
  - Documented return values for exported functions.
  - Replaced `installed.packages()` with `requireNamespace()`.
  - Removed package installation within functions.
  - Ensured proper handling of options using `on.exit()`.
- Updated `README.md`, `cran-comments.md`, and other documentation files.

---

## Version 1.0.4 and Earlier
Refer to previous `NEWS.md` versions for historical changes.
