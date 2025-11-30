# PlantUML Studio シーケンス図 - 保存・読み込み

**作成日**: 2025-11-30
**バージョン**: 1.0
**対象ユースケース**: UC 4-1, UC 4-2

---

## 目次

1. [図表保存フロー](#1-図表保存フロー)
2. [自動保存フロー](#2-自動保存フロー)
3. [バージョン履歴表示フロー](#3-バージョン履歴表示フロー)
4. [バージョン復元フロー](#4-バージョン復元フロー)
5. [図表読み込みフロー](#5-図表読み込みフロー)

---

## 対象ユースケース

| UC ID | ユースケース名 | 説明 |
|-------|---------------|------|
| UC 4-1 | 図を保存する | 明示的保存、自動保存、バージョン管理 |
| UC 4-2 | 図を読み込む | プロジェクトから図表を開く、バージョン復元 |

---

## 1. 図表保存フロー

```plantuml
@startuml save_diagram

title シーケンス図 - 図表保存（UC 4-1）

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
  BackgroundColor<<service>> #FCE4EC
  BackgroundColor<<storage>> #FFF3E0
}

actor "エンドユーザー" as user
participant "Monaco Editor" as editor <<frontend>> #E3F2FD
participant "フロントエンド\n(Next.js)" as frontend <<frontend>> #E3F2FD
participant "API Routes\n(/api/diagrams)" as api <<backend>> #E8F5E9
participant "VersionService" as versionService <<service>> #FCE4EC
participant "DiagramService" as diagramService <<service>> #FCE4EC
database "Supabase\nDatabase" as db #FFF3E0
database "Supabase\nStorage" as storage <<storage>> #FFF3E0

== 保存トリガー ==

alt Ctrl+S キーボードショートカット
  user -> editor : Ctrl+S 押下
  activate editor
  editor -> frontend : onSave イベント
else 保存ボタンクリック
  user -> frontend : 「保存」ボタンクリック
  activate frontend
end

== 保存前検証 ==

frontend -> frontend : ダーティフラグ確認
note right of frontend
  **保存前チェック**
  - 変更があるか（isDirty）
  - 構文エラーがないか
  - 保存中でないか
end note

alt 変更なし
  frontend --> user : 「変更はありません」通知
  deactivate frontend
else 構文エラーあり
  frontend --> user : 「構文エラーを修正してください」
  deactivate frontend
else 変更あり（正常）
  frontend -> frontend : 保存中フラグセット
  frontend -> frontend : 保存インジケーター表示
end

== バージョン保存処理 ==

frontend -> api : POST /api/diagrams/{id}/versions\n{ content: PlantUMLコード }
activate api

api -> api : 認証チェック（JWT検証）
api -> api : 権限チェック（RLS: owner確認）

api -> versionService : save(diagramId, content)
activate versionService

versionService -> versionService : SHA-256ハッシュ計算
note right of versionService
  **重複保存防止**
  content_hash = SHA-256(content)
  前回バージョンと比較
end note

versionService -> db : SELECT content_hash\nFROM diagram_versions\nWHERE diagram_id = ?\nORDER BY version DESC\nLIMIT 1
activate db
db --> versionService : 最新バージョンのハッシュ
deactivate db

alt ハッシュが同一（変更なし）
  versionService --> api : 304 Not Modified
  deactivate versionService
  api --> frontend : 304 Not Modified
  deactivate api
  frontend --> user : 「変更はありません」通知

else ハッシュが異なる（変更あり）
  versionService -> db : SELECT MAX(version)\nFROM diagram_versions\nWHERE diagram_id = ?
  activate db
  db --> versionService : 現在の最大バージョン番号
  deactivate db

  versionService -> versionService : 新バージョン番号 = 現在 + 1

  versionService -> storage : upload(\n  diagrams/{userId}/{diagramId}/v{version}.puml,\n  content\n)
  activate storage
  note right of storage
    **ファイル保存パス**
    diagrams/
      {user_id}/
        {diagram_id}/
          v1.puml
          v2.puml
          ...
  end note
  storage --> versionService : file_path
  deactivate storage

  versionService -> db : INSERT INTO diagram_versions\n(diagram_id, version, content, content_hash, file_path)
  activate db
  db --> versionService : DiagramVersion
  deactivate db

  versionService -> diagramService : updateCurrentVersion(diagramId, version)
  activate diagramService
  diagramService -> db : UPDATE diagrams\nSET current_version = ?, updated_at = NOW()\nWHERE id = ?
  activate db
  db --> diagramService : OK
  deactivate db
  diagramService --> versionService : OK
  deactivate diagramService

  versionService --> api : DiagramVersion
  deactivate versionService

  api --> frontend : 201 Created\n{ version, created_at }
  deactivate api

  frontend -> frontend : ダーティフラグクリア
  frontend -> frontend : バージョン表示更新
  frontend --> user : 「v{n} を保存しました」通知
end

deactivate frontend
deactivate editor

@enduml
```

### 保存データ構造

```typescript
// diagram_versions テーブル
interface DiagramVersion {
  id: string;          // UUID
  diagram_id: string;  // UUID (FK)
  version: number;     // バージョン番号
  content: string;     // PlantUMLコード
  content_hash: string; // SHA-256ハッシュ
  file_path: string;   // Storage パス
  created_at: Date;    // 作成日時
}
```

---

## 2. 自動保存フロー

```plantuml
@startuml autosave

title シーケンス図 - 自動保存（バックグラウンド）

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
  BackgroundColor<<service>> #FCE4EC
}

actor "エンドユーザー" as user
participant "Monaco Editor" as editor <<frontend>> #E3F2FD
participant "AutoSave\nManager" as autosave <<frontend>> #E3F2FD
participant "LocalStorage" as local #FFF9C4
participant "API Routes" as api <<backend>> #E8F5E9
participant "VersionService" as service <<service>> #FCE4EC
database "Supabase" as db #FFF3E0

== 編集開始 ==

user -> editor : コード編集
activate editor

editor -> autosave : onChange(content)
activate autosave

autosave -> autosave : デバウンス(2000ms)
note right of autosave
  **自動保存タイミング**
  - 編集停止から2秒後
  - 最大間隔: 30秒
end note

== ローカルドラフト保存 ==

autosave -> local : setItem(\n  draft_{diagramId},\n  { content, timestamp }\n)
activate local
local --> autosave : OK
deactivate local

note right of local
  **オフライン対策**
  ブラウザクラッシュ時に復旧可能
  有効期限: 24時間
end note

autosave --> user : 「ドラフト保存中...」表示

== サーバー同期（条件付き） ==

alt ネットワークオンライン
  autosave -> api : POST /api/diagrams/{id}/draft\n{ content }
  activate api

  api -> service : saveDraft(diagramId, content)
  activate service

  service -> db : UPSERT diagrams\nSET draft_content = ?\nWHERE id = ?
  activate db
  note right of db
    **ドラフトとバージョンの違い**
    draft_content: 作業中の内容
    diagram_versions: 確定バージョン
  end note
  db --> service : OK
  deactivate db

  service --> api : OK
  deactivate service

  api --> autosave : 200 OK
  deactivate api

  autosave --> user : 「同期完了」表示（控えめ）

else ネットワークオフライン
  autosave --> user : 「オフライン - ローカル保存のみ」表示
end

deactivate autosave
deactivate editor

== ドラフト復旧フロー ==

user -> editor : ページ再訪問
activate editor

editor -> local : getItem(draft_{diagramId})
activate local
local --> editor : draft または null
deactivate local

alt ドラフトあり && サーバーより新しい
  editor -> editor : 復旧確認ダイアログ表示
  note right of editor
    「未保存の変更があります。
    復元しますか？」
    [復元] [破棄]
  end note

  alt 復元を選択
    editor -> editor : content = draft.content
    editor --> user : 「ドラフトを復元しました」
  else 破棄を選択
    editor -> local : removeItem(draft_{diagramId})
    editor --> user : 「サーバー版を使用します」
  end

else ドラフトなし または サーバーが最新
  editor -> editor : サーバー版を表示
end

deactivate editor

@enduml
```

### 自動保存設定

| 設定項目 | デフォルト値 | 説明 |
|---------|-------------|------|
| autoSaveEnabled | true | 自動保存有効/無効 |
| autoSaveDelay | 2000ms | デバウンス時間 |
| autoSaveInterval | 30000ms | 最大保存間隔 |
| draftExpiry | 24h | ローカルドラフト有効期限 |

---

## 3. バージョン履歴表示フロー

```plantuml
@startuml version_history

title シーケンス図 - バージョン履歴表示

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
}

actor "エンドユーザー" as user
participant "エディタ画面" as editor <<frontend>> #E3F2FD
participant "バージョン履歴\nモーダル" as modal <<frontend>> #E3F2FD
participant "API Routes" as api <<backend>> #E8F5E9
database "Supabase" as db #FFF3E0

== 履歴モーダル表示 ==

user -> editor : 「履歴」ボタンクリック
activate editor

editor -> modal : open()
activate modal

modal -> api : GET /api/diagrams/{id}/versions?limit=50
activate api

api -> db : SELECT id, version, content_hash, created_at\nFROM diagram_versions\nWHERE diagram_id = ?\nORDER BY version DESC\nLIMIT 50
activate db
db --> api : DiagramVersion[]
deactivate db

api --> modal : 200 OK\n[{ version, created_at, ... }, ...]
deactivate api

modal -> modal : バージョンリスト構築
note right of modal
  **表示内容**
  - v5 - 2025-11-30 15:30 (現在)
  - v4 - 2025-11-30 14:00
  - v3 - 2025-11-29 18:00
  - ...
end note

modal --> user : 履歴一覧表示

== バージョン詳細・差分表示 ==

user -> modal : バージョンをクリック（例: v4）

modal -> api : GET /api/diagrams/{id}/versions/4
activate api

api -> db : SELECT content\nFROM diagram_versions\nWHERE diagram_id = ? AND version = 4
activate db
db --> api : DiagramVersion (content含む)
deactivate db

api --> modal : 200 OK\n{ version, content, created_at }
deactivate api

user -> modal : 「比較表示」クリック

modal -> api : GET /api/diagrams/{id}/versions/4/diff?compare=5
activate api

api -> api : diff計算（unified diff形式）
note right of api
  **Diff計算**
  diff-match-patch または
  jsdiff ライブラリ使用
end note

api --> modal : 200 OK\n{ diff: "unified diff string" }
deactivate api

modal -> modal : Diff表示（追加=緑、削除=赤）
modal --> user : 差分表示

deactivate modal
deactivate editor

@enduml
```

---

## 4. バージョン復元フロー

```plantuml
@startuml restore_version

title シーケンス図 - バージョン復元（UC 4-2の一部）

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
  BackgroundColor<<service>> #FCE4EC
}

actor "エンドユーザー" as user
participant "バージョン履歴\nモーダル" as modal <<frontend>> #E3F2FD
participant "Monaco Editor" as editor <<frontend>> #E3F2FD
participant "API Routes" as api <<backend>> #E8F5E9
participant "VersionService" as service <<service>> #FCE4EC
database "Supabase" as db #FFF3E0

== 復元開始 ==

user -> modal : 「v3を復元」ボタンクリック
activate modal

modal -> modal : 確認ダイアログ表示
note right of modal
  「v3（2025-11-29 18:00）を
  復元しますか？
  現在の内容は新しいバージョン
  として保存されます。」
  [復元] [キャンセル]
end note

user -> modal : 「復元」をクリック

== 現在の内容を保存（安全対策） ==

modal -> api : POST /api/diagrams/{id}/versions\n{ content: 現在の内容 }
activate api

api -> service : save(diagramId, currentContent)
activate service
note right of service
  **安全対策**
  復元前に現在の内容を
  新バージョンとして保存
end note

service -> db : INSERT INTO diagram_versions
activate db
db --> service : OK (v6 created)
deactivate db

service --> api : OK
deactivate service

api --> modal : 201 Created (v6)
deactivate api

== 復元バージョン取得 ==

modal -> api : GET /api/diagrams/{id}/versions/3
activate api

api -> db : SELECT content\nFROM diagram_versions\nWHERE diagram_id = ? AND version = 3
activate db
db --> api : v3の内容
deactivate db

api --> modal : 200 OK\n{ content: "v3のPlantUMLコード" }
deactivate api

== 新バージョンとして保存 ==

modal -> api : POST /api/diagrams/{id}/versions\n{ content: v3のコード, restored_from: 3 }
activate api

api -> service : save(diagramId, v3Content, { restoredFrom: 3 })
activate service

service -> db : INSERT INTO diagram_versions\n(restored_from_version = 3)
activate db
note right of db
  **復元履歴追跡**
  restored_from_version カラムで
  どのバージョンから復元したか記録
end note
db --> service : OK (v7 created)
deactivate db

service -> db : UPDATE diagrams\nSET current_version = 7
activate db
db --> service : OK
deactivate db

service --> api : DiagramVersion (v7)
deactivate service

api --> modal : 201 Created
deactivate api

== エディタ更新 ==

modal -> editor : updateContent(v3Content)
activate editor
editor -> editor : Monaco.setValue(content)
editor -> editor : プレビュー更新
editor --> user : 「v3を復元しました（v7として保存）」
deactivate editor

modal -> modal : close()
deactivate modal

@enduml
```

### 復元ポリシー

| 項目 | 仕様 |
|------|------|
| 復元方式 | 新バージョンとして保存（非破壊） |
| 復元前保存 | 現在の内容を自動保存 |
| 追跡 | `restored_from_version` で記録 |
| 最大バージョン数 | 100（超過時は古いものから削除） |

---

## 5. 図表読み込みフロー

```plantuml
@startuml load_diagram

title シーケンス図 - 図表読み込み（UC 4-2）

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
}

actor "エンドユーザー" as user
participant "プロジェクト\n一覧画面" as projectList <<frontend>> #E3F2FD
participant "エディタ画面" as editor <<frontend>> #E3F2FD
participant "Monaco Editor" as monaco <<frontend>> #E3F2FD
participant "API Routes" as api <<backend>> #E8F5E9
database "Supabase" as db #FFF3E0

== プロジェクト一覧表示 ==

user -> projectList : プロジェクト画面を開く
activate projectList

projectList -> api : GET /api/projects/{projectId}/diagrams
activate api

api -> db : SELECT id, name, diagram_type, updated_at\nFROM diagrams\nWHERE project_id = ?\nORDER BY updated_at DESC
activate db
db --> api : Diagram[] (メタデータのみ)
deactivate db

api --> projectList : 200 OK\n[{ id, name, type, updatedAt }, ...]
deactivate api

projectList --> user : 図表一覧表示
note right of projectList
  **表示内容**
  📊 class_diagram.puml - 更新: 5分前
  📈 sequence_login.puml - 更新: 1時間前
  📉 activity_order.puml - 更新: 昨日
end note

== 図表選択・読み込み ==

user -> projectList : 図表をダブルクリック
projectList -> editor : navigate(/editor/{diagramId})
activate editor
deactivate projectList

editor -> api : GET /api/diagrams/{id}
activate api

api -> db : SELECT d.*, dv.content\nFROM diagrams d\nJOIN diagram_versions dv\n  ON d.id = dv.diagram_id\n  AND d.current_version = dv.version\nWHERE d.id = ?
activate db
db --> api : Diagram + 最新バージョンのcontent
deactivate db

api --> editor : 200 OK\n{ id, name, type, content, version, ... }
deactivate api

editor -> monaco : initialize(content)
activate monaco

monaco -> monaco : シンタックスハイライト適用
monaco -> monaco : PlantUML言語モード設定

monaco --> editor : 初期化完了
deactivate monaco

editor -> editor : プレビューパネル更新
editor -> editor : メタデータ表示（名前、バージョン等）
editor --> user : エディタ表示完了

== ドラフト確認 ==

editor -> api : GET /api/diagrams/{id}/draft
activate api

api -> db : SELECT draft_content, draft_updated_at\nFROM diagrams\nWHERE id = ?
activate db
db --> api : draft または null
deactivate db

api --> editor : 200 OK\n{ hasDraft, draftUpdatedAt }
deactivate api

alt ドラフトあり && サーバーバージョンより新しい
  editor -> editor : 復旧確認ダイアログ
  note right of editor
    「作業中のドラフトがあります
    （2025-11-30 15:45）
    復元しますか？」
    [復元] [破棄]
  end note

  alt 復元を選択
    editor -> api : GET /api/diagrams/{id}/draft/content
    api --> editor : draft_content
    editor -> monaco : setValue(draft_content)
    editor --> user : 「ドラフトを復元しました」
  else 破棄を選択
    editor -> api : DELETE /api/diagrams/{id}/draft
    editor --> user : 「保存済みバージョンを表示」
  end
end

deactivate editor

@enduml
```

### 読み込み最適化

```plantuml
@startuml load_optimization

title シーケンス図 - 読み込み最適化（大規模図表対応）

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
}

participant "エディタ画面" as editor <<frontend>> #E3F2FD
participant "API Routes" as api <<backend>> #E8F5E9
database "Supabase" as db #FFF3E0
database "Supabase\nStorage" as storage #FFF3E0

== メタデータ先行読み込み ==

editor -> api : GET /api/diagrams/{id}?fields=meta
activate api
note right of api
  **軽量クエリ**
  content以外のメタデータのみ
end note

api -> db : SELECT id, name, type, version, size\nFROM diagrams\nWHERE id = ?
activate db
db --> api : メタデータ
deactivate db

api --> editor : 200 OK (高速)
deactivate api

editor -> editor : メタデータ表示（即座）
editor --> editor : ローディングスピナー表示

== コンテンツ遅延読み込み ==

alt サイズが小さい（< 100KB）
  editor -> api : GET /api/diagrams/{id}/content
  activate api

  api -> db : SELECT content\nFROM diagram_versions\nWHERE ...
  activate db
  db --> api : content
  deactivate db

  api --> editor : content
  deactivate api

else サイズが大きい（>= 100KB）
  editor -> api : GET /api/diagrams/{id}/content
  activate api

  api -> storage : download(file_path)
  activate storage
  note right of storage
    **大規模ファイル**
    Storageからストリーミング
  end note
  storage --> api : Stream<content>
  deactivate storage

  api --> editor : Stream + Content-Length
  deactivate api

  editor -> editor : プログレスバー表示
  editor -> editor : チャンク受信しながら表示
end

editor -> editor : エディタ初期化完了

@enduml
```

---

## エラーハンドリング

### 保存エラー一覧

| エラーコード | 説明 | 対処方法 |
|-------------|------|---------|
| SAVE_001 | 認証エラー | 再ログイン |
| SAVE_002 | 権限エラー（他ユーザーの図表） | アクセス権確認 |
| SAVE_003 | 同時編集コンフリクト | マージまたは上書き確認 |
| SAVE_004 | ストレージ容量不足 | 古いバージョン削除 |
| SAVE_005 | ネットワークエラー | 自動リトライ + ローカル保存 |

### コンフリクト解決フロー

```plantuml
@startuml conflict_resolution

title シーケンス図 - 同時編集コンフリクト解決

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
}

actor "ユーザーA" as userA
participant "エディタA" as editorA <<frontend>> #E3F2FD
participant "API Routes" as api <<backend>> #E8F5E9
database "Supabase" as db #FFF3E0
participant "エディタB" as editorB <<frontend>> #E3F2FD
actor "ユーザーB" as userB

== 両者が同時編集 ==

userA -> editorA : 編集開始（v5を基準）
userB -> editorB : 編集開始（v5を基準）

userB -> editorB : 保存
editorB -> api : POST /api/diagrams/{id}/versions\n{ content: B's changes, base_version: 5 }
api -> db : INSERT (v6)
api --> editorB : 201 Created (v6)

== ユーザーAの保存（コンフリクト発生） ==

userA -> editorA : 保存
editorA -> api : POST /api/diagrams/{id}/versions\n{ content: A's changes, base_version: 5 }
activate api

api -> db : SELECT current_version FROM diagrams
db --> api : current_version = 6 (Not 5!)

api --> editorA : 409 Conflict\n{ serverVersion: 6, yourBase: 5 }
deactivate api

== コンフリクト解決UI ==

editorA -> editorA : コンフリクトダイアログ表示
note right of editorA
  「他のユーザーが変更を保存しました」

  [サーバー版を確認]
  [自分の変更で上書き]
  [マージツールを開く]
end note

alt サーバー版を確認
  editorA -> api : GET /api/diagrams/{id}/versions/6
  api --> editorA : v6の内容
  editorA -> editorA : 比較表示

else 自分の変更で上書き
  editorA -> api : POST /api/diagrams/{id}/versions\n{ content: A's changes, force: true }
  api -> db : INSERT (v7)
  api --> editorA : 201 Created (v7)
  note right of editorA
    **警告**
    v6の変更は履歴に残るが
    current_versionには反映されない
  end note

else マージツール
  editorA -> editorA : 3-way merge UI表示
  note right of editorA
    左: ベース版（v5）
    中央: サーバー版（v6）
    右: 自分の変更
  end note
  userA -> editorA : マージ結果を確定
  editorA -> api : POST /api/diagrams/{id}/versions\n{ content: merged, base_version: 6 }
  api --> editorA : 201 Created (v7)
end

@enduml
```

---

## 技術仕様

### バージョン管理

| 項目 | 仕様 |
|------|------|
| 最大バージョン数 | 100 |
| バージョン番号方式 | 連番（1, 2, 3...） |
| 重複保存防止 | SHA-256ハッシュ比較 |
| 削除ポリシー | 古いバージョンから自動削除 |

### ストレージパス

```
diagrams/
  {user_id}/
    {diagram_id}/
      v1.puml
      v2.puml
      ...
      draft.puml (作業中ドラフト)
```

### データベーススキーマ

```sql
-- diagrams テーブル
CREATE TABLE diagrams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id),
  user_id UUID REFERENCES auth.users(id),
  name VARCHAR(255) NOT NULL,
  diagram_type VARCHAR(50) NOT NULL,
  current_version INTEGER DEFAULT 1,
  draft_content TEXT,
  draft_updated_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- diagram_versions テーブル
CREATE TABLE diagram_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  diagram_id UUID REFERENCES diagrams(id) ON DELETE CASCADE,
  version INTEGER NOT NULL,
  content TEXT NOT NULL,
  content_hash VARCHAR(64) NOT NULL,
  file_path VARCHAR(500),
  restored_from_version INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(diagram_id, version)
);
```

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|----------|
| 1.0 | 2025-11-30 | 初版作成 |
