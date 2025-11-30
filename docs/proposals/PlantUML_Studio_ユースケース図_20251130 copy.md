# PlantUML Studio - ユースケース図

**作成日**: 2025-11-30
**基準ドキュメント**: PlantUML_Studio_コンテキスト図_20251130.md

---

## ユースケース図

```plantuml
@startuml PlantUML_Studio_UseCase
'==================================================
' レイアウト設定（視認性向上）
'==================================================
left to right direction
scale 1.0

skinparam actorStyle awesome
skinparam packageStyle rectangle
skinparam defaultFontSize 11
skinparam usecaseFontSize 10
skinparam packageFontSize 12
skinparam noteFontSize 9

' パッケージ色分け
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
}

'--------------------------------------------------
' 主アクター定義（左側）
'--------------------------------------------------
actor "エンドユーザー" as user
actor "開発者" as developer

'--------------------------------------------------
' システム境界: PlantUML Studio
' カテゴリ順・作業フロー順に配置
'--------------------------------------------------
rectangle "PlantUML Studio" {

    '==============================================
    ' 1. 認証（最初に行う操作）
    '==============================================
    package "1. 認証" <<認証>> {
        usecase "1-1 ログインする" as UC_LOGIN
        usecase "1-2 ログアウトする" as UC_LOGOUT
    }

    '==============================================
    ' 2. プロジェクト管理（図表作成の前提）
    '==============================================
    package "2. プロジェクト管理" <<プロジェクト>> {
        usecase "2-1 プロジェクトを作成する" as UC_PRJ_CREATE
        usecase "2-2 プロジェクトを選択する" as UC_PRJ_SELECT
        usecase "2-3 プロジェクトを削除する" as UC_PRJ_DELETE
    }

    '==============================================
    ' 3. 図表操作（PlantUML・Excalidraw）
    ' - 共通操作: 作成、テンプレート選択、編集、保存、エクスポート、削除
    ' - PlantUML専用: プレビュー、バージョン管理
    ' - 学習支援: 学習コンテンツ検索・確認
    ' ※検証はシステム自動処理（プレビュー時に実行）
    '==============================================
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

    '==============================================
    ' 4. AI機能 - 利用フロー順
    ' ※用語一貫性チェックは保存時にシステムが自動実行
    '==============================================
    package "4. AI機能" <<AI機能>> {
        usecase "4-1 AI Question-Startで\n図表を生成する" as UC_AI_QS
        usecase "4-2 目的別AIチャットを\n利用する" as UC_AI_CHAT
    }

    '==============================================
    ' 5. 管理機能（開発者専用）
    '==============================================
    package "5. 管理機能" <<管理機能>> {
        usecase "5-1 ユーザーを管理する" as UC_ADMIN_USER
        usecase "5-2 学習コンテンツを登録する" as UC_ADMIN_CONTENT_REG
        usecase "5-3 学習コンテンツを管理する" as UC_ADMIN_CONTENT_MGT
        usecase "5-4 LLMモデルを切り替える" as UC_ADMIN_LLM
        usecase "5-5 システム設定を変更する" as UC_ADMIN_CONFIG
    }

}

'--------------------------------------------------
' 二次アクター定義（右側：外部システム）
'--------------------------------------------------
actor "Supabase" as supabase <<外部システム>>
actor "OpenRouter API" as openrouter <<外部システム>>
actor "OpenAI API" as openai <<外部システム>>

'--------------------------------------------------
' 主アクター - ユースケース関連
'--------------------------------------------------

' エンドユーザー: 認証
user --> UC_LOGIN
user --> UC_LOGOUT

' エンドユーザー: プロジェクト管理
user --> UC_PRJ_CREATE
user --> UC_PRJ_SELECT
user --> UC_PRJ_DELETE

' エンドユーザー: 図表操作
user --> UC_CREATE
user --> UC_EDIT
user --> UC_PREVIEW
user --> UC_SAVE
user --> UC_EXPORT
user --> UC_HISTORY
user --> UC_RESTORE
user --> UC_DELETE
user --> UC_LEARN_SEARCH
user --> UC_LEARN_VIEW

' エンドユーザー: AI機能
user --> UC_AI_QS
user --> UC_AI_CHAT

' 開発者: 管理機能
developer --> UC_ADMIN_USER
developer --> UC_ADMIN_CONTENT_REG
developer --> UC_ADMIN_CONTENT_MGT
developer --> UC_ADMIN_LLM
developer --> UC_ADMIN_CONFIG

'--------------------------------------------------
' 二次アクター（外部システム）- ユースケース関連
'--------------------------------------------------

' Supabase: 認証・データ保存
UC_LOGIN --> supabase : OAuth認証
UC_LOGOUT --> supabase : セッション終了
UC_ADMIN_USER --> supabase : ユーザーCRUD
UC_ADMIN_CONTENT_REG --> supabase : コンテンツ・ベクトル保存
UC_ADMIN_CONTENT_MGT --> supabase : コンテンツCRUD

' OpenRouter API: LLM呼び出し
UC_AI_QS --> openrouter : 図表生成
UC_AI_CHAT --> openrouter : チャット応答
UC_PREVIEW --> openrouter : AI自動修正(エラー時)
UC_LEARN_SEARCH --> openrouter : RAG応答生成
UC_SAVE --> openrouter : 用語一貫性チェック(自動)

' OpenAI API: Embedding（コンテンツ登録時）
UC_ADMIN_CONTENT_REG --> openai : Embedding生成

'--------------------------------------------------
' ユースケース間の関連
'--------------------------------------------------

' 作成時はテンプレート選択を含む
UC_CREATE ..> UC_TEMPLATE : <<include>>

' 作成・編集の結果としてプレビュー（PlantUML専用）
UC_CREATE ..> UC_PREVIEW : <<extends>>
UC_EDIT ..> UC_PREVIEW : <<extends>>

' 復元は履歴確認を前提とする
UC_RESTORE ..> UC_HISTORY : <<include>>

' AI機能と図表操作の関連
UC_AI_QS ..> UC_CREATE : <<extends>>

' AIチャットから学習コンテンツ検索
UC_AI_CHAT ..> UC_LEARN_SEARCH : <<extends>>

' 学習コンテンツの関連
UC_LEARN_VIEW ..> UC_LEARN_SEARCH : <<include>>

'--------------------------------------------------
' ノート（補足説明）
'--------------------------------------------------
note bottom of UC_TEMPLATE : PlantUML/ワイヤーフレーム\n両方に適用
note bottom of UC_PREVIEW : PlantUML専用\nシステムが自動検証\n(構文エラー時はAI修正提案)
note bottom of UC_HISTORY : PlantUML専用\nバージョン管理機能
note bottom of UC_LEARN_SEARCH : 編集中にPlantUML構文や\n書き方を検索（RAG）
note bottom of UC_AI_CHAT : 用語一貫性チェックは\n保存時にシステムが自動実行\n(結果をユーザーに通知)\n\n会話中にユーザーの質問に応じて\n学習コンテンツを検索・提案
note bottom of UC_EDIT : PlantUMLの場合\n編集結果を即時プレビュー
note bottom of UC_AI_QS : AIで生成した図表は\nPlantUML/ワイヤーフレームとして作成
note bottom of UC_ADMIN_CONTENT_REG : 登録時にEmbedding生成\n(OpenAI API)

@enduml
```

---

## ユースケース一覧

### 1. 認証

| ID | ユースケース | 説明 | 主アクター | 二次アクター |
|----|-------------|------|-----------|-------------|
| 1-1 | ログインする | Email/Password または OAuth（GitHub/Google） | エンドユーザー | Supabase Auth |
| 1-2 | ログアウトする | セッション終了 | エンドユーザー | Supabase Auth |

### 2. プロジェクト管理

| ID | ユースケース | 説明 | 主アクター | 二次アクター |
|----|-------------|------|-----------|-------------|
| 2-1 | プロジェクトを作成する | 図表をグループ化する単位を作成 | エンドユーザー | - |
| 2-2 | プロジェクトを選択する | 作業対象プロジェクトの切替 | エンドユーザー | - |
| 2-3 | プロジェクトを削除する | プロジェクトと配下図表の削除 | エンドユーザー | - |

### 3. 図表操作（PlantUML・Excalidraw）

※検証（構文チェック）はプレビュー時にシステムが自動実行

| ID | ユースケース | 説明 | 対象 | 主アクター | 二次アクター |
|----|-------------|------|------|-----------|-------------|
| 3-1 | 図表を作成する | 新規図表作成 | 共通 | エンドユーザー | - |
| 3-2 | テンプレートを選択する | テンプレートから図表を開始 | 共通 | エンドユーザー | - |
| 3-3 | 図表を編集する | Monaco Editor(PlantUML) / Excalidraw UI(ワイヤーフレーム) | 共通 | エンドユーザー | - |
| 3-4 | 図表をプレビューする | SVG/PNGでリアルタイム表示（自動検証含む） | PlantUML専用 | エンドユーザー | OpenRouter API |
| 3-5 | 図表を保存する | 手動保存（Ctrl+S）/ 自動保存（30秒）※用語一貫性チェック自動実行 | 共通 | エンドユーザー | OpenRouter API |
| 3-6 | 図表をエクスポートする | PDF/PNG/SVG出力 | 共通 | エンドユーザー | - |
| 3-7 | バージョン履歴を確認する | 過去バージョン一覧表示 | PlantUML専用 | エンドユーザー | - |
| 3-8 | 過去バージョンを復元する | 指定バージョンに戻す | PlantUML専用 | エンドユーザー | - |
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
| 2. プロジェクト | 2-1, 2-2, 2-3 | 基本機能 |
| 3. 図表操作（PlantUML・Excalidraw） | 3-1〜3-9 | コア機能 |
| 4. AI機能 | 4-1 | 差別化機能 |

### Phase 2以降

| カテゴリ | ユースケース | 理由 |
|---------|-------------|------|
| 3. 図表操作（PlantUML・Excalidraw） | 3-10, 3-11 | 学習支援機能 |
| 4. AI機能 | 4-2 | 拡張機能 |
| 5. 管理機能 | 5-1〜5-5 | 運用機能 |

---

## ユースケース数サマリ

| カテゴリ | 件数 | MVP | Phase 2 |
|---------|------|-----|---------|
| 1. 認証 | 2 | 2 | - |
| 2. プロジェクト管理 | 3 | 3 | - |
| 3. 図表操作（PlantUML・Excalidraw） | 11 | 9 | 2 |
| 4. AI機能 | 2 | 1 | 1 |
| 5. 管理機能 | 5 | - | 5 |
| **合計** | **23** | **15** | **8** |

---

## 設計判断の根拠

### 1. 図表操作の統合（3.と4.の統合）

**判断**: PlantUMLとワイヤーフレームを「3. 図表操作」として統合

**理由**:
- ユースケース図はユーザーの「目的」を表現するもの
- 「図表を作成したい」「テンプレートから始めたい」という目的は共通
- 実装の違い（Monaco vs Excalidraw）はユースケースレベルでは表現すべきではない
- PlantUML専用機能（プレビュー、バージョン管理）はノートで明示

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

---

## レビュー観点

1. **漏れているユースケースはあるか？**
2. **不要なユースケースはあるか？**
3. **ユースケースの粒度は適切か？**
4. **図表操作の統合は適切か？**
5. **外部システムの表現は適切か？**
6. **MVP vs Phase 2の優先度判断は妥当か？**
