# プロジェクト概要（Project Brief）

**プロジェクト名**: PlantUML Studio (PlantUML2_Opus4.5)
**最終更新**: 2025-11-30
**ステータス**: Planning

---

## プロジェクト目標

### ビジネス目標

次世代PlantUML図表作成Webアプリケーションの開発。技術者・非技術者の両方が直感的に使えるUIと、AI支援による高品質な図表作成を実現。

### 技術目標

- Monaco Editorベースの高機能エディタ
- リアルタイムプレビュー
- AI支援によるコード生成・エラー修正
- 22種類以上のPlantUML図表タイプサポート

---

## スコープ

### 含むもの

- [ ] PlantUMLコードエディタ（Monaco Editor）
- [ ] リアルタイムプレビュー機能
- [ ] AI支援コード生成（MCP統合）
- [ ] 図表タイプ別テンプレート
- [ ] ユーザー認証・データ永続化

### 含まないもの

- 他の図表フォーマット（Mermaid等）のサポート
- モバイルアプリ

---

## ステークホルダー

| 役割 | 担当者 | 責任 |
|------|--------|------|
| プロジェクトリード | 保科 慶光 | 全体統括、意思決定 |
| AI Assistant | Claude Code | コード生成、ドキュメント作成 |
| Serena MCP | - | コードベース理解、シンボル検索 |

---

## 技術スタック（予定）

### フロントエンド
- フレームワーク: Next.js (App Router)
- 言語: TypeScript
- UI: Tailwind CSS, shadcn/ui
- エディタ: Monaco Editor

### バックエンド
- フレームワーク: Next.js API Routes
- データベース: Supabase (PostgreSQL)
- 認証: Supabase Auth

### デプロイメント
- フロントエンド: Vercel
- MCP Validator: Google Cloud Run
- GCP Project: plantuml-477523
- Region: asia-northeast1 (Tokyo)

---

## ロードマップ

### Phase 1: 企画・調査（現在）
- [x] 企画書作成
- [x] 技術選定
- [x] AI駆動開発環境構築

### Phase 2: MVP開発
- [ ] 基本エディタ実装
- [ ] リアルタイムプレビュー
- [ ] 認証機能

### Phase 3: AI機能
- [ ] MCP統合
- [ ] AI支援コード生成

---

## 成功指標

- PlantUML構文検証成功率: 100%
- doc-reviewerスコア: 96/100以上
- Evidence完備率: 100%

---

**次のレビュー予定**: 2025-12-07
