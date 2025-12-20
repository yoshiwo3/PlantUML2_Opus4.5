# UC 4-1 AI Question-Start シーケンス図 作業ログ

**作成日**: 2025-12-20
**対象UC**: UC 4-1 AI Question-Startで図表を生成する

---

## タイムライン

### 22:14 - 作業開始
- Evidence ディレクトリ作成
- 関連ドキュメント確認（業務フロー図3.2, 機能一覧表F-AI-01, クラス図AIService）

### 22:19 - 初版作成
- ai_question_start.puml 作成
- PNG生成（-Review）

### 22:20 - 4パスレビュー実施（初回）
- Pass 1 Structure: ✅
- Pass 2 Connections: ✅
- Pass 3 Content: ✅
- Pass 4 Style: ✅
- **結果**: completed

### 22:25 - SVG生成（初回）
- `PlantUML_Studio_Sequence_AI_Question_Start.svg` 生成
- ドキュメントに§7として追加

### 22:35 - 採番ルール違反指摘
- ユーザーから採番ルール確認の指摘
- SVGを `7_1_AI_Question_Start.svg` にリネーム

### 22:44 - アクティブバー不足指摘 ⚠️
- ユーザーからスクリーンショットで指摘
- `data: [DONE]`後のOpenRouterClient, AIServiceのアクティブバーが欠落

---

## 誤り分析（LL-025候補）

### 問題
`else 正常レスポンス`ブランチで、ストリーミング処理後のアクティブバーが表示されない。

### 直接原因
```plantuml
alt 500 Provider Error
    deactivate OpenRouterClient  ' ← alt分岐でdeactivate
    deactivate AIService
    deactivate APIRoutes
else 正常レスポンス
    activate OpenRouter          ' ← OpenRouterのみactivate
    ' OpenRouterClient, AIService, APIRoutesのactivateが不足
```

### 根本原因
1. **LL-001の適用漏れ**: 「else分岐は前分岐のdeactivateを継承しない - 明示的にactivateが必要」を作成時に適用しなかった
2. **レビュー不足**: 初回4パスレビューでストリーミング後のアクティブバー状態を十分確認しなかった
3. **複雑なalt構造**: 3重のネストalt（401/403 → 正常処理 → 500/正常レスポンス）で追跡が困難

### なぜ見逃したか
- ストリーミングloop内は正常に見えた
- loop終了後の`data: [DONE]`以降の確認が甘かった
- 「activate OpenRouter」を追加したことで満足してしまった

### 修正内容
```plantuml
else 正常レスポンス（ストリーミング）
    ' LL-001: else分岐は前分岐のdeactivateを継承しない - 明示的にactivate
    activate OpenRouterClient  ' 追加
    activate AIService         ' 追加
    activate APIRoutes         ' 追加
    activate OpenRouter
```

### 教訓（LL-025提案）
**LL-025: ネストaltでのactivate漏れ防止**

altブロックがネストしている場合、else分岐の開始時点で「この分岐で活動する全参加者」を列挙し、明示的にactivateすること。

**チェック方法**:
1. else分岐で処理を行う参加者をリストアップ
2. 前のalt分岐でdeactivateされている参加者を特定
3. 重複があればelse分岐冒頭でactivateを追加

---

## 修正後レビュー

### 22:46 - PNG再生成
- LL-001適用版で再生成

### 22:48 - 4パスレビュー実施（2回目）
- Pass 1 Structure: ✅
- Pass 2 Connections: ✅
- Pass 3 Content: ✅
- Pass 4 Style: ✅
- **確認ポイント**:
  - `data: [DONE]`後: OpenRouterClientにアクティブバー ✅
  - `使用量計算`: OpenRouterClientにアクティブバー ✅
  - `UsageLog記録`: AIServiceにアクティブバー ✅

### 22:49 - SVG再生成
- `7_1_AI_Question_Start.svg` 更新

---

## 成果物

| ファイル | 状態 |
|---------|------|
| `ai_question_start.puml` | LL-001適用済み |
| `ai_question_start.review.json` | completed (2回目) |
| `PlantUML_Studio_Sequence_AI_Question_Start.png` | レビュー用 |
| `7_1_AI_Question_Start.svg` | 正式版（修正済み） |

---

## 関連知見

| ID | 内容 | 適用 |
|----|------|:----:|
| LL-001 | else分岐は前分岐のdeactivateを継承しない | ✅ 適用 |
| LL-025 | ネストaltでのactivate漏れ防止（提案） | 新規 |
