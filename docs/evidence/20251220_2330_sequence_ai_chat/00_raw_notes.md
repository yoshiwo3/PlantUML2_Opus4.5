# Raw Notes: UC 4-2 AIチャット シーケンス図作成

## タイムライン

### 2025-12-20 23:30 - 作業開始

- Evidenceディレクトリ作成: `20251220_2330_sequence_ai_chat`
- instructions.md作成
- Todoリスト作成（7項目）

---

## 関連ドキュメント確認

### §7 AI Question-Start（ベースパターン）

- 7参加者: User, Browser, APIRoutes, AIService, PromptService, OpenRouterClient, OpenRouter
- SSEストリーミング対応
- エラーハンドリング: 401/403/429/500/503
- LL-001適用: else分岐での明示的activate

### 業務フロー図 §3.2

- UC 4-1, 4-2 を包含
- AIがコンテキスト分析 → 質問入力 → AI回答/提案 → 採用?（ループ）

### 機能一覧表 F-AI-02

- **目的別AIチャット**: 編集中の図表についてAIに相談
- **チャットモード**: レビュー、改善提案、コード説明、エラー対応
- **入力データ**: message (TEXT), context (Object)
- **特徴**: 会話継続（マルチターン）

### クラス図 AIService

```
class AIService <<service>> {
  -llmClient: OpenRouterClient
  -promptService: PromptService
  +questionStart(question, context?): AIResponse
  +generateCode(prompt, diagramType): AIResponse
  +suggestFix(error, code): AIResponse
  +checkTermConsistency(code, glossary): TermCheckResult
}
```

- イベント駆動: `ai.fix.suggested` イベント発行
- PromptService経由でプロンプト取得
- OpenRouterClient経由でLLM呼び出し

### TD-007 AI機能プロバイダー構成

- LLM: OpenRouter経由（統一API）
- Embedding: OpenAI直接接続（Phase 2）

---

## 設計メモ

### 参加者（Participants）

§7と同じ7参加者:
1. User (actor)
2. Browser (AIチャットパネル)
3. APIRoutes (/api/ai/chat)
4. AIService
5. PromptService
6. OpenRouterClient
7. OpenRouter API

### メッセージフロー

1. **AIチャットパネルを開く**: 既存会話があれば読み込み
2. **コンテキスト送信**: 現在の図表コード（context_code）を送信
3. **メッセージ入力・送信**: chat_mode付きで送信
4. **AI処理**: 会話履歴付きでプロンプト構築
5. **ストリーミングレスポンス**: SSE経由でチャンク送信
6. **結果表示**: 提案があれば適用ボタン表示
7. **会話継続**: ループ（追加質問）

### §7との差分

| 項目 | §7 AI Question-Start | §8 AIチャット |
|------|---------------------|---------------|
| エンドポイント | /api/ai/question-start | /api/ai/chat |
| context_code | オプション（新規時null） | **必須**（現在の図表） |
| conversation_id | null（新規） | 継続時に使用 |
| messages | 単一質問 | **履歴配列** |
| chat_mode | なし | レビュー/改善/説明/エラー |
| プロンプト | question_start | **ai_chat_{mode}** |

### alt/else状態追跡表（LL-025準拠）

| 参加者 | alt開始時 | エラー分岐終了時 | else分岐で必要 | else冒頭でactivate? |
|--------|:---------:|:---------------:|:--------------:|:------------------:|
| Browser | active | deactivated | active | ✅ 必要 |
| APIRoutes | active | deactivated | active | ✅ 必要 |
| AIService | active | deactivated | active | ✅ 必要 |
| OpenRouterClient | - | - | active | ✅ 必要 |
| OpenRouter | - | - | active | ✅ 必要 |

### エラーハンドリング

| HTTPステータス | エラーコード | 発生条件 | ユーザー向けメッセージ |
|:-------------:|-------------|---------|----------------------|
| 400 | VALIDATION_ERROR | メッセージが空 | 「メッセージを入力してください」 |
| 400 | CONTEXT_REQUIRED | context_codeがない | 「図表を開いてから使用してください」 |
| 401 | UNAUTHORIZED | 未ログイン | 「ログインしてください」 |
| 403 | AI_FEATURE_DISABLED | AI機能が無効 | 「AI機能は現在無効です」 |
| 429 | RATE_LIMITED | レート制限超過 | 「しばらく待ってから再試行してください」 |
| 500 | AI_PROVIDER_ERROR | OpenRouterエラー | 「AIサービスでエラーが発生しました」 |
| 503 | AI_SERVICE_UNAVAILABLE | プロバイダー障害 | 「AIサービスが一時的に利用できません」 |

---

## レビューログ

### Pass 1: 全体構造 ✅

- 参加者7名: User, Browser, APIRoutes, AIService, PromptService, OpenRouterClient, OpenRouter
- セパレーター3つ: AIチャットパネル開始、メッセージ送信、会話継続（オプション）
- alt/elseブロック: 外側（バリデーション4分岐 + 正常処理）、内側（OpenRouterエラー3分岐 + SSE成功）
- loopブロック: SSEチャンク送信
- note: context_code説明、chat_mode説明、提案適用説明

### Pass 2: アクティブバー ✅

- 外側altの各エラー分岐: APIRoutes→Browser順にdeactivate 正常
- 正常処理分岐: AIService→PromptService→OpenRouterClient→OpenRouter順にactivate 正常
- 内側altエラー分岐: OpenRouter→OpenRouterClient→AIService→APIRoutes→Browser順にdeactivate（カスケード）正常
- SSE成功分岐: loop中は全参加者active、完了後カスケードdeactivate 正常
- 会話継続セクション: Browser→APIRoutes再activate 正常
- **LL-025準拠**: ネストalt内のdeactivateカスケード正常

### Pass 3: メッセージラベル ✅

- エンドポイント: POST /api/ai/chat
- HTTPステータスコード: 400/401/403/429/500/503
- メソッド呼び出し: chat(), getPrompt("ai_chat_{mode}"), streamChat()
- SSEフォーマット: data: {delta}, data: [DONE], SSE: event: complete

### Pass 4: 最終確認 ✅

- skinparam: 背景色、境界線色適用済み
- note配置: 適切な位置に配置
- タイトル: "UC 4-2 AIチャット シーケンス図"
- 日本語表示: 正常

**レビュー結果: 合格** - 全4パス問題なし

---

## 発見した問題・修正

### 初回エラー（line 67）

**症状**: PlantUMLエラー "Some diagram description contains errors"
**原因**: else分岐の冒頭で`activate Browser`を記述（LL-001違反）
**修正**: else分岐では明示的なactivateを削除し、alt開始時点の状態が復元されることを利用

---

## メモ

- Context7でPlantUMLシーケンス図仕様を確認後にコード作成
- §7 AI Question-Startをベースに会話継続（conversation_id, messages配列）を追加
- chat_mode別プロンプト: ai_chat_review, ai_chat_improve, ai_chat_explain, ai_chat_error
- 400エラーに CONTEXT_REQUIRED を追加（§7になかったエラー）
