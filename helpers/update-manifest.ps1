$ErrorActionPreference = "Stop"

$manifestPath = "manifest.json"
$dataDir = "data"

if (!(Test-Path $manifestPath)) {
    throw "manifest.json not found"
}

if (!(Test-Path $dataDir)) {
    throw "data directory not found"
}

# Load manifest
$manifest = Get-Content $manifestPath | ConvertFrom-Json

if (-not $manifest.files) {
    $manifest | Add-Member -MemberType NoteProperty -Name files -Value @{}
}

# Hash all txt files
$files = Get-ChildItem $dataDir -Filter *.txt

$hashMap = @{}

foreach ($file in $files) {
    $hash = (Get-FileHash $file.FullName -Algorithm SHA256).Hash.ToLower()
    $hashMap[$file.Name] = "sha256:$hash"
    Write-Host "Hashed $($file.Name)"
}

$manifest.files = $hashMap

# Bump dataVersion
$manifest.dataVersion = (Get-Date -Format "yyyy.MM.dd")

# Write manifest back (pretty JSON)
$manifest | ConvertTo-Json -Depth 10 | Out-File $manifestPath -Encoding utf8

Write-Host "manifest.json updated successfully"
