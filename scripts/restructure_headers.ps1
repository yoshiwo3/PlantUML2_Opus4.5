# restructure_headers.ps1
# Purpose: Convert section headers from old numbering to new numbering
# NO JAPANESE STRINGS - only regex patterns to avoid UTF-8 encoding issues
#
# Conversions:
#   ## 8. xxx  -> ### 6.11 xxx
#   ### 8.x    -> #### 6.11.x
#   #### 8.x.y -> ##### 6.11.x.y
#   (same pattern for 9->6.12, 10->6.13, 11->6.14)

param(
    [string]$FilePath = "C:\d\PlantUML2_Opus4.5\docs\evidence\20251224_1955_ui_design_login\wireframes\04_editor\05_sequence_diagram_spec.md"
)

# Read file with UTF-8 encoding
$content = [System.IO.File]::ReadAllText($FilePath, [System.Text.Encoding]::UTF8)
$originalLength = $content.Length

Write-Host "Original file length: $originalLength characters"
Write-Host ""

# === Section 8 -> 6.11 ===
Write-Host "=== Converting Section 8 -> 6.11 ==="

# Main header: ## 8. -> ### 6.11
$pattern1 = '(?m)^## 8\. '
$replacement1 = '### 6.11 '
$content = [regex]::Replace($content, $pattern1, $replacement1)
Write-Host "  ## 8. -> ### 6.11 completed"

# Subsection: ### 8.1 -> #### 6.11.1, ### 8.2 -> #### 6.11.2, etc.
$pattern2 = '(?m)^### 8\.(\d+)'
$replacement2 = '#### 6.11.$1'
$content = [regex]::Replace($content, $pattern2, $replacement2)
Write-Host "  ### 8.x -> #### 6.11.x completed"

# Sub-subsection: #### 8.1.1 -> ##### 6.11.1.1, etc.
$pattern3 = '(?m)^#### 8\.(\d+)\.(\d+)'
$replacement3 = '##### 6.11.$1.$2'
$content = [regex]::Replace($content, $pattern3, $replacement3)
Write-Host "  #### 8.x.y -> ##### 6.11.x.y completed"

# === Section 9 -> 6.12 ===
Write-Host ""
Write-Host "=== Converting Section 9 -> 6.12 ==="

$content = [regex]::Replace($content, '(?m)^## 9\. ', '### 6.12 ')
Write-Host "  ## 9. -> ### 6.12 completed"

$content = [regex]::Replace($content, '(?m)^### 9\.(\d+)', '#### 6.12.$1')
Write-Host "  ### 9.x -> #### 6.12.x completed"

$content = [regex]::Replace($content, '(?m)^#### 9\.(\d+)\.(\d+)', '##### 6.12.$1.$2')
Write-Host "  #### 9.x.y -> ##### 6.12.x.y completed"

# === Section 10 -> 6.13 ===
Write-Host ""
Write-Host "=== Converting Section 10 -> 6.13 ==="

$content = [regex]::Replace($content, '(?m)^## 10\. ', '### 6.13 ')
Write-Host "  ## 10. -> ### 6.13 completed"

$content = [regex]::Replace($content, '(?m)^### 10\.(\d+)', '#### 6.13.$1')
Write-Host "  ### 10.x -> #### 6.13.x completed"

$content = [regex]::Replace($content, '(?m)^#### 10\.(\d+)\.(\d+)', '##### 6.13.$1.$2')
Write-Host "  #### 10.x.y -> ##### 6.13.x.y completed"

# === Section 11 -> 6.14 ===
Write-Host ""
Write-Host "=== Converting Section 11 -> 6.14 ==="

$content = [regex]::Replace($content, '(?m)^## 11\. ', '### 6.14 ')
Write-Host "  ## 11. -> ### 6.14 completed"

$content = [regex]::Replace($content, '(?m)^### 11\.(\d+)', '#### 6.14.$1')
Write-Host "  ### 11.x -> #### 6.14.x completed"

$content = [regex]::Replace($content, '(?m)^#### 11\.(\d+)\.(\d+)', '##### 6.14.$1.$2')
Write-Host "  #### 11.x.y -> ##### 6.14.x.y completed"

# === Write result ===
Write-Host ""
Write-Host "=== Writing result ==="

$newLength = $content.Length
Write-Host "New file length: $newLength characters"

# Write with UTF-8 encoding (no BOM)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($FilePath, $content, $utf8NoBom)

Write-Host ""
Write-Host "File updated successfully!"
