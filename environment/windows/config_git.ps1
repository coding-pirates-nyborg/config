<#
    .SYNOPSIS
        This script is used to configure git-for-windows silently.
    
    .DESCRIPTION
        This script is used to set a default setup for git-for-windows.
    
    .EXAMPLE
        .\config-git.ps1
   
#>
#requires -version 5.0
#requires -runasadministrator

# put git config on a local dir 
setx HOME %USERPROFILE% 

Set-StrictMode -Version 2.0
$SaveErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'

# Frey Clante 2024
Push-Location $env:Temp
$ProgressPreference = 'SilentlyContinue' # Much faster than Continue

try {
    $displayname = Read-Host "Enter your name"
    $email = Read-Host "Enter your github email"

    # Check if email is a valid email

    if ($email -notmatch "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
    {
        Write-Output "Invalid email address: $email"
        exit 1
    }

    Write-Output "Configuring git with name and e-mail: $($displayname) and $($email)"
    
    $git = "${env:ProgramFiles}\git\bin\git.exe"
    & $git config --global --replace-all user.name "$displayname"
    & $git config --global --replace-all user.email $email
    & $git config --system --replace-all push.default upstream
    & $git config --system --replace-all http.sslverify true
    & $git config --system --replace-all core.longpaths true
    & $git config --system --replace-all core.autocrlf input # To make sure windows files with CRLF are converted to LF on the way in to the .git database
    & $git config --system --replace-all http.sslbackend schannel
    & $git config --system --replace-all init.defaultbranch main
    & $git config --system --replace-all push.autoSetupRemote true
    # Make sure global config does not interfere (sorry, git config only changes one file at a time)
# These must be set per-user   & $git config --global --unset-all user.name
# These must be set per-user   & $git config --global --unset-all user.email
    & $git config --global --unset-all push.default
    & $git config --global --unset-all http.sslverify
    & $git config --global --unset-all core.longpaths
    & $git config --global --unset-all core.autocrlf
    & $git config --global --unset-all http.sslbackend
    & $git config --global --unset-all init.defaultbranch
    & $git config --global --unset-all push.autoSetupRemote
    
    if (Test-Path -Path "${Env:\ProgramFiles}\Microsoft VS Code\Code.exe")
    {
        & $git config --global diff.tool vscode
        & $git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
        & $git config --global merge.tool vscode
        & $git config --global mergetool.vscode.cmd 'code --wait $MERGED'
    } elseIf (Test-Path -Path "${Env:\ProgramFiles(x86)}\Microsoft VS Code\Code.exe")
    {
        & $git config --global diff.tool vscode
        & $git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
        & $git config --global merge.tool vscode
        & $git config --global mergetool.vscode.cmd 'code --wait $MERGED'
    } else {
        & $git config --global diff.tool vimdiff
        & $git config --global merge.tool vimdiff
    }

    $ssh_public_key_file_name = "${Env:HOME}\.ssh\id_rsa.pub"
    # create a ssh key pair
    try {
        if (-Not (Test-Path -Path "$ssh_public_key_file_name"))
        {
            # create a .ssh dir if not there
            New-Item -ItemType Directory -Force -Path "${Env:HOME}\.ssh"
            # Generate a new key
            & "${Env:ProgramFiles}\git\usr\bin\ssh-keygen.exe" -q -t rsa -N '""' -f ${Env:HOME}\.ssh\id_rsa
        }

        if (Test-Path -Path "$ssh_public_key_file_name")
        {
            Write-Output "SSH keys found, please copy contents of $ssh_public_key_file_name to SSH-keys section under your profile"
        } else {
            Write-Output "SSH key generation failed - please report this error to fclante@gmail.com"
            exit 1
        }
    }
    
    catch {
        Write-Output $_.Exception | format-list -force
        Write-Output $_.InvocationInfo | format-list -force
        Write-Host -NoNewLine 'Could not generate SSH keys pair. Press any Key to close.';
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
        exit
    }
    
    $ProgressPreference = 'Continue'
    Pop-Location
}
Catch
{
    Write-Output $_.Exception | format-list -force
    Write-Output $_.InvocationInfo | format-list -force
    Write-Host -NoNewLine 'Something went wrong, press any key to close.';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

$ErrorActionPreference = $SaveErrorActionPreference