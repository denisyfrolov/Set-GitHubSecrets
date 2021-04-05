$localEnvFile = ".\.env"
$ghCmdName = "gh"
<#
.Synopsis
Exports environment variable from the .env file to the GitHub Encrypted secrets.

.Description
This function looks for .env file in the current directoty, if present
it loads the environment variable mentioned in the file to the GitHub Encrypted secrets.

.Example
Set-GitHubSecrets
Remove-GitHubSecrets
 
.Example
#.env file format
#To Assign value, use "=" operator
<variable name>=<value>
#To comment a line, use "#" at the start of the line
#This is a comment, it will be skipped when parsing
#To skip a line, use "#github-secrets-skip" before the line
#This is a comment, it will be skipped when parsing
#>
function Set-GitHubSecrets {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param(
        [bool] $Remove = $false
    )

    $skipNextLine = $false

    if (-Not (Get-Command $ghCmdName -errorAction SilentlyContinue))
    {
        "$ghCmdName doesn't exists. Please follow the link https://github.com/cli/cli#installation to install GitHub CLI"
        return
    }

    #return if no env file
    if (!( Test-Path $localEnvFile)) {
        Write-Verbose "No .env file"
        return
    }

    #read the local env file
    $content = Get-Content $localEnvFile -ErrorAction Stop
    Write-Verbose "Parsed .env file"

    #load the content to environment
    foreach ($line in $content) {

        if($skipNextLine){
            Write-Verbose "Skipping marked: $line"
            $skipNextLine = $false
            continue
        }

        if([string]::IsNullOrWhiteSpace($line)){
            Write-Verbose "Skipping empty line"
            continue
        }

        #skip marked lines
        if($line.Contains("github-secrets-skip")){
            Write-Verbose "Found marked line, will skip next line"
            $skipNextLine = $true
            continue
        }

        #ignore comments
        if($line.StartsWith("#")){
            Write-Verbose "Skipping comment: $line"
            continue
        }

        #get the operator
        if($line -like "*=*"){
            Write-Verbose "Assign"
            $kvp = $line -split "=",2            
            $key = $kvp[0].Trim()
            $value = $kvp[1].Trim() -replace '"', '\"'
        }

        if($Remove){
            Write-Verbose "Remove $key"
        
            if ($PSCmdlet.ShouldProcess("secret $key", "set value $value")) {            
                & $ghCmdName secret remove $($key)
            }
        }else {
            Write-Verbose "$key=$value"
        
            if ($PSCmdlet.ShouldProcess("secret $key", "set value $value")) {            
                & $ghCmdName secret set $($key) -b"$($value)"
            }
        }
    }
}

function Remove-GitHubSecrets {
    Set-GitHubSecrets -Remove $true
}

Export-ModuleMember -Function @('Set-GitHubSecrets')
Export-ModuleMember -Function @('Remove-GitHubSecrets')