# Set-GitHubSecrets

PowerShell DotEnv to GitHub Encrypted secrets

This is a simple script to exports environment variable from the .env file to the GitHub Encrypted secrets.

Usage
==========
Add the function Set-GitHubSecrets to the prompt function.

```powershell
Set-GitHubSecrets
```

```powershell
# This is function is called by convention in PowerShell
function prompt {
    Set-GitHubSecrets
}
```
Create a .env file at the folder level the environment variable has to be exported   
Sample .env file
```powershell
#This is a comment
#Assign a variable
DEPLOYKEY=KEY1
#github-secrets-skip Next var will be ignored
LOCALVAR=NOTFORGITHUB
```
Installation
============

### From PowerShell Gallery
```powershell
Install-Module -Name Set-GitHubSecrets
```