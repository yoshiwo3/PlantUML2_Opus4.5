# Instructions - UC 5-11 学習コンテンツ登録 シーケンス図

**作成日時**: 2025-12-22 10:14
**対象UC**: UC 5-11 学習コンテンツを登録する

---

## 目標

UC 5-11 学習コンテンツ登録のシーケンス図を作成する（Phase 2最後のシーケンス図）

## コンテキスト

### 参照ドキュメント

| ドキュメント | 参照箇所 |
|-------------|---------|
| 機能一覧表 | F-ADM-11: 学習コンテンツ登録 |
| クラス図 v1.8 | LearningService, EmbeddingService, ILearningContentRepository |
| 業務フロー図 | BF 3.10（エンドユーザー側）+ 3.11（管理機能概要） |

### 参加者

| 参加者 | 役割 |
|--------|------|
| 開発者 | 管理者権限を持つユーザー |
| Browser | Next.js Client |
| API Routes | /api/admin/learning-content |
| LearningService | コンテンツ登録・管理 |
| EmbeddingService | ベクトル生成（委譲） |
| OpenAI Embedding | text-embedding-3-small (直接接続) |
| ILearningContentRepository | データ永続化 |
| Supabase DB | learning_contents, content_chunks |

### 操作フロー（F-ADM-11）

1. 学習コンテンツ管理画面で「新規登録」をクリック
2. タイトル、カテゴリ、タグを入力
3. Markdown/PDFファイルをドラッグ＆ドロップ
4. 「登録」をクリック → バリデーション
5. インデックス作成（チャンク分割 + Embedding生成）
6. 完了通知（chunk_count, token_count表示）

### 技術仕様（TD-007準拠）

| 項目 | 仕様 |
|------|------|
| Embeddingモデル | text-embedding-3-small (OpenAI直接) |
| 次元数 | 1536 |
| チャンクサイズ | 512 tokens |
| ベクトルDB | Supabase pgvector |
| 接続 | OpenAI直接（OpenRouter経由ではない） |

### 適用するDP

- **DP-001（レジリエンス）**: OpenAI Embedding API呼び出し
  - timeout: 30秒（バッチ処理のため長め）
  - retry: 2回（exponential backoff）
  - fallback: エラー表示（Embeddingは必須のため処理中断）

### 入力データ（F-ADM-11）

| データ項目 | 型 | 必須 |
|-----------|-----|:----:|
| title | VARCHAR(200) | ✅ |
| category | VARCHAR(50) | ✅ |
| content_type | ENUM('puml', 'excalidraw', 'general') | ✅ |
| file | FILE (MD/PDF, max 10MB) | ✅ |
| tags | Array | ❌ |

### 出力データ

| データ項目 | 型 |
|-----------|-----|
| content_id | UUID |
| chunk_count | INTEGER |
| token_count | INTEGER |

### エラーケース

| エラーコード | 条件 |
|-------------|------|
| `FILE_TOO_LARGE` | ファイルサイズ超過 (>10MB) |
| `INVALID_FORMAT` | 非対応形式 (MD/PDF以外) |
| `DUPLICATE_TITLE` | タイトル重複 |
| OpenAI API 503 | Embedding API障害 |

---

## 実施内容

1. PlantUMLコード作成（13_1_Learning_Content_Register.puml）
2. Phase 1-B 視覚品質評価（PNG生成・レビュー）
3. Phase 1-A コード品質評価
4. Phase 2 ドキュメント統合（SVG生成・統合版追記）
5. active_context.md更新
6. SERENA Memory保存・Git commit

---

## 完了条件

- [ ] Phase 1-B 視覚品質: 85点以上
- [ ] Phase 1-A コード品質: 85点以上
- [ ] Phase 2 ドキュメント統合: 85点以上
- [ ] 統合版 §13 に追記完了
- [ ] active_context.md 進捗更新
- [ ] SERENA Memory保存
- [ ] Git commit完了
