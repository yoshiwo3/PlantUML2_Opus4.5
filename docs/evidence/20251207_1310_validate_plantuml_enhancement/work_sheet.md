# Work Sheet: validate_plantuml.ps1 機能拡張

## 作業概要

| 項目 | 内容 |
|------|------|
| 作業日 | 2025-12-07 |
| 作業者 | Claude (AI) |
| 作業時間 | 約30分 |
| 状態 | 完了 |

## 成果物

### 変更ファイル

| ファイル | 変更内容 |
|---------|---------|
| `scripts/validate_plantuml.ps1` | 2段階ワークフロー、レビューログ機能実装 |
| `docs/guides/PlantUML_SVG_Generation_Guide.md` | v3.0: レビューログ機能の説明追加 |

### 新機能

#### 1. 2段階ワークフロー

```powershell
# Phase 1: Review（PNG生成 + レビューログ生成）
.\validate_plantuml.ps1 -InputPath ".\diagram.puml" -Review

# Phase 2: Publish（レビューログ検証 + SVG生成）
.\validate_plantuml.ps1 -InputPath ".\diagram.puml" -Publish -DiagramType "business_flow"
```

#### 2. レビューログ機能

- ファイル: `<diagram>.review.json`
- 構造: current（現在）+ history（履歴）
- 検証: status=completed、ハッシュ一致

#### 3. 問題対策

| 問題 | 対策 | 実装 |
|------|------|------|
| レビューとPublishの紐付けなし | ハッシュ検証 | SHA256の先頭16文字で照合 |
| レビューOK判定が人間依存 | レビューログ必須 | status=completed必須 |

## 技術詳細

### レビューログ構造

```json
{
  "file": "diagram.puml",
  "current": {
    "hash": "A1B2C3D4E5F6G7H8",
    "timestamp": "2025-12-07T10:30:00",
    "status": "pending|completed|failed",
    "review": {
      "pass1_structure": true/false,
      "pass2_connections": true/false,
      "pass3_content": true/false,
      "pass4_style": true/false
    },
    "issues": [],
    "reviewed_at": "2025-12-07T10:35:00"
  },
  "history": [
    { /* 過去のレビュー結果 */ }
  ]
}
```

### Publish時検証

| # | 検証項目 | 失敗時エラー |
|:-:|---------|-------------|
| 1 | ログ存在 | "Review log not found. Run -Review first." |
| 2 | status=completed | "Review not completed. Status: pending/failed" |
| 3 | ハッシュ一致 | "File modified after review. Run -Review again." |

## 次のアクション

- [ ] 実際の図表作成でワークフローを検証
- [ ] Claudeによるレビューログ更新手順の確認

## 関連ドキュメント

- `docs/guides/PlantUML_SVG_Generation_Guide.md` - v3.0
- `CLAUDE.md` - PlantUML Code Rulesセクション
