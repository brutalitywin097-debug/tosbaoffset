# update.ps1 - re-dump CS2 offsets and publish them.
# Requires: cs2 running, dumper built. Set $env:CS2_DUMPER or edit the default.
param([switch]$Push)

$ErrorActionPreference = "Stop"
$dumper = if ($env:CS2_DUMPER) { $env:CS2_DUMPER } else { "C:\Users\g\Desktop\cs2-dumper\src\target\release\cs2-dumper.exe" }
if (-not (Test-Path $dumper)) { $dumper = "C:\Users\g\Desktop\cs2-dumper\cs2-dumper.exe" }
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$work = Join-Path $env:TEMP "cs2-offsets-dump"

if (-not (Get-Process cs2 -ErrorAction SilentlyContinue)) { throw "cs2.exe is not running" }

Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
& $dumper -o $work | Out-Null
if (-not (Test-Path (Join-Path $work "info.json"))) { throw "dump failed - no info.json" }

Copy-Item "$work\*" $repo -Recurse -Force
Remove-Item $work -Recurse -Force

$info = Get-Content (Join-Path $repo "info.json") | ConvertFrom-Json
$build = $info.build_number
$date = [DateTime]::Parse($info.timestamp).ToString("yyyy-MM-dd")

$readme = Get-Content (Join-Path $repo "README.md") -Raw
$readme = $readme -replace "build-\d+-", "build-$build-"
$readme = $readme -replace "last updated: .*", "last updated: $date (build $build)"
Set-Content (Join-Path $repo "README.md") $readme -NoNewline

git -C $repo add -A
$pending = git -C $repo status --porcelain
if ($pending) {
    git -C $repo commit -m "build $build" | Out-Null
    if ($Push) { git -C $repo push }
    "committed build $build"
} else {
    "no changes (still build $build)"
}
