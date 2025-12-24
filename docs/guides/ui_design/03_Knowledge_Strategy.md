# UI設計図表 知見統合戦略

**作成日**: 2025-12-22
**目的**: UI設計図表作成で得られた知見（EX-001〜, SD-001〜, TD-001〜, IC-001〜）をUI設計図表開発憲法に参照型で組み込む

---

## 1. 背景

### 1.1 知見の分類（2025-12-22時点）

| 分類 | 項目数 | 実体験由来 | 内容 |
|------|:------:|:----------:|------|
| EX-001〜004 | 4 | 0 | Excalidraw関連（ワイヤーフレーム作成）※テンプレート |
| SD-001〜007 | 7 | 2 | State Diagram関連（画面遷移図作成）|
| TD-001〜003 | 3 | 0 | TD-015適用知見（低精度、手書き風、グレースケール）※テンプレート |
| IC-001〜005 | 5 | 2 | 整合性チェック知見（3点対比、孤立ノード等）|
| CS-001 | 1 | 1 | ケーススタディ（画面遷移図初回作成）|
| **合計** | **20** | **5** | 実体験率: 25% |

> **「実体験由来」の定義**: 実際のUI設計図表作成作業中に発見・検証された知見。テンプレートとして事前作成されたものや、理論的推測のみの知見は含まない。SD-006〜007, IC-004〜005, CS-001が該当。

### 1.2 PlantUML開発憲法との関係

| 項目 | PlantUML開発憲法 | UI設計図表開発憲法 |
|------|-----------------|-------------------|
| 知見ベース | `Activation_Bar_Knowledge_Base.md` | `UI_Design_Knowledge_Base.md` |
| パターン集 | `Sequence_Diagram_Patterns.md` | `UI_Design_Patterns.md` |
| 設計パターン | `Design_Pattern_Checklist.md` | `Design_Pattern_Checklist.md` |
| 知見ID体系 | LL-XXX, NL-XXX, DP-XXX | EX-XXX, SD-XXX, TD-XXX, IC-XXX |

### 1.3 制約条件

| 制約 | 説明 |
|------|------|
| 憲法の安定性 | UI設計図表開発憲法 v3.2の既存内容は最小限の変更 |
| 参照型統合 | 詳細知見は外部ファイルに分離し、憲法からは参照のみ |
| 拡張性確保 | 新規知見の追加が既存ドキュメントに影響しない構造 |

---

## 2. 統合戦略

### 2.1 アーキテクチャ

```
UI_Design_Constitution.md (v3.2)
    │
    ├── §8 UI設計パターンチェックリスト
    │       └── 詳細は Design_Pattern_Checklist.md を参照
    │
    ├── 付録E 知見ベース参照
    │       └── UI_Design_Knowledge_Base.md への参照
    │
    └── 関連ドキュメント表
            └── 各サポートファイルへの参照

docs/guides/ui_design/  ← サポートドキュメント群
    ├── 00_Session_Start.md           ← セッション開始ガイド
    ├── 01_Reference_Guide.md         ← 参照ガイド
    ├── 02_Authoring_Guide.md         ← 作成ガイドライン
    ├── 03_Knowledge_Strategy.md      ← 本ファイル
    ├── UI_Design_Constitution.md     ← 憲法本体
    ├── UI_Design_Knowledge_Base.md   ← 知見ベース（EX/SD/TD/IC）
    ├── Design_Pattern_Checklist.md   ← UIパターンチェックリスト
    └── UI_Design_Patterns.md         ← 実装パターン集
```

### 2.2 ファイル構成

| ファイル | 役割 | 行数（実測） |
|---------|------|:-----------:|
| `UI_Design_Constitution.md` | 憲法本体 | ~1232行 |
| `UI_Design_Knowledge_Base.md` | 知見ベース | ~375行 |
| `Design_Pattern_Checklist.md` | UIパターン | ~306行 |
| `UI_Design_Patterns.md` | 実装パターン | ~466行 |
| `00_Session_Start.md` | セッション開始 | ~305行 |
| `01_Reference_Guide.md` | 参照ガイド | ~270行 |
| `02_Authoring_Guide.md` | 作成ガイド | ~371行 |
| `03_Knowledge_Strategy.md` | 本ファイル | ~250行 |

> **注**: 行数は2025-12-24時点の実測値。更新により変動する。

---

## 3. 知見管理プロセス

### 3.1 知見追加フロー

```
発見
  │
  ├─→ 分類判定
  │     ├── Excalidraw関連 → EX-XXX
  │     ├── State Diagram関連 → SD-XXX
  │     ├── TD-015関連 → TD-XXX
  │     └── 整合性チェック関連 → IC-XXX
  │
  ├─→ UI_Design_Knowledge_Base.md に追加
  │
  ├─→ 重要度判定
  │     ├── 高: 憲法への反映を検討
  │     ├── 中: ガイドライン更新
  │     └── 低: 知見ベースのみ
  │
  └─→ SERENA Memory保存
```

### 3.2 知見ID採番ルール

| カテゴリ | 接頭辞 | 例 |
|---------|:------:|-----|
| Excalidraw | EX- | EX-001, EX-002, ... |
| State Diagram | SD- | SD-001, SD-002, ... |
| TD-015適用 | TD- | TD-001, TD-002, ... |
| 整合性チェック | IC- | IC-001, IC-002, ... |

**採番ルール**:
- 各カテゴリ内で連番（001から開始）
- 削除せず、廃止の場合は「[廃止]」マーク
- 統合の場合は「[XX-XXXに統合]」マーク

---

## 4. 憲法との連携

### 4.1 憲法からの参照箇所

| 憲法セクション | 参照先 |
|---------------|--------|
| §8 UI設計パターンチェックリスト | `Design_Pattern_Checklist.md` |
| 付録E 知見ベース参照 | `UI_Design_Knowledge_Base.md` |
| 関連ドキュメント表 | 全サポートファイル |

### 4.2 知見の重要度と反映先

| 重要度 | 反映先 | 例 |
|:------:|--------|-----|
| 高 | 憲法 §禁止事項 | 重大な失敗パターン |
| 中 | 02_Authoring_Guide.md | 推奨プラクティス |
| 低 | UI_Design_Knowledge_Base.md のみ | Tips、補足情報 |

---

## 5. 期待される効果

| 効果 | 説明 |
|------|------|
| **知見の永続化** | EX/SD/TD/IC知見がdocs/guidesに正式版として保存 |
| **憲法の安定性維持** | v3.2の構造を維持しつつ拡張可能 |
| **参照性の向上** | 必要な時に詳細を参照できる階層構造 |
| **保守性の向上** | 知見の追加・修正が憲法に影響しない |
| **品質同等化** | sequence_diagramと同等のサポート体制 |

---

## 6. sequence_diagramとの対比

### 6.1 ファイル対応表

| sequence_diagram | ui_design | 役割 |
|-----------------|-----------|------|
| `00_Session_Start.md` | `00_Session_Start.md` | セッション開始 |
| `01_Reference_Guide.md` | `01_Reference_Guide.md` | 参照ガイド |
| `02_Authoring_Guide.md` | `02_Authoring_Guide.md` | 作成ガイド |
| `03_Knowledge_Strategy.md` | `03_Knowledge_Strategy.md` | 知見戦略 |
| `Activation_Bar_Knowledge_Base.md` | `UI_Design_Knowledge_Base.md` | 知見ベース |
| `Sequence_Diagram_Patterns.md` | `UI_Design_Patterns.md` | パターン集 |
| `Design_Pattern_Checklist.md` | `Design_Pattern_Checklist.md` | チェックリスト |

### 6.2 知見ID対比

| sequence_diagram | ui_design | 内容 |
|:----------------:|:---------:|------|
| LL-XXX | EX-XXX | ツール固有知見（アクティブバー / Excalidraw） |
| NL-XXX | SD-XXX | 図表タイプ固有知見（パターン / State Diagram） |
| DP-XXX | TD-XXX | 適用原則知見（設計パターン / TD-015） |
| - | IC-XXX | 整合性知見（UI設計固有） |

### 6.3 品質比較（正直な評価: 2025-12-22時点）

> **重要**: この比較は事実に基づく正直な評価である。

| 観点 | sequence_diagram | ui_design | 差異 |
|------|:----------------:|:---------:|:----:|
| **知見項目数** | 27項目（LL-001〜027） | 19項目（EX/SD/TD/IC） | -8 |
| **実体験由来** | 27項目（100%） | 4項目（21%） | -23 |
| **ケーススタディ** | 1件（CS-001）| 1件（CS-001）| 同等 |
| **実績ファイル編集数** | 47回以上 | 1回 | -46 |
| **実績レビュー数** | 5回以上 | 1回 | -4 |
| **対象UC数** | 9UC | 1UC相当（画面遷移図） | -8 |

#### 品質ギャップの根本原因

| 原因 | 説明 |
|------|------|
| **経験蓄積の差** | sequence_diagramは9UC分の実作業を経て知見を蓄積。ui_designは今回初の実作業 |
| **反復回数の差** | sequence_diagramは同じ問題を複数回解決し知見を深化。ui_designは1回目 |
| **問題発見の深さ** | sequence_diagramはエッジケース（alt/else分岐等）まで網羅。ui_designは基本パターンのみ |

#### 今後の品質向上計画

| Phase | 内容 | 期待される効果 |
|:-----:|------|---------------|
| 1 | ワイヤーフレーム実作成（1-2画面） | EX-XXX知見の実体験化 |
| 2 | 5パスレビュー反復実施 | SD/IC知見の深化 |
| 3 | 異なる画面タイプで検証 | エッジケース発見 |
| 4 | 複数セッションでの経験蓄積 | 知見の網羅性向上 |

#### 現時点の正直な結論

**構造的同等性は達成**（ファイル構成、命名規則、プロセス）

**内容的同等性は未達成**（実体験知見の深さ、網羅性）

今後のUI設計図表作成実務を通じて、知見を蓄積し品質を向上させる必要がある。

---

## 7. 関連ファイル

### 7.1 ui_designディレクトリ構成

| ファイル | 役割 | ステータス |
|---------|------|:----------:|
| `UI_Design_Constitution.md` | 憲法本体 | ✅ v3.2 |
| `UI_Design_Knowledge_Base.md` | 知見ベース | ✅ 作成済 |
| `Design_Pattern_Checklist.md` | UIパターン | ✅ 作成済 |
| `UI_Design_Patterns.md` | 実装パターン | ✅ 作成済 |
| `00_Session_Start.md` | セッション開始 | ✅ 作成済 |
| `01_Reference_Guide.md` | 参照ガイド | ✅ 作成済 |
| `02_Authoring_Guide.md` | 作成ガイド | ✅ 作成済 |
| `03_Knowledge_Strategy.md` | 本ファイル | ✅ 作成済 |

### 7.2 参照元ドキュメント

| ドキュメント | 内容 |
|-------------|------|
| `docs/context/technical_decisions.md` | TD-015意思決定 |
| `docs/proposals/02_ユースケース図_20251130.md` | UC定義（32UC） |
| `docs/proposals/03_業務フロー図_20251201.md` | 業務フロー詳細 |
| `docs/guides/PlantUML_Development_Constitution.md` | PlantUML開発憲法（参考） |
| `docs/guides/sequence_diagram/` | シーケンス図サポートファイル（参考） |

---

## 8. 更新履歴

| 日付 | 内容 |
|------|------|
| 2025-12-22 | v1.1: §6.3品質比較追加、§1.1知見分類更新（実体験率25%明記）|
| 2025-12-22 | v1.0: 初版作成 |
