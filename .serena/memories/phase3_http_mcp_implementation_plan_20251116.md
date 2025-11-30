# Phase 3: HTTP MCP実装 詳細計画

**策定日**: 2025-11-16
**ステータス**: 準備完了、実装開始可能

---

## 📋 概要

Phase 3では、MCP over HTTP仕様（2025-03-26）に準拠した、純粋なHTTP MCPサーバーを実装します。Phase 2で完了したstdio-http-proxy（stdio MCPサーバーをHTTP経由で利用可能にするプロキシ）とは異なり、Phase 3ではHTTP通信を直接処理するネイティブなMCPサーバーを構築します。

### 目標

- **MCP仕様準拠**: Streamable HTTP transport（2025-03-26）を完全実装
- **型安全**: TypeScript + Zod によるスキーマ検証
- **包括的テスト**: カバレッジ90%以上、正常系・異常系完備
- **本番環境対応**: Cloud Runデプロイ可能、エラーハンドリング強化

---

## 🎯 実装スコープ

### 実装する機能

1. **Streamable HTTP Server Transport**
   - `@modelcontextprotocol/sdk` v1.21.0以降の`StreamableHTTPServerTransport`を使用
   - セッション管理（ステートフル/ステートレス両対応）
   - DNS Rebinding Protection対応

2. **3つのツール実装**
   - `validate_plantuml`: PlantUMLコード検証（SVG/PNG生成）
   - `encode_plantuml`: PlantUMLコードエンコード
   - `decode_plantuml`: エンコードされたコードのデコード

3. **エラーハンドリング**
   - JSON-RPCエラーフォーマット準拠
   - タイムアウト処理
   - リトライロジック（クライアント側）

4. **セキュリティ**
   - CORS設定（適切なオリジン許可）
   - DNS Rebinding Protection
   - 入力検証（Zodスキーマ）

### 実装しない機能（将来拡張）

- ❌ Server-to-Client Notifications（Phase 4以降）
- ❌ SSE Transport（Deprecated、後方互換性不要）
- ❌ WebSocket Transport（Phase 4以降）
- ❌ リソース・プロンプト機能（現時点で不要）

---

## 📚 必要なライブラリ

### 本番依存関係

| ライブラリ | バージョン | 用途 |
|----------|----------|------|
| `@modelcontextprotocol/sdk` | ^1.21.0 | MCP TypeScript SDK（Server/Client） |
| `express` | ^4.21.2 | HTTPサーバーフレームワーク |
| `express-async-errors` | ^3.1.1 | 非同期エラーハンドリング自動化 |
| `cors` | ^2.8.5 | CORSミドルウェア |
| `zod` | ^3.24.1 | スキーマ検証（入力/出力） |
| `plantuml-encoder` | ^1.4.0 | PlantUMLエンコード/デコード |

### 開発依存関係

| ライブラリ | バージョン | 用途 |
|----------|----------|------|
| `typescript` | ^5.9.3 | TypeScriptコンパイラ |
| `tsx` | ^4.20.6 | TypeScript実行環境 |
| `@types/express` | ^5.0.0 | Express型定義 |
| `@types/cors` | ^2.8.17 | CORS型定義 |
| `@types/node` | ^24.10.0 | Node.js型定義 |
| `axios` | ^1.13.2 | HTTPクライアント（テスト用） |
| `c8` | ^10.1.3 | カバレッジ計測 |

**既存のpackage.json（stdio-http-proxy）との互換性**:
- ✅ すべて既存依存関係と互換性あり
- ✅ 追加必要: `zod`, `plantuml-encoder`

---

## 🧪 包括的テスト戦略

### テストカバレッジ目標

- **全体カバレッジ**: 90%以上
- **正常系**: 全3ツール（validate, encode, decode）
- **異常系**: タイムアウト、不正な入力、サーバーエラー
- **統合テスト**: Express + MCP SDK連携

### テストケース分類

#### 1. 正常系テスト（Success Cases）

| テストケース | 対象ツール | 検証内容 |
|------------|----------|---------|
| PlantUML検証成功 | `validate_plantuml` | 有効なコード → SVG URL生成 |
| エンコード成功 | `encode_plantuml` | PlantUMLコード → エンコード文字列 |
| デコード成功 | `decode_plantuml` | エンコード文字列 → PlantUMLコード |
| ラウンドトリップ | `encode` + `decode` | 元のコードと一致 |

#### 2. 異常系テスト（Error Cases）

| テストケース | 対象ツール | 検証内容 |
|------------|----------|---------|
| 構文エラー検出 | `validate_plantuml` | 不正なPlantUML → エラーレスポンス |
| 空入力検証 | 全ツール | 空文字列 → バリデーションエラー |
| 不正なフォーマット | `validate_plantuml` | 未対応フォーマット → エラー |
| タイムアウト | 全ツール | 長時間処理 → タイムアウトエラー |

#### 3. HTTPトランスポートテスト

| テストケース | 検証内容 |
|------------|---------|
| ヘルスチェック | `GET /` → サーバー情報取得 |
| JSON-RPCフォーマット | リクエスト/レスポンス形式準拠 |
| セッション管理 | ステートフル/ステートレス両対応 |
| CORSヘッダー | 適切なOrigin許可 |
| エラーレスポンス | JSON-RPCエラー形式準拠 |

#### 4. 統合テスト（Integration Tests）

- **サーバー起動/終了**: クリーンアップ確認
- **動的ポート割り当て**: `port=0`でOS自動割り当て
- **並行リクエスト**: 複数クライアント同時実行

### テスト実装パターン（参考）

```typescript
// 既存のstdio-http-proxyテストを参考に実装
// docs/poc/03_plantuml_mcp_poc/project/stdio-http-proxy/src/__tests__/proxy-server.test.ts

import { describe, it, before, after } from 'node:test';
import assert from 'node:assert';
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';
import axios from 'axios';

// グローバルbeforeフックでサーバー起動
// 動的ポート割り当て（port=0）
// テスト後にクリーンアップ（globalServer.stop()）
```

### カバレッジ計測

```bash
# カバレッジ計測コマンド
pnpm test:coverage

# 目標: 90%以上（lines, statements, functions, branches）
```

---

## 🏗️ アーキテクチャ

### ディレクトリ構成（案）

```
docs/poc/03_plantuml_mcp_poc/project/http-mcp-native/
├── src/
│   ├── index.ts                      # エントリポイント
│   ├── server.ts                     # MCP Server実装
│   ├── transport.ts                  # HTTP Transport設定
│   ├── tools/
│   │   ├── validate.ts               # validate_plantuml実装
│   │   ├── encode.ts                 # encode_plantuml実装
│   │   └── decode.ts                 # decode_plantuml実装
│   ├── schemas/
│   │   └── plantuml.ts               # Zodスキーマ定義
│   ├── utils/
│   │   └── plantuml-api.ts           # PlantUML公式API呼び出し
│   └── __tests__/
│       ├── server.test.ts            # サーバーテスト
│       ├── validate.test.ts          # validate_plantumlテスト
│       ├── encode.test.ts            # encode_plantumlテスト
│       └── decode.test.ts            # decode_plantumlテスト
├── dist/                             # ビルド成果物
├── package.json
├── tsconfig.json
├── Dockerfile                        # Cloud Runデプロイ用
└── cloudbuild.yaml                   # Cloud Build設定
```

### 実装例（TypeScript）

```typescript
// src/server.ts
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';
import express from 'express';
import cors from 'cors';
import { z } from 'zod';

const app = express();
app.use(express.json());
app.use(cors());

const server = new McpServer({
  name: 'plantuml-mcp-native',
  version: '1.0.0'
});

// validate_plantuml ツール登録
server.registerTool(
  'validate_plantuml',
  {
    title: 'PlantUML Validator',
    description: 'Validate PlantUML code and generate diagram',
    inputSchema: {
      code: z.string().min(1),
      format: z.enum(['svg', 'png']).default('svg')
    },
    outputSchema: {
      url: z.string().url(),
      validation_failed: z.boolean()
    }
  },
  async ({ code, format }) => {
    // PlantUML公式APIを呼び出し
    const url = await generatePlantUMLUrl(code, format);
    return {
      content: [{ type: 'text', text: JSON.stringify({ url, validation_failed: false }) }],
      structuredContent: { url, validation_failed: false }
    };
  }
);

// Stateless mode（セッション管理なし）
app.post('/mcp', async (req, res) => {
  const transport = new StreamableHTTPServerTransport({
    sessionIdGenerator: undefined,
    enableJsonResponse: true,
    enableDnsRebindingProtection: true,
    allowedHosts: ['127.0.0.1', 'localhost']
  });

  res.on('close', () => transport.close());
  await server.connect(transport);
  await transport.handleRequest(req, res, req.body);
});

const port = parseInt(process.env.PORT || '3000');
app.listen(port, () => {
  console.log(`HTTP MCP Server running on http://localhost:${port}/mcp`);
});
```

---

## 📦 既存プロジェクトとの関係

### Phase 1: stdio MCP Server

- **パス**: `docs/poc/03_plantuml_mcp_poc/project/stdio-mcp-server/`
- **通信**: stdio（標準入出力）
- **用途**: ローカルプロセス通信、Claude Code連携
- **ステータス**: ✅ 完了（2025-11-03）

### Phase 2: HTTP MCP Server（http-mcp-server）

- **パス**: `docs/poc/03_plantuml_mcp_poc/project/http-mcp-server/`
- **通信**: HTTP（Streamable HTTP transport）
- **用途**: Cloud Run デプロイ、外部アクセス
- **ステータス**: ✅ 完了（2025-11-14）
- **Service URL**: https://plantuml-mcp-http-server-491539021035.asia-northeast1.run.app

### Phase 2: stdio-http-proxy

- **パス**: `docs/poc/03_plantuml_mcp_poc/project/stdio-http-proxy/`
- **通信**: HTTP → stdio（プロキシ）
- **用途**: stdio MCPサーバーをHTTP経由で利用可能に
- **ステータス**: ✅ 完了（2025-11-16、v1.0.1）
- **Service URL**: https://stdio-http-proxy-491539021035.asia-northeast1.run.app
- **特徴**: パラメータ名変換（plantuml_code → code）

### Phase 3: HTTP MCP Native（本Phase）

- **パス**: `docs/poc/03_plantuml_mcp_poc/project/http-mcp-native/` （新規作成）
- **通信**: HTTP（ネイティブ実装、プロキシなし）
- **用途**: MCP over HTTP仕様の完全実装、学習目的
- **ステータス**: 🚧 準備完了、実装開始可能
- **目標**: 
  - Phase 2の http-mcp-server と同等機能
  - より明確なコード構成（tools/, schemas/, utils/分離）
  - 包括的テスト（カバレッジ90%以上）
  - Cloud Runデプロイ対応

---

## 🚀 実装ステップ（見積: 2.5時間）

### ステップ1: プロジェクト初期化（15分）

- [ ] ディレクトリ作成: `http-mcp-native/`
- [ ] package.json作成: stdio-http-proxyベース、zod/plantuml-encoder追加
- [ ] tsconfig.json作成
- [ ] 基本ファイル構成（src/, dist/, __tests__/）

### ステップ2: Zodスキーマ定義（15分）

- [ ] `schemas/plantuml.ts`: 入力/出力スキーマ
- [ ] validate_plantuml: `{ code: string, format?: 'svg'|'png' }`
- [ ] encode_plantuml: `{ code: string }`
- [ ] decode_plantuml: `{ encoded: string }`

### ステップ3: ツール実装（60分）

- [ ] `tools/validate.ts`: PlantUML公式API呼び出し
- [ ] `tools/encode.ts`: plantuml-encoder使用
- [ ] `tools/decode.ts`: plantuml-encoder使用
- [ ] `utils/plantuml-api.ts`: 共通ユーティリティ

### ステップ4: HTTPサーバー実装（30分）

- [ ] `transport.ts`: StreamableHTTPServerTransport設定
- [ ] `server.ts`: McpServer + 3ツール登録
- [ ] `index.ts`: Express設定、エントリポイント
- [ ] CORS設定、DNS Rebinding Protection

### ステップ5: テスト作成（30分）

- [ ] `__tests__/server.test.ts`: 統合テスト
- [ ] `__tests__/validate.test.ts`: validate_plantumlテスト
- [ ] `__tests__/encode.test.ts`: encode_plantumlテスト
- [ ] `__tests__/decode.test.ts`: decode_plantumlテスト
- [ ] 動的ポート割り当て、before/afterフック

### ステップ6: ローカル動作確認（15分）

- [ ] `pnpm build`
- [ ] `pnpm dev` → サーバー起動確認
- [ ] curl/Postman で全3ツール動作確認
- [ ] `pnpm test:coverage` → カバレッジ90%以上

### ステップ7: Cloud Runデプロイ（15分）

- [ ] Dockerfile作成（Phase 2参考）
- [ ] cloudbuild.yaml作成
- [ ] Cloud Build実行
- [ ] Cloud Runデプロイ確認
- [ ] 外部URLで全3ツール動作確認

---

## 🔍 参考リソース

### MCP仕様

- **公式仕様**: https://modelcontextprotocol.io/specification/2025-03-26/basic/transports/
- **Streamable HTTP Transport**: https://spec.modelcontextprotocol.io/specification/2025-03-26/basic/transports/
- **TypeScript SDK**: https://github.com/modelcontextprotocol/typescript-sdk

### 既存実装（参考）

- **Phase 1（stdio）**: `docs/poc/03_plantuml_mcp_poc/project/stdio-mcp-server/`
- **Phase 2（HTTP）**: `docs/poc/03_plantuml_mcp_poc/project/http-mcp-server/`
- **Phase 2（proxy）**: `docs/poc/03_plantuml_mcp_poc/project/stdio-http-proxy/`
- **テスト例**: `stdio-http-proxy/src/__tests__/proxy-server.test.ts`

### 技術ドキュメント

- **Node.js**: https://nodejs.org/api/
- **Express**: https://expressjs.com/en/guide/error-handling.html
- **Zod**: https://zod.dev/
- **PlantUML公式API**: https://www.plantuml.com/plantuml/uml/

---

## 📝 次のステップ

### 即座に実施可能

1. **ディレクトリ作成**: `http-mcp-native/`
2. **package.json作成**: stdio-http-proxyベース
3. **スキーマ定義**: Zodスキーマ（15分）

### Phase 3本格実装（見積: 2.5時間）

- 上記「実装ステップ」に従って実装
- Evidence 3点セット作成
- doc-reviewerレビュー（目標85/100以上）

### Cloud Runデプロイ後

- .mcp.json更新（http-mcp-native接続情報追加）
- Memory Bank更新（active_context.md、technical_decisions.md）
- 引継ぎ資料作成

---

**策定日**: 2025-11-16
**次回更新予定**: Phase 3実装完了時
