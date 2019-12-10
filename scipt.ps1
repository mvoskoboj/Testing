$scriptblock =
{
systeminfo
ipconfig /all
# Reg export "HKLM\Software\Microsoft\Windows NT\CurrentVersion" exportedkey.reg
}
 
foreach ($server in $servers)
{
invoke-command -computerName $Server -scriptblock $scriptblock -AsJob
 
}
 
foreach ( $job in get-job | Wait-Job)
{
$data = Receive-Job -Name $job.Name
$file = $job.Location + ".txt"
$data | Out-File $file
}
 
 
Remove-Job -State Completed