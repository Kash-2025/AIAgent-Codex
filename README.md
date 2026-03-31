\# CodexAgent



This is my AI agent system built using:



\- AWS (S3 for memory)

\- GitHub (version control)

\- PowerShell (automation scripts)



\---



\## What it does



\- Stores tasks in a JSON file

\- Lets me add, update, remove tasks

\- Syncs task memory to AWS S3



\---



\## How to use



\### Add a task

.\\scripts\\add-task.ps1 -Task "New task"



\### View tasks

.\\scripts\\list-tasks.ps1



\### Update a task

.\\scripts\\update-task-status.ps1 -Id "TASK-ID" -Status "done"



\### Remove a task

.\\scripts\\remove-task.ps1 -Id "TASK-ID"



\### Sync to AWS

.\\scripts\\sync-memory.ps1



\---



\## Project structure



\- config → settings

\- scripts → automation scripts

\- tasks-log.json → task memory



\---



\## Author



Kash Hussain  

https://github.com/Kash-2025

