::------------------------------------------------------------------------------
:: NAME
::     vidcat.bat, The Video Concatenator
::
:: USAGE
::     vidcat.bat <input_folder|filelist> [output_file]
::
:: DESCRIPTION
::     Combines all files in a specified folder or textfile into a single MKV
::     file by using ffmpeg's concat feature. All videos must already have the
::     same framerate and dimensions. Videos will be joined in the order
::     displayed by dir /b if a folder is chosen, or in the order listed in the
::     textfile.
::
:: ARGUMENTS
::     input_folder    The folder containing all video files to be combined.
::                     The folder must only contain video files, and all files
::                     must have the same dimensions and framerate.
::     input_file      A text file containing all files to be added. The file
::                     must only contain paths to video files, and all files
::                     must have the same dimensions and framerate.
::     output_file     The name of the output file. By default, the output file
::                     gets put in the same folder as the source data. A
::                     different output folder can be specified by providing a
::                     full path for output_file. Default name is output.mkv.
::
:: REQUIREMENTS
::     ffmpeg (https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z)
::
:: AUTHOR
::     sintrode
::
:: VERSION HISTORY
::     1.0 [2020-10-14] - Initial Version
::------------------------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

:: Constants
set "ffmpeg=%~dp0\ffmpeg.exe"
if not exist %ffmpeg% (
	echo [31mFFMPEG not found.[0m The FFMPEG executable can be downloaded from
	echo https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z
	exit /b
)

:: Input verification
set "outfile=output.mkv"
if not "%~2"=="" set "outfile=%~2"
if "%~1"=="" goto :usage

:: If you're inputting a folder, convert that to a file instead
if not exist "%~1\" (
	if not exist "%~1" (
		goto :usage
	) else (
		set "filelist=%~1"
	)
) else (
	call :from_folder "%~1"
)

:: Main function
:main
type "%filelist%"
echo(
choice /M "This is the order the files will be combined in. Is it correct? [Y/N] " /N
if "%errorlevel%"=="2" exit /b

:: Confirm that all files in filelist exist
for /f "usebackq delims=" %%A in ("%filelist%") do (
	if not exist "%%~A" (
		echo [31mERROR:[0m %%A does not exist. Exiting.
		exit /b
	)
)

:: Build the FFMPEG command string
set "input_list="
for /f "usebackq delims=" %%A in ("%filelist%") do set input_list=!input_list! -i "%%~A"
set "fc_list="
:: Ordinarily you would never need to use set /a to simply set a variable
:: without doing math, but this has the added benefit of trimming the leading whitespace
for /f "tokens=2 delims=:" %%A in ('find /c /v "" "%filelist%"') do set /a "file_count=%%A"
set /a z_index_count=file_count-1
for /L %%A in (0,1,%z_index_count%) do set fc_list=!fc_list![%%A:v:0][%%A:a:0]
set "fc_list=!fc_list!concat=n=%file_count%:v=1:a=1[outv][outa]"

"%ffmpeg%" !input_list! -filter_complex "!fc_list!" -map "[outv]" -map "[outa]" "%outfile%"

exit /b

::------------------------------------------------------------------------------
:: Generates a filelist from the contents of a folder
::
:: Arguments: %1 - The folder that contains the files to be processed
::------------------------------------------------------------------------------
:from_folder
if exist filelist.txt del filelist.txt
for /f "delims=" %%A in ('dir /b "%~1"') do >>filelist.txt echo "%~dpn1\%%A"
set filelist=filelist.txt
exit /b

::------------------------------------------------------------------------------
:: Displays how to use the script
::
:: Arguments: None
:: Returns:   None
::------------------------------------------------------------------------------
:usage
cls
echo [1mNAME[0m
echo     vidcat.bat, The Video Concatenator
echo(
echo [1mUSAGE[0m
echo     vidcat.bat ^<input_folder^|input_file^> [output_file]
echo(
echo [1mDESCRIPTION[0m
echo     Combines all files in a specified folder or textfile into a single MKV
echo     file by using ffmpeg's concat feature. All videos must already have the
echo     same framerate and dimensions. Videos will be joined in the order
echo     displayed by dir /b if a folder is chosen, or in the order listed in the
echo     textfile.
echo(
echo [1mARGUMENTS[0m
echo     input_folder    The folder containing all video files to be combined.
echo                     The folder must only contain video files, and all files
echo                     must have the same dimensions and framerate.
echo     input_file      A text file containing all files to be added. The file
echo                     must only contain paths to video files, and all files
echo                     must have the same dimensions and framerate.
echo     output_file     The name of the output file. By default, the output file
echo                     gets put in the same folder as the source data. A
echo                     different output folder can be specified by providing a
echo                     full path for output_file. Default name is output.mkv.
echo(
echo [1mREQUIREMENTS[0m
echo     ffmpeg (https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-full.7z)
