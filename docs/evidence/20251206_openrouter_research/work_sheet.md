# OpenRouter LLM制御仕様調査 - Work Sheet

**作成日**: 2025-12-06
**作業者**: Claude
**目的**: PlantUML Studio LLM管理機能の設計根拠を明確化

---

## 1. 調査概要

### 調査目的
OpenRouter APIでLLMをどこまで制御できるかを明確化し、PlantUML StudioのLLM管理機能の設計に反映する。

### 調査方法
- WebSearch: OpenRouter API仕様、ベストプラクティス、エラーハンドリング
- WebFetch: 公式ドキュメント、FAQ

### 調査ソース
| ソース | URL |
|--------|-----|
| OpenRouter Docs | https://openrouter.ai/docs |
| API Parameters | https://openrouter.ai/docs/api/reference/parameters |
| Provider Routing | https://openrouter.ai/docs/features/provider-routing |
| Prompt Caching | https://openrouter.ai/docs/features/prompt-caching |
| Error Handling | https://openrouter.ai/docs/errors |
| FAQ | https://openrouter.ai/docs/faq |

---

## 2. 主要な発見

### 2.1 OpenRouterで制御可能な範囲

| カテゴリ | 制御可能 | 方法 |
|---------|:--------:|------|
| サンプリングパラメータ | ✅ | リクエストボディに含める |
| プロバイダー選択 | ✅ | `provider`オブジェクト |
| フォールバック | ✅ | `models`配列 + `route: "fallback"` |
| 使用量取得 | ✅ | `/api/v1/key`エンドポイント |
| モデル一覧取得 | ✅ | `/api/v1/models`エンドポイント |
| プロンプトキャッシング | ✅ | 自動（一部プロバイダーは明示的設定要） |

### 2.2 アプリ側で実装が必要な機能

| 機能 | 理由 |
|------|------|
| プロンプトテンプレート管理 | OpenRouterは保存機能なし |
| ワークフロー定義 | アプリ固有の処理パイプライン |
| 設定の永続化 | モデル設定、パラメータをDB保存 |
| コスト可視化 | ダッシュボード表示 |

### 2.3 フォールバック戦略

**OpenRouterのデフォルト動作:**
1. 過去30秒に障害がなかったプロバイダーを優先
2. 安定プロバイダーの中から価格の逆二乗で重み付け選択
3. 残りをフォールバックとして使用

**カスタマイズ可能:**
- `provider.order`: プロバイダー優先順位指定
- `provider.allow_fallbacks`: フォールバック許可/禁止
- `models`配列: モデルレベルのフォールバックチェーン

### 2.4 コスト最適化

| 手法 | 効果 |
|------|------|
| `:floor`バリアント | 最安プロバイダー自動選択 |
| プロンプトキャッシング | **75%コスト削減**（Cache Read: 0.25x） |
| 使用量監視 | 予算超過防止 |

---

## 3. LLM管理機能への反映

### 3.1 現在の機能一覧（修正前）

| # | 機能名 | MVP |
|:-:|--------|:---:|
| LM-01 | LLMモデルを登録する | ✅ |
| LM-02 | LLMモデルを切り替える | ✅ |
| LM-03 | LLMプロンプトを管理する | ✅ |
| LM-04 | LLMパラメータを設定する | ✅ |
| LM-05 | LLMワークフローを定義する | ✅ |
| LM-06 | LLM使用量を監視する | ✅ |
| LM-07 | LLMフォールバックを設定する | ✅ |

### 3.2 調査結果に基づく再評価

| # | 機能名 | 実装場所 | 必要性 |
|:-:|--------|---------|:------:|
| LM-01 | LLMモデルを登録する | DB（モデルID、名前、デフォルトパラメータ） | **必須** |
| LM-02 | LLMモデルを切り替える | DB更新 → リクエスト時適用 | **必須** |
| LM-03 | LLMプロンプトを管理する | DB（テンプレートCRUD） | **必須** |
| LM-04 | LLMパラメータを設定する | DB → リクエスト時付与 | **必須** |
| LM-05 | LLMワークフローを定義する | アプリロジック | 要検討 |
| LM-06 | LLM使用量を監視する | OpenRouter API + 可視化 | **必須** |
| LM-07 | LLMフォールバックを設定する | DB → `provider`オブジェクト生成 | **必須** |

### 3.3 LM-05（ワークフロー）の検討

**PlantUML Studioで想定されるワークフロー:**
1. 構文チェック → エラー時AI修正提案
2. 用語一貫性チェック（保存時自動）
3. AI Question-Start（質問→テンプレート提案→生成）

**実装方針:**
- MVPではハードコード（固定パイプライン）
- Phase 2以降でUI設定可能に

---

## 4. 技術的決定事項

### TD-007: OpenRouter LLM制御方針（案）

| 項目 | 決定 |
|------|------|
| **LLMプロバイダー** | OpenRouter（統一API） |
| **Embeddingプロバイダー** | OpenAI（text-embedding-3-small） |
| **フォールバック** | `provider`オブジェクト + `models`配列で実現 |
| **プロンプト管理** | アプリ側DB保存 |
| **パラメータ管理** | アプリ側DB保存 → リクエスト時付与 |
| **コスト最適化** | プロンプトキャッシング + `:floor`バリアント |
| **使用量監視** | OpenRouter API + ダッシュボード表示 |

---

## 5. OpenAI Embedding詳細仕様

### 5.1 調査結果サマリー

| 項目 | 結論 |
|------|------|
| **OpenRouter Embedding** | ❌ 専用APIなし（直接OpenAI推奨） |
| **推奨プロバイダー** | OpenAI（text-embedding-3-small） |
| **価格** | $0.02/M（Batch: $0.01/M、50%オフ） |
| **次元数** | 1536（MRLで256まで削減可能） |
| **最大入力** | 8,191 tokens/テキスト、2,048要素/リクエスト |

### 5.2 レート制限（Usage Tier別）

| Tier | 条件 | RPM | TPM |
|:----:|------|:---:|:---:|
| Free | - | 3 | 制限あり |
| Tier 1 | $5+ | 500 | 1,000,000 |
| Tier 3 | $100+ | 1,000 | 2,000,000 |
| Tier 5 | $1,000+ | 10,000 | 10,000,000 |

### 5.3 セキュリティ・データプライバシー

| 項目 | ポリシー |
|------|---------|
| データ保持 | 最大30日（不正利用検出目的） |
| 学習利用 | ❌ API経由データは学習に使用しない |
| Zero Data Retention | ✅ Embeddings APIは申請可能 |
| 暗号化 | AES-256（保存）、TLS 1.2+（転送） |
| コンプライアンス | SOC 2 Type 2、GDPR、CCPA |

### 5.4 ベストプラクティス

| カテゴリ | 推奨事項 |
|---------|---------|
| **コスト** | Batch API（50%削減）、MRL次元削減（83%ストレージ削減） |
| **品質** | 512トークン+10%オーバーラップ、Hybrid Search |
| **信頼性** | 指数バックオフ（Tenacity）、retry-afterヘッダー参照 |
| **セキュリティ** | サーバーサイドのみAPI呼び出し、環境変数管理 |

### 5.5 PlantUML Studio学習コンテンツへの適用

| 機能 | 実装方法 |
|------|---------|
| LC-01 学習コンテンツを登録する | Markdown/PDF → チャンキング(512tok) → OpenAI Embedding → pgvector |
| LC-02 学習コンテンツを管理する | CRUD + メタデータ + カテゴリ分類 + Hybrid Search |

### 5.6 技術選定

| 項目 | 選定 | 理由 |
|------|------|------|
| Embeddingモデル | text-embedding-3-small | コスト効率最高、MTEB 62.3% |
| 次元数 | 1536 | デフォルト精度維持 |
| ベクトルDB | Supabase pgvector | Supabase統一アーキテクチャ |
| インデックス | HNSW | 高速検索（IVFFlatより推奨） |
| チャンクサイズ | 512 tokens | 技術文書向け |
| オーバーラップ | 50 tokens (10%) | 文脈保持 |
| 検索方式 | Hybrid Search | ベクトル + 全文検索 |

---

## 6. 完了したアクション

1. [x] TD-007として技術決定を記録（LLM: OpenRouter, Embedding: OpenAI）✅ 2025-12-07
2. [x] LLM管理機能一覧の最終確定 ✅ 2025-12-07（llm_management_feature_design.md）
3. [x] ユースケース図の更新（5. 管理機能）✅ 2025-12-07
   - UC 5-1〜5-5 → 5-1〜5-13に拡張（+8件）
   - UC総数: 24件 → 32件
   - 5-A ユーザー管理、5-B LLM管理、5-C Embedding管理、5-D 学習コンテンツ管理、5-E システム設定

## 7. 残作業（Phase 2）

1. [ ] 業務フロー3.10（管理機能フロー）の作成

---

## 8. 参考資料

- 詳細調査レポート: `openrouter_llm_control_specification.md`
  - セクション1-11: LLM制御仕様
  - セクション12: LLM接続仕様
  - セクション13: Embedding API仕様
- LLM管理機能設計書: `llm_management_feature_design.md`
  - LLM管理機能（LM-01〜LM-07）
  - Embedding管理機能（EM-01〜EM-02）
  - 学習コンテンツ管理機能（LC-01〜LC-02）
