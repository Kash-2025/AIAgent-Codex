$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== CodexAgent Task List ==="
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

if (-not (Test-Path $taskLogPath)) {
    Write-Host "ERROR: Task log file not found at $taskLogPath"
    exit 1
}

if ((Get-Item $taskLogPath).Length -eq 0) {
    Write-Host "No tasks found. tasks-log.json is empty."
    exit 0
}

$tasks = Get-Content $taskLogPath -Raw | ConvertFrom-Json
$taskList = @($tasks)

if ($taskList.Count -eq 0) {
    Write-Host "No tasks found."
    exit 0
}

$taskList |
    Select-Object id, task, status, createdAt |
    Format-Table -AutoSize

Write-Host ""
Write-Host "Total tasks: $($taskList.Count)"
Write-Host ""