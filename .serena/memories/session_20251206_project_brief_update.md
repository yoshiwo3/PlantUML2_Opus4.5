# project_brief.md 大幅更新セッション

## 日時
2025-12-06

## 作業内容

3つの正式版ドキュメントの内容をproject_brief.mdに反映

### 参照ドキュメント
1. `docs/proposals/PlantUML_Studio_コンテキスト図_20251130.md`
2. `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md`
3. `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md`

### 追加セクション

#### サービスアーキテクチャ
- **内部サービス（5サービス）**:
  - Frontend Service: UI/UX、Next.js (App Router)
  - API Gateway: ルーティング、認証検証、Next.js API Routes
  - PlantUML Service: PlantUML処理、node-plantuml + Java 17 + Graphviz
  - AI Service: AI支援機能、OpenRouter/OpenAI API
  - Excalidraw Service: ワイヤーフレーム処理、Excalidraw React

- **外部システム連携（5システム）**:
  - Supabase Auth: OAuth認証
  - Supabase Storage: 図表ファイル保存
  - OpenRouter API: LLM呼び出し
  - OpenAI API: Embedding生成（RAG用）
  - PlantUML MCP: 構文検証（開発時）

- **データフロー概要図**: ASCIIアート形式で追加

#### UX設計思想
- **想定ユーザーペルソナ（5タイプ）**:
  - システムエンジニア
  - フリーランス開発者
  - テックリード/アーキテクト
  - 学生・学習者
  - 技術ライター

- **UX設計のポイント（5項目）**:
  - 整理性: プロジェクト単位グループ化
  - 切替容易性: ワンクリック切替、前回選択記憶（TD-005）
  - 直感性: 明確なCRUD UI
  - 安全性: 削除時警告、カスケード削除明示
  - 拡張性: 将来機能追加対応

## Evidence反映（追加更新）

7つのEvidenceセットから以下を抽出・反映:

### 追加セクション
1. **検証済み技術仕様（Context7検証）**
   - Supabase Auth SSR: `getAll()`/`setAll()`, `getUser()`, `await cookies()`
   - Excalidraw React: SSR無効化必須（dynamic import）
   - PlantUML構文注意: `note bottom of`使用不可

2. **PlantUML/Excalidraw機能分類**
   - PlantUML専用: 3件（プレビュー、学習コンテンツ）
   - 共通機能: 8件（CRUD、エクスポート、バージョン管理）

3. **MVP Storage構成**
   - ファイル構造: `/{user_id}/{project_name}/{diagram_name}.*`
   - ファイル形式: B案（コメント内Markdown）
   - Repository Pattern図解

4. **作業履歴（Evidence）**
   - 2025-11-30〜2025-12-06の6件の主要作業を時系列で記録

### 参照Evidence
- `20251130_claude_md_update`
- `20251130_sequence_diagrams`
- `20251201_business_flow_diagram`
- `20251202_auth_flow`
- `20251206_project_management`
- `20251206_save_export_flow`
- `20251206_version_delete_flow`

## 関連ファイル
- `docs/context/project_brief.md` - 更新（2回）
- `docs/context/active_context.md` - 変更履歴追加（2回）
