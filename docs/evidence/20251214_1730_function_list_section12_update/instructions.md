# Instructions: 機能一覧表§12 全面更新

## 作成日時
2025-12-14 17:30

## 目標
`docs/proposals/PlantUML_Studio_機能一覧表_20251213.md` の§12「クラス図との橋渡し」セクションを全面更新し、クラス図v1.6と完全整合させる。

## コンテキスト
- 前セッションでクラス図v1.6の最新状況分析（Ultrathink）を実施
- 機能一覧表v3.11の§12が大幅に古いことが判明（29件の不足）
- 引継ぎ資料: `docs/session_handovers/20251214-1820_function_list_section12_update.md`

## 発見された不整合

| カテゴリ | クラス図v1.6 | 機能一覧表§12 | 差分 |
|---------|:-----------:|:------------:|:----:|
| エンティティ | 11件 | 6件 | -5件 |
| サービス | 13件 | 6件 | -7件 |
| Repository | 9件 | 0件 | -9件 |
| 外部クライアント | 5件 | 0件 | -5件 |
| Value Object | 3件 | 0件 | -3件 |
| **合計** | **41件** | **12件** | **-29件** |

## 実施内容
1. §12.1 エンティティ: 6件→11件 (+5件: Prompt, FeatureModelAssignment, SystemConfig, UsageLog, LearningContent)
2. §12.2 サービス: 6件→13件 (+7件: TemplateService, PromptService, UserService, SystemConfigService, LLMConfigService, LearningService, EmbeddingService)
3. §12.3 Repository: 新設 (9件)
4. §12.4 外部クライアント: 新設 (5件)
5. §12.5 Value Object: 新設 (3件)
6. バージョン更新: v3.11→v3.12

## 参照ドキュメント
- 機能一覧表 v3.11: `docs/proposals/PlantUML_Studio_機能一覧表_20251213.md`
- クラス図 v1.6: `docs/proposals/PlantUML_Studio_クラス図_20251208.md`
- 分析レポート: `docs/evidence/20251214_1700_class_diagram_analysis/class_diagram_v16_analysis_report.md`

## 完了条件
- [ ] §12.1 エンティティが11件になっている
- [ ] §12.2 サービスが13件になっている
- [ ] §12.3 Repositoryセクションが9件で新設されている
- [ ] §12.4 外部クライアントセクションが5件で新設されている
- [ ] §12.5 Value Objectセクションが3件で新設されている
- [ ] クラス図v1.6との差分が0件になっている
- [ ] バージョンがv3.12に更新されている
