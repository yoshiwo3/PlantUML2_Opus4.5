# Instructions: UC 3-1, 3-2 シーケンス図作成

## 作成日時
2025-12-14 22:00

## 目標
- UC 3-1（図表を作成する）シーケンス図作成
- UC 3-2（テンプレートを選択する）シーケンス図作成
- PlantUML開発憲法 v4.2準拠でPhase 1 Review → Phase 2 Publish実行
- 統合版シーケンス図ドキュメントへ追加（1ファイル方式）

## コンテキスト

### 対象ユースケース
| UC | 名称 | 優先度 |
|----|------|--------|
| UC 3-1 | 図表を作成する | MVP |
| UC 3-2 | テンプレートを選択する | MVP |

### 参照ドキュメント
- `docs/proposals/PlantUML_Studio_クラス図_20251208.md` - DiagramService, TemplateService定義
- `docs/context/technical_decisions.md` - TD-006 Storage Only設計
- `docs/guides/PlantUML_Development_Constitution.md` - v4.2 作業プロセス
- `docs/proposals/PlantUML_Studio_シーケンス図_20251214.md` - 統合版（追加先）

### 技術仕様
- **TD-006**: MVPはSupabase Storageのみ、DBテーブルなし
- **パス構造**: `/{user_id}/{project_name}/{diagram_name}.puml`
- **RLS Policy**: `user_id = auth.uid()`でアクセス制御
- **DiagramService**: 図表CRUD操作（クラス図v1.7）
- **TemplateService**: テンプレート取得・適用（クラス図v1.7）

## 実施内容

### Phase 1: Review
1. PlantUMLソースコード作成（.puml）
2. PNG生成（-Review）
3. 4パスレビュー（構造・接続・内容・スタイル）
4. review.json更新

### Phase 2: Publish
1. SVG生成（-Publish -DiagramType "sequence"）
2. 正式版保存（docs/proposals/diagrams/sequence/）
3. 統合版ドキュメント更新
4. active_context.md更新

## 完了条件
- [ ] UC 3-1シーケンス図: 4パスレビュー完了
- [ ] UC 3-2シーケンス図: 4パスレビュー完了
- [ ] SVG正式版保存
- [ ] 統合版ドキュメント更新
- [ ] active_context.md進捗更新
- [ ] Evidence 3点セット完成
- [ ] SERENA Memory保存

## 備考
- 前セッションでPlantUMLコード作成済み
- このセッションでPhase 1 Review〜Phase 2 Publish実行
