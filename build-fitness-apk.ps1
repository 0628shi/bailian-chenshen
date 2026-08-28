param(
    [switch]$Release
)
# Build helper for the FitnessApp (百炼成神) project.
# Reuses the local toolchain under <repo-root>/.tools (JDK, Gradle, Android SDK).
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent   # E:\安卓 (repo root holding .tools)
$proj = $PSScriptRoot                     # E:\安卓\FitnessApp
$tools = Join-Path $root ".tools"

$jdk = Get-ChildItem (Join-Path $tools "jdk") -Directory | Select-Object -First 1
if (-not $jdk) { throw "JDK not found under $tools\jdk." }
$env:JAVA_HOME = $jdk.FullName
$env:ANDROID_HOME = Join-Path $tools "android-sdk"
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:ANDROID_USER_HOME = Join-Path $root ".tmp\android-user-home"
if (-not (Test-Path $env:ANDROID_USER_HOME)) { New-Item -ItemType Directory -Path $env:ANDROID_USER_HOME -Force | Out-Null }
$env:GRADLE_USER_HOME = Join-Path $root ".gradle-home"
$env:TMP = Join-Path $root ".tmp"
$env:TEMP = $env:TMP

$gradle = Join-Path $tools "gradle\gradle-8.7\bin\gradle.bat"
if (-not (Test-Path $gradle)) { throw "Gradle not found at $gradle" }

Set-Location $proj
$task = if ($Release) { "assembleRelease" } else { "assembleDebug" }
Write-Output "Building: gradle $task in $proj"
& $gradle $task --no-daemon --console=plain
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if ($Release) {
    Write-Output "APK: $proj\app\build\outputs\apk\release\app-release-unsigned.apk"
} else {
    Write-Output "APK: $proj\app\build\outputs\apk\debug\app-debug.apk"
}
