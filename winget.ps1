$progressPreference = 'silentlyContinue'
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module Microsoft.WinGet.Client -Force | Out-Null
Import-Module Microsoft.WinGet.Client | Out-Null
Repair-WinGetPackageManager -Force | Out-Null