# PlantUML SVG生成・視覚的レビュー標準

**作成日**: 2025-12-07

## 概要

PlantUML図表作成時のSVG生成・視覚的レビューのスタンダード。

## PlantUML JAR

**パス**: `C:\temp\vscode\.plantuml\plantuml-mit-1.2025.2.jar`

VSCode PlantUML拡張機能と共有。MIT版（v1.2025.2）を使用。

## ディレクトリ構成

```
PlantUML2_Opus4.5/
├── scripts/
│   └── validate_plantuml.ps1     # 検証・生成スクリプト
└── docs/proposals/diagrams/      # 正式版SVG保存先
    ├── business_flow/
    ├── sequence/
    ├── usecase/
    ├── context/
    ├── component/
    ├── class/
    └── dfd/
```

## 必須フロー

```
1. Context7で仕様確認
2. コード作成
3. SVG生成・バリデーション
4. 視覚的レビュー（Claude読み込み）
5. 保存
```

## SVG生成方法

### 方法1: スクリプト使用（推奨）

```powershell
# 単一ファイル検証
pwsh scripts/validate_plantuml.ps1 -InputPath ".\diagram.puml"

# 正式版として保存
pwsh scripts/validate_plantuml.ps1 -InputPath ".\diagram.puml" -DiagramType "business_flow" -OutputToProposals
```

### 方法2: 直接実行

```powershell
java -jar tools/plantuml.jar -tsvg -charset UTF-8 diagram.puml
```

## 視覚的レビュー

生成されたSVGをClaudeのReadツールで読み込み、以下を確認：

- フローの論理的正確性
- スイムレーンの接続線
- 色分け・noteの適切性
- 全体のレイアウト

## 保存先ルール

| 用途 | 保存先 |
|------|--------|
| 正式版SVG | `docs/proposals/diagrams/<図表タイプ>/` |
| 一時検証用 | `docs/evidence/<日付>/` |

## DiagramType一覧

- business_flow: 業務フロー図
- sequence: シーケンス図
- usecase: ユースケース図
- context: コンテキスト図
- component: コンポーネント図
- class: クラス図
- dfd: データフロー図

## 関連ファイル

- `CLAUDE.md` - PlantUML Code Rulesセクション
- `scripts/validate_plantuml.ps1` - 検証スクリプト
- `tools/plantuml.jar` - PlantUML JAR
