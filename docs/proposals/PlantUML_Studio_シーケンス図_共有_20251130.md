# PlantUML Studio シーケンス図 - 共有

**作成日**: 2025-11-30
**バージョン**: 1.0
**対象ユースケース**: UC 4-3

---

## 目次

1. [共有リンク生成フロー](#1-共有リンク生成フロー)
2. [共有リンクアクセスフロー](#2-共有リンクアクセスフロー)
3. [埋め込みコード生成フロー](#3-埋め込みコード生成フロー)
4. [コラボレーション招待フロー](#4-コラボレーション招待フロー)

---

## 対象ユースケース

| UC ID | ユースケース名 | 説明 |
|-------|---------------|------|
| UC 4-3 | 図を共有する | リンク共有、埋め込み、コラボレーション |

---

## 1. 共有リンク生成フロー

```plantuml
@startuml share_link_generate

title シーケンス図 - 共有リンク生成（UC 4-3）

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
  BackgroundColor<<service>> #FCE4EC
}

actor "エンドユーザー" as user
participant "共有モーダル" as modal <<frontend>> #E3F2FD
participant "API Routes\n(/api/diagrams/{id}/share)" as api <<backend>> #E8F5E9
participant "ShareService" as service <<service>> #FCE4EC
database "Supabase" as db #FFF3E0

== 共有モーダル表示 ==

user -> modal : 「共有」ボタンクリック
activate modal

modal -> api : GET /api/diagrams/{id}/share
activate api

api -> db : SELECT * FROM diagram_shares\nWHERE diagram_id = ?
activate db
db --> api : 既存の共有設定（あれば）
deactivate db

api --> modal : 200 OK\n{ shares: [...], currentAccess: "private" }
deactivate api

modal --> user : 共有設定モーダル表示
note right of modal
  **共有オプション**
  ○ 非公開（自分のみ）
  ○ リンクを知っている人（閲覧のみ）
  ○ リンクを知っている人（編集可能）

  [リンクをコピー]
  [埋め込みコード]
end note

== 共有リンク生成 ==

user -> modal : 「リンクを知っている人」を選択
user -> modal : 権限を選択（閲覧のみ）
user -> modal : 「リンクを生成」クリック

modal -> api : POST /api/diagrams/{id}/share\n{ accessLevel: "view", expiresIn: null }
activate api

api -> api : 認証チェック（所有者確認）

api -> service : createShareLink(diagramId, options)
activate service

service -> service : 共有トークン生成
note right of service
  **トークン生成**
  - nanoid(21) 使用
  - 例: "xYz123AbC456dEf789gHi"
  - URL安全な文字のみ
end note

service -> db : INSERT INTO diagram_shares\n(diagram_id, token, access_level, created_by)
activate db
db --> service : DiagramShare
deactivate db

service -> service : 共有URL構築
note right of service
  **URL形式**
  https://plantuml.studio/s/{token}

  短縮形式で共有しやすく
end note

service --> api : { shareUrl, token, accessLevel }
deactivate service

api --> modal : 201 Created\n{ shareUrl: "https://plantuml.studio/s/xYz123..." }
deactivate api

modal -> modal : URLを表示
modal -> modal : クリップボードにコピー
modal --> user : 「リンクをコピーしました」

deactivate modal

@enduml
```

### 共有設定オプション

| アクセスレベル | 説明 | 権限 |
|---------------|------|------|
| private | 非公開 | 所有者のみ |
| view | 閲覧のみ | 読み取り、エクスポート |
| edit | 編集可能 | 読み取り、編集（保存は別バージョン） |
| comment | コメント可能 | 読み取り、コメント追加 |

### 有効期限オプション

| オプション | 説明 |
|-----------|------|
| null | 無期限 |
| 24h | 24時間 |
| 7d | 7日間 |
| 30d | 30日間 |
| custom | カスタム日時 |

---

## 2. 共有リンクアクセスフロー

```plantuml
@startuml share_link_access

title シーケンス図 - 共有リンクアクセス

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
  BackgroundColor<<service>> #FCE4EC
}

actor "ゲスト/\n登録ユーザー" as visitor
participant "共有ページ\n(/s/{token})" as sharePage <<frontend>> #E3F2FD
participant "API Routes" as api <<backend>> #E8F5E9
participant "ShareService" as service <<service>> #FCE4EC
database "Supabase" as db #FFF3E0

== 共有リンクアクセス ==

visitor -> sharePage : https://plantuml.studio/s/xYz123...
activate sharePage

sharePage -> api : GET /api/share/{token}
activate api

api -> service : validateShareToken(token)
activate service

service -> db : SELECT ds.*, d.name, d.diagram_type\nFROM diagram_shares ds\nJOIN diagrams d ON ds.diagram_id = d.id\nWHERE ds.token = ?
activate db
db --> service : DiagramShare + Diagram メタデータ
deactivate db

alt 有効期限チェック
  service -> service : 有効期限確認
  alt 有効期限切れ
    service --> api : 410 Gone
    api --> sharePage : 有効期限切れエラー
    sharePage --> visitor : 「このリンクは有効期限が切れています」
  else 有効
    service --> api : ShareInfo
  end

else パスワード保護
  service --> api : 401 Unauthorized\n{ requiresPassword: true }
  api --> sharePage : パスワード要求
  sharePage --> visitor : パスワード入力ダイアログ

  visitor -> sharePage : パスワード入力
  sharePage -> api : POST /api/share/{token}/verify\n{ password }
  api -> service : verifyPassword(token, password)

  alt パスワード正しい
    service --> api : OK + セッショントークン
    api --> sharePage : 200 OK
  else パスワード間違い
    service --> api : 403 Forbidden
    api --> sharePage : エラー
    sharePage --> visitor : 「パスワードが違います」
  end
end

deactivate service

== コンテンツ読み込み ==

api -> db : SELECT dv.content\nFROM diagram_versions dv\nJOIN diagrams d ON d.id = dv.diagram_id\n  AND d.current_version = dv.version\nWHERE d.id = ?
activate db
db --> api : コンテンツ
deactivate db

api --> sharePage : 200 OK\n{ diagram, content, accessLevel }
deactivate api

sharePage -> sharePage : ビューアー初期化
note right of sharePage
  **表示モード**
  - 閲覧モード: 編集不可
  - プレビューのみ表示
  - エクスポートボタン表示
end note

sharePage --> visitor : 図表表示

== ゲストアクション ==

alt アクセスレベル = view
  visitor -> sharePage : 「エクスポート」クリック
  sharePage -> api : POST /api/share/{token}/export\n{ format: "PNG" }
  api --> sharePage : PNG画像
  sharePage --> visitor : ダウンロード

else アクセスレベル = edit
  visitor -> sharePage : 編集を開始
  sharePage -> sharePage : エディタモードに切替
  note right of sharePage
    **編集時の動作**
    - ログイン済み: 自分のコピーとして保存
    - 未ログイン: ローカルのみ保存
  end note

else アクセスレベル = comment
  visitor -> sharePage : コメントを追加
  sharePage -> api : POST /api/share/{token}/comments\n{ content, position }
  api --> sharePage : Comment
end

deactivate sharePage

@enduml
```

### 共有ページUI状態

```plantuml
@startuml share_page_states

title 共有ページの状態遷移

[*] --> Loading : URLアクセス

Loading --> ValidLink : トークン有効
Loading --> ExpiredLink : 有効期限切れ
Loading --> NotFound : トークン不正
Loading --> PasswordRequired : パスワード保護

PasswordRequired --> ValidLink : パスワード正しい
PasswordRequired --> PasswordRequired : パスワード間違い

ValidLink --> ViewMode : accessLevel = view
ValidLink --> EditMode : accessLevel = edit
ValidLink --> CommentMode : accessLevel = comment

ViewMode --> [*] : 閲覧終了
EditMode --> SavePrompt : 変更あり
CommentMode --> [*] : コメント完了

SavePrompt --> LoginPrompt : 未ログイン
SavePrompt --> SaveAsOwn : ログイン済み
LoginPrompt --> SaveAsOwn : ログイン完了
LoginPrompt --> LocalSave : キャンセル

SaveAsOwn --> [*]
LocalSave --> [*]

ExpiredLink --> [*]
NotFound --> [*]

@enduml
```

---

## 3. 埋め込みコード生成フロー

```plantuml
@startuml embed_code_generate

title シーケンス図 - 埋め込みコード生成

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
}

actor "エンドユーザー" as user
participant "共有モーダル" as modal <<frontend>> #E3F2FD
participant "API Routes" as api <<backend>> #E8F5E9
database "Supabase" as db #FFF3E0

== 埋め込みタブ選択 ==

user -> modal : 「埋め込みコード」タブクリック
activate modal

modal -> modal : 埋め込みオプション表示
note right of modal
  **埋め込み形式**
  - iframe
  - 画像（静的PNG/SVG）
  - Markdown
  - HTML img タグ

  **サイズ設定**
  - 幅: [___] px
  - 高さ: [___] px または auto

  **テーマ**
  - ライト / ダーク
end note

== iframe埋め込み ==

alt iframe選択
  user -> modal : iframe形式を選択
  user -> modal : サイズ設定（800x600）

  modal -> api : POST /api/diagrams/{id}/share/embed\n{ type: "iframe", width: 800, height: 600 }
  activate api

  api -> api : 埋め込み用トークン生成
  note right of api
    **埋め込みトークン**
    別トークン（e_xxx）を使用
    - X-Frame-Optionsバイパス
    - 最小限のUI表示
  end note

  api -> db : INSERT INTO diagram_embeds\n(diagram_id, embed_token, options)
  activate db
  db --> api : OK
  deactivate db

  api --> modal : 200 OK\n{ embedToken: "e_abc123" }
  deactivate api

  modal -> modal : iframeコード生成
  note right of modal
    ```html
    <iframe
      src="https://plantuml.studio/embed/e_abc123"
      width="800"
      height="600"
      frameborder="0"
      allowfullscreen>
    </iframe>
    ```
  end note

  modal --> user : コード表示

== 静的画像埋め込み ==

else 画像形式選択
  user -> modal : PNG/SVG形式を選択

  modal -> api : POST /api/diagrams/{id}/share/image\n{ format: "SVG", theme: "light" }
  activate api

  api -> api : 画像生成・アップロード
  note right of api
    **CDN配信**
    永続的な画像URL生成
    https://cdn.plantuml.studio/img/{hash}.svg
  end note

  api --> modal : 200 OK\n{ imageUrl: "https://cdn..." }
  deactivate api

  modal -> modal : HTMLコード生成
  note right of modal
    ```html
    <img
      src="https://cdn.plantuml.studio/img/abc123.svg"
      alt="クラス図"
      width="800">
    ```
  end note

  modal --> user : コード表示

== Markdown埋め込み ==

else Markdown形式選択
  user -> modal : Markdown形式を選択

  modal -> modal : Markdownコード生成
  note right of modal
    ```markdown
    ![クラス図](https://cdn.plantuml.studio/img/abc123.svg)
    ```
  end note

  modal --> user : コード表示
end

user -> modal : 「コピー」クリック
modal -> modal : クリップボードにコピー
modal --> user : 「コピーしました」

deactivate modal

@enduml
```

### 埋め込みオプション

| オプション | 値 | 説明 |
|-----------|---|------|
| type | iframe, image, markdown | 埋め込み形式 |
| width | number | 幅（px） |
| height | number / "auto" | 高さ |
| theme | light, dark | テーマ |
| showToolbar | boolean | ツールバー表示（iframeのみ） |
| allowZoom | boolean | ズーム許可（iframeのみ） |

---

## 4. コラボレーション招待フロー

```plantuml
@startuml collaboration_invite

title シーケンス図 - コラボレーション招待

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
  BackgroundColor<<service>> #FCE4EC
  BackgroundColor<<external>> #FFF3E0
}

actor "所有者" as owner
participant "共有モーダル" as modal <<frontend>> #E3F2FD
participant "API Routes" as api <<backend>> #E8F5E9
participant "CollaborationService" as collabService <<service>> #FCE4EC
participant "NotificationService" as notifyService <<service>> #FCE4EC
database "Supabase" as db #FFF3E0
actor "招待ユーザー" as invitee

== コラボレーター招待 ==

owner -> modal : 「共同編集者を追加」タブ
activate modal

modal --> owner : メールアドレス入力フォーム

owner -> modal : メールアドレス入力\n権限選択（編集者）

modal -> api : POST /api/diagrams/{id}/collaborators\n{ email: "user@example.com", role: "editor" }
activate api

api -> api : 認証チェック（所有者確認）

api -> collabService : invite(diagramId, email, role)
activate collabService

collabService -> db : SELECT id FROM users\nWHERE email = ?
activate db
db --> collabService : user または null
deactivate db

alt 登録済みユーザー
  collabService -> db : INSERT INTO diagram_collaborators\n(diagram_id, user_id, role, status)
  activate db
  db --> collabService : Collaborator
  deactivate db

  collabService -> notifyService : sendInvitation(userId, diagram)
  activate notifyService

  notifyService -> db : INSERT INTO notifications\n(user_id, type, data)
  activate db
  db --> notifyService : Notification
  deactivate db

  notifyService -> notifyService : プッシュ通知送信
  note right of notifyService
    **通知チャネル**
    - In-app通知
    - メール通知
    - ブラウザ通知（許可時）
  end note

  notifyService --> collabService : OK
  deactivate notifyService

else 未登録ユーザー
  collabService -> db : INSERT INTO pending_invitations\n(diagram_id, email, role, invite_token)
  activate db
  db --> collabService : PendingInvitation
  deactivate db

  collabService -> notifyService : sendInviteEmail(email, inviteToken)
  activate notifyService
  notifyService -> notifyService : メール送信
  note right of notifyService
    **招待メール内容**
    「{ownerName}さんが図表を
    共有しました。
    [招待を受ける]」
  end note
  notifyService --> collabService : OK
  deactivate notifyService
end

collabService --> api : Collaborator / PendingInvitation
deactivate collabService

api --> modal : 201 Created
deactivate api

modal --> owner : 「招待を送信しました」

== 招待承諾（登録済みユーザー） ==

notifyService --> invitee : 通知
activate invitee

invitee -> modal : 通知から招待を開く
modal -> api : GET /api/invitations/{invitationId}
api --> modal : Invitation詳細

modal --> invitee : 招待確認ダイアログ
note right of modal
  「{ownerName}さんが
  「クラス図.puml」を
  共有しました。
  権限: 編集者
  [承諾] [辞退]」
end note

invitee -> modal : 「承諾」クリック

modal -> api : POST /api/invitations/{invitationId}/accept
activate api

api -> collabService : acceptInvitation(invitationId)
activate collabService

collabService -> db : UPDATE diagram_collaborators\nSET status = 'accepted'\nWHERE id = ?
activate db
db --> collabService : OK
deactivate db

collabService --> api : OK
deactivate collabService

api --> modal : 200 OK
deactivate api

modal --> invitee : 「図表にアクセスできます」
modal -> modal : 図表を開く
deactivate modal
deactivate invitee

@enduml
```

### コラボレーターの役割

| 役割 | 閲覧 | 編集 | 共有 | 削除 | バージョン復元 |
|------|------|------|------|------|--------------|
| owner | ○ | ○ | ○ | ○ | ○ |
| editor | ○ | ○ | - | - | ○ |
| commenter | ○ | - | - | - | - |
| viewer | ○ | - | - | - | - |

### リアルタイムコラボレーション

```plantuml
@startuml realtime_collaboration

title シーケンス図 - リアルタイムコラボレーション（将来実装）

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
  BackgroundColor<<realtime>> #FFF9C4
}

actor "ユーザーA" as userA
participant "エディタA" as editorA <<frontend>> #E3F2FD
participant "Supabase\nRealtime" as realtime <<realtime>> #FFF9C4
participant "エディタB" as editorB <<frontend>> #E3F2FD
actor "ユーザーB" as userB

== チャネル接続 ==

userA -> editorA : 図表を開く
activate editorA

editorA -> realtime : subscribe(\n  channel: "diagram:{id}",\n  events: ["presence", "changes"]\n)
activate realtime

realtime --> editorA : subscribed

userB -> editorB : 図表を開く
activate editorB

editorB -> realtime : subscribe(\n  channel: "diagram:{id}"\n)

realtime --> editorA : presence: userB joined
realtime --> editorB : presence: userA online

editorA -> editorA : アクティブユーザー表示
editorB -> editorB : アクティブユーザー表示
note right of editorA
  👤 ユーザーA（あなた）
  👤 ユーザーB
end note

== リアルタイム同期 ==

userA -> editorA : コード編集
editorA -> realtime : broadcast(\n  event: "change",\n  payload: { ops: [...] }\n)

realtime --> editorB : change event
editorB -> editorB : OT/CRDT適用
note right of editorB
  **同期アルゴリズム**
  - Operational Transform または
  - CRDT (Conflict-free Replicated Data Type)
  - Yjs / Automerge 使用
end note

editorB --> userB : 変更反映

== カーソル同期 ==

userA -> editorA : カーソル移動
editorA -> realtime : broadcast(\n  event: "cursor",\n  payload: { line: 10, ch: 5 }\n)

realtime --> editorB : cursor event
editorB -> editorB : カーソルマーカー表示
note right of editorB
  他ユーザーのカーソル位置を
  色付きマーカーで表示
end note

editorB --> userB : Aのカーソル表示

deactivate editorA
deactivate editorB
deactivate realtime

@enduml
```

---

## データベーススキーマ

```sql
-- 共有リンク
CREATE TABLE diagram_shares (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  diagram_id UUID REFERENCES diagrams(id) ON DELETE CASCADE,
  token VARCHAR(21) UNIQUE NOT NULL,
  access_level VARCHAR(20) NOT NULL DEFAULT 'view',
  password_hash VARCHAR(255),
  expires_at TIMESTAMPTZ,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  view_count INTEGER DEFAULT 0
);

-- 埋め込み設定
CREATE TABLE diagram_embeds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  diagram_id UUID REFERENCES diagrams(id) ON DELETE CASCADE,
  embed_token VARCHAR(21) UNIQUE NOT NULL,
  options JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- コラボレーター
CREATE TABLE diagram_collaborators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  diagram_id UUID REFERENCES diagrams(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  role VARCHAR(20) NOT NULL DEFAULT 'viewer',
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  invited_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  accepted_at TIMESTAMPTZ,
  UNIQUE(diagram_id, user_id)
);

-- 保留中の招待（未登録ユーザー向け）
CREATE TABLE pending_invitations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  diagram_id UUID REFERENCES diagrams(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'viewer',
  invite_token VARCHAR(64) UNIQUE NOT NULL,
  invited_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ DEFAULT NOW() + INTERVAL '7 days'
);
```

---

## セキュリティ考慮事項

| 項目 | 対策 |
|------|------|
| トークン漏洩 | 21文字のランダムトークン、推測困難 |
| 有効期限 | 期限設定、期限切れ自動無効化 |
| パスワード保護 | bcryptハッシュ化、レート制限 |
| アクセスログ | view_count、最終アクセス日時記録 |
| 所有者権限 | いつでも共有取り消し可能 |
| RLS | 権限に応じたデータアクセス制限 |

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|----------|
| 1.0 | 2025-11-30 | 初版作成 |
