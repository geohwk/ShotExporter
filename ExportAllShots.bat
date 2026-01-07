@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM ShotExporter - Export all ImageSequences\Shot*_sequence to MP4
REM Requires: ffmpeg in a folder relative to this script:
REM   ShotExporter\
REM     ExportAllShots.bat
REM     ffmpeg\bin\ffmpeg.exe
REM ============================================================

REM ---- Project root: pass as first arg, otherwise use current dir
set "ROOT=%~1"
if "%ROOT%"=="" set "ROOT=%CD%"

REM ---- Script-relative FFmpeg
set "SCRIPT_DIR=%~dp0"
set "FFMPEG=%SCRIPT_DIR%ffmpeg\bin\ffmpeg.exe"

REM ---- Input / output folders (relative to project root)
set "SEQROOT=%ROOT%\ImageSequences"
set "OUTDIR=%ROOT%\FOR-DAVINCI\videos"

REM ---- Encode settings (tweak these)
set "FPS=15"

REM SCALE_WIDTH:
REM   1920  -> true 1080p width (height auto)
REM   2560/3200/3744 -> bigger frames (better detail, bigger files)
REM NOTE: If you ever switch back to OpenH264, keep <= ~3744 wide for 3:2 sources.
set "SCALE_WIDTH=1920"

REM Quality preset (libx264 CRF mode)
REM   18 = very high quality
REM   20 = great balance
REM   22 = smaller
set "CRF=15"
set "PRESET=slow"

REM Output container
set "EXT=mp4"

echo Root:   "%ROOT%"
echo In:     "%SEQROOT%"
echo Out:    "%OUTDIR%"
echo FFMPEG: "%FFMPEG%"
echo.

if not exist "%FFMPEG%" (
  echo ERROR: ffmpeg not found at "%FFMPEG%"
  echo        Expected: "%SCRIPT_DIR%ffmpeg\bin\ffmpeg.exe"
  exit /b 1
)

if not exist "%SEQROOT%" (
  echo ERROR: Could not find "%SEQROOT%"
  exit /b 1
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%" >nul 2>&1

REM ---- Optional: verify libx264 exists (warn if not)
"%FFMPEG%" -hide_banner -encoders 2>nul | findstr /i "libx264" >nul
if errorlevel 1 (
  echo WARNING: libx264 encoder not found in this ffmpeg build.
  echo          This script is configured for libx264.
  echo          Download a GPL build that includes x264, or change -c:v.
  echo.
)

REM ---- Process each shot folder via subroutine (avoids cmd block parsing issues)
for /d %%D in ("%SEQROOT%\Shot*_sequence") do (
  call :ProcessShot "%%~fD" "%%~nxD"
)

echo ==================================================
echo All done.
endlocal
exit /b 0


:ProcessShot
setlocal EnableDelayedExpansion
set "SHOTDIR=%~1"
set "FOLDER=%~2"

REM Folder name like Shot10_sequence -> Shot10
set "SHOTNAME=!FOLDER:_sequence=!"
set "PREFIX=!SHOTNAME!_"

set "FIRSTFRAME=!SHOTDIR!\!PREFIX!0001.jpg"
set "OUTFILE=%OUTDIR%\!SHOTNAME!.%EXT%"

echo ==================================================
echo Processing: !SHOTNAME!
echo Folder:     "!SHOTDIR!"
echo Output:     "!OUTFILE!"

REM Sanity check: first frame exists
if not exist "!FIRSTFRAME!" (
  echo WARNING: Missing first frame:
  echo          "!FIRSTFRAME!"
  echo          Skipping this shot.
  echo.
  endlocal & exit /b 0
)

REM Encode
"%FFMPEG%" ^
  -hide_banner ^
  -y ^
  -framerate %FPS% ^
  -start_number 1 ^
  -i "!SHOTDIR!\!PREFIX!%%04d.jpg" ^
  -vf "scale=%SCALE_WIDTH%:-2" ^
  -c:v libx264 ^
  -pix_fmt yuv420p ^
  -crf %CRF% ^
  -preset %PRESET% ^
  -movflags +faststart ^
  "!OUTFILE!"

if errorlevel 1 (
  echo ERROR: Failed encoding !SHOTNAME!
) else (
  echo DONE:  !SHOTNAME!
)
echo.

endlocal
exit /b 0
