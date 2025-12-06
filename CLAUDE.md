# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PlantUML Studio - 次世代PlantUML図表作成Webアプリケーションの企画・調査リポジトリ。現在はドキュメント中心のフェーズ（`project_type: documentation`）。

## 現在の目標

**`docs/design/PlantUML_Studio_設計図表_20251130.md`をもとに高品質なプロダクト要件定義書（PRD）を作成する**

### 進捗管理（必読）

**`docs/context/active_context.md`** - プロジェクト全体の進捗管理表

| 項目 | 内容 |
|------|------|
| 図表作成進捗 | 14項目の完了状況 |
| 業務フロー図詳細 | 10フローの進捗 |
| UCカバレッジ | 24UC中の対応状況 |
| 技術決定一覧 | TD-001〜最新 |
| 最近の変更履歴 | 日付別の作業記録 |

⚠️ **作業開始時は必ず確認し、作業完了時は必ず更新すること**

---

## ドキュメント管理の基本ルール

### 2つのドキュメント領域

| 場所 | 役割 | 状態 | PRDへの採用 |
|------|------|------|:-----------:|
| `docs/design/PlantUML_Studio_設計図表_20251130.md` | **下書き・たたき台** | 未レビュー、整合性未確認 | ❌ 不可 |
| `docs/proposals/` | **レビュー済み正式版** | チャットで検証・確認済み | ✅ 採用 |

### ワークフロー

```
[下書き]                              [正式版]
docs/design/設計図表集.md        docs/proposals/〇〇図_20251130.md
         │                                  ↑
         │ 参考にする                        │
         ↓                                  │
    チャットで対話 ──→ レビュー・修正 ──→ 正式版として保存
         │                                  │
         │ Context7等で仕様検証              │
         ↓                                  ↓
                                      PRDに採用
```

### 重要な注意点

- **設計図表集（design/）はそのままPRDには使えない** - 「とりあえず形にした」状態
- **正式版（proposals/）のみがPRDの構成要素** - チャットでレビュー・検証済み
- 図表作成時は必ず下書きを参考にしつつ、対話を通じて正式版を作成する

---

## 作業時に意識すべきこと

このプロジェクトで作業する際、以下の6点を常に意識する。

### 1. ドキュメントの位置づけを理解する

| やること | やらないこと |
|---------|-------------|
| `docs/proposals/`に正式版を作成 | `docs/design/`をそのまま使う |
| チャットでレビュー・検証してから保存 | 下書きを「完了」と報告する |

### 2. 確認せずに報告しない

- ファイルの存在を主張する前に**実際に読む**
- 「完了」と言う前に**ファイルパス・行番号を確認**
- 推測や記憶に頼らない
- grep検索等で実際の内容を検証する

### 3. 目的を理解する

- **最終ゴール**: PRD（プロダクト要件定義書）の作成
- 図表作成は手段であり、目的ではない
- 言われたことだけでなく、**なぜそれをやるのか**を考える
- **わからなければ質問する** - 理解せずに作業を進めない

### 4. 対話を通じて作成する

```
下書き参照 → チャットで対話 → Context7等で検証 → 正式版保存
```

一方的に作成せず、レビュー・確認を経て正式版とする。

### 5. 技術仕様を守る

| 項目 | 正しい仕様 | 誤った仕様（使用禁止） |
|------|-----------|---------------------|
| PlantUMLレンダリング | node-plantuml + Java 17 + Graphviz（内部） | PlantUML Server API（外部） |
| テキストエディタ | Monaco Editor | CodeMirror |
| 検証処理 | API Routes (`/api/validate`) + ValidationService | 外部API直接呼び出し |

### 6. 既存の正式版図表との整合性を保つ

新しい図表を作成する際は、`docs/proposals/`内の既存図表と**矛盾のない**内容にする。

**整合性確認対象（既存の正式版）:**

| ファイル | 内容 |
|---------|------|
| `PlantUML_Studio_コンテキスト図_20251130.md` | システム境界、外部アクター |
| `PlantUML_Studio_ユースケース図_20251130.md` | 機能一覧、アクター定義 |
| `PlantUML_Studio_シーケンス図_ログイン_20251130.md` | 認証フロー |
| `PlantUML_Studio_業務フロー図_20251201.md` | 図表作成・AI支援・Excalidraw・認証・プロジェクト管理フロー |

**確認すべき整合性:**
- アクター名・システム名の統一
- コンポーネント名・サービス名の一致
- データフロー・処理フローの一貫性
- 用語・命名規則の統一

---

## PRD作成に必要な図表・一覧表

PRDは以下の図表・一覧表で構成される。図表作成自体が目的ではなく、**PRD完成が最終ゴール**である。

### 作成順序（依存関係に基づく）

図表には依存関係があるため、以下の順序で作成・確認する：

```
Phase 1: スコープ定義
  ① コンテキスト図 → システム境界を明確化
  ② ユースケース図 → 機能要件を定義

Phase 2: プロセス定義
  ③ 業務フロー図 → 業務プロセスを可視化
  ④ データフロー図（DFD） → データの流れを定義
  ⑤ 業務フロー・DFD対比表 → ③④の紐付け・トレーサビリティ

Phase 3: データ・構造定義
  ⑥ クラス図 → ドメインモデル・データ構造
  ⑦ CRUD表 → 機能×データ操作の網羅性確認

Phase 4: 振る舞い詳細化
  ⑧ シーケンス図 → ユースケースの処理フロー詳細
  ⑨ 画面遷移図 → 画面フロー定義
  ⑩ ワイヤーフレーム → UI/UX視覚化

Phase 5: アーキテクチャ・インターフェース
  ⑪ コンポーネント図 → システムアーキテクチャ
  ⑫ 外部インターフェース一覧 → 外部システム連携

Phase 6: 品質・権限定義
  ⑬ 非機能要件一覧表 → 品質特性（IPA準拠）
  ⑭ アクター権限マトリクス → アクセス制御
```

### 図表一覧と現在の状況（2025-12-06 更新）

**設計図表集の実際の構成（セクション1-11）:**
- セクション1: コンポーネント図
- セクション2: ユースケース図
- セクション3: 業務フロー図（3.1-3.4）
- セクション4: データフロー図（4.1 コンテキスト図、4.2 レベル1）
- セクション5: ワイヤーフレーム（5.1-5.4）
- セクション6: 画面遷移図
- セクション7: クラス図（7.1 ドメインモデル、7.2 サービス層）
- セクション8: 業務フロー図・データフロー図対比表
- セクション9: CRUD表（9.1 機能×エンティティ、9.2 アクター×機能権限）
- セクション10: シーケンス図（10.1-10.5）
- セクション11: 外部インターフェース一覧（11.1-11.4）

| 順序 | 図表 | 正式版ファイル（proposals） | 下書き参照 | 状況 |
|:----:|------|----------------------------|:----------:|:----:|
| ① | **コンテキスト図** | `docs/proposals/PlantUML_Studio_コンテキスト図_20251130.md` | §4.1 | ✅ 完了 |
| ② | **ユースケース図** | `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md` | §2 | ✅ 完了 |
| ③ | **業務フロー図** | `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` | §3.1-3.5 | 🟡 一部完了 (5/10) |
| ④ | **データフロー図（DFD）** | 未作成 | §4.1-4.2 | 🔴 要作成 |
| ⑤ | **業務フロー・DFD対比表** | 未作成 | §8 | 🔴 要作成 |
| ⑥ | **クラス図** | 未作成 | §7.1-7.2 | 🔴 要作成 |
| ⑦ | **CRUD表** | 未作成 | §9.1 | 🔴 要作成 |
| ⑧ | **シーケンス図** | | §10.1-10.5 | |
|    |  └ ログイン | `docs/proposals/PlantUML_Studio_シーケンス図_ログイン_20251130.md` | - | ✅ 完了 |
|    |  └ 編集プレビュー | 未作成 | - | 🔴 要作成 |
|    |  └ エクスポート | 未作成 | - | 🔴 要作成 |
|    |  └ 保存読込 | 未作成 | - | 🔴 要作成 |
|    |  └ 共有 | 未作成 | - | 🔴 要作成 |
| ⑨ | **画面遷移図** | 未作成 | §6 | 🔴 要作成 |
| ⑩ | **ワイヤーフレーム** | 未作成 | §5.1-5.4 | 🔴 要作成 |
| ⑪ | **コンポーネント図** | 未作成 | §1 | 🔴 要作成 |
| ⑫ | **外部インターフェース一覧** | 未作成 | §11.1-11.4 | 🔴 要作成 |
| ⑬ | **非機能要件一覧表** | 未作成 | なし | 🔴 要作成 |
| ⑭ | **アクター権限マトリクス** | 未作成 | §9.2 | 🔴 要作成 |

**進捗: 3/14 完了（21%）** ※業務フロー図は一部完了のためカウント外

※ 正式版 = `docs/proposals/`内のレビュー済みファイル
※ 下書き参照 = `docs/design/PlantUML_Studio_設計図表_20251130.md`のセクション（未レビュー、参考程度）

### ③ 業務フロー図 詳細進捗（ユースケース対応）

業務フロー図はユースケース図（24UC）に対応して作成する。

| # | 業務フロー名 | 対応UC | 優先度 | 状況 |
|---|-------------|--------|:------:|:----:|
| 3.1 | **PlantUML 図表作成フロー** | 3-1〜3-4 (作成・編集・プレビュー) | MVP | ✅ 完了 |
| 3.2 | **PlantUML AI支援フロー** | 4-1, 4-2 (Question-Start, AIチャット) | MVP | ✅ 完了 |
| 3.3 | **Excalidraw ワイヤーフレーム作成フロー** | 3-1, 3-3 (Excalidraw版) | MVP | ✅ 完了 |
| 3.4 | **認証フロー** | 1-1, 1-2 (ログイン・ログアウト) | MVP | ✅ 完了 |
| 3.5 | **プロジェクト管理フロー** | 2-1〜2-4 (プロジェクトCRUD) | MVP | ✅ 完了 |
| 3.6 | **保存・エクスポートフロー** | 3-5, 3-6 (保存・エクスポート) | MVP | 🔴 要作成 |
| 3.7 | **バージョン管理フロー** | 3-7, 3-8 (履歴・復元) | MVP | 🔴 要作成 |
| 3.8 | **図表削除フロー** | 3-9 (図表削除) | MVP | 🔴 要作成 |
| 3.9 | **学習コンテンツフロー** | 3-10, 3-11 (検索・確認) | Phase 2 | 🔴 要作成 |
| 3.10 | **管理機能フロー** | 5-1〜5-5 (開発者向け管理) | Phase 2 | 🔴 要作成 |

**業務フロー図 進捗: 5/10 完了（50%）**

**MVP必須で未完了: 3フロー** (3.6〜3.8)
**Phase 2で未完了: 2フロー** (3.9〜3.10)

#### ユースケースカバレッジ

| パッケージ | 総UC数 | カバー済み | 未カバー |
|-----------|:------:|:----------:|:--------:|
| 1. 認証 | 2 | 2 | 0 |
| 2. プロジェクト管理 | 4 | 4 | 0 |
| 3. 図表操作 | 11 | 4 | 7 (3-5〜3-11) |
| 4. AI機能 | 2 | 2 | 0 |
| 5. 管理機能 | 5 | 0 | 5 (5-1〜5-5) |
| **合計** | **24** | **12** | **12** |

### 非機能要件一覧表の項目（IPA非機能要求グレード準拠）

| 大項目 | 中項目例 | 定義内容 |
|--------|---------|---------|
| **可用性** | 稼働率、障害復旧時間（RTO/RPO） | サービス継続性の要件 |
| **性能・拡張性** | レスポンス時間、同時接続数、スループット | パフォーマンス目標値 |
| **運用・保守性** | バックアップ、監視、ログ管理 | 運用に必要な機能・体制 |
| **移行性** | データ移行、並行稼働期間 | 既存システムからの移行要件 |
| **セキュリティ** | 認証、認可、暗号化、監査ログ | セキュリティ対策要件 |
| **システム環境** | 動作環境、ブラウザ対応、アクセシビリティ | 技術的制約・対応範囲 |

---

## 参照ドキュメント（下書き）

**`docs/design/PlantUML_Studio_設計図表_20251130.md`** - 設計図表集

⚠️ **注意: これは下書き・たたき台であり、PRDには直接使用しない**

正式版作成時の参考資料として使用。チャットでレビュー・検証後、`docs/proposals/`に正式版を作成する。

### 設計図表集の構成（参考）

| セクション | 内容 |
|-----------|------|
| 1 | コンポーネント図 |
| 2 | ユースケース図 |
| 3 | 業務フロー図（図表作成、AI支援、検証ループ、Excalidraw） |
| 4 | データフロー図（レベル0コンテキスト図、レベル1） |
| 5 | ワイヤーフレーム（エディタ、新規作成、Excalidraw、バージョン履歴） |
| 6 | 画面遷移図 |
| 7 | クラス図（ドメインモデル、サービス層） |
| 8 | 業務フロー図・データフロー図対比表 |
| 9 | CRUD表（機能×エンティティ、アクター×機能権限） |
| 10 | シーケンス図（図表作成、検証ループ、AI質問、バージョン保存、Excalidraw） |
| 11 | 外部インターフェース一覧（外部システム、API仕様、データ連携、認証） |

---

## 作成済み正式版ドキュメント

`docs/proposals/`内のレビュー済み正式版：

| ファイル | 内容 |
|---------|------|
| `PlantUML_Studio_コンテキスト図_20251130.md` | システム境界、外部アクター定義 |
| `PlantUML_Studio_ユースケース図_20251130.md` | ユースケース図（概要図＋詳細図） |
| `PlantUML_Studio_シーケンス図_ログイン_20251130.md` | UC1-1, UC1-2: OAuth(PKCE)、セッション検証、ログアウト |
| `PlantUML_Studio_業務フロー図_20251201.md` | 業務フロー5/10完了（図表作成・AI支援・Excalidraw・認証・プロジェクト管理）+ UX設計思想 |
| `PlantUML_Studio_開発ステップ詳細化計画_20251130.md` | 開発フェーズ計画 |

### UX設計思想（重要）

業務フロー図（`PlantUML_Studio_業務フロー図_20251201.md`）に**UX設計思想**セクションを追加済み。
新機能設計時は必ず参照すること：

- **プロジェクトの定義**: 階層構造（プロジェクト1:N図表）、データモデル
- **想定ユーザーペルソナ**: 個人開発者、学習者、チームリーダー、フリーランス、技術文書担当
- **想定利用ケース**: ソフトウェア開発、学習・教育、技術文書作成、システム移行、ナレッジ管理
- **UX設計のポイント**: シンプルなCRUD、即時フィードバック、安全な削除、一覧性、アクセシビリティ

---

## 設計図表集との整合性ルール

**すべてのドキュメント作成時は必ず設計図表集を参照すること。**

| 項目 | 正しい仕様 | 誤った仕様（使用禁止） |
|------|-----------|---------------------|
| PlantUMLレンダリング | node-plantuml + Java 17 + Graphviz（内部） | PlantUML Server API（外部） |
| テキストエディタ | Monaco Editor | CodeMirror |
| 検証処理 | API Routes (`/api/validate`) + ValidationService | 外部API直接呼び出し |

---

## 次のアクション（2025-12-06更新）

### 優先度順タスク

1. [ ] **残り11図表の正式版作成**（Phase順に依存関係を考慮）
   - Phase 2: 業務フロー図、DFD、業務フロー・DFD対比表
   - Phase 3: クラス図、CRUD表
   - Phase 4: シーケンス図（編集プレビュー/エクスポート/保存読込/共有）、画面遷移図、ワイヤーフレーム
   - Phase 5: コンポーネント図、外部インターフェース一覧
   - Phase 6: 非機能要件一覧表、アクター権限マトリクス
2. [ ] 全図表・一覧表の整合性最終確認
3. [ ] PRDドキュメント本体の作成

### 残タスク詳細

**非機能要件一覧表の作成（IPA非機能要求グレード準拠）**
- 可用性（稼働率、RTO/RPO）
- 性能・拡張性（レスポンス時間、同時接続数）
- 運用・保守性（バックアップ、監視）
- 移行性（データ移行要件）
- セキュリティ（認証、暗号化、監査）
- システム環境（ブラウザ対応、アクセシビリティ）

## Key Technical Decisions (Context7 Verified)

### Supabase Auth SSR
```typescript
// 必須パターン: getAll()/setAll()
cookies: {
  getAll() { return cookieStore.getAll() },
  setAll(cookiesToSet) { ... }
}
// 禁止: get/set/remove は動作しない
```

- Middlewareでは`getUser()`を使用（NOT `getSession()`）
- Next.js 15では`await cookies()`必須
- サーバー側ログアウトで`revalidatePath('/', 'layout')`

### Excalidraw React
```typescript
// SSR無効化必須
const Excalidraw = dynamic(
  () => import('@excalidraw/excalidraw').then(mod => mod.Excalidraw),
  { ssr: false }
)
```

### PlantUML構文注意
- シーケンス図で`note bottom of`は使用不可 → `note over`を使用

### TD-005: プロジェクト選択状態のSupabase保存
```typescript
// users.last_selected_project_id で最後に選択したプロジェクトを保存
// リロード・デバイス切り替え後も前回の作業を即座に再開可能
```
- ローカルストレージ/React State不採用（リロード時消失、デバイス固有）
- Supabase中心アーキテクチャとの一貫性を維持

## MCP Servers

このプロジェクトでは以下のMCPサーバーを使用：

### 必須
- **Context7**: ライブラリドキュメント参照（PlantUML仕様等）
- **Serena**: コードベース理解、シンボル検索、プロジェクトメモリ管理

### 設定済み
- **Playwright**: ブラウザ自動操作
- **GitHub**: GitHub API操作
- **Claude Ops**: 操作履歴・ファイル変更追跡

## Custom Agents

現在未使用（削除済み）。必要に応じて`.claude/agents/`配下に再定義可能。

## PlantUML Code Rules

すべてのPlantUMLコード（.pumlファイル、ドキュメント内コードブロック）作成時は以下のフローに従う：

### 必須フロー

```
1. Context7で仕様確認 → 2. コード作成 → 3. バリデーション → 4. 保存
```

### Step 1: Context7 MCPで仕様確認（必須）

PlantUML図表を新規作成・修正する前に、**必ずContext7 MCPに問い合わせる**：

```
mcp__context7__resolve-library-id → libraryName: "plantuml"
mcp__context7__get-library-docs   → topic: "<図表タイプ>" (例: "activity diagram", "sequence diagram")
```

**確認すべき内容**:
- 使用する図表タイプの構文
- スイムレーン、分岐、ループ等の特殊構文
- skinparam、pragma等のオプション
- 既知の制約・非互換性

### Step 2: コード作成

Context7で確認した仕様に基づいてPlantUMLコードを作成。

### Step 3: バリデーション（必須）

```
mcp__plantuml-validator__generate_plantuml_diagram
```

- 検証失敗時は修正→再検証（最大5回リトライ）
- 検証スキップ・エラー無視は**禁止**

### Step 4: 保存/コミット

バリデーション成功後のみ保存・コミット可能。

### よく使うContext7クエリ例

| 図表タイプ | topic |
|-----------|-------|
| アクティビティ図 | `"activity diagram swimlane"` |
| シーケンス図 | `"sequence diagram"` |
| ユースケース図 | `"use case diagram"` |
| クラス図 | `"class diagram"` |
| コンポーネント図 | `"component diagram"` |
| 状態図 | `"state diagram"` |

### 禁止事項

- Context7確認なしでのPlantUMLコード作成
- バリデーション未実施での保存
- エラー無視・検証スキップ

## Directory Structure

```
PlantUML2_Opus4.5/
├── .claude/
│   ├── agents/              # カスタムエージェント定義
│   └── settings.local.json  # MCP設定・権限
├── .obsidian/               # Obsidian設定
│   └── plugins/             # PlantUML、Excalidrawプラグイン
├── .serena/
│   ├── memories/            # プロジェクト知識永続化
│   ├── project.yml          # Serena設定
│   └── QUICK_REFERENCE.md   # Serenaクイックリファレンス
├── .vscode/
│   └── settings.json        # VSCode設定
├── doc/
│   └── AI_DRIVEN_DEV_ENVIRONMENT_SETUP_GUIDE.md  # AI駆動開発ガイド
├── docs/
│   ├── context/             # Memory Bank（Layer 1）
│   │   ├── project_brief.md
│   │   ├── active_context.md
│   │   ├── technical_decisions.md
│   │   └── coding_standards.md
│   ├── design/              # 下書き・たたき台（未レビュー）
│   │   └── PlantUML_Studio_設計図表_20251130.md
│   ├── evidence/            # 作業証跡
│   │   ├── 20251130_claude_md_update/
│   │   ├── 20251130_sequence_diagrams/
│   │   ├── 20251201_business_flow_diagram/
│   │   ├── 20251202_auth_flow/
│   │   └── 20251206_project_management/
│   ├── proposals/           # 正式版（レビュー済み）
│   │   ├── PlantUML_Studio_コンテキスト図_20251130.md
│   │   ├── PlantUML_Studio_ユースケース図_20251130.md
│   │   ├── PlantUML_Studio_シーケンス図_ログイン_20251130.md
│   │   ├── PlantUML_Studio_業務フロー図_20251201.md
│   │   └── PlantUML_Studio_開発ステップ詳細化計画_20251130.md
│   ├── session_handovers/   # セッション引継ぎ資料
│   ├── templates/           # ドキュメントテンプレート
│   ├── guides/              # ガイドドキュメント
│   └── poc/evidence/        # PoC証跡（Layer 3）
├── scripts/
│   ├── create_evidence.ps1  # Evidence自動作成（Windows）
│   └── create_evidence.sh   # Evidence自動作成（Linux/macOS）
└── CLAUDE.md                # プロジェクトガイド
```

## Tech Stack (Planned)

- **Frontend**: Next.js (App Router), React, TypeScript, Monaco Editor, Tailwind CSS, shadcn/ui
- **Backend**: Supabase, Next.js API Routes
- **AI Integration**: PlantUML Validator MCP, OpenAI/Claude API
- **Deployment**: Vercel (Frontend), Google Cloud Run (MCP Validator)
  - GCP Project: `plantuml-477523`, Region: `asia-northeast1`

## Serena Usage

Serenaは積極的に活用する：
- `mcp__serena__list_memories`: 保存済みメモリ一覧
- `mcp__serena__read_memory`: メモリ読み込み（関連タスク時）
- `mcp__serena__search_for_pattern`: コード/ドキュメント検索
- `mcp__serena__find_symbol`: シンボル検索
- `mcp__serena__get_symbols_overview`: ファイル内シンボル一覧

## Evidence Creation Rules

すべての作業で**Evidence 3点セット**作成必須：
1. `instructions.md`: 作業開始時に作成
2. `00_raw_notes.md`: 作業中にリアルタイム更新
3. `work_sheet.md`: 作業完了時に作成

自動化スクリプト: `pwsh scripts/create_evidence.ps1 <evidence_name>`

## Session Handovers

以下のタイミングで引継ぎ資料を作成：
- Phase完了時
- 重要なマイルストーン達成時
- 長期作業の中断時
- トークン使用率90%到達時

---

## 作業開始時の確認フロー

### 0. セッション引継ぎ資料を確認（最優先）

**次セッション開始時**:
- `docs/session_handovers/<latest>.md`: 前セッションからの引継ぎ資料
  - 最新の引継ぎ資料を確認（ファイル名でソート: `YYYYMMDD-HHMM_*.md`）
  - 次の作業ステップ、優先度、必読ドキュメントを把握

### 1. Memory Bankを読む

**初回セッション時**:
- `docs/context/project_brief.md`: プロジェクト目標、技術スタック、ロードマップ
- `docs/context/active_context.md`: 現在の状況、進行中の作業、次のタスク

**技術決定が必要な時**:
- `docs/context/technical_decisions.md`: 既存決定（TD-001〜）を確認
- 新しい決定をした場合: technical_decisions.mdに追記

### 2. 作業開始チェックリスト実行

**所要時間**: 約5分

1. **Memory Bank確認**（3分）
   - `CLAUDE.md`, `docs/context/active_context.md`, `docs/context/technical_decisions.md`

2. **Evidenceディレクトリとテンプレート作成**（1分）
   ```powershell
   pwsh scripts/create_evidence.ps1 <work_type>
   ```

3. **instructions.md編集**（4分）
   - 目標、コンテキスト、実施内容、完了条件を明記

4. **Todoリスト作成**
   - `TodoWrite`ツールでタスクをリストアップ

---

## Memory Bank活用方法

### 初回セッション時

1. **project_brief.md を必ず読む**
   - プロジェクト目標、技術スタック、制約を理解

2. **active_context.md で現在地を把握**
   - 進行中の作業
   - 次のタスク
   - ブロッカー

3. **関連ドキュメントへ深掘り**
   - technical_decisions.md: 技術判断の背景
   - coding_standards.md: コーディング規約

### Memory Bank構成

| ファイル | 内容 | 更新タイミング |
|---------|------|---------------|
| `project_brief.md` | プロジェクト目標、スコープ、ロードマップ | Phase変更時 |
| `active_context.md` | 現在の状況、進行中の作業 | 毎セッション |
| `technical_decisions.md` | 技術決定記録（TD-001〜） | 決定時 |
| `coding_standards.md` | コーディング規約 | 規約変更時 |

---

## Serena活用パターン

### 作業開始時（必須4ステップ）

```
1. mcp__serena__activate_project  → プロジェクトをアクティベート
2. mcp__serena__get_current_config → 設定確認
3. mcp__serena__list_dir          → ディレクトリ構造把握
4. mcp__serena__list_memories     → 利用可能なメモリ一覧
```

### パターン別活用

| パターン | 用途 | 使用ツール |
|---------|------|-----------|
| パターン1 | instructions.md作成 | `list_dir`, `find_file`, `read_memory` |
| パターン2 | 00_raw_notes.md更新 | `get_symbols_overview`, `find_symbol` |
| パターン3 | work_sheet.md作成 | `find_referencing_symbols`, `search_for_pattern` |
| パターン4 | セッション終了 | `write_memory` |

---

## 重要な制約（憲法級ルール）

以下のルールは**絶対に守ること**：

| ルール | 説明 |
|--------|------|
| Evidence 3点セット必須 | すべての作業で`instructions.md`, `00_raw_notes.md`, `work_sheet.md`を完備 |
| トークン90%ルール | トークン使用率90%到達時に引継ぎ資料を自動作成 |
| Serena Memories保存 | セッション終了時に`write_memory`で知識を永続化 |
| 正式版はproposals/ | PRDに採用するのは`docs/proposals/`内のレビュー済みファイルのみ |
| **進捗管理表の更新** | 作業完了時に`docs/context/active_context.md`を更新（図表進捗、UCカバレッジ、変更履歴） |
| 技術仕様厳守 | node-plantuml（内部）、Monaco Editor、API Routes経由 |

---

## 関連ドキュメント

| ドキュメント | パス | 内容 |
|-------------|------|------|
| AI駆動開発ガイド | `doc/AI_DRIVEN_DEV_ENVIRONMENT_SETUP_GUIDE.md` | 環境構築・運用の完全ガイド |
| Memory Bank | `docs/context/` | プロジェクト全体の知識ベース |
| テンプレート集 | `docs/templates/` | Evidence・引継ぎ資料テンプレート |
| セッション引継ぎ | `docs/session_handovers/` | 過去のセッション引継ぎ資料 |
