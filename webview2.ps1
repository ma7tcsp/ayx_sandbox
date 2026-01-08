# the alteryx installer doesn't seem to include the webview2 binaries so install these manually
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/p/?LinkId=2124703" -OutFile "$env:Temp\wv2.exe"
Start-Process -FilePath "$env:Temp\wv2.exe" -ArgumentList "/silent", "/install" -Wait