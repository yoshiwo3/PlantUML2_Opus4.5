# PlantUML Studio 設計図表集

**作成日**: 2025-11-30
**バージョン**: 1.0

---

## 目次

1. [コンポーネント図](#1-コンポーネント図)
2. [ユースケース図](#2-ユースケース図)
3. [業務フロー図](#3-業務フロー図)
4. [データフロー図](#4-データフロー図)
5. [ワイヤーフレーム](#5-ワイヤーフレーム)
6. [画面遷移図](#6-画面遷移図)
7. [クラス図](#7-クラス図)
8. [業務フロー図・データフロー図対比表](#8-業務フロー図データフロー図対比表)
9. [CRUD表（機能×データマトリクス）](#9-crud表機能データマトリクス)
10. [シーケンス図](#10-シーケンス図)
11. [外部インターフェース一覧](#11-外部インターフェース一覧)

---

## アクター定義

### 人間アクター

| アクター | 説明 | 継承関係 |
|---------|------|----------|
| エンドユーザー | 図表作成・編集を行う一般ユーザー（非エンジニア・エンジニア） | 基底 |
| 開発者 | 学習コンテンツ・テンプレートを作成する | エンドユーザーを継承 |
| 管理者 | システム監視・ユーザー管理を行う | エンドユーザーを継承 |

### システムアクター

| アクター | 説明 |
|---------|------|
| Supabase | 認証・データ保存・ストレージ |
| AI/LLM | 自然言語処理・コード生成 |
| Context7 MCP | 外部ドキュメント取得 |
| Playwright MCP | スクリーンショット生成 |
| Excalidraw | ワイヤーフレーム作成（TD-015採用） |

---

## 1. コンポーネント図

```plantuml
@startuml component_diagram
!define RECTANGLE class

title PlantUML Studio - コンポーネント図

skinparam component {
  BackgroundColor<<frontend>> LightCyan
  BackgroundColor<<backend>> LightGreen
  BackgroundColor<<external>> LightYellow
  BackgroundColor<<ai>> Lavender
}

package "フロントエンド" <<frontend>> {
  component "Next.js App Router" as nextjs {
    component "Pages" as pages
    component "Components" as components
    component "Hooks" as hooks
  }

  component "Monaco Editor" as monaco
  component "Excalidraw Editor" as excalidraw #LightPink
  component "Preview Panel" as preview
  component "AI Chat Panel" as chatPanel
}

package "バックエンド" <<backend>> {
  component "API Routes" as apiRoutes {
    component "/api/diagrams" as diagramsApi
    component "/api/ai/generate" as aiApi
    component "/api/validate" as validateApi
    component "/api/export" as exportApi
  }

  component "PlantUML Validator" as validator {
    component "node-plantuml" as nodePlantuml
    component "Java 17 Runtime" as javaRuntime
    component "Graphviz" as graphviz
  }
}

package "外部サービス" <<external>> {
  component "Supabase" as supabase {
    database "PostgreSQL" as postgres
    component "Auth" as auth
    component "Storage" as storage
    component "Realtime" as realtime
    component "Edge Functions" as edgeFn
  }
}

package "AI/MCP" <<ai>> {
  component "OpenRouter API" as openrouter
  component "Context7 MCP" as context7
  component "Playwright MCP" as playwright
}

' フロントエンド内部
pages --> components
pages --> hooks
components --> monaco
components --> excalidraw
components --> preview
components --> chatPanel

' フロントエンド → バックエンド
monaco --> validateApi : コード検証
chatPanel --> aiApi : AI生成リクエスト
preview --> diagramsApi : 図表取得
pages --> exportApi : エクスポート

' バックエンド内部
validateApi --> validator
validator --> nodePlantuml
nodePlantuml --> javaRuntime
javaRuntime --> graphviz

' バックエンド → 外部サービス
diagramsApi --> postgres : CRUD
apiRoutes --> auth : 認証
diagramsApi --> storage : 画像保存
aiApi --> openrouter : LLM呼び出し

' AI/MCP連携
openrouter --> context7 : Function Calling
pages --> playwright : スクショ生成

@enduml
```

---

## 2. ユースケース図

```plantuml
@startuml usecase_diagram

title PlantUML Studio - ユースケース図

skinparam packageStyle rectangle
skinparam actorStyle awesome

' ===== アクター =====

' 人間アクター
actor "エンドユーザー" as endUser #LightBlue
actor "開発者" as developer #LightGreen
actor "管理者" as admin #LightCoral

' 外部システムアクター
actor "Supabase" as supabase <<system>> #LightYellow
actor "AI/LLM" as llm <<system>> #Lavender
actor "Context7\nMCP" as context7 <<system>> #LightSalmon

' アクター汎化（継承関係）
endUser <|-- developer
endUser <|-- admin

' ===== システム境界 =====
package "PlantUML Studio" {

  ' --- エンドユーザー向け機能 ---
  usecase "アカウントを管理する" as UC0
  usecase "新しい図表を作成する" as UC1
  usecase "業務カテゴリを選択する" as UC1_1
  usecase "図表タイプを推薦する" as UC1_2
  usecase "テンプレートを適用する" as UC1_3

  usecase "図表を開く" as UC2
  usecase "図表を編集する" as UC3
  usecase "コードを検証する" as UC4
  usecase "プレビューを表示する" as UC5

  ' AI支援
  usecase "構文について質問する" as UC6
  usecase "図表タイプを推薦する（AI）" as UC7
  usecase "コード修正を提案する" as UC8

  ' プロジェクト管理
  usecase "プロジェクトを管理する" as UC9
  usecase "学習コンテンツを検索する" as UC10
  usecase "図表をエクスポートする" as UC11

  ' マイテンプレート
  usecase "マイテンプレートを作成する" as UC13
  usecase "マイテンプレートを管理する" as UC14

  ' Excalidrawワイヤーフレーム（TD-015）
  usecase "ワイヤーフレームを作成する" as UC15
  usecase "ワイヤーフレームをAI生成する" as UC16
  usecase "ワイヤーフレームをエクスポートする" as UC17

  ' --- 開発者向け機能 ---
  usecase "学習コンテンツを作成する" as UC20
  usecase "テンプレートを作成する" as UC23
  usecase "テンプレートを更新する" as UC24

  ' --- 管理者向け機能 ---
  usecase "システムを監視する" as UC30
  usecase "ユーザーを管理する" as UC31
  usecase "テンプレートを承認する" as UC33

  ' --- ユースケース間の関係 ---
  UC1 ..> UC1_1 : <<include>>
  UC1 ..> UC1_2 : <<include>>
  UC1 ..> UC1_3 : <<include>>
  UC3 ..> UC4 : <<include>>
  UC3 ..> UC5 : <<include>>
}

' ===== アクターとユースケースの関連 =====

' エンドユーザー
endUser --> UC0
endUser --> UC1
endUser --> UC2
endUser --> UC3
endUser --> UC6
endUser --> UC7
endUser --> UC8
endUser --> UC9
endUser --> UC10
endUser --> UC11
endUser --> UC13
endUser --> UC14
endUser --> UC15
endUser --> UC16
endUser --> UC17

' 開発者
developer --> UC20
developer --> UC23
developer --> UC24

' 管理者
admin --> UC30
admin --> UC31
admin --> UC33

' ===== 外部システムとの関連 =====
UC0 --> supabase
UC3 --> supabase
UC6 --> llm
UC7 --> llm
UC8 --> llm
UC10 --> context7
UC15 --> supabase : Excalidraw JSON保存
UC16 --> llm : ワイヤーフレームAI生成

@enduml
```

---

## 3. 業務フロー図

### 3.1 図表作成フロー

```plantuml
@startuml business_flow_create

title 業務フロー図 - 図表作成

|エンドユーザー|
start
:ログイン;

|システム|
:認証処理;

|エンドユーザー|
:「新規作成」をクリック;

|システム|
:業務カテゴリ選択画面表示;

|エンドユーザー|
:業務カテゴリを選択;
note right
  - システム開発
  - 業務分析
  - プロジェクト管理
  - ドキュメント作成
  - 教育・研修
  - その他
end note

|システム|
:図表タイプを推薦;
:テンプレート一覧表示;

|エンドユーザー|
:テンプレートを選択;

|システム|
:エディタ画面を開く;
:テンプレートコードを適用;

|エンドユーザー|
:PlantUMLコードを編集;

|システム|
:リアルタイム検証;
if (構文エラー?) then (あり)
  :エラーをハイライト表示;
  :AI修正提案を表示;
  |エンドユーザー|
  :修正を適用または手動修正;
else (なし)
  :プレビュー更新;
endif

|エンドユーザー|
:保存ボタンをクリック;

|システム|
:バージョン保存;
:SHA-256ハッシュ生成;

stop

@enduml
```

### 3.2 AI支援フロー

```plantuml
@startuml business_flow_ai

title 業務フロー図 - AI支援

|エンドユーザー|
start
:AIチャットパネルを開く;
:質問を入力;
note right
  例：
  - 「このエラーの意味は？」
  - 「クラス図に継承を追加して」
  - 「シーケンス図に変換して」
end note

|システム|
:質問をAI APIへ送信;

|AI/LLM|
:コンテキスト解析;
:PlantUML構文知識参照;

if (Context7参照必要?) then (はい)
  |Context7 MCP|
  :最新構文情報取得;
endif

|AI/LLM|
:回答生成;
:コード修正提案生成;

|システム|
:回答をストリーミング表示;
:修正提案をDiff形式で表示;

|エンドユーザー|
if (修正を適用?) then (はい)
  :「適用」ボタンをクリック;
  |システム|
  :コードを更新;
  :検証実行;
  :プレビュー更新;
else (いいえ)
  :手動で編集続行;
endif

stop

@enduml
```

### 3.3 検証ループフロー

```plantuml
@startuml business_flow_validation

title 業務フロー図 - 検証ループ

|エンドユーザー|
start
:コードを編集;

|システム|
:デバウンス処理（500ms）;
:検証API呼び出し;

|PlantUML Validator|
:node-plantuml実行;
:Java 17 + Graphviz処理;

if (構文エラー?) then (あり)
  :stderrからエラー抽出;
  :エラー行番号特定;

  |システム|
  :Monaco Editorにマーカー設置;
  :エラーメッセージ表示;

  if (AI自動修正有効?) then (はい)
    |AI/LLM|
    :エラー解析;
    :修正コード生成;

    |システム|
    :修正提案表示;

    |エンドユーザー|
    if (修正承認?) then (はい)
      :修正を適用;
      |システム|
      :再検証（最大3回）;
    else (いいえ)
      :手動修正;
    endif
  endif

else (なし)
  :SVG/PNG生成;

  |システム|
  :プレビュー更新;
  :処理時間表示;
  note right
    目標: 500ms以内
  end note
endif

stop

@enduml
```

### 3.4 Excalidrawワイヤーフレーム作成フロー（TD-015）

```plantuml
@startuml business_flow_excalidraw

title 業務フロー図 - Excalidrawワイヤーフレーム作成

|エンドユーザー|
start
:プロジェクトを開く;

|システム|
:プロジェクト画面表示;

|エンドユーザー|
:「ワイヤーフレーム作成」をクリック;

|システム|
:Excalidrawエディタを開く;
note right
  Dynamic Import（SSR無効化）
  @excalidraw/excalidraw
end note

|エンドユーザー|
if (AI生成を使用?) then (はい)
  :自然言語で画面を説明;
  note right
    例：「ログインフォーム
    - ユーザー名入力欄
    - パスワード入力欄
    - ログインボタン」
  end note

  |AI/LLM|
  :説明からExcalidraw JSON生成;
  note right
    中レベルLLM使用
    （GPT-4o-mini / Claude 3.5 Haiku）
    成功率: 80-90%
    トークン消費: 80-100
  end note

  |システム|
  :生成されたJSONをExcalidrawに適用;

else (いいえ)
  :手動で描画;
  note right
    ローファイワイヤーフレーム
    手書き風スタイル
    グレースケールモード
  end note
endif

|エンドユーザー|
:ワイヤーフレームを編集・調整;

|システム|
:リアルタイムプレビュー;

|エンドユーザー|
:「保存」をクリック;

|システム|
:Excalidraw JSONをSupabase Storageに保存;
note right
  保存パス:
  wireframes/<project_id>/<diagram_id>.excalidraw
end note

|エンドユーザー|
if (エクスポート?) then (はい)
  :エクスポート形式を選択;
  |システム|
  :PNG/SVG/Excalidraw JSON出力;
endif

stop

@enduml
```

---

## 4. データフロー図

### 4.1 レベル0（コンテキスト図）

```plantuml
@startuml dfd_level0

title データフロー図 - レベル0（コンテキスト図）

' 外部エンティティ
rectangle "エンドユーザー" as user #LightBlue
rectangle "開発者" as dev #LightGreen
rectangle "管理者" as admin #LightCoral
rectangle "AI/LLM" as ai #Lavender
rectangle "Context7 MCP" as context7 #LightSalmon

' プロセス（システム）
storage "PlantUML Studio" as system #AliceBlue

' データストア
database "Supabase" as db #LightYellow

' データフロー
user --> system : PlantUMLコード\n図表作成リクエスト
system --> user : SVG/PNG画像\nエラーメッセージ

dev --> system : 学習コンテンツ\nテンプレート
system --> dev : 承認ステータス

admin --> system : 管理コマンド
system --> admin : システムログ\nユーザー情報

system <--> db : 図表データ\nユーザー情報\nバージョン履歴

system --> ai : 質問\nコード
ai --> system : AI回答\n修正提案

ai --> context7 : ドキュメント検索
context7 --> ai : PlantUML構文情報

@enduml
```

### 4.2 レベル1（主要プロセス）

```plantuml
@startuml dfd_level1

title データフロー図 - レベル1（主要プロセス）

' 外部エンティティ
rectangle "エンドユーザー" as user #LightBlue
rectangle "AI/LLM" as ai #Lavender

' プロセス
usecase "1.0\n認証処理" as P1
usecase "2.0\n図表編集" as P2
usecase "3.0\n検証処理" as P3
usecase "4.0\nAI支援" as P4
usecase "5.0\nファイル管理" as P5
usecase "6.0\nエクスポート" as P6

' データストア
database "D1: users" as D1
database "D2: diagrams" as D2
database "D3: diagram_versions" as D3
database "D4: projects" as D4

' データフロー
user --> P1 : ログイン情報
P1 --> D1 : ユーザー照会
D1 --> P1 : ユーザー情報
P1 --> user : 認証トークン

user --> P2 : PlantUMLコード
P2 --> P3 : コード検証依頼
P3 --> P2 : 検証結果
P2 --> user : プレビュー画像

user --> P4 : 質問
P4 --> ai : プロンプト
ai --> P4 : AI回答
P4 --> user : 回答・修正提案

P2 --> P5 : 保存リクエスト
P5 --> D2 : 図表データ
P5 --> D3 : バージョンデータ

user --> P6 : エクスポート依頼
D2 --> P6 : 図表データ
P6 --> user : PNG/SVG/PDF

@enduml
```

---

## 5. ワイヤーフレーム

### 5.1 メイン画面（エディタ）

```plantuml
@startuml wireframe_editor

salt
{
  {T
    + PlantUML Studio | ファイル | 編集 | 表示 | AI | ヘルプ | [ユーザー名 ▼]
  }
  {
    {
      == プロジェクト ==
      {T
        + マイプロジェクト
        ++ システム設計
        +++ class_diagram.puml
        +++ sequence_login.puml
        ++ 業務フロー
        +++ activity_order.puml
      }
    } | {
      == エディタ ==
      {+
        @startuml
        class User {
          +id: UUID
          +name: String
          +email: String
        }
        @enduml
      }
      --
      [ 行 5, 列 12 ] | [ UTF-8 ] | [ PlantUML ]
    } | {
      == プレビュー ==
      {+
        [    SVG プレビュー    ]
        [                      ]
        [   ┌──────────┐       ]
        [   │  User    │       ]
        [   ├──────────┤       ]
        [   │ +id      │       ]
        [   │ +name    │       ]
        [   │ +email   │       ]
        [   └──────────┘       ]
      }
      --
      [ PNG ] [ SVG ] [ PDF ]
    }
  }
  {
    == AIチャット ==
    {+
      [AI] クラス図にメソッドを追加しますか？

      [あなた] はい、getUserById()を追加して

      [AI] 了解しました。以下の修正を提案します...
    }
    --
    { 質問を入力... | [送信] }
  }
}

@enduml
```

### 5.2 新規作成画面（オンボーディング）

```plantuml
@startuml wireframe_onboarding

salt
{
  {T
    + PlantUML Studio - 新規図表作成
  }
  ==
  {
    <b>業務カテゴリを選択してください</b>
    ---
    {
      (X) システム開発
      () 業務分析
      () プロジェクト管理
      () ドキュメント作成
      () 教育・研修
      () その他
    }
  }
  ==
  {
    <b>推奨される図表タイプ</b>
    ---
    {T
      + クラス図 | ★★★ | システム構造の可視化に最適
      + シーケンス図 | ★★☆ | 処理フローの表現に
      + コンポーネント図 | ★★☆ | アーキテクチャ設計に
    }
  }
  ==
  {
    <b>テンプレートを選択</b>
    ---
    [基本クラス図] | [継承付きクラス図] | [インターフェース図]
  }
  ==
  { [キャンセル] | [作成開始] }
}

@enduml
```

### 5.3 Excalidrawワイヤーフレーム画面（TD-015）

```plantuml
@startuml wireframe_excalidraw

salt
{
  {T
    + PlantUML Studio - ワイヤーフレーム | [戻る] | [エクスポート ▼]
  }
  ==
  {
    {
      == ツール ==
      [ 選択 ]
      [ 四角形 ]
      [ 円 ]
      [ 線 ]
      [ テキスト ]
      [ フリーハンド ]
      --
      <b>スタイル</b>
      (X) 手書き風
      () シャープ
      --
      (X) グレースケール
      () カラー
    } | {
      == Excalidrawキャンバス ==
      {+
        [                                    ]
        [   ┌────────────────────┐           ]
        [   │   ログインフォーム  │           ]
        [   ├────────────────────┤           ]
        [   │ ユーザー名: [____] │           ]
        [   │ パスワード: [____] │           ]
        [   │                    │           ]
        [   │    [ ログイン ]    │           ]
        [   │                    │           ]
        [   │ パスワードを忘れた │           ]
        [   └────────────────────┘           ]
        [                                    ]
      }
    }
  }
  ==
  {
    <b>AI生成</b>
    { 画面を自然言語で説明... | [AI生成] }
    --
    <b>最近のAI生成</b>
    - ログインフォーム（2025-11-30 15:00）
    - ダッシュボード（2025-11-30 14:30）
  }
  ==
  { [キャンセル] | [保存] }
}

@enduml
```

### 5.4 バージョン履歴画面

```plantuml
@startuml wireframe_version_history

salt
{
  {T
    + バージョン履歴 - class_diagram.puml
  }
  ==
  {T
    + v5 | 2025-11-30 15:30 | 現在のバージョン
    + v4 | 2025-11-30 14:00 | メソッド追加
    + v3 | 2025-11-29 18:00 | リファクタリング
    + v2 | 2025-11-29 10:00 | 継承関係追加
    + v1 | 2025-11-28 09:00 | 初版作成
  }
  ==
  {
    {+
      <b>v4 → v5 の差分</b>
      ---
      - class User {
      + class User {
      +   +getUserById(): User
      }
    }
  }
  ==
  { [閉じる] | [v4を復元] | [比較表示] }
}

@enduml
```

---

## 6. 画面遷移図

```plantuml
@startuml screen_transition

title 画面遷移図

skinparam state {
  BackgroundColor<<main>> LightCyan
  BackgroundColor<<auth>> LightYellow
  BackgroundColor<<modal>> LightGreen
}

[*] --> ログイン画面 : アクセス

state "ログイン画面" as login <<auth>>
state "新規登録画面" as signup <<auth>>
state "パスワードリセット" as reset <<auth>>

state "ダッシュボード" as dashboard <<main>>
state "エディタ画面" as editor <<main>>
state "プロジェクト一覧" as projects <<main>>
state "設定画面" as settings <<main>>
state "学習コンテンツ" as learning <<main>>

state "新規作成モーダル" as newModal <<modal>>
state "バージョン履歴" as versionModal <<modal>>
state "エクスポート" as exportModal <<modal>>
state "AIチャット" as chatPanel <<modal>>
state "テンプレート選択" as templateModal <<modal>>
state "Excalidrawエディタ" as excalidrawEditor <<main>>

' 認証フロー
login --> signup : 新規登録
login --> reset : パスワード忘れ
signup --> login : 登録完了
reset --> login : リセット完了
login --> dashboard : ログイン成功

' メイン画面遷移
dashboard --> projects : プロジェクト管理
dashboard --> editor : 図表を開く
dashboard --> newModal : 新規作成
dashboard --> learning : 学習コンテンツ
dashboard --> settings : 設定

projects --> editor : 図表を開く
projects --> dashboard : 戻る

editor --> dashboard : 閉じる
editor --> versionModal : 履歴表示
editor --> exportModal : エクスポート
editor --> chatPanel : AIチャット
editor --> templateModal : テンプレート挿入

' モーダルから戻る
newModal --> editor : 作成開始
newModal --> excalidrawEditor : ワイヤーフレーム作成
newModal --> dashboard : キャンセル
versionModal --> editor : 閉じる/復元
exportModal --> editor : 閉じる
templateModal --> editor : 適用

' Excalidraw遷移
dashboard --> excalidrawEditor : ワイヤーフレーム作成
excalidrawEditor --> dashboard : 閉じる/保存
projects --> excalidrawEditor : ワイヤーフレームを開く

learning --> dashboard : 戻る
settings --> dashboard : 戻る

' ログアウト
dashboard --> login : ログアウト
editor --> login : ログアウト

@enduml
```

---

## 7. クラス図

### 7.1 ドメインモデル

```plantuml
@startuml class_diagram_domain

title クラス図 - ドメインモデル

skinparam class {
  BackgroundColor<<entity>> LightCyan
  BackgroundColor<<valueobject>> LightGreen
  BackgroundColor<<enum>> LightYellow
}

' === エンティティ ===

class User <<entity>> {
  +id: UUID
  +email: String
  +name: String
  +avatar_url: String
  +created_at: DateTime
  +updated_at: DateTime
  --
  +createProject(): Project
  +getDiagrams(): Diagram[]
}

class Project <<entity>> {
  +id: UUID
  +user_id: UUID
  +name: String
  +description: String
  +phase: ProjectPhase
  +created_at: DateTime
  +updated_at: DateTime
  --
  +addDiagram(diagram: Diagram): void
  +changePhase(phase: ProjectPhase): void
}

class Diagram <<entity>> {
  +id: UUID
  +project_id: UUID
  +user_id: UUID
  +name: String
  +diagram_type: DiagramType
  +content: String
  +current_version: Number
  +created_at: DateTime
  +updated_at: DateTime
  --
  +validate(): ValidationResult
  +save(): DiagramVersion
  +export(format: ExportFormat): Blob
}

class DiagramVersion <<entity>> {
  +id: UUID
  +diagram_id: UUID
  +version: Number
  +content: String
  +content_hash: String
  +file_path: String
  +created_at: DateTime
  --
  +restore(): Diagram
  +diff(other: DiagramVersion): DiffResult
}

class Template <<entity>> {
  +id: UUID
  +name: String
  +description: String
  +diagram_type: DiagramType
  +category: TemplateCategory
  +content: String
  +preview_url: String
  +is_system: Boolean
  +created_by: UUID
  +approved_at: DateTime
  --
  +apply(): String
}

class GlossaryEntry <<entity>> {
  +id: UUID
  +project_id: UUID
  +term: String
  +aliases: String[]
  +definition: String
  +category: String
  --
  +findSimilar(threshold: Number): GlossaryEntry[]
}

class Wireframe <<entity>> {
  +id: UUID
  +project_id: UUID
  +user_id: UUID
  +name: String
  +description: String
  +excalidraw_json: JSON
  +preview_url: String
  +created_at: DateTime
  +updated_at: DateTime
  --
  +render(): SVG
  +export(format: ExportFormat): Blob
  +updateFromAI(prompt: String): void
}

' === 値オブジェクト ===

class ValidationResult <<valueobject>> {
  +valid: Boolean
  +errors: ValidationError[]
  +svg: String
  +processingTime: Number
}

class ValidationError <<valueobject>> {
  +line: Number
  +column: Number
  +message: String
  +severity: ErrorSeverity
  +suggestion: String
}

' === 列挙型 ===

enum DiagramType <<enum>> {
  SEQUENCE
  CLASS
  USECASE
  ACTIVITY
  STATE
  COMPONENT
  DEPLOYMENT
  ER
  MINDMAP
  GANTT
}

enum ProjectPhase <<enum>> {
  REQUIREMENTS
  BASIC_DESIGN
  DETAILED_DESIGN
  IMPLEMENTATION
  TESTING
  OPERATION
}

enum ErrorSeverity <<enum>> {
  ERROR
  WARNING
  INFO
}

enum ExportFormat <<enum>> {
  PNG
  SVG
  PDF
  PUML
}

' === 関連 ===

User "1" --o "*" Project : owns
User "1" --o "*" Diagram : creates
User "1" --o "*" Template : creates

Project "1" --o "*" Diagram : contains
Project "1" --o "*" GlossaryEntry : defines
Project "1" --o "*" Wireframe : contains
Project "1" -- "1" ProjectPhase : has

Diagram "1" --o "*" DiagramVersion : has
Diagram "1" -- "1" DiagramType : is
Diagram --> ValidationResult : produces

Template "1" -- "1" DiagramType : for

ValidationResult "1" --o "*" ValidationError : contains

@enduml
```

### 7.2 サービス層クラス図

```plantuml
@startuml class_diagram_service

title クラス図 - サービス層

skinparam class {
  BackgroundColor<<service>> LightBlue
  BackgroundColor<<repository>> LightGreen
  BackgroundColor<<client>> LightYellow
}

' === サービス ===

class DiagramService <<service>> {
  -diagramRepository: DiagramRepository
  -validator: PlantUMLValidator
  -versionService: VersionService
  --
  +create(dto: CreateDiagramDto): Diagram
  +update(id: UUID, dto: UpdateDiagramDto): Diagram
  +delete(id: UUID): void
  +validate(code: String): ValidationResult
  +export(id: UUID, format: ExportFormat): Blob
}

class AIService <<service>> {
  -openRouterClient: OpenRouterClient
  -context7Client: Context7Client
  --
  +generateCode(prompt: String, type: DiagramType): GenerateResponse
  +suggestFix(error: ValidationError, code: String): String
  +answerQuestion(question: String, context: String): String
  +recommendDiagramType(description: String): DiagramType
}

class VersionService <<service>> {
  -versionRepository: VersionRepository
  -storageClient: StorageClient
  --
  +save(diagram: Diagram): DiagramVersion
  +getHistory(diagramId: UUID): DiagramVersion[]
  +restore(versionId: UUID): Diagram
  +diff(v1: UUID, v2: UUID): DiffResult
}

class ValidationService <<service>> {
  -validator: PlantUMLValidator
  -aiService: AIService
  --
  +validate(code: String): ValidationResult
  +validateWithAutoFix(code: String, maxRetries: Number): ValidationResult
}

class ConsistencyService <<service>> {
  -glossaryRepository: GlossaryRepository
  --
  +checkTerms(projectId: UUID): ConsistencyIssue[]
  +findSimilarTerms(terms: String[], threshold: Number): TermSimilarity[]
  +applyFix(issue: ConsistencyIssue): void
}

class WireframeService <<service>> {
  -wireframeRepository: WireframeRepository
  -storageClient: StorageClient
  -aiService: AIService
  --
  +create(dto: CreateWireframeDto): Wireframe
  +update(id: UUID, json: JSON): Wireframe
  +delete(id: UUID): void
  +generateFromPrompt(prompt: String): ExcalidrawJSON
  +export(id: UUID, format: ExportFormat): Blob
}

' === リポジトリ ===

interface DiagramRepository <<repository>> {
  +findById(id: UUID): Diagram
  +findByProjectId(projectId: UUID): Diagram[]
  +save(diagram: Diagram): Diagram
  +delete(id: UUID): void
}

interface VersionRepository <<repository>> {
  +findByDiagramId(diagramId: UUID): DiagramVersion[]
  +findById(id: UUID): DiagramVersion
  +save(version: DiagramVersion): DiagramVersion
}

interface GlossaryRepository <<repository>> {
  +findByProjectId(projectId: UUID): GlossaryEntry[]
  +save(entry: GlossaryEntry): GlossaryEntry
}

' === クライアント ===

class OpenRouterClient <<client>> {
  -apiKey: String
  -baseUrl: String
  --
  +chat(messages: Message[], options: ChatOptions): Stream
  +complete(prompt: String): String
}

class Context7Client <<client>> {
  --
  +resolveLibraryId(name: String): LibraryInfo
  +getDocs(libraryId: String, topic: String): String
}

class PlantUMLValidator <<client>> {
  -javaPath: String
  -jarPath: String
  --
  +validate(code: String): ValidationResult
  +render(code: String, format: String): Buffer
}

class StorageClient <<client>> {
  -supabaseClient: SupabaseClient
  --
  +upload(path: String, data: Buffer): String
  +download(path: String): Buffer
  +delete(path: String): void
}

' === 関連 ===

DiagramService --> DiagramRepository
DiagramService --> ValidationService
DiagramService --> VersionService

AIService --> OpenRouterClient
AIService --> Context7Client

VersionService --> VersionRepository
VersionService --> StorageClient

ValidationService --> PlantUMLValidator
ValidationService --> AIService

ConsistencyService --> GlossaryRepository

@enduml
```

---

## 8. 業務フロー図・データフロー図対比表

| No | 業務フロー | 対応データフロー | 入力データ | 出力データ | データストア |
|----|-----------|-----------------|-----------|-----------|-------------|
| 1 | ログイン | P1.0 認証処理 | email, password | JWT token | D1: users |
| 2 | 新規図表作成 | P2.0 図表編集 | カテゴリ, タイプ | Diagram | D2: diagrams |
| 3 | コード編集 | P2.0 図表編集 | PlantUMLコード | 更新されたDiagram | D2: diagrams |
| 4 | 検証実行 | P3.0 検証処理 | PlantUMLコード | ValidationResult | - |
| 5 | AI質問 | P4.0 AI支援 | 質問テキスト | AI回答 | - |
| 6 | コード修正提案 | P4.0 AI支援 | エラー情報, コード | 修正コード | - |
| 7 | 保存 | P5.0 ファイル管理 | Diagram | DiagramVersion | D2, D3 |
| 8 | バージョン復元 | P5.0 ファイル管理 | version_id | Diagram | D3: diagram_versions |
| 9 | エクスポート | P6.0 エクスポート | diagram_id, format | PNG/SVG/PDF | D2: diagrams |
| 10 | プロジェクト作成 | P2.0 図表編集 | name, description | Project | D4: projects |
| 11 | テンプレート適用 | P2.0 図表編集 | template_id | コード | D5: templates |
| 12 | 用語チェック | P7.0 用語管理 | project_id | ConsistencyIssue[] | D6: glossary |
| 13 | ワイヤーフレーム作成 | P8.0 ワイヤーフレーム | 手動描画/AI生成 | Wireframe | D7: wireframes |
| 14 | ワイヤーフレームAI生成 | P8.0 ワイヤーフレーム | 自然言語説明 | Excalidraw JSON | D7: wireframes |
| 15 | ワイヤーフレームエクスポート | P8.0 ワイヤーフレーム | wireframe_id, format | PNG/SVG/JSON | D7: wireframes |

---

## 9. CRUD表（機能×データマトリクス）

### 9.1 機能×エンティティ CRUD表

| 機能 | users | projects | diagrams | diagram_versions | wireframes | templates | glossary_entries |
|------|-------|----------|----------|------------------|------------|-----------|------------------|
| **ログイン** | R | - | - | - | - | - | - |
| **新規登録** | C | - | - | - | - | - | - |
| **プロファイル編集** | U | - | - | - | - | - | - |
| **プロジェクト作成** | - | C | - | - | - | - | - |
| **プロジェクト編集** | - | U | - | - | - | - | - |
| **プロジェクト削除** | - | D | D | D | D | - | D |
| **図表作成** | - | R | C | C | - | R | - |
| **図表編集** | - | - | U | - | - | - | - |
| **図表保存** | - | - | U | C | - | - | - |
| **図表削除** | - | - | D | D | - | - | - |
| **バージョン復元** | - | - | U | R | - | - | - |
| **ワイヤーフレーム作成** | - | R | - | - | C | - | - |
| **ワイヤーフレーム編集** | - | - | - | - | U | - | - |
| **ワイヤーフレーム削除** | - | - | - | - | D | - | - |
| **ワイヤーフレームAI生成** | - | R | - | - | C | - | - |
| **テンプレート作成** | - | - | - | - | - | C | - |
| **テンプレート承認** | - | - | - | - | - | U | - |
| **用語登録** | - | - | - | - | - | - | C |
| **用語チェック** | - | - | R | - | - | - | R |
| **用語統一** | - | - | U | - | - | - | U |

### 9.2 アクター×機能 権限マトリクス

| 機能 | エンドユーザー | 開発者 | 管理者 |
|------|---------------|--------|--------|
| ログイン/ログアウト | ○ | ○ | ○ |
| プロファイル編集 | ○ | ○ | ○ |
| プロジェクト管理 | ○ | ○ | ○ |
| 図表作成・編集 | ○ | ○ | ○ |
| 図表エクスポート | ○ | ○ | ○ |
| ワイヤーフレーム作成・編集（Excalidraw） | ○ | ○ | ○ |
| ワイヤーフレームAI生成 | ○ | ○ | ○ |
| AI質問・修正提案 | ○ | ○ | ○ |
| マイテンプレート管理 | ○ | ○ | ○ |
| システムテンプレート作成 | - | ○ | ○ |
| 学習コンテンツ作成 | - | ○ | ○ |
| テンプレート承認 | - | - | ○ |
| ユーザー管理 | - | - | ○ |
| システム監視 | - | - | ○ |

---

## 10. シーケンス図

### 10.1 図表作成シーケンス

```plantuml
@startuml sequence_create_diagram

title シーケンス図 - 図表作成

actor "エンドユーザー" as user
participant "フロントエンド\n(Next.js)" as frontend
participant "API Routes" as api
participant "DiagramService" as service
database "Supabase" as db

user -> frontend : 「新規作成」クリック
activate frontend

frontend -> frontend : オンボーディング画面表示
user -> frontend : カテゴリ選択
user -> frontend : 図表タイプ選択
user -> frontend : テンプレート選択

frontend -> api : POST /api/diagrams
activate api

api -> service : create(dto)
activate service

service -> db : INSERT INTO diagrams
activate db
db --> service : diagram
deactivate db

service -> db : INSERT INTO diagram_versions
activate db
db --> service : version
deactivate db

service --> api : Diagram
deactivate service

api --> frontend : 201 Created
deactivate api

frontend -> frontend : エディタ画面に遷移
frontend -> frontend : テンプレートコード適用
frontend --> user : エディタ表示
deactivate frontend

@enduml
```

### 10.2 検証ループシーケンス

```plantuml
@startuml sequence_validation

title シーケンス図 - 検証ループ

actor "エンドユーザー" as user
participant "Monaco Editor" as editor
participant "ValidationService" as validation
participant "PlantUML\nValidator" as validator
participant "AIService" as ai
participant "OpenRouter" as llm

user -> editor : コード入力
activate editor

editor -> editor : デバウンス(500ms)

editor -> validation : validate(code)
activate validation

validation -> validator : validate(code)
activate validator

validator -> validator : node-plantuml実行
validator -> validator : stderr解析

alt 構文エラーあり
  validator --> validation : ValidationResult(errors)
  deactivate validator

  validation -> ai : suggestFix(error, code)
  activate ai

  ai -> llm : chat(prompt)
  activate llm
  llm --> ai : 修正提案
  deactivate llm

  ai --> validation : fixedCode
  deactivate ai

  validation --> editor : ValidationResult + 修正提案
  deactivate validation

  editor -> editor : エラーマーカー表示
  editor -> editor : 修正提案表示

  user -> editor : 「修正適用」クリック

  loop 最大3回
    editor -> validation : validate(fixedCode)
    activate validation
    validation -> validator : validate(fixedCode)
    activate validator

    alt 成功
      validator --> validation : ValidationResult(valid)
      deactivate validator
      validation --> editor : SVG
      deactivate validation
      editor -> editor : プレビュー更新
    else エラー継続
      validator --> validation : ValidationResult(errors)
      deactivate validator
      validation --> editor : 再度修正提案
      deactivate validation
    end
  end

else 構文エラーなし
  validator --> validation : ValidationResult(valid, svg)
  deactivate validator

  validation --> editor : SVG
  deactivate validation

  editor -> editor : プレビュー更新
end

editor --> user : 結果表示
deactivate editor

@enduml
```

### 10.3 AI質問シーケンス

```plantuml
@startuml sequence_ai_chat

title シーケンス図 - AI質問

actor "エンドユーザー" as user
participant "AIチャット\nパネル" as chat
participant "API Routes" as api
participant "AIService" as service
participant "OpenRouter" as llm
participant "Context7 MCP" as context7

user -> chat : 質問入力
activate chat

chat -> api : POST /api/ai/chat
activate api

api -> service : answerQuestion(question, context)
activate service

service -> service : プロンプト構築

alt PlantUML構文の質問
  service -> llm : chat(prompt + function_calling)
  activate llm

  llm -> context7 : get-library-docs(plantuml)
  activate context7
  context7 --> llm : 最新構文情報
  deactivate context7

  llm --> service : AI回答(stream)
  deactivate llm

else 一般的な質問
  service -> llm : chat(prompt)
  activate llm
  llm --> service : AI回答(stream)
  deactivate llm
end

service --> api : Stream<Response>
deactivate service

api --> chat : SSE Stream
deactivate api

chat -> chat : ストリーミング表示
chat --> user : 回答表示

opt コード修正提案あり
  chat -> chat : Diff表示
  user -> chat : 「適用」クリック
  chat -> chat : エディタに反映
end

deactivate chat

@enduml
```

### 10.4 バージョン保存シーケンス

```plantuml
@startuml sequence_save_version

title シーケンス図 - バージョン保存

actor "エンドユーザー" as user
participant "フロントエンド" as frontend
participant "API Routes" as api
participant "VersionService" as service
participant "StorageClient" as storage
database "Supabase" as db

user -> frontend : Ctrl+S または「保存」クリック
activate frontend

frontend -> api : POST /api/diagrams/{id}/versions
activate api

api -> service : save(diagram)
activate service

service -> service : SHA-256ハッシュ計算

service -> db : SELECT content_hash\nFROM diagram_versions\nWHERE diagram_id = ?
activate db
db --> service : 最新ハッシュ
deactivate db

alt ハッシュが異なる（変更あり）
  service -> storage : upload(path, content)
  activate storage
  storage --> service : file_url
  deactivate storage

  service -> db : INSERT INTO diagram_versions
  activate db
  db --> service : version
  deactivate db

  service -> db : UPDATE diagrams\nSET current_version = ?
  activate db
  db --> service : OK
  deactivate db

  service --> api : DiagramVersion
  deactivate service

  api --> frontend : 201 Created
  deactivate api

  frontend --> user : 「保存しました」通知

else ハッシュが同じ（変更なし）
  service --> api : 304 Not Modified
  deactivate service

  api --> frontend : 304 Not Modified
  deactivate api

  frontend --> user : 「変更はありません」通知
end

deactivate frontend

@enduml
```

### 10.5 Excalidrawワイヤーフレーム作成シーケンス（TD-015）

```plantuml
@startuml sequence_excalidraw

title シーケンス図 - Excalidrawワイヤーフレーム作成

actor "エンドユーザー" as user
participant "フロントエンド\n(Next.js)" as frontend
participant "Excalidraw\nコンポーネント" as excalidraw
participant "API Routes" as api
participant "WireframeService" as service
participant "AIService" as aiService
participant "OpenRouter" as llm
database "Supabase\nStorage" as storage

user -> frontend : 「ワイヤーフレーム作成」クリック
activate frontend

frontend -> excalidraw : Dynamic Import\n(ssr: false)
activate excalidraw
excalidraw --> frontend : Excalidrawエディタ
deactivate excalidraw

frontend --> user : Excalidrawエディタ表示

alt AI生成を使用
  user -> frontend : 自然言語で画面説明
  frontend -> api : POST /api/wireframes/generate
  activate api

  api -> service : generateFromPrompt(prompt)
  activate service

  service -> aiService : generateExcalidrawJSON(prompt)
  activate aiService

  aiService -> llm : chat(prompt)
  activate llm
  note right of llm
    中レベルLLM使用
    GPT-4o-mini / Claude 3.5 Haiku
    トークン消費: 80-100
  end note
  llm --> aiService : Excalidraw JSON
  deactivate llm

  aiService --> service : ExcalidrawJSON
  deactivate aiService

  service --> api : ExcalidrawJSON
  deactivate service

  api --> frontend : 200 OK + JSON
  deactivate api

  frontend -> excalidraw : updateScene(json)
  activate excalidraw
  excalidraw --> frontend : 描画完了
  deactivate excalidraw

else 手動描画
  user -> excalidraw : 手動で図形描画
  activate excalidraw
  excalidraw --> user : リアルタイムプレビュー
  deactivate excalidraw
end

user -> frontend : 「保存」クリック

frontend -> excalidraw : getSceneElements()
activate excalidraw
excalidraw --> frontend : Excalidraw JSON
deactivate excalidraw

frontend -> api : POST /api/wireframes
activate api

api -> service : create(dto)
activate service

service -> storage : upload(path, json)
activate storage
storage --> service : file_url
deactivate storage

service --> api : Wireframe
deactivate service

api --> frontend : 201 Created
deactivate api

frontend --> user : 「保存しました」通知
deactivate frontend

@enduml
```

---

## 11. 外部インターフェース一覧

### 11.1 外部システム一覧

| No | システム名 | 種別 | プロトコル | 用途 | エンドポイント |
|----|-----------|------|-----------|------|---------------|
| EXT-001 | Supabase Auth | BaaS | HTTPS | ユーザー認証 | `https://{project}.supabase.co/auth/v1` |
| EXT-002 | Supabase Database | BaaS | HTTPS/WSS | データ永続化 | `https://{project}.supabase.co/rest/v1` |
| EXT-003 | Supabase Storage | BaaS | HTTPS | ファイル保存 | `https://{project}.supabase.co/storage/v1` |
| EXT-004 | Supabase Realtime | BaaS | WSS | リアルタイム同期 | `wss://{project}.supabase.co/realtime/v1` |
| EXT-005 | OpenRouter API | AI | HTTPS | LLM呼び出し | `https://openrouter.ai/api/v1` |
| EXT-006 | Context7 MCP | MCP | MCP Protocol | ドキュメント取得 | MCP Server |
| EXT-007 | Playwright MCP | MCP | MCP Protocol | スクリーンショット | MCP Server |

### 11.2 API仕様一覧

#### 内部API（Next.js API Routes）

| No | エンドポイント | メソッド | 説明 | 認証 |
|----|---------------|---------|------|------|
| API-001 | `/api/auth/login` | POST | ログイン | 不要 |
| API-002 | `/api/auth/logout` | POST | ログアウト | 必要 |
| API-003 | `/api/auth/signup` | POST | 新規登録 | 不要 |
| API-004 | `/api/users/me` | GET | プロファイル取得 | 必要 |
| API-005 | `/api/users/me` | PATCH | プロファイル更新 | 必要 |
| API-006 | `/api/projects` | GET | プロジェクト一覧 | 必要 |
| API-007 | `/api/projects` | POST | プロジェクト作成 | 必要 |
| API-008 | `/api/projects/{id}` | GET | プロジェクト詳細 | 必要 |
| API-009 | `/api/projects/{id}` | PATCH | プロジェクト更新 | 必要 |
| API-010 | `/api/projects/{id}` | DELETE | プロジェクト削除 | 必要 |
| API-011 | `/api/diagrams` | GET | 図表一覧 | 必要 |
| API-012 | `/api/diagrams` | POST | 図表作成 | 必要 |
| API-013 | `/api/diagrams/{id}` | GET | 図表詳細 | 必要 |
| API-014 | `/api/diagrams/{id}` | PATCH | 図表更新 | 必要 |
| API-015 | `/api/diagrams/{id}` | DELETE | 図表削除 | 必要 |
| API-016 | `/api/diagrams/{id}/versions` | GET | バージョン履歴 | 必要 |
| API-017 | `/api/diagrams/{id}/versions` | POST | バージョン保存 | 必要 |
| API-018 | `/api/diagrams/{id}/versions/{v}` | GET | バージョン詳細 | 必要 |
| API-019 | `/api/diagrams/{id}/export` | POST | エクスポート | 必要 |
| API-020 | `/api/validate` | POST | PlantUML検証 | 必要 |
| API-021 | `/api/ai/generate` | POST | AI図表生成 | 必要 |
| API-022 | `/api/ai/chat` | POST | AIチャット | 必要 |
| API-023 | `/api/ai/fix` | POST | AI修正提案 | 必要 |
| API-024 | `/api/templates` | GET | テンプレート一覧 | 必要 |
| API-025 | `/api/templates/{id}` | GET | テンプレート詳細 | 必要 |
| API-026 | `/api/wireframes` | GET | ワイヤーフレーム一覧 | 必要 |
| API-027 | `/api/wireframes` | POST | ワイヤーフレーム作成 | 必要 |
| API-028 | `/api/wireframes/{id}` | GET | ワイヤーフレーム詳細 | 必要 |
| API-029 | `/api/wireframes/{id}` | PATCH | ワイヤーフレーム更新 | 必要 |
| API-030 | `/api/wireframes/{id}` | DELETE | ワイヤーフレーム削除 | 必要 |
| API-031 | `/api/wireframes/generate` | POST | AI生成（Excalidraw JSON） | 必要 |
| API-032 | `/api/wireframes/{id}/export` | POST | エクスポート（PNG/SVG） | 必要 |

### 11.3 データ連携仕様

#### Supabase Database テーブル

| テーブル名 | 説明 | RLS |
|-----------|------|-----|
| `users` | ユーザー情報 | ○ |
| `projects` | プロジェクト | ○ |
| `diagrams` | 図表 | ○ |
| `diagram_versions` | バージョン履歴 | ○ |
| `wireframes` | ワイヤーフレーム（Excalidraw） | ○ |
| `templates` | テンプレート | △ |
| `glossary_entries` | 用語集 | ○ |
| `learning_documents` | 学習コンテンツ | △ |

#### Supabase Storage バケット

| バケット名 | 用途 | 公開設定 |
|-----------|------|---------|
| `diagrams` | 図表バージョンファイル | Private |
| `wireframes` | Excalidraw JSONファイル | Private |
| `exports` | エクスポートファイル | Private |
| `templates` | テンプレートプレビュー | Public |
| `avatars` | ユーザーアバター | Public |

### 11.4 認証・認可仕様

| 項目 | 仕様 |
|------|------|
| 認証方式 | Supabase Auth (JWT) |
| トークン有効期限 | 1時間（リフレッシュトークン: 7日） |
| 認可方式 | Row Level Security (RLS) |
| APIキー管理 | 環境変数（サーバーサイドのみ） |

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|----------|
| 1.0 | 2025-11-30 | 初版作成 |
