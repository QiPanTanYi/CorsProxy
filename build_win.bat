@echo off

:: Set environment variables for cross-compilation
set GOOS=windows
set GOARCH=amd64

:: Create the 'win-proxy' directory if it does not exist
if not exist win-proxy mkdir win-proxy

echo Setting up environment for building on Windows...
echo Compiling the Go program...

:: Build the Go program, outputting an executable named 'main.exe' inside the 'win-proxy' directory
go build -o win-proxy\CorsProxy.exe main.go

:: Check if the build was successful
if %errorlevel% neq 0 (
    echo Compilation failed, please check the error messages.
    pause
    exit
)

:: Copy the 'config.ini' to the 'win-proxy' directory
echo Copying 'config.ini' to the 'win-proxy' directory...
copy config.ini win-proxy\config.ini

:: Check if the copy was successful
if %errorlevel% neq 0 (
    echo Copying 'config.ini' failed, please check the error messages.
    pause
    exit
)

echo Compilation complete.
echo The Windows executable 'main.exe' and 'config.ini' have been created in the 'win-proxy' directory.

pause
echo Press any key to continue...