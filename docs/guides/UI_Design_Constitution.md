# UI設計図表開発憲法

**バージョン**: 1.0
**最終更新**: 2025-12-22

ClaudeCodeが高品質なUI設計図表（ワイヤーフレーム・画面遷移図）を作成するための行動規範。

---

## 目次

| セクション | 内容 | 参照タイミング |
|-----------|------|---------------|
| [§0 用語定義](#0-用語定義) | 本憲法で使用する用語の定義 | 初回・不明時 |
| [§1 2成果物方式](#1-2成果物方式) | 全体フロー、作成順序 | 作業開始時 |
| [§2 禁止事項](#2-禁止事項must-not) | やってはいけないこと | 作業前確認 |
| [§3 技術的制限](#3-技術的制限と回避策) | ツールの制約と回避策 | コード作成前 |
| [§4 レビュー手順](#4-レビュー手順) | 評価・確認プロセス | レビュー時 |
| [§5 コマンドリファレンス](#5-コマンドリファレンス) | スクリプト実行方法 | 実行時 |
| [§6 ディレクトリ構成](#6-ディレクトリ構成) | ファイル配置ルール | 作業開始時 |
| [付録](#付録) | 画面一覧テンプレート、スタイル設定例 | 必要時 |

---

## 0. 用語定義

### 成果物用語

| 用語 | 定義 |
|------|------|
| **ワイヤーフレーム** | 各画面のレイアウト・UI要素を示す低精度図表（Excalidraw） |
| **画面遷移図** | 画面間のナビゲーション・遷移を示す図表（PlantUML state） |
| **2成果物方式** | ワイヤーフレームと画面遷移図を別々に作成する方式 |

### TD-015原則（必読）

| 原則 | 説明 |
|:----:|------|
| **低精度** | Low-Fidelity（低忠実度）が正解。ピクセルパーフェクトは不要 |
| **手書き風** | 要件変更の柔軟性を示す。シャープなデザインは設計フェーズ以降 |
| **グレースケール** | 色の議論を避ける。色は設計フェーズで決定 |

> **参照**: `.serena/memories/wireframe_research_td015_decision_2025-11-26_29.md`

### ファイル用語

| 用語 | 定義 | 例 |
|------|------|-----|
| **Excalidrawファイル** | `.excalidraw`拡張子のJSON形式ファイル | `login.excalidraw` |
| **PlantUMLソース** | `.puml`拡張子のテキストファイル | `screen_transition.puml` |
| **正式版** | レビュー済みの`docs/proposals/`内ファイル | SVG, PNG, Markdown |

---

## 1. 2成果物方式

### 1.1 全体フロー

```
┌─────────────────────────────────────────────────────────────┐
│  Phase 0: 画面一覧の確定                                     │
│           └─ UC図・業務フロー図から画面を抽出               │
│                    ↓                                        │
│  Phase 1: ワイヤーフレーム作成（Excalidraw）                 │
│           ├─ TD-015原則に従う（低精度、手書き風、グレー）   │
│           ├─ 各画面を個別ファイルで作成                     │
│           └─ PNG/SVGエクスポート                            │
│                    ↓                                        │
│  Phase 2: 画面遷移図作成（PlantUML state diagram）           │
│           ├─ Context7で構文確認                              │
│           ├─ 画面をノードとして配置                         │
│           └─ 遷移ロジックを矢印で表現                       │
│                    ↓                                        │
│  Phase 3: レビュー・統合                                     │
│           ├─ 視覚的レビュー                                 │
│           ├─ 統合版Markdownに追記                           │
│           └─ active_context.md更新                          │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 成果物サマリ

| 成果物 | ツール | 形式 | 目的 |
|--------|--------|------|------|
| **ワイヤーフレーム** | Excalidraw | .excalidraw + PNG/SVG | 各画面のレイアウト定義 |
| **画面遷移図** | PlantUML | .puml + SVG | 画面間の遷移ロジック定義 |

### 1.3 PRDでの配置

```markdown
# PRD構成

§9 画面遷移図
  └─ PlantUML state diagram（全体の流れを俯瞰）

§10 ワイヤーフレーム
  └─ Excalidraw（各画面の詳細）
  └─ 画面遷移図の各ノードに対応
```

---

## 2. 禁止事項（MUST NOT）

以下の行為は**絶対に禁止**する。

### ワイヤーフレーム作成時

| # | 禁止事項 | 理由 |
|:-:|---------|------|
| 1 | **ピクセルパーフェクトを目指す** | TD-015違反。要件定義フェーズでは低精度が正解 |
| 2 | **カラフルなデザインにする** | TD-015違反。グレースケールで色の議論を避ける |
| 3 | **細かいUI調整に時間をかける** | 設計フェーズの作業。要件定義では大まかな構成が重要 |
| 4 | **画面一覧を確定せずに作成開始する** | 抜け漏れ・手戻りが発生する |

### 画面遷移図作成時

| # | 禁止事項 | 理由 |
|:-:|---------|------|
| 5 | **Context7確認なしでPlantUMLコードを書く** | 構文エラーの見落とし |
| 6 | **存在しない画面をノードにする** | ワイヤーフレームと不整合 |
| 7 | **遷移トリガーを省略する** | ユーザー操作が不明確になる |
| 8 | **SVGのXMLテキストで視覚確認したと判断する** | 画像として認識されない |

### 共通

| # | 禁止事項 | 理由 |
|:-:|---------|------|
| 9 | **UC図・業務フロー図との整合性を確認しない** | 機能漏れ・矛盾が発生する |
| 10 | **レビューなしでPublishする** | 品質保証の証跡がない |

---

## 3. 技術的制限と回避策

### 3.1 Excalidrawの制限

| # | 制限 | 回避策 |
|:-:|------|--------|
| 1 | Context7で「描き方」を取得できない | TD-015原則 + 本憲法に従う |
| 2 | 構文検証ができない（GUIツール） | 視覚的レビューで確認 |

> **注意**: Excalidrawは自由度が高いため、TD-015原則を意識的に守る必要がある。

### 3.2 PlantUML state diagramの制限

Context7確認結果: **重大な構文制限なし**（シーケンス図より単純）

| # | 機能 | 構文 | 備考 |
|:-:|------|------|------|
| 1 | 開始点 | `[*] --> State` | 必須 |
| 2 | 終了点 | `State --> [*]` | 必須 |
| 3 | 遷移 | `State1 --> State2 : ラベル` | ラベル推奨 |
| 4 | 複合状態 | `state Name { ... }` | ネスト可能 |
| 5 | 分岐 | `<<choice>>` | 条件分岐 |
| 6 | 並行 | `<<fork>>`, `<<join>>` | 並行処理 |
| 7 | ノート | `note right of State : 内容` | 補足説明 |
| 8 | 手書き風 | `!option handwritten true` | TD-015対応 |

### 3.3 既知の制限（発見次第追記）

| # | 発見日 | 制限内容 | 回避策 |
|:-:|--------|---------|--------|
| - | - | （現時点で未発見） | - |

---

## 4. レビュー手順

### 4.1 ワイヤーフレームのレビュー

| # | チェック項目 | 確認方法 |
|:-:|-------------|---------|
| 1 | TD-015原則に従っているか | 視覚確認（低精度、手書き風、グレー） |
| 2 | 画面一覧の全画面が作成されているか | チェックリスト照合 |
| 3 | 主要なUI要素が含まれているか | UC図・業務フロー図と照合 |
| 4 | 過度に詳細になっていないか | ピクセルパーフェクトでないことを確認 |

### 4.2 画面遷移図のレビュー

| # | チェック項目 | 確認方法 |
|:-:|-------------|---------|
| 1 | PNG生成が成功するか | `-Review`オプションで確認 |
| 2 | 全画面がノードとして存在するか | ワイヤーフレーム一覧と照合 |
| 3 | 遷移にラベル（トリガー）があるか | 視覚確認 |
| 4 | 開始点・終了点があるか | `[*]`の存在確認 |
| 5 | 孤立ノードがないか | 全ノードに入出力があることを確認 |

### 4.3 評価基準

| カテゴリ | 配点 | 評価内容 |
|---------|:----:|---------|
| TD-015準拠 | 25 | 低精度、手書き風、グレースケール |
| 網羅性 | 25 | 画面一覧との整合性 |
| 遷移ロジック | 25 | トリガー明記、孤立ノードなし |
| 可読性 | 15 | レイアウト、ラベルの明確さ |
| スタイル一貫性 | 10 | 命名規則、色分けの統一 |
| **合計** | **100** | **80点以上で合格** |

---

## 5. コマンドリファレンス

### 5.1 PlantUML画面遷移図

```powershell
# レビュー用PNG生成
powershell.exe scripts/validate_plantuml.ps1 -InputPath ".\screen_transition.puml" -Review

# 正式版SVG保存
powershell.exe scripts/validate_plantuml.ps1 -InputPath ".\screen_transition.puml" -Publish -DiagramType "state"
```

### 5.2 Excalidrawワイヤーフレーム

Obsidian Excalidraw Pluginを使用：
1. Obsidianで`.excalidraw`ファイルを開く
2. 編集完了後、右クリック → Export → PNG/SVG

または、Excalidraw公式サイト（https://excalidraw.com/）でエクスポート。

### 5.3 Context7参照

```
# PlantUML state diagram構文確認
mcp__context7__resolve-library-id → libraryName: "plantuml"
mcp__context7__get-library-docs   → topic: "state diagram"
```

---

## 6. ディレクトリ構成

### 6.1 作業ディレクトリ

```
docs/evidence/yyyyMMdd_HHmm_ui_design/
├── instructions.md              # 作業指示
├── 00_raw_notes.md              # 作業メモ
├── work_sheet.md                # 作業結果
├── wireframes/                  # ワイヤーフレーム
│   ├── 01_login.excalidraw
│   ├── 02_dashboard.excalidraw
│   └── ...
├── screen_transition.puml       # 画面遷移図ソース
└── screen_transition.review.json # レビューログ
```

### 6.2 正式版保存先

```
docs/proposals/
├── diagrams/
│   ├── 09_screen_transition/
│   │   └── PlantUML_Studio_ScreenTransition.svg
│   └── 10_wireframe/
│       ├── 01_login.svg
│       ├── 02_dashboard.svg
│       └── ...
├── 09_画面遷移図_yyyyMMdd.md    # 統合版Markdown
└── 10_ワイヤーフレーム_yyyyMMdd.md
```

### 6.3 命名規則

| 項目 | 規則 | 例 |
|------|------|-----|
| ワイヤーフレーム | `NN_画面名.excalidraw` | `01_login.excalidraw` |
| 画面遷移図 | `screen_transition.puml` | - |
| 正式版SVG | `PlantUML_Studio_ScreenTransition.svg` | - |

---

## 付録

### 付録A: 画面一覧テンプレート

作成前に画面一覧を確定すること。

```markdown
## 画面一覧（UC図・業務フロー図から抽出）

| # | 画面名 | カテゴリ | 対応UC | ワイヤーフレーム | 状況 |
|:-:|--------|:-------:|--------|:----------------:|:----:|
| 1 | ログイン画面 | 認証 | 1-1 | 01_login.excalidraw | 🔴 |
| 2 | 新規登録画面 | 認証 | 1-1 | 02_signup.excalidraw | 🔴 |
| 3 | ダッシュボード | メイン | 2-1 | 03_dashboard.excalidraw | 🔴 |
| 4 | エディタ画面 | メイン | 3-1〜3-6 | 04_editor.excalidraw | 🔴 |
| 5 | プロジェクト一覧 | メイン | 2-2〜2-4 | 05_projects.excalidraw | 🔴 |
| ... | ... | ... | ... | ... | ... |
```

### 付録B: PlantUML画面遷移図テンプレート

```plantuml
@startuml PlantUML_Studio_ScreenTransition

!option handwritten true

title 画面遷移図

skinparam state {
  BackgroundColor<<auth>> #FFFDE7
  BackgroundColor<<main>> #E3F2FD
  BackgroundColor<<modal>> #E8F5E9
  BorderColor #666666
}

' === 開始点 ===
[*] --> login

' === 認証画面 ===
state "ログイン画面" as login <<auth>>
state "新規登録画面" as signup <<auth>>
state "パスワードリセット" as reset <<auth>>

' === メイン画面 ===
state "ダッシュボード" as dashboard <<main>>
state "エディタ画面" as editor <<main>>
state "プロジェクト一覧" as projects <<main>>

' === モーダル ===
state "新規作成モーダル" as newModal <<modal>>

' === 認証フロー ===
login --> signup : 新規登録
login --> reset : パスワード忘れ
signup --> login : 登録完了
reset --> login : リセット完了
login --> dashboard : ログイン成功

' === メイン画面遷移 ===
dashboard --> projects : プロジェクト管理
dashboard --> editor : 図表を開く
dashboard --> newModal : 新規作成

projects --> editor : 図表を開く
projects --> dashboard : 戻る

editor --> dashboard : 閉じる

newModal --> editor : 作成開始
newModal --> dashboard : キャンセル

' === ログアウト ===
dashboard --> login : ログアウト
editor --> login : ログアウト

@enduml
```

### 付録C: Excalidrawスタイル設定

TD-015原則に従うための設定：

| 設定項目 | 推奨値 | 理由 |
|---------|--------|------|
| **Stroke style** | Hand-drawn | 手書き風 |
| **Roughness** | 1-2 | 低精度を表現 |
| **Background** | なし or 薄いグレー | グレースケール |
| **Stroke color** | 黒 or 濃いグレー | グレースケール |
| **Fill color** | 薄いグレー（#E0E0E0等） | グレースケール |
| **Font** | Hand-drawn | 手書き風 |

---

## 更新履歴

| 日付 | Ver | 内容 |
|------|:---:|------|
| 2025-12-22 | 1.0 | 初版作成（2成果物方式、TD-015原則統合） |
