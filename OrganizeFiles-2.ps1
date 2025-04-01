# Define the source directory
$sourceDir = "C:\Path\To\Your\Directory"

# Get all files in the directory
$files = Get-ChildItem -Path $sourceDir -File

# Process each unique file name (without extension)
$uniqueFileNames = $files | ForEach-Object { $_.BaseName } | Sort-Object -Unique

foreach ($fileName in $uniqueFileNames) {
    # Create a new folder for the unique file name
    $newFolder = Join-Path -Path $sourceDir -ChildPath $fileName
    if (-not (Test-Path -Path $newFolder)) {
        New-Item -Path $newFolder -ItemType Directory | Out-Null
    }

    # Move matching files into the new folder
    $matchingFiles = $files | Where-Object { $_.BaseName -eq $fileName }
    foreach ($file in $matchingFiles) {
        Move-Item -Path $file.FullName -Destination $newFolder
    }
}

Write-Host "Files have been organized into folders."