# scripts/copy-profile.ps1

This README explains the `copy-profile.ps1` helper script included in this project.

Purpose
- Back up any existing `images/profile.jpg` to `images/backups/` with a timestamp.
- Copy a specified source image into `images/profile.jpg` (site uses this image on `index.html`, `resume.html`, and `biodata.html`).
- Optionally crop/resize the image and generate a project thumbnail `images/simple-name.jpg` using ImageMagick (if installed).

Files
- `scripts/copy-profile.ps1` — PowerShell script that performs the steps above.

Quick usage
1. From the project root, run (recommended):

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\copy-profile.ps1 'C:\Users\HP\OneDrive\Desktop\sneha.jpg'
```

- If you omit the source path, the script defaults to `C:\Users\HP\OneDrive\Desktop\sneha.jpg`.

One-line commands (alternative)
```powershell
# Back up current profile.jpg (if any) and copy your Desktop image into the site
$dest='C:\Users\HP\OneDrive\Documents\MyWebsite[1]\images\profile.jpg'; $backup=Join-Path (Split-Path $dest) 'backups'; if(-not (Test-Path $backup)){ New-Item -ItemType Directory -Path $backup | Out-Null }; if(Test-Path $dest){ $ts=Get-Date -Format 'yyyyMMdd_HHmmss'; $b=[IO.Path]::GetFileNameWithoutExtension($dest); $e=[IO.Path]::GetExtension($dest); Copy-Item $dest (Join-Path $backup "$b`_$ts$e") -Force; Write-Host 'Backed up existing profile.jpg' }
Copy-Item 'C:\Users\HP\OneDrive\Desktop\sneha.jpg' -Destination $dest -Force
```

Optional: resize / crop using ImageMagick
- If ImageMagick is installed and available as `magick` the script will
  - crop/resize `images/profile.jpg` to `400x400` (square profile image)
  - create `images/simple-name.jpg` sized `600x360` for the project thumbnail

Install ImageMagick: https://imagemagick.org

Manual ImageMagick commands
```powershell
# Resize to square 400x400
magick 'C:\Users\HP\OneDrive\Documents\MyWebsite[1]\images\profile.jpg' -auto-orient -resize 400x400^ -gravity center -extent 400x400 'C:\Users\HP\OneDrive\Documents\MyWebsite[1]\images\profile.jpg'
# Create project thumbnail 600x360
magick 'C:\Users\HP\OneDrive\Documents\MyWebsite[1]\images\profile.jpg' -auto-orient -resize 600x360^ -gravity center -extent 600x360 'C:\Users\HP\OneDrive\Documents\MyWebsite[1]\images\simple-name.jpg'
```

Notes

Troubleshooting
 The script creates `images/backups/` and stores previous `profile.jpg` files with timestamps so you can revert if needed.
 The script opens `index.html`, `resume.html`, and `biodata.html` at the end so you can check the result quickly.
 If you'd like different thumbnail sizes or filenames, edit the script accordingly or ask me to update it.
- Permission errors: run PowerShell as the same user who owns the files and ensure `ExecutionPolicy` allows running scripts, or run with the `-ExecutionPolicy Bypass` flag as shown above.
- ImageMagick not found: install or remove the resize step if you don't want automatic resizing.

 If you want, I can also:
 - Add a shorter wrapper script (e.g., `scripts/install-photo.ps1`) that prompts for a source path.
 - Add a commit-ready `gitignore` entry suggestion for `images/backups/` if you don't want backups committed to your repository.

Interactive installer
---------------------
If you prefer to be prompted for the image path instead of passing it on the command line, use the interactive wrapper:

```powershell
# from project root
powershell -ExecutionPolicy Bypass -File .\scripts\install-photo.ps1
```

The interactive script will ask for the image path (press Enter to accept the default `C:\Users\HP\OneDrive\Desktop\sneha.jpg`) and then call `copy-profile.ps1` to perform the backup/copy and optional ImageMagick resizing.

Note: `scripts\install-photo.ps1` was added alongside `copy-profile.ps1` and requires no additional arguments.
