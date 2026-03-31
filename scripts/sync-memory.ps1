$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== CodexAgent Memory Sync ==="
Write-Host ""

# Load config
$configPath = "C:\AIAgent-Codex\config\agent-config.json"

if (-not (Test-Path $configPath)) {
    Write-Host "ERROR: Config file not found at $configPath"
    exit 1
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json

# Validate required config
if (-not $config.localRoot) {
    Write-Host "ERROR: localRoot is missing in agent-config.json"
    exit 1
}

if (-not $config.files.taskLog) {
    Write-Host "ERROR: files.taskLog is missing in agent-config.json"
    exit 1
}

if (-not $config.awsProfile) {
    Write-Host "ERROR: awsProfile is missing in agent-config.json"
    exit 1
}

if (-not $config.s3Bucket) {
    Write-Host "ERROR: s3Bucket is missing in agent-config.json"
    exit 1
}

# Build paths
$localRoot = $config.localRoot
$taskLogFile = $config.files.taskLog
$awsProfile = $config.awsProfile
$s3Bucket = $config.s3Bucket

$localTaskLogPath = Join-Path $localRoot $taskLogFile
$s3TargetPath = "s3://$s3Bucket/memory/$taskLogFile"

Write-Host "Agent Name   : $($config.agentName)"
Write-Host "Local File   : $localTaskLogPath"
Write-Host "AWS Profile  : $awsProfile"
Write-Host "S3 Target    : $s3TargetPath"
Write-Host ""

# Check local file exists
if (-not (Test-Path $localTaskLogPath)) {
    Write-Host "ERROR: Local task log file not found at $localTaskLogPath"
    exit 1
}

# Upload to S3
Write-Host "Uploading file to S3..."
aws s3 cp $localTaskLogPath $s3TargetPath --profile $awsProfile

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Upload failed."
    exit 1
}

Write-Host ""
Write-Host "Memory sync completed successfully."
Write-Host ""