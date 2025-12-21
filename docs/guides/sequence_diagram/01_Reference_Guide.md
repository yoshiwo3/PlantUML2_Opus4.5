# シーケンス図作成 参照ガイド

**作成日**: 2025-12-20
**対象**: Phase 2 シーケンス図 6本
**前提**: MVP シーケンス図 8/8 完了

---

## 概要

本ガイドは、シーケンス図を作成する際に参照すべきドキュメントを整理したものです。
Phase 2 シーケンス図（6本）の作成時に活用してください。

---

## 0. セッション開始手順（作業前に実行）

シーケンス図作成セッションを開始する前に、以下の手順を実行すること。

### 0.1 コンテキスト確認

- [ ] `docs/context/active_context.md` でシーケンス図進捗を確認
  - 現在の進捗: MVP 8/8 ✅、Phase 2 2/6
  - 次に作成すべきUCを特定
- [ ] 本ガイド（§2）で対象UCの重点参照先を確認

### 0.2 SERENA Memory確認

```
mcp__serena__list_memories
```

関連メモリを確認し、必要に応じて読み込む:

| メモリ名パターン | 内容 |
|-----------------|------|
| `session_*_sequence_*` | 過去のシーケンス図作成セッション記録 |
| `session_*_class_diagram_*` | クラス図更新記録（整合性確認用） |
| `plantuml_*` | PlantUML関連の知見・標準 |

```
mcp__serena__read_memory → memory_file_name: "<関連メモリ名>"
```

### 0.3 Evidence作成

作業開始前にEvidenceディレクトリを作成する。

```powershell
# 1. 現在時刻を確認
Get-Date -Format "yyyyMMdd_HHmm"

# 2. Evidenceディレクトリ作成（3点セット自動生成）
pwsh scripts/create_evidence.ps1 <yyyyMMdd_HHmm>_sequence_<uc_name>

# 例: UC 3-10 学習コンテンツ検索の場合
pwsh scripts/create_evidence.ps1 20251221_1400_sequence_learning_content_search
```

**Evidence 3点セット**:

| ファイル | 作成タイミング | 内容 |
|---------|--------------|------|
| `instructions.md` | 作業開始時 | 目標、コンテキスト、完了条件 |
| `00_raw_notes.md` | 作業中 | リアルタイムの作業ログ、レビュー結果 |
| `work_sheet.md` | 作業完了時 | 成果物、知見、次のアクション |

### 0.4 Todoリスト作成

`TodoWrite`ツールでタスクをリストアップする。

**シーケンス図作成の標準Todoテンプレート**:

```
1. 関連ドキュメント確認（業務フロー図、機能一覧表、クラス図）
2. UC固有分析（§0.5）— 設計パターン要否確認
3. Context7でPlantUML仕様確認
4. PlantUMLコード作成
5. PNG生成・5パスレビュー（Pass 5: 設計パターン含む）
6. レビューログ更新
7. SVG生成・統合版追加
8. active_context.md更新
9. SERENA Memory保存
10. Git commit
```

### 0.5 UC固有分析（LL-027）

**シーケンス図作成前に、UC固有の設計パターン要否を分析すること。**

> **チェックリスト**: → `docs/guides/sequence_diagram/Design_Pattern_Checklist.md` を参照
>
> DP-001〜DP-006（レジリエンス、デバウンス、キャッシュ、レート制限、監査ログ、分散トレーシング）

**背景**: UC 3-10作成時に、デバウンス・キャッシュ・503エラー等の「設計パターンの知識」はあったが、プロセスに「適用トリガー」がなかったため適用しなかった（LL-027）。

---

## 1. 必須参照ドキュメント

### 1.1 作成ガイドライン（最優先）

シーケンス図作成前に必ず確認すること。

| ドキュメント | パス | 目的 |
|-------------|------|------|
| **シーケンス図作成ガイド** | `docs/guides/sequence_diagram/02_Authoring_Guide.md` | 8項目チェックリスト、Repository Pattern、参加者命名規則、エラーハンドリング網羅 |
| **PlantUML開発憲法** | `docs/guides/PlantUML_Development_Constitution.md` | v5.0、禁止事項9項目、技術的制限、5パスレビュー手順 |
| **アクティブバー知見ベース** | `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` | LL-001〜LL-027（特にLL-025: ネストalt状態追跡、LL-026: クラス図整合性、LL-027: 設計パターン適用トリガー） |
| **設計パターンチェックリスト** | `docs/guides/sequence_diagram/Design_Pattern_Checklist.md` | DP-001〜DP-006（レジリエンス、パフォーマンス、セキュリティ） |
| **シーケンス図パターン集** | `docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md` | NL-001〜NL-007（非アクティブバーパターン） |

### 1.2 設計仕様（UC理解）

UCの詳細仕様と業務フローを理解するために参照。

| ドキュメント | パス | 目的 |
|-------------|------|------|
| **業務フロー図** | `docs/proposals/03_業務フロー図_20251201.md` | 業務フロー詳細（3.2 AI支援、3.9 管理機能、3.10 学習コンテンツ） |
| **機能一覧表** | `docs/proposals/05_機能一覧表_20251213.md` | 機能ID（F-xxx-xx）、UC詳細、入出力、エラーハンドリング |
| **クラス図** | `docs/proposals/06_クラス図_20251208.md` | Service/Repository構造（v1.8）、ドメインモデル、外部クライアント |
| **CRUD表** | `docs/proposals/07_CRUD表_20251213.md` | 機能×エンティティ操作マトリクス |

### 1.3 技術決定

アーキテクチャ判断の根拠を確認。

| ドキュメント | パス | 関連TD |
|-------------|------|--------|
| **技術決定記録** | `docs/context/technical_decisions.md` | TD-007（OpenRouter/OpenAI分離）、TD-008（LLMワークフローDAG）、TD-009（Embedding再生成戦略） |

### 1.4 既存シーケンス図（パターン参照）

既存の完成済みシーケンス図からパターンを参照。

| ドキュメント | パス | 参照ポイント |
|-------------|------|-------------|
| **シーケンス図統合版** | `docs/proposals/08_シーケンス図_20251214.md` | フォーマット、skinparam、参加者定義 |

#### 参照すべきセクション

| セクション | 参照ポイント |
|-----------|-------------|
| §1-2 認証フロー | OAuth PKCE、セッション管理パターン |
| §3 図表作成・テンプレート | Storage操作、Repository Pattern |
| §5 保存・エクスポート | 複合操作、用語チェック連携 |
| §7 AI Question-Start | **SSEストリーミング、OpenRouter連携**（Phase 2で最も参考になる） |

---

## 2. Phase 2 UC別 重点参照先

各UCで特に重点的に参照すべきドキュメントとセクション。

### UC 4-2: AIチャット ✅ 完了

| 参照先 | 内容 |
|--------|------|
| `08_シーケンス図_20251214.md` §8 | AIチャット（UC 4-2）— 会話履歴管理、コンテキスト維持 |
| `03_業務フロー図_20251201.md` §3.2 | PlantUML AI支援フロー |
| `technical_decisions.md` TD-007 | OpenRouter経由でLLM利用 |
| `06_クラス図_20251208.md` | AIService.chat()（v1.8追加）、ChatContext、ChatResponse |

**完了**: 2025-12-21。§7 AI Question-Startをベースに会話継続機能を追加。クラス図v1.8との整合性確認済み（LL-026）。

### UC 3-10: 学習コンテンツ検索 ✅ 完了

| 参照先 | 内容 |
|--------|------|
| `08_シーケンス図_20251214.md` §9 | 学習コンテンツ検索（UC 3-10）— Hybrid Search |
| `03_業務フロー図_20251201.md` §3.10 | 学習コンテンツフロー |
| `technical_decisions.md` TD-007 | OpenAI Embedding直接接続 |
| `06_クラス図_20251208.md` | EmbeddingService、LearningContentRepository |

**完了**: 2025-12-21。TD-007準拠（OpenAI Embedding直接接続）。Hybrid Search（ベクトル検索 + 全文検索BM25）実装。LL-001準拠。

### UC 5-1: ユーザー管理

| 参照先 | 内容 |
|--------|------|
| `03_業務フロー図_20251201.md` §3.9.1 | ユーザー管理フロー（詳細確認、権限変更、無効化） |
| `06_クラス図_20251208.md` | UserService、IUserRepository |
| `05_機能一覧表_20251213.md` F-ADM-01 | ユーザー管理機能詳細 |

**ポイント**: Supabase Auth連携、権限レベル（admin/user）

### UC 5-2: LLMモデル登録

| 参照先 | 内容 |
|--------|------|
| `03_業務フロー図_20251201.md` §3.9.2 | LLM管理フロー |
| `technical_decisions.md` TD-007 | OpenRouter統一API |
| `06_クラス図_20251208.md` | LLMService、OpenRouterClient |
| `05_機能一覧表_20251213.md` F-ADM-02 | LLMモデル登録機能詳細 |

**ポイント**: OpenRouter利用可能モデル一覧取得、モデルメタデータ保存

### UC 5-7: LLM使用量監視

| 参照先 | 内容 |
|--------|------|
| `03_業務フロー図_20251201.md` §3.9.2 | LLM使用量監視フロー |
| `06_クラス図_20251208.md` | UsageLogRepository、LLMService |
| `05_機能一覧表_20251213.md` F-ADM-07 | LLM使用量監視機能詳細 |

**ポイント**: UsageLog集計、期間指定、モデル別/ユーザー別統計

### UC 5-11: 学習コンテンツ登録

| 参照先 | 内容 |
|--------|------|
| `03_業務フロー図_20251201.md` §3.10 | 学習コンテンツフロー |
| `technical_decisions.md` TD-007 | OpenAI Embedding（text-embedding-3-small） |
| `technical_decisions.md` TD-009 | Embedding再生成戦略 |
| `06_クラス図_20251208.md` | EmbeddingService、LearningContentRepository |

**ポイント**: チャンク分割（512 tokens）、pgvector保存、バックグラウンドジョブ

---

## 3. 作成前チェックリスト

シーケンス図作成前に以下を確認すること。

### 3.1 設計確認

- [ ] 業務フロー図の該当セクションを確認したか
- [ ] 機能一覧表の該当UC番号・機能IDを確認したか
- [ ] クラス図v1.8を確認し、使用するService/Repositoryを特定したか
- [ ] 関連する技術決定（TD-xxx）を確認したか

### 3.2 ガイドライン確認

- [ ] シーケンス図作成ガイドのチェックリスト（§7）を確認したか
- [ ] PlantUML開発憲法の禁止事項（§2）を確認したか
- [ ] アクティブバー知見ベース（LL-025: alt/else状態追跡）を確認したか

### 3.3 パターン参照

- [ ] 既存シーケンス図から類似パターンを特定したか
- [ ] 参加者命名規則を確認したか
- [ ] エラーハンドリング（400/401/403/404/409/500/503）を検討したか

### 3.4 クラス図整合性確認（LL-026）

- [ ] シーケンス図で使用するServiceメソッドがクラス図v1.8に存在するか
- [ ] メソッドの引数・戻り値がシーケンス図と一致するか
- [ ] 新規メソッドが必要な場合、クラス図を先に更新したか

---

## 4. ファイル命名規則

### 4.1 SVGファイル

```
<セクション番号>_<サブセクション>_<説明>.svg
```

| UC | 予定セクション | SVGファイル名 | 状況 |
|----|---------------|--------------|:----:|
| 4-2 | §8 | `8_1_AI_Chat.svg` | ✅ |
| 3-10 | §9 | `9_1_Learning_Content_Search.svg` | ✅ |
| 5-1 | §10 | `10_1_User_Management.svg` | 🔴 |
| 5-2 | §11 | `11_1_LLM_Model_Register.svg` | 🔴 |
| 5-7 | §12 | `12_1_LLM_Usage_Monitor.svg` | 🔴 |
| 5-11 | §13 | `13_1_Learning_Content_Register.svg` | 🔴 |

### 4.2 Evidenceディレクトリ

```
docs/evidence/yyyyMMdd_HHmm_sequence_<uc_name>/
```

例: `docs/evidence/20251221_1400_sequence_ai_chat/`

---

## 5. 外部システム連携一覧

Phase 2で連携する外部システム。

| 外部システム | 用途 | 関連UC |
|-------------|------|--------|
| **OpenRouter** | LLM API（Chat/Completion） | 4-2, 5-2, 5-7 |
| **OpenAI** | Embedding API（text-embedding-3-small） | 3-10, 5-11 |
| **Supabase Auth** | 認証・ユーザー管理 | 5-1 |
| **Supabase Storage** | ファイル保存 | - |
| **Supabase pgvector** | ベクトル検索 | 3-10, 5-11 |

---

## 6. 参照ドキュメント一覧（パス）

### ガイドライン

```
docs/guides/sequence_diagram/02_Authoring_Guide.md
docs/guides/PlantUML_Development_Constitution.md
docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md
docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md
docs/guides/sequence_diagram/Design_Pattern_Checklist.md
```

### 設計仕様

```
docs/proposals/03_業務フロー図_20251201.md
docs/proposals/05_機能一覧表_20251213.md
docs/proposals/06_クラス図_20251208.md
docs/proposals/07_CRUD表_20251213.md
docs/proposals/08_シーケンス図_20251214.md
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
| 2025-12-20 | 初版作成（Phase 2 シーケンス図6本用） |
| 2025-12-21 | UC 4-2完了反映、クラス図v1.7→v1.8更新、§3.4クラス図整合性確認追加 |
| 2025-12-21 | §0追加（セッション開始手順: コンテキスト確認、SERENA Memory、Evidence作成、Todoリスト） |
| 2025-12-21 | UC 3-10完了反映（Phase 2: 2/6）、§4.1状況列追加 |
| 2025-12-21 | §0.5追加（UC固有分析: LL-027設計パターン適用トリガー）、§1.1更新（5パスレビュー、DP-001〜006） |
