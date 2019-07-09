Param(
   [Parameter(Mandatory=$true)]
   [string]$output_file
)

#get date and time 3 days / 72 hrs back from now 
$time = (Get-Date).AddDays(-3)

#now search recursive through the file system and search all files and folders that have been changed in the last three days
$mod_files = Get-ChildItem C:\ -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {$_.LastWriteTime -gt $time } | format-table -AutoSize LastWriteTime, FullName

#write the findings into a text file
Out-File -FilePath $output_file -InputObject $mod_files -Width 280