<#
    .SYNOPSIS
        This script is used to install tools and configure them for use by the Coding Pirates volounteers.
    
    .DESCRIPTION
        This script calls a lot of small installers
    
    .EXAMPLE
        .\setup_env.ps1
   
#>
#requires -version 5.0
#requires -runasadministrator
Set-StrictMode -Version 2.0
$SaveErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

function logFileConsole
{
    # Any printable string
    Param($lines)
    Write-Output $lines | Tee-Object -Append -FilePath "$env:TEMP\install-log.txt"
}

try {

    $starttime = $(Get-Date -Format u)
    logFileConsole "`r`nStarting installation at $starttime".

    # find our local "root"
    $LocalRootPath = Split-Path $PSScriptRoot -Parent
    
    $testchoco = Get-Command -Name choco.exe -ErrorAction SilentlyContinue
    
    if(-not($testchoco)){
        logFileConsole "Chocolatey is not installed, installing now"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }else{
        logFileConsole "Chocolatey Version $testchoco is already installed, trying upgrade"
        choco upgrade -y chocolatey
    }

    choco upgrade -y git gitextensions
    choco upgrade -y vscode
    choco upgrade -y python3
    choco upgrade -y thonny
    choco upgrade -y openscad
    choco upgrade -y inkscape

    logFileConsole "Setting up git"
    & "$LocalRootPath/config_git.ps1"

    logFileConsole "Adding vscode extensions"
    & "$LocalRootPath/vscode_extensions.ps1"

}
Catch
{
    logFileConsole $_.Exception | format-list -force
    logFileConsole $_.InvocationInfo | format-list -force
    Write-Host -NoNewLine 'Something went wrong, press any key to close.';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

$endtime = (Get-Date -Format u)
logFileConsole "Ending installation at $endtime`r`n"
$ErrorActionPreference = $SaveErrorActionPreference