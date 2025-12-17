# シーケンス図知見統合戦略

**作成日**: 2025-12-18
**目的**: UC 3-5 保存シーケンス図作成で得られた知見（LL-001〜LL-024, NL-001〜NL-007）をPlantUML開発憲法に参照型で組み込む

---

## 1. 背景

### 1.1 知見の出典

| 出典 | 内容 |
|------|------|
| `docs/evidence/20251215_2345_sequence_save/work_sheet.md` | 詳細版（31項目、コード例・失敗分析含む） |
| `.serena/memories/session_20251217_sequence_save_lessons_learned.md` | サマリー版（SERENA Memory） |

### 1.2 知見の分類

| 分類 | 項目数 | 内容 |
|------|:------:|------|
| LL-001〜LL-024 | 24 | アクティブバー関連（基本原則、構文、PNG視覚確認失敗分析） |
| NL-001〜NL-007 | 7 | 非アクティブバー関連（skinparam、participant、note等） |

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
PlantUML_Development_Constitution.md
    │
    ├── 関連ドキュメント表（§0末尾付近）
    │       └── +2行: 新規ファイルへの参照
    │
    └── §3.2 シーケンス図の制限（末尾）
            └── +3行: 詳細ガイド参照ブロック

docs/guides/sequence_diagram/  ← 新規ディレクトリ
    ├── Activation_Bar_Knowledge_Base.md  ← LL-001〜LL-024
    └── Sequence_Diagram_Patterns.md      ← NL-001〜NL-007

docs/guides/md_authoring_guides/
    └── Sequence_Diagram_Authoring_Guide.md
            └── §8末尾 +2行: 知見ベースへの参照
```

### 2.2 変更量サマリー

| ファイル | 変更タイプ | 行数 |
|---------|:----------:|:----:|
| `PlantUML_Development_Constitution.md` | 追加のみ | +5行 |
| `Activation_Bar_Knowledge_Base.md` | 新規作成 | ~300行 |
| `Sequence_Diagram_Patterns.md` | 新規作成 | ~150行 |
| `Sequence_Diagram_Authoring_Guide.md` | 追加のみ | +2行 |

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
> 24項目の知見（LL-001〜LL-024）とPNG視覚確認の失敗パターン分析を含む。
```

### 3.2 新規ファイル: Activation_Bar_Knowledge_Base.md

**パス**: `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md`

**構成**:
```markdown
# PlantUML シーケンス図 アクティブバー知見ベース

## 概要
- 24項目の知見（LL-001〜LL-024）
- UC 3-5 保存シーケンス図作成での実践から抽出

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

### 3.4 既存ファイル更新: Sequence_Diagram_Authoring_Guide.md

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
1. `Activation_Bar_Knowledge_Base.md` - work_sheet.mdから LL-001〜LL-024 を移植
2. `Sequence_Diagram_Patterns.md` - work_sheet.mdから NL-001〜NL-007 を移植

### Step 3: Constitution 追加（最小限）
1. 関連ドキュメント表に2行追加
2. §3.2末尾に3行追加

### Step 4: Authoring Guide 追加
1. §8末尾に2行追加

### Step 5: 検証
1. 各ファイルのリンクが正しく機能することを確認
2. Constitutionの既存内容が変更されていないことを確認

---

## 5. 期待される効果

| 効果 | 説明 |
|------|------|
| 知見の永続化 | 31項目の知見がdocs/guidesに正式版として保存 |
| 憲法の安定性維持 | プロンプトチューニング済みの憲法を維持 |
| 参照性の向上 | 必要な時に詳細を参照できる階層構造 |
| 保守性の向上 | 知見の追加・修正が憲法に影響しない |

---

## 6. 関連ファイル

| ファイル | 役割 |
|---------|------|
| `docs/evidence/20251215_2345_sequence_save/work_sheet.md` | 知見の原本（詳細版） |
| `.serena/memories/session_20251217_sequence_save_lessons_learned.md` | SERENA Memory版 |
| `docs/guides/PlantUML_Development_Constitution.md` | 統合先（最小限の追加のみ） |
| `docs/guides/md_authoring_guides/Sequence_Diagram_Authoring_Guide.md` | 設計レベルガイド |
