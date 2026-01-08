#runs PowerShell as admin and also preserves working directory
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

#start the process
Clear-Host
function Write-HostColored2(){[CmdletBinding()]param([parameter(Position=0, ValueFromPipeline=$true)] [string[]] $t,[switch] $x,[ConsoleColor] $bc = $host.UI.RawUI.BackgroundColor,[ConsoleColor] $fc = $host.UI.RawUI.ForegroundColor);begin{if ($null -ne $t){$t = "$t"}};process {if ($t) {$cfc = $fc;$cbc = $bc;$ks = $t.split("#");$p = $false;foreach($k in $ks) {if (-not $p -and $k -match '^([a-z]*)(:([a-z]+))?$') {try {$cfc = [ConsoleColor] $matches[1];$p = $true} catch {}if ($matches[3]) {try {$cbc = [ConsoleColor] $matches[3];$p = $true} catch {}}if ($p) {continue}};$p = $false;if ($k) {$argsHash = @{};if ([int] $cfc -ne -1) { $argsHash += @{ 'ForegroundColor' = $cfc } };if ([int] $cbc -ne -1) { $argsHash += @{ 'BackgroundColor' = $cbc } };Write-Host -NoNewline @argsHash $k} $cfc = $fc;$cbc = $bc}} if (-not $x) { write-host }}}

Write-HostColored2 "#darkcyan#Sandbox Setup`n#"

$feature = Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM"
$windowsSandboxEnabled = ($feature.State -eq "Enabled")

if ($windowsSandboxEnabled) {
    Write-HostColored2 "Windows Sandbox is #green#ENABLED#, let's continue!`n`n"
} else {
Write-HostColored2 "Windows Sandbox is #red#NOT enabled#. Please enable and re-run.`n"
$answer = Read-Host "Would you like to enable it now? (A reboot will be required) (Y/N)"
$installwsb = $answer -eq 'Y' -or $answer -eq 'y'
if ($installwsb) {
	Write-Host "`nPlease wait while for Windows Sandbox to configure..." 
	Enable-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM" -All -NoRestart
    Write-Host "`nWindows Sandbox enabled. A reboot is required to complete installation."
	Pause
	exit
} else {
write-host "OK, please install Windows Sanbox and re-run this script"
Pause
exit
}

}

$content = Get-Content "SandboxTemplate.wsb" -Raw
$sandbox_folder = (Get-Location).Path
Write-HostColored2 "Location of current sandbox files: #cyan#$sandbox_folder#"


$inputpath = Read-Host "Press Enter to accept current path or enter a new path"
$sandbox_folder = if ([string]::IsNullOrWhiteSpace($inputpath)) {
    $sandbox_folder
} else {
    $input
}
Write-HostColored2 "Selected sandbox folder: #green#$sandbox_folder#"
$content = $content -replace '\{\{SandboxFolder\}\}', $sandbox_folder

$answer = Read-Host "`nDo you want to map your Documents folder (read-only)? (Y/N)"
$mapDocuments = $answer -eq 'Y' -or $answer -eq 'y'
if ($mapDocuments) {
	$mydocs = [Environment]::GetFolderPath("MyDocuments")
    Write-HostColored2 "#green#Documents folder will be mapped (read-only)#"
	Write-HostColored2 "#green#$mydocs#"
	$content = $content -replace '\{\{DocumentsFolder\}\}', $mydocs
	$content = $content -replace '\{\{\<\!\-\-DocumentMapping\}\}', ''
	$content = $content -replace '\{\{DocumentMapping\-\->\}\}', ''
} else {
    Write-HostColored2 "#darkred#Documents folder will not be mapped#"
	$content = $content -replace '\{\{\<\!\-\-DocumentMapping\}\}', '<!--Documents Folder Not Mapped'
	$content = $content -replace '\{\{DocumentMapping\-\->\}\}', '-->'
	$content = $content -replace '\<\!\-\- Create a drive mapping to your documents if you want, or remove this secion \-\-\>', ''
}

write-host "`nAlteryx Desktop installer found to be installed:"

$installer = Get-ChildItem -Path . -Filter "AlteryxInstall*.exe" -File |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1 -ExpandProperty Name

if ($installer ) {
	Write-HostColored2 "#green#$installer#"
} else {
	Write-HostColored2 "#red#No Alteryx installer found, ensure it's placed in the sandbox folder before running the wsb#"
}

$file = "sandbox1.wsb"
$inputfilename = Read-Host "`nPress Enter to accept default filename of sandbox1.wsb or enter a new one"

if ([string]::IsNullOrWhiteSpace($inputfilename)) {
    Write-HostColored2 "Sandbox template file to be created: #green#$file#"
} else {
    $file = $inputfilename
	if ($file -notlike "*.wsb") {
    $file += ".wsb"
}
    Write-HostColored2 "Sandbox template file to be created: #green#$file#"
}

Set-Content $file $content

$answer = Read-Host "`n$file sandbox template file created in this folder. `n`nWould you like to launch it? (Y/N)"
$launch = $answer -eq 'Y' -or $answer -eq 'y'
if ($launch) {
	start-process .\$file
	exit
} else {
    exit
}