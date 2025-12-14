# Evidence 3点セット自動作成スクリプト（Windows PowerShell）
# 使用方法: pwsh scripts/create_evidence.ps1 <evidence_name>
# 命名規則: yyyyMMdd_HHmm_<work_type>
# 例: pwsh scripts/create_evidence.ps1 20251214_2100_sequence_diagram_analysis

param(
    [Parameter(Mandatory=$true)]
    [string]$WorkType
)

# エラーハンドリング
$ErrorActionPreference = "Stop"

# 現在の日時取得
$DateStr = Get-Date -Format "yyyyMMdd"
$TimeStr = Get-Date -Format "HHmm"
$DateTimeStr = Get-Date -Format "yyyy-MM-dd HH:mm"

# Evidenceディレクトリパス
# 命名規則: yyyyMMdd_HHmm_<work_type> (例: 20251207_0902_admin_flow_mvp)
# ユーザーがフルネームを渡す想定（日時を含む）
$EvidenceDir = "docs/evidence/$WorkType"

# ディレクトリ作成
Write-Host "Evidenceディレクトリ作成: $EvidenceDir" -ForegroundColor Cyan
New-Item -ItemType Directory -Path $EvidenceDir -Force | Out-Null

# instructions.mdテンプレートコピー
$InstructionsSrc = "docs/templates/instructions_template.md"
$InstructionsDest = "$EvidenceDir/instructions.md"

if (Test-Path $InstructionsSrc) {
    Write-Host "instructions.md作成中..." -ForegroundColor Cyan
    $InstructionsContent = Get-Content $InstructionsSrc -Raw

    # プレースホルダー置換
    $InstructionsContent = $InstructionsContent -replace '<作業タイトル>', $WorkType
    $InstructionsContent = $InstructionsContent -replace 'YYYY-MM-DD HH:MM', $DateTimeStr
    $InstructionsContent = $InstructionsContent -replace 'feature / review / research / migration / refactor / bugfix', $WorkType

    Set-Content -Path $InstructionsDest -Value $InstructionsContent -Encoding UTF8
    Write-Host "instructions.md作成完了: $InstructionsDest" -ForegroundColor Green
} else {
    Write-Host "テンプレートが見つかりません: $InstructionsSrc" -ForegroundColor Yellow
}

# 00_raw_notes.mdテンプレートコピー
$RawNotesSrc = "docs/templates/00_raw_notes_template.md"
$RawNotesDest = "$EvidenceDir/00_raw_notes.md"

if (Test-Path $RawNotesSrc) {
    Write-Host "00_raw_notes.md作成中..." -ForegroundColor Cyan
    $RawNotesContent = Get-Content $RawNotesSrc -Raw

    # プレースホルダー置換
    $RawNotesContent = $RawNotesContent -replace '<作業タイトル>', $WorkType
    $RawNotesContent = $RawNotesContent -replace 'YYYY-MM-DD HH:MM', $DateTimeStr
    $RawNotesContent = $RawNotesContent -replace '<work_type>', $WorkType
    $RawNotesContent = $RawNotesContent -replace 'HH:MM', (Get-Date -Format "HH:mm")

    Set-Content -Path $RawNotesDest -Value $RawNotesContent -Encoding UTF8
    Write-Host "00_raw_notes.md作成完了: $RawNotesDest" -ForegroundColor Green
} else {
    Write-Host "テンプレートが見つかりません: $RawNotesSrc" -ForegroundColor Yellow
}

# Git状態表示
Write-Host "`nGit状態:" -ForegroundColor Cyan
git status --short

# 次のステップガイド
Write-Host "`n次のステップ:" -ForegroundColor Cyan
Write-Host "1. instructions.md を編集（目標、コンテキスト、実施内容、完了条件）" -ForegroundColor White
Write-Host "2. 作業開始（00_raw_notes.md にリアルタイム記録）" -ForegroundColor White
Write-Host "3. 作業完了後、work_sheet.md を作成（テンプレート: docs/templates/work_sheet_template.md）" -ForegroundColor White
Write-Host "4. Git commit and push" -ForegroundColor White

Write-Host "`nEvidence 3点セット初期化完了！" -ForegroundColor Green
