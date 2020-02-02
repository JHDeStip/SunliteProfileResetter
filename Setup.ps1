$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Write-Host 'This script must be ran as administrator!'
	Read-Host
	Exit
}

$installDir = "$env:SystemDrive\SunliteProfilesResetter"
$resetProfilesFileName = 'ResetProfiles.ps1'
$globalXmlFileName = '_global.xml'
$powerShellPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"

if (Test-Path($installDir)) {
	Remove-Item -Force -Recurse $installDir
}

New-Item -Type Directory -Force -Path $installDir
Copy-Item -Force -Path "$PSScriptRoot/$resetProfilesFileName" -Destination $installDir
Copy-Item -Force -Path "$PSScriptRoot/$globalXmlFileName" -Destination $installDir
Get-ChildItem -Path $PSScriptRoot -File -Filter '*.shw' |  Copy-Item -Destination $installDir -Force

$resetProfilesTaskName = 'ResetSunliteProfiles'
if (Get-ScheduledTask | Where-Object { $_.TaskName -eq $resetProfilesTaskName }) {
	Unregister-ScheduledTask -TaskName $resetProfilesTaskName -Confirm:$false
}
$resetProfilesTaskAction = New-ScheduledTaskAction -Execute $powerShellPath -Argument "-NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -File `"$installDir\$resetProfilesFileName`""
$resetProfilesTaskTrigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -Action $resetProfilesTaskAction -Trigger $resetProfilesTaskTrigger -RunLevel Highest -TaskName $resetProfilesTaskName -Description 'Reset Sunlite profiles on every login.'