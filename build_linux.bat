@echo off

:: Set environment variables for cross-compilation
set GOOS=linux
set GOARCH=amd64

:: Create the 'linux-proxy' directory if it does not exist
if not exist linux-proxy mkdir linux-proxy

echo Setting up environment for building on Linux...
echo Compiling the Go program...

:: Build the Go program, outputting an executable named 'CorsProxy' inside the 'linux-proxy' directory
go build -o linux-proxy/CorsProxy

:: Check if the build was successful
if %errorlevel% neq 0 (
    echo Compilation failed, please check the error messages.
    pause
    exit
)

:: Copy the 'config.ini' to the 'linux-proxy' directory
echo Copying 'config.ini' to the 'linux-proxy' directory...
copy config.ini linux-proxy\config.ini

:: Check if the copy was successful
if %errorlevel% neq 0 (
    echo Copying 'config.ini' failed, please check the error messages.
    pause
    exit
)

echo Compilation complete.
echo The Linux executable 'CorsProxy' and 'config.ini' have been created in the 'linux-proxy' directory.

pause
echo Press any key to continue...