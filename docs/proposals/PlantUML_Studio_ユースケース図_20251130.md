# PlantUML Studio - ユースケース図

**作成日**: 2025-11-30
**基準ドキュメント**: PlantUML_Studio_コンテキスト図_20251130.md

---

## 図表構成

| 図 | 内容 | 用途 |
|----|------|------|
| 1. 概要図 | 5パッケージ、主要フローのみ | 全体俯瞰 |
| 2. 詳細図: 認証・プロジェクト | 1.認証 + 2.プロジェクト管理 | 基盤機能 |
| 3. 詳細図: 図表操作 | 3.図表操作（11ユースケース） | コア機能 |
| 4. 詳細図: AI機能 | 4.AI機能 + 関連 | 差別化機能 |
| 5. 詳細図: 管理機能 | 5.管理機能（開発者専用） | 運用機能 |

---

## 0. 全体俯瞰（レイアウト調整版）

```plantuml
@startuml PlantUML_Studio_UseCase_Full_Overview
'==================================================
' 全体俯瞰図（レイアウト調整版）
' 調整: A.横方向 / D.線の長さ / E.together横グループ
' 情報量: 23ユースケース全件 + 全関連 + 全外部システム
'==================================================
left to right direction
scale 0.9

skinparam actorStyle awesome
skinparam packageStyle rectangle
skinparam defaultFontSize 9
skinparam usecaseFontSize 8
skinparam packageFontSize 10

skinparam package {
    BackgroundColor<<認証>> #E8F5E9
    BackgroundColor<<プロジェクト>> #E3F2FD
    BackgroundColor<<図表操作>> #FFF3E0
    BackgroundColor<<AI機能>> #FCE4EC
    BackgroundColor<<管理機能>> #F3E5F5
}

skinparam usecase {
    BackgroundColor #FAFAFA
    BorderColor #666666
}

skinparam note {
    BackgroundColor #FFFDE7
    BorderColor #FBC02D
    FontSize 7
}

'==================================================
' アクター定義
'==================================================
actor "エンドユーザー" as user
actor "開発者" as developer

'==================================================
' システム境界
'==================================================
rectangle "PlantUML Studio" {

    '----------------------------------------------
    ' 第1層: 認証（入口）
    '----------------------------------------------
    together {
        package "1. 認証" <<認証>> {
            usecase "1-1 ログインする" as UC_LOGIN
            usecase "1-2 ログアウトする" as UC_LOGOUT
        }
    }

    '----------------------------------------------
    ' 第2層: プロジェクト管理
    '----------------------------------------------
    together {
        package "2. プロジェクト管理" <<プロジェクト>> {
            usecase "2-1 プロジェクトを作成する" as UC_PRJ_CREATE
            usecase "2-2 プロジェクトを選択する" as UC_PRJ_SELECT
            usecase "2-3 プロジェクトを編集する" as UC_PRJ_EDIT
            usecase "2-4 プロジェクトを削除する" as UC_PRJ_DELETE
        }
    }

    '----------------------------------------------
    ' 第3層: メイン機能（図表操作 + AI機能）
    '----------------------------------------------
    together {
        package "3. 図表操作（PlantUML・Excalidraw）" <<図表操作>> {
            usecase "3-1 図表を作成する" as UC_CREATE
            usecase "3-2 テンプレートを選択する" as UC_TEMPLATE
            usecase "3-3 図表を編集する" as UC_EDIT
            usecase "3-4 図表をプレビューする" as UC_PREVIEW
            usecase "3-5 図表を保存する" as UC_SAVE
            usecase "3-6 図表をエクスポートする" as UC_EXPORT
            usecase "3-7 バージョン履歴を確認する" as UC_HISTORY
            usecase "3-8 過去バージョンを復元する" as UC_RESTORE
            usecase "3-9 図表を削除する" as UC_DELETE
            usecase "3-10 学習コンテンツを検索する" as UC_LEARN_SEARCH
            usecase "3-11 学習コンテンツを確認する" as UC_LEARN_VIEW
        }

        package "4. AI機能" <<AI機能>> {
            usecase "4-1 AI Question-Startで\n図表を生成する" as UC_AI_QS
            usecase "4-2 目的別AIチャットを\n利用する" as UC_AI_CHAT
        }
    }

    '----------------------------------------------
    ' 第4層: 管理機能（開発者専用）
    '----------------------------------------------
    together {
        package "5. 管理機能" <<管理機能>> {
            usecase "5-1 ユーザーを管理する" as UC_ADMIN_USER
            usecase "5-2 学習コンテンツを登録する" as UC_ADMIN_CONTENT_REG
            usecase "5-3 学習コンテンツを管理する" as UC_ADMIN_CONTENT_MGT
            usecase "5-4 LLMモデルを切り替える" as UC_ADMIN_LLM
            usecase "5-5 システム設定を変更する" as UC_ADMIN_CONFIG
        }
    }
}

'==================================================
' 外部システム（右側に配置）
'==================================================
actor "Supabase" as supabase <<外部システム>>
actor "OpenRouter API" as openrouter <<外部システム>>
actor "OpenAI API" as openai <<外部システム>>

'==================================================
' 主アクター関連（線の長さで階層別調整）
'==================================================

' エンドユーザー → 認証（短い線）
user --> UC_LOGIN
user --> UC_LOGOUT

' エンドユーザー → プロジェクト（中程度の線）
user ---> UC_PRJ_CREATE
user ---> UC_PRJ_SELECT
user ---> UC_PRJ_DELETE
user ---> UC_PRJ_EDIT

' エンドユーザー → 図表操作（長い線）
user ----> UC_CREATE
user ----> UC_EDIT
user ----> UC_PREVIEW
user ----> UC_SAVE
user ----> UC_EXPORT
user ----> UC_HISTORY
user ----> UC_RESTORE
user ----> UC_DELETE
user ----> UC_LEARN_SEARCH
user ----> UC_LEARN_VIEW

' エンドユーザー → AI機能（長い線）
user ----> UC_AI_QS
user ----> UC_AI_CHAT

' 開発者 → 管理機能（最長の線）
developer -----> UC_ADMIN_USER
developer -----> UC_ADMIN_CONTENT_REG
developer -----> UC_ADMIN_CONTENT_MGT
developer -----> UC_ADMIN_LLM
developer -----> UC_ADMIN_CONFIG

'==================================================
' 外部システム関連（ラベル付き）
'==================================================

' Supabase: 認証・データ保存
UC_LOGIN --> supabase : OAuth認証
UC_LOGOUT --> supabase : セッション終了
UC_ADMIN_USER --> supabase : ユーザーCRUD
UC_ADMIN_CONTENT_REG --> supabase : コンテンツ・ベクトル保存
UC_ADMIN_CONTENT_MGT --> supabase : コンテンツCRUD

' OpenRouter API: LLM呼び出し
UC_PREVIEW --> openrouter : AI自動修正(エラー時)
UC_SAVE --> openrouter : 用語一貫性チェック(自動)
UC_LEARN_SEARCH --> openrouter : RAG応答生成
UC_AI_QS --> openrouter : 図表生成
UC_AI_CHAT --> openrouter : チャット応答

' OpenAI API: Embedding
UC_ADMIN_CONTENT_REG --> openai : Embedding生成

'==================================================
' ユースケース間関連（7件全て）
'==================================================
UC_CREATE ..> UC_TEMPLATE : <<include>>
UC_CREATE ..> UC_PREVIEW : <<extends>>
UC_EDIT ..> UC_PREVIEW : <<extends>>
UC_RESTORE ..> UC_HISTORY : <<include>>
UC_LEARN_VIEW ..> UC_LEARN_SEARCH : <<include>>
UC_AI_QS ..> UC_CREATE : <<extends>>
UC_AI_CHAT ..> UC_LEARN_SEARCH : <<extends>>

'==================================================
' ノート（補足説明）
'==================================================
note right of UC_TEMPLATE : PlantUML/ワイヤーフレーム両方に適用
note right of UC_PREVIEW : PlantUML専用\nシステムが自動検証\n(構文エラー時はAI修正提案)
note right of UC_HISTORY : PlantUML/Excalidraw共通\nバージョン管理機能
note right of UC_LEARN_SEARCH : 編集中にPlantUML構文や\n書き方を検索（RAG）
note right of UC_AI_CHAT : 用語一貫性チェックは\n保存時にシステムが自動実行
note right of UC_ADMIN_CONTENT_REG : 登録時にEmbedding生成\n(OpenAI API)

@enduml
```

**レイアウト調整の適用:**

| 調整 | 適用内容 |
|------|----------|
| A. 方向変更 | `left to right direction`（横方向に展開） |
| D. 線の長さ | `-->` / `--->` / `---->` / `----->` で階層別に調整 |
| E. together | 4つの層（認証→プロジェクト→メイン機能→管理）で横グループ化 |

**情報量（全件維持）:**

| 項目 | 件数 |
|------|------|
| ユースケース | 23件 |
| 主アクター関連 | 18件（user）+ 5件（developer） |
| 外部システム関連 | 11件（ラベル付き） |
| ユースケース間関連 | 7件 |
| ノート | 6件 |

---

## 1. 概要図（全体俯瞰）

```plantuml
@startuml PlantUML_Studio_UseCase_Overview
'==================================================
' 概要図: 5パッケージの全体像
'==================================================
top to bottom direction
scale 1.0

skinparam actorStyle awesome
skinparam packageStyle rectangle
skinparam defaultFontSize 11
skinparam packageFontSize 12
skinparam usecaseFontSize 10

skinparam package {
    BackgroundColor<<認証>> #E8F5E9
    BackgroundColor<<プロジェクト>> #E3F2FD
    BackgroundColor<<図表操作>> #FFF3E0
    BackgroundColor<<AI機能>> #FCE4EC
    BackgroundColor<<管理機能>> #F3E5F5
}

'-- 主アクター（上部） --
actor "エンドユーザー" as user
actor "開発者" as developer

'-- システム境界 --
rectangle "PlantUML Studio" {

    '-- 上段: 認証・プロジェクト --
    together {
        package "1. 認証" <<認証>> {
            usecase "ログイン\nログアウト" as UC1
        }

        package "2. プロジェクト" <<プロジェクト>> {
            usecase "プロジェクト\nCRUD" as UC2
        }
    }

    '-- 中段: メイン機能 --
    together {
        package "3. 図表操作" <<図表操作>> {
            usecase "図表CRUD\nプレビュー\nエクスポート" as UC3
        }

        package "4. AI機能" <<AI機能>> {
            usecase "Question-Start\nAIチャット" as UC4
        }
    }

    '-- 下段: 管理機能 --
    package "5. 管理機能" <<管理機能>> {
        usecase "ユーザー管理\nコンテンツ管理" as UC5
    }
}

'-- 外部システム（右側） --
actor "Supabase" as supabase <<外部>>
actor "OpenRouter" as openrouter <<外部>>
actor "OpenAI" as openai <<外部>>

'-- 主アクター関連 --
user --> UC1
user --> UC2
user --> UC3
user --> UC4
developer --> UC5

'-- 外部システム関連 --
UC1 --> supabase
UC3 --> openrouter
UC4 --> openrouter
UC5 --> supabase
UC5 --> openai

'-- フロー説明（図の外にノートで表示） --
note bottom of UC1
  認証後 → プロジェクト選択
end note

note bottom of UC4
  AI生成 → 図表作成
end note

@enduml
```

---

## 2. 詳細図: 認証・プロジェクト管理

```plantuml
@startuml PlantUML_Studio_UseCase_Auth_Project
'==================================================
' 詳細図: 1.認証 + 2.プロジェクト管理
'==================================================
left to right direction

skinparam actorStyle awesome
skinparam packageStyle rectangle
skinparam defaultFontSize 11

skinparam package {
    BackgroundColor<<認証>> #E8F5E9
    BackgroundColor<<プロジェクト>> #E3F2FD
}

skinparam usecase {
    BackgroundColor #FAFAFA
    BorderColor #666666
}

'-- アクター --
actor "エンドユーザー" as user
actor "Supabase" as supabase <<外部システム>>

'-- システム境界 --
rectangle "PlantUML Studio" {

    package "1. 認証" <<認証>> {
        usecase "1-1 ログインする" as UC_LOGIN
        usecase "1-2 ログアウトする" as UC_LOGOUT
    }

    package "2. プロジェクト管理" <<プロジェクト>> {
        usecase "2-1 プロジェクトを作成する" as UC_PRJ_CREATE
        usecase "2-2 プロジェクトを選択する" as UC_PRJ_SELECT
        usecase "2-3 プロジェクトを編集する" as UC_PRJ_EDIT
        usecase "2-4 プロジェクトを削除する" as UC_PRJ_DELETE
    }
}

'-- 主アクター関連 --
user --> UC_LOGIN
user --> UC_LOGOUT
user --> UC_PRJ_CREATE
user --> UC_PRJ_SELECT
user --> UC_PRJ_DELETE
user --> UC_PRJ_EDIT

'-- 外部システム関連 --
UC_LOGIN --> supabase : OAuth認証\n(GitHub/Google)
UC_LOGOUT --> supabase : セッション終了

'-- ノート --
note right of UC_LOGIN
  認証方式:
  - OAuth (GitHub/Google)
end note

note right of UC_PRJ_CREATE
  プロジェクト = 図表のグループ
  作成時は名前のみ設定
end note

@enduml
```

---

## 3. 詳細図: 図表操作

```plantuml
@startuml PlantUML_Studio_UseCase_Diagram_Operations
'==================================================
' 詳細図: 3.図表操作（PlantUML・Excalidraw）
' レイアウト: 縦スタック（カテゴリ別）
'==================================================
left to right direction

skinparam actorStyle awesome
skinparam packageStyle rectangle
skinparam defaultFontSize 10
skinparam usecaseFontSize 9

skinparam package {
    BackgroundColor #FFF3E0
    BackgroundColor<<基本操作>> #E3F2FD
    BackgroundColor<<出力操作>> #E8F5E9
    BackgroundColor<<PlantUML専用>> #FCE4EC
    BackgroundColor<<学習支援>> #F3E5F5
}

skinparam usecase {
    BackgroundColor #FAFAFA
    BorderColor #666666
}

skinparam note {
    BackgroundColor #FFFDE7
    BorderColor #FBC02D
    FontSize 8
}

'-- アクター --
actor "エンドユーザー" as user

'-- システム境界 --
rectangle "PlantUML Studio" {

    package "3. 図表操作（PlantUML・Excalidraw）" {

        '========================================
        ' 3-A. 基本操作（共通）
        '========================================
        package "3-A. 基本操作（共通）" <<基本操作>> {
            usecase "3-1 図表を作成する" as UC_CREATE
            usecase "3-2 テンプレートを選択する" as UC_TEMPLATE
            usecase "3-3 図表を編集する" as UC_EDIT
        }

        '========================================
        ' 3-B. 出力・管理操作（共通）
        '========================================
        package "3-B. 出力・管理（共通）" <<出力操作>> {
            usecase "3-5 図表を保存する" as UC_SAVE
            usecase "3-6 図表をエクスポートする" as UC_EXPORT
            usecase "3-7 バージョン履歴を確認する" as UC_HISTORY
            usecase "3-8 過去バージョンを復元する" as UC_RESTORE
            usecase "3-9 図表を削除する" as UC_DELETE
        }

        '========================================
        ' 3-C. PlantUML専用機能
        '========================================
        package "3-C. PlantUML専用" <<PlantUML専用>> {
            usecase "3-4 図表をプレビューする" as UC_PREVIEW
        }

        '========================================
        ' 3-D. 学習支援機能
        '========================================
        package "3-D. 学習支援" <<学習支援>> {
            usecase "3-10 学習コンテンツを検索する" as UC_LEARN_SEARCH
            usecase "3-11 学習コンテンツを確認する" as UC_LEARN_VIEW
        }
    }
}

'-- 外部システム --
actor "OpenRouter API" as openrouter <<外部システム>>

'-- 主アクター関連（基本操作） --
user --> UC_CREATE
user --> UC_EDIT

'-- 主アクター関連（出力・管理操作） --
user --> UC_SAVE
user --> UC_EXPORT
user --> UC_HISTORY
user --> UC_RESTORE
user --> UC_DELETE

'-- 主アクター関連（PlantUML専用） --
user --> UC_PREVIEW

'-- 主アクター関連（学習支援） --
user --> UC_LEARN_SEARCH
user --> UC_LEARN_VIEW

'-- 外部システム関連 --
UC_PREVIEW --> openrouter : AI自動修正\n(エラー時)
UC_SAVE --> openrouter : 用語一貫性\nチェック(自動)
UC_LEARN_SEARCH --> openrouter : RAG応答生成

'-- ユースケース間関連 --
UC_CREATE ..> UC_TEMPLATE : <<include>>
UC_CREATE ..> UC_PREVIEW : <<extends>>
UC_EDIT ..> UC_PREVIEW : <<extends>>
UC_RESTORE ..> UC_HISTORY : <<include>>
UC_LEARN_VIEW ..> UC_LEARN_SEARCH : <<include>>

'-- ノート --
note right of UC_TEMPLATE
  PlantUML/ワイヤーフレーム
  両方に適用
end note

note right of UC_PREVIEW
  PlantUML専用
  構文自動検証
  エラー時はAI修正提案
end note

note right of UC_HISTORY
  PlantUML/Excalidraw共通
  SHA-256ハッシュで
  バージョン管理
end note

note right of UC_LEARN_SEARCH
  RAG検索
  編集中のヘルプ機能
  pgvectorでベクトル検索
end note

note right of UC_SAVE
  手動保存のみ: Ctrl+S
  保存時に用語一貫性チェック
end note

@enduml
```

---

## 4. 詳細図: AI機能

```plantuml
@startuml PlantUML_Studio_UseCase_AI
'==================================================
' 詳細図: 4.AI機能
'==================================================
left to right direction

skinparam actorStyle awesome
skinparam packageStyle rectangle
skinparam defaultFontSize 11

skinparam package {
    BackgroundColor<<AI機能>> #FCE4EC
    BackgroundColor<<図表操作>> #FFF3E0
}

skinparam usecase {
    BackgroundColor #FAFAFA
    BorderColor #666666
}

skinparam note {
    BackgroundColor #FFFDE7
    BorderColor #FBC02D
}

'-- アクター --
actor "エンドユーザー" as user
actor "OpenRouter API" as openrouter <<外部システム>>

'-- システム境界 --
rectangle "PlantUML Studio" {

    package "4. AI機能" <<AI機能>> {
        usecase "4-1 AI Question-Startで\n図表を生成する" as UC_AI_QS
        usecase "4-2 目的別AIチャットを\n利用する" as UC_AI_CHAT
    }

    package "3. 図表操作（参照）" <<図表操作>> {
        usecase "3-1 図表を作成する" as UC_CREATE
        usecase "3-10 学習コンテンツを検索する" as UC_LEARN_SEARCH
    }
}

'-- 主アクター関連 --
user --> UC_AI_QS
user --> UC_AI_CHAT

'-- 外部システム関連 --
UC_AI_QS --> openrouter : 図表生成
UC_AI_CHAT --> openrouter : チャット応答

'-- ユースケース間関連 --
UC_AI_QS ..> UC_CREATE : <<extends>>\nAI生成後に図表作成
UC_AI_CHAT ..> UC_LEARN_SEARCH : <<extends>>\n学習コンテンツを提案

'-- ノート --
note right of UC_AI_QS
  **AI Question-Start フロー**
  1. ユーザーが目的を入力
  2. AIが質問で要件を引き出す
  3. テンプレート提案
  4. PlantUMLコード生成
end note

note right of UC_AI_CHAT
  **目的別AIチャット**
  - フェーズ認識（要件定義→設計→実装）
  - 図表セット提案
  - 用語一貫性チェック（保存時自動）
end note

@enduml
```

---

## 5. 詳細図: 管理機能

```plantuml
@startuml PlantUML_Studio_UseCase_Admin
'==================================================
' 詳細図: 5.管理機能（開発者専用）
'==================================================
left to right direction

skinparam actorStyle awesome
skinparam packageStyle rectangle
skinparam defaultFontSize 11

skinparam package {
    BackgroundColor #F3E5F5
}

skinparam usecase {
    BackgroundColor #FAFAFA
    BorderColor #666666
}

skinparam note {
    BackgroundColor #FFFDE7
    BorderColor #FBC02D
}

'-- アクター --
actor "開発者" as developer
actor "Supabase" as supabase <<外部システム>>
actor "OpenAI API" as openai <<外部システム>>

'-- システム境界 --
rectangle "PlantUML Studio" {

    package "5. 管理機能" {
        usecase "5-1 ユーザーを管理する" as UC_ADMIN_USER
        usecase "5-2 学習コンテンツを登録する" as UC_ADMIN_CONTENT_REG
        usecase "5-3 学習コンテンツを管理する" as UC_ADMIN_CONTENT_MGT
        usecase "5-4 LLMモデルを切り替える" as UC_ADMIN_LLM
        usecase "5-5 システム設定を変更する" as UC_ADMIN_CONFIG
    }
}

'-- 主アクター関連 --
developer --> UC_ADMIN_USER
developer --> UC_ADMIN_CONTENT_REG
developer --> UC_ADMIN_CONTENT_MGT
developer --> UC_ADMIN_LLM
developer --> UC_ADMIN_CONFIG

'-- 外部システム関連 --
UC_ADMIN_USER --> supabase : ユーザーCRUD
UC_ADMIN_CONTENT_REG --> supabase : コンテンツ・ベクトル保存
UC_ADMIN_CONTENT_REG --> openai : Embedding生成
UC_ADMIN_CONTENT_MGT --> supabase : コンテンツCRUD

'-- ノート --
note right of UC_ADMIN_CONTENT_REG
  **学習コンテンツ登録フロー**
  1. コンテンツ（Markdown/PDF）アップロード
  2. OpenAI APIでEmbedding生成
  3. Supabase pgvectorに保存
  4. RAG検索で利用可能に
end note

note right of UC_ADMIN_LLM
  **対象モデル**
  - GPT-4o-mini
  - Claude
  - Gemini
  (OpenRouter経由で切替)
end note

@enduml
```

---

## ユースケース一覧

### 1. 認証

| ID | ユースケース | 説明 | 主アクター | 二次アクター |
|----|-------------|------|-----------|-------------|
| 1-1 | ログインする | OAuth（GitHub/Google）による認証 | エンドユーザー | Supabase Auth |
| 1-2 | ログアウトする | セッション終了 | エンドユーザー | Supabase Auth |

### 2. プロジェクト管理

| ID | ユースケース | 説明 | 主アクター | 二次アクター |
|----|-------------|------|-----------|-------------|
| 2-1 | プロジェクトを作成する | 図表をグループ化する単位を作成 | エンドユーザー | - |
| 2-2 | プロジェクトを選択する | 作業対象プロジェクトの切替 | エンドユーザー | - |
| 2-3 | プロジェクトを編集する | プロジェクト名の変更 | エンドユーザー | - |
| 2-4 | プロジェクトを削除する | プロジェクトと配下図表の削除 | エンドユーザー | - |

### 3. 図表操作（PlantUML・Excalidraw）

※検証（構文チェック）はプレビュー時にシステムが自動実行

| ID | ユースケース | 説明 | 対象 | 主アクター | 二次アクター |
|----|-------------|------|------|-----------|-------------|
| 3-1 | 図表を作成する | 新規図表作成 | 共通 | エンドユーザー | - |
| 3-2 | テンプレートを選択する | テンプレートから図表を開始 | 共通 | エンドユーザー | - |
| 3-3 | 図表を編集する | Monaco Editor(PlantUML) / Excalidraw UI(ワイヤーフレーム) | 共通 | エンドユーザー | - |
| 3-4 | 図表をプレビューする | SVG/PNGでリアルタイム表示（自動検証含む） | PlantUML専用 | エンドユーザー | OpenRouter API |
| 3-5 | 図表を保存する | 手動保存（Ctrl+S）※用語一貫性チェック自動実行 | 共通 | エンドユーザー | OpenRouter API |
| 3-6 | 図表をエクスポートする | PDF/PNG/SVG出力 | 共通 | エンドユーザー | - |
| 3-7 | バージョン履歴を確認する | 過去バージョン一覧表示 **（v3）** | 共通 | エンドユーザー | - |
| 3-8 | 過去バージョンを復元する | 指定バージョンに戻す **（v3）** | 共通 | エンドユーザー | - |
| 3-9 | 図表を削除する | 図表の削除 | 共通 | エンドユーザー | - |
| 3-10 | 学習コンテンツを検索する | PlantUML構文・書き方のRAG検索 | 共通 | エンドユーザー | OpenRouter API |
| 3-11 | 学習コンテンツを確認する | 検索結果の学習コンテンツを表示 | 共通 | エンドユーザー | - |

### 4. AI機能

※用語一貫性チェックは保存時（3-5）にシステムが自動実行し、結果をユーザーに通知

| ID | ユースケース | 説明 | 主アクター | 二次アクター |
|----|-------------|------|-----------|-------------|
| 4-1 | AI Question-Startで図表を生成する | AIが質問→テンプレート提案→生成 | エンドユーザー | OpenRouter API |
| 4-2 | 目的別AIチャットを利用する | フェーズ認識、図表セット提案 | エンドユーザー | OpenRouter API |

### 5. 管理機能（開発者専用）

| ID | ユースケース | 説明 | 主アクター | 二次アクター |
|----|-------------|------|-----------|-------------|
| 5-1 | ユーザーを管理する | ユーザー登録・CRUD、権限管理 | 開発者 | Supabase |
| 5-2 | 学習コンテンツを登録する | 学習資料をEmbedding化して登録 | 開発者 | OpenAI API, Supabase |
| 5-3 | 学習コンテンツを管理する | 学習資料のCRUD、カテゴリ管理 | 開発者 | Supabase |
| 5-4 | LLMモデルを切り替える | 全サービス一括でモデル変更 | 開発者 | - |
| 5-5 | システム設定を変更する | その他システム設定 | 開発者 | - |

---

## アクター一覧

### 主アクター（Primary Actors）

| アクター | 役割 | 対象ユースケース |
|---------|------|-----------------|
| エンドユーザー | 図表作成・編集 | 1〜4（18件） |
| 開発者 | システム管理 | 5（5件） |

### 二次アクター（Supporting Actors / 外部システム）

| アクター | 役割 | 関連ユースケース |
|---------|------|-----------------|
| Supabase Auth | OAuth認証、セッション管理、ユーザーCRUD | 1-1, 1-2, 5-1 |
| OpenRouter API | LLM呼び出し（図表生成、チャット、AI修正、RAG応答、用語一貫性チェック） | 3-4, 3-5, 3-10, 4-1, 4-2 |
| OpenAI API | Embedding生成（コンテンツ登録時のベクトル化） | 5-2 |

---

## ユースケース間の関連

| 関連 | タイプ | 説明 |
|------|--------|------|
| 3-1 → 3-2 | <<include>> | 作成時にテンプレート選択 |
| 3-1 → 3-4 | <<extends>> | 作成後にプレビュー（PlantUML） |
| 3-3 → 3-4 | <<extends>> | 編集結果を即時プレビュー（PlantUML） |
| 3-8 → 3-7 | <<include>> | 復元は履歴確認を前提 |
| 3-11 → 3-10 | <<include>> | 確認は検索を前提 |
| 4-1 → 3-1 | <<extends>> | AI生成後に図表作成へ |
| 4-2 → 3-10 | <<extends>> | AIチャットが学習コンテンツを検索・提案 |

---

## 優先度（MVP vs 将来）

### MVP（Phase 1）

| カテゴリ | ユースケース | 理由 |
|---------|-------------|------|
| 1. 認証 | 1-1, 1-2 | 基本機能 |
| 2. プロジェクト | 2-1, 2-2, 2-3, 2-4 | 基本機能 |
| 3. 図表操作（PlantUML・Excalidraw） | 3-1〜3-6, 3-9 | コア機能 |
| 4. AI機能 | 4-1 | 差別化機能 |

### Phase 2以降

| カテゴリ | ユースケース | 理由 |
|---------|-------------|------|
| 3. 図表操作（PlantUML・Excalidraw） | 3-10, 3-11 | 学習支援機能 |
| 4. AI機能 | 4-2 | 拡張機能 |
| 5. 管理機能 | 5-1〜5-5 | 運用機能 |

### v3（DB追加後）

| カテゴリ | ユースケース | 理由 |
|---------|-------------|------|
| 3. 図表操作 | 3-7, 3-8 | バージョン管理（DB必須） |

---

## ユースケース数サマリ

| カテゴリ | 件数 | MVP | Phase 2 | v3 |
|---------|------|-----|---------|-----|
| 1. 認証 | 2 | 2 | - | - |
| 2. プロジェクト管理 | 4 | 4 | - | - |
| 3. 図表操作（PlantUML・Excalidraw） | 11 | 7 | 2 | 2 |
| 4. AI機能 | 2 | 1 | 1 | - |
| 5. 管理機能 | 5 | - | 5 | - |
| **合計** | **24** | **14** | **8** | **2** |

> **v3 UC**: 3-7（バージョン履歴確認）、3-8（バージョン復元）はDB追加後に実装

---

## 設計判断の根拠

### 1. 図表操作の統合（3.と4.の統合）

**判断**: PlantUMLとワイヤーフレームを「3. 図表操作」として統合

**理由**:
- ユースケース図はユーザーの「目的」を表現するもの
- 「図表を作成したい」「テンプレートから始めたい」という目的は共通
- 実装の違い（Monaco vs Excalidraw）はユースケースレベルでは表現すべきではない
- PlantUML専用機能（プレビュー自動検証）はノートで明示
- バージョン管理はPlantUML/Excalidraw共通機能

### 2. テンプレート選択の追加

**判断**: 「テンプレートを選択する」を独立ユースケースとして追加

**理由**:
- テンプレート選択は明確なユーザーアクション
- 作成時の必須ステップとして<<include>>関連で表現

### 3. システムをアクターにしない

**判断**: 「システム」はアクターとして登場させない

**理由**:
- 標準UMLでは、システム自体は境界であり、アクターではない
- 自動処理（検証など）はノートで表現
- Timer/Schedulerのような時間起動型の場合のみアクターとなる

### 4. 外部システムを二次アクターとして表現

**判断**: Supabase Auth、OpenRouter API、OpenAI APIを二次アクターとして追加

**理由**:
- 外部システムはSupporting Actor（二次アクター）として表現可能
- ユースケースの完遂に必要な外部依存関係を明示
- コンテキスト図との整合性を維持

### 5. 学習コンテンツを図表操作に配置

**判断**: 学習コンテンツの検索・確認を「3. 図表操作」に追加

**理由**:
- 図表編集中に「書き方がわからない」場面で利用するワークフロー
- AI機能ではなく、図表操作の一部として位置づけ
- RAG技術を利用するが、ユーザー視点では「ヘルプ機能」

### 6. 作成・編集とプレビューの関連

**判断**: UC_CREATE、UC_EDITからUC_PREVIEWへの<<extends>>関連を追加

**理由**:
- PlantUMLでは作成・編集の結果としてプレビューが行われる
- リアルタイムプレビューは編集体験の一部
- ワイヤーフレームには適用されない（Excalidrawは直接描画）

### 7. 用語一貫性チェックの自動化

**判断**: 「用語一貫性をチェックする」をユーザー操作から削除し、保存時の自動処理に変更

**理由**:
- ユーザーが明示的に実行・指示するものではない
- 保存時にシステムが自動的に実行すべき機能
- 検出結果はユーザーに通知し、修正は任意
- 構文検証（プレビュー時自動）と同様のパターン

### 8. 階層化（概要図＋詳細図）

**判断**: 1つの大きな図から、概要図＋4つの詳細図に分割

**理由**:
- 23ユースケースを1図に収めると視認性が低下
- 概要図で全体像を把握、詳細図で個別機能を確認
- レビューや説明時に適切な粒度で提示可能

---

## レビュー観点

1. **漏れているユースケースはあるか？**
2. **不要なユースケースはあるか？**
3. **ユースケースの粒度は適切か？**
4. **図表操作の統合は適切か？**
5. **外部システムの表現は適切か？**
6. **MVP vs Phase 2の優先度判断は妥当か？**
7. **階層化（概要図＋詳細図）は適切か？**
