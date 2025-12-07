<#
.SYNOPSIS
    PlantUML図表の検証・レビュー・正式版保存スクリプト

.DESCRIPTION
    2段階のワークフローでPlantUML図表を管理します。

    Phase 1 (-Review): PNG生成してレビュー
      → カレントディレクトリにPNG出力
      → レビューログ（.review.json）を生成
      → Claudeマルチモーダル機能で視覚的レビュー
      → レビュー完了後、Claudeがログを更新

    Phase 2 (-Publish): レビュー済み図表をSVGで正式版保存
      → レビューログを検証（completed & ハッシュ一致）
      → docs/proposals/diagrams/<DiagramType>/にSVG出力

.PARAMETER InputPath
    検証対象の.pumlファイルまたはディレクトリ

.PARAMETER Review
    レビューモード: PNG形式で出力（視覚的レビュー用）

.PARAMETER Publish
    正式版保存モード: SVG形式でproposals/diagrams/に出力

.PARAMETER DiagramType
    図表タイプ（-Publish時に必須）
    business_flow, sequence, usecase, context, component, class, dfd

.EXAMPLE
    # Phase 1: レビュー用PNG生成
    .\validate_plantuml.ps1 -InputPath ".\diagram.puml" -Review

.EXAMPLE
    # Phase 2: 正式版SVG保存（レビュー完了後）
    .\validate_plantuml.ps1 -InputPath ".\diagram.puml" -Publish -DiagramType "business_flow"

.EXAMPLE
    # ディレクトリ内の全.pumlをレビュー
    .\validate_plantuml.ps1 -InputPath ".\docs\evidence\20251207_admin_flow_review\" -Review
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$InputPath,

    [Parameter(Mandatory=$false)]
    [switch]$Review,

    [Parameter(Mandatory=$false)]
    [switch]$Publish,

    [Parameter(Mandatory=$false)]
    [ValidateSet("business_flow", "sequence", "usecase", "context", "component", "class", "dfd")]
    [string]$DiagramType
)

# 設定
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$PlantUmlJar = "C:\temp\vscode\.plantuml\plantuml-mit-1.2025.2.jar"
$ProposalsDiagramsDir = Join-Path $ProjectRoot "docs\proposals\diagrams"

# ハッシュ計算関数
function Get-FileHashValue {
    param([string]$FilePath)
    $hash = Get-FileHash -Path $FilePath -Algorithm SHA256
    return $hash.Hash.Substring(0, 16)  # 先頭16文字
}

# レビューログパス取得
function Get-ReviewLogPath {
    param([string]$PumlPath)
    $dir = Split-Path -Parent $PumlPath
    $name = [System.IO.Path]::GetFileNameWithoutExtension($PumlPath)
    return Join-Path $dir "$name.review.json"
}

# レビューログ生成/更新（Review時）
function New-ReviewLog {
    param(
        [string]$PumlPath,
        [string]$Hash,
        [string]$Timestamp
    )

    $logPath = Get-ReviewLogPath $PumlPath
    $fileName = Split-Path -Leaf $PumlPath

    $issueTemplate = [PSCustomObject]@{
        pass = $null
        symptom = $null
        cause = $null
    }

    $newCurrent = @{
        hash = $Hash
        timestamp = $Timestamp
        status = "pending"
        review = @{
            pass1_structure = $false
            pass2_connections = $false
            pass3_content = $false
            pass4_style = $false
        }
        issues = @($issueTemplate)
        reviewed_at = $null
    }

    if (Test-Path $logPath) {
        # 既存ログがある場合、currentをhistoryに移動
        $existingLog = Get-Content $logPath -Raw | ConvertFrom-Json

        # historyが存在しない場合は空配列で初期化
        $history = @()
        if ($existingLog.history) {
            $history = @($existingLog.history)
        }

        # 前回のcurrentをhistoryに追加（pending以外の場合）
        if ($existingLog.current -and $existingLog.current.status -ne "pending") {
            $history = @($existingLog.current) + $history
        }

        $log = @{
            file = $fileName
            current = $newCurrent
            history = $history
        }
    } else {
        # 新規ログ
        $log = @{
            file = $fileName
            current = $newCurrent
            history = @()
        }
    }

    $log | ConvertTo-Json -Depth 10 | Set-Content $logPath -Encoding UTF8
    return $logPath
}

# レビューログ検証（Publish時）
function Test-ReviewLog {
    param(
        [string]$PumlPath
    )

    $logPath = Get-ReviewLogPath $PumlPath
    $fileName = Split-Path -Leaf $PumlPath

    # ログファイル存在確認
    if (-not (Test-Path $logPath)) {
        return @{
            valid = $false
            error = "Review log not found. Run -Review first."
            logPath = $logPath
        }
    }

    $log = Get-Content $logPath -Raw | ConvertFrom-Json

    # status確認
    if ($log.current.status -ne "completed") {
        return @{
            valid = $false
            error = "Review not completed. Status: $($log.current.status)"
            logPath = $logPath
        }
    }

    # ハッシュ確認
    $currentHash = Get-FileHashValue $PumlPath
    if ($log.current.hash -ne $currentHash) {
        return @{
            valid = $false
            error = "File modified after review. Run -Review again."
            logPath = $logPath
            expectedHash = $log.current.hash
            actualHash = $currentHash
        }
    }

    return @{
        valid = $true
        logPath = $logPath
        reviewedAt = $log.current.reviewed_at
    }
}

# モード検証
if (-not $Review -and -not $Publish) {
    Write-Error "Either -Review or -Publish must be specified"
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  Phase 1 (Review):  .\validate_plantuml.ps1 -InputPath <path> -Review"
    Write-Host "  Phase 2 (Publish): .\validate_plantuml.ps1 -InputPath <path> -Publish -DiagramType <type>"
    exit 1
}

if ($Review -and $Publish) {
    Write-Error "Cannot use both -Review and -Publish at the same time"
    exit 1
}

if ($Publish -and -not $DiagramType) {
    Write-Error "-DiagramType is required when using -Publish"
    Write-Host ""
    Write-Host "Available DiagramTypes:" -ForegroundColor Yellow
    Write-Host "  business_flow, sequence, usecase, context, component, class, dfd"
    exit 1
}

# Java確認
$JavaPath = Get-Command java -ErrorAction SilentlyContinue
if (-not $JavaPath) {
    Write-Error "Java is not installed or not in PATH"
    exit 1
}

# plantuml.jar確認
if (-not (Test-Path $PlantUmlJar)) {
    Write-Error "plantuml.jar not found at: $PlantUmlJar"
    Write-Host "Download from: https://github.com/plantuml/plantuml/releases"
    exit 1
}

# 入力パス確認
if (-not (Test-Path $InputPath)) {
    Write-Error "Input path not found: $InputPath"
    exit 1
}

# モード別設定
if ($Review) {
    $Mode = "Review"
    $Format = "png"
    $FormatOption = "-tpng"
    if (Test-Path $InputPath -PathType Container) {
        $OutputDir = $InputPath
    } else {
        $OutputDir = Split-Path -Parent $InputPath
    }
} else {
    $Mode = "Publish"
    $Format = "svg"
    $FormatOption = "-tsvg"
    $OutputDir = Join-Path $ProposalsDiagramsDir $DiagramType
    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    }
}

$FormatUpper = $Format.ToUpper()

# ヘッダー表示
Write-Host ""
if ($Review) {
    Write-Host "=== PlantUML Review Mode (PNG) ===" -ForegroundColor Cyan
    Write-Host "Generate PNG for visual review with Claude" -ForegroundColor Gray
} else {
    Write-Host "=== PlantUML Publish Mode (SVG) ===" -ForegroundColor Green
    Write-Host "Save official SVG to proposals/diagrams/$DiagramType" -ForegroundColor Gray
}
Write-Host ""
Write-Host "Input:  $InputPath"
Write-Host "Output: $OutputDir"
Write-Host "Format: $FormatUpper"
Write-Host ""

# ファイル一覧取得
if (Test-Path $InputPath -PathType Container) {
    $PumlFiles = Get-ChildItem -Path $InputPath -Filter "*.puml"
} else {
    $PumlFiles = Get-Item $InputPath
}

if ($PumlFiles.Count -eq 0) {
    Write-Warning "No .puml files found"
    exit 0
}

Write-Host "Found $($PumlFiles.Count) .puml file(s)" -ForegroundColor Yellow
Write-Host ""

# 検証・生成
$SuccessCount = 0
$ErrorCount = 0
$GeneratedFiles = @()
$ReviewLogs = @()

foreach ($File in $PumlFiles) {
    Write-Host "Processing: $($File.Name)" -ForegroundColor White

    # Publish時はレビューログ検証
    if ($Publish) {
        $validation = Test-ReviewLog $File.FullName
        if (-not $validation.valid) {
            Write-Host "  [ERROR] $($validation.error)" -ForegroundColor Red
            $ErrorCount++
            continue
        }
        Write-Host "  [OK] Review verified (reviewed at: $($validation.reviewedAt))" -ForegroundColor Green
    }

    $TempOutput = if ($Publish) { $OutputDir } else { $File.DirectoryName }

    $Process = Start-Process -FilePath "java" `
        -ArgumentList "-jar", "`"$PlantUmlJar`"", $FormatOption, "-charset", "UTF-8", "-o", "`"$TempOutput`"", "`"$($File.FullName)`"" `
        -NoNewWindow -Wait -PassThru -RedirectStandardError "$env:TEMP\plantuml_err.txt"

    if ($Process.ExitCode -eq 0) {
        $OutputName = [System.IO.Path]::GetFileNameWithoutExtension($File.Name) + ".$Format"

        # @startumlの名前から出力ファイル名を特定
        $Content = Get-Content $File.FullName -Raw
        if ($Content -match '@startuml\s+(\w+)') {
            $OutputName = $Matches[1] + ".$Format"
        }

        $OutputPath = Join-Path $TempOutput $OutputName
        if (Test-Path $OutputPath) {
            Write-Host "  [OK] Generated: $OutputName" -ForegroundColor Green
            $GeneratedFiles += $OutputPath
            $SuccessCount++

            # Review時はレビューログ生成
            if ($Review) {
                $hash = Get-FileHashValue $File.FullName
                $timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
                $logPath = New-ReviewLog $File.FullName $hash $timestamp
                $ReviewLogs += $logPath
                Write-Host "  [OK] Review log: $(Split-Path -Leaf $logPath)" -ForegroundColor Cyan
            }
        } else {
            # フォールバック: ファイル名ベースで検索
            $RecentFiles = Get-ChildItem -Path $TempOutput -Filter "*.$Format" |
                Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-1) }
            if ($RecentFiles) {
                Write-Host "  [OK] Generated: $($RecentFiles.Name -join ', ')" -ForegroundColor Green
                $GeneratedFiles += $RecentFiles.FullName
                $SuccessCount++

                # Review時はレビューログ生成
                if ($Review) {
                    $hash = Get-FileHashValue $File.FullName
                    $timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
                    $logPath = New-ReviewLog $File.FullName $hash $timestamp
                    $ReviewLogs += $logPath
                    Write-Host "  [OK] Review log: $(Split-Path -Leaf $logPath)" -ForegroundColor Cyan
                }
            } else {
                Write-Host "  [WARN] $FormatUpper may not have been generated" -ForegroundColor Yellow
            }
        }
    } else {
        $ErrorMsg = Get-Content "$env:TEMP\plantuml_err.txt" -ErrorAction SilentlyContinue
        Write-Host "  [ERROR] Failed to generate $FormatUpper" -ForegroundColor Red
        if ($ErrorMsg) {
            Write-Host "  $ErrorMsg" -ForegroundColor Red
        }
        $ErrorCount++
    }
}

# サマリー
Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Success: $SuccessCount" -ForegroundColor Green
Write-Host "Errors:  $ErrorCount" -ForegroundColor $(if ($ErrorCount -gt 0) { "Red" } else { "Green" })

# 次のステップ案内
Write-Host ""
if ($Review -and $SuccessCount -gt 0) {
    Write-Host "=== Next Steps ===" -ForegroundColor Yellow
    Write-Host "1. Read the generated PNG with Claude (visual review)"
    Write-Host "2. Perform 4-pass review:"
    Write-Host "   - Pass 1: Structure (swimlanes, start/end)"
    Write-Host "   - Pass 2: Connections (arrows, no breaks)"
    Write-Host "   - Pass 3: Content (text, labels)"
    Write-Host "   - Pass 4: Style (colors, notes)"
    Write-Host "3. Update review log with results:"
    Write-Host "   - Edit .review.json: set status to 'completed' or 'failed'"
    Write-Host "   - Update pass results and issues"
    Write-Host "4. If completed, run -Publish:"
    Write-Host ""
    Write-Host "   .\validate_plantuml.ps1 -InputPath `"$InputPath`" -Publish -DiagramType <type>" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Generated files:" -ForegroundColor Gray
    foreach ($f in $GeneratedFiles) {
        Write-Host "  PNG: $f" -ForegroundColor Gray
    }
    foreach ($f in $ReviewLogs) {
        Write-Host "  LOG: $f" -ForegroundColor Gray
    }
}

if ($Publish -and $SuccessCount -gt 0) {
    Write-Host "=== Published ===" -ForegroundColor Green
    Write-Host "Official SVGs saved to: $OutputDir"
    Write-Host ""
    Write-Host "Generated SVG files:" -ForegroundColor Gray
    foreach ($f in $GeneratedFiles) {
        Write-Host "  $f" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "Don't forget to commit:" -ForegroundColor Yellow
    Write-Host "  git add docs/proposals/diagrams/"
    Write-Host "  git commit -m `"docs: Add $DiagramType diagram`""
}

exit $ErrorCount
