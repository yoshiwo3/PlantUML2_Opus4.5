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

## 関連ドキュメント

| ドキュメント | パス |
|-------------|------|
| PlantUML開発憲法 | `docs/guides/PlantUML_Development_Constitution.md` |
| **スクリプトリファレンス** | `docs/guides/PlantUML_Script_Reference.md` |
| プロジェクトガイド | `CLAUDE.md` |
| issuesテンプレート仕様書 | `docs/guides/validate_plantuml_issues_template_spec.md` |
| PlantUML公式 | https://plantuml.com/ |

---

## 変更履歴

| 日付 | バージョン | 変更内容 |
|------|-----------|---------|
| 2025-12-07 | 1.1 | スクリプトリファレンス・トラブルシューティングを`validate_plantuml_reference.md`に分離 |
| 2025-12-07 | 1.0 | PlantUML_SVG_Generation_Guide.md v4.0から環境構成・スクリプト部分を抽出して新規作成 |
