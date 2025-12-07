# PlantUML環境構成ガイド

**作成日**: 2025-12-07
**バージョン**: 1.0

---

## 概要

本ガイドは、PlantUML図表作成に必要な環境構成とスクリプトの使用方法を説明する。

**ルール・プロセスについては別ドキュメントを参照:**
- `docs/guides/PlantUML_Development_Constitution.md` - 禁止事項、既知制限、必須プロセス

---

## 環境構成

### 必要なソフトウェア

| ソフトウェア | バージョン | 用途 |
|-------------|-----------|------|
| Java | 17以上推奨（21.0.7で動作確認済み） | PlantUML実行環境 |
| Graphviz | 2.44以上（2.44.1で動作確認済み） | クラス図、コンポーネント図等のレイアウトエンジン |
| PowerShell | 5.1以上 | 検証スクリプト実行 |
| PlantUML JAR | 1.2025.2 (MIT版) | SVG/PNG生成 |

### Graphvizの必要性

| 図表タイプ | Graphviz必要 | 備考 |
|-----------|:------------:|------|
| アクティビティ図（新構文） | - | 業務フロー図で使用 |
| シーケンス図 | - | - |
| クラス図 | 必要 | dotレイアウト使用 |
| コンポーネント図 | 必要 | dotレイアウト使用 |
| ユースケース図 | 必要 | dotレイアウト使用 |
| 状態図 | 必要 | dotレイアウト使用 |
| ER図 | 必要 | dotレイアウト使用 |

### Graphvizインストール確認

```powershell
java -jar "C:\temp\vscode\.plantuml\plantuml-mit-1.2025.2.jar" -testdot
```

**期待される出力**:
```
Dot version: dot - graphviz version 2.44.1 (20200629.0846)
Installation seems OK. File generation OK
```

### Graphvizインストール（未インストールの場合）

```powershell
# Chocolateyを使用
choco install graphviz

# または公式サイトからダウンロード
# https://graphviz.org/download/
```

### ディレクトリ構成

```
PlantUML2_Opus4.5/
├── scripts/
│   └── validate_plantuml.ps1     # 検証・SVG生成スクリプト
└── docs/
    ├── proposals/
    │   └── diagrams/             # 正式版SVG保存先
    │       ├── business_flow/    # 業務フロー図
    │       ├── sequence/         # シーケンス図
    │       ├── usecase/          # ユースケース図
    │       ├── context/          # コンテキスト図
    │       ├── component/        # コンポーネント図
    │       ├── class/            # クラス図
    │       └── dfd/              # データフロー図
    └── evidence/
        └── <yyyyMMdd_HHmm_xxx>/  # 一時検証用
```

---

## スクリプトリファレンス

### validate_plantuml.ps1

2段階のワークフローでPlantUML図表を管理するスクリプト。

#### パラメータ

| パラメータ | 必須 | 説明 |
|-----------|:----:|------|
| `-InputPath` | 必須 | 検証対象の.pumlファイルまたはディレクトリ |
| `-Review` | 択一 | レビューモード: PNG形式で出力（視覚的レビュー用） |
| `-Publish` | 択一 | 正式版保存モード: SVG形式でproposals/diagrams/に出力 |
| `-DiagramType` | 条件付 | 図表タイプ（-Publish時に必須） |

※ `-Review`または`-Publish`のいずれかを必ず指定

#### DiagramType一覧

| DiagramType | 説明 |
|-------------|------|
| `business_flow` | 業務フロー図 |
| `sequence` | シーケンス図 |
| `usecase` | ユースケース図 |
| `context` | コンテキスト図 |
| `component` | コンポーネント図 |
| `class` | クラス図 |
| `dfd` | データフロー図 |

#### 使用例

```powershell
# Phase 1: レビュー用PNG生成
pwsh scripts/validate_plantuml.ps1 -InputPath ".\diagram.puml" -Review

# Phase 2: 正式版SVG保存
pwsh scripts/validate_plantuml.ps1 -InputPath ".\diagram.puml" -Publish -DiagramType "sequence"

# ディレクトリ内の全ファイルをレビュー
pwsh scripts/validate_plantuml.ps1 -InputPath ".\puml_files\" -Review
```

#### 出力例（Review）

```
=== PlantUML Review Mode (PNG) ===
Generate PNG for visual review with Claude

Input:  .\diagram.puml
Output: C:\d\PlantUML2_Opus4.5
Format: PNG

Found 1 .puml file(s)

Processing: diagram.puml
  [OK] Generated: my_sequence.png
  [OK] Review log: diagram.review.json

=== Summary ===
Success: 1
Errors:  0

=== Next Steps ===
1. Read the generated PNG with Claude (visual review)
2. Perform 4-pass review:
   - Pass 1: Structure (swimlanes, start/end)
   - Pass 2: Connections (arrows, no breaks)
   - Pass 3: Content (text, labels)
   - Pass 4: Style (colors, notes)
3. Update review log with results:
   - Edit .review.json: set status to 'completed' or 'failed'
   - Update pass results and issues
4. If completed, run -Publish
```

#### 出力例（Publish - 成功）

```
=== PlantUML Publish Mode (SVG) ===
Save official SVG to proposals/diagrams/sequence

Input:  .\diagram.puml
Output: C:\d\PlantUML2_Opus4.5\docs\proposals\diagrams\sequence
Format: SVG

Found 1 .puml file(s)

Processing: diagram.puml
  [OK] Review verified (reviewed at: 2025-12-07T10:35:00)
  [OK] Generated: my_sequence.svg

=== Summary ===
Success: 1
Errors:  0

=== Published ===
Official SVGs saved to: C:\d\PlantUML2_Opus4.5\docs\proposals\diagrams\sequence
```

#### 出力例（Publish - 失敗：レビュー未完了）

```
Processing: diagram.puml
  [ERROR] Review not completed. Status: pending
```

#### 出力例（Publish - 失敗：ファイル変更）

```
Processing: diagram.puml
  [ERROR] File modified after review. Run -Review again.
```

### レビューログ構造

`-Review`実行時に自動生成される`.review.json`の構造：

```json
{
  "file": "diagram.puml",
  "current": {
    "hash": "A1B2C3D4E5F6G7H8",
    "timestamp": "2025-12-07T10:30:00",
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

## トラブルシューティング

### Javaが見つからない

```
エラー: Java is not installed or not in PATH
```

**解決策**: Java 17以上をインストールし、PATHに追加する。

### plantuml.jarが見つからない

```
エラー: plantuml.jar not found at: C:\temp\vscode\.plantuml\plantuml-mit-1.2025.2.jar
```

**解決策**:
1. VSCode PlantUML拡張機能をインストール
2. 拡張機能がJARを自動ダウンロード
3. または手動でダウンロード:
```powershell
mkdir -p "C:\temp\vscode\.plantuml"
curl -L -o "C:\temp\vscode\.plantuml\plantuml-mit-1.2025.2.jar" "https://github.com/plantuml/plantuml/releases/download/v1.2025.2/plantuml-mit-1.2025.2.jar"
```

### 文字化け

**解決策**: `-charset UTF-8`オプションを使用（スクリプトではデフォルトで適用済み）。

### スクリプト修正時の注意（開発者向け）

`validate_plantuml.ps1`を修正する際は、以下に注意：

| 項目 | 対応 |
|------|------|
| **エンコーディング** | UTF-8 **BOM付き**で保存する（日本語コメントがあるため） |
| **ハッシュテーブル配列** | `@(@{...})`の直接ネストはパースエラーになる場合がある。`[PSCustomObject]@{}`を使用 |

**BOM付きで保存する方法**:
```powershell
$path = "scripts\validate_plantuml.ps1"
$content = Get-Content $path -Raw -Encoding UTF8
$utf8Bom = [System.Text.UTF8Encoding]::new($true)
[System.IO.File]::WriteAllText($path, $content, $utf8Bom)
```

---

## 関連ドキュメント

| ドキュメント | パス |
|-------------|------|
| PlantUML開発憲法 | `docs/guides/PlantUML_Development_Constitution.md` |
| プロジェクトガイド | `CLAUDE.md` |
| issuesテンプレート仕様書 | `docs/guides/validate_plantuml_issues_template_spec.md` |
| PlantUML公式 | https://plantuml.com/ |
| Serenaメモリ | `.serena/memories/plantuml_svg_generation_standard.md` |

---

## 変更履歴

| 日付 | バージョン | 変更内容 |
|------|-----------|---------|
| 2025-12-07 | 1.0 | PlantUML_SVG_Generation_Guide.md v4.0から環境構成・スクリプト部分を抽出して新規作成 |
