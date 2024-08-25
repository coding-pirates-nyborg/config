<#
    .SYNOPSIS
        This script sets up vscode extensions.
    
    .DESCRIPTION
        You can add extra extensions. See the current list of extensions using this command:

        code --list-extensions
    
    .EXAMPLE
        .\vscode_extensions.ps1
   
#>
#requires -version 5.0
Set-StrictMode -Version 2.0

# By Frey Clante 2024
try {
    # Script for batch installing Visual Studio Code extensions
    # Specify extensions to be checked & installed by modifying $extensions

    $extensions =
    "donjayamanne.git-extension-pack",
    "mhutchie.git-graph",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-vscode.powershell",
    "pucelle.run-on-save",
    "bierner.markdown-preview-github-styles",
    "moozzyk.Arduino",
    "platformio.platformio-ide", 
    "yzhang.markdown-all-in-one"

    $cmd = "code --list-extensions"
    Invoke-Expression $cmd -OutVariable output | Out-Null
    $installed = $output -split "\s"

    foreach ($ext in $extensions) {
        if ($installed.Contains($ext)) {
            Write-Host $ext "already installed." -ForegroundColor Gray
        } else {
            Write-Host "Installing" $ext "..." -ForegroundColor White
            code --install-extension $ext
        }
    }
}
Catch
{
    Write-Output $_.Exception | format-list -force
    Write-Output $_.InvocationInfo | format-list -force
    Write-Host -NoNewLine 'Something went wrong, press any key to close.';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}