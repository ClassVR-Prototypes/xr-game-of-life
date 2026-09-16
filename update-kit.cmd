@echo off
setlocal
title Update the prototyping kit
cd /d "%~dp0"

echo.
echo  Updating the ClassVR Prototyping Kit in this project...
echo.

rem --- find git: on the PATH, or the copy bundled with GitHub Desktop ---
set "GIT="
where git >nul 2>nul && set "GIT=git"
if not defined GIT (
  for /d %%D in ("%LOCALAPPDATA%\GitHubDesktop\app-*") do (
    if exist "%%D\resources\app\git\cmd\git.exe" set "GIT=%%D\resources\app\git\cmd\git.exe"
  )
)
if not defined GIT (
  echo  Couldn't find Git on this computer. Install GitHub Desktop ^(desktop.github.com^)
  echo  and try again, or ask Claude to "update the kit" instead.
  goto :end
)

rem --- make sure the kit folder exists, then move it to the latest version ---
"%GIT%" submodule update --init --recursive kit >nul 2>nul
for /f "usebackq delims=" %%B in (`"%GIT%" -C kit rev-parse --short HEAD 2^>nul`) do set "BEFORE=%%B"
"%GIT%" submodule update --remote --merge kit
if errorlevel 1 (
  echo.
  echo  The update didn't complete. Check your internet connection and try again,
  echo  or ask Claude to "update the kit".
  goto :end
)
for /f "usebackq delims=" %%A in (`"%GIT%" -C kit rev-parse --short HEAD 2^>nul`) do set "AFTER=%%A"

if "%BEFORE%"=="%AFTER%" (
  echo  The kit is already up to date. Nothing to do.
  goto :end
)

rem --- record the new version in this project ---
for /f "usebackq delims=" %%V in (`powershell -NoProfile -Command "(Get-Content 'kit/plugins/classvr-prototyping-kit/.claude-plugin/plugin.json' | ConvertFrom-Json).version"`) do set "VERSION=%%V"
"%GIT%" add kit
"%GIT%" commit -q -m "Update the prototyping kit to %VERSION%"
echo  Kit updated to version %VERSION% and saved.

rem --- try to send it to GitHub; fall back to GitHub Desktop ---
"%GIT%" push >nul 2>nul
if errorlevel 1 (
  echo.
  echo  One more step: open GitHub Desktop and press "Push origin" to send the update.
) else (
  echo  Sent to GitHub. Done.
)

:end
echo.
pause
