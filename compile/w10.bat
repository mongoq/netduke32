@echo off

rem ---
rem THIS FILE IS WORK IN PROGRESS. DEMONSTRATES THE POWER OF MSYS2 IN ANY CASE !!!
rem ---

echo.
echo ----------------------
echo - Netduke32 Compiler -
echo -  MongoQ V0.1 '25   -
echo ----------------------

rem Netduke32 Sources
set "netduke-url=https://voidpoint.io/StrikerTheHedgefox/eduke32-csrefactor/-/archive/NetDuke32_v1.2.1/eduke32-csrefactor-NetDuke32_v1.2.1.tar.gz"
set "netduke-sha256-sum=cd5afc07a2a405b73f9720e158232a9e7af310448cffad8034742dfbeb8f080f"

echo. 
echo Downloading MSYS2 ...
echo. 
rem curl -L -o msys2-installer.exe https://github.com/msys2/msys2-installer/releases/latest/download/msys2-x86_64-latest.exe

echo.
echo Installing MSYS2 ...
rem msys2-installer.exe in --confirm-command --accept-messages --root C:/msys64

echo.
echo Updating MSYS2 ...
echo.
C:\msys64\usr\bin\bash.exe -lc "pacman -Syu --noconfirm"
 
echo.
echo Installing packages for Netduke32 ...
echo.
rem C:\msys64\msys2_shell.cmd -defterm -no-start -mintty -c "pacman -S --needed --noconfirm mingw-w64-x86_64-gcc mingw-w64-x86_64-make mingw-w64-x86_64-cmake mingw-w64-x86_64-sdl2 mingw-w64-x86_64-sdl2_mixer mingw-w64-x86_64-sdl2_image"
rem C:\msys64\msys2_shell.cmd -defterm -no-start -mintty -c "pacman -S --needed --noconfirm mingw-w64-{i686,x86_64}-toolchain make nasm yasm"
C:\msys64\usr\bin\bash.exe -lc "pacman -S --needed --noconfirm mingw-w64-i686-toolchain mingw-w64-x86_64-toolchain make nasm yasm"

echo.
echo Getting Netduke32 sourcecode ...

REM Extract filename and directory from netduke-url
for %%F in ("%netduke-url%") do set "netduke-file=%%~nxF"
set "netduke-dir=%netduke-file:.tar.gz=%"

mkdir c:\temp\
cd /d c:\temp\

REM ----------------------------------------------------

setlocal enabledelayedexpansion

for %%a in ("%netduke-url%") do set "filename=%%~nxa"

if exist "%filename%" (
    for /f "tokens=1" %%b in ('certutil -hashfile "%filename%" SHA256 ^| findstr /v /c:"hash" ^| findstr /v /c:"CertUtil"') do set "hash=%%b"
    set "hash=!hash: =!"
    if /i "!hash!" neq "!netduke-sha256-sum!" (
        echo SHA256SUM of tar.gz doesn't match. Redownloading sourcecode.
        curl -L -o "!filename!" "!netduke-url!"
        if errorlevel 1 exit /b 1
    ) else (
        echo File "%filename%" is already downloaded and the hash matches.
    )
) else (
    echo Downloading sourcecode ...
    curl -L -o "!filename!" "!netduke-url!"
    if errorlevel 1 exit /b 1
)

echo Calculated Hash: !hash! TODO ...
echo Expected Hash: !netduke-sha256-sum!

endlocal

pause 

for %%a in ("%netduke-url%") do set "filename=%%~nxa"
if exist "%filename%" (
    for /f "tokens=1" %%b in ('certutil -hashfile "%filename%" SHA256 ^| findstr /v /c:"hash" ^| findstr /v /c:"CertUtil"') do set "hash=%%b"
    if /i not "%hash%"=="%netduke-sha256-sum%" curl -L -o "%filename%" "%netduke-url%"
    echo.
    echo File %netduke-file% was already downloaded.
    echo SHA256SUM meets the required value of %netduke-sha256-sum%.
) else (
    echo.
    echo Downloading %netduke-file% ...
    curl -L -o "%filename%" "%netduke-url%"
)
echo Berechneter Hash: %hash%
echo Erwarteter Hash: %netduke-sha256-sum%
echo.
rem C:\msys64\usr\bin\bash.exe -lc "mkdir -p /c/temp && cd /c/temp && wget %netduke-url% && tar -xzfv %netduke-file%"

echo.
echo Patching sourcecode ...
echo sed ... TODO

echo.
echo Compiling Netduke32 executable ...
echo.

REM C:\msys64\msys2_shell.cmd -defterm -no-start -mintty -c "mkdir -p /c/temp && cd /c/temp && wget %netduke-url% && tar -xzf %netduke-file% && cd %netduke-dir% && sleep 10 && make -j$(nproc)

C:\msys64\usr\bin\bash.exe -lc "cd /c/temp/%netduke-dir% && export PATH=/mingw64/bin:$PATH && make netduke32 -j$(nproc)"

echo.
echo Now you should have a 'netduke.exe'. Have fun !!!
echo.

echo --------------------
pause



set "default=N"
set /p "input=Do you want to delete MSYS2? [y/N]: "

REM Set default to N if no input is provided
if "%input%"=="" set "input=%default%"

if /i "%input%"=="Y" (
    echo You selected YES.
    echo Deleting MSYS2 ...
    REM C:\msys64\uninstall.exe pr --confirm-command
) else (
    echo You selected No or other key - no action is taken.
    echo That's all folks !!!
)

