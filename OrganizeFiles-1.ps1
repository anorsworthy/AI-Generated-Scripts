# PowerShell script to move groups of files into new folders based on the first 5 words of the file group

# Define the source directory containing the files
$sourceDirectory = "C:\Path\To\Source\Directory"

# Create a new directory for each unique file name
$uniqueFileNames = Get-ChildItem -Path $sourceDirectory -File | Select-Object -ExpandProperty BaseName | Sort-Object -Unique
foreach ($fileName in $uniqueFileNames) {
    $newFolderPath = Join-Path -Path $destinationDirectory -ChildPath $fileName
    if (!(Test-Path -Path $newFolderPath)) {
        New-Item -ItemType Directory -Path $newFolderPath
    }
}
# Find all files matching each unique file name and move them into the corresponding folder
foreach ($fileName in $uniqueFileNames) {
    $matchingFiles = Get-ChildItem -Path $sourceDirectory -File | Where-Object { $_.BaseName -eq $fileName }
    $targetFolderPath = Join-Path -Path $destinationDirectory -ChildPath $fileName

    foreach ($file in $matchingFiles) {
        $destinationPath = Join-Path -Path $targetFolderPath -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $destinationPath
    }
}
# Set the destination directory for each file group
$destinationDirectory = $sourceDirectory

# Define the destination directory where folders will be created
$destinationDirectory = "C:\Path\To\Destination\Directory"

# Ensure the destination directory exists
if (!(Test-Path -Path $destinationDirectory)) {
    New-Item -ItemType Directory -Path $destinationDirectory
}

# Get all files in the source directory
$files = Get-ChildItem -Path $sourceDirectory -File

    $groupKey
}

# Process each group
foreach ($group in $groupedFiles) {
    $folderName = $group.Name
    $folderPath = Join-Path -Path $destinationDirectory -ChildPath $folderName

    # Create a new folder for the group if it doesn't exist
    if (!(Test-Path -Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath
    }

    # Move each file in the group to the new folder
    foreach ($file in $group.Group) {
        $destinationPath = Join-Path -Path $folderPath -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $destinationPath
    }
}

Write-Host "Files have been grouped and moved into folders successfully."