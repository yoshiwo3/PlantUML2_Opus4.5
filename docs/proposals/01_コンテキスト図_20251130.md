# PlantUML Studio - システムコンテキスト図

**作成日**: 2025-11-30
**設計思想**: マイクロサービス + APIファースト

---

## コンテキスト図

```plantuml
@startuml PlantUML_Studio_Context
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Context.puml

title PlantUML Studio - システムコンテキスト図

'--------------------------------------------------
' 外部アクター
' - システムを利用する人間
'--------------------------------------------------
Person(endUser, "エンドユーザー", "図表を作成・編集する\n非エンジニアを含む")
Person(developer, "開発者", "システム管理\nユーザー管理\nLLM設定")

'--------------------------------------------------
' PlantUML Studio システム境界
' - マイクロサービス群で構成
' - すべてCloud Runにデプロイ
'--------------------------------------------------
System_Boundary(studio, "PlantUML Studio") {

    '--------------------------------------------------
    ' Frontend Service
    ' - ユーザーが直接操作するUI
    ' - Next.js (React) で構築
    ' - Monaco EditorでPlantUML編集
    ' - 4パネルレイアウト（左:GUI、中央:Editor、右:Preview、下:AI）
    '--------------------------------------------------
    System(frontend, "Frontend Service", "Next.js on Cloud Run\nMonaco Editor\n4パネルレイアウト")

    '--------------------------------------------------
    ' API Gateway Service
    ' - すべてのAPI呼び出しの入口
    ' - 認証トークン検証
    ' - 各マイクロサービスへのルーティング
    ' - レート制限・ログ収集
    '--------------------------------------------------
    System(gateway, "API Gateway", "Cloud Run\nルーティング\n認証検証")

    '--------------------------------------------------
    ' Excalidraw Service
    ' - ワイヤーフレーム生成・管理
    ' - CRUD操作（作成・読取・更新・削除）
    ' - バージョン管理（SHA-256ハッシュ）
    ' - 自然言語 → Excalidraw JSON（LLM経由）
    ' - JSON → SVG/PNG変換
    ' - テンプレート管理
    '--------------------------------------------------
    System(excalidraw, "Excalidraw Service", "Cloud Run\nワイヤーフレーム\nCRUD・バージョン管理")

    '--------------------------------------------------
    ' AI Service
    ' - AI Question-Start（AIが先に質問）
    ' - 自然言語 → PlantUML生成
    ' - 目的別AIチャット（フェーズ認識）
    ' - 図表セット提案（要件定義に必要な図表）
    ' - 用語一貫性チェック（表記揺れ検出）
    ' - RAG（Retrieval-Augmented Generation）
    '   - OpenAI APIでEmbedding生成
    '   - pgvectorでベクトル検索
    '   - 学習コンテンツ検索・回答生成
    '--------------------------------------------------
    System(ai, "AI Service", "Cloud Run\nAI Question-Start\n目的別チャット\nRAG(Embedding)")

    '--------------------------------------------------
    ' PlantUML Service
    ' - PlantUML図表の管理
    ' - CRUD操作（作成・読取・更新・削除）
    ' - バージョン管理（SHA-256ハッシュ）
    ' - 構文検証・レンダリング
    '   - node-plantuml（Node.jsラッパー）
    '   - ローカルJAR同梱（コンテナ内）
    '   - Java 17 + Graphviz で実行
    '   - 公式サーバー不使用（プライバシー保護）
    ' - SVG/PNG レンダリング
    ' - PDF/画像エクスポート
    ' - AI自動修正ループ（検証エラー時、最大3回）
    '--------------------------------------------------
    System(plantuml, "PlantUML Service", "Cloud Run\n図表CRUD\nnode-plantuml\n(ローカルJAR)")
}

'--------------------------------------------------
' 外部システム: Supabase
' - BaaS（Backend as a Service）
' - MVP: Storage + Auth のみ（DBテーブルなし）
' - v3: Postgres追加（メタデータ、検索インデックス）
' - Storage: 図表ファイル、プレビュー画像
' - pgvector: RAG用ベクトル検索（v3）
' - Auth: 認証・認可（OAuth対応）
' - Storage Policy: 所有権制御
'--------------------------------------------------
System_Ext(supabase, "Supabase", "Storage (Policy)\nAuth\n[v3: Postgres, pgvector]")

'--------------------------------------------------
' 外部システム: OpenRouter API
' - LLM統合プラットフォーム
' - 複数モデル対応（GPT-4o-mini, Claude, Gemini）
'--------------------------------------------------
System_Ext(openrouter, "OpenRouter API", "LLM統合\nGPT-4o-mini\nClaude, Gemini")

'--------------------------------------------------
' 外部システム: OpenAI API
' - Embedding生成専用
' - text-embedding-3-small / ada-002
' - RAG用ベクトル生成
' - 学習コンテンツのベクトル化
'--------------------------------------------------
System_Ext(openai, "OpenAI API", "Embedding生成\ntext-embedding-3")

'--------------------------------------------------
' 注: node-plantuml + ローカルJAR
' - node-plantuml: PlantUML JARのNode.jsラッパー
' - ローカルJAR: PlantUML Serviceコンテナに同梱
' - 実行環境: Java 17 + Graphviz（コンテナ内）
' - 公式サーバー不使用（プライバシー保護）
'--------------------------------------------------

'--------------------------------------------------
' リレーション: アクター → Frontend
'--------------------------------------------------
Rel(endUser, frontend, "図表作成・編集", "HTTPS")
Rel(developer, frontend, "システム管理", "HTTPS")

'--------------------------------------------------
' リレーション: Frontend → API Gateway
'--------------------------------------------------
Rel(frontend, gateway, "API呼び出し", "HTTPS/REST")

'--------------------------------------------------
' リレーション: API Gateway → 各マイクロサービス
'--------------------------------------------------
Rel(gateway, plantuml, "図表操作\n(PlantUML)", "HTTP/REST")
Rel(gateway, ai, "AI機能", "HTTP/REST")
Rel(gateway, excalidraw, "図表操作\n(ワイヤーフレーム)", "HTTP/REST")

'--------------------------------------------------
' リレーション: 各サービス → 外部システム
'--------------------------------------------------
Rel(gateway, supabase, "認証検証", "HTTPS")
Rel(plantuml, supabase, "データ永続化", "HTTPS")
Rel(plantuml, openrouter, "AI自動修正", "HTTPS")
Rel(ai, supabase, "RAG検索\n(pgvector)", "HTTPS")
Rel(ai, openrouter, "LLM呼び出し", "HTTPS")
Rel(ai, openai, "Embedding生成", "HTTPS")
Rel(excalidraw, supabase, "JSON保存", "HTTPS")
Rel(excalidraw, openrouter, "JSON生成", "HTTPS")

@enduml
```

---

## コンポーネント説明

### 外部アクター

| アクター | 役割 |
|---------|------|
| **エンドユーザー** | PlantUML/Excalidraw図表を作成・編集する。非エンジニアも含む |
| **開発者** | ユーザー管理、LLM設定、システム設定を行う |

### マイクロサービス（Cloud Run）

| サービス | 役割 | 主要機能 | LLM接続 |
|---------|------|---------|---------|
| **Frontend Service** | ユーザーインターフェース | Monaco Editor、4パネルレイアウト、リアルタイムプレビュー | - |
| **API Gateway** | API入口・ルーティング | 認証検証、レート制限、サービス振り分け | - |
| **PlantUML Service** | 図表管理 | CRUD、バージョン管理、**node-plantuml（ローカルJAR）**、レンダリング、AI自動修正 | OpenRouter |
| **AI Service** | AI機能全般 | Question-Start、生成、チャット、用語一貫性、**RAG(Embedding+pgvector)** | OpenRouter, **OpenAI** |
| **Excalidraw Service** | ワイヤーフレーム | CRUD、**バージョン管理**、**LLM→JSON生成**、レンダリング、テンプレート | OpenRouter |

### 外部システム

| システム | 役割 | 詳細 | 利用サービス |
|---------|------|------|-------------|
| **Supabase** | BaaS | **MVP**: Storage(Policy)、Auth / **v3**: Postgres(RLS)、pgvector(RAG) | 全サービス |
| **OpenRouter API** | LLM統合 | GPT-4o-mini、Claude、Gemini等 | PlantUML, AI, Excalidraw |
| **OpenAI API** | Embedding生成 | text-embedding-3-small（RAG用ベクトル化） | AI |

### 内部コンポーネント（コンテナ同梱）

| コンポーネント | 同梱先 | 詳細 |
|--------------|-------|------|
| **node-plantuml** | PlantUML Service | Node.jsラッパー、ローカルJAR + Java 17 + Graphviz |
| **PlantUML JAR** | PlantUML Service | ローカル実行、公式サーバー不使用（プライバシー保護） |

---

## 設計思想

1. **マイクロサービス**: 各機能を独立したサービスとして分離
2. **APIファースト**: すべてのサービス間通信はREST APIで行う
3. **Cloud Run統一**: すべてのサービスをGCP Cloud Runにデプロイ
4. **BaaS活用**: 認証・データ永続化はSupabaseに委譲
