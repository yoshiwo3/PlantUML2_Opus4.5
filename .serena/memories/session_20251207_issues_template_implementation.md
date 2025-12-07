# Session: validate_plantuml.ps1 issuesテンプレート実装

**日付**: 2025-12-07
**作業**: issuesテンプレート機能の実装

## 実装内容

### 変更ファイル

| ファイル | 変更内容 |
|---------|---------|
| `scripts/validate_plantuml.ps1` | issuesテンプレート追加（PSCustomObject使用） |
| `docs/guides/PlantUML_SVG_Generation_Guide.md` | v3.1更新（操作手順、トラブルシューティング追加） |
| `CLAUDE.md` | Step 5にissues操作手順追加 |
| `docs/guides/validate_plantuml_issues_template_spec.md` | ステータス更新（実装完了） |

### issuesテンプレート構造

```json
{
  "issues": [
    {
      "pass": null,
      "symptom": null,
      "cause": null
    }
  ]
}
```

### 技術的注意点

1. **UTF-8 BOM必須**: 日本語コメントがあるPowerShellスクリプトはBOM付きで保存
2. **PSCustomObject使用**: `@(@{...})`の直接ネストはパースエラーになる場合がある

### BOM付き保存コマンド

```powershell
$path = "scripts\validate_plantuml.ps1"
$content = Get-Content $path -Raw -Encoding UTF8
$utf8Bom = [System.Text.UTF8Encoding]::new($true)
[System.IO.File]::WriteAllText($path, $content, $utf8Bom)
```

### Claudeの操作手順

**問題なしの場合**:
1. `issues`を空配列`[]`に変更
2. `review`の各passを`true`に変更
3. `status`を`"completed"`に変更
4. `reviewed_at`に現在日時を記入

**問題ありの場合**:
1. テンプレートの`pass`/`symptom`/`cause`に値を記入
2. 複数問題がある場合はオブジェクトを追加
3. `status`を`"failed"`に変更

## 関連ドキュメント

- `docs/guides/validate_plantuml_issues_template_spec.md` - 仕様書
- `docs/guides/PlantUML_SVG_Generation_Guide.md` - ガイド（v3.1）
