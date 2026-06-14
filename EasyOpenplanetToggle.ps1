<#
Easy OpenPlanet Toggle Script
Author: Griftz & ChatGPT :^)
Version: 1.0 - 14/06/26
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Check if Trackmania is running
if (Get-Process -Name "Trackmania" -ErrorAction SilentlyContinue) {
    [System.Windows.Forms.MessageBox]::Show(
        "Please close Trackmania before changing Openplanet status.",
        "Trackmania Running",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    exit
}

# Variables populated after a valid Trackmania folder is selected
$script:gameDir = $null
$script:enabledFile = $null
$script:disabledFile = $null

# Check if the script is already in the Trackmania folder
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$trackmaniaExe = Join-Path $scriptDir "Trackmania.exe"

if (Test-Path $trackmaniaExe) {
    $script:gameDir = $scriptDir
    $script:enabledFile = Join-Path $scriptDir "dinput8.dll"
    $script:disabledFile = Join-Path $scriptDir "dinput8.dll-DISABLED"
}

function Update-OpenplanetStatus {

    if (-not $script:gameDir) {
        $statusValue.Text = "No Folder Selected"
        $statusValue.ForeColor = [System.Drawing.Color]::Gray
        return
    }

    if (Test-Path $script:enabledFile) {
        $statusValue.Text = "Enabled"
        $statusValue.ForeColor = [System.Drawing.Color]::Green
    }
    elseif (Test-Path $script:disabledFile) {
        $statusValue.Text = "Disabled"
        $statusValue.ForeColor = [System.Drawing.Color]::Red
    }
    else {
        $statusValue.Text = "Openplanet Not Found"
        $statusValue.ForeColor = [System.Drawing.Color]::DarkOrange
    }
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "Easy OpenPlanet Toggle"
$form.Size = New-Object System.Drawing.Size(360,250)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Trackmania folder label
$folderLabel = New-Object System.Windows.Forms.Label
$folderLabel.Text = "Trackmania Folder:"
$folderLabel.AutoSize = $true
$folderLabel.Location = New-Object System.Drawing.Point(20,20)

# Selected folder display
$folderPathLabel = New-Object System.Windows.Forms.Label
$folderPathLabel.AutoSize = $false
$folderPathLabel.Size = New-Object System.Drawing.Size(220,40)
$folderPathLabel.Location = New-Object System.Drawing.Point(20,45)

if ($script:gameDir) {
    $folderPathLabel.Text = $script:gameDir
}
else {
    $folderPathLabel.Text = "No folder selected"
}

# Browse button
$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "Browse..."
$btnBrowse.Size = New-Object System.Drawing.Size(90,30)
$btnBrowse.Location = New-Object System.Drawing.Point(245,40)

# Status Label Title
$statusTitle = New-Object System.Windows.Forms.Label
$statusTitle.Text = "Openplanet Status:"
$statusTitle.AutoSize = $true
$statusTitle.Location = New-Object System.Drawing.Point(20,95)

# Status Value
$statusValue = New-Object System.Windows.Forms.Label
$statusValue.AutoSize = $true
$statusValue.Font = New-Object System.Drawing.Font(
    "Segoe UI",
    10,
    [System.Drawing.FontStyle]::Bold
)
$statusValue.Location = New-Object System.Drawing.Point(140,93)
$statusValue.Text = "No Folder Selected"
$statusValue.ForeColor = [System.Drawing.Color]::Gray

# Disable Button
$btnDisable = New-Object System.Windows.Forms.Button
$btnDisable.Text = "Disable Openplanet"
$btnDisable.Size = New-Object System.Drawing.Size(140,40)
$btnDisable.Location = New-Object System.Drawing.Point(20,140)
$btnDisable.Enabled = $false

# Enable Button
$btnEnable = New-Object System.Windows.Forms.Button
$btnEnable.Text = "Enable Openplanet"
$btnEnable.Size = New-Object System.Drawing.Size(140,40)
$btnEnable.Location = New-Object System.Drawing.Point(180,140)
$btnEnable.Enabled = $false

# Automatically enable controls if script is already in Trackmania folder
if ($script:gameDir) {
    $btnEnable.Enabled = $true
    $btnDisable.Enabled = $true
}

# Browse for Trackmania folder
$btnBrowse.Add_Click({

    while ($true) {

        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $dialog.Description = "Select the folder containing Trackmania.exe"

        if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
            break
        }

        $selectedFolder = $dialog.SelectedPath
        $trackmaniaExe = Join-Path $selectedFolder "Trackmania.exe"

        if (Test-Path $trackmaniaExe) {

            $script:gameDir = $selectedFolder
            $script:enabledFile = Join-Path $selectedFolder "dinput8.dll"
            $script:disabledFile = Join-Path $selectedFolder "dinput8.dll-DISABLED"

            $folderPathLabel.Text = $selectedFolder

            $btnEnable.Enabled = $true
            $btnDisable.Enabled = $true

            Update-OpenplanetStatus
            break
        }

        $retry = [System.Windows.Forms.MessageBox]::Show(
            "Trackmania.exe was not found in:`n`n$selectedFolder`n`nWould you like to try again?",
            "Trackmania Not Found",
            [System.Windows.Forms.MessageBoxButtons]::RetryCancel,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )

        if ($retry -eq [System.Windows.Forms.DialogResult]::Cancel) {
            break
        }
    }
})

# Disable Openplanet
$btnDisable.Add_Click({

    if (-not $script:gameDir) {
        return
    }

    if (Test-Path $script:enabledFile) {

        Rename-Item `
            -Path $script:enabledFile `
            -NewName "dinput8.dll-DISABLED"

        [System.Windows.Forms.MessageBox]::Show(
            "Openplanet disabled.`nNew file name: dinput8.dll-DISABLED",
            "Openplanet Status"
        )

        Update-OpenplanetStatus
    }
    else {

        [System.Windows.Forms.MessageBox]::Show(
            "Openplanet is already disabled.",
            "Openplanet Status"
        )
    }
})

# Enable Openplanet
$btnEnable.Add_Click({

    if (-not $script:gameDir) {
        return
    }

    if (Test-Path $script:disabledFile) {

        Rename-Item `
            -Path $script:disabledFile `
            -NewName "dinput8.dll"

        [System.Windows.Forms.MessageBox]::Show(
            "Openplanet enabled.`nNew file name: dinput8.dll",
            "Openplanet Status"
        )

        Update-OpenplanetStatus
    }
    elseif (Test-Path $script:enabledFile) {

        [System.Windows.Forms.MessageBox]::Show(
            "Openplanet is already enabled.",
            "Openplanet Status"
        )
    }
    else {

        [System.Windows.Forms.MessageBox]::Show(
            "Cannot enable Openplanet. dinput8.dll-DISABLED was not found.",
            "Openplanet Status"
        )
    }
})

$form.Controls.Add($folderLabel)
$form.Controls.Add($folderPathLabel)
$form.Controls.Add($btnBrowse)
$form.Controls.Add($statusTitle)
$form.Controls.Add($statusValue)
$form.Controls.Add($btnDisable)
$form.Controls.Add($btnEnable)

Update-OpenplanetStatus

[void]$form.ShowDialog()