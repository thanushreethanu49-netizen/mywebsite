<#
install-photo.ps1
Interactive wrapper to install a profile image into the site.

Usage:
  powershell -ExecutionPolicy Bypass -File .\scripts\install-photo.ps1

The script prompts for a source image path (press Enter to use the default Desktop location),
then calls `copy-profile.ps1` to perform the backup/copy and optional ImageMagick resize.
#>

# Default path (change if your Desktop path is different)
$default = 'C:\Users\HP\OneDrive\Desktop\sneha.jpg'

Write-Host "Interactive photo installer"
Write-Host "Press Enter to accept the default path shown in brackets."
$input = Read-Host "Enter full path to the image file [$default]"
if ([string]::IsNullOrWhiteSpace($input)) { $input = $default }

if (-not (Test-Path $input)) {
    Write-Error "File not found: $input"
    exit 1
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$copyScript = Join-Path $scriptDir 'copy-profile.ps1'

if (-not (Test-Path $copyScript)) {
    Write-Error "Required helper script not found: $copyScript"
    exit 1
}

Write-Host "Using source image: $input"
Write-Host "Calling helper script to back up current image and install the new one..."

# Call the helper script with the chosen source path
try {
    & powershell -ExecutionPolicy Bypass -File $copyScript $input
} catch {
    Write-Error "Failed to run copy script: $_"
    exit 1
}

Write-Host "Done. If pages didn't refresh, open your browser and reload the pages to see the new photo."
