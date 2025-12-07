# PlantUML SVG生成・視覚的レビューガイド

**作成日**: 2025-12-07
**バージョン**: 4.0

---

## 目次

1. [概要](#概要)
2. [環境構成](#環境構成)
3. [必須フロー](#必須フロー)
4. [Step 1: Context7で仕様確認](#step-1-context7で仕様確認)
5. [Step 2: コード作成](#step-2-コード作成)
6. [Step 3: PNG生成 + レビューログ生成](#step-3-png生成--レビューログ生成)
7. [Step 4: 視覚的レビュー（4パス方式）](#step-4-視覚的レビュー4パス方式)
8. [Step 5: ソース+PNG対比確認](#step-5-ソースpng対比確認)
9. [Step 6: レビューログ更新](#step-6-レビューログ更新)
10. [Step 7: 正式版SVG保存（Publish）](#step-7-正式版svg保存publish)
11. [PlantUML既知の制限と回避策](#plantuml既知の制限と回避策)
12. [イテレーティブ改善](#イテレーティブ改善)
13. [禁止事項](#禁止事項)
14. [スクリプトリファレンス](#スクリプトリファレンス)
15. [トラブルシューティング](#トラブルシューティング)
16. [関連ドキュメント](#関連ドキュメント)
17. [変更履歴](#変更履歴)

---

## 概要

本ガイドは、PlantUML図表作成時のSVG生成・視覚的レビューのスタンダードプロセスを定義する。

### 目的

- PlantUML図表の品質保証
- 視覚的レビューによる問題の早期発見
- 正式版SVGの一元管理

### 重要な前提

| 項目 | 内容 |
|------|------|
| **レビュー形式** | PNG形式を使用（SVGはXMLテキストとして返されるため視覚確認不可） |
| **レビューログ** | `.review.json`でレビュー結果・履歴を管理 |
| **正式版保存** | レビュー完了（status: completed）& ハッシュ一致の場合のみ |

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
| アクティビティ図（新構文） | ❌ | 業務フロー図で使用 |
| シーケンス図 | ❌ | - |
| クラス図 | ✅ | dotレイアウト使用 |
| コンポーネント図 | ✅ | dotレイアウト使用 |
| ユースケース図 | ✅ | dotレイアウト使用 |
| 状態図 | ✅ | dotレイアウト使用 |
| ER図 | ✅ | dotレイアウト使用 |

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

## 必須フロー

PlantUML図表を作成する際は、以下の2段階ワークフローを**必ず**実行する。

```
┌─────────────────────────────────────────────────────────────────┐
│  1. Context7で仕様確認                                           │
│           ↓                                                     │
│  2. コード作成（.puml）                                          │
│           ↓                                                     │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Phase 1: Review (-Review)                               │    │
│  │   3. PNG生成 + レビューログ生成（.review.json）          │    │
│  │   4. 視覚的レビュー（4パス方式）                         │    │
│  │   5. ソース+PNG対比確認（上流・下流接続）                │    │
│  │   6. レビューログ更新（status/issues記録）               │    │
│  └─────────────────────────────────────────────────────────┘    │
│           ↓                                                     │
│       問題あり？ ─→ はい ─→ Step 2に戻る（履歴保持）            │
│           ↓ いいえ                                              │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Phase 2: Publish (-Publish)                             │    │
│  │   7. レビューログ検証（completed & ハッシュ一致）        │    │
│  │      → SVG生成・正式版保存 → Gitコミット                │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Context7で仕様確認

PlantUML図表を新規作成・修正する前に、Context7 MCPで仕様を確認する。

```
mcp__context7__resolve-library-id → libraryName: "plantuml"
mcp__context7__get-library-docs   → topic: "<図表タイプ>"
```

### よく使うtopic

| 図表タイプ | topic |
|-----------|-------|
| アクティビティ図 | `"activity diagram swimlane"` |
| シーケンス図 | `"sequence diagram"` |
| ユースケース図 | `"use case diagram"` |
| クラス図 | `"class diagram"` |
| コンポーネント図 | `"component diagram"` |
| 状態図 | `"state diagram"` |

---

## Step 2: コード作成

Context7で確認した仕様に基づいてPlantUMLコードを作成する。

### ファイル命名規則

```
<図表名>.puml
```

例: `business_flow_admin_overview.puml`

### コード内の命名

`@startuml`の後にダイアグラム名を指定する（SVGファイル名になる）。

```plantuml
@startuml business_flow_admin_overview
...
@enduml
```

**⚠️ 重要**: コード作成前に「[PlantUML既知の制限と回避策](#plantuml既知の制限と回避策)」を確認し、問題パターンを避けること。

---

## Step 3: PNG生成 + レビューログ生成

### 検証スクリプト使用

```powershell
# プロジェクトルートから実行

# Phase 1: レビュー用PNG生成 + レビューログ生成
pwsh scripts/validate_plantuml.ps1 -InputPath ".\diagram.puml" -Review

# ディレクトリ内の全.pumlをレビュー
pwsh scripts/validate_plantuml.ps1 -InputPath ".\docs\evidence\20251207_admin_flow_review\" -Review
```

### 生成されるファイル

| ファイル | 説明 |
|---------|------|
| `diagram.png` | 視覚的レビュー用PNG |
| `diagram.review.json` | レビューログ（status: pending） |

### レビューログ構造

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

### DiagramType一覧

| DiagramType | 説明 |
|-------------|------|
| `business_flow` | 業務フロー図 |
| `sequence` | シーケンス図 |
| `usecase` | ユースケース図 |
| `context` | コンテキスト図 |
| `component` | コンポーネント図 |
| `class` | クラス図 |
| `dfd` | データフロー図 |

---

## Step 4: 視覚的レビュー（4パス方式）

生成されたPNGをClaudeがマルチモーダル機能で視覚的に分析する。

### 実行手順

```
1. Read tool → 生成されたPNGファイルを読み込み
2. マルチモーダル機能で視覚的に分析
3. 4パス方式で段階的にレビュー
```

### 4パス方式

接続線の見落としを防ぐため、**4段階に分けてレビュー**する。

| パス | 確認内容 | 重要度 |
|:---:|---------|:-----:|
| Pass 1 | **全体構造**: スイムレーン構成、開始/終了ノードの存在 | ○ |
| Pass 2 | **接続線**: すべての線が正しく結線されているか、途切れ・孤立ノードがないか | **最重要** |
| Pass 3 | **ノード内容**: テキスト、条件分岐ラベル、処理内容 | ○ |
| Pass 4 | **スタイル**: 色分け、note配置、レイアウト | ○ |

### Pass 2: 接続線チェックリスト（必須）

| # | 確認項目 | チェック内容 |
|:-:|---------|-------------|
| 1 | **開始ノード** | `start`から最初のアクションへ矢印が接続されているか |
| 2 | **終了ノード** | すべてのフローが`stop`または`end`に到達しているか |
| 3 | **分岐の結線** | `if/else`、`switch`の全分岐が正しく接続されているか |
| 4 | **スイムレーン間** | スイムレーンをまたぐ矢印が途切れていないか |
| 5 | **孤立ノード** | どこからも接続されていないノードがないか |
| 6 | **ループ構造** | `repeat`、`while`のループが正しく閉じているか |
| 7 | **並行処理** | `fork/join`、`split`が正しくペアになっているか |

### Pass 1, 3, 4: その他の確認項目

| パス | 項目 | 確認内容 |
|:---:|------|---------|
| 1 | 全体構造 | スイムレーン数、処理の流れの方向 |
| 3 | ノード内容 | テキストの正確性、条件分岐のラベル |
| 4 | 色分け | 成功=palegreen、エラー=mistyrose、確認=lightyellow |
| 4 | note | 補足説明が正しい位置に配置されているか |
| 4 | レイアウト | 幅・高さが適切か、可読性は十分か |

---

## Step 5: ソース+PNG対比確認

PNGの視覚確認だけでは接続線の途切れを見落としやすい。**PlantUMLソースコードとPNGを対比して確認**する。

### なぜ対比確認が必要か

| 確認方法 | 検出できること | 検出できないこと |
|---------|--------------|----------------|
| ソースコードのみ | 構文エラー、論理的な接続 | **描画されない接続線** |
| PNGのみ | 見た目の問題 | **どの行が原因か** |
| **ソース+PNG対比** | **コードでは接続→画像では途切れ**という不一致 | - |

PlantUMLには既知のレンダリングバグがあり、**コード上は正しくても描画されない接続線がある**（Issue #1007）。

### 上流・下流接続の確認手順

各ノードについて、**上流接続（入力）と下流接続（出力）の両方**を確認する。

```
        上流接続（入力）
              ↓
    ┌─────────────────┐
    │     ノード      │
    └─────────────────┘
              ↓
        下流接続（出力）
```

| 方向 | 確認内容 | 見落とすと |
|:---:|---------|-----------|
| **上流** | このノードに矢印が**入っているか** | 孤立ノード（どこからも到達不能） |
| **下流** | このノードから矢印が**出ているか** | 行き止まり（フローが途切れる） |

### 具体的な確認手順

```
1. PNGを読み込む（Read tool → マルチモーダル機能で視覚確認）
2. ソースコードを読み込む（Read tool）
3. スイムレーン遷移箇所を抽出（Grepパターン使用）
4. 各ノードの上流・下流接続をPNGで確認
5. 対比確認テーブルを作成して記録
```

### Grepパターンと出力例

#### スイムレーン遷移箇所を抽出

```powershell
grep -nE "^\s*\|.*\|" diagram.puml
```

**出力例**:
```
5:|開発者|
12:|Frontend Service|
18:|Supabase|
25:|Frontend Service|
32:|開発者|
```

#### if/fork構文を抽出

```powershell
grep -nE "^\s*(if |else|endif|fork|end fork)" diagram.puml
```

**出力例**:
```
8:if (確認?) then (はい)
15:else (キャンセル)
20:endif
28:if (成功?) then (はい)
35:else (エラー)
38:endif
```

### 対比確認テーブル（必須）

各ノードについて、上流・下流接続の状態を記録する：

```markdown
| ノード | 行 | 上流接続 | 下流接続 | 判定 |
|--------|:--:|:--------:|:--------:|:----:|
| start | 4 | - | ✅ →:操作選択 | OK |
| :操作選択; | 6 | ✅ start→ | ✅ →if | OK |
| :リクエスト送信; | 14 | ❌ なし | ✅ →:DB更新 | **要修正** |
| :DB更新; | 19 | ✅ →リクエスト | ❌ なし | **要修正** |
| stop | 40 | ✅ →完了通知 | - | OK |
```

### 具体例：問題のあるコードと対比確認

#### ソースコード（問題あり）

```plantuml
@startuml example_problem
|開発者|
start
:操作を選択;

if (確認?) then (はい)
  |Frontend Service|      ← 行7: if内でスイムレーン遷移
  :リクエスト送信;
  |Supabase|              ← 行9: if内でさらに遷移
  :DB更新;
else (キャンセル)
  :キャンセル;
  stop
endif

|Frontend Service|        ← 行16: endif直後のスイムレーン遷移
:結果表示;
stop
@enduml
```

#### 対比確認テーブル

| ノード | 行 | 上流接続 | 下流接続 | 判定 |
|--------|:--:|:--------:|:--------:|:----:|
| :操作を選択; | 4 | ✅ start→ | ✅ →if | OK |
| :リクエスト送信; | 8 | ❌ **なし** | ✅ →:DB更新 | **NG: 上流途切れ** |
| :DB更新; | 10 | ✅ :リクエスト→ | ❌ **なし** | **NG: 下流途切れ** |
| :結果表示; | 17 | ❌ **なし** | ✅ →stop | **NG: 上流途切れ** |

**問題**: if文内でのスイムレーン遷移により、行7, 9, 16で接続線が描画されていない。

---

## Step 6: レビューログ更新

4パスレビュー + ソース対比確認の完了後、`.review.json`を更新する。

### 問題なしの場合

1. `issues`を空配列`[]`に変更
2. `review`の各passを`true`に変更
3. `status`を`"completed"`に変更
4. `reviewed_at`に現在日時を記入（ISO 8601形式: `2025-12-07T10:35:00`）

```json
{
  "current": {
    "status": "completed",
    "review": {
      "pass1_structure": true,
      "pass2_connections": true,
      "pass3_content": true,
      "pass4_style": true
    },
    "issues": [],
    "reviewed_at": "2025-12-07T10:35:00"
  }
}
```

### 問題ありの場合

1. テンプレートの`pass`/`symptom`/`cause`に値を記入
2. 複数問題がある場合はオブジェクトを追加
3. `review`の該当passを`false`のまま維持
4. `status`を`"failed"`に変更
5. `reviewed_at`に現在日時を記入

```json
{
  "current": {
    "status": "failed",
    "review": {
      "pass1_structure": true,
      "pass2_connections": false,
      "pass3_content": true,
      "pass4_style": true
    },
    "issues": [
      {
        "pass": 2,
        "symptom": "行8「:リクエスト送信;」の上流接続がない",
        "cause": "if文内でスイムレーン遷移している（Issue #1007）"
      },
      {
        "pass": 2,
        "symptom": "行17「:結果表示;」の上流接続がない",
        "cause": "endif直後のスイムレーン遷移（Issue #1007）"
      }
    ],
    "reviewed_at": "2025-12-07T10:35:00"
  }
}
```

### issues構造

| フィールド | 説明 | 例 |
|-----------|------|-----|
| `pass` | 問題を検出したパス番号（1-4） | `2` |
| `symptom` | 現象（何が起きているか） | `"行8の上流接続がない"` |
| `cause` | 原因（なぜ起きているか） | `"if文内でスイムレーン遷移"` |

### 問題発見時のフロー

```
問題発見 → レビューログにissues記録（status: failed）
    ↓
.pumlを修正
    ↓
再度 -Review 実行
    ↓
前回のcurrentがhistoryに移動（履歴保持）
新しいcurrent生成（status: pending）
    ↓
再レビュー → 問題なし → status: completed
```

---

## Step 7: 正式版SVG保存（Publish）

レビューログが**completed**かつ**ハッシュ一致**の場合のみ、正式版としてSVGを保存できる。

### 保存先ルール

| 用途 | 保存先 | 説明 |
|------|--------|------|
| 正式版SVG | `docs/proposals/diagrams/<DiagramType>/` | PRDに採用する図表 |
| 一時検証用PNG | `docs/evidence/<日付>/` | レビュー・作業証跡 |
| レビューログ | `.puml`と同じディレクトリ | 品質保証の証跡 |

### Phase 2: 正式版として保存

```powershell
# レビューログ検証 → SVG生成
pwsh scripts/validate_plantuml.ps1 -InputPath ".\diagram.puml" -Publish -DiagramType "business_flow"
```

### 検証内容

スクリプトが自動検証する項目：

| # | 検証項目 | 失敗時のエラー |
|:-:|---------|---------------|
| 1 | レビューログ存在 | "Review log not found. Run -Review first." |
| 2 | status = completed | "Review not completed. Status: pending/failed" |
| 3 | ハッシュ一致 | "File modified after review. Run -Review again." |

### レビュー完了後のファイル管理

| ファイル | Publish後の扱い | 理由 |
|---------|----------------|------|
| `.puml` | **保持** | ソースコードとして管理 |
| `.review.json` | **保持** | 品質保証の証跡、履歴分析に使用 |
| `.png` | **保持（evidence内）** | 作業証跡として保存 |
| `.svg` | **proposals/diagrams/に保存** | 正式版として管理 |

### Gitコミット

```bash
git add docs/proposals/diagrams/
git commit -m "docs: 業務フロー図SVGを追加"
```

---

## PlantUML既知の制限と回避策

### 一覧

| 問題 | 原因 | 回避策 |
|------|------|--------|
| **スイムレーンをまたぐ条件分岐で接続線が切れる** | 「完全には実装されていない」機能 ([Issue #1007](https://github.com/plantuml/plantuml/issues/1007)) | 条件分岐を1つのスイムレーン内に収め、noteで詳細を説明 |
| ネストしたsplit/forkとスイムレーンの問題 | レンダリングバグ ([Issue #2161](https://github.com/plantuml/plantuml/issues/2161)) | 構造を簡素化、detachで分岐を終端 |
| シーケンス図で`note bottom of`使用不可 | 構文非対応 | `note over`を使用 |

### ⚠️ 最重要警告: if/fork内でのスイムレーン遷移

**if文/fork文の内部でスイムレーンを変更すると、接続線が描画されないことがある。**

この問題は「完全には実装されていない」機能であり、PlantUML側で修正される見込みは低い。
**コード作成時に以下のパターンを避けること。**

### 問題パターン一覧（避けるべき）

#### パターン1: if内で複数回スイムレーン遷移

```plantuml
' ❌ 問題パターン: if内で複数のスイムレーンに遷移
|開発者|
if (確認?) then (はい)
  |Frontend Service|     ← 問題: if内でスイムレーン変更
  :リクエスト送信;
  |Supabase|             ← 問題: if内でさらにスイムレーン変更
  :データ更新;
endif
```

#### パターン2: endif後のスイムレーン遷移

```plantuml
' ❌ 問題パターン: endif直後のスイムレーン遷移
|開発者|
if (条件) then (はい)
  :処理;
endif
|Frontend Service|       ← 問題: endif直後のスイムレーン遷移も接続が切れる
:結果表示;
```

#### パターン3: fork内でスイムレーン遷移

```plantuml
' ❌ 問題パターン: fork内でスイムレーン遷移
|Frontend Service|
fork
  :内部ログ取得;
  |Supabase|             ← 問題: fork内でスイムレーン変更
  :ログ集計;
fork again
  :外部API呼出;
end fork
```

### 回避策パターン

#### 回避策1: スイムレーン遷移をif外に出す

```plantuml
' ✅ 回避策: スイムレーン遷移をif文の外で行う
|開発者|
if (確認?) then (はい)
  :確認OK;
else (キャンセル)
  :キャンセル選択;
  stop
endif

|Frontend Service|       ← if外でスイムレーン遷移（OK）
:リクエスト送信;

|Supabase|               ← if外でスイムレーン遷移（OK）
:データ更新;

|Frontend Service|
if (成功?) then (はい)
  :完了通知;
else (エラー)
  :エラー通知;
endif
stop
```

#### 回避策2: noteで処理内容を説明

```plantuml
' ✅ 回避策: 1つのスイムレーン内に収め、noteで詳細を説明
|Frontend Service|
:処理を実行;
note right
  **処理フロー**
  1. Supabaseにリクエスト送信
  2. データ更新実行
  3. 結果を受信
end note

if (成功?) then (はい)
  #palegreen:完了通知;
else (エラー)
  #mistyrose:エラー通知;
endif
stop
```

#### 回避策3: 図を分割する

複雑なフローの場合は、概要図と詳細図に分割する。

```plantuml
' ✅ 回避策: 概要図（メインフロー）
|開発者|
start
:操作を選択;
switch (操作)
case (処理A)
  :処理Aへ;
  note right: 詳細は「処理A詳細図」参照
  detach
case (処理B)
  :処理Bへ;
  note right: 詳細は「処理B詳細図」参照
  detach
endswitch
```

---

## イテレーティブ改善

プレビューで接続線の問題等が発生した場合、以下のループを回す：

```
Context7照会 → 案を作成 → Context7照会 → 案を修正 → プレビュー確認
     ↑                                              │
     └──────────── 問題が残る場合 ←─────────────────┘
```

### 手順

1. Context7でPlantUML構文を再確認
2. GitHub Issues/公式ドキュメントで既知の問題を調査
3. 回避策を適用
4. プレビューで確認、問題が残れば1に戻る

### 改善サイクル完了時の更新

改善サイクルを通じて得た知見を適切に記録・蓄積する。

| # | 更新対象 | 記録内容 | 性質 |
|:-:|---------|---------|------|
| 1 | `work_sheet.md` | 各イテレーションの経緯（発見した問題、原因分析、適用した回避策、対比確認テーブル） | セッション単位の詳細記録 |
| 2 | **本ガイド** | 新たに発見した問題パターン・回避策を「PlantUML既知の制限と回避策」セクションに追記、変更履歴を更新 | 永続的な知識ベース |

**重要**: `work_sheet.md`だけでなく、本ガイドにも反映することで、学んだ知識がプロジェクト全体に蓄積される。

---

## 禁止事項

以下の行為は**禁止**とする：

| 禁止事項 | 理由 |
|---------|------|
| Context7確認なしでのPlantUMLコード作成 | 構文エラーや非互換性の見落としリスク |
| バリデーション未実施での保存 | 構文エラーのある図表がコミットされる |
| エラー無視・検証スキップ | 品質保証の担保ができない |
| **SVGのXMLテキストを見て視覚確認したと判断** | SVGはReadツールで画像として認識されない。必ずPNGを使用すること |
| **ソース+PNG対比確認をスキップ** | PNG視覚確認だけでは接続線の途切れを見落とす可能性がある |
| **if/fork内でスイムレーン遷移するコードを書く** | 接続線が描画されない既知の問題がある（Issue #1007） |
| **レビューログ未更新でPublish** | スクリプトが拒否する。status: completedが必須 |
| **レビュー後に.pumlを修正してPublish** | ハッシュ不一致でスクリプトが拒否。再Reviewが必要 |

---

## スクリプトリファレンス

### validate_plantuml.ps1

2段階のワークフローでPlantUML図表を管理するスクリプト。

#### パラメータ

| パラメータ | 必須 | 説明 |
|-----------|:----:|------|
| `-InputPath` | ○ | 検証対象の.pumlファイルまたはディレクトリ |
| `-Review` | △ | レビューモード: PNG形式で出力（視覚的レビュー用） |
| `-Publish` | △ | 正式版保存モード: SVG形式でproposals/diagrams/に出力 |
| `-DiagramType` | △ | 図表タイプ（-Publish時に必須） |

※ `-Review`または`-Publish`のいずれかを必ず指定

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
| プロジェクトガイド | `CLAUDE.md` |
| issuesテンプレート仕様書 | `docs/guides/validate_plantuml_issues_template_spec.md` |
| PlantUML公式 | https://plantuml.com/ |
| Serenaメモリ | `.serena/memories/plantuml_svg_generation_standard.md` |

---

## 変更履歴

| 日付 | バージョン | 変更内容 |
|------|-----------|---------|
| 2025-12-07 | 4.0 | 全面改善: 目次追加、Step 4/5分割、上流・下流確認手順具体化、具体例追加、重複整理、PlantUML既知の制限を独立セクション化、ファイル管理ルール追加、表記統一、Grep出力例追加 |
| 2025-12-07 | 3.3 | イテレーティブ改善セクションに「改善サイクル完了時の更新」を追加 |
| 2025-12-07 | 3.2 | マルチモーダル確認の重要事項を追加（上流・下流接続の両方確認、不一致検出の視点） |
| 2025-12-07 | 3.1 | issuesテンプレート追加（pass/symptom/cause構造）、Claudeの操作手順追記 |
| 2025-12-07 | 3.0 | レビューログ機能追加（.review.json、履歴保持、ハッシュ検証） |
| 2025-12-07 | 2.0 | 2段階ワークフロー導入（-Review/-Publish）、スクリプト刷新 |
| 2025-12-07 | 1.4 | ソース+SVG並行確認手順を追加（接続構文抽出、Grepパターン） |
| 2025-12-07 | 1.3 | 4パス方式レビュー手順、接続線チェックリスト、レビュー報告テンプレート追加 |
| 2025-12-07 | 1.2 | Graphviz要件を追加（図表タイプ別必要性、インストール確認方法） |
| 2025-12-07 | 1.1 | 禁止事項、イテレーティブ改善、既知の制限詳細化を追加 |
| 2025-12-07 | 1.0 | 初版作成 |
