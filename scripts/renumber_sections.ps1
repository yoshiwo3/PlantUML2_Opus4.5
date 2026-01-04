# renumber_sections.ps1
# Purpose: Renumber sections 12-19 to 8-15
# NO JAPANESE STRINGS - only regex patterns to avoid UTF-8 encoding issues
# Uses placeholder approach to avoid conflicts
#
# Mapping:
#   §12 -> §8, §13 -> §9, §14 -> §10, §15 -> §11
#   §16 -> §12, §17 -> §13, §18 -> §14, §19 -> §15

param(
    [string]$FilePath = "C:\d\PlantUML2_Opus4.5\docs\evidence\20251224_1955_ui_design_login\wireframes\04_editor\05_sequence_diagram_spec.md"
)

# Read file content
$content = [System.IO.File]::ReadAllText($FilePath, [System.Text.Encoding]::UTF8)
$originalLength = $content.Length

Write-Host "Original file length: $originalLength characters"
Write-Host ""

# Mapping from old to new section numbers
$mapping = @{
    '12' = '8'
    '13' = '9'
    '14' = '10'
    '15' = '11'
    '16' = '12'
    '17' = '13'
    '18' = '14'
    '19' = '15'
}

# === Phase 1: Replace with placeholders ===
Write-Host "=== Phase 1: Converting to placeholders ==="

foreach ($old in $mapping.Keys) {
    $new = $mapping[$old]

    # Main section headers: ## 12. -> ## PLACEHOLDER_8.
    $content = [regex]::Replace($content, "(?m)^## $old\. ", "## PLACEHOLDER_$new. ")

    # Subsection headers: ### 12.1 -> ### PLACEHOLDER_8.1
    $content = [regex]::Replace($content, "(?m)^### $old\.", "### PLACEHOLDER_$new.")

    # Sub-subsection headers: #### 12.1.1 -> #### PLACEHOLDER_8.1.1
    $content = [regex]::Replace($content, "(?m)^#### $old\.", "#### PLACEHOLDER_$new.")

    # Sub-sub-subsection headers: ##### 12.1.1.1 -> ##### PLACEHOLDER_8.1.1.1
    $content = [regex]::Replace($content, "(?m)^##### $old\.", "##### PLACEHOLDER_$new.")

    Write-Host "  $old -> PLACEHOLDER_$new completed"
}

Write-Host ""
Write-Host "=== Phase 2: Converting placeholders to final numbers ==="

# Replace placeholders with final numbers (8-15)
for ($i = 8; $i -le 15; $i++) {
    # Main section headers: ## PLACEHOLDER_8. -> ## 8.
    $content = [regex]::Replace($content, "(?m)^## PLACEHOLDER_$i\. ", "## $i. ")

    # Subsection headers: ### PLACEHOLDER_8.1 -> ### 8.1
    $content = [regex]::Replace($content, "(?m)^### PLACEHOLDER_$i\.", "### $i.")

    # Sub-subsection headers: #### PLACEHOLDER_8.1.1 -> #### 8.1.1
    $content = [regex]::Replace($content, "(?m)^#### PLACEHOLDER_$i\.", "#### $i.")

    # Sub-sub-subsection headers: ##### PLACEHOLDER_8.1.1.1 -> ##### 8.1.1.1
    $content = [regex]::Replace($content, "(?m)^##### PLACEHOLDER_$i\.", "##### $i.")

    Write-Host "  PLACEHOLDER_$i -> $i completed"
}

Write-Host ""
Write-Host "=== Verification ==="

$newLength = $content.Length
Write-Host "New file length: $newLength characters"
Write-Host "Length difference: $($newLength - $originalLength) characters"

# Count main section headers
$matches = [regex]::Matches($content, '(?m)^## \d+\. ')
Write-Host ""
Write-Host "Found $($matches.Count) main section headers"

# Extract section numbers
$sectionNumbers = @()
foreach ($m in $matches) {
    if ($m.Value -match '## (\d+)\. ') {
        $sectionNumbers += [int]$Matches[1]
    }
}

$sortedNumbers = $sectionNumbers | Sort-Object
Write-Host "Section numbers found: $($sortedNumbers -join ', ')"

# Verify all numbers 1-15 are present
$expected = 1..15
$missing = $expected | Where-Object { $_ -notin $sortedNumbers }
$extra = $sortedNumbers | Where-Object { $_ -notin $expected }

if ($missing.Count -eq 0 -and $extra.Count -eq 0) {
    Write-Host "All sections 1-15 present: OK"
} else {
    if ($missing.Count -gt 0) {
        Write-Host "ERROR: Missing sections: $($missing -join ', ')"
    }
    if ($extra.Count -gt 0) {
        Write-Host "ERROR: Extra sections: $($extra -join ', ')"
    }
    exit 1
}

# Check for any remaining placeholders
$placeholderCheck = [regex]::Match($content, 'PLACEHOLDER_\d+')
if ($placeholderCheck.Success) {
    Write-Host "ERROR: Found remaining placeholder: $($placeholderCheck.Value)"
    exit 1
}

Write-Host ""
Write-Host "=== Writing result ==="

# Write with UTF-8 encoding (no BOM)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($FilePath, $content, $utf8NoBom)

Write-Host ""
Write-Host "File updated successfully!"
