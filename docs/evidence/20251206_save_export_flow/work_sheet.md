# 3.6 保存・エクスポートフロー作成 - ワークシート

## 作業概要

| 項目 | 内容 |
|------|------|
| 作業名 | 3.6 保存・エクスポートフロー作成 |
| 対応UC | UC 3-5（図表を保存する）、UC 3-6（図表をエクスポートする） |
| 作業期間 | 2025-12-06 |
| ステータス | ✅ 完了 |

## 成果物一覧

| 成果物 | ファイルパス | 状態 |
|--------|-------------|:----:|
| 業務フロー図 3.6セクション | `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` | ✅ |
| Serena Memory | `.serena/memories/session_20251206_save_export_flow_complete.md` | ✅ |
| CLAUDE.md更新 | `CLAUDE.md` | ✅ |
| active_context.md更新 | `docs/context/active_context.md` | ✅ |

## 作成した図表

### 3.6 概要図
- 手動保存 / 自動保存 / エクスポート / 編集継続 の4分岐
- PlantUML制限回避のためswitch内スイムレーン変更を削除

### 3.6.1.1 PlantUML保存フロー（13ステップ）
| ステップ | 処理内容 | 担当 |
|:-------:|---------|------|
| 1 | 保存トリガー（手動/自動） | エンドユーザー/システム |
| 2 | 現在のPlantUMLコードを取得 | Frontend Service |
| 3 | PlantUML Serviceへ処理依頼 | Frontend Service |
| 4 | SHA-256ハッシュ生成 | PlantUML Service |
| 5 | バージョン情報作成 | PlantUML Service |
| 6 | **プレビューSVG生成**（図の数だけ） | PlantUML Service |
| 7 | 処理結果を受信 | Frontend Service |
| 8 | AI Serviceへ用語チェック依頼 | Frontend Service |
| 9 | 用語一貫性チェック | AI Service |
| 10 | チェック結果を受信 | Frontend Service |
| 11 | Supabaseへ保存リクエスト | Frontend Service |
| 12 | メタデータ・ソース・プレビュー保存 | Supabase |
| 13 | 完了通知・最終保存時刻更新 | Frontend Service |

### 3.6.1.2 Excalidraw保存フロー（9ステップ）
| ステップ | 処理内容 | 担当 |
|:-------:|---------|------|
| 1 | 保存トリガー（手動/自動） | エンドユーザー/システム |
| 2 | 現在のExcalidraw状態を取得 | Frontend Service |
| 3 | Excalidraw Serviceへ処理依頼 | Frontend Service |
| 4 | Excalidraw JSON生成（source.json） | Excalidraw Service |
| 5 | プレビューSVG生成（preview_0.svg） | Excalidraw Service |
| 6 | 処理結果を受信 | Frontend Service |
| 7 | Supabaseへ保存リクエスト | Frontend Service |
| 8 | メタデータ・ソース・プレビュー保存 | Supabase |
| 9 | 完了通知・最終保存時刻更新 | Frontend Service |

### 3.6.2.1 PlantUMLエクスポートフロー（7ステップ）
- PNG/SVG/PDF形式選択
- node-plantumlによる生成

### 3.6.2.2 Excalidrawエクスポートフロー（7ステップ）
- PNG/SVG/PDF形式選択
- Excalidraw API（exportToBlob/exportToSvg）による生成

## 設計決定事項

### Storage構成（統一設計）
```
/{user_id}/{project_id}/{diagram_id}/
├── source.puml または source.json
├── preview_0.svg
├── preview_1.svg (PlantUMLで複数図がある場合)
└── ...
```

| 項目 | PlantUML | Excalidraw |
|------|----------|------------|
| ソースファイル | `source.puml`（複数@startuml可） | `source.json` |
| プレビューファイル | `preview_N.svg`（図の数だけ） | `preview_0.svg`（1ファイル） |
| サムネイル | `preview_0.svg`を使用 | `preview_0.svg`を使用 |

### Frontend Serviceオーケストレーションパターン
```
Frontend Service → バックエンドサービスへ処理依頼
バックエンドサービス → 処理実行
Frontend Service ← 処理結果を受信
Frontend Service → Supabaseへ保存リクエスト
```

### PlantUML既知の制限と回避策
| 制限 | 回避策 |
|------|--------|
| switch内のスイムレーン変更 | 同一スイムレーン内に収める |
| note内の`@startuml`文字列 | 別の表現に置き換え |
| 条件分岐でスイムレーンをまたぐ | 概要図+詳細図に分割 |

## 技術仕様

| 項目 | PlantUML | Excalidraw |
|------|---------|-----------|
| PNG生成 | node-plantuml | Excalidraw exportToBlob |
| SVG生成 | node-plantuml | Excalidraw exportToSvg |
| PDF生成 | SVG→PDF変換 | SVG→PDF変換 |
| バージョン管理 | SHA-256ハッシュ | なし |
| 用語一貫性チェック | ✅ 対応 | ❌ 非対応（ビジュアル図表のため） |

## 進捗更新

### 業務フロー図
- 完了: 6/10（60%）
- 3.1〜3.6 ✅ 完了
- 3.7〜3.8 🔴 MVP必須
- 3.9〜3.10 🔴 Phase 2

### ユースケースカバレッジ
- カバー済み: 14/24（58%）
- 未カバー: 10（3-7〜3-11, 5-1〜5-5）

## 参照ドキュメント

- `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` セクション3.6
- `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md` UC 3-5, 3-6
- `docs/evidence/20251206_save_export_flow/00_raw_notes.md` 作業メモ

## 整合性チェック

### 調査対象ドキュメント
- PlantUML_Studio_コンテキスト図_20251130.md
- PlantUML_Studio_ユースケース図_20251130.md
- PlantUML_Studio_シーケンス図_ログイン_20251130.md
- PlantUML_Studio_業務フロー図_20251201.md

### 確認結果

| 項目 | 状態 | 備考 |
|------|:----:|------|
| アクター名 | ✅ | エンドユーザー、開発者 |
| サービス名 | ✅ | Frontend/PlantUML/AI/Excalidraw Service |
| 外部システム名 | ✅ | Supabase、OpenRouter API |
| UC参照 | ✅ | UC 3-5, 3-6定義と一致 |
| Storage構成 | ✅ | Supabase Storage使用 |
| API Gateway | ✅ | 「暗黙的に介在」と明記（可読性優先） |

### 対応した不整合

| 項目 | 修正前 | 修正後 |
|------|--------|--------|
| コンテキスト図 PlantUML Service | 「JAR同梱検証」 | 「node-plantuml（ローカルJAR）」 |
| API Gatewayの扱い | 「図では省略」 | 「暗黙的に介在」と明記 |

**ポイント**:
- ローカルJARによるプライバシー保護が重要
- API Gatewayは全フローで暗黙的に介在（業務フロー図の可読性を優先）

## Gitコミット

| # | コミット | メッセージ | 変更 |
|---|----------|-----------|------|
| 1 | `46ae4f7` | 3.6保存・エクスポートフロー完成、整合性チェック実施 | 8件、+1299/-32 |
| 2 | `a705f82` | 機能一覧表の導入決定、Phase 2フロー更新 | 6件、+109/-6 |

## 機能一覧表の導入決定

| 項目 | 内容 |
|------|------|
| 決定 | 選択肢C採用（機能一覧表に業務フロー・DFD対比を統合） |
| 変更 | 「業務フロー・DFD対比表」→「機能一覧表」 |
| タイミング | 業務フロー・DFD完了後 |
| 役割 | 網羅性確認、整合性チェック、不備発見→フロー修正 |

## 次のアクション

1. **3.7 バージョン管理フロー**（UC 3-7, 3-8）
2. **3.8 図表削除フロー**（UC 3-9）
