#choco install googlechrome -y | out-null
winget install Google.Chrome --silent --force --accept-source-agreements --disable-interactivity --source winget | Out-Null
#set chrome to default - horrible fudge
Start-Process ms-settings:defaultapps
Start-Sleep -Milliseconds 1000
Add-Type -AssemblyName 'System.Windows.Forms'
[System.Windows.Forms.SendKeys]::SendWait('{TAB}'); Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait('{TAB}'); Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait('{TAB}'); Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait('{TAB}'); Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait('{TAB}'); Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait('chrome'); Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait('{TAB}'); Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}'); Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}'); Start-Sleep -Milliseconds 200
[System.Windows.Forms.SendKeys]::SendWait('%{F4}'); Start-Sleep -Milliseconds 200
#force chrome to not ask you to sign in
mkdir "C:\Users\WDAGUtilityAccount\AppData\Local\Google\Chrome\User Data"
New-Item "C:\Users\WDAGUtilityAccount\AppData\Local\Google\Chrome\User Data\First Run"