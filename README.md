# LJmp3converter

## Overview  

**LJmp3converter** is an R package that allows users to **convert video files to 'MP3' audio** using 'FFmpeg'.  
It provides an easy-to-use interface for selecting input/output folders and batch processing media files. The package uses the **'RStudio API'** or **'utils'** to handle file and folder selection.

## Installation & Usage  

To install the package from CRAN, run:  

```r
install.packages("LJmp3converter")

# Load the package
library(LJmp3converter)

# Run the video-to-MP3 converter process
run_converter_app()
```

## Features  
- **Select input folder**: Choose a folder containing video files. All converted MP3 files will be saved in the same folder.
- **Batch convert**: Convert multiple video files to MP3 format with one click.

The package **automatically downloads 'FFmpeg'** if it is not already installed and ensures that the required R packages are available.

## Supported Formats  
LJmp3converter can extract audio from **various video formats**, including:  
- 'MP4', 'MKV', 'AVI', 'MOV', 'WMV', 'FLV', 'MPEG', 'MPG', 'WEBM', 'M4A'  

## License  
LJmp3converter is licensed under **GPL-3**.  
'FFmpeg' is **not bundled** with this package; it is dynamically downloaded to ensure the package is lightweight.  
Users are required to adhere to the 'FFmpeg' licensing terms when using this package.