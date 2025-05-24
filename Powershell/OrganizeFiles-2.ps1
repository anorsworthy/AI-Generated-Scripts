param (
    [string]$sourceDir = "C:\Path\To\Your\Directory"
)

if (-not (Test-Path -Path $sourceDir)) {
    Write-Error "The specified directory does not exist: $sourceDir"
    exit 1
}

$files = Get-ChildItem -Path $sourceDir -File
$uniqueFileNames = $files | ForEach-Object { $_.BaseName } | Sort-Object -Unique

foreach ($fileName in $uniqueFileNames) {
    $newFolder = Join-Path -Path $sourceDir -ChildPath $fileName
    if (-not (Test-Path -Path $newFolder)) {
        try {
            New-Item -Path $newFolder -ItemType Directory -ErrorAction Stop | Out-Null
            Write-Host "Created folder: $newFolder"
        } catch {
            Write-Warning "Failed to create folder $newFolder: $_"
            continue
        }
    }

    $matchingFiles = $files | Where-Object { $_.BaseName -eq $fileName }
    foreach ($file in $matchingFiles) {
        $destinationPath = Join-Path -Path $newFolder -ChildPath $file.Name
        if (Test-Path -Path $destinationPath) {
            Write-Warning "File already exists and will not be overwritten: $destinationPath"
            continue
        }
        try {
            Move-Item -Path $file.FullName -Destination $newFolder -ErrorAction Stop
            Write-Host "Moved '$($file.Name)' to '$newFolder'"
        } catch {
            Write-Warning "Failed to move $($file.FullName): $_"
        }
    }
}

Write-Host "Files have been organized into folders."