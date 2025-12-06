# OpenRouter LLM制御仕様調査レポート

**調査日**: 2025-12-06
**目的**: PlantUML StudioのLLM管理機能設計のための技術調査

---

## 1. OpenRouter概要

OpenRouterは**数百のAIモデルへのアクセスを単一エンドポイント経由で提供する統合API**です。

### 主な特徴
- OpenAI API互換（`/chat/completions`エンドポイント）
- 自動フォールバック・負荷分散
- 複数プロバイダー間の統一料金体系（マークアップなし）
- プロンプトキャッシングによるコスト削減

### ベースURL
```
https://openrouter.ai/api/v1
```

---

## 2. 認証

### 必須ヘッダー
```http
Authorization: Bearer <OPENROUTER_API_KEY>
```

### オプションヘッダー
| ヘッダー | 説明 |
|---------|------|
| `HTTP-Referer` | アプリURLを指定するとリーダーボードに表示 |
| `X-Title` | アプリ名を指定 |

---

## 3. 制御可能なパラメータ

### 3.1 サンプリングパラメータ

| パラメータ | 説明 | 範囲 | デフォルト |
|-----------|------|------|-----------|
| `temperature` | 応答の多様性制御 | 0.0〜2.0 | 1.0 |
| `max_tokens` | 最大生成トークン数 | 1〜context_length | - |
| `top_p` | 確率ベースのトークン選択 | 0.0〜1.0 | 1.0 |
| `top_k` | 上位Kトークンに制限 | 0以上 | 0 |
| `frequency_penalty` | 頻出トークン抑制 | -2.0〜2.0 | 0.0 |
| `presence_penalty` | 既出トークン抑制 | -2.0〜2.0 | 0.0 |
| `stop` | 停止トークン指定 | 文字列配列 | - |
| `seed` | 再現性のためのシード | 整数 | - |

### 3.2 出力形式パラメータ

| パラメータ | 説明 |
|-----------|------|
| `response_format` | JSON出力強制（`{"type": "json_object"}`） |
| `tools` | ツール呼び出し定義 |
| `logit_bias` | 特定トークンの確率調整（一部モデルのみ） |
| `logprobs` | トークン確率の取得 |

### 3.3 プロバイダールーティングパラメータ（`provider`オブジェクト）

```json
{
  "provider": {
    "order": ["Anthropic", "OpenAI"],
    "allow_fallbacks": true,
    "require_parameters": true,
    "data_collection": "deny",
    "only": ["Anthropic"],
    "ignore": ["Together"]
  }
}
```

| フィールド | 説明 |
|-----------|------|
| `order` | プロバイダー優先順位（配列） |
| `allow_fallbacks` | フォールバック許可（bool） |
| `require_parameters` | 全パラメータ対応プロバイダーのみ使用 |
| `data_collection` | `"deny"`でデータ収集拒否 |
| `only` | 指定プロバイダーのみ使用 |
| `ignore` | 指定プロバイダーを除外 |

### 3.4 モデルフォールバック設定

```json
{
  "models": ["anthropic/claude-3.5-sonnet", "openai/gpt-4o"],
  "route": "fallback"
}
```

- プライマリモデルがエラー時、次のモデルを自動試行
- `route: "fallback"`のみ指定した場合、適切なOSSモデルを自動選択

---

## 4. モデルバリアント

| バリアント | 説明 | 用途 |
|-----------|------|------|
| `:free` | 無料（低レート制限） | テスト・開発 |
| `:extended` | 拡張コンテキスト長 | 長文処理 |
| `:nitro` | スループット優先 | 高速レスポンス |
| `:floor` | 価格優先 | コスト最適化 |
| `:thinking` | 推論サポート | 複雑な思考タスク |
| `:exacto` | 高品質エンドポイント | 品質優先 |

---

## 5. エラーコードと対処法

| コード | 意味 | 対処法 |
|:------:|------|--------|
| 400 | Bad Request | パラメータ修正 |
| 401 | 認証エラー | APIキー確認・再生成 |
| 402 | クレジット不足 | クレジット追加 |
| 403 | アクセス拒否 | 権限確認 |
| 429 | レート制限 | 指数バックオフでリトライ |
| 500 | サーバーエラー | リトライ |
| 502 | Bad Gateway | 待機後リトライ |
| 503 | プロバイダー利用不可 | フォールバック or 待機 |

### ストリーミング中のエラー
- HTTP 200が送信済みの場合、エラーはSSEイベントで送信
- `finish_reason: "error"`でストリーム終了

---

## 6. プロンプトキャッシング

### コスト構造
| 操作 | コスト |
|------|--------|
| Cache Write | 入力トークンコスト + 5分のストレージ |
| Cache Read | 入力トークンコストの **0.25倍** |

### ベストプラクティス
1. **動的部分をプロンプト末尾に配置** - キャッシュヒット率向上
2. **大きなコンテンツに適用** - CSV、RAGデータ、長文ソース
3. **最小トークン数を確認** - Gemini: 4096（2.5 Pro: 2048、2.5 Flash: 1028）

### プロバイダー別対応
- **Anthropic**: メッセージ単位で明示的に有効化が必要
- **Gemini**: 自動管理（TTL 5分、自動更新なし）
- **OpenAI**: 自動対応

---

## 7. 使用量監視

### エンドポイント
```
GET https://openrouter.ai/api/v1/key
```

### 取得可能情報
- クレジット残高
- 利用状況（全期間/日次/週次/月次）
- BYOK使用量

### レスポンス内の使用量情報
```json
{
  "usage": {
    "prompt_tokens": 100,
    "completion_tokens": 50,
    "total_tokens": 150
  }
}
```

---

## 8. レート制限

### 無料モデルの制限
- 分単位・日単位のリクエスト制限あり
- クレジット購入で日次上限緩和

### クレジット残高による制限
- 残高がマイナスの場合、無料モデルも利用不可（402エラー）

### 事前確認方法
```
GET https://openrouter.ai/api/v1/models
Authorization: Bearer <API_KEY>
```
→ ユーザーが生成可能な最大トークン数を事前に確認可能

---

## 9. モデル一覧取得

### 全モデル一覧
```
GET https://openrouter.ai/api/v1/models
```

### 特定モデルのエンドポイント
```
GET https://openrouter.ai/api/v1/models/:author/:slug/endpoints
```

### 価格情報
- 百万トークンあたりの価格
- プロンプト/コンプリーション別価格
- リクエスト単価、画像単価、推論トークン単価

---

## 10. ベストプラクティス

### 10.1 プロダクション導入手順

1. **ステージングで明示的モデル選択から開始**
2. **構造化ログを実装**
   - モデル/プロバイダー名
   - コスト
   - レイテンシ
3. **フィーチャーフラグで自動ルーティング導入**
   - `:nitro`（高速）or `:floor`（低コスト）
4. **予算アラーム設定**
5. **1週間比較後に本番適用**

### 10.2 フォールバック戦略

```
推奨フォールバックチェーン:
1. 優先プロバイダー（Anthropic等）
2. バックアッププロバイダー（OpenAI等）
3. OSSモデル（Llama等）
```

### 10.3 コスト最適化

1. **`:floor`バリアント使用** - 最安プロバイダー自動選択
2. **プロンプトキャッシング活用** - 75%コスト削減
3. **使用量監視の自動化** - 予算超過防止

### 10.4 エラーハンドリング

```python
# 推奨リトライ戦略
def call_with_retry(request, max_retries=3):
    for attempt in range(max_retries):
        try:
            return make_request(request)
        except RateLimitError:
            wait_time = 2 ** attempt  # 指数バックオフ
            time.sleep(wait_time)
        except (BadGatewayError, ServiceUnavailableError):
            # フォールバックモデルを試行
            request["model"] = FALLBACK_MODEL
    raise MaxRetriesExceeded()
```

### 10.5 セキュリティ

- APIキーは環境変数で管理
- `data_collection: "deny"`でデータ収集拒否
- プロンプトログ記録はオプトイン

---

## 11. PlantUML Studio LLM管理機能への示唆

### OpenRouterで制御可能（アプリ側設定不要）
- サンプリングパラメータ（temperature等）→ リクエスト時に付与
- プロバイダールーティング → `provider`オブジェクトで制御
- フォールバック → `models`配列 + `route: "fallback"`
- 使用量取得 → `/api/v1/key`エンドポイント

### アプリ側で実装が必要
| 機能 | 理由 |
|------|------|
| プロンプトテンプレート管理 | OpenRouterは提供しない |
| ワークフロー定義 | アプリ固有のロジック |
| モデル設定のDB保存 | 永続化が必要 |
| コスト監視ダッシュボード | 可視化が必要 |

### 推奨LLM管理機能（再整理）

| # | 機能名 | 実装方法 |
|:-:|--------|---------|
| LM-01 | LLMモデルを登録する | DB保存（モデルID、デフォルトパラメータ） |
| LM-02 | LLMモデルを切り替える | DB更新 + リクエスト時適用 |
| LM-03 | LLMプロンプトを管理する | DB保存（テンプレートCRUD） |
| LM-04 | LLMパラメータを設定する | DB保存 → リクエスト時付与 |
| LM-05 | LLMワークフローを定義する | アプリロジック（処理パイプライン） |
| LM-06 | LLM使用量を監視する | OpenRouter API取得 + 可視化 |
| LM-07 | LLMフォールバックを設定する | `provider.order` + `models`配列で実現 |

---

## 12. LLM接続仕様

### 12.1 エンドポイント

| エンドポイント | メソッド | 用途 |
|---------------|---------|------|
| `/api/v1/chat/completions` | POST | チャット補完（メイン） |
| `/api/v1/completions` | POST | テキスト補完（レガシー） |
| `/api/v1/models` | GET | モデル一覧取得 |
| `/api/v1/models/:author/:slug/endpoints` | GET | 特定モデルのエンドポイント |
| `/api/v1/key` | GET | APIキー情報・使用量取得 |

### 12.2 リクエスト形式

#### 必須ヘッダー
```http
POST https://openrouter.ai/api/v1/chat/completions
Authorization: Bearer <OPENROUTER_API_KEY>
Content-Type: application/json
```

#### オプションヘッダー
| ヘッダー | 説明 |
|---------|------|
| `HTTP-Referer` | アプリURL（リーダーボード表示用） |
| `X-Title` | アプリ名 |

#### リクエストボディ（基本形）
```json
{
  "model": "anthropic/claude-3.5-sonnet",
  "messages": [
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "Hello!"}
  ],
  "temperature": 0.7,
  "max_tokens": 1000,
  "stream": false
}
```

#### リクエストボディ（フル設定）
```json
{
  "model": "anthropic/claude-3.5-sonnet",
  "messages": [
    {"role": "system", "content": "..."},
    {"role": "user", "content": "..."}
  ],
  "temperature": 0.7,
  "max_tokens": 1000,
  "top_p": 0.9,
  "top_k": 40,
  "frequency_penalty": 0.0,
  "presence_penalty": 0.0,
  "stop": ["END"],
  "seed": 12345,
  "stream": true,
  "response_format": {"type": "json_object"},
  "tools": [...],
  "tool_choice": "auto",
  "provider": {
    "order": ["Anthropic", "OpenAI"],
    "allow_fallbacks": true,
    "require_parameters": true,
    "data_collection": "deny"
  },
  "models": ["anthropic/claude-3.5-sonnet", "openai/gpt-4o"],
  "route": "fallback"
}
```

### 12.3 レスポンス形式

#### 非ストリーミング
```json
{
  "id": "gen-xxxxx",
  "object": "chat.completion",
  "created": 1234567890,
  "model": "anthropic/claude-3.5-sonnet",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Hello! How can I help you?"
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 10,
    "completion_tokens": 8,
    "total_tokens": 18
  }
}
```

#### `finish_reason`の正規化値
| 値 | 意味 |
|----|------|
| `stop` | 正常終了 |
| `length` | max_tokens到達 |
| `tool_calls` | ツール呼び出し |
| `content_filter` | コンテンツフィルタ |
| `error` | エラー発生 |

※ `native_finish_reason`で生の値も取得可能

### 12.4 ストリーミング

#### 有効化
```json
{
  "stream": true
}
```

#### SSEレスポンス形式
```
data: {"id":"gen-xxx","object":"chat.completion.chunk","choices":[{"delta":{"content":"Hello"}}]}

data: {"id":"gen-xxx","object":"chat.completion.chunk","choices":[{"delta":{"content":"!"}}]}

data: {"id":"gen-xxx","object":"chat.completion.chunk","choices":[],"usage":{"prompt_tokens":10,"completion_tokens":8}}

data: [DONE]
```

#### ストリーミングの特徴
- `choices[].delta.content`でトークンを取得
- 最後に`usage`オブジェクト付きの空`choices`
- `data: [DONE]`で終了
- SSEコメント（`: `で始まる行）はキープアライブ用

#### ストリーミング中のエラー
```json
{
  "id": "gen-xxx",
  "object": "chat.completion.chunk",
  "choices": [
    {
      "finish_reason": "error"
    }
  ],
  "error": {
    "code": 500,
    "message": "Provider error"
  }
}
```
※ HTTP 200送信後のエラーはSSEイベントで送信

### 12.5 タイムアウト・リトライ設定

#### 推奨設定
| 設定 | 値 | 説明 |
|------|-----|------|
| タイムアウト | 60〜90秒 | 長文生成を考慮 |
| リトライ回数 | 3〜5回 | 一時的障害対応 |
| バックオフ | 指数（2^n秒） | 429対応 |

#### TypeScript実装例
```typescript
const client = new OpenRouter({
  apiKey: process.env.OPENROUTER_API_KEY,
  timeout: 60000,  // 60秒
  maxRetries: 3,
});

// リトライ付きリクエスト
async function callWithRetry(request: ChatRequest, maxRetries = 3) {
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await client.chat.completions.create(request);
    } catch (error) {
      if (error.status === 429) {
        const waitTime = Math.pow(2, attempt) * 1000;
        await new Promise(r => setTimeout(r, waitTime));
        continue;
      }
      if (error.status >= 500) {
        // フォールバックモデルを試行
        request.model = FALLBACK_MODEL;
        continue;
      }
      throw error;
    }
  }
  throw new Error('Max retries exceeded');
}
```

### 12.6 SDK統合

#### 公式TypeScript SDK（Beta）
```bash
npm add @openrouter/sdk
```

```typescript
import { OpenRouter } from "@openrouter/sdk";

const openRouter = new OpenRouter({
  apiKey: process.env.OPENROUTER_API_KEY
});

// 非ストリーミング
const response = await openRouter.chat.completions.create({
  model: "anthropic/claude-3.5-sonnet",
  messages: [{ role: "user", content: "Hello!" }]
});

// ストリーミング
const stream = await openRouter.chat.completions.create({
  model: "anthropic/claude-3.5-sonnet",
  messages: [{ role: "user", content: "Hello!" }],
  stream: true
});

for await (const chunk of stream) {
  process.stdout.write(chunk.choices[0]?.delta?.content || "");
}
```

#### OpenAI SDK互換
```typescript
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://openrouter.ai/api/v1",
  apiKey: process.env.OPENROUTER_API_KEY,
  defaultHeaders: {
    "HTTP-Referer": "https://your-app.com",
    "X-Title": "Your App Name"
  }
});

const completion = await client.chat.completions.create({
  model: "anthropic/claude-3.5-sonnet",
  messages: [{ role: "user", content: "Hello!" }]
});
```

#### Vercel AI SDK
```bash
npm i @openrouter/ai-sdk-provider
```

```typescript
import { openrouter } from "@openrouter/ai-sdk-provider";
import { generateText } from "ai";

const { text } = await generateText({
  model: openrouter("anthropic/claude-3.5-sonnet"),
  prompt: "Hello!"
});
```

### 12.7 接続のベストプラクティス

#### セキュリティ
1. **APIキーは環境変数で管理**
   ```bash
   OPENROUTER_API_KEY=sk-or-v1-xxxxx
   ```
2. **クライアントサイドでAPIキーを露出しない**
   - Next.js API Routesなどサーバーサイドで呼び出し
3. **`data_collection: "deny"`でプライバシー保護**

#### パフォーマンス
1. **ストリーミングでUX向上**
   - 長文生成時は`stream: true`
2. **適切なタイムアウト設定**
   - 短すぎると長文生成が中断
3. **コネクションプーリング**
   - SDKインスタンスを再利用

#### 信頼性
1. **フォールバック設定**
   ```json
   {
     "models": ["primary-model", "backup-model"],
     "route": "fallback"
   }
   ```
2. **指数バックオフでリトライ**
3. **エラーログの構造化**
   - モデル名、プロバイダー、レイテンシ、コストを記録

---

## 13. OpenAI Embedding API詳細仕様

### 13.1 概要

OpenRouterは**Embedding専用APIを提供していない**ため、PlantUML StudioではOpenAI Embedding APIを直接使用する。

| 項目 | 状況 |
|------|------|
| OpenRouter Embedding | ❌ 専用エンドポイントなし |
| 推奨方法 | ✅ **OpenAI API直接使用** |
| 選定モデル | `text-embedding-3-small` |

---

### 13.2 接続仕様

#### 13.2.1 エンドポイント

| エンドポイント | メソッド | 用途 |
|---------------|---------|------|
| `https://api.openai.com/v1/embeddings` | POST | 同期埋め込み生成 |
| `https://api.openai.com/v1/batches` | POST | 非同期バッチ処理（50%割引） |

#### 13.2.2 認証

```http
POST https://api.openai.com/v1/embeddings
Authorization: Bearer <OPENAI_API_KEY>
Content-Type: application/json
```

#### 13.2.3 リクエスト形式

**単一テキスト:**
```json
{
  "model": "text-embedding-3-small",
  "input": "Your text to embed",
  "dimensions": 1536,
  "encoding_format": "float"
}
```

**バッチ（配列）:**
```json
{
  "model": "text-embedding-3-small",
  "input": ["text1", "text2", "text3"],
  "dimensions": 1536,
  "encoding_format": "float"
}
```

#### 13.2.4 リクエストパラメータ

| パラメータ | 必須 | 型 | 説明 | デフォルト |
|-----------|:----:|-----|------|-----------|
| `model` | ✅ | string | モデルID | - |
| `input` | ✅ | string \| array | テキストまたはテキスト配列（最大2048要素） | - |
| `dimensions` | - | integer | 出力次元数（MRL対応モデルのみ） | モデル依存 |
| `encoding_format` | - | string | `"float"` or `"base64"` | `"float"` |
| `user` | - | string | エンドユーザー識別子（不正利用検出用） | - |

#### 13.2.5 レスポンス形式

```json
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "index": 0,
      "embedding": [0.0023064255, -0.009327292, ...]
    }
  ],
  "model": "text-embedding-3-small",
  "usage": {
    "prompt_tokens": 5,
    "total_tokens": 5
  }
}
```

#### 13.2.6 レスポンスヘッダー（レート制限監視用）

| ヘッダー | 説明 |
|---------|------|
| `x-ratelimit-limit-requests` | 分あたりリクエスト上限 |
| `x-ratelimit-limit-tokens` | 分あたりトークン上限 |
| `x-ratelimit-remaining-requests` | 残りリクエスト数 |
| `x-ratelimit-remaining-tokens` | 残りトークン数 |
| `x-ratelimit-reset-requests` | リクエスト制限リセット時刻 |
| `x-ratelimit-reset-tokens` | トークン制限リセット時刻 |
| `retry-after` | 429エラー時の待機秒数 |

---

### 13.3 利用可能モデル

| モデル | 次元数 | 最大入力 | 価格 | MTEB | MIRACL | 用途 |
|--------|:------:|:-------:|:----:|:----:|:------:|------|
| `text-embedding-3-small` | 1536 | 8191 | $0.02/M | 62.3% | 44.0% | **推奨（MVP）** |
| `text-embedding-3-large` | 3072 | 8191 | $0.13/M | 64.6% | 54.9% | 高精度要求時 |
| `text-embedding-ada-002` | 1536 | 8191 | $0.10/M | 61.0% | 31.4% | レガシー |

**モデル選定基準:**
- **MVP/スタートアップ**: `text-embedding-3-small`（コスト効率最高）
- **ミッションクリティカル**: `text-embedding-3-large`（精度優先）
- **レガシー互換**: `text-embedding-ada-002`（既存システム移行時のみ）

---

### 13.4 制限事項

#### 13.4.1 入力制限

| 制限項目 | 値 | 備考 |
|---------|-----|------|
| **最大入力トークン** | 8,191 tokens/テキスト | 超過時は400エラー |
| **最大配列サイズ** | 2,048要素/リクエスト | input配列の要素数 |
| **リクエストあたり総トークン** | 約300,000 tokens | 36×8,191の上限目安 |
| **空文字列** | ❌ 不可 | 400エラー |

#### 13.4.2 レート制限（Usage Tier別）

| Tier | 条件 | RPM | TPM | 備考 |
|:----:|------|:---:|:---:|------|
| **Free** | - | 3 | 制限あり | テスト用 |
| **Tier 1** | $5+支払い | 500 | 1,000,000 | 開発用 |
| **Tier 2** | $50+支払い, 7日以上 | 500 | 1,000,000 | 本番小規模 |
| **Tier 3** | $100+支払い, 7日以上 | 1,000 | 2,000,000 | 本番中規模 |
| **Tier 4** | $250+支払い, 14日以上 | 5,000 | 5,000,000 | 本番大規模 |
| **Tier 5** | $1,000+支払い, 30日以上 | 10,000 | 10,000,000 | エンタープライズ |

※ RPM = Requests Per Minute, TPM = Tokens Per Minute

#### 13.4.3 Batch API制限

| 制限項目 | 値 |
|---------|-----|
| キュー内最大リクエスト数 | 1,000,000 |
| 処理時間SLA | 24時間以内 |
| 価格割引 | **50%オフ** |

---

### 13.5 Matryoshka Representation Learning (MRL)

text-embedding-3シリーズは**次元削減**をネイティブサポート。

#### 13.5.1 使用方法

```json
{
  "model": "text-embedding-3-small",
  "input": "Hello world",
  "dimensions": 256
}
```

#### 13.5.2 次元数と性能トレードオフ

| 次元数 | MTEB | ストレージ削減 | 推奨用途 |
|:------:|:----:|:-------------:|---------|
| 1536 | 62.3% | 0% | 最高精度（デフォルト） |
| 1024 | 61.9% | 33% | バランス |
| 512 | 61.6% | 67% | ストレージ重視 |
| 256 | 59.7% | 83% | 大規模・低コスト |

#### 13.5.3 MRLの特性

- **漸進的精度低下**: 重要情報は先頭次元に集約
- **再学習不要**: API呼び出し時に次元指定するだけ
- **コサイン類似度**: OpenAI Embeddingは**L2正規化済み**のため、ドット積で高速計算可能

---

### 13.6 非同期Batch API

リアルタイム性不要な場合、Batch APIで**50%コスト削減**。

#### 13.6.1 JSONL入力ファイル形式

```jsonl
{"custom_id": "req-1", "method": "POST", "url": "/v1/embeddings", "body": {"model": "text-embedding-3-small", "input": "First text"}}
{"custom_id": "req-2", "method": "POST", "url": "/v1/embeddings", "body": {"model": "text-embedding-3-small", "input": "Second text"}}
```

#### 13.6.2 バッチ作成フロー

```typescript
import OpenAI from "openai";
import * as fs from "fs";

const openai = new OpenAI();

// 1. JONLファイルをアップロード
const file = await openai.files.create({
  file: fs.createReadStream("embeddings_batch.jsonl"),
  purpose: "batch"
});

// 2. バッチジョブ作成
const batch = await openai.batches.create({
  input_file_id: file.id,
  endpoint: "/v1/embeddings",
  completion_window: "24h"
});

// 3. ステータス確認
const status = await openai.batches.retrieve(batch.id);
console.log(status.status); // "validating" | "in_progress" | "completed" | "failed"

// 4. 結果取得
if (status.status === "completed") {
  const results = await openai.files.content(status.output_file_id!);
  // 各行をパースして処理
}
```

#### 13.6.3 バッチステータス

| ステータス | 説明 |
|-----------|------|
| `validating` | ファイル検証中 |
| `in_progress` | 処理中 |
| `finalizing` | 結果準備中 |
| `completed` | ✅ 完了 |
| `failed` | ❌ 検証失敗 |
| `expired` | SLA超過（24時間） |
| `canceling` | キャンセル中 |
| `cancelled` | キャンセル完了 |

#### 13.6.4 価格比較

| モデル | 同期API | Batch API | 削減率 |
|--------|:-------:|:---------:|:------:|
| text-embedding-3-small | $0.020/M | $0.010/M | **50%** |
| text-embedding-3-large | $0.130/M | $0.065/M | **50%** |

---

### 13.7 エラーハンドリング

#### 13.7.1 エラーコード

| コード | 意味 | 対処法 |
|:------:|------|--------|
| 400 | Bad Request | 入力検証（長さ、空文字列、配列サイズ） |
| 401 | Unauthorized | APIキー確認、再生成 |
| 403 | Forbidden | アクセス権限確認 |
| 429 | Rate Limit | 指数バックオフ + `retry-after`ヘッダー参照 |
| 500 | Server Error | リトライ（最大3回） |
| 503 | Service Unavailable | 待機後リトライ |

#### 13.7.2 指数バックオフ実装（Tenacityライブラリ）

```python
from tenacity import retry, stop_after_attempt, wait_random_exponential
import openai

@retry(
    wait=wait_random_exponential(min=1, max=60),
    stop=stop_after_attempt(6)
)
def embed_with_backoff(text: str) -> list[float]:
    response = openai.embeddings.create(
        model="text-embedding-3-small",
        input=text
    )
    return response.data[0].embedding
```

#### 13.7.3 TypeScript実装（手動バックオフ）

```typescript
import OpenAI from "openai";

const openai = new OpenAI();

async function embedWithRetry(
  text: string,
  maxRetries = 5,
  initialDelay = 1000
): Promise<number[]> {
  let delay = initialDelay;

  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      const response = await openai.embeddings.create({
        model: "text-embedding-3-small",
        input: text
      });
      return response.data[0].embedding;
    } catch (error: any) {
      if (error.status === 429) {
        // retry-afterヘッダーがあれば優先
        const retryAfter = error.headers?.["retry-after"];
        const waitTime = retryAfter ? parseInt(retryAfter) * 1000 : delay;

        console.warn(`Rate limited. Waiting ${waitTime}ms...`);
        await new Promise(r => setTimeout(r, waitTime));

        // 指数バックオフ + ジッター
        delay *= 2 * (1 + Math.random() * 0.1);
        continue;
      }

      if (error.status >= 500 && attempt < maxRetries - 1) {
        await new Promise(r => setTimeout(r, delay));
        delay *= 2;
        continue;
      }

      throw error;
    }
  }
  throw new Error(`Max retries (${maxRetries}) exceeded`);
}
```

#### 13.7.4 プロアクティブ遅延（レート制限回避）

```typescript
// レート制限に余裕を持たせるプロアクティブ遅延
async function embedWithDelay(
  texts: string[],
  rpmLimit = 500,
  tpmLimit = 1000000
): Promise<number[][]> {
  const results: number[][] = [];
  const delayMs = (60 / rpmLimit) * 1000; // 例: 500 RPM → 120ms間隔

  for (const text of texts) {
    const embedding = await embedWithRetry(text);
    results.push(embedding);
    await new Promise(r => setTimeout(r, delayMs));
  }

  return results;
}
```

---

### 13.8 セキュリティとデータプライバシー

#### 13.8.1 OpenAIデータポリシー

| 項目 | ポリシー |
|------|---------|
| **データ保持** | 最大30日（不正利用検出目的） |
| **学習利用** | ❌ API/Enterprise経由データは学習に使用しない |
| **Zero Data Retention (ZDR)** | ✅ Embeddings APIは申請可能 |
| **暗号化** | AES-256（保存時）、TLS 1.2+（転送時） |
| **コンプライアンス** | SOC 2 Type 2、GDPR、CCPA対応 |

#### 13.8.2 実装時のセキュリティ対策

```typescript
// ✅ 推奨: サーバーサイドでのみAPI呼び出し
// Next.js API Route例
// app/api/embed/route.ts
import { NextRequest, NextResponse } from "next/server";
import OpenAI from "openai";

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY // 環境変数から取得
});

export async function POST(req: NextRequest) {
  const { text } = await req.json();

  // 入力検証
  if (!text || typeof text !== "string" || text.length > 32000) {
    return NextResponse.json({ error: "Invalid input" }, { status: 400 });
  }

  const response = await openai.embeddings.create({
    model: "text-embedding-3-small",
    input: text
  });

  return NextResponse.json({
    embedding: response.data[0].embedding
  });
}
```

#### 13.8.3 セキュリティチェックリスト

- [x] APIキーは環境変数で管理（`.env`に保存、`.gitignore`に追加）
- [x] クライアントサイドでAPIキーを露出しない
- [x] サーバーサイド（API Routes）でのみOpenAI API呼び出し
- [x] 入力データのサニタイズ・バリデーション
- [x] ステージング/本番で別のAPIキーを使用
- [x] APIキーの定期ローテーション
- [x] 機密データは埋め込み前に匿名化を検討

---

### 13.9 RAG用チャンキング戦略

#### 13.9.1 推奨チャンクサイズ

| ユースケース | チャンクサイズ | オーバーラップ | 備考 |
|-------------|:-------------:|:-------------:|------|
| 一般的なRAG | 256-512 tokens | 10-20% | バランス型 |
| 技術文書 | 512 tokens | 50-100 tokens | 文脈保持重視 |
| FAQ/QA | 128-256 tokens | 20-30% | 短文精度重視 |
| コード | 関数/クラス単位 | 文脈依存 | 構造ベース |

#### 13.9.2 チャンキング実装

```typescript
import { encode, decode } from "gpt-tokenizer";

interface Chunk {
  text: string;
  tokens: number;
  startIndex: number;
  endIndex: number;
}

function chunkByTokens(
  text: string,
  maxTokens = 512,
  overlapTokens = 50
): Chunk[] {
  const tokens = encode(text);
  const chunks: Chunk[] = [];

  let start = 0;
  while (start < tokens.length) {
    const end = Math.min(start + maxTokens, tokens.length);
    const chunkTokens = tokens.slice(start, end);

    chunks.push({
      text: decode(chunkTokens),
      tokens: chunkTokens.length,
      startIndex: start,
      endIndex: end
    });

    // オーバーラップを考慮して次の開始位置を決定
    start = end - overlapTokens;
    if (start >= tokens.length - overlapTokens) break;
  }

  return chunks;
}
```

---

### 13.10 pgvector/Supabase設定

#### 13.10.1 テーブル定義

```sql
-- pgvector拡張を有効化
CREATE EXTENSION IF NOT EXISTS vector;

-- ドキュメントテーブル
CREATE TABLE documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  embedding VECTOR(1536),  -- text-embedding-3-small
  metadata JSONB DEFAULT '{}',
  chunk_index INTEGER DEFAULT 0,
  source_file TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 類似検索用インデックス（HNSW推奨 - 高速）
CREATE INDEX idx_documents_embedding ON documents
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- メタデータ検索用インデックス
CREATE INDEX idx_documents_metadata ON documents USING gin (metadata);

-- 更新日時自動更新トリガー
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_updated_at
BEFORE UPDATE ON documents
FOR EACH ROW EXECUTE FUNCTION update_updated_at();
```

#### 13.10.2 類似検索関数

```sql
CREATE OR REPLACE FUNCTION match_documents(
  query_embedding VECTOR(1536),
  match_count INT DEFAULT 5,
  filter JSONB DEFAULT '{}'
)
RETURNS TABLE (
  id UUID,
  content TEXT,
  metadata JSONB,
  similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    d.id,
    d.content,
    d.metadata,
    1 - (d.embedding <=> query_embedding) AS similarity
  FROM documents d
  WHERE
    CASE
      WHEN filter = '{}' THEN TRUE
      ELSE d.metadata @> filter
    END
  ORDER BY d.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;
```

#### 13.10.3 Hybrid Search（ベクトル + 全文検索）

```sql
-- 全文検索用インデックス追加
ALTER TABLE documents ADD COLUMN fts tsvector
  GENERATED ALWAYS AS (to_tsvector('japanese', content)) STORED;
CREATE INDEX idx_documents_fts ON documents USING gin (fts);

-- Hybrid Search関数
CREATE OR REPLACE FUNCTION hybrid_search(
  query_text TEXT,
  query_embedding VECTOR(1536),
  match_count INT DEFAULT 5,
  vector_weight FLOAT DEFAULT 0.5,  -- ベクトル検索の重み
  fts_weight FLOAT DEFAULT 0.5      -- 全文検索の重み
)
RETURNS TABLE (
  id UUID,
  content TEXT,
  metadata JSONB,
  combined_score FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    d.id,
    d.content,
    d.metadata,
    (vector_weight * (1 - (d.embedding <=> query_embedding))) +
    (fts_weight * COALESCE(ts_rank(d.fts, plainto_tsquery('japanese', query_text)), 0))
    AS combined_score
  FROM documents d
  WHERE d.fts @@ plainto_tsquery('japanese', query_text)
     OR (1 - (d.embedding <=> query_embedding)) > 0.7
  ORDER BY combined_score DESC
  LIMIT match_count;
END;
$$;
```

---

### 13.11 本番運用ベストプラクティス

#### 13.11.1 コスト最適化

| 戦略 | 効果 | 実装難易度 |
|------|:----:|:----------:|
| Batch API使用 | 50%削減 | 低 |
| 次元削減（MRL） | ストレージ最大83%削減 | 低 |
| チャンク最適化 | トークン数削減 | 中 |
| キャッシング | API呼び出し削減 | 中 |
| 重複排除 | 不要な埋め込み削減 | 高 |

#### 13.11.2 品質向上

1. **適切なチャンクサイズ選定**
   - 小さすぎ: 文脈不足で精度低下
   - 大きすぎ: ノイズ増加で精度低下
   - 推奨: 256-512トークン + 10-20%オーバーラップ

2. **メタデータ活用**
   - カテゴリ、作成日時、ソースファイル、チャンクインデックス
   - フィルタリングで検索精度向上

3. **Hybrid Search導入**
   - ベクトル検索: 意味的類似性
   - 全文検索: キーワード一致
   - 両者の組み合わせで精度向上

#### 13.11.3 監視・ログ

```typescript
// 構造化ログ例
interface EmbeddingLog {
  timestamp: string;
  requestId: string;
  model: string;
  inputTokens: number;
  latencyMs: number;
  cost: number;
  success: boolean;
  error?: string;
}

async function embedWithLogging(text: string): Promise<number[]> {
  const startTime = Date.now();
  const requestId = crypto.randomUUID();

  try {
    const response = await openai.embeddings.create({
      model: "text-embedding-3-small",
      input: text
    });

    const log: EmbeddingLog = {
      timestamp: new Date().toISOString(),
      requestId,
      model: "text-embedding-3-small",
      inputTokens: response.usage.total_tokens,
      latencyMs: Date.now() - startTime,
      cost: response.usage.total_tokens * 0.00002 / 1000, // $0.02/M tokens
      success: true
    };
    console.log(JSON.stringify(log));

    return response.data[0].embedding;
  } catch (error: any) {
    const log: EmbeddingLog = {
      timestamp: new Date().toISOString(),
      requestId,
      model: "text-embedding-3-small",
      inputTokens: 0,
      latencyMs: Date.now() - startTime,
      cost: 0,
      success: false,
      error: error.message
    };
    console.error(JSON.stringify(log));
    throw error;
  }
}
```

---

### 13.12 PlantUML Studio学習コンテンツ管理への適用

#### 13.12.1 推奨アーキテクチャ

```
学習コンテンツ登録フロー:
┌─────────────┐    ┌───────────────┐    ┌──────────────┐
│ Markdown/   │ → │ チャンキング   │ → │ OpenAI       │
│ PDF Upload  │    │ (512 tokens)  │    │ Embedding    │
└─────────────┘    └───────────────┘    └──────────────┘
                                               │
                                               ▼
                                        ┌──────────────┐
                                        │ Supabase     │
                                        │ pgvector     │
                                        └──────────────┘

RAG検索フロー:
┌──────────┐    ┌───────────────┐    ┌──────────────┐
│ ユーザー │ → │ Query         │ → │ Hybrid       │
│ 質問     │    │ Embedding     │    │ Search       │
└──────────┘    └───────────────┘    └──────────────┘
                                            │
                                            ▼
                                     ┌──────────────┐
                                     │ 関連コンテン │
                                     │ ツ + LLM応答 │
                                     └──────────────┘
```

#### 13.12.2 機能マッピング

| 機能 | 実装 |
|------|------|
| LC-01 学習コンテンツを登録する | Markdown/PDF → チャンキング(512tok) → OpenAI Embedding → pgvector保存 |
| LC-02 学習コンテンツを管理する | CRUD + メタデータ管理 + カテゴリ分類 + Hybrid Search |

#### 13.12.3 技術選定サマリー

| 項目 | 選定 | 理由 |
|------|------|------|
| Embeddingモデル | text-embedding-3-small | コスト効率最高、十分な精度 |
| 次元数 | 1536 | デフォルト精度維持 |
| ベクトルDB | Supabase pgvector | Supabase統一アーキテクチャ |
| インデックス | HNSW | 高速検索（IVFFlatより推奨） |
| チャンクサイズ | 512 tokens | 技術文書向け |
| オーバーラップ | 50 tokens (10%) | 文脈保持 |
| 検索方式 | Hybrid Search | ベクトル + 全文検索 |

---

## 参考リンク

- [OpenRouter Documentation](https://openrouter.ai/docs)
- [OpenRouter Quickstart](https://openrouter.ai/docs/quickstart)
- [API Parameters](https://openrouter.ai/docs/api/reference/parameters)
- [Provider Routing](https://openrouter.ai/docs/features/provider-routing)
- [Prompt Caching](https://openrouter.ai/docs/features/prompt-caching)
- [Error Handling](https://openrouter.ai/docs/errors)
- [FAQ](https://openrouter.ai/docs/faq)
- [Models List](https://openrouter.ai/models)
- [Pricing](https://openrouter.ai/pricing)
- [TypeScript SDK](https://openrouter.ai/docs/sdks/typescript)
- [TypeScript SDK GitHub](https://github.com/OpenRouterTeam/typescript-sdk)
- [OpenRouter Examples](https://github.com/OpenRouterTeam/openrouter-examples)

### OpenAI Embedding
- [OpenAI Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
- [OpenAI Embeddings API Reference](https://platform.openai.com/docs/api-reference/embeddings)
- [OpenAI Batch API](https://platform.openai.com/docs/guides/batch)
- [OpenAI Rate Limits](https://platform.openai.com/docs/guides/rate-limits)
- [OpenAI Usage Tiers](https://platform.openai.com/docs/guides/rate-limits/usage-tiers)
- [How to Handle Rate Limits (OpenAI Cookbook)](https://cookbook.openai.com/examples/how_to_handle_rate_limits)
- [OpenAI Security & Privacy](https://openai.com/security-and-privacy/)
- [New Embedding Models Announcement](https://openai.com/index/new-embedding-models-and-api-updates/)
- [DataCamp: Exploring Text-Embedding-3](https://www.datacamp.com/tutorial/exploring-text-embedding-3-large-new-openai-embeddings)

### Vector Database
- [Supabase pgvector](https://supabase.com/docs/guides/ai/vector-columns)
- [pgvector GitHub](https://github.com/pgvector/pgvector)
- [Azure OpenAI Embeddings](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/embeddings)
