@ECHO OFF
:: 20190708 HV
:: ETHZ_Evidence_Collector_x64_v20190708


@echo Evidence data collection has started!
@echo Please wait... 


set outputdir=%~dp0ETHZ_EC_%COMPUTERNAME%


:: create output directory
mkdir %outputdir%


:: step #01 get date and time of machine
date /T > %outputdir%\01_date_time.txt
time /T >> %outputdir%\01_date_time.txt


:: step #02 get systeminfo
@systeminfo > %outputdir%\02_systeminfo_timezone.txt


:: step #03 full memory dump
.\tools\ETHZ_EC_winpmem_1_6_2.exe %outputdir%\03_full_memory_dump.raw > NUL


:: step #04 get ip configuration
ipconfig -all > %outputdir%\04_ipconfig_all.txt


:: step #05 get active network connections incl. PID
netstat -abno > %outputdir%\05_netstat_abno.txt


:: step #06 pslist
.\tools\ETHZ_EC_pslist64.exe -accepteula -nobanner -t > %outputdir%\06_pslist.txt


:: step #07 process details like commandline
wmic process list full > %outputdir%\07_process_details.txt


:: step #08 get open files and handles by process
.\tools\ETHZ_EC_OpenedFilesView.exe /stabular "%outputdir%\08_opened_files_by_process.txt" /sort "Process ID"


:: step #09 get last opened applications from Prefetch cache; last executed application on top
.\tools\ETHZ_EC_WinPrefetchView.exe /shtml "%outputdir%\09_last_opened_apps_from_prefetch_cache.html" /sort "~7"
.\tools\ETHZ_EC_WinPrefetchView.exe /scomma "%outputdir%\09_last_opened_apps_from_prefetch_cache.txt" /sort "~7"
mkdir %outputdir%\09_last_opened_apps_from_prefetch_cache_copied
if exist "%windir%\prefetch\*.*" copy "%windir%\prefetch\*.*" %outputdir%\09_last_opened_apps_from_prefetch_cache_copied > NUL


:: step #10 analyze the Amcache with Eric Zimmerman tool. The tool has internal logic and only show the suspicious entries
echo please check the folder 10_amcache_analysis for more details > "%outputdir%\10_amcache_analysis.txt"
echo this file is just a placeholder to continue the order of logfiles >> "%outputdir%\10_amcache_analysis.txt"
mkdir %outputdir%\10_amcache_analysis
.\tools\ETHZ_EC_AmcacheParser.exe -f "%windir%\appcompat\programs\Amcache.hve" -i on --csv %outputdir%\10_amcache_analysis --csvf ETHZ_EC 1>NUL


:: step #11 get local group membership
net localgroup "administrators" > %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
net localgroup "backup operators" >> %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
net localgroup "Remote management users" >> %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
net localgroup "power users" >> %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
net localgroup "Remote desktop users" >> %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
echo. >> %outputdir%\11_local_group_membership.txt
net localgroup "users" >> %outputdir%\11_local_group_membership.txt


:: step #12 get details of all local users like SID
wmic useraccount list brief | more >  %outputdir%\12_local_users.txt
echo. >> %outputdir%\12_local_users.txt
echo. >> %outputdir%\12_local_users.txt
wmic useraccount get name | more /E +1 | findstr /v /r /c:"^$" /c:"^\ *$" /c:"^\*$" > %outputdir%\12_tmp.txt
echo. >> %outputdir%\12_local_users.txt
echo. >> %outputdir%\12_local_users.txt
FOR /f %%a IN (%outputdir%\12_tmp.txt) DO net user %%a >> %outputdir%\12_local_users.txt & echo. >> %outputdir%\12_local_users.txt & echo. >> %outputdir%\12_local_users.txt
del /Q %outputdir%\12_tmp.txt


:: step #13 show all local SMB file shares
net share > %outputdir%\13_SMB_file_shares_local.txt


:: step #14 show all incoming open SMB sessions
net session > %outputdir%\14_SMB_incoming_sessions_to_local_shares.txt


:: step #15 show all outgoing SMB mounts - depending on UAC settings you don't see mapped drives from other/all users
net use > %outputdir%\15_SMB_outgoing_sessions_to_remote_shares.txt


:: step #16 get machine registry - extensive but worth looking for 
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Computername\Computername" > %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Computername\ActiveComputername" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /V "ProductName" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /V "CurrentVersion" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /V "InstallDate" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /V "SystemRoot" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /V "DaylightName" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /V "DaylightStart" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /V "DaylightBias" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /V "StandardName" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /V "StandardStart" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /V "StandardBias" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /V "ActiveTimeBias" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Shell" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogon" /v "Userinit" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /reg:64 >> %outputdir%\16_machine_registry.txt 2>&1
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /reg:64 >> %outputdir%\16_machine_registry.txt 2>&1
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /reg:32 >> %outputdir%\16_machine_registry.txt 2>&1
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /reg:32 >> %outputdir%\16_machine_registry.txt 2>&1
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "Authentication Packages" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "Notification Packages" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "Security Packages" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "SecureBoot" >> %outputdir%\16_machine_registry.txt 1>NUL 2>&1
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" >> %outputdir%\16_machine_registry.txt 1>NUL 2>&1
reg query "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /s >> %outputdir%\16_machine_registry.txt 2>&1
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs >> %outputdir%\16_machine_registry.txt
reg query "HKLM\System\CurrentControlSet\Enum\USBSTOR" /s >> %outputdir%\16_machine_registry.txt 1>NUL 2>&1
reg query "HKLM\System\MountedDevices" /s >> %outputdir%\16_machine_registry.txt 2>&1
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /reg:64 /s >> %outputdir%\16_machine_registry.txt
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /reg:32 /s >> %outputdir%\16_machine_registry.txt
reg query "HKLM\Software\Microsoft\Active Setup\Installed Components" /reg:64 /s >> %outputdir%\16_machine_registry.txt
reg query "HKLM\Software\Microsoft\Active Setup\Installed Components" /reg:32 /s >> %outputdir%\16_machine_registry.txt
reg query "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /s >> %outputdir%\16_machine_registry.txt
reg query "HKLM\System\CurrentControlSet\Services\Tcpip6\Parameters\Interfaces" /s >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles" /s >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Shares" /s >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /s >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy" /f "S-*-*-**-**********-*********-*********-****" /s >> %outputdir%\16_machine_registry.txt 2>&1
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache" /V "AppCompatCache" >> %outputdir%\16_machine_registry.txt
reg query "HKLM\SYSTEM\CurrentControlSet\Services" >> %outputdir%\16_tmp.txt
FOR /f %%a IN (%outputdir%\16_tmp.txt) DO (
	echo. >> %outputdir%\16_machine_registry.txt 2>&1
	reg query %%a >> %outputdir%\16_machine_registry.txt 2>&1
	echo. >> %outputdir%\16_machine_registry.txt 2>&1
	)
del /Q %outputdir%\16_tmp.txt


:: step #17 users registry
echo All CU registry will be collected grouped together for each user - please notice/follow the SID inside this file  > %outputdir%\17_users_registry.txt
echo. >> %outputdir%\17_users_registry.txt
echo 1st check for well-known security identifiers >> %outputdir%\17_users_registry.txt
echo 1-5-18 Local System >> %outputdir%\17_users_registry.txt
echo 1-5-19 NT Authority Local Service >> %outputdir%\17_users_registry.txt
echo 1-5-20 NT Authority Network Service >> %outputdir%\17_users_registry.txt
echo. >> %outputdir%\17_users_registry.txt
reg query HKU | findstr /R "S-1-5-..$" | sort > %outputdir%\17_tmp.txt
FOR /f %%a IN (%outputdir%\17_tmp.txt) DO ( 
	reg query "%%a\Software\Microsoft\Windows\CurrentVersion\Run" >> %outputdir%\17_users_registry.txt  2>NUL
	reg query "%%a\Software\Microsoft\Windows\CurrentVersion\RunOnce" >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /V "Shell" >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Internet Explorer\TypedURLs" >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Terminal Server Client" /S >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" >> %outputdir%\17_users_registry.txt 2>NUL
	echo. >> %outputdir%\17_users_registry.txt
	echo. >> %outputdir%\17_users_registry.txt
	)
echo now proceed to other users with a full SID >> %outputdir%\17_users_registry.txt
echo. >> %outputdir%\17_users_registry.txt
reg query HKU | findstr /R "S-1-5-21-.*[0-9]$" | sort > %outputdir%\17_tmp.txt
FOR /f %%a IN (%outputdir%\17_tmp.txt) DO ( 
	reg query "%%a\Software\Microsoft\Windows\CurrentVersion\Run" >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Windows\CurrentVersion\RunOnce" >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /V "Shell" >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Internet Explorer\TypedURLs" >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Terminal Server Client" /S >> %outputdir%\17_users_registry.txt 2>NUL
	reg query "%%a\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" >> %outputdir%\17_users_registry.txt 2>NUL
	echo. >> %outputdir%\17_users_registry.txt
	echo. >> %outputdir%\17_users_registry.txt
	)
reg query HKU | findstr /v ".DEFAULT" | findstr "_Classes" > %outputdir%\17_tmp.txt
FOR /f %%a IN (%outputdir%\17_tmp.txt) DO (reg query "%%a\Local Settings\Software\Microsoft\Windows\Shell" /s >> %outputdir%\17_users_registry.txt 2>&1)
del /Q %outputdir%\17_tmp.txt


:: step #18 list all files that have been modified in the last three 3day/72hrs
powershell.exe -executionpolicy bypass -nop -f .\tools\ETHZ_EC_files_modified_in_last_3_days.ps1 %outputdir%\18_files_modified_in_last_3_days.txt


:: step #19 copy security log
copy "%windir%\system32\winevt\Logs\Security.evtx" "%outputdir%\19_Security.evtx" > NUL


:: step #20 copy system log
copy "%windir%\system32\winevt\Logs\System.evtx" "%outputdir%\20_System.evtx" > NUL


:: step #21 get dns cache
ipconfig -displaydns > %outputdir%\21_dns_cache.txt


:: step #22 get local hostsfile
copy %windir%\system32\drivers\etc\hosts.* %outputdir%\22_etc_hosts.txt > NUL


:: step #23 get local arp cache
arp -a > %outputdir%\23_arp_cache.txt


:: step #24 get routing table
route print > %outputdir%\24_route_print.txt


:: step #25 list windows advanced firewall rules
netsh advfirewall monitor show firewall > %outputdir%\25_advanced_firewall.txt
echo. >> %outputdir%\25_advanced_firewall.txt
echo. >> %outputdir%\25_advanced_firewall.txt
netsh advfirewall firewall show rule name=all >> %outputdir%\25_advanced_firewall.txt


:: step #26 get autoruns for machine AND all users; txt easier readable; csv for automated analayze
.\tools\ETHZ_EC_autorunsc64.exe -accepteula -nobanner -a * -h -s -t * > %outputdir%\26_autorunsc.txt
.\tools\ETHZ_EC_autorunsc64.exe -accepteula -nobanner -a * -h -s -t -c * > %outputdir%\26_autorunsc.csv


:: step #27 copy scheduled task logs - some Windows 10 seemed like to not having this log file but with recent cumulative updates it got fixed
copy "%windir%\system32\winevt\Logs\Microsoft-Windows-TaskScheduler%%4Operational.evtx" "%outputdir%\27_Microsoft-Windows-TaskScheduler_Operational.evtx"> NUL


:: step #28 export all currently visible scheduled tasks
schtasks /query /V /FO Table > %outputdir%\28_scheduled_tasks_export.txt


:: step #29 check loaded drivers - the way of bringing root kits into Windows
.\tools\ETHZ_EC_DriverView.exe /stabular "%outputdir%\29_loaded_drivers.txt" /sort "~Filename"


:: step #30 copy setup log
copy "%windir%\system32\winevt\Logs\Setup.evtx" "%outputdir%\30_Setup.evtx" > NUL


:: step #31 copy Application log
copy "%windir%\system32\winevt\Logs\Application.evtx" "%outputdir%\31_Application.evtx" > NUL


:: step #32 copy Windows Defender log
copy "%windir%\system32\winevt\Logs\Microsoft-Windows-Windows Defender%%4Operational.evtx" "%outputdir%\32_Microsoft-Windows-Windows-Defender_Operational.evtx" > NUL


@echo Evidence data collection has finished!
@echo Please disconnect removable drive for further offline analyzation!
@Pause