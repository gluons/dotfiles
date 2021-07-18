# Run Discord as admin.

$discordUpdateExePath = Join-Path $env:LOCALAPPDATA 'Discord/Update.exe'
$discordArgs = @('--processStart Discord.exe')

if ([bool] (Get-Process -Name 'Discord' -ErrorAction SilentlyContinue)) {
	Stop-Process -Name 'Discord' -Force
}
Start-Process $discordUpdateExePath -ArgumentList $discordArgs -Verb RunAs
