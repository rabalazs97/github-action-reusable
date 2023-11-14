# Get the directory where the script is located
$parentDir = Split-Path -Path $env:solutionPath -Parent

Write-Host ${{vars.asd}}
Write-Host ${{vars.asdsecret}}
Write-Host ${{secret.}}

# Define the search pattern for .csproj files
$csprojPattern = "*.xml"
$unitTestString = "UnitTest"

# Search for .csproj files in the script directory and its subdirectories
$csprojFile = Get-ChildItem -Path $parentDir -Filter $csprojPattern -File -Recurse | 
    Where-Object { -not ($_.Name -like "*$unitTestString*" -or $_.DirectoryName -like ("*$unitTestString*"))  } | 
    Select-Object -First 1

switch ($env:platform) {
    'x64' { $env:platform = 'x64' }
    'x86' { $env:platform = 'Win32' }
    'Win32' { $env:platform = 'Win32' }
    Default { $env:platform = 'AnyCpu' }
}

# Check if any .csproj files were found
if ($csprojFile) {
    # Load the .csproj file as XML
    [xml]$csprojXml = Get-Content $csprojFile.FullName

    # Find the PropertyGroup elements
    $propertyGroups = $csprojXml.Project.PropertyGroup

    # Filter PropertyGroup elements by Condition containing "Release"
    $releasePropertyGroups = $propertyGroups | Where-Object { $_.Condition -like "*Release*" -and $_.Condition -like "*$env:platform*" }
    $releasePath = $releasePropertyGroups.OutputPath
    Write-Output releasePath=$releasePath >> $env:GITHUB_OUTPUT
}