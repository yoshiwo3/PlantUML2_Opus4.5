# UI設計図表作成 参照ガイド

**作成日**: 2025-12-22
**対象**: ワイヤーフレーム・画面遷移図作成
**前提**: UI設計図表開発憲法 v3.0

---

> **重要**: 本ガイドを読む前に [`00_Session_Start.md`](./00_Session_Start.md) を確認し、作業プロセス（ユーザー確認必須、1セッション=1画面セット）を理解すること。

---

## 概要

本ガイドは、UI設計図表（ワイヤーフレーム・画面遷移図）を作成する際に参照すべきドキュメントを整理したものです。

---

## 0. セッション開始手順（作業前に実行）

UI設計図表作成セッションを開始する前に、以下の手順を実行すること。

### 0.1 コンテキスト確認

- [ ] `docs/context/active_context.md` でUI設計進捗を確認
  - 現在の進捗: ワイヤーフレーム X/Y、画面遷移図 完了/未作成
  - 次に作成すべき画面を特定
- [ ] 本ガイド（§2）で対象画面の重点参照先を確認

### 0.2 SERENA Memory確認

```
mcp__serena__list_memories
```

関連メモリを確認し、必要に応じて読み込む:

| メモリ名パターン | 内容 |
|-----------------|------|
| `session_*_ui_design_*` | 過去のUI設計作成セッション記録 |
| `wireframe_research_*` | ワイヤーフレーム調査記録 |
| `td015_*` | TD-015意思決定記録 |

### 0.3 Evidence作成

作業開始前にEvidenceディレクトリを作成する。

```powershell
# 1. 現在時刻を確認
Get-Date -Format "yyyyMMdd_HHmm"

# 2. Evidenceディレクトリ作成（3点セット自動生成）
pwsh scripts/create_evidence.ps1 <yyyyMMdd_HHmm>_ui_design_<screen_name>

# 例: ログイン画面の場合
pwsh scripts/create_evidence.ps1 20251222_1400_ui_design_login
```

### 0.4 Todoリスト作成

`TodoWrite`ツールでタスクをリストアップする。

**UI設計図表作成の標準Todoテンプレート**:

```
1. 関連ドキュメント確認（UC図、業務フロー図、機能一覧表）
2. TD-015原則確認（低精度、手書き風、グレースケール）
3. ワイヤーフレーム作成
4. PNG/SVGエクスポート
5. 5パスレビュー・Phase 1-A採点
6. 画面遷移図更新（該当時）
7. Phase 1-Bレビュー・採点（該当時）
8. active_context.md更新
9. SERENA Memory保存
10. Git commit
```

---

## 1. 必須参照ドキュメント

### 1.1 作成ガイドライン（最優先）

UI設計図表作成前に必ず確認すること。

| ドキュメント | パス | 目的 |
|-------------|------|------|
| **UI設計図表開発憲法** | `docs/guides/ui_design/UI_Design_Constitution.md` | v3.0、禁止事項10項目、3フェーズ評価、命名規則 |
| **UI設計作成ガイド** | `docs/guides/ui_design/02_Authoring_Guide.md` | チェックリスト、TD-015適用、スタイル設定 |
| **知見ベース** | `docs/guides/ui_design/UI_Design_Knowledge_Base.md` | EX-001〜, SD-001〜, TD-001〜, IC-001〜 |
| **設計パターンチェックリスト** | `docs/guides/ui_design/Design_Pattern_Checklist.md` | UIパターン（アクセシビリティ、ナビゲーション） |
| **UI設計パターン集** | `docs/guides/ui_design/UI_Design_Patterns.md` | 実装パターン・テンプレート |

### 1.2 設計仕様（画面理解）

画面の詳細仕様と業務フローを理解するために参照。

| ドキュメント | パス | 目的 |
|-------------|------|------|
| **UC図** | `docs/proposals/02_ユースケース図_20251130.md` | 機能要件、32UC定義 |
| **業務フロー図** | `docs/proposals/03_業務フロー図_20251201.md` | 業務フロー詳細（3.1〜3.11） |
| **機能一覧表** | `docs/proposals/05_機能一覧表_20251213.md` | 機能ID（F-xxx-xx）、UC詳細 |
| **コンテキスト図** | `docs/proposals/01_コンテキスト図_20251130.md` | システム境界、外部アクター |

### 1.3 技術決定

アーキテクチャ判断の根拠を確認。

| ドキュメント | パス | 関連TD |
|-------------|------|--------|
| **技術決定記録** | `docs/context/technical_decisions.md` | TD-015（ワイヤーフレーム方針）、TD-006（Storage設計） |

---

## 2. 画面カテゴリ別 重点参照先

各画面カテゴリで特に重点的に参照すべきドキュメントとセクション。

### 認証画面群（auth）

| 画面 | 対応UC | 参照先 |
|------|--------|--------|
| ログイン画面 | UC 1-1 | 業務フロー §3.4、機能一覧 F-AUTH-01 |
| 新規登録画面 | UC 1-1 | 業務フロー §3.4、機能一覧 F-AUTH-01 |
| パスワードリセット | UC 1-1 | 業務フロー §3.4 |

**ポイント**: Supabase Auth連携、OAuth PKCE

### メイン画面群（main）

| 画面 | 対応UC | 参照先 |
|------|--------|--------|
| ダッシュボード | UC 2-1 | 業務フロー §3.5、機能一覧 F-PRJ-01 |
| プロジェクト一覧 | UC 2-2〜2-4 | 業務フロー §3.5、機能一覧 F-PRJ-02〜04 |
| エディタ画面 | UC 3-1〜3-6 | 業務フロー §3.1, §3.6、機能一覧 F-DGM-* |

**ポイント**: Monaco Editor、PlantUML/Excalidraw切り替え

### モーダル群（modal）

| 画面 | 対応UC | 参照先 |
|------|--------|--------|
| 新規プロジェクト作成 | UC 2-1 | 業務フロー §3.5 |
| 新規図表作成 | UC 3-1 | 業務フロー §3.1 |
| エクスポート設定 | UC 3-6 | 業務フロー §3.6 |

**ポイント**: フォーカストラップ、ESCキー閉じ

### 管理画面群（admin）

| 画面 | 対応UC | 参照先 |
|------|--------|--------|
| ユーザー管理 | UC 5-1 | 業務フロー §3.9.1、機能一覧 F-ADM-01 |
| LLMモデル管理 | UC 5-2 | 業務フロー §3.9.2、機能一覧 F-ADM-02 |
| 使用量監視 | UC 5-7 | 業務フロー §3.9.2、機能一覧 F-ADM-07 |

**ポイント**: 管理者権限、テーブルビュー

---

## 3. 作成前チェックリスト

UI設計図表作成前に以下を確認すること。

### 3.1 設計確認

- [ ] UC図の該当セクションを確認したか
- [ ] 業務フロー図の該当セクションを確認したか
- [ ] 機能一覧表の該当UC番号・機能IDを確認したか

### 3.2 ガイドライン確認

- [ ] 憲法 §0（TD-015原則）を確認したか
- [ ] 憲法 §2（禁止事項）を確認したか
- [ ] 憲法 §6.3（命名規則）を確認したか

### 3.3 スタイル参照

- [ ] 既存ワイヤーフレームから類似パターンを特定したか
- [ ] Excalidrawスタイル設定（憲法 付録C）を確認したか

### 3.4 整合性確認（憲法 §1.3.7）

- [ ] 画面一覧テンプレートを確認したか
- [ ] UC/業務フロー整合性テーブルを記入したか
- [ ] 3点対比（画面一覧↔ワイヤーフレーム↔遷移図ノード）を意識しているか

---

## 4. ファイル命名規則

### 4.1 ワイヤーフレームファイル

```
NN_<category>_<screen_name>.excalidraw
```

| 画面 | 予定ファイル名 | 状況 |
|------|---------------|:----:|
| ログイン画面 | `01_auth_login.excalidraw` | 🔴 |
| 新規登録画面 | `02_auth_signup.excalidraw` | 🔴 |
| ダッシュボード | `03_main_dashboard.excalidraw` | 🔴 |
| エディタ画面 | `04_main_editor.excalidraw` | 🔴 |
| プロジェクト一覧 | `05_main_project_list.excalidraw` | 🔴 |

### 4.2 Evidenceディレクトリ

```
docs/evidence/yyyyMMdd_HHmm_ui_design_<screen_name>/
```

例: `docs/evidence/20251222_1400_ui_design_login/`

---

## 5. 外部ツール・ライブラリ

UI設計図表作成で使用するツール。

| ツール | 用途 | 備考 |
|--------|------|------|
| **Excalidraw** | ワイヤーフレーム作成 | 手書き風スタイル |
| **PlantUML** | 画面遷移図作成 | state diagram |
| **Obsidian** | Excalidraw Plugin | ローカル編集 |

---

## 6. 参照ドキュメント一覧（パス）

### ガイドライン

```
docs/guides/ui_design/UI_Design_Constitution.md
docs/guides/ui_design/02_Authoring_Guide.md
docs/guides/ui_design/UI_Design_Knowledge_Base.md
docs/guides/ui_design/Design_Pattern_Checklist.md
docs/guides/ui_design/UI_Design_Patterns.md
```

### 設計仕様

```
docs/proposals/01_コンテキスト図_20251130.md
docs/proposals/02_ユースケース図_20251130.md
docs/proposals/03_業務フロー図_20251201.md
docs/proposals/05_機能一覧表_20251213.md
```

### コンテキスト

```
docs/context/technical_decisions.md
docs/context/active_context.md
```

---

## 更新履歴

| 日付 | 内容 |
|------|------|
| 2025-12-22 | 初版作成 |
