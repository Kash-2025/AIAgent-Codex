param(
    [Parameter(Mandatory = $true)]
    [string]$Id
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== CodexAgent Remove Task ==="
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
    Write-Host "ERROR: Task log is empty."
    exit 1
}

$tasks = Get-Content $taskLogPath -Raw | ConvertFrom-Json
$taskList = @($tasks)

$remainingTasks = $taskList | Where-Object { $_.id -ne $Id }

if ($remainingTasks.Count -eq $taskList.Count) {
    Write-Host "ERROR: No task found with ID $Id"
    exit 1
}

$remainingTasks | ConvertTo-Json -Depth 5 | Set-Content $taskLogPath

Write-Host "Task removed successfully."
Write-Host "ID      : $Id"
Write-Host ""