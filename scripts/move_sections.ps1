# move_sections.ps1
# Purpose: Move sections 6.11-6.14 (formerly 8-11) to be after 6.10 and before 7
# NO JAPANESE STRINGS - only regex patterns to avoid UTF-8 encoding issues
#
# Current structure (after restructure_headers.ps1):
#   ... §6.10 ... --- §7 ... --- §6.11 ... §6.12 ... §6.13 ... §6.14 ... --- §12 ...
#
# Target structure:
#   ... §6.10 ... --- §6.11 ... §6.12 ... §6.13 ... §6.14 ... --- §7 ... --- §12 ...

param(
    [string]$FilePath = "C:\d\PlantUML2_Opus4.5\docs\evidence\20251224_1955_ui_design_login\wireframes\04_editor\05_sequence_diagram_spec.md"
)

# Read file with UTF-8 encoding
$content = [System.IO.File]::ReadAllText($FilePath, [System.Text.Encoding]::UTF8)
$originalLength = $content.Length

Write-Host "Original file length: $originalLength characters"
Write-Host ""

# === Find section positions ===
Write-Host "=== Finding section positions ==="

# Pattern to find section headers (using regex, no Japanese)
# §7 starts with "## 7. "
$s7Match = [regex]::Match($content, '(?m)^---\r?\n\r?\n## 7\. ')
if (-not $s7Match.Success) {
    Write-Host "ERROR: Could not find section 7 header"
    exit 1
}
$s7Start = $s7Match.Index
Write-Host "  Section 7 divider starts at: $s7Start"

# §6.11 starts with "### 6.11 " (after restructure_headers.ps1)
$s611Match = [regex]::Match($content, '(?m)^---\r?\n\r?\n### 6\.11 ')
if (-not $s611Match.Success) {
    Write-Host "ERROR: Could not find section 6.11 header"
    exit 1
}
$s611Start = $s611Match.Index
Write-Host "  Section 6.11 divider starts at: $s611Start"

# §12 starts with "## 12. "
$s12Match = [regex]::Match($content, '(?m)^---\r?\n\r?\n## 12\. ')
if (-not $s12Match.Success) {
    Write-Host "ERROR: Could not find section 12 header"
    exit 1
}
$s12Start = $s12Match.Index
Write-Host "  Section 12 divider starts at: $s12Start"

# === Validate order ===
Write-Host ""
Write-Host "=== Validating current order ==="
if ($s7Start -lt $s611Start -and $s611Start -lt $s12Start) {
    Write-Host "  Current order: S7 < S6.11 < S12 (expected after header conversion)"
} else {
    Write-Host "  ERROR: Unexpected order. s7=$s7Start, s611=$s611Start, s12=$s12Start"
    exit 1
}

# === Extract sections ===
Write-Host ""
Write-Host "=== Extracting sections 6.11-6.14 ==="

# Content to move: from §6.11 divider to just before §12 divider
$sectionToMove = $content.Substring($s611Start, $s12Start - $s611Start)
Write-Host "  Section 6.11-6.14 length: $($sectionToMove.Length) characters"

# === Build new content ===
Write-Host ""
Write-Host "=== Building new content ==="

# Part 1: Everything before §7 divider (includes §1-6.10)
$part1 = $content.Substring(0, $s7Start)
Write-Host "  Part 1 (before S7): $($part1.Length) characters"

# Part 2: The sections to move (§6.11-6.14)
$part2 = $sectionToMove
Write-Host "  Part 2 (S6.11-6.14): $($part2.Length) characters"

# Part 3: §7 up to §6.11 (excluding the moved sections)
$part3 = $content.Substring($s7Start, $s611Start - $s7Start)
Write-Host "  Part 3 (S7 only): $($part3.Length) characters"

# Part 4: Everything from §12 onwards
$part4 = $content.Substring($s12Start)
Write-Host "  Part 4 (S12 onwards): $($part4.Length) characters"

# Combine: Part1 + Part2 + Part3 + Part4
$newContent = $part1 + $part2 + $part3 + $part4

Write-Host ""
Write-Host "=== Verification ==="
$newLength = $newContent.Length
Write-Host "  New file length: $newLength characters"
Write-Host "  Length difference: $($newLength - $originalLength) characters"

# Verify new positions
$newS611Match = [regex]::Match($newContent, '(?m)^---\r?\n\r?\n### 6\.11 ')
$newS7Match = [regex]::Match($newContent, '(?m)^---\r?\n\r?\n## 7\. ')
$newS12Match = [regex]::Match($newContent, '(?m)^---\r?\n\r?\n## 12\. ')

if ($newS611Match.Success -and $newS7Match.Success -and $newS12Match.Success) {
    $newS611Pos = $newS611Match.Index
    $newS7Pos = $newS7Match.Index
    $newS12Pos = $newS12Match.Index

    Write-Host "  New positions: S6.11=$newS611Pos, S7=$newS7Pos, S12=$newS12Pos"

    if ($newS611Pos -lt $newS7Pos -and $newS7Pos -lt $newS12Pos) {
        Write-Host "  Order verified: S6.11 < S7 < S12 OK"
    } else {
        Write-Host "  ERROR: Order verification failed!"
        exit 1
    }
} else {
    Write-Host "  ERROR: Could not verify new positions"
    exit 1
}

# === Write result ===
Write-Host ""
Write-Host "=== Writing result ==="

# Write with UTF-8 encoding (no BOM)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($FilePath, $newContent, $utf8NoBom)

Write-Host ""
Write-Host "File updated successfully!"
