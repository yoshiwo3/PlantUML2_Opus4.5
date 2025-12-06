# TD-007: AI機能プロバイダー構成

**作成日**: 2025-12-07
**ステータス**: Accepted

## 概要

PlantUML StudioのAI機能は、LLMとEmbeddingで異なるプロバイダーを使用する。

## アーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│                    PlantUML Studio                           │
│   ┌─────────────────────┐    ┌─────────────────────────┐    │
│   │   LLM機能           │    │   Embedding機能          │    │
│   │   (Chat/Completion) │    │   (RAG/Learning)        │    │
│   └──────────┬──────────┘    └────────────┬────────────┘    │
└──────────────┼────────────────────────────┼──────────────────┘
               │                            │
               ▼                            ▼
      ┌────────────────┐          ┌────────────────┐
      │   OpenRouter   │          │   OpenAI API   │
      │   (統一API)    │          │   (直接接続)    │
      └────────────────┘          └────────────────┘
```

## プロバイダー構成

| 機能 | プロバイダー | 接続方式 | 環境変数 |
|------|------------|---------|---------|
| LLM | OpenRouter | 統一API | `OPENROUTER_API_KEY` |
| Embedding | OpenAI | 直接接続 | `OPENAI_API_KEY` |

## 機能一覧

### LLM管理機能（OpenRouter経由）
- LM-01: LLMモデルを登録する
- LM-02: LLMモデルを切り替える
- LM-03: LLMプロンプトを管理する
- LM-04: LLMパラメータを設定する
- LM-05: LLMワークフローを定義する
- LM-06: LLM使用量を監視する
- LM-07: LLMフォールバックを設定する

### Embedding管理機能（OpenAI直接）
- EM-01: Embeddingモデルを設定する
- EM-02: Embedding使用量を監視する

### 学習コンテンツ管理機能（OpenAI Embedding使用）
- LC-01: 学習コンテンツを登録する
- LC-02: 学習コンテンツを管理する

## Embedding技術選定

| 項目 | 選定 | 理由 |
|------|------|------|
| モデル | text-embedding-3-small | コスト効率最高 |
| 次元数 | 1536 | デフォルト精度維持 |
| ベクトルDB | Supabase pgvector | Supabase統一 |
| インデックス | HNSW | 高速検索 |
| チャンクサイズ | 512 tokens | 技術文書向け |
| 検索方式 | Hybrid Search | ベクトル + 全文検索 |

## 関連ドキュメント

- `docs/context/technical_decisions.md` - TD-007
- `docs/evidence/20251206_openrouter_research/llm_management_feature_design.md`
- `docs/evidence/20251206_openrouter_research/openrouter_llm_control_specification.md`
