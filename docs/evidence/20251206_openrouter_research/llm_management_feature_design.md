# PlantUML Studio LLM管理機能 設計書

**作成日**: 2025-12-07
**更新日**: 2025-12-07
**基準ドキュメント**: `openrouter_llm_control_specification.md`
**ステータス**: Draft

---

## 1. 概要

### 1.1 目的

PlantUML StudioにおけるAI機能の管理機能を設計する。
**LLM（Chat/Completion）とEmbeddingは別プロバイダーを使用**し、それぞれ独立して管理する。

### 1.2 プロバイダー構成

```
┌─────────────────────────────────────────────────────────────┐
│                    PlantUML Studio                           │
│                                                              │
│   ┌─────────────────────┐    ┌─────────────────────────┐    │
│   │   LLM機能           │    │   Embedding機能          │    │
│   │   (Chat/Completion) │    │   (RAG/Learning)        │    │
│   └──────────┬──────────┘    └────────────┬────────────┘    │
│              │                            │                  │
└──────────────┼────────────────────────────┼──────────────────┘
               │                            │
               ▼                            ▼
      ┌────────────────┐          ┌────────────────┐
      │   OpenRouter   │          │   OpenAI API   │
      │   (統一API)    │          │   (直接接続)    │
      │                │          │                │
      │ ・Claude       │          │ ・text-embedding│
      │ ・GPT-4o       │          │   -3-small     │
      │ ・Gemini       │          │                │
      │ ・Llama        │          │                │
      └────────────────┘          └────────────────┘
```

### 1.3 設計原則

| 原則 | 説明 |
|------|------|
| **プロバイダー分離** | LLM=OpenRouter、Embedding=OpenAI直接 |
| **設定の永続化** | モデル設定・プロンプトはSupabase DBに保存 |
| **リクエスト時適用** | 保存された設定をAPIリクエスト時に動的に付与 |
| **段階的リリース** | MVP → Phase 2で機能を段階的に拡張 |

### 1.4 技術スタック

| コンポーネント | 技術 | 用途 | 接続先 |
|--------------|------|------|--------|
| **LLM（Chat/Completion）** | OpenRouter | AIチャット、構文チェック、Question-Start | OpenRouter API |
| **Embedding** | OpenAI | 学習コンテンツのベクトル化、RAG検索 | OpenAI API（直接） |
| 設定永続化 | Supabase PostgreSQL | モデル設定、プロンプト、使用量 | - |
| ベクトルDB | Supabase pgvector | Embeddingベクトル保存 | - |

---

## 2. 機能一覧

### 2.1 LLM管理機能（OpenRouter経由）

| ID | 機能名 | 説明 | アクター | 優先度 |
|:--:|--------|------|---------|:------:|
| LM-01 | LLMモデルを登録する | OpenRouterモデルを追加・設定 | 開発者 | MVP |
| LM-02 | LLMモデルを切り替える | アクティブモデルを変更 | 開発者 | MVP |
| LM-03 | LLMプロンプトを管理する | プロンプトテンプレートのCRUD | 開発者 | MVP |
| LM-04 | LLMパラメータを設定する | temperature, max_tokens等 | 開発者 | MVP |
| LM-05 | LLMワークフローを定義する | 処理パイプライン定義 | 開発者 | P2 |
| LM-06 | LLM使用量を監視する | コスト・トークン数監視 | 開発者 | MVP |
| LM-07 | LLMフォールバックを設定する | 障害時の代替モデル設定 | 開発者 | MVP |

### 2.2 Embedding管理機能（OpenAI直接）

| ID | 機能名 | 説明 | アクター | 優先度 |
|:--:|--------|------|---------|:------:|
| EM-01 | Embeddingモデルを設定する | text-embedding-3-small/large選択 | 開発者 | P2 |
| EM-02 | Embedding使用量を監視する | トークン数・コスト監視 | 開発者 | P2 |

### 2.3 学習コンテンツ管理機能（OpenAI Embedding使用）

| ID | 機能名 | 説明 | アクター | 優先度 |
|:--:|--------|------|---------|:------:|
| LC-01 | 学習コンテンツを登録する | Markdown/PDF → OpenAI Embedding → pgvector | 開発者 | P2 |
| LC-02 | 学習コンテンツを管理する | CRUD + カテゴリ分類 | 開発者 | P2 |

---

## 3. LLM管理機能詳細設計（OpenRouter）

### 3.1 LM-01: LLMモデルを登録する

#### 概要
OpenRouterで利用可能なモデルをシステムに登録し、デフォルトパラメータを設定する。

#### データモデル

```sql
CREATE TABLE llm_models (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_id TEXT NOT NULL UNIQUE,        -- "anthropic/claude-3.5-sonnet"
  display_name TEXT NOT NULL,           -- "Claude 3.5 Sonnet"
  provider TEXT NOT NULL,               -- "Anthropic"
  is_active BOOLEAN DEFAULT true,
  is_default BOOLEAN DEFAULT false,

  -- デフォルトパラメータ
  default_temperature DECIMAL(3,2) DEFAULT 0.7,
  default_max_tokens INTEGER DEFAULT 4096,
  default_top_p DECIMAL(3,2) DEFAULT 1.0,

  -- コスト情報（キャッシュ）
  input_cost_per_million DECIMAL(10,4),  -- $/M tokens
  output_cost_per_million DECIMAL(10,4),

  -- メタデータ
  context_length INTEGER,
  supports_vision BOOLEAN DEFAULT false,
  supports_tools BOOLEAN DEFAULT false,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- デフォルトモデルは1つだけ
CREATE UNIQUE INDEX idx_llm_models_default
ON llm_models (is_default) WHERE is_default = true;
```

#### API設計

```typescript
// POST /api/admin/llm-models
interface CreateLLMModelRequest {
  modelId: string;           // "anthropic/claude-3.5-sonnet"
  displayName: string;
  provider: string;
  defaultTemperature?: number;
  defaultMaxTokens?: number;
  defaultTopP?: number;
}

// GET /api/admin/llm-models
interface LLMModelListResponse {
  models: LLMModel[];
  total: number;
}

// PUT /api/admin/llm-models/:id
interface UpdateLLMModelRequest {
  displayName?: string;
  isActive?: boolean;
  isDefault?: boolean;
  defaultTemperature?: number;
  defaultMaxTokens?: number;
  defaultTopP?: number;
}

// DELETE /api/admin/llm-models/:id
// デフォルトモデルは削除不可
```

#### OpenRouterモデル一覧取得

```typescript
// モデル一覧をOpenRouterから取得してUI表示
async function fetchAvailableModels(): Promise<OpenRouterModel[]> {
  const response = await fetch("https://openrouter.ai/api/v1/models", {
    headers: {
      Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`
    }
  });
  return response.json();
}
```

---

### 3.2 LM-02: LLMモデルを切り替える

#### 概要
アクティブなモデルを切り替える。全サービス一括または機能別に設定可能。

#### データモデル

```sql
CREATE TABLE llm_model_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  feature_key TEXT NOT NULL UNIQUE,  -- "ai_chat", "syntax_check", "question_start"
  model_id UUID NOT NULL REFERENCES llm_models(id),

  -- オーバーライドパラメータ（nullなら親モデルのデフォルト使用）
  override_temperature DECIMAL(3,2),
  override_max_tokens INTEGER,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 機能キー定義
-- ai_chat: AIチャット機能
-- syntax_check: 構文チェック・修正提案
-- question_start: Question-Start機能
-- terminology_check: 用語一貫性チェック
```

#### API設計

```typescript
// GET /api/admin/llm-assignments
interface LLMAssignmentListResponse {
  assignments: {
    featureKey: string;
    featureDisplayName: string;
    modelId: string;
    modelDisplayName: string;
    temperature: number;
    maxTokens: number;
  }[];
}

// PUT /api/admin/llm-assignments/:featureKey
interface UpdateLLMAssignmentRequest {
  modelId: string;
  overrideTemperature?: number;
  overrideMaxTokens?: number;
}

// PUT /api/admin/llm-assignments/bulk
// 全機能一括変更
interface BulkUpdateLLMAssignmentRequest {
  modelId: string;
}
```

---

### 3.3 LM-03: LLMプロンプトを管理する

#### 概要
プロンプトテンプレートをCRUD管理。変数置換、バージョン管理をサポート。

#### データモデル

```sql
CREATE TABLE llm_prompt_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,            -- "syntax-check-v1"
  category TEXT NOT NULL,               -- "system", "user", "assistant"
  feature_key TEXT NOT NULL,            -- "syntax_check", "ai_chat"

  -- テンプレート本体
  content TEXT NOT NULL,

  -- 変数定義（JSON Schema形式）
  variables JSONB DEFAULT '[]',
  -- 例: [{"name": "diagram_type", "type": "string", "required": true}]

  -- バージョン管理
  version INTEGER DEFAULT 1,
  is_active BOOLEAN DEFAULT true,

  -- メタデータ
  description TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 同一slugでアクティブは1つだけ
CREATE UNIQUE INDEX idx_prompt_templates_active_slug
ON llm_prompt_templates (slug) WHERE is_active = true;

-- 履歴テーブル
CREATE TABLE llm_prompt_template_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID NOT NULL REFERENCES llm_prompt_templates(id),
  version INTEGER NOT NULL,
  content TEXT NOT NULL,
  variables JSONB,
  changed_by UUID REFERENCES auth.users(id),
  changed_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### プロンプトテンプレート例

```typescript
// システムプロンプト（構文チェック用）
const syntaxCheckSystemPrompt = {
  name: "PlantUML Syntax Checker",
  slug: "syntax-check-system-v1",
  category: "system",
  featureKey: "syntax_check",
  content: `You are a PlantUML syntax expert.
Analyze the following PlantUML code and identify any syntax errors.

Diagram Type: {{diagram_type}}

For each error found:
1. Line number
2. Error description
3. Suggested fix

If no errors are found, respond with "No syntax errors detected."`,
  variables: [
    { name: "diagram_type", type: "string", required: true }
  ]
};
```

---

### 3.4 LM-04: LLMパラメータを設定する

#### 概要
OpenRouterでサポートされるサンプリングパラメータを設定。

#### サポートパラメータ

| パラメータ | 型 | 範囲 | デフォルト | 説明 |
|-----------|-----|------|-----------|------|
| `temperature` | number | 0.0-2.0 | 0.7 | 応答の多様性 |
| `max_tokens` | integer | 1-∞ | 4096 | 最大生成トークン数 |
| `top_p` | number | 0.0-1.0 | 1.0 | 確率ベースのトークン選択 |
| `top_k` | integer | 0-∞ | 0 | 上位Kトークンに制限 |
| `frequency_penalty` | number | -2.0-2.0 | 0.0 | 頻出トークン抑制 |
| `presence_penalty` | number | -2.0-2.0 | 0.0 | 既出トークン抑制 |
| `stop` | string[] | - | - | 停止トークン |
| `seed` | integer | - | - | 再現性シード |

#### パラメータ適用ロジック

```typescript
interface LLMRequestParams {
  model: string;
  messages: Message[];
  temperature?: number;
  max_tokens?: number;
  top_p?: number;
}

async function buildLLMRequest(
  featureKey: string,
  messages: Message[]
): Promise<LLMRequestParams> {
  // 1. 機能に割り当てられたモデルを取得
  const assignment = await getLLMAssignment(featureKey);
  const model = await getLLMModel(assignment.modelId);

  // 2. パラメータ優先順位: override > model default > system default
  const params: LLMRequestParams = {
    model: model.modelId,
    messages,
    temperature: assignment.overrideTemperature ?? model.defaultTemperature ?? 0.7,
    max_tokens: assignment.overrideMaxTokens ?? model.defaultMaxTokens ?? 4096,
    top_p: model.defaultTopP ?? 1.0,
  };

  return params;
}
```

---

### 3.5 LM-05: LLMワークフローを定義する（Phase 2）

#### 概要
複数のLLM呼び出しを組み合わせた処理パイプラインを定義。
MVPではハードコード、Phase 2でUI設定可能に。

#### MVPワークフロー（ハードコード）

```typescript
// 1. 構文チェック → エラー時AI修正提案
async function syntaxCheckWorkflow(plantUmlCode: string): Promise<SyntaxCheckResult> {
  // Step 1: ローカル構文チェック（node-plantuml）
  const localResult = await validatePlantUML(plantUmlCode);

  if (localResult.hasErrors) {
    // Step 2: AIによる修正提案（OpenRouter経由）
    const prompt = await renderPrompt("syntax-fix-suggestion", {
      code: plantUmlCode,
      errors: JSON.stringify(localResult.errors)
    });

    const aiSuggestion = await callLLM("syntax_check", [
      { role: "system", content: prompt.system },
      { role: "user", content: prompt.user }
    ]);

    return {
      hasErrors: true,
      errors: localResult.errors,
      aiSuggestion: aiSuggestion.content
    };
  }

  return { hasErrors: false, errors: [], aiSuggestion: null };
}

// 2. Question-Start（質問→テンプレート提案→生成）
async function questionStartWorkflow(
  question: string,
  context?: string
): Promise<QuestionStartResult> {
  // Step 1: 質問分析 & テンプレート選択（OpenRouter経由）
  const analysis = await callLLM("question_start", [
    { role: "system", content: await getPrompt("question-analysis-system") },
    { role: "user", content: question }
  ]);

  // Step 2: テンプレート生成（OpenRouter経由）
  const template = await callLLM("question_start", [
    { role: "system", content: await getPrompt("template-generation-system") },
    { role: "user", content: analysis.suggestedTemplate }
  ]);

  return {
    analysis: analysis.content,
    suggestedTemplate: template.content
  };
}
```

---

### 3.6 LM-06: LLM使用量を監視する

#### 概要
OpenRouter APIから使用量を取得し、ダッシュボードで可視化。

#### データモデル

```sql
CREATE TABLE llm_usage_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- リクエスト情報
  request_id TEXT,
  feature_key TEXT NOT NULL,
  model_id TEXT NOT NULL,

  -- トークン情報
  prompt_tokens INTEGER NOT NULL,
  completion_tokens INTEGER NOT NULL,
  total_tokens INTEGER NOT NULL,

  -- コスト（USD）
  cost_usd DECIMAL(10,6),

  -- パフォーマンス
  latency_ms INTEGER,

  -- ユーザー情報（オプション）
  user_id UUID REFERENCES auth.users(id),

  -- タイムスタンプ
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 日次集計ビュー
CREATE VIEW llm_usage_daily AS
SELECT
  DATE(created_at) AS date,
  model_id,
  feature_key,
  COUNT(*) AS request_count,
  SUM(prompt_tokens) AS total_prompt_tokens,
  SUM(completion_tokens) AS total_completion_tokens,
  SUM(total_tokens) AS total_tokens,
  SUM(cost_usd) AS total_cost_usd,
  AVG(latency_ms) AS avg_latency_ms
FROM llm_usage_logs
GROUP BY DATE(created_at), model_id, feature_key;
```

#### 使用量記録ミドルウェア

```typescript
async function callLLMWithLogging(
  featureKey: string,
  messages: Message[],
  userId?: string
): Promise<LLMResponse> {
  const startTime = Date.now();
  const requestId = crypto.randomUUID();

  try {
    const params = await buildLLMRequest(featureKey, messages);

    // OpenRouter経由でLLM呼び出し
    const response = await openrouter.chat.completions.create(params);

    // 使用量をログ
    await supabase.from("llm_usage_logs").insert({
      request_id: requestId,
      feature_key: featureKey,
      model_id: params.model,
      prompt_tokens: response.usage.prompt_tokens,
      completion_tokens: response.usage.completion_tokens,
      total_tokens: response.usage.total_tokens,
      cost_usd: calculateCost(params.model, response.usage),
      latency_ms: Date.now() - startTime,
      user_id: userId
    });

    return response;
  } catch (error) {
    // エラーもログ
    await logLLMError(requestId, featureKey, error, Date.now() - startTime);
    throw error;
  }
}
```

#### OpenRouter使用量API連携

```typescript
// OpenRouterのクレジット残高・使用量を取得
async function getOpenRouterUsage(): Promise<OpenRouterUsage> {
  const response = await fetch("https://openrouter.ai/api/v1/key", {
    headers: {
      Authorization: `Bearer ${process.env.OPENROUTER_API_KEY}`
    }
  });

  return response.json();
}
```

---

### 3.7 LM-07: LLMフォールバックを設定する

#### 概要
プライマリモデルが利用不可時に自動で代替モデルに切り替え。

#### データモデル

```sql
CREATE TABLE llm_fallback_chains (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,

  -- フォールバックチェーン（優先順位順）
  model_chain TEXT[] NOT NULL,
  -- 例: ["anthropic/claude-3.5-sonnet", "openai/gpt-4o", "meta-llama/llama-3.1-70b"]

  -- プロバイダー設定
  provider_order TEXT[],
  -- 例: ["Anthropic", "OpenAI", "Together"]

  allow_fallbacks BOOLEAN DEFAULT true,
  require_parameters BOOLEAN DEFAULT false,
  data_collection TEXT DEFAULT 'deny',  -- "deny" | "allow"

  is_default BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 機能別フォールバック割り当て
CREATE TABLE llm_fallback_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  feature_key TEXT NOT NULL UNIQUE,
  fallback_chain_id UUID NOT NULL REFERENCES llm_fallback_chains(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### OpenRouterリクエスト生成

```typescript
async function buildLLMRequestWithFallback(
  featureKey: string,
  messages: Message[]
): Promise<OpenRouterRequest> {
  const assignment = await getFallbackAssignment(featureKey);
  const chain = await getFallbackChain(assignment.fallbackChainId);

  const request: OpenRouterRequest = {
    model: chain.modelChain[0],  // プライマリモデル
    messages,

    // フォールバック設定
    models: chain.modelChain,
    route: "fallback",

    // プロバイダー設定
    provider: {
      order: chain.providerOrder,
      allow_fallbacks: chain.allowFallbacks,
      require_parameters: chain.requireParameters,
      data_collection: chain.dataCollection
    }
  };

  return request;
}
```

---

## 4. Embedding管理機能詳細設計（OpenAI直接）

### 4.1 EM-01: Embeddingモデルを設定する

#### 概要
OpenAI Embedding APIで使用するモデルと設定を管理。
**OpenRouterを経由せず、OpenAI APIに直接接続する。**

#### データモデル

```sql
CREATE TABLE embedding_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- モデル設定
  model_id TEXT NOT NULL DEFAULT 'text-embedding-3-small',
  dimensions INTEGER DEFAULT 1536,

  -- コスト情報
  cost_per_million DECIMAL(10,4) DEFAULT 0.02,  -- $/M tokens

  -- 処理設定
  chunk_size INTEGER DEFAULT 512,
  chunk_overlap INTEGER DEFAULT 50,

  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 利用可能モデル（参照用）
CREATE TABLE embedding_models (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_id TEXT NOT NULL UNIQUE,        -- "text-embedding-3-small"
  display_name TEXT NOT NULL,           -- "Text Embedding 3 Small"
  max_dimensions INTEGER NOT NULL,      -- 1536
  max_input_tokens INTEGER NOT NULL,    -- 8191
  cost_per_million DECIMAL(10,4),       -- $0.02
  mteb_score DECIMAL(4,2),              -- 62.3
  is_active BOOLEAN DEFAULT true
);

-- 初期データ
INSERT INTO embedding_models (model_id, display_name, max_dimensions, max_input_tokens, cost_per_million, mteb_score) VALUES
('text-embedding-3-small', 'Text Embedding 3 Small', 1536, 8191, 0.02, 62.3),
('text-embedding-3-large', 'Text Embedding 3 Large', 3072, 8191, 0.13, 64.6),
('text-embedding-ada-002', 'Text Embedding Ada 002', 1536, 8191, 0.10, 61.0);
```

#### Embeddingクライアント実装

```typescript
import OpenAI from "openai";

// OpenAI直接接続（OpenRouterを経由しない）
const openaiClient = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY  // OpenAI APIキー
});

async function createEmbedding(text: string): Promise<number[]> {
  const settings = await getEmbeddingSettings();

  const response = await openaiClient.embeddings.create({
    model: settings.modelId,  // "text-embedding-3-small"
    input: text,
    dimensions: settings.dimensions
  });

  return response.data[0].embedding;
}

async function createEmbeddingBatch(texts: string[]): Promise<number[][]> {
  const settings = await getEmbeddingSettings();

  const response = await openaiClient.embeddings.create({
    model: settings.modelId,
    input: texts,
    dimensions: settings.dimensions
  });

  return response.data.map(d => d.embedding);
}
```

---

### 4.2 EM-02: Embedding使用量を監視する

#### データモデル

```sql
CREATE TABLE embedding_usage_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- リクエスト情報
  request_id TEXT,
  feature_key TEXT NOT NULL,  -- "learning_content", "rag_search"
  model_id TEXT NOT NULL,

  -- トークン情報（Embeddingは入力のみ）
  input_tokens INTEGER NOT NULL,

  -- コスト（USD）
  cost_usd DECIMAL(10,6),

  -- パフォーマンス
  latency_ms INTEGER,
  input_count INTEGER,  -- バッチ処理時の入力数

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 日次集計ビュー
CREATE VIEW embedding_usage_daily AS
SELECT
  DATE(created_at) AS date,
  model_id,
  feature_key,
  COUNT(*) AS request_count,
  SUM(input_tokens) AS total_input_tokens,
  SUM(cost_usd) AS total_cost_usd,
  AVG(latency_ms) AS avg_latency_ms
FROM embedding_usage_logs
GROUP BY DATE(created_at), model_id, feature_key;
```

#### 使用量記録付きEmbedding

```typescript
async function createEmbeddingWithLogging(
  text: string,
  featureKey: string
): Promise<number[]> {
  const startTime = Date.now();
  const requestId = crypto.randomUUID();
  const settings = await getEmbeddingSettings();

  try {
    const response = await openaiClient.embeddings.create({
      model: settings.modelId,
      input: text,
      dimensions: settings.dimensions
    });

    // 使用量をログ
    await supabase.from("embedding_usage_logs").insert({
      request_id: requestId,
      feature_key: featureKey,
      model_id: settings.modelId,
      input_tokens: response.usage.total_tokens,
      cost_usd: response.usage.total_tokens * settings.costPerMillion / 1_000_000,
      latency_ms: Date.now() - startTime,
      input_count: 1
    });

    return response.data[0].embedding;
  } catch (error) {
    await logEmbeddingError(requestId, featureKey, error, Date.now() - startTime);
    throw error;
  }
}
```

---

## 5. 学習コンテンツ管理機能（Phase 2）

### 5.1 LC-01: 学習コンテンツを登録する

#### 概要
Markdown/PDFファイルをアップロードし、OpenAI Embeddingでベクトル化してpgvectorに保存。

#### データモデル

```sql
CREATE TABLE learning_contents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  source_type TEXT NOT NULL,  -- "markdown", "pdf"
  source_file_path TEXT,

  -- メタデータ
  description TEXT,
  tags TEXT[],

  -- ステータス
  status TEXT DEFAULT 'pending',  -- "pending", "processing", "completed", "failed"
  chunk_count INTEGER DEFAULT 0,

  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE learning_content_chunks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_id UUID NOT NULL REFERENCES learning_contents(id) ON DELETE CASCADE,
  chunk_index INTEGER NOT NULL,

  -- チャンク内容
  content TEXT NOT NULL,
  token_count INTEGER,

  -- Embedding（OpenAI直接生成）
  embedding VECTOR(1536),

  -- メタデータ
  metadata JSONB DEFAULT '{}',

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 類似検索用インデックス
CREATE INDEX idx_learning_chunks_embedding ON learning_content_chunks
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);
```

#### 登録フロー

```typescript
async function registerLearningContent(
  file: File,
  metadata: LearningContentMetadata
): Promise<LearningContent> {
  // 1. レコード作成
  const content = await supabase.from("learning_contents").insert({
    title: metadata.title,
    category: metadata.category,
    source_type: file.type === "application/pdf" ? "pdf" : "markdown",
    status: "processing"
  }).select().single();

  try {
    // 2. テキスト抽出
    const text = await extractText(file);

    // 3. チャンキング
    const settings = await getEmbeddingSettings();
    const chunks = chunkText(text, settings.chunkSize, settings.chunkOverlap);

    // 4. Embedding生成（OpenAI直接）& 保存
    for (let i = 0; i < chunks.length; i++) {
      const embedding = await createEmbeddingWithLogging(
        chunks[i],
        "learning_content"
      );

      await supabase.from("learning_content_chunks").insert({
        content_id: content.id,
        chunk_index: i,
        content: chunks[i],
        embedding,
        token_count: countTokens(chunks[i])
      });
    }

    // 5. ステータス更新
    await supabase.from("learning_contents").update({
      status: "completed",
      chunk_count: chunks.length
    }).eq("id", content.id);

    return content;
  } catch (error) {
    await supabase.from("learning_contents").update({
      status: "failed"
    }).eq("id", content.id);
    throw error;
  }
}
```

---

### 5.2 LC-02: 学習コンテンツを管理する

#### API設計

```typescript
// GET /api/admin/learning-contents
// POST /api/admin/learning-contents
// GET /api/admin/learning-contents/:id
// PUT /api/admin/learning-contents/:id
// DELETE /api/admin/learning-contents/:id

// RAG検索（OpenAI Embedding + pgvector）
// POST /api/learning-contents/search
interface LearningContentSearchRequest {
  query: string;
  category?: string;
  limit?: number;
}

interface LearningContentSearchResponse {
  results: {
    contentId: string;
    title: string;
    chunkContent: string;
    similarity: number;
  }[];
}
```

#### 類似検索実装

```typescript
async function searchLearningContent(
  query: string,
  options: { category?: string; limit?: number } = {}
): Promise<SearchResult[]> {
  // 1. クエリをEmbedding化（OpenAI直接）
  const queryEmbedding = await createEmbeddingWithLogging(query, "rag_search");

  // 2. pgvectorで類似検索
  const { data } = await supabase.rpc("match_learning_chunks", {
    query_embedding: queryEmbedding,
    match_count: options.limit ?? 5,
    filter_category: options.category
  });

  return data;
}
```

---

## 6. アーキテクチャ

### 6.1 コンポーネント図

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Frontend (Next.js)                            │
│  ┌─────────────┐  ┌─────────────┐  ┌───────────────┐  ┌───────────┐│
│  │ Admin Panel │  │ AI Chat UI  │  │ Question-Start│  │ RAG Search││
│  └──────┬──────┘  └──────┬──────┘  └───────┬───────┘  └─────┬─────┘│
└─────────┼────────────────┼─────────────────┼────────────────┼───────┘
          │                │                 │                │
          ▼                ▼                 ▼                ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      API Routes (Next.js)                            │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                     Service Layer                             │   │
│  │                                                               │   │
│  │  ┌─────────────────────────┐  ┌─────────────────────────┐    │   │
│  │  │    LLM Service          │  │   Embedding Service      │    │   │
│  │  │    (OpenRouter経由)     │  │   (OpenAI直接)          │    │   │
│  │  │                         │  │                         │    │   │
│  │  │  ・Model Manager        │  │  ・Embedding Generator   │    │   │
│  │  │  ・Prompt Manager       │  │  ・Chunk Manager        │    │   │
│  │  │  ・Fallback Controller  │  │  ・Vector Search        │    │   │
│  │  │  ・Usage Logger         │  │  ・Usage Logger         │    │   │
│  │  └───────────┬─────────────┘  └───────────┬─────────────┘    │   │
│  └──────────────┼────────────────────────────┼──────────────────┘   │
└─────────────────┼────────────────────────────┼───────────────────────┘
                  │                            │
    ┌─────────────┼────────────────────────────┼─────────────┐
    │             │                            │             │
    ▼             │                            ▼             ▼
┌─────────────┐   │                    ┌─────────────┐ ┌───────────────┐
│ OpenRouter  │   │                    │  OpenAI API │ │   Supabase    │
│   API       │   │                    │  (直接接続)  │ │  PostgreSQL   │
│             │   │                    │             │ │  + pgvector   │
│ Chat/       │   │                    │ Embeddings  │ │               │
│ Completions │   │                    │ API         │ │ ・llm_models  │
└─────────────┘   │                    └─────────────┘ │ ・prompts     │
                  │                                    │ ・usage_logs  │
                  └───────────────────────────────────>│ ・embeddings  │
                           DB接続                      └───────────────┘
```

### 6.2 APIキー管理

```bash
# .env.local

# LLM用（OpenRouter経由）
OPENROUTER_API_KEY=sk-or-v1-xxxxx

# Embedding用（OpenAI直接）
OPENAI_API_KEY=sk-xxxxx

# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=xxxxx
```

---

## 7. セキュリティ

### 7.1 アクセス制御

| 機能 | エンドユーザー | 管理者 | 開発者 |
|------|:-------------:|:------:|:------:|
| AIチャット利用 | ✅ | ✅ | ✅ |
| RAG検索利用 | ✅ | ✅ | ✅ |
| LLMモデル設定閲覧 | ❌ | ✅ | ✅ |
| LLMモデル設定変更 | ❌ | ❌ | ✅ |
| Embedding設定閲覧 | ❌ | ✅ | ✅ |
| Embedding設定変更 | ❌ | ❌ | ✅ |
| 使用量閲覧 | ❌ | ✅ | ✅ |
| 学習コンテンツ管理 | ❌ | ❌ | ✅ |

### 7.2 データプライバシー

```typescript
// OpenRouter: データ収集拒否
const llmRequest = {
  model: "anthropic/claude-3.5-sonnet",
  messages,
  provider: {
    data_collection: "deny"
  }
};

// OpenAI: API経由データは学習に使用されない
// ※ Enterprise/APIのデフォルトポリシー
```

---

## 8. 実装ロードマップ

### Phase 1: MVP（4週間）- LLM管理のみ

| 週 | タスク |
|:--:|--------|
| W1 | DB設計・マイグレーション、LLM基本API（LM-01, LM-02） |
| W2 | プロンプト管理（LM-03）、パラメータ設定（LM-04） |
| W3 | 使用量監視（LM-06）、フォールバック（LM-07） |
| W4 | 管理画面UI、テスト、ドキュメント |

### Phase 2: 拡張（4週間）- Embedding + 学習コンテンツ

| 週 | タスク |
|:--:|--------|
| W5 | Embedding設定（EM-01, EM-02）、OpenAI直接接続実装 |
| W6 | 学習コンテンツ登録（LC-01）、チャンキング |
| W7 | 学習コンテンツ管理（LC-02）、RAG検索 |
| W8 | ワークフローエンジン（LM-05）、統合テスト |

---

## 9. 技術的決定事項

### TD-007: AI機能プロバイダー構成

| 項目 | 決定 | 根拠 |
|------|------|------|
| **LLMプロバイダー** | OpenRouter（統一API） | 複数プロバイダー対応、自動フォールバック |
| **Embeddingプロバイダー** | OpenAI（直接接続） | OpenRouterにEmbedding APIなし、コスト効率 |
| **LLM→Embedding分離** | 別APIキー、別クライアント | 責務分離、障害分離 |
| **フォールバック** | LLMのみ（OpenRouter機能） | Embeddingはモデル固定でフォールバック不要 |
| **プロンプト管理** | アプリ側DB保存 | OpenRouterは保存機能なし |
| **使用量監視** | LLM/Embedding別に記録 | コスト分析の粒度向上 |

---

## 10. 参考資料

- [OpenRouter LLM制御仕様調査レポート](./openrouter_llm_control_specification.md)
- [OpenRouter Documentation](https://openrouter.ai/docs)
- [OpenAI Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
- [Supabase pgvector](https://supabase.com/docs/guides/ai/vector-columns)
