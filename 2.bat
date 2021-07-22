@ECHO OFF
REM  QBFC Project Options Begin
REM  HasVersionInfo: Yes
REM  Companyname: Vectra LLC
REM  Productname: File_Check
REM  Filedescription: File_Check
REM  Copyrights: Vectra LLC @2020
REM  Trademarks: 
REM  Originalname: 
REM  Comments: 
REM  Productversion: 20.00.00.00
REM  Fileversion: 20.00.00.00
REM  Internalname: File Check
REM  Appicon: 
REM  AdministratorManifest: No
REM  QBFC Project Options End
@ECHO ON
:: ------------------------------------------COMAU-GM--------------------------------------------------------------::
::---Variables---::
::--- This script will be run on the designer system and it will pull data from the Gatway system for 2D creation--::
::-----------------------------------------------------------------------------------------------------------------::
Set GatewayPC=uusso1dt0270316
::---Create Date and Time Folder to segregate data ---::
set "datestamp=%date:~4,-8%_%date:~7,-5%_%date:~12,2%"
:: -- Time Format 06:46:13.50 -- ::
set "timestamp=%time:~0,2%_%time:~3,2%_%time:~6,2%"

::-----BeginScript-----::

::--- This completion file is created if an error is encountered. Delete it before any subsequent tries
if exist C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Failed.txt del /s /f /q C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Failed.txt

::----- Presence of this file indicates that the script has already been run and hence EXIT without doing any process
if exist C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt exit

if not exist \\%GatewayPC%\Auto2d\%computername%\Unzip_Complete.txt (
exit
)

::----------------------------------------------------------------------------------------------------------------------------------------------------------
::----------------------------------------------------------------------------------------------------------------------------------------------------------

::xcopy /e /i /r /y \\%GatewayPC%\Auto2d\%computername% C:\vectra\Auto2d_Output_files
robocopy \\%GatewayPC%\Auto2d\%computername% C:\vectra\Auto2d_Output_files /E /R:1 /W:60 /TBD /NP /V /MT:8 /log:"C:\vectra\Auto2D_Output_files\%datestamp%_%timestamp%"_FileCheck_Log.txt""

REM /S — Copy subdirectories, but not empty ones.
REM /E — Copy Subdirectories, including empty ones.
REM /Z — Copy files in restartable mode.
REM /ZB — Uses restartable mode, if access denied use backup mode.
REM /R:5 — Retry 5 times (you can specify a different number, default is 1 million).
REM /W:5 — Wait 5 seconds before retrying (you can specify a different number, default is 30 seconds).
REM /TBD — Wait for sharenames To Be Defined (retry error 67).
REM /NP — No Progress – don’t display percentage copied.
REM /V — Produce verbose output, showing skipped files.
REM /MT:16 — Do multithreaded copies with n threads (default is 8).

::--- ROBOCOPY EXIT CODES --- ::
::--- SUCCESS --- ::
REM 0	No files were copied. No failure was encountered. No files were mismatched. The files already exist in the destination directory; therefore, the copy operation was skipped.
REM 1	All files were copied successfully.
REM 2	There are some additional files in the destination directory that are not present in the source directory. No files were copied.
REM 3	Some files were copied. Additional files were present. No failure was encountered.
REM 5	Some files were copied. Some files were mismatched. No failure was encountered.
REM 6	Additional files and mismatched files exist. No files were copied and no failures were encountered. This means that the files already exist in the destination directory.
REM 7	Files were copied, a file mismatch was present, and additional files were present.
REM 8	Several files did not copy.
REM Any value greater than 8 indicates that there was at least one failure during the copy operation.


REM EQU : Equal
REM NEQ : Not equal

REM LSS : Less than <
REM LEQ : Less than or Equal <=

REM GTR : Greater than >
REM GEQ : Greater than or equal >=


::--- Code below handles any xcopy related error
::---Error
if %errorlevel% GEQ 8 (
REM Create the completion file
REM Write the error code, append to the same text file
echo %errorlevel% > C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Failed.txt
REM Write the error code description

echo "Error Code Details:" >> c:\vectra\auto2d_output_files\Server_Data_Fetch_Failed.txt
echo 8	Several files did not copy. >> c:\vectra\auto2d_output_files\Server_Data_Fetch_Failed.txt
echo Any value greater than 8 indicates that there was at least one failure during the copy operation. >> c:\vectra\auto2d_output_files\Server_Data_Fetch_Failed.txt
REM Do not continue
Exit
)


::--- Success
if %errorlevel% LSS 8 (
REM remove the system name folder on the customer gateway
rd /s /q \\%GatewayPC%\Auto2D\%computername%

REM Create the completion file
REM Write Success code
echo %errorlevel% > C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt

echo "Success Code Details:" >> C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt
REM Write Success code description
echo 0	No files were copied. No failure was encountered. No files were mismatched. The files already exist in the destination directory; therefore, the copy operation was skipped. >> C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt
echo 1	All files were copied successfully. >> C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt
echo 2	There are some additional files in the destination directory that are not present in the source directory. No files were copied. >> C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt
echo 3	Some files were copied. Additional files were present. No failure was encountered. >> C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt
echo 5	Some files were copied. Some files were mismatched. No failure was encountered. >> C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt
echo 6	Additional files and mismatched files exist. No files were copied and no failures were encountered. This means that the files already exist in the destination directory. >> C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt
echo 7	Files were copied, a file mismatch was present, and additional files were present. >> C:\Vectra\Auto2D_Output_Files\Server_Data_Fetch_Complete.txt
)

