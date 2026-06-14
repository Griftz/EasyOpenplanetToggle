# What is this for?
With the number of events that require Openplanet to be disabled to participate in, and a file rename being the easiest & supported method to quickly disable it [^1] - Here is a PowerShell script to easily toggle the status with simple buttons for enable/disable.

> [!IMPORTANT]
>This is a **PowerShell** script, you will need to run the script with PowerShell.. not Notepad ;)

<br/><br/>
# How to Install
1. Download the latest release
3. Run **EasyOpenplanetToggle.ps1**

> [!TIP]
> If you place the script in the **Trackmania.exe** directory, it won't prompt to browse to the **Trackmania.exe** directory and automatically proceed to run the script.
> The default Trackmania.exe directory is one of the below:
> * **Ubisoft Connect:** C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\games\Trackmania
> * **Epic Games:** C:\Program Files\Epic Games\Trackmania
> * **Steam:** C:\Program Files (x86)\Steam\steamapps\common\Trackmania

<br/><br/>

# How it works
## Main Window
* Browse - Used to browse to your **Trackmania.exe** directory
* Enable - Enables Openplanet
* Disable - Disabled Openplanet
<img width="336" height="221" alt="image" src="https://github.com/user-attachments/assets/e4aebeae-dba1-458f-b427-0224aab43755" />

<br/><br/>

## Enable button
> [!CAUTION]
> If you have already renamed **dinput8.dll** to another name to disable Openplanet, the script will say it cannot find the file and not be able to change the status.<br/><br/>
> Change the filename back to **dinput8.dll** to proceed.
* Checks if **dinput8.dll** already exists, passes as Enabled if so
<img width="338" height="232" alt="image" src="https://github.com/user-attachments/assets/3f40c155-ed20-4c4a-9946-ff8eb49cdc15" />

* Checks if **dinput8.dll-DISABLED** exists, renames the file back to **dinput8.dll** if so
<img width="338" height="232" alt="image" src="https://github.com/user-attachments/assets/da0ffc55-3e72-42cd-aded-341efdc2c6a2" />
<img width="338" height="229" alt="image" src="https://github.com/user-attachments/assets/b92ae4ea-4a1e-4aeb-8319-4b27336efd78" />

<br/><br/>
## Disable button
* Checks if **dinput8.dll-DISABLED** already exists, passes as Disabled if so
<img width="337" height="235" alt="image" src="https://github.com/user-attachments/assets/e2544826-59ab-4df7-89b1-cf6ba94bebb6" />

* Checks if **dinput8.dll** exists,  renames the file to **dinput8.dll-DISABLED** if so
<img width="337" height="236" alt="image" src="https://github.com/user-attachments/assets/57fccb0f-0cf7-4f69-95cc-4c72a1d1be1d" />
<img width="337" height="232" alt="image" src="https://github.com/user-attachments/assets/577a1a4c-9fb6-48aa-95c4-b3456e9305f6" />


[^1]: Openplanet tutorial on how to temporarily disable Openplanet by renaming **dinput8.dll** - https://openplanet.dev/docs/tutorials/noop
