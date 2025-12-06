# セッション記録: 2025-12-07 UC番号再整理

## 概要

開発者向け管理機能のユースケース番号を再整理し、LLM管理機能設計書との整合性を確保した。

## 主な変更

### UC番号の拡張

| 変更前 | 変更後 |
|--------|--------|
| UC 5-1〜5-5（5件） | UC 5-1〜5-13（13件） |
| UC総数 24件 | UC総数 **32件** |

### 新しいUC構成

```
5. 管理機能（開発者専用）
├── 5-A. ユーザー管理
│   └── 5-1  ユーザーを管理する
├── 5-B. LLM管理（OpenRouter経由）
│   ├── 5-2  LLMモデルを登録する
│   ├── 5-3  LLMモデルを切り替える
│   ├── 5-4  LLMプロンプトを管理する
│   ├── 5-5  LLMパラメータを設定する
│   ├── 5-6  LLMワークフローを定義する
│   ├── 5-7  LLM使用量を監視する
│   └── 5-8  LLMフォールバックを設定する
├── 5-C. Embedding管理（OpenAI直接）
│   ├── 5-9  Embeddingモデルを設定する
│   └── 5-10 Embedding使用量を監視する
├── 5-D. 学習コンテンツ管理
│   ├── 5-11 学習コンテンツを登録する
│   └── 5-12 学習コンテンツを管理する
└── 5-E. システム設定
    └── 5-13 システム設定を変更する
```

## TD-007: AI機能プロバイダー構成

| 機能 | プロバイダー | 接続方式 |
|------|------------|---------|
| LLM | OpenRouter | 統一API |
| Embedding | OpenAI | 直接接続 |

## 更新したファイル

1. `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md`
   - UC定義拡張（5-1〜5-13）
   - 詳細図追加（5-A〜5-E サブパッケージ）
   - 外部システム接続更新

2. `docs/context/active_context.md`
   - UCカバレッジ更新（32UC）
   - 変更履歴追加

3. `docs/context/technical_decisions.md`
   - TD-007追加

4. `docs/context/project_brief.md`
   - UC総数更新

5. `CLAUDE.md`
   - UC総数更新
   - TD-007追加

## 関連ドキュメント

- `docs/evidence/20251206_openrouter_research/llm_management_feature_design.md`
- `docs/evidence/20251206_openrouter_research/openrouter_llm_control_specification.md`
- `.serena/memories/td007_ai_provider_architecture.md`
