@echo off
goto :main
-------------------
weebu v3.1
by @aaviator42
-------------------

:main
::CONFIG -- EDIT THIS STUFF!
REM 'infourl' should contain the URL to your `info.txt`
REM file.

REM [!!] Make sure powershell is installed!

set infourl=http://example.com/files/info.txt

::main
echo -------------------------------------
echo weebu by @aaviator42
echo -------------------------------------

echo: >> weebu_log.txt 
echo %date% %time%: STARTING WEEBU >> weebu_log.txt 
echo --info file url = %infourl% >> weebu_log.txt

::internetcheck
::delete this code block if you are accessing resources on the local network
echo STATUS: Checking internet connection
ping example.com -n 1 -w 1000>nul
if errorlevel 0 (
	echo --Internet connection working!
) else (
	echo ERROR: NO INTERNET CONNECTION [2]
	echo %date% %time%: NO INTERNET CONNECTION, EXITING [2] >> weebu_log.txt
	timeout /t 2 >nul
	exit /b 2
)

::oldcheck
echo STATUS: Checking for old info.txt
if exist oldinfo.txt (
	echo --Old oldinfo.txt found!

	::readoldvar
	echo STATUS: Reading old variables
	(
		set /p oldver=
	)<oldinfo.txt
	echo --Variables read!
) else (
	echo --No old info.txt found!
	set oldver=0
)
echo --pervious version = %oldver% >> weebu_log.txt

::downloadinfo
echo STATUS: Downloading new info.txt
call :psd %infourl% info.txt
if exist info.txt (
	echo --info.txt download successful!
) else (
	echo ERROR: info.txt DOWNLOAD FAILED [3]
	echo %date% %time%: info.txt DOWNLOAD FAILED [3] >> weebu_log.txt
	exit /b 3
)

::readnewvar
echo STATUS: Reading new variables
(
	set /p newver=
	set /p comurl=
)<info.txt
echo --Variables read!
echo --pervious version = %newver% >> weebu_log.txt
echo --commands url = %comurl% >> weebu_log.txt

::comparevar
if exist oldinfo.txt (
	echo STATUS: Comparing variables
	echo [+] Current version: %oldver%
	echo [+] New version: %newver%
	if %newver% GTR %oldver% (
		echo --New commands available!
	) else (
		echo --No new commands, exiting!
		del info.txt
		echo %date% %time%: No new commands available, exiting [0] >> weebu_log.txt
		exit /b 0
	)
)

::downloadnew
echo STATUS: Downloading new commands
call :psd %comurl% commands.cmd
if exist commands.cmd (
	echo --New commands downloaded!
) else (
	echo ERROR: COULDN'T DOWNLOAD NEW COMMANDS [4]
	echo %date% %time%: COMMAND DOWNLOAD FAILED [4] >> weebu_log.txt
	exit /b 4
)

::renaminginfo
if exist oldinfo.txt (
	del oldinfo.txt
)
ren info.txt oldinfo.txt

echo STATUS: Running new commands!
start /wait commands.cmd
del commands.cmd
echo Commands have been run! Exiting now!
echo %date% %time%: Commands have been fetched and run [version: %newver%], exiting [0] >>  weebu_log.txt
exit /b 0

:psd
powershell ([Net.ServicePointManager]::SecurityProtocol = "[Net.SecurityProtocolType]::tls12, [Net.SecurityProtocolType]::tls11, [Net.SecurityProtocolType]::tls, [Net.SecurityProtocolType]::ssl3") -and (wget %~1 -UseBasicParsing -OutFile %~2) >nul
