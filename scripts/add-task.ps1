param(
    [Parameter(Mandatory = $true)]
    [string]$Task
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== CodexAgent Add Task ==="
Write-Host ""

$configPath = "C:\AIAgent-Codex\config\agent-config.json"

if (-not (Test-Path $configPath)) {
    Write-Host "ERROR: Config file not found at $configPath"
    exit 1
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json

if (-not $config.localRoot) {
    Write-Host "ERROR: localRoot is missing in agent-config.json"
    exit 1
}

if (-not $config.files.taskLog) {
    Write-Host "ERROR: files.taskLog is missing in agent-config.json"
    exit 1
}

$taskLogPath = Join-Path $config.localRoot $config.files.taskLog

# Build new task entry
$newTask = [PSCustomObject]@{
    id        = [guid]::NewGuid().ToString()
    task      = $Task
    status    = "pending"
    createdAt = (Get-Date).ToString("s")
}

# Load existing file
if ((Test-Path $taskLogPath) -and ((Get-Item $taskLogPath).Length -gt 0)) {
    $existingContent = Get-Content $taskLogPath -Raw | ConvertFrom-Json
    $taskList = @($existingContent)
} else {
    $taskList = @()
}

# Add new task
$taskList += $newTask

# Save back to file
$taskList | ConvertTo-Json -Depth 5 | Set-Content $taskLogPath

Write-Host "Added task successfully:"
Write-Host "Task      : $Task"
Write-Host "File      : $taskLogPath"
Write-Host ""