# 作業ログ: UC 3-9 図表削除シーケンス図

## タイムライン

### 01:17 - 作業開始
- Evidence ディレクトリ作成完了
- instructions.md 作成完了

### 01:20 - コンテキスト確認
- 業務フロー図 § 3.8 確認完了
  - 削除ボタン → 確認ダイアログ → Storage削除
  - 削除対象: .puml/.excalidraw.json + .preview.svg
  - エラー種別: ネットワーク、認証、権限、DB障害
- クラス図 v1.7 確認完了
  - DiagramService.delete(projectName, diagramName): void
  - IDiagramRepository.delete(projectName, diagramName): void
  - MVP: StorageDiagramRepository実装

### 01:25 - シーケンス図コード作成開始
- UC 3-9: 図表を削除する
- 参加者:
  - actor "エンドユーザー" as user
  - participant "ブラウザ\n(図表一覧)" as browser
  - participant "API Routes\n(/api/diagrams/delete)" as APIRoutes
  - participant "DiagramService" as DiagramService
  - participant "IDiagramRepository" as DiagramRepository
  - participant "Supabase Storage" as Storage

## 設計メモ

### フロー概要
1. ユーザーが削除ボタンをクリック
2. 確認ダイアログ表示（「削除しますか？」）
3. 確認 or キャンセル
4. キャンセル: 何もせず終了
5. 確認: API Routes → DiagramService → IDiagramRepository → Storage
6. ファイル削除（ソース + プレビュー）
7. 成功/エラー通知

### エラーハンドリング
| HTTP | エラー種別 | 発生条件 |
|:----:|----------|---------|
| 401 | Unauthorized | 未ログイン |
| 403 | Forbidden | 他ユーザーの図表 |
| 404 | Not Found | 図表が存在しない |
| 500 | Server Error | Storage削除失敗 |

## 作業中の問題・解決

（後で記録）

## 完了事項

（後で記録）

## 次のステップ

1. シーケンス図コード作成
2. PNG生成・4パスレビュー
3. SVG正式版保存
4. 統合版への追記
