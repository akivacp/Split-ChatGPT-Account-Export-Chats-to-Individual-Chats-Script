# Step 1: File Picker and Split

# Open File Picker Dialog (using Windows standard dialog)
Add-Type -AssemblyName System.Windows.Forms
function Select-FileDialog {
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = "Select the conversations.json file"
    $dialog.Filter = "JSON Files (*.json)|*.json|All Files (*.*)|*.*"
    $dialog.ShowDialog() | Out-Null
    return $dialog.FileName
}

# Ask for file containing the JSON
$InputFile = Select-FileDialog
if (-not $InputFile) {
    Write-Host "No file selected. Exiting."
    exit
}

Write-Host "[INFO] Selected File: $InputFile"

# Install jq if it's not already installed
if (-not (Get-Command jq -ErrorAction SilentlyContinue)) {
    Write-Host "[INFO] jq not found. Installing jq..."
    winget install jqlang.jq 
}

# Create split directory if it doesn't exist
$OutputDir = Join-Path (Split-Path $InputFile) "split"
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Counter for fallback names
$i = 0

# Split the conversations
jq -c '.[]' $InputFile | ForEach-Object {
    $json = $_ | ConvertFrom-Json

    # Extract title
    $title = $json.title
    if ([string]::IsNullOrWhiteSpace($title)) {
        $title = "untitled"
    }

    # Sanitize title for filename
    $safeTitle = ($title -replace '[^a-zA-Z0-9\- ]', '') -replace '\s+', '-'

    # Convert Unix time to readable format
    $unix = $json.create_time
    $epoch = Get-Date -Date "1970-01-01 00:00:00Z"
    $date = $epoch.AddSeconds([double]$unix).ToLocalTime()
    $formattedDate = $date.ToString("yyyy-MM-dd_HH-mm-ss")

    # Build output filename
    $fileName = "${formattedDate}_${safeTitle}.json"
    $filePath = Join-Path $OutputDir $fileName

    # If duplicate, append index
    while (Test-Path $filePath) {
        $i++
        $fileName = "${formattedDate}_${safeTitle}_$i.json"
        $filePath = Join-Path $OutputDir $fileName
    }

    # Save the file
    $json | ConvertTo-Json -Depth 100 | Out-File -Encoding UTF8 $filePath
    Write-Host "[INFO] Saved: $filePath"
}

# Step 2: Multiverse Conversion

# Create output folder for multiverse final files
$MultiverseDir = Join-Path (Split-Path $InputFile) "multiverseFinal"
if (!(Test-Path $MultiverseDir)) {
    New-Item -ItemType Directory -Path $MultiverseDir | Out-Null
}

# Get all the split files
$splitFiles = Get-ChildItem -Path $OutputDir -Filter "*.json"
if ($splitFiles.Count -eq 0) {
    Write-Host "[ERROR] No files found in split folder. Exiting."
    exit 1
}

# Process each split file and convert it to the multiverse format
foreach ($file in $splitFiles) {
    Write-Host "[INFO] Processing: $($file.Name)"

    try {
        $raw = Get-Content -Path $file.FullName -Raw
        $json = $raw | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Write-Warning "[ERROR] Could not parse: $($file.Name)   Skipping."
        continue
    }

    # Convert to multiverse format
    $mapping = $json.mapping
    $current = $json.current_node

    if (-not $current -and $mapping) {
        $current = ($mapping.Keys)[-1]
    }

    $converted = [ordered]@{
        title           = $json.title
        create_time     = $json.create_time
        update_time     = $json.update_time
        mapping         = $mapping
        current_node    = $current
        conversation_id = $json.conversation_id
    }

    # Save converted file
    $outPath = Join-Path $MultiverseDir ($file.BaseName + "_multiverse.json")
    $converted | ConvertTo-Json -Depth 100 | Out-File -Encoding UTF8 $outPath
    Write-Host "[INFO] Saved: $outPath"
}

Write-Host "[INFO] Multiverse conversion complete."
