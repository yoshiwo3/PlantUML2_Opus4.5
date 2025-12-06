# 技術決定記録（Technical Decisions）

**最終更新**: 2025-12-06

---

## 概要

このファイルは、プロジェクトの重要な技術決定を索引形式で記録します。

---

## 技術決定一覧

### TD-001: AI駆動開発標準の採用

**日付**: 2025-11-30
**ステータス**: Accepted

**決定内容**:
3層ドキュメント構造（Memory Bank / Session Log / Evidence）とMCPサーバー統合を採用

**理由**:
- トレーサビリティの向上（Evidence完備率100%）
- 作業効率化（自動化スクリプトで作業時間75%削減）
- 品質保証（doc-reviewerスコア96/100達成）

**影響**:
- すべての作業でEvidence 3点セット作成が必須
- MCPサーバー（Serena, Context7等）のセットアップが必要

---

### TD-002: PlantUML Validator MCP採用

**日付**: 2025-11-30
**ステータス**: Accepted

**決定内容**:
PlantUML構文検証にMCPサーバーを使用し、すべてのPlantUMLコードを検証必須とする

**理由**:
- 構文エラーの早期発見
- 検証ループによる100%成功保証
- ドキュメント品質向上

**影響**:
- PlantUMLコード作成時は必ず検証を実行
- 検証失敗時は最大5回リトライ

---

### TD-003: Google Cloud Run採用（MCP Validator）

**日付**: 2025-11-08
**ステータス**: Accepted

**決定内容**:
PlantUML Validator MCPサーバーをGoogle Cloud Runでホスティング

**理由**:
- サーバーレスでスケーラブル
- 東京リージョン（asia-northeast1）で低レイテンシ
- コスト効率が良い

**影響**:
- GCPプロジェクト（plantuml-477523）の管理が必要
- Dockerコンテナでのデプロイ

---

### TD-004: Serena MCP採用

**日付**: 2025-11-30
**ステータス**: Accepted

**決定内容**:
コードベース理解とシンボル検索にSerena MCPを使用

**理由**:
- トークン効率化（シンボル検索でトークン消費1/20）
- プロジェクトメモリ永続化
- 構造化されたコード解析

**影響**:
- .serena/project.yml での設定が必要
- .serena/memories/ でのメモリ管理

---

### TD-005: プロジェクト選択状態のSupabase保存

**日付**: 2025-12-06
**ステータス**: Accepted

**決定内容**:
ユーザーが最後に選択したプロジェクトの状態をSupabaseに保存する（`users.last_selected_project_id`）

**理由**:
- UX向上：前回の作業を即座に再開可能
- アーキテクチャ一貫性：本プロジェクトはSupabase中心設計
- クロスデバイス対応：どのデバイスからでも同じ状態で再開

**代替案（不採用）**:
- ローカルストレージ/React State：リロード時消失、デバイス固有
- 実装コストは低いがUX劣化

**影響**:
- usersテーブルに`last_selected_project_id`カラム追加
- プロジェクト選択時にSupabase更新APIコール

---

### TD-006: MVPデータ保存設計（Storage Only）

**日付**: 2025-12-06
**ステータス**: Accepted

**決定内容**:
MVPはSupabase Storageのみで構成し、DBテーブルは作成しない（auth.usersのみ使用）

**Storage構造**:
```
/{user_id}/
  └── {project_name}/
      ├── {diagram_name}.puml
      ├── {diagram_name}.excalidraw.json
      └── {diagram_name}.preview.svg
```

**ファイル形式**: B案（.puml + コメント内Markdown）
```plantuml
/'
# 図表タイトル
説明文（Markdown形式）
'/

@startuml
...PlantUMLコード...
@enduml
```

**理由**:
- MVPはシンプルに：DBテーブル設計・RLS設定の複雑さを回避
- Storage Policyで十分なアクセス制御が可能
- 実際に必要になってから対応（YAGNI原則）

**機能ロードマップ**:
| Phase | 機能 | 実装方法 |
|-------|------|---------|
| **MVP** | 図表一覧、プロジェクト管理、CRUD | Storage API のみ |
| **v3** | ファイル名検索、全文検索、バージョン管理 | DB追加 + 取込み機能 |

**代替案（不採用）**:
- DB中心（コンテンツDB保存）：複雑すぎる
- DB + Storage（メタデータDB、ファイルStorage）：過剰設計
- MVPでUUID/マニフェスト：v3で取込み機能として対応すれば十分

**v3移行戦略**:
- 「ファイル取込み機能」をv3で実装
- 取込み時にUUID付与・DBインデックス作成
- 既存ファイルは取込み機能で移行

**影響**:
- 業務フロー図3.6, 3.7の一部を修正が必要（Storage構造変更）
- バージョン管理（UC 3-7, 3-8）はv3に延期

---

**次のレビュー予定**: 2025-12-07
