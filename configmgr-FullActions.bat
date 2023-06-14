
::SIMPLY COMMENT THE COMMAND WITH "::" IF DON't WANT TO EXECUTE.
@ECHO off


	NET SESSION >nul 2>&1
	IF %ERRORLEVEL% EQU 0 (
    goto continue
	) ELSE (
    ECHO !! THIS SCRIPT MUST BE RUN AS AN ADMINISTRATOR !!.
    pause
    exit
	)
:continue



:ost	
	ECHO Updating Policy before running Evaluation Cycles...
	gpupdate /force
	if %errorlevel% neq 0 goto ost
	ECHO waiting few seconds before running Evaluation Cycle...
 


	ECHO Running Full Evaluation Cycle
timeout /t 5 /nobreak

	ECHO Application Deployment Evaluation Cycle 
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000121}" /NOINTERACTIVE

	ECHO Discovery Data Collection Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000003}" /NOINTERACTIVE

	ECHO File Collection Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000010}" /NOINTERACTIVE

::	ECHO Hardware Inventory Cycle
::WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000001}" /NOINTERACTIVE

	ECHO Machine Policy Retrieval Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000021}" /NOINTERACTIVE

	ECHO Machine Policy Evaluation Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000022}" /NOINTERACTIVE

	ECHO Software Inventory Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000002}" /NOINTERACTIVE

	ECHO Software Metering Usage Report Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000031}" /NOINTERACTIVE

	ECHO Software Updates Assignments Evaluation Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000108}" /NOINTERACTIVE

	ECHO Software Update Scan Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000113}" /NOINTERACTIVE

	ECHO State Message Refresh
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000111}" /NOINTERACTIVE

	ECHO User Policy Retrieval Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000026}" /NOINTERACTIVE

	ECHO User Policy Evaluation Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000027}" /NOINTERACTIVE

	ECHO Windows Installers Source List Update Cycle
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-000000000032}" /NOINTERACTIVE

	ECHO Client action evaluation cycle is done.
timeout /t 5 /nobreak

setlocal
SET /P OST1=DELETE_ALL_CCMCACHE (Y/[N])?
IF /I "%OST1%" NEQ "Y" GOTO END





	ECHO Deleting the SCCM Cache, excluding skpswi.dat...
	
	for /d %%i in ("C:\Windows\ccmcache\*") do (
   if not "%%i"=="C:\Windows\ccmcache\skpswi.dat" (
      rd /s /q "%%i"
	)
)

	pause



IF %OST1% NEQ "Y" (
    goto END1
	) 
	::ELSE (
    ::ECHO !! THIS SCRIPT MUST BE RUN AS AN ADMINISTRATOR !!.
    ::pause
    ::exit
	::)





::0IF /I %OST1% NEQ "Y" 


exit




:END
endlocal
ECHO SKIPPING CCMCACHE DELETATION...
timeout /t 5 /nobreak

exit
