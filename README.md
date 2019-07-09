# ETHZ_EC_Winx64

The ETHZ Evidence Collector Windows x64 (ETHZ_EC_Winx64) is designed to automize the data collection process for live incident response on default Windows x64 machines/setups.

It focuses on OS built-in commands enriched with tried and trusted, free of charge 3rd party tools from Sysinternals, Nirsoft, Rekall Forensiscs and Eric Zimmerman.

The core functionality is a batch file called `ETHZ_EC_Winx64.cmd` and the subfolder `Tools`.

The batch file `ETHZ_EC_Winx64.cmd` needs to be run from an administrative CMD prompt to properly collect all data!

It just collects data for later offline analysis and sorts them from live to persist:
* Date and time
* System information
* Full memory dump
* Network activity - note PID!
* Process tree - look for PID!
* Process details - look for PID!
* Open Files by Process - look for PID!
* Prefetch cache
* AMCache
* Local groups and users
* SMB shares/sessions/mounts
* Selected registy HKLM and HKU
* File changes in last 72hrs
* OS logfiles
* DNS cache/ARP table/hosts file/firewall config/routing
* Autoruns dump
* Scheduled tasks
* AV logfile

All listed data from above is collected in a new subfolder called `ETHZ_EC_%COMPUTERNAME%` next to the `ETHZ_EC_Winx64.cmd` file.

The whole data collection process takes about 5-10 min depending on physical memory size of the machine and USB stick performance. The full memory dump, file changes in last 72hrs and Autoruns dump steps usually taking the most time.

The ordering of the collected data should improve the general data quality and speed up the investigative process for security teams.
At the same time it allows interested IT operational staff to learn how their systems behave under the hood.



Manual download of 3rd party tools
----------------------------------

For licensing reasons we can't provide the ETHZ Evidence Collector fully operational and already equipped with 3rd party tools.
Please manually download all 3rd party tools from their offical website, extract, rename and put them into the `Tools` folder to get the full functionality.

|Download URL: | Original filename: | Save files in .\ETHZ_EC_Winx64\Tools and rename to: |
| ------------ | ------------------ | --------------------------------------------------- |
|https://download.sysinternals.com/files/Autoruns.zip |	Autoruns64.exe | ETHZ_EC_Autoruns64.exe |
|https://download.sysinternals.com/files/Autoruns.zip	| Autorunsc64.exe	|ETHZ_EC_autorunsc64.exe |
|https://download.sysinternals.com/files/PSTools.zip | pslist64.exe | ETHZ_EC_pslist64.exe |
|https://www.nirsoft.net/utils/driverview-x64.zip |	Driverview.exe | ETHZ_EC_DriverView.exe |
|https://www.nirsoft.net/utils/ofview-x64.zip | OpenedFilesView.exe | ETHZ_EC_OpenedFilesView.exe |
|https://www.nirsoft.net/utils/winprefetchview-x64.zip | WinPrefetchView.exe | ETHZ_EC_WinPrefetchView.exe |
|https://github.com/google/rekall/releases/download/v1.3.1/winpmem_1.6.2.exe | winpmem_1.6.2.exe | ETHZ_EC_winpmem_1_6_2.exe |
|https://f001.backblazeb2.com/file/EricZimmermanTools/AmcacheParser.zip | AmcacheParser.exe | ETHZ_EC_AmcacheParser.exe |

**The name of winpmem does not only get the prefix "ETHZ_EC" but also changes the . to _ in the version range!**

The renaming of the 3rd party tool makes them easier to distinguish while they run and leave traces in the collected data.

After downloading, extracting, moving/renaming the 3rd party tools the content of the subfolder `.\ETHZ_EC_Winx64\Tools` should look like this:

```
C:\>dir C:\Build\ETHZ_EC_Winx64\Tools
 Volume in drive C is System
 Volume Serial Number is 6FGZ-4149

 Directory of C:\Build\ETHZ_EC_Winx64\Tools

14.06.2019  11:08    <DIR>          .  
14.06.2019  11:08    <DIR>          ..  
27.03.2019  13:32         3’874’416 ETHZ_EC_AmcacheParser.exe  
31.05.2019  12:49           857’592 ETHZ_EC_Autoruns64.exe  
31.05.2019  12:54           776’480 ETHZ_EC_autorunsc64.exe  
19.09.2015  12:52            95’328 ETHZ_EC_DriverView.exe  
06.05.2019  14:57               563 ETHZ_EC_files_modified_in_last_3_days.ps1  
10.09.2018  23:36           171’728 ETHZ_EC_OpenedFilesView.exe  
28.06.2016  11:42           202’400 ETHZ_EC_pslist64.exe  
02.02.2018  18:12         1’299’968 ETHZ_EC_winpmem_1_6_2.exe  
12.01.2016  12:23           112’224 ETHZ_EC_WinPrefetchView.exe  
               9 File(s)      7’408’699 bytes
```
               
Now you are ready to use the tool in it's core functionality from an administrative CMD prompt!



Use core functionality
----------------------

1. Use a memory stick that has more capacity then the target machine has RAM

2. Copy the content from `.\ETHZ_EC_Winx64` to the root of an USB stick 
* `ETHZ_EC_Winx64.cmd`
* `Tools` folder

3. Logon onto the target machine with local administrator account only!
**Be aware of the risk of lateral movement and therefor use whenever possible a local account only!**

4. Open an administrative CMD prompt

5. `ETHZ_EC_Winx64.cmd`

The `ETHZ_EC_Winx64.cmd` will create a new subfolder called `ETHZ_EC_%COMPUTERNAME%` and put all collected evidence files into it.
After the data collection process has ended please disconnected the USB stick and analyze the files on another machine.



Create an SFX/EXE
-----------------

For further improvment of the data collection process you can create a self-extracting archive (SFX) straight out of the downloaded/equipped toolset.
The SFX will contain the `ETHZ_EC_Winx64.cmd` and the manually equipped `Tools` folder and requests/requires admin privilieges at the start.
Therefor the data collection process will be even more handy and robust at the same time.
The SFX creation itself is automated by another batch file.

Just doubleclick `.\SFX_Build_Tools\SFX_ETHZ_EC_Winx64_Build.cmd`

The resulting SFX will be `.\SFX_Output\ETHZ_EC_Winx64.exe`

Now put `ETHZ_EC_Winx64.exe` on a USB stick and run it.

SFX creation is possible thanks to:

7-Zip by Igor Pavlov; licensed under GNU LGPL license  
please visit https://www.7-zip.org for further information

7zSFX by Oleg Scherbakov; because a modified 7zsd is required to extract the files in the current directory  
please visit https://github.com/OlegScherbakov/7zSFX 

Reference links for SFX creation and manifest integration:  
https://www.7-zip.org/a/7z1900-extra.7z  
https://github.com/OlegScherbakov/7zSFX  
https://raw.githubusercontent.com/OlegScherbakov/7zSFX/master/files/7zsd_extra_170_3900.7z  
https://sourceforge.net/p/sevenzip/discussion/45797/thread/f01833f4/



Known issues
------------
* The currently used memory dump tool bluescreens the machine when Windows 10 Credential Guard is activated.
* The currently used memory dump tool dumps no data when run on a Hyper-V VM with dynamic memory enabled.


Disclaimer
----------
Use at your own risk! No warranty, absolutely no support nor liability.


License
-------
Licensed under the [MIT license](LICENSE).
