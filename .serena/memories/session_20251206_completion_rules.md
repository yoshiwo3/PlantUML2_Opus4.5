# 作業完了時の更新ルール追加セッション

## 日時
2025-12-06

## 作業内容

CLAUDE.mdに「作業完了時の更新ルール」セクションを追加

## 追加内容

### 必須更新ファイル（3件）
1. `docs/evidence/<作業名>/work_sheet.md` - 作業結果、成果物
2. `docs/context/active_context.md` - 最近の変更、進捗、次のステップ
3. SERENA Memory (`write_memory`) - セッション知識永続化

### 状況に応じた更新ファイル（4件）
- `docs/context/project_brief.md` - スコープ・アーキテクチャ変更時
- `docs/context/technical_decisions.md` - TD追加時
- `CLAUDE.md` - 進捗・ルール変更時
- `docs/proposals/*` - 正式版図表作成時

### active_context.md更新チェックリスト
- 「最近の変更」に日付と作業内容を追記
- 「図表作成進捗」テーブルを更新
- 「業務フロー図 詳細進捗」テーブルを更新（該当時）
- 「UCカバレッジ」テーブルを更新（該当時）
- 「次のステップ」を更新

## 背景

ユーザーからの提案: 「作業完了時に更新すべきファイルをCLAUDE.mdに記述した方が良い」

## 関連ファイル
- `CLAUDE.md` - 行742-792に新セクション追加
- `docs/context/active_context.md` - 変更履歴追加
- `docs/evidence/20251206_save_export_flow/work_sheet.md` - 追加作業記録
