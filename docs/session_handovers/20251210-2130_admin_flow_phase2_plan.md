# セッション引継ぎ資料: 3.11 管理機能フロー（Phase 2）

**作成日時**: 2025-12-10 21:30
**作成者**: Claude Opus 4.5
**次セッション開始時の必読度**: ★★★（必須）

---

## 1. 作業概要

### 完了した作業

- **3.11 管理機能フロー（Phase 2）の計画策定**
  - 対象UC決定: 5-6, 5-9, 5-10（3件）
  - 後回し: 5-11, 5-12（学習コンテンツ管理）→ 3.10と一緒に作成
  - 設計決定事項確定（ユーザー確認済み）
  - PlantUML開発憲法v3.4準拠を明記

### 未完了の作業

- [ ] Evidenceディレクトリ作成
- [ ] 3.11概要図.puml作成
- [ ] 3.11.1 LLMワークフロー定義.puml作成（UC 5-6）
- [ ] 3.11.2 Embeddingモデル設定.puml作成（UC 5-9）
- [ ] 3.11.3 Embedding使用量監視.puml作成（UC 5-10）
- [ ] 正式版SVG生成（4件）
- [ ] 業務フロー図への統合
- [ ] クラス図更新（後続作業）

---

## 2. 設計決定事項（ユーザー確認済み）

| 項目 | 決定 | 備考 |
|------|------|------|
| **LLMワークフロー** | **自由DAG構造** | ステップ追加・削除・接続自由、条件分岐も設定可能 |
| **Embedding切り替え** | **選択可能** | 「既存再生成」or「新規のみ」をUI上で選択 |
| **詳細度** | **3.9と同程度** | 概要図 + 各UC詳細図（スイムレーン3〜4本）|

### 技術決定候補

| TD | 内容 |
|:--:|------|
| TD-008 | LLMワークフローのDAG構造採用 |
| TD-009 | Embeddingモデル切り替え時の再生成戦略 |

---

## 3. 必読ドキュメント

| 優先度 | ドキュメント | 目的 |
|:------:|-------------|------|
| ★★★ | `C:\Users\保科　慶光\.claude\plans\deep-tickling-starfish.md` | **計画ファイル（最重要）** |
| ★★★ | `docs/guides/PlantUML_Development_Constitution.md` | **PlantUML憲法v3.4（完全準拠必須）** |
| ★★☆ | `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` | 3.9の構造・フォーマット参考 |
| ★★☆ | `docs/evidence/20251206_openrouter_research/llm_management_feature_design.md` | LM-05, EM-01, EM-02設計仕様 |
| ★☆☆ | `docs/context/active_context.md` | プロジェクト進捗確認 |

---

## 4. PlantUML開発憲法v3.4 重要事項

### 絶対禁止（8項目）

1. **if/fork/switch内でスイムレーン遷移するコードを書く**（最重要）
2. SVGのXMLテキストを見て視覚確認したと判断する
3. ソース+PNG対比確認をスキップする
4. Context7確認なしでPlantUMLコードを作成する
5. レビューログ未更新でPublishする
6. レビュー後に.pumlを修正してPublishする
7. ソースコードから接続を推測して✅をつける
8. PNGと.pumlを同時に読み込む

### 必須プロセス

```
1. Context7で仕様確認（topic: "activity diagram swimlane"）
2. 憲法 § 2, § 3 確認
3. .pumlコード作成（回避策を先に適用）
4. PNG生成（-Review）
5. 4パスレビュー + ソース対比確認
6. レビューログ更新
7. 問題あれば修正→再レビュー
8. 問題なければSVG生成（-Publish）
```

### 回避策

| 状況 | 推奨回避策 |
|------|:---------:|
| 単純な分岐後に別レーンで処理継続 | if外でスイムレーン遷移 |
| 複数サービス間の複雑な内部処理 | noteで詳細説明 |
| 10ステップ以上の大規模フロー | 概要図+詳細図で階層化 |

---

## 5. 作成するフロー詳細

### 3.11 概要図

- 開発者が3つの機能（LLMワークフロー/Embedding設定/Embedding使用量）から選択
- 3.9概要図と同様の構造

### 3.11.1 LLMワークフロー定義（UC 5-6）

**スイムレーン**: 開発者 / Frontend Service / Supabase

**フロー**:
1. ワークフロー一覧表示
2. 新規作成 or 既存編集
3. DAGエディタでステップ定義
4. テスト実行
5. 保存・有効化

**データモデル**:
- `llm_workflows`
- `llm_workflow_steps`
- `llm_workflow_edges`

### 3.11.2 Embeddingモデル設定（UC 5-9）

**スイムレーン**: 開発者 / Frontend Service / Supabase

**フロー**:
1. 現在の設定表示
2. モデル選択（3種）
3. パラメータ設定
4. **再生成オプション選択**（既存再生成 or 新規のみ）
5. 確認ダイアログ（コスト見積もり）
6. 保存・適用

### 3.11.3 Embedding使用量監視（UC 5-10）

**スイムレーン**: 開発者 / Frontend Service / Supabase / OpenAI API

**フロー**:
1. ダッシュボード表示
2. 期間選択
3. 使用量データ取得
4. グラフ・テーブル表示

---

## 6. 実装優先度

| 優先度 | 項目 | 理由 |
|:------:|------|------|
| 1 | 3.11概要図 | 全体像を先に定義 |
| 2 | UC 5-9 Embeddingモデル設定 | 5-10の前提条件 |
| 3 | UC 5-10 Embedding使用量監視 | 5-9の後に実装 |
| 4 | UC 5-6 LLMワークフロー定義 | 最も複雑、最後に実装 |

---

## 7. 次セッションの開始手順

1. **計画ファイル確認**
   ```
   Read: C:\Users\保科　慶光\.claude\plans\deep-tickling-starfish.md
   ```

2. **PlantUML憲法確認**
   ```
   Read: docs/guides/PlantUML_Development_Constitution.md
   ```

3. **Evidenceディレクトリ作成**
   ```powershell
   pwsh scripts/create_evidence.ps1 20251210_HHMM_admin_flow_phase2
   ```

4. **Context7でPlantUML仕様確認**
   ```
   mcp__context7__resolve-library-id → libraryName: "plantuml"
   mcp__context7__get-library-docs   → topic: "activity diagram swimlane"
   ```

5. **3.11概要図から作成開始**

---

## 8. 注意事項

- **クラス図は業務フロー完成後に更新**（業務フローが先、クラス図は後）
- **UC 5-11, 5-12は後回し**（3.10 学習コンテンツフローと一緒に作成）
- **PlantUML憲法v3.4に完全準拠**（特に禁止事項#1: if/fork/switch内スイムレーン遷移禁止）

---

## 9. 関連ファイル

| ファイル | 用途 |
|---------|------|
| `C:\Users\保科　慶光\.claude\plans\deep-tickling-starfish.md` | 計画ファイル |
| `docs/guides/PlantUML_Development_Constitution.md` | PlantUML憲法v3.4 |
| `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` | 統合先 |
| `docs/evidence/20251206_openrouter_research/llm_management_feature_design.md` | 設計仕様 |
| `docs/context/active_context.md` | 進捗管理 |
| `docs/context/technical_decisions.md` | TD-008, TD-009追記先 |
