# Encoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Alias
New-Alias grep Select-String
New-Alias which Get-Command
New-Alias ln New-SymLink

# Important functions
<#
.SYNOPSIS
	Determine whether the given module name exist.

.PARAMETER ModuleName
	Module name.
#>
function Test-ModuleExists ([Parameter(Mandatory = $true)][string] $ModuleName) {
	return [bool](Get-Module -ListAvailable -Name $ModuleName)
}

<#
.SYNOPSIS
	Determine whether the given command exist.
#>
function Test-CommandExists ([Parameter(Mandatory = $true)][string] $Command) {
	return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# Modules
if (Test-ModuleExists posh-git) {
	Import-Module posh-git
}
if (Test-ModuleExists git-aliases) {
	Import-Module git-aliases -DisableNameChecking
}
if (Test-ModuleExists npm-completion) {
	Import-Module npm-completion
}
if (Test-ModuleExists yarn-completion) {
	Import-Module yarn-completion
}
if (Test-ModuleExists npm-upgrade) {
	Import-Module npm-upgrade
}


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
	Import-Module "$ChocolateyProfile"
}

# Prompt
if (Test-CommandExists starship) { # Starship
	Invoke-Expression (&starship init powershell)

	# https://github.com/microsoft/terminal/issues/3158#issuecomment-967199838
	$script:oldPrompt = $function:prompt

	function prompt {
		$pp = $pwd.ProviderPath
		Write-Host -NoNewline "$([char]27)]9;9;`"$pp`"$([char]7)"
		& $script:oldPrompt
	}
} elseif (Test-ModuleExists oh-my-posh) { # Oh My Posh
	Import-Module oh-my-posh

	$OhMyPoshVersion = Get-Module oh-my-posh | Select-Object -ExpandProperty Version
	$Version3 = [Version]::new('3.0.0')

	if ($OhMyPoshVersion -lt $Version3) {
		Set-Theme Paradox
	} else {
		Set-PoshPrompt -Theme star
	}
}

# Functions
<#
.SYNOPSIS
	Change current directory to $HOME.
#>
function cdh {
	Set-Location $HOME
}

<#
.SYNOPSIS
	Change current directory to my-projects directory.
#>
function cdm {
	$MyProjectsPath = Join-Path $HOME './my-projects'

	if (!(Test-Path $MyProjectsPath)) {
		return
	}

	$MyProjectsPath = Resolve-Path $MyProjectsPath

	if (Test-SymLink $MyProjectsPath -and (Get-Item $MyProjectsPath).Target.Count -gt 0) {
		$MyProjectsPath = Get-Item $MyProjectsPath | Select-Object -ExpandProperty Target
	}

	Set-Location $MyProjectsPath
}

<#
.SYNOPSIS
	Create new empty file or change file timestamp to now.
#>
Function touch ([string] $file) {
	if (Test-Path $file) {
		(Get-ChildItem $file).LastAccessTime = Get-Date
		(Get-ChildItem $file).LastWriteTime = Get-Date
	} else {
		New-Item -ItemType File $file | Out-Null
	}
}

<#
.SYNOPSIS
	Copy current working directory to clipboard.
#>
function cpwd {
	(Get-Location).Path | Set-Clipboard
}

<#
.SYNOPSIS
	Open current working directory in Windows Explorer.
#>
function opwd {
	Get-Location | Invoke-Item
}

<#
.SYNOPSIS
	Create a symbolic link to given target.
#>
function New-SymLink ([string] $Target, [string] $Link) {
	New-Item -ItemType SymbolicLink -Path $Link -Value $Target
}

<#
.SYNOPSIS
	Determine whether the given is symbolic link.
#>
function Test-SymLink([string] $Path) {
	if (!(Test-Path $Path)) {
		return $false
	}

	return (Get-Item $Path).LinkType -eq 'SymbolicLink'
}

<#
.SYNOPSIS
	List all global npm packages.
#>
function npmlsg {
	if (Test-CommandExists npm) {
		npm ls -g --depth 0
	} else {
		Write-Host -ForegroundColor Red -Object "npm command does not exist."
	}
}

<#
.SYNOPSIS
	List all npm packages of current working directory.
#>
function npmls {
	if (Test-CommandExists npm) {
		npm ls --depth 0
	} else {
		Write-Host -ForegroundColor Red -Object "npm command does not exist."
	}
}

<#
.SYNOPSIS
	Update all packages.
#>
Function u {
	cdh
	Clear-Host
	if (Test-CommandExists npm) {
		npm update -g --verbose
	}
	if (Test-CommandExists yarn) {
		yarn global upgrade
	}
	if (Test-CommandExists apm) {
		apm upgrade --verbose --no-confirm
	}
	if (Test-CommandExists gem) {
		gem update --system
		gem update
		gem clean
	}
}

<#
.SYNOPSIS
	Gitignore
#>
Function gig {
	param(
		[Parameter(Mandatory = $true)]
		[string[]]$list
	)
	$params = $list -join ","
	Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | Select-Object -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding UTF8
}

<#
.SYNOPSIS
	Reset IP address
#>
Function Reset-IP {
	ipconfig /release
	ipconfig /flushdns
	ipconfig /renew
}

# Notepad++
<#
.SYNOPSIS
	Run Notepad++
#>
Function npp {
	Param
	(
		# File path
		[Parameter(ValueFromPipelineByPropertyName, Position = 0)]
		$Path
	)

	$NPPPath = 'C:\Program Files\Notepad++\notepad++.exe'
	if (Test-Path $NPPPath) {
		& $NPPPath $Path
	}
}

<#
.SYNOPSIS
	Rerun Discord as administrator.
#>
function discord {
	$discordUpdateExePath = Join-Path $env:LOCALAPPDATA 'Discord/Update.exe'
	$discordArgs = @('--processStart Discord.exe')

	if ([bool] (Get-Process -Name 'Discord' -ErrorAction SilentlyContinue)) {
		Stop-Process -Name 'Discord' -Force
	}
	Start-Process $discordUpdateExePath -ArgumentList $discordArgs -Verb RunAs
}
