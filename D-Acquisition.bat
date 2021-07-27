@echo off
::Created by Arzan Elchidana
::Acquisition using FTK_Imager_CLI_V10
::Version 3.1
REM Fill the information maked with REM in the lines below before sending the script for Acquisition
@echo off
net session >nul 2>&1
echo Checking if script is run with Administrator privileges
if %errorlevel% == 0 (goto :run) else (goto :1endA)

:run
title D-Acquisition.bat %1 
cls

mkdir %1\%computername%
set /p stage= To acquire memory and disk image press 1 or to acquire only disk image press 2
if %stage%==1 Goto stage1
if %stage%==2 Goto stage2
:stage1 
:: Memory acquisition
::Creation of folder to store Memory Image
mkdir %1\%computername%\Memory-Image
echo ---Memory Collection Initiated--- >> %1\%computername%\%computername%-log.txt
echo %date% %time% - Memory-Image\%computername%-memdump.mem >> %1\%computername%\%computername%-log.txt
%~dp0\winpmem_mini_x64_rc2.exe %1\%computername%\Memory-Image\%computername%-memdump.mem
echo ---Memory Collection Completed--- >> %1\%computername%\%computername%-log.txt
echo %date% %time% - Memory-Image\%computername%-memdump.mem >> %1\%computername%\%computername%-log.txt
::echo[ >> %1:\%computername%\%computername%-log.txt
:stage2
:: Device information and Bitlocker details
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
)>"%DeviceInfo%"            
type "%DeviceInfo%" 
@echo BitLock
set BitLock=BitLock_Details.txt
(
manage-bde -status
manage-bde -protectors C: -get 
manage-bde -protectors D: -get 
manage-bde -protectors E: -get 
manage-bde -protectors F: -get
manage-bde -protectors G: -get
manage-bde -protectors H: -get 
manage-bde -protectors I: -get
manage-bde -protectors J: -get
manage-bde -protectors K: -get
manage-bde -protectors L: -get
manage-bde -protectors N: -get
manage-bde -protectors O: -get
manage-bde -protectors P: -get
manage-bde -protectors Q: -get
manage-bde -protectors R: -get
manage-bde -protectors S: -get
manage-bde -protectors T: -get
manage-bde -protectors U: -get
manage-bde -protectors V: -get
manage-bde -protectors W: -get
manage-bde -protectors X: -get
manage-bde -protectors Y: -get
manage-bde -protectors Z: -get
manage-bde -protectors A: -get
manage-bde -protectors B: -get

)>"%BitLock%"            
type "%BitLock%" 
 
@echo off
::Creation of folder to store Disk Image
mkdir %1\%computername%\Disk-Image
set UserInputPath1="%1\%computername%\Disk-Image"
::Get information for Notes in FTK Imager
echo ---Getting additional details for the system and disk--- 
@echo off
for /f "skip=1 delims=" %%h in ('wmic computersystem get name') do (
set hname=%%h
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

copy DeviceInfo.txt "%UserInputPath1%"
copy BitLock_Details.txt "%UserInputPath1%"
del /F /Q DeviceInfo.txt
del /F /Q BitLock_Details.txt
:: Acquisition begins
echo ---Start of disk acquisition--- >> %1\%computername%\%computername%-log.txt
echo %date% %time% - Disk-Image\%computername%-driveImage >> %1\%computername%\%computername%-log.txt
ftkimager.exe --list-drives 

echo Enter number for the drive to be imaged e.g. 0 for PhysicalDrive0 or 1 for PhysicalDrive1 
set /p DriveSel= Enter 0 or 1 or 2 for the drive to be acquired 
echo ---Imaging process begins--- >> %1\%computername%\%computername%-log.txt
echo %date% %time% - Disk-Image\%computername%-drive%DriveSel% >> %1\%computername%\%computername%-log.txt
if %DriveSel%==0 Goto Label0
if %DriveSel%==1 Goto Label1
if %DriveSel%==2 Goto Label2
if %DriveSel%==3 Goto Label3
if %DriveSel%==4 Goto Label4
if %DriveSel%==5 Goto Label5
::echo[ >> %1:\%computername%\%computername%-log.txt
:Label0 
ftkimager.exe \\.\PHYSICALDRIVE0 "%UserInputPath1%\%caseno%" --e01 --frag 2G --compress 5 --verify --case-number "%caseno%" --evidence-number "%caseno%" --description "%caseno%" --examiner "%Inv%" --notes "%notes%"
goto :END

:Label1
ftkimager.exe \\.\PHYSICALDRIVE1 "%UserInputPath1%\%caseno%" --e01 --frag 2G --compress 5 --verify --case-number "%caseno%" --evidence-number "%caseno%" --description "%caseno%" --examiner "%Inv%" --notes "%notes%"
goto :END

:Label2
ftkimager.exe \\.\PHYSICALDRIVE2 "%UserInputPath1%\%caseno%" --e01 --frag 2G --compress 5 --verify --case-number "%caseno%" --evidence-number "%caseno%" --description "%caseno%" --examiner "%Inv%" --notes "%notes%"
goto :END

:Label3
ftkimager.exe \\.\PHYSICALDRIVE3 "%UserInputPath1%\%caseno%" --e01 --frag 2G --compress 5 --verify --case-number "%caseno%" --evidence-number "%caseno%" --description "%caseno%" --examiner "%Inv%" --notes "%notes%"
goto :END

:Label4
ftkimager.exe \\.\PHYSICALDRIVE4 "%UserInputPath1%\%caseno%" --e01 --frag 2G --compress 5 --verify --case-number "%caseno%" --evidence-number "%caseno%" --description "%caseno%" --examiner "%Inv%" --notes "%notes%"
goto :END

:Label5
ftkimager.exe \\.\PHYSICALDRIVE5 "%UserInputPath1%\%caseno%" --e01 --frag 2G --compress 5 --verify --case-number "%caseno%" --evidence-number "%caseno%" --description "%caseno%" --examiner "%Inv%" --notes "%notes%"
goto :END
:END
echo ---Imaging process completed along with verification---
echo ---Imaging process completed along with verification--- >> %1\%computername%\%computername%-log.txt
echo %date% %time% - Disk-Image\%computername%-drive%DriveSel% >> %1\%computername%\%computername%-log.txt
::Script completed
echo ---Acquisition Process Completed, safely unmount the drive---
echo ---Acquisition Process Completed, safely unmount the drive--- >> %1\%computername%\%computername%-log.txt
echo %date% %time% - Disk-Image\%computername%-drive%DriveSel% >> %1\%computername%\%computername%-log.txt
goto :ENDF
:1endA
echo Ensure CMD is runas Administrator
:ENDF
