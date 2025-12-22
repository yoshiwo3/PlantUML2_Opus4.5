# 00_raw_notes.md - UC 5-11 学習コンテンツ登録

**作成開始**: 2025-12-22 10:14

---

## 作業ログ

### 10:14 作業開始

- Evidenceディレクトリ作成
- 参照ドキュメント確認:
  - F-ADM-11: 入力/出力データ、操作フロー
  - クラス図: LearningService.register(), EmbeddingService.generateBatchEmbedding()
  - TD-007: OpenAI直接接続

### クラス図整合性確認

| メソッド | クラス図v1.8 | 状態 |
|---------|-------------|:----:|
| LearningService.register(dto: RegisterContentDto): LearningContent | §Phase 2: 学習コンテンツサービス | ✅ |
| EmbeddingService.generateEmbedding(text: String): Vector | §Phase 2 | ✅ |
| EmbeddingService.generateBatchEmbedding(texts: String[]): Vector[] | §Phase 2 | ✅ |
| ILearningContentRepository.save(content: LearningContent): void | §Repositories | ✅ |
| OpenAIEmbeddingClient | §外部クライアント | ✅ |

### 設計パターン

- **DP-001（レジリエンス）**: OpenAI Embedding API
  - timeout: 30秒（バッチ処理）
  - retry: 2回
  - fallback: エラー表示（登録失敗）

### LL準拠確認

- LL-001: else分岐のアクティブバー継承
- LL-015: 権限チェック明示
- LL-006: note内の改行配慮

---

## 発見事項

（作業中に追記）

---

## エラー・修正履歴

（作業中に追記）
