# NAME
vidcat, the Video Concatenator

# USAGE
vidcat.bat <input_folder|filelist> [output_file]

# DESCRIPTION
Combines all files in a specified folder or textfile into a single MKV file by using ffmpeg's concat feature. All videos must already have the same framerate and dimensions. Videos will be joined in the order displayed by dir /b if a folder is chosen, or in the order listed in the textfile.

# ARGUMENTS
    input_folder    The folder containing all video files to be combined.
                    The folder must only contain video files, and all files
                    must have the same dimensions and framerate.
    input_file      A text file containing all files to be added. The file
                    must only contain paths to video files, and all files
                    must have the same dimensions and framerate.
    output_file     The name of the output file. By default, the output file
                    gets put in the same folder as the source data. A
                    different output folder can be specified by providing a
                    full path for output_file. Default name is output.mkv.

# REQUIREMENTS
ffmpeg (https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z)

# AUTHOR
sintrode
