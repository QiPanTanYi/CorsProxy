@echo off

:: Set environment variables for cross-compilation
set GOOS=linux
set GOARCH=amd64

:: Create the 'linux' directory if it does not exist
if not exist linux mkdir linux

echo Setting up environment for building on Linux...
echo Compiling the Go program...

:: Build the Go program, outputting an executable named 'CorsProxy' inside the 'linux' directory
go build -o linux/CorsProxy

:: Check if the build was successful
if %errorlevel% neq 0 (
    echo Compilation failed, please check the error messages.
    pause
    exit
)

:: Copy the 'config.ini' to the 'linux' directory
echo Copying 'config.ini' to the 'linux' directory...
copy config.ini linux\config.ini

:: Check if the copy was successful
if %errorlevel% neq 0 (
    echo Copying 'config.ini' failed, please check the error messages.
    pause
    exit
)

echo Compilation complete.
echo The Linux executable 'CorsProxy' and 'config.ini' have been created in the 'linux' directory.

pause
echo Press any key to continue...