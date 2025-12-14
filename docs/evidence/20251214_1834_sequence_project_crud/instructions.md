# 作業指示書: プロジェクトCRUDシーケンス図作成

**作成日時**: 2025-12-14 18:34
**作業タイプ**: feature
**担当**: Claude Code

---

## 1. 目標

プロジェクトCRUD操作（UC 2-1〜2-4）のシーケンス図を作成する。

## 2. コンテキスト

### 対象ユースケース
- UC 2-1: プロジェクト作成
- UC 2-2: プロジェクト選択
- UC 2-3: プロジェクト編集
- UC 2-4: プロジェクト削除

### 参照ドキュメント
- `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` § 3.5
- `docs/context/technical_decisions.md` TD-005, TD-006
- `docs/guides/PlantUML_Development_Constitution.md` v3.4

### 技術仕様
- **TD-005**: プロジェクト選択状態はSupabase `users.last_selected_project_id`で保存
- **TD-006**: MVPはStorage Only構成（`/{user_id}/{project_name}/`）

## 3. 実施内容

1. 4つのシーケンス図を.puml形式で作成
2. PNG生成・4パス視覚的レビュー
3. SVG生成・Publish
4. 正式版ドキュメント作成

## 4. 完了条件

- [ ] 4つのシーケンス図が作成されている
- [ ] 4パス視覚的レビューが完了している
- [ ] SVGが`docs/proposals/diagrams/sequence/`に保存されている
- [ ] 正式版ドキュメントが作成されている

## 5. 成果物

- `PlantUML_Studio_Sequence_Project_Create.puml`
- `PlantUML_Studio_Sequence_Project_Select.puml`
- `PlantUML_Studio_Sequence_Project_Edit.puml`
- `PlantUML_Studio_Sequence_Project_Delete.puml`
