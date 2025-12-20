# Work Sheet: UC 3-6 エクスポートシーケンス図

## 作業情報

| 項目 | 内容 |
|------|------|
| 作業日時 | 2025-12-18 01:04 - 01:30 |
| 作業者 | Claude Code |
| 対象UC | UC 3-6 図表をエクスポートする |
| ステータス | ✅ 完了 |

## 成果物

| ファイル | 説明 | 場所 |
|---------|------|------|
| sequence_export.puml | PlantUMLソースコード | 本Evidence内 |
| PlantUML_Studio_Sequence_Export.png | レビュー用PNG | 本Evidence内 |
| sequence_export.review.json | レビューログ | 本Evidence内 |
| 6_1_Export.svg | 正式版SVG | `docs/proposals/diagrams/08_sequence/` |
| 08_シーケンス図_20251214.md | 統合版（§5追加） | `docs/proposals/` |

## 設計決定

### 参加者構成

| 参加者 | 役割 | 色 |
|--------|------|:--:|
| エンドユーザー | アクター | - |
| ブラウザ（エディタ画面） | フロントエンド | #E3F2FD |
| API Routes (/api/diagrams/export) | エンドポイント | #FFF3E0 |
| ExportService | エクスポートサービス | #E8F5E9 |
| ValidationService | レンダリング実行 | #FCE4EC |

### アーキテクチャ決定

1. **ExportService経由のレンダリング**: クラス図v1.7準拠
   - ExportService → ValidationService → node-plantuml
2. **PDF生成**: SVG → PDF変換方式採用
3. **エラーハンドリング**: 6種類のHTTPステータスコード対応

### エラーハンドリング設計

| HTTPステータス | エラーコード | 発生条件 |
|:-------------:|-------------|---------|
| 400 | INVALID_FORMAT | 無効な形式指定（PNG/SVG/PDF以外） |
| 400 | SYNTAX_ERROR | PlantUML構文エラー |
| 401 | UNAUTHORIZED | 未ログイン |
| 403 | FORBIDDEN | 他ユーザーの図表アクセス |
| 404 | DIAGRAM_NOT_FOUND | 図表が存在しない |
| 500 | GENERATION_FAILED | node-plantuml実行失敗 |

## レビュー結果

### 4パス視覚的レビュー

| パス | 観点 | 結果 |
|:----:|------|:----:|
| 1 | Structure（構造） | ✅ 合格 |
| 2 | Connections（接続） | ✅ 合格 |
| 3 | Content（内容） | ✅ 合格 |
| 4 | Style（スタイル） | ✅ 合格 |

### ソースコード対比確認

- 参加者数: ソース5 = PNG5 ✅
- alt/elseブロック: 4階層 ✅
- HTTPステータスコード: 6種類 ✅
- activate/deactivate対: 4対 ✅

## 作業中の問題と解決

### 問題1: PowerShellスクリプトのJSONエンコーディング

- **症状**: `-Publish`実行時にJSONパースエラー発生
- **原因**: 日本語を含むJSONファイルのUTF-8エンコーディング問題
- **解決**: Java直接実行でSVG生成し、手動で正式版ディレクトリにコピー

## 更新ファイル一覧

1. `docs/proposals/08_シーケンス図_20251214.md`
   - 目次更新（5. エクスポート追加、6. 技術仕様に変更）
   - §5 エクスポート（UC 3-6）セクション追加
   - §6 技術仕様 > 図表API にエクスポートAPI追加

2. `docs/proposals/diagrams/08_sequence/6_1_Export.svg`
   - 正式版SVG保存

## 次のアクション

1. ~~シーケンス図統合版への追記~~ ✅ 完了
2. active_context.md更新
3. UC 3-9 図表削除シーケンス図作成
4. UC 4-1 AI Question-Startシーケンス図作成

## 参照ドキュメント

| ドキュメント | 参照内容 |
|-------------|---------|
| 03_業務フロー図_20251201.md § 3.6.2 | エクスポートフロー仕様 |
| 05_機能一覧表_20251213.md F-DGM-06 | 機能定義 |
| 06_クラス図_20251208.md v1.7 | ExportService, ValidationService |
| PlantUML_Development_Constitution.md v4.6 | 開発ルール |
| Sequence_Diagram_Authoring_Guide.md | 作成ガイドライン |
