$servers = "server4", "server", "server2", "server3"

$scriptblock =
{
$Sysinfo = systeminfo 
$ipconfig = ipconfig /all
$routes = route print
$RegInfo = (Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\" -Name BuildLabEx, EditionID) | Select-Object BuildLabEx, EditionID
$Sysinfo, $ipconfig, $routes, $RegInfo
}
 
foreach ($server in $servers)
{
invoke-command -computerName $Server -scriptblock $scriptblock -AsJob -ThrottleLimit 1
 
}
 
foreach ( $job in get-job | Wait-Job)
{
try {
$data = Receive-Job -Name $job.Name -ErrorAction Stop
$date = Get-Date -Format yyyy-MM-dd
$file = $job.Location +"_"+$date +".txt"
$data | Out-File $file
    }

catch {
$_.Exception 
    }

}
 
Get-job | Remove-Job