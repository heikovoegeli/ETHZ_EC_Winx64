:: 20190704 SFX_ETHZ_EC_Winx64_Build.cmd
::
:: How to generate the SFX:
:: 1. Power on Test/Build VM
:: 2. Create C:\Build folder although other directories are fine too thanks to relative paths
:: 3. Copy folder structure to C:\Build folder
:: 4. run SFX_ETHZ_EC_Winx64_Build.cmd (this file) either from CMD or by double clicking it
::
:: Credits for SFX creation goes to:
:: 7-Zip; licensed under GNU LGPL license; please visit https://www.7-zip.org for further information
:: Modified 7zSFX by Oleg Scherbakov; please visit https://github.com/OlegScherbakov/7zSFX because a modified 7zsd is required to extract the files in the current directory
::
:: Reference links for SFX creation:
:: https://www.7-zip.org/a/7z1900-extra.7z
:: https://github.com/OlegScherbakov/7zSFX
:: https://raw.githubusercontent.com/OlegScherbakov/7zSFX/master/files/7zsd_extra_170_3900.7z
:: https://sourceforge.net/p/sevenzip/discussion/45797/thread/f01833f4/


:: 1st delete any possible left-overs from previous SFX builds to make sure we only have new stuff
if exist ..\SFX_Output\ETHZ_EC_Winx64.exe del ..\SFX_Output\ETHZ_EC_Winx64.exe 
if exist .\Installer.7z del .\Installer.7z

:: 2nd create 7z archive from SRC_EC folder that contains newest CMD and the Tools subfolder with manually downloaded/renamed 3rd party tools
".\7za.exe" a -stl .\Installer.7z ..\ETHZ_EC_Winx64\*

:: 3rd add the manifest file to the 7zsd to request admin privs according to https://sourceforge.net/p/sevenzip/discussion/45797/thread/f01833f4/
:: This step has already be done in the distribution since it otherwise requires to have MSFT SDK installed on the machine
:: The '7zsd_All_x64.sfx.ORIGINAL' is the original file and the '7zsd_All_x64.sfx.manifest' is for reference part of the folder too.
:: "C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x64\mt.exe" -nologo -manifest ".\7zsd_All_x64.sfx.manifest" -outputresource:".\7zsd_All_x64.sfx;1"

:: 4rd ceate SFX
copy /B /Y .\7zsd_All_x64.sfx + .\config.txt + .\Installer.7z ..\SFX_Output\ETHZ_EC_Winx64.exe

:: done - have fun with the SFX thanks to 7Zip and Oleg Scherbakov