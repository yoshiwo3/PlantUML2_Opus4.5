# 作業指示書: 3.11 管理機能フロー（Phase 2）

**作成日時**: 2025-12-10 22:30
**作業者**: Claude Opus 4.5
**Evidence ID**: 20251210_2230_admin_flow_phase2

---

## 1. 目標

業務フロー図 3.11「管理機能フロー（Phase 2）」を作成する。

## 2. コンテキスト

- 前回セッションで計画策定完了
- DAG構造の詳細設計をヒアリングで確定
- PlantUML憲法v3.4に準拠

## 3. 対象UC

| UC | 機能名 | 設計書参照 |
|:--:|--------|:----------:|
| 5-6 | LLMワークフローを定義する | LM-05 |
| 5-9 | Embeddingモデルを設定する | EM-01 |
| 5-10 | Embedding使用量を監視する | EM-02 |

## 4. 実施内容

### Phase 1: 準備
- [x] Evidenceディレクトリ作成
- [ ] Context7でPlantUML仕様確認
- [ ] PlantUML憲法確認

### Phase 2: フロー作成（優先度順）
- [ ] 3.11概要図
- [ ] 3.11.2 Embeddingモデル設定（UC 5-9）
- [ ] 3.11.3 Embedding使用量監視（UC 5-10）
- [ ] 3.11.1 LLMワークフロー定義（UC 5-6）

### Phase 3: 統合・完了
- [ ] 業務フロー図へ統合
- [ ] active_context.md更新
- [ ] SERENA Memory保存

## 5. 完了条件

- [ ] 4つの.pumlファイル作成
- [ ] 4つの正式版SVG生成
- [ ] 業務フロー図への統合完了
- [ ] レビューログ更新

## 6. 参照ドキュメント

- `C:\Users\保科　慶光\.claude\plans\lexical-twirling-moonbeam.md` - 計画ファイル
- `docs/guides/PlantUML_Development_Constitution.md` - PlantUML憲法v3.4
- `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` - 統合先
- `docs/evidence/20251206_openrouter_research/llm_management_feature_design.md` - 設計仕様
