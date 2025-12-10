<#
copy-profile.ps1

Usage:
  - Double-click or run from PowerShell:
      powershell -ExecutionPolicy Bypass -File .\scripts\copy-profile.ps1
  - Or pass a custom source image path as the first argument:
      powershell -ExecutionPolicy Bypass -File .\scripts\copy-profile.ps1 'C:\path\to\image.jpg'

What it does:
  1) Backs up existing images\profile.jpg (if any) into images\backups with a timestamp.
  2) Copies the source image into images\profile.jpg.
  3) If ImageMagick is installed, crops/resizes profile to 400x400 and creates a project thumbnail images\simple-name.jpg (600x360).
  4) Opens the site pages for verification.
#>

param(
    [string]$SourceImage = 'C:\Users\HP\OneDrive\Desktop\sneha.jpg'
)

# Determine paths relative to this script's folder
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$siteRoot = Resolve-Path (Join-Path $scriptDir '..')
$imagesDir = Join-Path $siteRoot 'images'
$destProfile = Join-Path $imagesDir 'profile.jpg'
$backupDir = Join-Path $imagesDir 'backups'
$projectThumb = Join-Path $imagesDir 'simple-name.jpg'

# Ensure images folder exists
if (-not (Test-Path $imagesDir)) {
    Write-Host "Creating images directory: $imagesDir"
    New-Item -ItemType Directory -Path $imagesDir | Out-Null
}

# Ensure backup folder exists
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

# Validate source
if (-not (Test-Path $SourceImage)) {
    Write-Error "Source image not found: $SourceImage"
    exit 1
}

# Backup existing profile.jpg if present
if (Test-Path $destProfile) {
    $ts = Get-Date -Format 'yyyyMMdd_HHmmss'
    $base = [IO.Path]::GetFileNameWithoutExtension($destProfile)
    $ext = [IO.Path]::GetExtension($destProfile)
    $backupPath = Join-Path $backupDir ("$base`_$ts$ext")
    Copy-Item -Path $destProfile -Destination $backupPath -Force
    Write-Host "Backed up existing profile to: $backupPath"
}

# Copy new profile image
Copy-Item -Path $SourceImage -Destination $destProfile -Force
Write-Host "Copied image to: $destProfile"

# If ImageMagick is available, create cropped/resized versions
if (Get-Command magick -ErrorAction SilentlyContinue) {
    try {
        Write-Host "ImageMagick detected — creating cropped profile (400x400) and project thumbnail (600x360)..."
        magick $destProfile -auto-orient -resize 400x400^ -gravity center -extent 400x400 $destProfile
        magick $destProfile -auto-orient -resize 600x360^ -gravity center -extent 600x360 $projectThumb
        Write-Host "Created: $destProfile and $projectThumb"
    }
    catch {
        Write-Warning ("ImageMagick processing failed: {0}" -f $_.Exception.Message)
    }
}
else {
    Write-Host "ImageMagick not found. Skipping resize/crop. Install ImageMagick if you want automatic thumbnail creation."
}

# Open pages for verification
Start-Process (Join-Path $siteRoot 'index.html')
Start-Process (Join-Path $siteRoot 'resume.html')
Start-Process (Join-Path $siteRoot 'biodata.html')

Write-Host "Done. If you want to use a different source image, re-run the script with the path as the first argument."
Write-Host "Done"
