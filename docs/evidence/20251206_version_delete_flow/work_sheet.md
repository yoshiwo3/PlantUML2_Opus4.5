# 作業報告書: 3.7/3.8 業務フロー図作成 + データ保存設計

**作業日**: 2025-12-06
**作業者**: Claude Opus 4.5
**ステータス**: 完了

---

## 概要

3.7 バージョン管理フローおよび3.8 図表削除フローの作成を完了。作業中にデータ保存設計の根本的な見直しを実施し、MVP構成とv3ロードマップを決定した。

---

## 成果物

### 1. 業務フロー図（新規作成）

| フロー | 対応UC | 内容 |
|--------|--------|------|
| 3.7 バージョン管理フロー | UC 3-7, 3-8 | 履歴確認・復元（v3で実装） |
| 3.8 図表削除フロー | UC 3-9 | 確認ダイアログ・カスケード削除 |

### 2. データ保存設計（決定）

#### 機能ロードマップ

| Phase | 機能 | 実装方法 |
|-------|------|---------|
| **MVP** | 図表一覧、プロジェクト管理、CRUD | Storage API のみ |
| **v3** | ファイル名検索、全文検索、バージョン管理 | DB追加 + 取込み機能 |

#### MVP構成（確定）

```
Supabase Storage:
/{user_id}/
  └── {project_name}/
      ├── {diagram_name}.puml
      ├── {diagram_name}.excalidraw.json
      └── {diagram_name}.preview.svg

DBテーブル: なし（auth.usersのみ）
```

#### ファイル形式（B案：確定）

```plantuml
/'
# 図表タイトル
説明文（Markdown形式で記述可能）
'/

@startuml
...PlantUMLコード...
@enduml
```

| 拡張子 | ビューワー | Markdown部分 | PlantUML部分 |
|--------|-----------|:------------:|:------------:|
| `.puml` | PlantUMLビューワー | 非表示（コメント） | 図表表示 |
| `.md` | Markdownビューワー | 表示 | 対応ビューワーなら図表表示 |

---

## 設計決定の経緯

### 1. バージョン管理の実現可能性

**問題**: 業務フロー図3.7で定義したが、実装詳細が未検討

**検討結果**:
- 自動保存（30秒）との関係が未整理
- DB + Storage両方管理は複雑
- → **v3に延期**

### 2. DB vs Storage

**検討した選択肢**:

| 方式 | 採用 |
|------|:----:|
| DB中心（コンテンツDB保存） | ❌ |
| DB + Storage（メタデータDB、ファイルStorage） | ❌ |
| **Storage のみ（フォルダ構造で管理）** | ✅ |

**決定理由**:
- MVPはシンプルに
- DBテーブル設計・RLS設定の複雑さを回避
- v3で必要になったら取込み機能で対応

### 3. v3移行への考慮

**ユーザー提案**: 「v3でファイル取込み機能を設け、その時にUUID付与・インデックス作成」

**採用理由**:
- MVPで過剰設計しない
- 実際に必要になってから対応
- 移行パスは取込み機能で解決

---

## PlantUML/Excalidraw機能分類（確定）

### PlantUML専用機能（3件）

| UC | 機能名 | 専用の理由 |
|----|--------|-----------|
| 3-4 | 図表をプレビューする | コード→画像変換・構文検証（ExcalidrawはWYSIWYG） |
| 3-10 | 学習コンテンツを検索する | PlantUML構文学習（RAG） |
| 3-11 | 学習コンテンツを確認する | PlantUML構文学習 |

### 共通機能（8件）

| UC | 機能名 |
|----|--------|
| 3-1 | 図表を作成する |
| 3-2 | テンプレートから作成する |
| 3-3 | 図表を編集する |
| 3-5 | 図表を保存する |
| 3-6 | 図表をエクスポートする |
| 3-7 | バージョン履歴を確認する（v3） |
| 3-8 | 過去バージョンを復元する（v3） |
| 3-9 | 図表を削除する |

---

## 今後の作業

### 業務フロー図への反映（要対応）

3.6 保存・エクスポートフロー、3.7 バージョン管理フロー等の業務フロー図を、今回決定したMVP構成に合わせて修正が必要。

| 項目 | 現在の記載 | 修正後 |
|------|-----------|--------|
| Storage構造 | `/{user_id}/{project_id}/{diagram_id}/` | `/{user_id}/{project_name}/{diagram_name}.puml` |
| DBテーブル | diagrams, diagram_versions等 | なし（auth.usersのみ） |
| バージョン管理 | MVP | v3 |
| ファイル形式 | 未定義 | B案（コメント内Markdown） |

### アーキテクチャ決定（追記）

**Repository Pattern採用**

v3移行を容易にするため、ストレージ層を抽象化する。

```
Application Layer (図表CRUD、一覧取得)
        │
        ▼
IDiagramRepository (Interface)
  - list(projectName): Diagram[]
  - get(projectName, diagramName): Diagram
  - save(diagram): void
  - delete(projectName, diagramName): void
        │
   ┌────┴────┐
   ▼         ▼
MVP:      v3:
Storage   DB+Storage
Repository Repository
```

**採用理由**:
- MVP→v3移行時、Repository実装の差し替えのみ
- アプリケーション層のコード変更不要
- テスト時にMock Repositoryで置換可能
- SOLID原則（DIP）に準拠

---

### 次のアクション

1. [ ] 業務フロー図をMVP構成に修正
2. [x] active_context.mdにデータ保存設計決定を追記
3. [ ] データフロー図（DFD）作成（MVP構成ベース）

---

## 関連ドキュメント

- `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md`
- `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md`
- `docs/proposals/PlantUML_Studio_コンテキスト図_20251130.md`
- `docs/context/active_context.md`
