@echo off

cd python38
set PYVER=3.8
set PYVERSION=3.8.10
set PYHOME=%~dp0python38
echo CurrentDir: %PYHOME%

:: HKCU\Software\Python\PythonCore\
reg add "HKCU\Software\Python\PythonCore\%PYVER%" /f
reg delete "HKCU\Software\Python\PythonCore\%PYVER%" /ve /f
reg add "HKCU\Software\Python\PythonCore\%PYVER%" /v Version /t REG_SZ /d "%PYVERSION%" /f
reg add "HKCU\Software\Python\PythonCore\%PYVER%" /v SysVersion /t REG_SZ /d "%PYVER%" /f
reg add "HKCU\Software\Python\PythonCore\%PYVER%" /v SysArchitecture /t REG_SZ /d "64bit" /f
reg add "HKCU\Software\Python\PythonCore\%PYVER%" /v DisplayName /t REG_SZ /d "Python %PYVER% (64-bit)" /f
reg add "HKCU\Software\Python\PythonCore\%PYVER%" /v SupportUrl /t REG_SZ /d "https://www.python.org/" /f

:: Idle
reg add "HKCU\Software\Python\PythonCore\%PYVER%\IdleShortcuts" /ve /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Python\PythonCore\%PYVER%\Idle" /ve /t REG_SZ /d "%PYHOME%\Lib\idlelib\idle.pyw" /f

:: InstallPath
reg add "HKCU\Software\Python\PythonCore\%PYVER%\InstallPath" /ve /t REG_SZ /d "%PYHOME%\\" /f
reg add "HKCU\Software\Python\PythonCore\%PYVER%\InstallPath" /v ExecutablePath /t REG_SZ /d "%PYHOME%\python.exe" /f
reg add "HKCU\Software\Python\PythonCore\%PYVER%\InstallPath" /v WindowedExecutablePath /t REG_SZ /d "%PYHOME%\pythonw.exe" /f

:: PythonPath
reg add "HKCU\Software\Python\PythonCore\%PYVER%\PythonPath" /ve /t REG_SZ /d "%PYHOME%\Lib\;%PYHOME%\DLLs\\" /f

echo.
echo All Done!
echo All Done!
echo All Done!
echo Python %PYVER% has been installed to register successfully!
set /p codes=Press 1 to start idapyswitch or exit directly: 
if %codes%==1 (
	echo.
	..\idapyswitch
	pause
)

