#choco install notepadplusplus -y | out-null
winget install Notepad++.Notepad++ --silent --force --accept-source-agreements --disable-interactivity --source winget | Out-Null
 
copy "C:\Users\WDAGUtilityAccount\tmp_install\notepad.exe" "$env:SystemRoot\System32\notepad.exe"
reg import "C:\Users\WDAGUtilityAccount\Desktop\Install\reg_np.reg"
