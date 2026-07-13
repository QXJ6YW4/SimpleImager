REM SimpleImager - Live acquisition tool for Windows systems
REM Copyright (C) 2026 [Your Name or Alias]
REM 
REM This program is free software: you can redistribute it and/or modify
REM it under the terms of the GNU General Public License as published by
REM the Free Software Foundation, either version 3 of the License, or
REM (at your option) any later version.
REM 
REM This program is distributed in the hope that it will be useful,
REM but WITHOUT ANY WARRANTY; without even the implied warranty of
REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM GNU General Public License for more details.
REM 
REM You should have received a copy of the GNU General Public License
REM along with this program.  If not, see <https://www.gnu.org/licenses/>.


@echo off

rem code add
setlocal EnableDelayedExpansion

::Created by Encode -> QXJ6YW4gRWxjaGlkYW5h
::Special thanks Mihir Kabani and Yasuki Kouno
::Acquisition using FTK_Imager_CLI_V3.1.1 (Aug 20 2012)
::Version 4.5

color 0A

echo  ------------------------------------------------------------
echo   SIMPLE IMAGER
echo   Forensic Acquisition Utility for Meoery and Disk
echo  ------------------------------------------------------------

	@echo off
	cls
	net session >nul 2>&1
	color 0E
	echo Checking if script is run with Administrator privileges
	if %errorlevel% == 0 (goto :run) else (goto :1endA)
:run
	echo OK
	echo.

rem code add：Checking if arguments are given to the script.
	color 0E
	echo Checking if exists arguments
	if "%1%"=="" goto 1endB
	echo OK
	echo.



	title D-Acquisition.bat %1 

rem code add：Checking if the folder already exists.
	if not exist %1\%computername% (goto :run2)
	color 0E
	echo The folder already exists. Continue?
	choice
	if %errorlevel%==2 (goto :1endC)
	

color 0A
:run2
	mkdir %1\%computername%
	echo To acquire memory and disk image press 1 or to acquire only disk image press 2 
	set /p stage= 
	if %stage%==1 Goto stage1
	if %stage%==2 Goto stage2
	
:stage1 
:: Script Setup -----
	if "%processor_architecture%" == "AMD64" (
		set winpmem=winpmem_mini_x64_rc2
		title  D-Acquisition.bat %1 64-bit
	) else (
		set winpmem=winpmem_mini_x86
		title D-Acquisition.bat %1 32-bit
	)
::Memory acquisition
::Creation of folder to store Memory Image
	color 0A
	echo =====================================================
	echo  MEMORY ACQUISITION PHASE
	echo =====================================================
	mkdir %1\%computername%\Memory-Image
	echo ---Memory Collection Initiated--- >> %1\%computername%\%computername%-log.txt
	echo %date% %time% - Memory-Image\%computername%-memdump.mem >> %1\%computername%\%computername%-log.txt
	%~dp0%winpmem%.exe %1\%computername%\Memory-Image\%computername%-memdump.mem
	echo ---Memory Collection Completed--- >> %1\%computername%\%computername%-log.txt
	echo %date% %time% - Memory-Image\%computername%-memdump.mem >> %1\%computername%\%computername%-log.txt

:stage2
:: Device information and Bitlocker details

::Creation of folder to store Disk Image
	mkdir %1\%computername%\Disk-Image
	set UserInputPath1="%1\%computername%\Disk-Image"

	@echo DeviceInfo
	set DeviceInfo=DeviceInfo.txt
	(
		echo ---PhysicalDisk_Info---
		wmic DISKDRIVE get InterfaceType,Name,Manufacturer,Model,Size,Status,serialnumber,MediaType,Partitions 
		echo ---LogicalDisk_Info---
		wmic logicaldisk get caption,description,drivetype,providername,volumename 
		echo ---Partition_Info---
		wmic partition get name,size,type 
		echo ---MotherBoard_Info---
		wmic bios get name,serialnumber,version
		echo ---Computer_Info---
		wmic computersystem get model,name,manufacturer,systemtype 
	)>"%UserInputPath1%\%DeviceInfo%"
	type "%UserInputPath1%\%DeviceInfo%"


	@echo BitLock
	set BitLock=BitLock_Details.txt
	(
		echo [status]
		manage-bde -status
	)>"%UserInputPath1%\%BitLock%"


rem Refactoring
	set Letters=CDEFGHIJKLMNOPQRSTUVWXYZAB
	set buf=%Letters%
	set len=0

:LOOP
	if not "%buf%"=="" (
	    set buf=%buf:~1%
	    set /a len=%len%+1
	    goto :LOOP
	)

	set /a len-=1

	for /l %%n in (0,1,%len%) do (
		set Letter=!Letters:~%%n,1!
		(
			echo [protectors !Letter!]
			manage-bde -protectors !Letter!: -get
			echo.
			echo.
		)>>"%UserInputPath1%\%BitLock%"
	)
	type "%UserInputPath1%\%BitLock%"





	@echo off

::Get information for Notes in FTK Imager
	echo ---Getting additional details for the system and disk--- 
	@echo off
	for /f "usebackq" %%h in (`powershell -command "$env:COMPUTERNAME"`) do set hname=%%h
		goto :H
	)
:H
	echo %hname%
	echo %UserInputPath1%

	set caseno=%hname%
	set Inv= Self
	set Cname= DeviceInfo

	@echo off
	for /f "skip=1 delims=" %%j in ('wmic computersystem get model') do (
		set model=%%j
		goto :D1
	)

:D1
	echo %model%

	for /f "skip=1 delims=" %%a in ('wmic computersystem get name') do (
		set name=%%a
		goto D2
	)

:D2
	echo %name%

	for /f "skip=1 delims=" %%b in ('wmic computersystem get manufacturer') do (
		set manufacturer=%%b
		goto D3
	)

:D3
	echo %manufacturer%

	for /f "skip=1 delims=" %%c in ('wmic bios get serialnumber') do (
		set srno=%%c
		goto :Done
	)

:Done
	echo %srno%


:: Notes for FTK
	set notes=Custodian_Name %Cname% Make %manufacturer% Model %model% Serialnumber %srno% UserName %name%


:: Acquisition begins
	color 0A
	echo =====================================================
	echo  DISK ACQUISITION PHASE
	echo =====================================================
	echo ---Start of disk acquisition--- >> %1\%computername%\%computername%-log.txt
	echo %date% %time% - Disk-Image\%computername%-driveImage >> %1\%computername%\%computername%-log.txt
	echo Enter "a" to perform verification post imaging or "b" to only perform imaging without verification
	set /p Verify= 

:: Verification begins
rem Refactoring
	if %Verify%==a (
		set v=--verify
		set msg1=---Imaging process begins---
		set msg2=---Imaging process completed along with verification---
	) else if %Verify%==b (
		set v=
		set msg1=---Imaging process without verification begins---
		set msg2=---Imaging process completed without verification---
	)


:StartFTK
rem code add:[%~dp0] just in case.	
	%cd%\ftkimager.exe --list-drives 

:SelectDrive
	echo Enter number for the drive to be imaged e.g. 0 for PhysicalDrive0 or 1 for PhysicalDrive1 
	echo Enter 0 or 1 or 2 for the drive to be acquired 
	set /p DriveSel=

rem code add:input check
	if not defined DriveSel (
		echo pleaseinput
		goto SelectDrive
	)

	echo %msg1% >> %1\%computername%\%computername%-log.txt
	echo %date% %time% - Disk-Image\%computername%-drive%DriveSel% >> %1\%computername%\%computername%-log.txt

	%cd%\ftkimager.exe \\.\PHYSICALDRIVE%DriveSel% "%UserInputPath1%\%caseno%" --e01 --frag 2G --compress 5 --case-number "%caseno%" --evidence-number "%caseno%" --description "%caseno%" --examiner "%Inv%" --notes "%notes%" %v%

rem code add:Redo on error
	if %errorlevel% == 0 (goto :EndFTK)
	echo An error has occurred. Retry?
	choice
	if %errorlevel%==1 (goto :StartFTK)


:EndFTK
	echo %msg2%
	echo %msg2% >> %1\%computername%\%computername%-log.txt
	echo %date% %time% - Disk-Image\%computername%-drive%DriveSel% >> %1\%computername%\%computername%-log.txt


::Script completed
	echo ---Acquisition Process Completed, safely unmount the drive---
	echo ---Acquisition Process Completed, safely unmount the drive--- >> %1\%computername%\%computername%-log.txt
	echo %date% %time% - Disk-Image\%computername%-drive%DriveSel% >> %1\%computername%\%computername%-log.txt
	goto :ENDF


:1endA
	echo NG:Ensure CMD is runas Administrator
	goto :ENDF

:1endB
	echo NG:No arguments
	goto :ENDF

:1endC
	echo NG:Folders already exists
	goto :ENDF


:ENDF
	pause


