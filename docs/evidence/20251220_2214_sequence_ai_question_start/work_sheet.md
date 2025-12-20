# UC 4-1 AI Question-Start シーケンス図 作業結果

**作成日**: 2025-12-20
**対象UC**: UC 4-1 AI Question-Startで図表を生成する
**ステータス**: 完了

---

## 成果物

| ファイル | 説明 | 状態 |
|---------|------|:----:|
| `ai_question_start.puml` | PlantUMLソースコード | ✅ 完了 |
| `ai_question_start.review.json` | レビューログ（completed） | ✅ 完了 |
| `PlantUML_Studio_Sequence_AI_Question_Start.png` | レビュー用PNG | ✅ 完了 |
| `7_1_AI_Question_Start.svg` | 正式版SVG | ✅ 完了 |

### 正式版保存先

- **SVG**: `docs/proposals/diagrams/08_sequence/7_1_AI_Question_Start.svg`
- **ドキュメント**: `docs/proposals/08_シーケンス図_20251214.md` §7

---

## 技術仕様

### 参加者（7名）

| 参加者 | 役割 |
|--------|------|
| User | エンドユーザー |
| Browser | ブラウザ（Question-Start UI） |
| APIRoutes | API Routes（/api/ai/generate） |
| AIService | AIService |
| OpenRouterClient | OpenRouterClient |
| OpenRouter | OpenRouter（外部API） |
| UsageRepo | IUsageLogRepository |

### 外部システム連携

- **OpenRouter API**: SSEストリーミングによるリアルタイム図表生成
- **TD-007準拠**: LLMはOpenRouter経由

### エラーハンドリング

| HTTPステータス | エラー種別 | 対応 |
|:-------------:|-----------|----- |
| 401 | 認証エラー | ログイン画面へリダイレクト |
| 403 | 権限エラー | 権限不足メッセージ表示 |
| 429 | レート制限 | リトライ待機メッセージ |
| 500 | Provider Error | 「AIサービス一時障害」表示 |
| 503 | OpenRouter障害 | 「サービス一時利用不可」表示 |

---

## レビュー履歴

### 初回レビュー（22:20）

- 4パスレビュー全合格
- SVG生成（初回）

### 採番ルール指摘（22:35）

- ユーザーから採番ルール違反の指摘
- `PlantUML_Studio_Sequence_AI_Question_Start.svg` → `7_1_AI_Question_Start.svg` にリネーム

### アクティブバー不足指摘（22:44）

- ユーザーからスクリーンショットで指摘
- `data: [DONE]`後のOpenRouterClient, AIServiceのアクティブバー欠落
- **根本原因**: LL-001の適用漏れ（else分岐は前分岐のdeactivateを継承しない）

### 修正後レビュー（22:48）

- LL-001適用版で再生成
- 4パスレビュー再実施、全合格
- SVG再生成完了

---

## 発見した知見

### LL-025: ネストaltでのactivate漏れ防止

**問題**: ネストしたalt/else構造で、else分岐の活動する参加者のactivateが漏れる

**根本原因**:
1. LL-001の「知識」はあったが「適用」しなかった
2. 複雑なalt構造（3重ネスト）で追跡が困難
3. ストリーミングloop内は正常に見えたため、loop終了後の確認が甘くなった

**回避策**: alt/elseブロックを書く前に状態追跡表を作成

```markdown
| 参加者 | alt開始時 | alt分岐終了時 | else分岐で必要 | else冒頭でactivate? |
|--------|:---------:|:------------:|:--------------:|:------------------:|
| APIRoutes | active | deactivated | active | ✅ 必要 |
```

---

## ドキュメント更新

| ドキュメント | 更新内容 |
|-------------|---------|
| `Activation_Bar_Knowledge_Base.md` | LL-025追加（25項目に） |
| `Sequence_Diagram_Authoring_Guide.md` | §7「alt/else状態追跡チェックリスト」追加 |
| `PlantUML_Development_Constitution.md` | v4.7: LL-025参照追加（関連ドキュメント表・§3.2） |

---

## 進捗更新

**シーケンス図進捗**: 7/14 → **8/14**
- **MVP**: 7/8 → **8/8完了（100%）** ✅
- Phase 2: 0/6

---

## 次のアクション

1. Phase 2 シーケンス図 6本
   - UC 4-2 AIチャット
   - UC 3-10 学習コンテンツ検索
   - UC 5-1 ユーザー管理
   - UC 5-2 LLMモデル登録
   - UC 5-7 LLM使用量監視
   - UC 5-11 学習コンテンツ登録

---

## 作業統計

| 項目 | 値 |
|------|-----|
| 作業開始 | 22:14 |
| 作業完了 | 23:00 |
| 所要時間 | 約46分 |
| レビューサイクル | 2回 |
| 発見知見 | LL-025（1件） |
