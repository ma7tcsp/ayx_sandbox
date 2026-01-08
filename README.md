## Aim
Spin up a Windows Sandbox and automatically install an Alteryx Desktop version of your choice ready for activation. 

## Instructions

- Copy the contents of the repo somewhere on your local machine. 
- Copy the contents of the repo somewhere on your local machine. 
- Place a copy of the Alteryx Installer in the same folder. 
- Run the ***SandboxTemplateSetup.ps1*** script (right-click, *Run with PowerShell*) to generate the Windows Sandbox configuration file. (This script runs as an admin, and if you're asked to, allow it when it runs)
- Run the resulant wsb file to launch the sandbox environment. 
- Wait while everything installs, usually about 15 mins. 
- Put the kettle on

## How

### Locally
*SandboxTemplateSetup.ps1* helps create a *wsb* from the *SandboxTemplate.wsb* config. There are a few options which can be configured. 

First the script checks to see if Windows Sandbox is enabled. If it's not you can install it from the script. A reboot is required. 

The current sandbox path is where you are going to run your wsb from. It defaults to the current location, but you could change this if you wish to create other templates in other folders.
Generally the default is what should be used. This create a folder on the desktop which contains all the files in this folder and importantly whatever Alteryx Installer you have in place. 

You can optionally map your Documents folder (read-only) to be accessible inside the sandbox environment under the sandbox user's documents. Handy if you want to use existing Alteryx flows in the new sandbox environment. 

The sandbox machine will find the latest Alteryx installer in the folder and use this for the install. If you have multiple versions the script will indicate which version will be installed. 
If there is no Alteryx installer in the installer you will receive a warning. 

The default name of the *wsb* the setup creates is *sandbox1.wsb* but you can enter any name you want here. 

You can then automatically launch the *wsb* from the script, or if you wish run is later manually by simply double-clicking the *wsb* file. 

**NB** You don't have to use the *SandboxTemplateSetup.ps1* at all to create the *wsb* files, you can manually configure them if you want. 

### In the Sandbox

The included wsb template launches the sandbox1.ps1 inside the sandbox environment and does a few things 
- Installs WinGet for ease of installing programs
- Installs Chrome
- Installs notepad++ and also restores default Windows notepad as sets .txt associations. (notepad doesn't exist in sandbox by default any more)
- Installs Microsoft Edge WebView2. This runtime is needed in order to install - Alteryx but not included in the sandbox or the Alteryx installer 
- Installs Alteryx desktop
- Finally makes some tweaks to explorer showing hidden files and showing file extensions by default
