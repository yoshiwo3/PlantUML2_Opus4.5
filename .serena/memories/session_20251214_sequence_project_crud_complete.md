# Session: プロジェクトCRUDシーケンス図完成

**日時**: 2025-12-14
**作業者**: Claude Code

---

## 完了タスク

### プロジェクトCRUDシーケンス図（UC 2-1〜2-4）

4つのシーケンス図を作成・レビュー・公開完了:

| # | ファイル | UC | 内容 |
|:-:|---------|-----|------|
| 1 | 01_project_create.puml | UC 2-1 | プロジェクト作成 |
| 2 | 02_project_list.puml | UC 2-2 | 一覧取得・選択 |
| 3 | 03_project_update.puml | UC 2-3 | 編集（名前変更）|
| 4 | 04_project_delete.puml | UC 2-4 | 削除 |

---

## 技術仕様

### TD-006 Storage Only構成

- DBテーブルなし（auth.usersのみ）
- メタデータは `.meta.json` ファイルで管理
- Storage構造: `/{user_id}/{project_name}/`

### IProjectRepository パターン

```
Application Layer (ProjectService)
        ↓
IProjectRepository (Interface)
  - list(userId): Project[]
  - get(userId, name): Project | null
  - create(project): void
  - update(project): void
  - delete(userId, name): void
  - exists(userId, name): boolean
        ↓
StorageProjectRepository
  - Supabase Storage API操作
```

### Storage API操作

| 操作 | Storage API |
|------|-------------|
| 一覧取得 | `list()` + `download()` |
| 作成 | `upload()` |
| 更新（名前変更）| `copy()` → `upload()` → `remove()` |
| 削除 | `list()` → `remove()` |

---

## 成果物

### Evidence
- `docs/evidence/20251214_1708_sequence_project_crud/`

### 正式版SVG
- `docs/proposals/diagrams/sequence/PlantUML_Studio_Sequence_Project_Create.svg`
- `docs/proposals/diagrams/sequence/PlantUML_Studio_Sequence_Project_List.svg`
- `docs/proposals/diagrams/sequence/PlantUML_Studio_Sequence_Project_Update.svg`
- `docs/proposals/diagrams/sequence/PlantUML_Studio_Sequence_Project_Delete.svg`

### 正式版ドキュメント
- `docs/proposals/PlantUML_Studio_シーケンス図_プロジェクトCRUD_20251214.md`

---

## 進捗更新

### シーケンス図
- **進捗**: 1/14 → 2/14（14%）
- **MVP**: 1/8 → 2/8（25%）

### 次の作業候補

MVP必須残り6本:
1. 図表作成・テンプレート（UC 3-1, 3-2）- Storage + node-plantuml
2. 編集・プレビュー（UC 3-3, 3-4）- node-plantuml + OpenRouter
3. 保存（UC 3-5）- Storage + OpenRouter
4. エクスポート（UC 3-6）- node-plantuml
5. 図表削除（UC 3-9）- Supabase Storage
6. AI Question-Start（UC 4-1）- OpenRouter (streaming)

---

## 参考

- TD-005: プロジェクト選択状態のSupabase保存
- TD-006: MVPデータ保存設計（Storage Only）
- 既存シーケンス図: `PlantUML_Studio_シーケンス図_ログイン_20251130.md`
