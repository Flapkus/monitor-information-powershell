if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) #$myWindowsPrincipal.IsInRole($adminRole))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb runAs
    Exit
}
$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi
$LogFile = "C:\monitor\"
    
 function Decode {
     If ($args[0] -is [System.Array]) {
         [System.Text.Encoding]::ASCII.GetString($args[0])
     }
     Else {
         "Not Found"
     }
 }
    
    
 ForEach ($Monitor in $Monitors) {
     $Manufacturer = Decode $Monitor.ManufacturerName -notmatch 0
     $Name = Decode $Monitor.UserFriendlyName -notmatch 0
     $Serial = Decode ($Monitor.SerialNumberID -notmatch 0)
    
     echo $Manufacturer,$Name,$Serial | Out-File -FilePath C:\monitor.txt -force
     
 }

Write-Host " Manufacturer: $Manufacturer`n","Model: $Name"`n, "Serial Number: $Serial`n"   
Write-Host "`nThe data was saved in - C:\monitors.txt\"
Read-Host -Prompt “`n`nPress Enter to exit”


