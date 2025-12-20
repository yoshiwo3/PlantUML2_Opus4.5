# Instructions: UC 3-9 図表削除シーケンス図

## 作業目標

UC 3-9「図表を削除する」のシーケンス図を作成する。

## 入力情報

### 参照ドキュメント

| ドキュメント | 参照内容 |
|-------------|---------|
| 03_業務フロー図_20251201.md § 3.8 | 削除フロー仕様 |
| 05_機能一覧表_20251213.md F-DGM-09 | 機能定義 |
| 06_クラス図_20251208.md v1.7 | DiagramService, IDiagramRepository |
| PlantUML_Development_Constitution.md v4.6 | 開発ルール |
| Sequence_Diagram_Authoring_Guide.md | 作成ガイドライン |

### 設計要件

1. **参加者構成**
   - エンドユーザー（actor）
   - ブラウザ（エディタ画面）
   - API Routes (/api/diagrams/delete)
   - DiagramService
   - IDiagramRepository
   - Supabase Storage

2. **フロー概要**（業務フロー§3.8より）
   - 削除ボタンクリック
   - 確認ダイアログ表示
   - キャンセル or 確認
   - DELETE APIリクエスト
   - DiagramService → IDiagramRepository → Storage
   - ファイル削除（.puml/.excalidraw.json + .preview.svg）
   - 成功/エラー通知

3. **HTTPエラーコード**
   | HTTP | エラーコード | 発生条件 |
   |:----:|-------------|---------|
   | 401 | UNAUTHORIZED | 未ログイン |
   | 403 | FORBIDDEN | 他ユーザーの図表 |
   | 404 | NOT_FOUND | 図表が存在しない |
   | 500 | STORAGE_ERROR | Storage削除失敗 |

## 出力物

1. `sequence_delete.puml` - PlantUMLソースコード
2. `PlantUML_Studio_Sequence_Delete.png` - レビュー用PNG
3. `sequence_delete.review.json` - レビューログ
4. `7_1_Delete.svg` - 正式版SVG（`docs/proposals/diagrams/08_sequence/`）

## 完了条件

- [ ] 4パス視覚的レビュー合格
- [ ] ソースコード対比確認合格
- [ ] シーケンス図統合版（§6）への追記完了
