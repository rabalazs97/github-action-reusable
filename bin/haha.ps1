# Get the directory where the script is located
$parentDir = Split-Path -Path $env:solutionPath -Parent

# Define the search pattern for .csproj files
$csprojPattern = "*.xml"

# Search for .csproj files in the script directory and its subdirectories
$csprojFile = Get-ChildItem -Path $parentDir -Filter $csprojPattern -File -Recurse | Where-Object { -not $_.DirectoryName.EndsWith(".UnitTest") } | Select-Object -First 1

# Check if any .csproj files were found
if ($csprojFile) {
    # Load the .csproj file as XML
    [xml]$csprojXml = Get-Content $csprojFile.FullName

    # Find the PropertyGroup elements
    $propertyGroups = $csprojXml.Project.PropertyGroup

    # Filter PropertyGroup elements by Condition containing "Release"
    $releasePropertyGroups = $propertyGroups | Where-Object { $_.Condition -like "*Release*" }
    Write-Output $releasePropertyGroups.OutputPath
}