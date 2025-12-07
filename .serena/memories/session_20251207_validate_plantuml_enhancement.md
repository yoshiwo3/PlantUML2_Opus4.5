# Session: validate_plantuml.ps1 機能拡張

**日付**: 2025-12-07
**作業**: PlantUML検証スクリプトの機能拡張

## 実装内容

### 2段階ワークフロー
- `-Review`: PNG生成 + レビューログ生成（status: pending）
- `-Publish`: レビューログ検証 + SVG生成

### レビューログ機能（.review.json）
- ファイル構造: current + history
- 検証項目:
  1. ログ存在確認
  2. status = completed
  3. ハッシュ一致（SHA256先頭16文字）

### 問題対策
| 問題 | 対策 |
|------|------|
| レビューとPublishの紐付けなし | ハッシュ検証 |
| レビューOK判定が人間依存 | status=completed必須 |

## 変更ファイル
- `scripts/validate_plantuml.ps1` - v3.0
- `docs/guides/PlantUML_SVG_Generation_Guide.md` - v3.0

## 使用方法

```powershell
# Phase 1: Review
.\validate_plantuml.ps1 -InputPath ".\diagram.puml" -Review

# Claudeがレビュー → .review.json更新（status: completed）

# Phase 2: Publish
.\validate_plantuml.ps1 -InputPath ".\diagram.puml" -Publish -DiagramType "business_flow"
```

## Evidence
`docs/evidence/20251207_1310_validate_plantuml_enhancement/`
