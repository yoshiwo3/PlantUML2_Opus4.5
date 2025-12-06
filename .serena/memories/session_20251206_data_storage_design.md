# データ保存設計決定 (2025-12-06)

## 概要

MVP向けのデータ保存設計を決定。シンプルさを優先し、Storage中心のアーキテクチャを採用。

---

## 機能ロードマップ

| Phase | 機能 | 実装方法 |
|-------|------|---------|
| **MVP** | 図表一覧、プロジェクト管理、CRUD | Storage API のみ |
| **v3** | ファイル名検索、全文検索、バージョン管理 | DB追加 + 取込み機能 |

---

## MVP構成（確定）

### Storage構造

```
Supabase Storage:
/{user_id}/
  └── {project_name}/
      ├── {diagram_name}.puml
      ├── {diagram_name}.excalidraw.json
      └── {diagram_name}.preview.svg
```

### DBテーブル

**なし**（auth.usersのみ使用）

### RLS

Storage Policiesのみで実現

---

## ファイル形式（B案：確定）

### PlantUML

```plantuml
/'
# 図表タイトル
説明文（Markdown形式で記述可能）
'/

@startuml
...PlantUMLコード...
@enduml
```

### Excalidraw

```
{diagram_name}.excalidraw.json
```

### 動作

| 拡張子 | ビューワー | Markdown部分 | 図表部分 |
|--------|-----------|:------------:|:--------:|
| `.puml` | PlantUMLビューワー | 非表示（コメント） | 図表表示 |
| `.md`に変更 | Markdownビューワー | 表示 | 対応ビューワーなら図表表示 |

---

## v3移行戦略

### 取込み機能でDB移行

1. 既存ファイルをスキャン
2. UUID付与
3. DBインデックス作成
4. 検索・バージョン管理が有効化

### 留意点（MVP）

- ファイル名の命名規則を統一
- 拡張子の統一: `.puml`, `.excalidraw.json`, `.preview.svg`
- 特殊文字を避ける（`/`, `\`, `:` 等）

---

## アーキテクチャ: Repository Pattern

v3移行を容易にするため、ストレージ層を抽象化する。

```
┌─────────────────────────────────────────────┐
│           Application Layer                  │
│  (図表CRUD、プロジェクト管理、一覧取得)        │
└─────────────────┬───────────────────────────┘
                  │ 依存（Interface経由）
                  ▼
┌─────────────────────────────────────────────┐
│      IDiagramRepository (Interface)          │
│  - list(projectName): Diagram[]              │
│  - get(projectName, diagramName): Diagram    │
│  - save(diagram): void                       │
│  - delete(projectName, diagramName): void    │
└─────────────────┬───────────────────────────┘
                  │ 実装
        ┌─────────┴─────────┐
        ▼                   ▼
┌───────────────┐   ┌─────────────────┐
│ MVP: Storage  │   │ v3: DB+Storage  │
│ Repository    │   │ Repository      │
│ (Storage API) │   │ (Supabase DB)   │
└───────────────┘   └─────────────────┘
```

### 採用理由

- MVP→v3移行時、Repository実装の差し替えのみでOK
- アプリケーション層のコード変更不要（依存性逆転）
- テスト時にMock Repositoryで置換可能
- SOLID原則（特にDIP: 依存性逆転の原則）に準拠

### 影響

- MVPでIDiagramRepository interfaceを定義
- StorageRepositoryを実装
- v3でDBRepositoryに差し替え可能

---

## 決定の経緯

### 不採用とした方式

| 方式 | 不採用理由 |
|------|-----------|
| DB中心 | 複雑、RLS設定が大変 |
| DB + Storage | 2箇所管理、同期が必要 |
| バージョン管理（MVP） | 自動保存との関係が未整理、複雑 |

### 採用理由

- MVPはシンプルに
- DBテーブル設計・RLS設定の複雑さを回避
- v3で必要になったら取込み機能で対応

---

## 関連ドキュメント

- `docs/evidence/20251206_version_delete_flow/` - エビデンスセット
- `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` - 要修正
