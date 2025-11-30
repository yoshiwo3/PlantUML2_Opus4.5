# 自動化スクリプト

## create_evidence.ps1 / create_evidence.sh

Evidence 3点セット（instructions.md, 00_raw_notes.md）を自動作成します。

### 使用方法

**Windows (PowerShell)**:
```powershell
pwsh scripts/create_evidence.ps1 <work_type>

# 例
pwsh scripts/create_evidence.ps1 feature_http_mcp
```

**Linux/macOS (Bash)**:
```bash
./scripts/create_evidence.sh <work_type>

# 例
./scripts/create_evidence.sh feature_http_mcp
```

### work_type命名規則

| 種別 | 説明 | 例 |
|------|------|-----|
| `feature_<name>` | 機能実装 | `feature_validation_loop` |
| `review_<name>` | レビュー・修正 | `review_technical_packages` |
| `research_<name>` | 調査・研究 | `research_cloudrun_pricing` |
| `migration_<name>` | 移行作業 | `migration_flyio_to_cloudrun` |
| `refactor_<name>` | リファクタリング | `refactor_mcp_architecture` |
| `bugfix_<name>` | バグ修正 | `bugfix_typescript_imports` |

### 実行内容

1. Evidenceディレクトリ自動作成（`docs/poc/evidence/<YYYYMMDD>/<work_type>/`）
2. instructions.md自動生成（プレースホルダー置換済み）
3. 00_raw_notes.md自動生成（プレースホルダー置換済み）
4. Git状態表示
5. 次のステップガイド表示

### 次のステップ

1. `instructions.md` を編集（目標、コンテキスト、実施内容、完了条件）
2. 作業開始（`00_raw_notes.md` にリアルタイム記録）
3. 作業完了後、`work_sheet.md` を作成（テンプレート: `docs/templates/work_sheet_template.md`）
4. Git commit & push

### トラブルシューティング

**テンプレートが見つからない**:
```bash
# テンプレートファイルが存在するか確認
ls -l docs/templates/

# 存在しない場合はテンプレート作成を再実行
```

**実行権限がない（Linux/macOS）**:
```bash
chmod +x scripts/create_evidence.sh
```
