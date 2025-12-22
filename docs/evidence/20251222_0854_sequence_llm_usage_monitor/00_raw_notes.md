# Raw Notes - UC 5-7 LLM使用量監視 シーケンス図

**作成日時**: 2025-12-22 08:54

---

## 作業ログ

### 08:54 - 作業開始
- `active_context.md` 確認済み
- `00_Session_Start.md` 確認済み
- UC 5-7の要件確認完了

### 参照済みドキュメント
- 業務フロー図 §3.9.2.5
- 機能一覧表 F-ADM-07
- クラス図 UsageLogRepository, LLMConfigService

---

## クラス図確認テーブル

| # | クラス図定義 | シーケンス図で使用予定 | 一致 |
|:-:|-------------|---------------------|:----:|
| 1 | IUsageLogRepository.getByPeriod(period: DateRange): UsageReport | getByPeriod(period) | ✅ |
| 2 | IUsageLogRepository.getByModel(modelId: String, period: DateRange): UsageLog[] | getByModel(modelId, period) | ✅ |
| 3 | IUsageLogRepository.getByUser(userId: UUID, period: DateRange): UsageLog[] | getByUser(userId, period) | ✅ |
| 4 | OpenRouterClient（存在確認必要） | getCredits() | 🔍 |

---

## 業務フロー操作リスト

**対象**: UC 5-7 LLM使用量監視
**業務フロー参照**: 3.9.2.5

| # | 業務フロー上の操作 | シーケンス図でカバー | セクション |
|:-:|------------------|:------------------:|:----------:|
| 1 | 使用量監視クリック | ✅ | 初期読込 |
| 2 | 内部ログ取得（Supabase） | ✅ | 初期読込 |
| 3 | OpenRouter残高取得 | ✅ | 初期読込 |
| 4 | ダッシュボード表示 | ✅ | 初期読込 |
| 5 | 期間・フィルタ選択 | ✅ | 詳細フィルタ |
| 6 | 詳細確認実行 | ✅ | 詳細フィルタ |

---

## レビュー記録

### Phase 1-B: 視覚品質評価

（PNG生成後に記録）

### Phase 1-A: コード品質評価

（視覚評価合格後に記録）

### Phase 2: ドキュメント統合評価

（統合版追記後に記録）
