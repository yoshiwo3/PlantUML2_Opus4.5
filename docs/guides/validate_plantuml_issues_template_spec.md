# スクリプト修正指示書: validate_plantuml.ps1

**作成日**: 2025-12-07
**ステータス**: 実装完了（2025-12-07）

---

## 修正概要

| 項目 | 内容 |
|------|------|
| 対象ファイル | `scripts/validate_plantuml.ps1` |
| 修正箇所 | `New-ReviewLog`関数内の`issues`初期化部分 |
| 目的 | issuesテンプレート構造を生成し、Claudeの記入を容易にする |

---

## 修正内容

### 変更前（行91-103付近）

```powershell
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
    issues = @()
    reviewed_at = $null
}
```

### 変更後

```powershell
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
    issues = @(
        @{
            pass = $null
            symptom = $null
            cause = $null
        }
    )
    reviewed_at = $null
}
```

---

## 生成されるJSON

```json
{
  "file": "diagram.puml",
  "current": {
    "hash": "A1B2C3D4E5F6G7H8",
    "timestamp": "2025-12-07T13:30:00",
    "status": "pending",
    "review": {
      "pass1_structure": false,
      "pass2_connections": false,
      "pass3_content": false,
      "pass4_style": false
    },
    "issues": [
      {
        "pass": null,
        "symptom": null,
        "cause": null
      }
    ],
    "reviewed_at": null
  },
  "history": []
}
```

---

## Claudeの操作手順

### 問題なしの場合

1. `issues`を空配列`[]`に変更
2. `review`の各passを`true`に変更
3. `status`を`"completed"`に変更
4. `reviewed_at`に現在日時を記入

### 問題ありの場合

1. テンプレートの`pass`/`symptom`/`cause`に値を記入
2. 複数問題がある場合はオブジェクトを追加
3. `review`の該当passを`false`のまま維持
4. `status`を`"failed"`に変更
5. `reviewed_at`に現在日時を記入

---

## issues構造

| フィールド | 説明 | 例 |
|-----------|------|-----|
| `pass` | 問題を検出したパス番号（1-4） | `2` |
| `symptom` | 現象（何が起きているか） | `"接続線が途切れている"` |
| `cause` | 原因（なぜ起きているか） | `"if文内でスイムレーン遷移"` |

---

## 関連ドキュメント更新

| ファイル | 更新内容 |
|---------|---------|
| `docs/guides/PlantUML_SVG_Generation_Guide.md` | Step 3のレビューログ構造例を更新 |

---

## テスト確認項目

- [x] `-Review`実行でissuesテンプレートが生成される
- [x] ConvertTo-Jsonで正しくシリアライズされる
- [x] Claudeがテンプレートを編集できる
- [x] `-Publish`でissues内容に関わらず検証が通る（status/hash検証のみ）

> **テスト結果** (2025-12-07)
> - `tests/test_issues_template.puml` で動作確認済み
> - issues構造が正しくJSON出力されることを確認

---

## 変更履歴

| 日付 | 内容 |
|------|------|
| 2025-12-07 | 実装完了（PSCustomObject使用、UTF-8 BOM対応） |
| 2025-12-07 | 初版作成（未実装） |
