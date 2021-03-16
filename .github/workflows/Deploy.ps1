Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Write-Host (Get-Location).Path

$nuGetApiKey = $env:PSGALLERY_TOKEN

try{
    Publish-Module -Path . -NuGetApiKey $nuGetApiKey -ErrorAction Stop -Force #-Debug
    Write-Host "Set-GitHubSecrets has been Published to the PowerShell Gallery!"
}
catch {
    throw $_
}
