# Alias
New-Alias which Get-Command

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
	Import-Module "$ChocolateyProfile"
}

# Modules
if (Get-Module -ListAvailable -Name posh-git) {
	Import-Module posh-git
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
	Create new empty file or change file timestamp to now.
#>
Function touch([string] $file) {
	if(Test-Path $file) {
		(Get-ChildItem $file).LastAccessTime = Get-Date
		(Get-ChildItem $file).LastWriteTime = Get-Date
	} else {
		New-Item -ItemType File $file | Out-Null
	}
}

<#
.SYNOPSIS
	Update all packages.
#>
Function u {
	cdh
	Clear-Host
	npm update -g --verbose
	apm upgrade --verbose --no-confirm
	gem update --system
	gem update
	gem clean
}

<#
.SYNOPSIS
	Gitignore
#>
Function gig {
	param(
		[Parameter(Mandatory=$true)]
		[string[]]$list
	)
	$params = $list -join ","
	Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | Select-Object -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding UTF8
}

<#
.SYNOPSIS
	Reset IP address
#>
Function Reset-IP
{
	ipconfig /release
	ipconfig /flushdns
	ipconfig /renew
}

# Notepad++
$NPPPath = 'C:\Program Files\Notepad++\notepad++.exe'
<#
.SYNOPSIS
	Run Notepad++
#>
Function npp {
	Param
	(
		# File path
		[Parameter(ValueFromPipelineByPropertyName, Position=0)]
		$Path
	)

	& $NPPPath $Path
}
