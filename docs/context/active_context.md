# 現在の作業コンテキスト（Active Context）

**最終更新**: 2025-12-22（UC 5-2 LLMモデル登録シーケンス図完了、憲法v5.4評価順序逆転）

---

## 現在の状況

### 現在のフェーズ

**Phase**: PRD作成（図表正式版作成中）
**ステータス**: In Progress
**進捗率**: 57%（8/14図表完了）

**Phase別内訳**:
| Phase | 内容 | 進捗 |
|:-----:|------|:----:|
| 1-2 | スコープ・プロセス定義（①②③④⑤） | 5/5 ✅ |
| 3 | データ・構造定義（⑥⑦） | 2/2 ✅ |
| 4 | 振る舞い詳細化（⑧⑨⑩） | 1/3 🟡 |
| 5 | アーキテクチャ（⑪⑫） | 0/2 🔴 |
| 6 | 品質・権限定義（⑬⑭） | 0/2 🔴 |

### 図表作成進捗

| 図表 | 状況 | 評価 | 備考 |
|------|:----:|:----:|------|
| ① コンテキスト図 | ✅ | - | 完了 |
| ② ユースケース図 | ✅ | - | 32UC定義済み |
| ③ 業務フロー図 | ✅ | - | 11/11完了（100%） |
| ④ データフロー図（DFD） | ✅ | 100点A | v5.0 draw.io形式 |
| ⑤ 機能一覧表 | ✅ | 93点A | v3.12 §12クラス図整合版 |
| ⑥ クラス図 | ✅ | 100点A | v1.8 UC 4-2整合対応 |
| ⑦ CRUD表 | ✅ | 90点A | v2.2 32機能×11エンティティ |
| ⑧ シーケンス図 | 🟡 | 100点S | 12/14完了（MVP: 8/8 ✅、Phase 2: 4/6）|
| ⑨ 画面遷移図 | 🔴 | - | 要作成 |
| ⑩ ワイヤーフレーム | 🔴 | - | 要作成 |
| ⑪ コンポーネント図 | 🔴 | - | 要作成 |
| ⑫ 外部インターフェース一覧 | 🔴 | - | 要作成 |
| ⑬ 非機能要件一覧表 | 🔴 | - | 要作成 |
| ⑭ アクター権限マトリクス | 🔴 | - | 要作成 |

**全体進捗: 8/14 完了（57%）**

### 業務フロー図 詳細進捗

| # | フロー名 | 対応UC | 優先度 | 状況 |
|---|---------|--------|:------:|:----:|
| 3.1 | PlantUML図表作成フロー | 3-1〜3-4 | MVP | ✅ |
| 3.2 | PlantUML AI支援フロー | 4-1, 4-2 | MVP | ✅ |
| 3.3 | Excalidrawワイヤーフレーム作成フロー | 3-1, 3-3 | MVP | ✅ |
| 3.4 | 認証フロー | 1-1, 1-2 | MVP | ✅ |
| 3.5 | プロジェクト管理フロー | 2-1〜2-4 | MVP | ✅ |
| 3.6 | 保存・エクスポートフロー | 3-5, 3-6 | MVP | ✅ |
| 3.7 | バージョン管理フロー | 3-7, 3-8 | MVP | ✅ |
| 3.8 | 図表削除フロー | 3-9 | MVP | ✅ |
| 3.9 | 管理機能フロー（MVP） | 5-1, 5-2〜5-5, 5-7, 5-8, 5-13 | **MVP** | ✅ |
| 3.10 | 学習コンテンツフロー | 3-10, 3-11 | Phase 2 | ✅ |
| 3.11 | 管理機能フロー（Phase 2） | 5-6, 5-9, 5-10 | Phase 2 | ✅ |

**業務フロー図 進捗: 11/11 完了（100%）** ※MVP必須: 9/9完了、Phase 2: 2/2完了

### シーケンス図 詳細進捗（14本、v3除外）

#### MVP必須（8本）

| # | シーケンス図 | 対応UC | 外部システム | 状況 |
|:-:|-------------|--------|-------------|:----:|
| 1 | 認証フロー | 1-1, 1-2 | Supabase Auth (OAuth PKCE) | ✅ 完了 |
| 2 | プロジェクトCRUD | 2-1, 2-2, 2-3, 2-4 | Supabase Storage | ✅ 完了 |
| 3 | 図表作成・テンプレート | 3-1, 3-2 | Supabase Storage | ✅ 完了 |
| 4 | 編集・プレビュー | 3-3, 3-4 | node-plantuml + OpenRouter | ✅ 完了 |
| 5 | 保存 | 3-5 | Storage + OpenRouter | ✅ 完了 |
| 6 | エクスポート | 3-6 | node-plantuml | ✅ 完了 |
| 7 | 図表削除 | 3-9 | Supabase Storage | ✅ 完了 |
| 8 | AI Question-Start | 4-1 | OpenRouter (streaming) | ✅ 完了 |

#### Phase 2（6本）

| # | シーケンス図 | 対応UC | 外部システム | 状況 |
|:-:|-------------|--------|-------------|:----:|
| 9 | AIチャット | 4-2 | OpenRouter (conversation) | ✅ 完了 |
| 10 | 学習コンテンツ検索 | 3-10 | OpenAI Embedding + pgvector | ✅ 完了 |
| 11 | ユーザー管理 | 5-1 | Supabase Auth | ✅ 完了（93点→統合95点） |
| 12 | LLMモデル登録 | 5-2 | OpenRouter + Supabase | ✅ 完了（90点） |
| 13 | LLM使用量監視 | 5-7 | OpenRouter + Supabase | 🔴 要作成 |
| 14 | 学習コンテンツ登録 | 5-11 | OpenAI Embedding + pgvector | 🔴 要作成 |

**シーケンス図 進捗: 12/14 完了（86%）**
- MVP: 8/8完了（100%） ✅
- Phase 2: 4/6

> **v3除外**: バージョン管理（UC 3-7, 3-8）はv3フェーズで作成予定のため、現在の対象外

> **スキップ対象（単純なCRUD/設定変更）**: UC 5-3, 5-4, 5-5, 5-6, 5-8, 5-9, 5-10, 5-12, 5-13, 3-11

#### シーケンス図 UCカバレッジ

| パッケージ | 総UC | シーケンス図対象 | 完了 | 残り |
|-----------|:----:|:---------------:|:----:|:----:|
| 1. 認証 | 2 | 1本（統合） | 1 | 0 |
| 2. プロジェクト管理 | 4 | 1本（統合） | 1 | 0 |
| 3. 図表操作 | 11 | 6本 | 6 | 0 |
| 4. AI機能 | 2 | 2本 | 2 | 0 |
| 5. 管理機能 | 13 | 4本 | 2 | 2 |
| **合計** | **32** | **14本** | **12** | **2** |

**知見ドキュメント**: `docs/guides/sequence_diagram/`（LL-001〜LL-027, NL-001〜NL-007, DP-001〜DP-006）

### 次のアクション（シーケンス図 Phase 2）

**作業開始手順**:
1. `CLAUDE.md` を読む
2. 本ファイル（`active_context.md`）を読む
3. `docs/guides/sequence_diagram/00_Session_Start.md` を読む
4. 下記UCの中から1つ選び、ユーザーに確認を求める

| 優先度 | UC | 説明 | 外部システム | 状況 |
|:------:|:--:|------|-------------|:----:|
| ~~1~~ | ~~UC 5-1~~ | ~~ユーザー管理~~ | Supabase Auth | ✅ 完了 |
| ~~2~~ | ~~UC 5-2~~ | ~~LLMモデル登録~~ | OpenRouter + Supabase | ✅ 完了 |
| **1** | **UC 5-7** | **LLM使用量監視** | OpenRouter + Supabase | 🔴 次 |
| 2 | UC 5-11 | 学習コンテンツ登録 | OpenAI Embedding + pgvector | 🔴 |

> **注意**: 1セッション = 1UC。複数UCを連続作成しない。

### 管理機能一覧（UC 5-1〜5-13）

| UC | 機能名 | カテゴリ | 優先度 |
|:--:|--------|----------|:------:|
| 5-1 | ユーザーを管理する | 5-A. ユーザー管理 | MVP |
| 5-2 | LLMモデルを登録する | 5-B. LLM管理 | MVP |
| 5-3 | LLMモデルを切り替える | 5-B. LLM管理 | MVP |
| 5-4 | LLMプロンプトを管理する | 5-B. LLM管理 | MVP |
| 5-5 | LLMパラメータを設定する | 5-B. LLM管理 | MVP |
| 5-6 | LLMワークフローを定義する | 5-B. LLM管理 | Phase 2 |
| 5-7 | LLM使用量を監視する | 5-B. LLM管理 | MVP |
| 5-8 | LLMフォールバックを設定する | 5-B. LLM管理 | MVP |
| 5-9 | Embeddingモデルを設定する | 5-C. Embedding管理 | Phase 2 |
| 5-10 | Embedding使用量を監視する | 5-C. Embedding管理 | Phase 2 |
| 5-11 | 学習コンテンツを登録する | 5-D. 学習コンテンツ管理 | Phase 2 |
| 5-12 | 学習コンテンツを管理する | 5-D. 学習コンテンツ管理 | Phase 2 |
| 5-13 | システム設定を変更する | 5-E. システム設定 | MVP |

**管理機能サマリ**: MVP 8件 / Phase 2 5件

### ユースケースカバレッジ（業務フロー図）

| パッケージ | 総UC数 | カバー済み | 未カバー(MVP) | 未カバー(Phase 2) |
|-----------|:------:|:----------:|:-------------:|:-----------------:|
| 1. 認証 | 2 | 2 | 0 | 0 |
| 2. プロジェクト管理 | 4 | 4 | 0 | 0 |
| 3. 図表操作 | 11 | 11 | 0 | 0 |
| 4. AI機能 | 2 | 2 | 0 | 0 |
| 5. 管理機能 | 13 | 13 | 0 | 0 |
| **合計** | **32** | **32** | **0** | **0** |

**UCサマリ（優先度別）:**
| 優先度 | 総数 | カバー済み | 未カバー |
|:------:|:----:|:----------:|:--------:|
| MVP | 23 | 23 | **0** |
| Phase 2 | 7 | 7 | **0** |
| v3 | 2 | 2 | 0 |

**業務フロー図: 全32UC完了（100%）** ✅

---

## 最近の変更

### 2025-12-22

- **UC 5-2 LLMモデル登録 シーケンス図完了** ✅
  - 評価: **90点/90点（100%）** → 合格
  - 7参加者、4セクション（利用可能モデル取得/モデル選択/登録/有効化）
  - OpenRouter連携（API経由でモデル一覧取得）
  - DP-001（レジリエンス: 503）、DP-005（監査ログ）適用
  - **統合版追記**: `08_シーケンス図_20251214.md` §11追加
    - §12技術仕様にLLM管理API追加（2エンドポイント + 型定義）
  - SVG: `docs/proposals/diagrams/08_sequence/PlantUML_Studio_Sequence_LLMModelRegistration.svg`
  - **シーケンス図進捗**: 11/14 → 12/14（Phase 2: 3/6 → 4/6）
  - Evidence: `docs/evidence/20251222_0013_sequence_uc5_2_llm_model/`

- **PlantUML開発憲法 v5.4 更新（評価順序逆転）** ✅
  - **確証バイアス低減**: Phase 1-B（視覚品質評価）を先に、Phase 1-A（コード品質評価）を後に実行
  - ソースコードを見ずにPNGのみで視覚評価を先行することで、コード知識による偏りを排除
  - §1.1フロー図、§1.3/§1.3Aセクション順序を逆転
  - 変更ログ: v5.3（3フェーズ評価体系導入）、v5.4（評価順序逆転）

### 2025-12-21

- **UC 5-1 ユーザー管理 シーケンス図完了** ✅
  - 評価: **93点/95点（98%）** → 合格
  - 改善ループ: 初回77点（LL-001違反9箇所）→ 修正後93点
  - 7参加者、4セクション（一覧/詳細/ロール変更/無効化）
  - DP-001（レジリエンス: 503）、DP-005（監査ログ）適用
  - **統合版追記**: `08_シーケンス図_20251214.md` §10追加（評価: 95/95点 満点）
    - §11技術仕様に管理API追加（4エンドポイント + 型定義）
  - **PlantUML開発憲法更新**: v5.0 → v5.1 → v5.2
    - §1.3.5〜§1.3.7追加（問題予防チェックリスト、LL-001専用ガイド、DP実装チェックリスト）
    - §1.4追加（ドキュメント統合後の評価・採点、90点以上合格）
    - §1.7追加（作業完了時の知見反映プロセス）
  - **知見反映**: Activation_Bar_Knowledge_Base.md にCS-001追加（LL-001大量違反パターン）
  - **CLAUDE.md更新**: PlantUML作業時の追加ルール（§1.7参照）追加
  - Evidence: `docs/evidence/20251221_1655_sequence_user_management/`

- **UC 4-2 AIチャット シーケンス図完了** ✅
  - UC 4-2: AIチャットで図表を修正する（OpenRouter conversation）
  - §7 AI Question-Startをベースに会話継続機能を追加
  - 7参加者、ネストalt/else（外側5分岐 + 内側4分岐）、loopブロック
  - **§7との差分**:
    - エンドポイント: `/api/ai/chat`
    - `context_code`必須、`messages`履歴配列、`chat_mode`追加
    - 400 CONTEXT_REQUIRED エラー追加
  - 4パスレビュー完了（LL-025準拠）
  - SVG: `docs/proposals/diagrams/08_sequence/8_1_AI_Chat.svg`
  - 統合版: `08_シーケンス図_20251214.md` §8追加（旧§8技術仕様→§9にリネンバリング）
  - **シーケンス図進捗**: 8/14 → 9/14（Phase 2: 1/6）
  - Evidence: `docs/evidence/20251220_2330_sequence_ai_chat/`

- **UC 3-10 学習コンテンツ検索 シーケンス図完了** ✅
  - UC 3-10: 学習コンテンツを検索する（OpenAI Embedding + pgvector Hybrid Search）
  - 8参加者、TD-007準拠（Embedding: OpenAI直接接続）
  - Hybrid Search実装（ベクトル類似度 + 全文検索BM25）
  - 4パスレビュー完了（LL-001準拠）
  - SVG: `docs/proposals/diagrams/08_sequence/9_1_Learning_Content_Search.svg`
  - 統合版: `08_シーケンス図_20251214.md` §9追加（旧§9技術仕様→§10にリナンバリング）
  - **シーケンス図進捗**: 9/14 → 10/14（Phase 2: 2/6）
  - Evidence: `docs/evidence/20251221_0100_sequence_learning_content_search/`

- **クラス図 v1.8 更新（UC 4-2シーケンス図整合性対応）** ✅
  - Ultrathink分析により `AIService.chat()` メソッド未定義を発見
  - UC 4-1（単発）とUC 4-2（マルチターン）の責務分離を確認
  - **追加内容**:
    - `AIService.chat(message, context, chatMode, messages[]): ChatResponse`
    - 値オブジェクト: ChatContext, ChatResponse, Suggestion, Message
    - 列挙型: ChatMode, ChatPhase, SuggestionType, MessageRole
    - PromptPurpose に AI_CHAT_* を追加
  - **クラス図バージョン**: v1.7 → v1.8

### 2025-12-20

- **UC 4-1 AI Question-Start シーケンス図完了** ✅
  - UC 4-1: AI Question-Startで図表を生成する（OpenRouter SSEストリーミング）
  - 7参加者、5フェーズ、エラーハンドリング（401/403/429/500/503）
  - 4パスレビュー完了
  - SVG: `docs/proposals/diagrams/08_sequence/7_1_AI_Question_Start.svg`
  - 統合版: `08_シーケンス図_20251214.md` §7追加
  - **シーケンス図進捗**: 7/14 → 8/14（**MVP: 8/8完了** ✅）
  - Evidence: `docs/evidence/20251220_2214_sequence_ai_question_start/`

- **LL-025知見追加（ネストaltでのactivate漏れ防止）** ✅
  - UC 4-1作成時にアクティブバー欠落を発見
  - 根本原因: LL-001の「知識」はあったが「適用」しなかった
  - **ドキュメント更新**:
    - `Activation_Bar_Knowledge_Base.md`: LL-025追加（24→25項目）
    - `Sequence_Diagram_Authoring_Guide.md`: §7「alt/else状態追跡チェックリスト」追加
    - `PlantUML_Development_Constitution.md`: v4.7 LL-025参照追加

- **シーケンス図 §5 再構成** ✅
  - UC 3-5（保存）とUC 3-6（エクスポート）を§5「保存・エクスポート」に統合
  - SVGリネーム: `PlantUML_Studio_Sequence_Save.svg` → `5_1_Save.svg`, `6_1_Export.svg` → `5_2_Export.svg`
  - 業務フロー3.6（保存・エクスポートフロー）との整合性確保

- **UC 3-9 図表削除シーケンス図完了** ✅
  - UC 3-9: 図表を削除する（確認ダイアログ、カスケード削除）
  - SVG: `docs/proposals/diagrams/08_sequence/6_1_Delete.svg`
  - 統合版: `08_シーケンス図_20251214.md` §6追加

### 2025-12-18

- **シーケンス図アクティブバー知見統合** ✅
  - UC 3-5作成時に発見した知見を正式ドキュメントに統合
  - **新規作成ファイル**:
    - `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` (LL-001〜LL-024)
    - `docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md` (NL-001〜NL-007)
    - `docs/guides/Sequence_Diagram_Knowledge_Integration_Strategy.md`
  - **更新ファイル（最小限追加）**:
    - `PlantUML_Development_Constitution.md`: +5行
    - `Sequence_Diagram_Authoring_Guide.md`: +1行、`md_authoring_guides/`に移動
  - **制約遵守**: Constitution既存テキスト変更なし（追加のみ）
  - Evidence更新: `00_raw_notes.md`, `sequence_save.review.json`に偽陽性分析追加
  - **統計**: 偽陽性レビュー6回/7サイクル、知見31件（LL 24 + NL 7）

- **proposalsディレクトリ再構成** ✅
  - **ファイル名変更（番号プレフィックス追加）**:
    - `PlantUML_Studio_*` → `01_〜08_*`
  - **diagramsディレクトリ再構成**:
    - `business_flow/` → `03_business_flow/`
    - `class/` → `06_class/`
    - `sequence/` → `08_sequence/`
    - 新規: `01_context/`, `02_usecase/`, `04_dfd/`
  - **DFD図追加**: Level 0/1/2 のSVG・Mermaid PNG 20ファイル

- **Git push完了**: `e780ce3` (80ファイル、+3790/-594行)

- **UC 3-6 エクスポートシーケンス図追加** ✅
  - UC 3-6: 図表エクスポートフロー（node-plantuml PNG/SVG/PDF）
  - ExportService → ValidationService 経由のレンダリング
  - 4パス視覚的レビュー完了
  - **シーケンス図進捗**: 5/14 → 6/14（MVP: 6/8完了、75%）
  - 統合版: `08_シーケンス図_20251214.md` §5追加
  - SVG: `docs/proposals/diagrams/08_sequence/6_1_Export.svg`
  - Evidence: `docs/evidence/20251218_0104_sequence_export/`

### 2025-12-16

- **UC 3-5 保存シーケンス図追加** ✅
  - UC 3-5: 図表保存フロー（Storage + 用語チェック）
  - Repository Pattern準拠（DiagramService → IDiagramRepository → Supabase Storage）
  - 初期読込シーケンス明示（「前提」ではなくAPI呼び出し記述）
  - エラーハンドリング: 400 構文エラー、500 Storage書き込み失敗
  - 用語チェック: TD-007準拠（OpenRouter API経由、非同期処理）
  - **メッセージチェック表方式導入**: 50メッセージの始点・終点アクティブバーを事前チェック
  - **PlantUML activate/deactivate教訓**:
    - LL-001: else分岐はalt開始時点の状態を継承
    - LL-002: 選択的activate（first branchでdeactivateされた参加者のみ）
    - LL-003: メッセージチェック表の有効性
  - 5パス視覚的レビュー完了
  - SVG生成: `docs/proposals/diagrams/08_sequence/PlantUML_Studio_Sequence_Save.svg`
  - Evidence: `docs/evidence/20251215_2345_sequence_save/`
  - **シーケンス図進捗**: 4/14 → 5/14（MVP: 5/8完了、63%）

### 2025-12-15

- **UC 3-3, 3-4 編集・プレビュー シーケンス図追加** ✅
  - UC 3-3: 図表編集フロー（Monaco Editor + デバウンス + node-plantuml）
  - UC 3-4: 図表プレビュー・AI修正提案フロー（ValidationService + OpenRouter）
  - TD-007 AI機能プロバイダー構成準拠（OpenRouter経由でLLM利用）
  - 4パスレビュー完了（Pass 2: アクティブバー詳細確認、UC 3-3修正実施）
  - SVG 2件生成: `4_1_Edit.svg`, `4_2_Preview.svg`
  - 統合版シーケンス図v2.2に追加
  - Evidence: `docs/evidence/20251214_2330_sequence_edit_preview/`
  - **シーケンス図進捗**: 3/14 → 4/14（MVP: 4/8完了、50%）

- **PlantUML開発憲法 v4.3 更新（シーケンス図チェック項目追加）** ✅
  - UC 3-3レビューで発見: alt分岐内でdeactivate漏れ → アクティブバー不正確
  - § 3.2: 「alt分岐内でdeactivateが抜けるとアクティブバーが不正確」制限追加
  - § 4.2 Pass 2: シーケンス図用チェックリスト新設（4項目）
  - 付録C Phase 3-2: シーケンス図用チェック項目（3-2-8〜3-2-11）追加
  - 改善サイクル完了時の§3反映プロセスを実施

### 2025-12-14

- **UC 3-1, 3-2 図表作成・テンプレート シーケンス図追加** ✅
  - UC 3-1: 図表新規作成フロー（空の図表作成）
  - UC 3-2: テンプレート選択フロー（テンプレートから作成）
  - TD-006 Storage Only構成準拠（`/{user_id}/{project_name}/{diagram_name}.puml`）
  - RLS Policy、バリデーションルール、エラーハンドリング定義
  - 4パスレビュー完了、SVG 2件生成
  - シーケンス図統合版v2.1に追加
  - Evidence: `docs/evidence/20251214_2200_sequence_diagram_create/`
  - **シーケンス図進捗**: 2/14 → 3/14（MVP: 3/8完了）

- **シーケンス図統合版完成（100点Sランク）** ✅
  - `08_シーケンス図_20251214.md`（1ファイル方式）
  - **認証フローSVG 4件追加**:
    - Login_OAuth.svg（UC 1-1: OAuthログイン PKCE）
    - Session_Check.svg（UC 1-1: セッション検証 Middleware）
    - Logout_Client.svg（UC 1-2: クライアント側ログアウト）
    - Logout_Server.svg（UC 1-2: サーバー側ログアウト推奨）
  - **プロジェクトCRUD SVG 4件**（既存）:
    - Project_Create/Select/Edit/Delete.svg（UC 2-1〜2-4）
  - 憲法バージョン v3.4 → v4.2 更新
  - 目次アンカー修正（#技術仕様 → #3-技術仕様）
  - **評価: 87点(B) → 100点(S) に改善**
  - Evidence: `20251214_1834_sequence_project_crud/`, `20251214_2132_sequence_auth_svg/`

- **PlantUML開発憲法 v4.2 完成（100点Sランク）** ✅
  - 付録C「統合チェックリスト」追加
  - Step 2b「既存ドキュメント構成確認」追加
  - DRY原則適用（付録B統合）
  - 1ファイル方式強化

- **シーケンス図 再分析完了（14本、v3除外）** 🔄
  - 全32UCの外部システム連携を精査し、必要なシーケンス図を再分析
  - **MVP必須: 8本**（認証/プロジェクトCRUD/図表作成/編集プレビュー/保存/エクスポート/図表削除/AI Question-Start）
  - **Phase 2: 6本**（AIチャット/学習コンテンツ検索/ユーザー管理/LLMモデル登録/LLM使用量監視/学習コンテンツ登録）
  - **v3除外**: バージョン管理（UC 3-7, 3-8）はv3フェーズで作成

- **シーケンス図要件 Ultrathink再分析完了** ✅
  - 32UC全件を外部システム連携の観点で精査
  - **判断基準**: 外部API呼び出し、複数サービス連携、非同期/ストリーミング、複雑なエラーリカバリ
  - **スキップ対象（11UC）**: 単純なCRUD/設定変更（UC 5-3〜5-6, 5-8〜5-10, 5-12, 5-13, 3-2, 3-11）
  - UC番号の誤り修正: LLMモデル登録(5-2), LLM使用量監視(5-7), 学習コンテンツ登録(5-11)

- **クラス図 v1.7 100点達成（PRD即採用可能）** ✅
  - v1.6評価で発見した問題点を修正:
    - ValidationService: `-aiService: AIService` → `-eventEmitter: EventEmitter`（イベント駆動）
    - DiagramFacade クラス追加（Facadeパターン）
    - EventEmitter インターフェース追加（イベント駆動インフラ）
    - skinparam: facade/infrastructure ステレオタイプ色定義追加
    - ヘッダー/ステータス/関連ドキュメント参照を最新化
  - 評価サイクル: 83点(v1.6) → 94点 → 98点 → **100点(v1.7)**
  - 正式版: `docs/proposals/06_クラス図_20251208.md`（v1.7）
  - Evidence: `docs/evidence/20251214_1830_function_list_section12_update/`

- **機能一覧表 v3.12 §12クラス図整合版 完成** ✅
  - §12「クラス図への橋渡し」を全面更新（12件→41件: +29件）
  - §12.1 エンティティ: 6件→11件
  - §12.2 サービス: 6件→13件
  - §12.3 Repository: 新設（9件）
  - §12.4 外部クライアント: 新設（5件）
  - §12.5 Value Object: 新設（3件）
  - クラス図v1.7と完全整合
  - Evidence: `docs/evidence/20251214_1830_function_list_section12_update/`

- **機能一覧表 v3.11 スタイル統一版 完成（99点A+評価）** ✅
  - **改善サイクル**: 78点(v3.5) → 92点(v3.6) → 92点(v3.10) → **99点(v3.11)**
  - **v3.6改善**: 用語集拡充（AI, PlantUML, Excalidraw等）、`<details>`→Callout変換（7箇所）、ショートカット追加
  - **v3.11改善**（厳格評価で発見した問題を修正）:
    - v3警告のCallout内移動（F-DGM-07, F-DGM-08）
    - Phase 2警告の統一（「次期バージョン」「現在は利用できません」追加、7箇所）
    - ヘッダーマーカー削除（14箇所の🔵/🟢/🟠を削除、冗長性排除）
    - Mermaid図「システム全体像」修正（番号付きリスト誤認識問題を解消）
  - **PRD即採用可能**な品質レベルに到達
  - Evidence: `docs/evidence/20251214_1300_function_list_v311_complete/`

### 2025-12-13

- **機能一覧表 非エンジニア向け改訂戦略書 v2.0 完成** ✅
  - **Phase 1完了**: 戦略立案、テンプレート設計、サンプル作成（86点A評価）
  - **致命的欠陥4点修正**（前回セッションから継続）:
    - バージョン番号不整合: v2.0/v3.0混在 → v3.0に統一
    - 機能数の誤り: 16→22、14→8に修正
    - §3.3 ベースファイル操作手順追加（37行）
    - §6.4 エッジケース処理ルール追加（26行）
  - **追加改善**:
    - §7.0 Part 0テンプレート追加（50行）
    - §8.3 評価基準客観化（計測方法・計算式追加）
  - **戦術書スコア**: 46点(F) → **100点(A+)**（即実行可能）
  - Evidence: `docs/evidence/20251213_1535_function_list_nonengineer_revision/`
  - 次のステップ: Phase 2-5実行（Part 0追加 → 32機能改訂 → 品質評価）

- **⑦ CRUD表 v2.2 完成（90点A評価 + Obsidian callout対応）** ✅
  - **v2.0**: 非エンジニア向け大幅改訂（デュアルトラック構造、用語集、ユーザーストーリー4例）
  - **v2.1**: 82点評価フィードバック対応（表ヘッダー日本語化、AI生成コード保存ステップ追加等）
  - **v2.2**: 90点評価フィードバック対応
    - §7.1エンティティ名を全て日本語化
    - §7.3 Diagram操作機能数を9に修正
    - §4.1の図に日本語ラベル併記
    - **§5.5 ストーリー5: 管理者がAIモデルを設定する** 追加（5ストーリーに拡充）
    - `<details>`タグをObsidian callout構文に変換（8箇所）
  - **評価スコア推移**: 82点(B) → 90点(A) → **96点以上(A)見込**
  - 正式版: `docs/proposals/07_CRUD表_20251213.md`
  - Evidence: `docs/evidence/20251213_0253_crud_table_revision/`

### 2025-12-12

- **3.10 学習コンテンツフロー作成完了** ✅
  - 3.10.1 エディタ内ヘルプフロー（UC 3-10）
  - 3.10.2 学習画面フロー（UC 3-10, 3-11）
  - 確定済み要件17項目、データモデル、エラーハンドリング
  - PNG生成・4パスレビュー完了
  - SVG生成完了（`docs/proposals/diagrams/03_business_flow/`）
  - 業務フロー図ドキュメントへ統合完了
  - Evidence: `docs/evidence/20251211_2330_learning_content_flow/`
- **業務フロー図 全11フロー完了** ✅
  - MVP必須: 9/9完了（100%）
  - Phase 2: 2/2完了（100%）
- **UCカバレッジ更新**: 28/32 → 30/32（93.75%）
  - UC 3-10, 3-11をカバー済みに更新
  - 残り未カバー: UC 5-11, 5-12（学習コンテンツ管理・管理者機能）

### 2025-12-10

- **3.11 管理機能フロー（Phase 2）作成完了** ✅
  - 3.11.1 概要図（Phase 2管理機能の全体構成）
  - 3.11.2 LLMワークフロー定義フロー（UC 5-6）
  - 3.11.3 Embeddingモデル設定フロー（UC 5-9）
  - 3.11.4 Embedding使用量監視フロー（UC 5-10）
  - Evidence: `docs/evidence/20251210_2230_admin_flow_phase2/`
  - SVG: `docs/proposals/diagrams/03_business_flow/`（4件追加）
  - 業務フロー図への統合完了
- **TD-008: LLMワークフローのDAG構造採用**
  - UI: ビジュアルノードエディタ（React Flow）
  - 入出力マッピング: Jinja2テンプレート + AI支援
  - 条件分岐: success/error/always + LLM判定
- **TD-009: Embeddingモデル切り替え時の再生成戦略**
  - 再生成オプション: 「既存コンテンツ再生成」or「新規コンテンツのみ」
  - バックグラウンドジョブキューで非同期実行
- **業務フロー図進捗**: 9/11 → 10/11（91%）
- **UCカバレッジ更新**: 25/32 → 28/32（87.5%）

### 2025-12-09

- **⑦ CRUD表 v1.0 作成完了** ✅
  - 32機能×11エンティティのマトリクス作成
  - カテゴリ別詳細テーブル（F-AUTH/F-PRJ/F-DGM/F-AI/F-ADM）
  - 操作分布: Read 47%, Update 30%, Create 15%, Delete 8%
  - クラス図v1.6 Repository（9インターフェース）との対応表
  - 正式版: `docs/proposals/07_CRUD表_20251209.md`
  - Evidence: `docs/evidence/20251209_0024_crud_table/`
- **⑥ クラス図 v1.6 評価・修正完了** ✅
  - **評価結果: 97点→100点（Aランク）- PRD採用版**
  - AdminService → UserService + SystemConfigService 分離（SRP準拠、PlantUMLコード完全整合）
  - 評価項目別: 構造的完全性20/20、技術決定整合性15/15、DFD/機能一覧表整合性20/20、PlantUMLコード品質15/15、ドキュメント品質15/15、詳細度・実装可能性15/15
  - 正式版: `docs/proposals/06_クラス図_20251208.md`（v1.6）

### 2025-12-08

- **⑥ クラス図作成完了** ✅
  - ドメインモデル図: 11エンティティ、3値オブジェクト、9列挙型、9関連
  - サービス層図: 9インターフェース、8Repository実装、12サービス、5外部クライアント
  - TD-005/TD-006/TD-007との整合性確認済み
  - 機能一覧表v1.5 §9との対応確認済み（エンティティ11/11、サービス10/10）
  - 正式版: `docs/proposals/06_クラス図_20251208.md`
  - SVG: `docs/proposals/diagrams/06_class/`
  - Evidence: `docs/evidence/20251208_0430_class_diagram/`
- **⑤ 機能一覧表 v1.5 評価完了** ✅
  - **評価結果: 82点（Bランク）- PRD採用条件付き**
  - 構成・網羅性: 18/20、機能定義の詳細度: 21/25、整合性: 16/20
  - クラス図への橋渡し: 12/15、エラーハンドリング: 8/10、文書品質: 7/10
  - **MVP PRDとして採用可能**、完全版PRDには非機能要件追加が必要
  - 改善提案: Phase 2機能詳細化、非機能要件セクション追加、バージョン管理DFD追加
- **⑤ 機能一覧表（業務フロー・DFD対比含む）作成完了** ✅
  - 全32機能を網羅（5カテゴリ: 認証、プロジェクト管理、図表操作、AI機能、管理機能）
  - 機能ID採番体系を新規定義（F-{カテゴリ}-{連番}）
  - 業務フロー・DFD対比表（11フロー × 7プロセス × 24データフロー）
  - UCカバレッジマトリクス: 全体71.9%、**MVP 100%**
  - 整合性チェック: MVP機能はすべて完全カバー、問題なし
  - 正式版: `docs/proposals/05_機能一覧表_20251213.md`
  - Evidence: `docs/evidence/20251208_0239_function_list/`
- **④ データフロー図（DFD）v3.1 100点完全版** ✅
  - **評価・改善サイクル実施**: 75点（v2.1）→ 99点（v3.0）→ **100点（v3.1）**
  - **v3.0追加内容**:
    - データディクショナリ詳細化（型・制約・バリデーション）
    - DFDレベル2追加（P3.0/P5.0/P6.0サブプロセス分解）
    - P6.0管理機能DF採番（DF-17〜DF-22、DF-22E）
    - UC 3-2テンプレート選択フロー追加（DF-23、DF-24）
    - データストア記法注記（PlantUML制約説明）
    - バランシング検証表（Level 0 ↔ Level 1）
    - エラーリカバリ手順表（18種のエラー対応）
    - データ量・頻度・セキュリティ分類
    - 用語統一表（日英対応10用語）
  - **v3.1追加内容**:
    - D1バリデーションエラーメッセージ（14種）
    - D2バリデーションエラーメッセージ（8種）
    - 実装チームが迷わない詳細レベルに到達
  - 正式版: `docs/proposals/04_データフロー図_20251208.md`（v3.1）
  - SVG: `docs/proposals/diagrams/04_dfd/dfd_level0.svg`, `dfd_level1.svg`
  - Evidence: `docs/evidence/20251208_0128_dfd/`, `20251208_0157_dfd_improvement/`
- **④ データフロー図（DFD）初版作成**
  - DFDレベル0（コンテキスト図）: 外部エンティティ、プロセス、データストア定義
  - DFDレベル1（主要プロセス）: P1.0〜P7.0、D1〜D2、データフロー一覧
- **3.9 管理機能フロー（MVP）作成完了** ✅
  - 全10フローのPNG生成・4パスレビュー完了
  - 7/10フロー（70%）で修正実施（if/fork/switch内スイムレーン遷移問題）
  - Evidence: `docs/evidence/20251208_0007_admin_flow_mvp/`
  - 業務フロー図への.puml反映完了（全10ファイル一致確認済み）
- **PlantUML憲法v3.4更新**
  - § 2 禁止事項: 4項目→8項目に拡張
  - § 3 既知の制限: switch/case内スイムレーン遷移問題を追加
  - 問題発見統計追加（10フロー中7フローで修正必要）
- **CLAUDE.md更新**
  - PlantUML構文注意セクション: 既知の制限テーブル追加
  - 絶対禁止セクション: 8項目に拡張、最重要注意書き追加
- **Git push**: 管理機能フロー（MVP）+ PlantUML憲法v3.4

### 2025-12-07

- **validate_plantuml.ps1 issuesテンプレート追加（v3.1）**
  - レビューログにissuesテンプレート（pass/symptom/cause構造）を自動生成
  - Claudeの操作手順をガイドドキュメントに追記
  - PSCustomObject使用、UTF-8 BOM対応
  - 関連ドキュメント更新: PlantUML_SVG_Generation_Guide.md v3.1、CLAUDE.md
  - Evidence: `docs/evidence/20251207_1530_issues_template_implementation/`
- **validate_plantuml.ps1 機能拡張（v3.0）**
  - 2段階ワークフロー導入（-Review / -Publish）
  - レビューログ機能追加（.review.json）
    - 問題2対策: ハッシュ検証（レビュー時と同一ファイルか確認）
    - 問題3対策: status=completed必須（レビュー完了なしでPublish不可）
  - 履歴保持機能（historyに過去のレビュー結果を保持）
  - ガイドドキュメント更新（PlantUML_SVG_Generation_Guide.md v3.0）
  - Evidence: `docs/evidence/20251207_1310_validate_plantuml_enhancement/`
- **3.9 管理機能フロー（MVP）作成完了**（UC 5-1, 5-2〜5-5, 5-7, 5-8, 5-13）
  - 3.9.1 ユーザー管理フロー（詳細確認、権限変更、無効化）
  - 3.9.2 LLM管理フロー（モデル登録/切替/プロンプト/パラメータ/使用量/フォールバック）
  - 3.9.3 システム設定フロー（機能フラグ、表示設定、制限値、外部連携）
  - TD-007（OpenRouter/OpenAI分離）との整合性確認済み
  - LLM管理機能設計書（LM-01〜LM-07）との対応確認済み
- **業務フロー図MVP完了**: 9/9フロー完了（100%）
- **UCカバレッジMVP完了**: 23/23 UC完了（100%）
- **ユースケース図 UC番号再整理**（UC 5-1〜5-5 → 5-1〜5-13）
  - **5-A. ユーザー管理**: 5-1（既存）
  - **5-B. LLM管理**: 5-2〜5-8（7件追加、OpenRouter経由）
  - **5-C. Embedding管理**: 5-9〜5-10（2件追加、OpenAI直接）
  - **5-D. 学習コンテンツ管理**: 5-11〜5-12（番号変更）
  - **5-E. システム設定**: 5-13（番号変更）
  - **UC総数**: 24件 → **32件**
- **OpenRouter LLM制御仕様調査完了**
  - `docs/evidence/20251206_openrouter_research/`に調査結果を保存
  - OpenRouter API仕様（Chat/Completion、フォールバック、プロバイダールーティング）
  - OpenAI Embedding API仕様（接続仕様、レート制限、ベストプラクティス）
- **TD-007: AI機能プロバイダー構成決定**
  - **LLM**: OpenRouter経由（統一API、300+モデル対応）
  - **Embedding**: OpenAI直接接続（text-embedding-3-small）
  - プロバイダー分離によるコスト最適化と信頼性向上
- **LLM管理機能設計書作成**
  - `llm_management_feature_design.md`
  - LLM管理機能（LM-01〜LM-07）: OpenRouter経由
  - Embedding管理機能（EM-01〜EM-02）: OpenAI直接
  - 学習コンテンツ管理機能（LC-01〜LC-02）: OpenAI Embedding使用
  - データモデル、API設計、実装ロードマップを定義
- **PlantUML SVG生成・視覚的レビュー環境構築**
  - `scripts/validate_plantuml.ps1`: 検証・SVG生成スクリプト作成
  - `docs/guides/PlantUML_SVG_Generation_Guide.md`: 詳細ガイド作成
  - `docs/proposals/diagrams/`: 正式版SVG保存ディレクトリ構造作成
  - ローカルJAR使用（`C:\temp\vscode\.plantuml\plantuml-mit-1.2025.2.jar`）
- **管理機能フローSVG生成・視覚的レビュー完了**（10件）
  - `docs/proposals/diagrams/03_business_flow/`に正式版SVG保存
  - 3.9.1 ユーザー管理、3.9.2 LLM管理（6件）、3.9.3 システム設定
  - Playwrightでブラウザ表示確認済み
- **CLAUDE.md更新**: ガイドへの参照追加、ディレクトリ構造更新
- **PlantUML SVG生成ガイド v1.1更新**
  - 禁止事項セクション追加（Context7確認なし、バリデーション未実施、エラー無視）
  - イテレーティブ改善セクション追加（問題発生時のループフロー）
  - 既知の制限と回避策を詳細化（3件の既知問題、回避策パターン例）

### 2025-12-06

- **project_brief.md 大幅更新**（正式版ドキュメント + Evidence反映）
  - サービスアーキテクチャ追加（コンテキスト図から）
  - 内部サービス構成（5サービス）・外部システム連携（5システム）
  - データフロー概要図
  - UX設計思想追加（業務フロー図から）
  - 想定ユーザーペルソナ（5タイプ）・UX設計ポイント（5項目）
  - **検証済み技術仕様**（Context7検証: Supabase SSR, Excalidraw, PlantUML構文）
  - **PlantUML/Excalidraw機能分類**（3専用 + 8共通）
  - **MVP Storage構成**（ファイル構造、Repository Pattern）
  - **作業履歴（Evidence）**（7エビデンスセットから抽出）
- **CLAUDE.mdに「作業完了時の更新ルール」追加**
  - 必須更新ファイル（3件）、状況別更新ファイル（4件）
  - 更新の流れ（フローチャート）、active_context.md更新チェックリスト
- **自動保存機能を削除**（TD-006対応）
  - Storage Only構成では30秒自動保存が実現困難（上書きでデータ損失リスク）
  - MVPは**手動保存のみ**（Ctrl+S/保存ボタン）に変更
  - 修正ファイル: 業務フロー図(8箇所)、ユースケース図(2箇所)、開発計画(1箇所)、active_context(2箇所)
  - 「復元前自動保存」→「復元前保存」に表現変更（紛らわしさ解消）
- **TD-006: MVPデータ保存設計決定**
  - **Storage Only構成**: DBテーブルなし（auth.usersのみ）
  - **構造**: `/{user_id}/{project_name}/{diagram_name}.puml`
  - **ファイル形式**: B案（.puml + コメント内Markdown）
  - **v3ロードマップ**: 検索・バージョン管理は取込み機能で対応
- **docs/proposals整合性チェック完了**（Excalidrawバージョン管理対応後）
  - コンテキスト図: Excalidraw Serviceにバージョン管理追加（修正）
  - ユースケース図: UC 3-7, 3-8を「共通」に変更済み
  - シーケンス図: 認証のみのため変更不要
  - 業務フロー図: 3.7を両タイプ対応済み
  - 開発ステップ詳細化計画: 図表タイプ非依存のため変更不要
- **3.7 バージョン管理フロー作成完了**（UC 3-7, 3-8）
  - **PlantUML/Excalidraw両方対応**（設計修正）
  - SHA-256ハッシュでバージョン識別
  - 復元前に現在の内容をバージョンとして保存（データ損失防止）
  - 履歴確認 → プレビュー表示 → 復元のフロー
- **バージョン管理をExcalidrawにも適用**（設計変更）
  - ユースケース図: 3-7, 3-8を「共通」に変更
  - パッケージ構成: 3-B. 出力・管理（共通）にUC_HISTORY, UC_RESTOREを移動
  - 技術的制約なし、両図表タイプで同等のバージョン管理を提供
- **3.8 図表削除フロー作成完了**（UC 3-9）
  - PlantUML/Excalidraw両方対応
  - 確認ダイアログで誤操作防止
  - カスケード削除（メタデータ + Storage + バージョン履歴）
- **MVP必須業務フロー完了**: 8/10フロー完了（残りはPhase 2）
- **3.6 保存・エクスポートフロー作成完了**（UC 3-5, 3-6）
  - 手動保存（Ctrl+S）のみ ※自動保存はStorage Only構成では未実装（TD-006）
  - PNG/SVG/PDFエクスポート
  - 用語一貫性チェック（自動実行）
  - **Storage設計統一**: PlantUML/Excalidraw両方で source + preview_N.svg を保存
  - **Frontend Serviceオーケストレーション**: 処理依頼→結果受信→保存リクエストの明示化
  - PlantUML: 複数@startumlブロック対応（複数プレビューSVG生成）
- **整合性チェック実施**: 全図表間で整合確認、コンテキスト図更新（node-plantuml明記）
- **API Gatewayの扱い明記**: 業務フロー図で「暗黙的に介在」と明記
- **機能一覧表の導入決定**: 業務フロー・DFD対比表を機能一覧表に統合（選択肢C）
  - 作成タイミング: 業務フロー図・DFD完了後
  - 役割: 機能網羅性確認 + フロー不備発見 → フロー修正 → クラス図へ
- UC 2-4「プロジェクトを編集する」追加（CRUD完備）
- UC採番・業務フロー図をCRUD順に整理
- UX設計思想ドキュメント化（業務フロー図内）
- TD-005: プロジェクト選択状態のSupabase保存
- CLAUDE.md現状反映・不要ファイル削除
- **Git push**: `46ae4f7` master → origin/master

> **過去の履歴**: 2週間以上前の履歴は [`active_context_history_archive.md`](./active_context_history_archive.md) を参照

---

## 技術決定（最新）

| TD | 内容 | 日付 |
|:--:|------|------|
| TD-001 | AI駆動開発標準の採用 | 2025-11-30 |
| TD-002 | PlantUML Validator MCP採用 | 2025-11-30 |
| TD-003 | Google Cloud Run採用 | 2025-11-08 |
| TD-004 | Serena MCP採用 | 2025-11-30 |
| TD-005 | プロジェクト選択状態のSupabase保存 | 2025-12-06 |
| TD-006 | MVPデータ保存設計（Storage Only）+ 自動保存削除 | 2025-12-06 |
| TD-007 | AI機能プロバイダー構成（LLM: OpenRouter, Embedding: OpenAI直接） | 2025-12-07 |
| TD-008 | LLMワークフローのDAG構造採用（Phase 2） | 2025-12-10 |
| TD-009 | Embeddingモデル切り替え時の再生成戦略（Phase 2） | 2025-12-10 |

詳細: `docs/context/technical_decisions.md`

---

## 次のステップ

### 即座に必要なアクション（MVP）

1. [x] **3.6 保存・エクスポートフロー**（UC 3-5, 3-6）✅ 完了
2. [x] **3.7 バージョン管理フロー**（UC 3-7, 3-8）✅ 完了
3. [x] **3.8 図表削除フロー**（UC 3-9）✅ 完了
4. [x] **3.9 管理機能フロー（MVP）**（UC 5-1, 5-2〜5-5, 5-7, 5-8, 5-13）✅ 完了
5. [x] **データフロー図（DFD）** ✅ 完了
6. [x] **機能一覧表**（業務フロー・DFD対比含む）✅ 完了
7. [x] 【レビュー・修正】業務フロー・DFDの不備を修正（MVP完全カバー、問題なし）✅
8. [x] **Phase 3: クラス図**（ドメインモデル、サービス層）✅ 完了
9. [x] **Phase 3続き: CRUD表**（機能×エンティティ）✅ 完了
10. [ ] **Phase 4: シーケンス図**（残り6件: Phase2 6本）← **次の作業**

### Phase 2 残作業（業務フロー）

1. [x] **3.10 学習コンテンツフロー**（UC 3-10, 3-11）✅ 完了
2. [x] **3.11 管理機能フロー（Phase 2）**（UC 5-6, 5-9, 5-10）✅ 完了

**業務フロー図 全11フロー完了** ✅

### 今後の検討事項

- [x] Phase 3: データ・構造定義（クラス図、CRUD表）✅
- [ ] Phase 4: 振る舞い詳細化（シーケンス図残り6件: Phase2 6本、画面遷移図、ワイヤーフレーム）← **次**
- [ ] Phase 5: アーキテクチャ（コンポーネント図、外部インターフェース一覧）
- [ ] Phase 6: 品質・権限定義（非機能要件、アクター権限マトリクス）

---

## 重要なドキュメント

### プロジェクト管理
| ドキュメント | 内容 |
|-------------|------|
| `CLAUDE.md` | プロジェクトガイド（最新） |
| `docs/context/technical_decisions.md` | 技術決定記録（TD-001〜009） |

### 正式版図表
| ドキュメント | 内容 |
|-------------|------|
| `docs/proposals/02_ユースケース図_20251130.md` | ユースケース図（32UC） |
| `docs/proposals/03_業務フロー図_20251201.md` | 業務フロー図 + UX設計思想 |
| `docs/proposals/08_シーケンス図_20251214.md` | シーケンス図統合版（6/14完了） |

### ガイドライン・知見ベース
| ドキュメント | 内容 |
|-------------|------|
| `docs/guides/PlantUML_Development_Constitution.md` | PlantUML開発憲法 v5.0 |
| `docs/guides/sequence_diagram/01_Reference_Guide.md` | シーケンス図参照ガイド（ナビゲーション） |
| `docs/guides/sequence_diagram/02_Authoring_Guide.md` | シーケンス図作成ガイド（How-to） |
| `docs/guides/sequence_diagram/03_Knowledge_Strategy.md` | 知見統合戦略（メタドキュメント） |
| `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` | アクティブバー知見ベース（LL-001〜027） |
| `docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md` | シーケンス図パターン集（NL-001〜007） |
| `docs/guides/sequence_diagram/Design_Pattern_Checklist.md` | 設計パターンチェックリスト（DP-001〜006） |

---

**次のレビュー予定**: 2025-12-21
