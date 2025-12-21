# シーケンス図知見統合戦略

**作成日**: 2025-12-18
**最終更新**: 2025-12-21
**目的**: シーケンス図作成で得られた知見（LL-001〜LL-027, NL-001〜NL-007, DP-001〜DP-006）をPlantUML開発憲法に参照型で組み込む

---

## 1. 背景

### 1.1 知見の出典

| 出典 | 内容 | 追加知見 |
|------|------|---------|
| `docs/evidence/20251215_2345_sequence_save/work_sheet.md` | 詳細版（31項目、コード例・失敗分析含む） | LL-001〜LL-025, NL-001〜NL-007 |
| `docs/evidence/20251221_0100_sequence_learning_content_search/best_practices_analysis.md` | ベストプラクティス分析（UC 3-10） | LL-026〜LL-027, DP-001〜DP-006 |
| `.serena/memories/session_20251217_sequence_save_lessons_learned.md` | サマリー版（SERENA Memory） | - |

### 1.2 知見の分類

| 分類 | 項目数 | 内容 |
|------|:------:|------|
| LL-001〜LL-027 | 27 | アクティブバー関連（基本原則、構文、PNG視覚確認失敗分析、クラス図整合性、設計パターン適用トリガー） |
| NL-001〜NL-007 | 7 | 非アクティブバー関連（skinparam、participant、note等） |
| DP-001〜DP-006 | 6 | 設計パターン（レジリエンス、デバウンス、キャッシュ、レート制限、監査ログ、分散トレーシング） |

#### 設計パターン詳細（DP-001〜DP-006）

| ID | パターン | 適用条件 | 推奨値 |
|:--:|---------|---------|--------|
| DP-001 | レジリエンス | 外部API呼び出し時 | タイムアウト5秒、リトライ3回（指数バックオフ）、503対応 |
| DP-002 | デバウンス | ユーザー入力リアルタイム処理 | 300ms |
| DP-003 | キャッシュ | 同一リクエスト繰り返し | Embedding/結果キャッシュ（TTL付き） |
| DP-004 | レート制限 | 高頻度呼び出しAPI | ユーザー単位30 req/min |
| DP-005 | 監査ログ | 権限変更・データ削除 | 操作者、対象、タイムスタンプ記録 |
| DP-006 | 分散トレーシング | マイクロサービス間通信 | traceId伝播 |

### 1.3 制約条件

**重要**: `PlantUML_Development_Constitution.md`はプロンプトチューニング済みのため、以下の制約を厳守する。

| 制約 | 説明 |
|------|------|
| 既存テキスト不変 | 既存の文章・表・コードブロックを変更しない |
| 追加のみ | 新規行の追加のみ許可（削除・修正禁止） |
| 最小限の変更 | 憲法への追加は**5行以内**に抑える |

---

## 2. 統合戦略

### 2.1 アーキテクチャ

```
PlantUML_Development_Constitution.md (v5.0)
    │
    ├── 関連ドキュメント表（§0末尾付近）
    │       └── +3行: 新規ファイルへの参照
    │
    ├── §3.2 シーケンス図の制限（末尾）
    │       └── +3行: 詳細ガイド参照ブロック
    │
    └── §4 レビュープロセス
            └── 5パスレビュー（Pass 5: 設計パターン追加）

docs/guides/sequence_diagram/  ← 新規ディレクトリ
    ├── Activation_Bar_Knowledge_Base.md  ← LL-001〜LL-027
    ├── Sequence_Diagram_Patterns.md      ← NL-001〜NL-007
    └── Design_Pattern_Checklist.md       ← DP-001〜DP-006（NEW）

docs/guides/md_authoring_guides/
    └── Sequence_Diagram_Authoring_Guide.md
            └── §7 設計パターン確認（LL-027）
            └── §8末尾: 知見ベースへの参照
```

### 2.2 変更量サマリー

| ファイル | 変更タイプ | 行数 | ステータス |
|---------|:----------:|:----:|:----------:|
| `PlantUML_Development_Constitution.md` | 追加のみ | +8行 | ✅ v5.0完了 |
| `Activation_Bar_Knowledge_Base.md` | 新規作成 | ~350行 | ✅ LL-027まで |
| `Sequence_Diagram_Patterns.md` | 新規作成 | ~150行 | ✅ 完了 |
| `Sequence_Diagram_Authoring_Guide.md` | 追加のみ | +20行 | ✅ §7追加 |
| `Design_Pattern_Checklist.md` | 新規作成 | ~200行 | ✅ DP-006まで |

---

## 3. 実装詳細

### 3.1 Constitution への追加（2箇所）

#### 追加箇所1: 関連ドキュメント表（§0末尾付近）

**現在の表**（行87-95付近）:
```markdown
| ドキュメント | 内容 |
|-------------|------|
| `docs/guides/PlantUML_Environment_Setup.md` | 環境構成... |
| `docs/guides/PlantUML_Script_Reference.md` | スクリプト詳細... |
```

**追加する2行**:
```markdown
| `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` | シーケンス図アクティブバー知見（LL-001〜LL-024） |
| `docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md` | シーケンス図パターン集（NL-001〜NL-007） |
```

#### 追加箇所2: §3.2 シーケンス図の制限（末尾）

**現在の末尾**（行475-478付近）:
```markdown
### 3.2 シーケンス図の制限
...（既存内容）...
```

**追加する3行**:
```markdown

> **詳細ガイド**: アクティブバーの詳細な制御方法は `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` を参照。
> 25項目の知見（LL-001〜LL-025）とPNG視覚確認の失敗パターン分析を含む。
```

### 3.2 新規ファイル: Activation_Bar_Knowledge_Base.md

**パス**: `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md`

**構成**:
```markdown
# PlantUML シーケンス図 アクティブバー知見ベース

## 概要
- 27項目の知見（LL-001〜LL-027）
- UC 3-5 保存シーケンス図、UC 3-10 学習コンテンツ検索での実践から抽出

## 1. 基本原則（LL-001〜LL-003）
### LL-001: else分岐のactivation継承
...

## 2. 構文・パターン（LL-004〜LL-008）
### LL-004: ショートカット構文（++/--）
...

## 3. 制限・原則（LL-009〜LL-012）
...

## 4. PNG視覚確認の失敗パターン（LL-013〜LL-016）
...

## 5. 視覚レビュー方法論（LL-017〜LL-020）
...

## 6. claude ops分析知見（LL-021〜LL-024）
...

## 7. 設計パターン適用（LL-025〜LL-027）
### LL-025: ネストaltでのactivate漏れ防止
### LL-026: クラス図整合性確認
### LL-027: 設計パターン知識の適用トリガー欠如
...

## チェックリスト
...
```

### 3.3 新規ファイル: Sequence_Diagram_Patterns.md

**パス**: `docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md`

**構成**:
```markdown
# PlantUML シーケンス図 パターン集

## 概要
- 7項目の非アクティブバー知見（NL-001〜NL-007）
- スタイル設定、構造定義、可読性向上パターン

## NL-001: skinparam設定パターン
...

## NL-002: participant宣言パターン
...

## NL-003: フェーズ区切り線
...

## NL-004: note配置パターン
...

## NL-005: Self-messageとnoteの使い分け
...

## NL-006: ヘッダーコメント構造
...

## NL-007: 矢印タイプの選択
...
```

### 3.4 新規ファイル: Design_Pattern_Checklist.md

**パス**: `docs/guides/sequence_diagram/Design_Pattern_Checklist.md`

**構成**:
```markdown
# シーケンス図 設計パターンチェックリスト

## 概要
- 6項目の設計パターン（DP-001〜DP-006）
- シーケンス図作成前のUC固有分析に使用

## DP-001: レジリエンス
- 外部API呼び出し時に適用
- タイムアウト（5秒）
- リトライ（指数バックオフ: 1s→2s→4s、最大3回）
- 503 Service Unavailable対応

## DP-002: デバウンス
- ユーザー入力リアルタイム処理に適用
- 推奨値: 300ms

## DP-003: キャッシュ
- 同一リクエスト繰り返し時に検討
- Embeddingキャッシュ、検索結果キャッシュ

## DP-004: レート制限
- 高頻度呼び出しAPIに適用
- ユーザー単位30 req/min

## DP-005: 監査ログ
- 権限変更・データ削除操作に必須
- 操作者、対象、タイムスタンプ記録

## DP-006: 分散トレーシング
- マイクロサービス間通信に適用
- traceId伝播

## UC固有分析チェックリスト
| # | 質問 | Yes の場合 |
|:-:|------|-----------:|
| 1 | 外部APIを呼び出すか？ | DP-001必須 |
| 2 | ユーザー入力がリアルタイムか？ | DP-002必須 |
| 3 | 同一リクエストが繰り返されるか？ | DP-003検討 |
| 4 | 高頻度呼び出しが想定されるか？ | DP-004必須 |
| 5 | 権限変更・データ削除があるか？ | DP-005必須 |
```

### 3.5 既存ファイル更新: Sequence_Diagram_Authoring_Guide.md

**パス**: `docs/guides/md_authoring_guides/Sequence_Diagram_Authoring_Guide.md`

**追加箇所**: §8 チェックリスト末尾

**追加する2行**:
```markdown

**関連知見ベース**: 詳細なアクティブバー制御とパターン集は `docs/guides/sequence_diagram/` を参照。
```

---

## 4. 実装手順

### Step 1: ディレクトリ作成
```powershell
mkdir docs/guides/sequence_diagram
```

### Step 2: 新規ファイル作成
1. `Activation_Bar_Knowledge_Base.md` - work_sheet.mdから LL-001〜LL-027 を移植 ✅
2. `Sequence_Diagram_Patterns.md` - work_sheet.mdから NL-001〜NL-007 を移植 ✅
3. `Design_Pattern_Checklist.md` - best_practices_analysis.mdから DP-001〜DP-006 を移植 ✅

### Step 3: Constitution 追加（最小限）
1. 関連ドキュメント表に3行追加 ✅
2. §3.2末尾に3行追加 ✅
3. §4レビュープロセスをPass 5追加（5パスレビュー化）✅

### Step 4: Authoring Guide 追加
1. §7「設計パターン確認（LL-027）」セクション追加 ✅
2. §8末尾に知見ベース参照追加 ✅

### Step 5: 検証
1. 各ファイルのリンクが正しく機能することを確認 ✅
2. Constitutionの既存内容が変更されていないことを確認 ✅
3. 5パスレビューがreview.jsonに反映されることを確認 ✅

---

## 5. 期待される効果

| 効果 | 説明 |
|------|------|
| 知見の永続化 | 40項目の知見（LL-27 + NL-7 + DP-6）がdocs/guidesに正式版として保存 |
| 憲法の安定性維持 | プロンプトチューニング済みの憲法を維持（v5.0） |
| 参照性の向上 | 必要な時に詳細を参照できる階層構造 |
| 保守性の向上 | 知見の追加・修正が憲法に影響しない |
| 設計品質向上 | UC固有分析による設計パターン適用漏れ防止 |
| レビュー品質向上 | 5パスレビュー（Pass 5: 設計パターン）の導入 |

---

## 6. 関連ファイル

### 6.1 知見の原本

| ファイル | 役割 | 知見 |
|---------|------|------|
| `docs/evidence/20251215_2345_sequence_save/work_sheet.md` | UC 3-5 保存シーケンス図知見 | LL-001〜LL-025, NL-001〜NL-007 |
| `docs/evidence/20251221_0100_sequence_learning_content_search/best_practices_analysis.md` | UC 3-10 ベストプラクティス分析 | LL-026〜LL-027, DP-001〜DP-006 |
| `.serena/memories/session_20251217_sequence_save_lessons_learned.md` | SERENA Memory版 | - |

### 6.2 統合先ドキュメント

| ファイル | 役割 | バージョン |
|---------|------|:----------:|
| `docs/guides/PlantUML_Development_Constitution.md` | PlantUML開発憲法 | v5.0 |
| `docs/guides/md_authoring_guides/Sequence_Diagram_Authoring_Guide.md` | シーケンス図作成ガイド | - |
| `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` | アクティブバー知見ベース | LL-027まで |
| `docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md` | シーケンス図パターン集 | NL-007まで |
| `docs/guides/sequence_diagram/Design_Pattern_Checklist.md` | 設計パターンチェックリスト | DP-006まで |

### 6.3 適用実績

| UC | 適用パターン | 改善効果 |
|:--:|-------------|---------|
| UC 3-5 | LL-001〜LL-025 | 4パスレビュー確立 |
| UC 3-10 | DP-001, DP-002 | 84点→92点（+8点、A評価） |

---

## 7. 更新履歴

| 日付 | 内容 |
|------|------|
| 2025-12-18 | 初版作成（LL-001〜LL-025, NL-001〜NL-007） |
| 2025-12-21 | UC 3-10ベストプラクティス統合（LL-026〜LL-027, DP-001〜DP-006）、5パスレビュー対応 |
