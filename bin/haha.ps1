# Get the directory where the script is located
$parentDir = Split-Path -Path $env:solutionPath -Parent

# Define the search pattern for .csproj files
$csprojPattern = "*.xml"

# Search for .csproj files in the script directory and its subdirectories
$csprojFiles = Get-ChildItem -Path $parentDir -Filter $csprojPattern -File -Recurse

# Check if any .csproj files were found
if ($csprojFiles.Count -gt 0) {
    foreach ($csprojFile in $csprojFiles) {
        # Load the .csproj file as XML
        [xml]$csprojXml = Get-Content $csprojFile.FullName

        # Find the PropertyGroup elements
        $propertyGroups = $csprojXml.Project.PropertyGroup

        # Filter PropertyGroup elements by Condition containing "Release"
        $releasePropertyGroups = $propertyGroups | Where-Object { $_.Condition -like "*Release*" }
        Write-Output $releasePropertyGroups

        # Check if the OutputPath element exists
        # if ($outputPathElement) {
        #     # Output the value of OutputPath along with the .csproj file path
        #     Write-Output "Project: $($csprojFile.FullName)"
        #     Write-Output "Output Path: $($outputPathElement.InnerText)"
        #     Write-Output ""
        # } else {
        #     Write-Error "OutputPath element not found in $($csprojFile.FullName)"
        # }
    }
} else {
    Write-Error "No .csproj files found in the script directory and its subdirectories."
}