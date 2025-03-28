# LJmp3converter

## Overview  
**LJmp3converter** is an R package that allows users to **convert video files to 'MP3' audio**, **merge multiple audio files**, and **trim audio files** using 'FFmpeg'.  
It provides an easy-to-use interface for selecting input/output folders and batch processing media files. The package uses the **'RStudio API'** or **'utils'** to handle file and folder selection.

## Installation & Usage  
To install the package from CRAN, run:  

```r
install.packages("LJmp3converter")

# Load the package
library(LJmp3converter)

# Run the video-to-MP3 converter process
run_converter_app()

# Merge multiple audio files into a single MP3
merge_mp3()

# Trim an audio file
trim_audio()
```

## Features  
- **Select input folder or file**: Choose a folder containing video/audio files for converting/merging or select an individual audio file for trimming.
- **Batch convert**: Convert multiple video files to 'MP3' format with one click.
- **Merge audio files**: Combine multiple audio files ('MP3', 'WAV', 'AAC', 'FLAC', 'OGG', 'M4A') into a single 'MP3' file.
- **Trim audio files**: Cut an audio file based on user-defined start and end times and choose output format..
- **Automatic 'FFmpeg' handling**: The package **automatically detects or downloads 'FFmpeg'** if it is not already installed.

## Supported Formats  
LJmp3converter can extract audio, merge, and trim files from various formats, including:  
- **Video:** 'MP4', 'MKV', 'AVI', 'MOV', 'WMV', 'FLV', 'MPEG', 'MPG', 'WEBM', 'M4A'  
- **Audio:** 'MP3', 'WAV', 'AAC', 'FLAC', 'OGG', 'M4A'  

## License  
LJmp3converter is licensed under **GPL-3**.  
'FFmpeg' is **not bundled** with this package; it is dynamically downloaded to ensure the package is lightweight.  
Users are required to adhere to the 'FFmpeg' licensing terms when using this package.

