# PlantUML Studio - CRUD表

**作成日**: 2025-12-09
**バージョン**: v1.0
**ステータス**: レビュー中

---

## 目次

1. [概要](#1-概要)
2. [凡例](#2-凡例)
3. [機能×エンティティ CRUD表](#3-機能エンティティ-crud表)
   - [3.1 認証機能（F-AUTH）](#31-認証機能f-auth)
   - [3.2 プロジェクト管理機能（F-PRJ）](#32-プロジェクト管理機能f-prj)
   - [3.3 図表操作機能（F-DGM）](#33-図表操作機能f-dgm)
   - [3.4 AI機能（F-AI）](#34-ai機能f-ai)
   - [3.5 管理機能（F-ADM）](#35-管理機能f-adm)
4. [CRUD表サマリ](#4-crud表サマリ)
5. [エンティティ別操作サマリ](#5-エンティティ別操作サマリ)
6. [整合性検証](#6-整合性検証)
7. [クラス図Repositoryとの対応](#7-クラス図repositoryとの対応)

---

## 1. 概要

本ドキュメントは、PlantUML Studioの機能とエンティティの関係をCRUD操作（Create/Read/Update/Delete）で表現する。

### 目的

1. **データ操作の網羅性確認**: 各エンティティに対する操作が適切に定義されているか
2. **Repository設計の検証**: クラス図v1.6のRepositoryメソッドとの整合性確認
3. **アクセス制御設計への入力**: 誰がどのエンティティにアクセスできるか

### 入力ドキュメント

| ドキュメント | バージョン | 参照ポイント |
|-------------|-----------|-------------|
| クラス図 | v1.6 | 11エンティティ、9Repository |
| 機能一覧表 | v1.5 | 32機能（5カテゴリ） |
| 業務フロー図 | 2025-12-01 | 処理フロー |
| DFD | v3.1 | データフロー |

---

## 2. 凡例

### CRUD操作

| 記号 | 操作 | 説明 |
|:----:|------|------|
| **C** | Create | 新規レコード作成 |
| **R** | Read | レコード参照（一覧/詳細） |
| **U** | Update | レコード更新 |
| **D** | Delete | レコード削除 |
| **-** | なし | 操作なし |

### 優先度

| 優先度 | 説明 |
|:------:|------|
| MVP | 最小限の製品要件 |
| Phase 2 | 拡張機能 |
| v3 | DB追加後の機能 |

---

## 3. 機能×エンティティ CRUD表

### エンティティ一覧（クラス図v1.6）

| # | エンティティ | 略称 | 説明 |
|:-:|-------------|:----:|------|
| 1 | User | USR | システム利用者 |
| 2 | Session | SES | 認証セッション |
| 3 | Project | PRJ | プロジェクト |
| 4 | Diagram | DGM | 図表 |
| 5 | Template | TPL | テンプレート |
| 6 | LLMModel | LLM | LLMモデル |
| 7 | Prompt | PRM | プロンプト |
| 8 | FeatureModelAssignment | FMA | 機能別モデル割当 |
| 9 | SystemConfig | CFG | システム設定 |
| 10 | UsageLog | LOG | 使用量ログ |
| 11 | LearningContent | LRN | 学習コンテンツ |

---

### 3.1 認証機能（F-AUTH）

| 機能ID | 機能名 | USR | SES | PRJ | DGM | TPL | LLM | PRM | FMA | CFG | LOG | LRN | 優先度 |
|:------:|--------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:------:|
| F-AUTH-01 | ログイン | R,U | C | - | - | - | - | - | - | - | - | - | MVP |
| F-AUTH-02 | ログアウト | - | D | - | - | - | - | - | - | - | - | - | MVP |

**詳細**:
- **F-AUTH-01**: User(R)でユーザー存在確認、User(U)でlast_sign_in_at更新、Session(C)で新規セッション作成
- **F-AUTH-02**: Session(D)でセッション無効化

---

### 3.2 プロジェクト管理機能（F-PRJ）

| 機能ID | 機能名 | USR | SES | PRJ | DGM | TPL | LLM | PRM | FMA | CFG | LOG | LRN | 優先度 |
|:------:|--------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:------:|
| F-PRJ-01 | プロジェクト作成 | - | - | C | - | - | - | - | - | - | - | - | MVP |
| F-PRJ-02 | プロジェクト選択 | U | - | R | - | - | - | - | - | - | - | - | MVP |
| F-PRJ-03 | プロジェクト編集 | - | - | U | - | - | - | - | - | - | - | - | MVP |
| F-PRJ-04 | プロジェクト削除 | - | - | D | D | - | - | - | - | - | - | - | MVP |

**詳細**:
- **F-PRJ-01**: Project(C)で新規プロジェクト作成
- **F-PRJ-02**: User(U)でlast_selected_project_id更新、Project(R)でプロジェクト情報取得
- **F-PRJ-03**: Project(U)でプロジェクト名/説明更新
- **F-PRJ-04**: Project(D)でプロジェクト削除、Diagram(D)でカスケード削除

---

### 3.3 図表操作機能（F-DGM）

| 機能ID | 機能名 | USR | SES | PRJ | DGM | TPL | LLM | PRM | FMA | CFG | LOG | LRN | 優先度 |
|:------:|--------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:------:|
| F-DGM-01 | 図表作成 | - | - | R | C | R | - | - | - | - | - | - | MVP |
| F-DGM-02 | テンプレート選択 | - | - | - | - | R | - | - | - | - | - | - | MVP |
| F-DGM-03 | 図表編集 | - | - | - | U | - | - | - | - | - | - | - | MVP |
| F-DGM-04 | PlantUML検証 | - | - | - | R | - | - | - | - | - | - | - | MVP |
| F-DGM-05 | 図表保存 | - | - | - | U | - | - | - | - | - | - | - | MVP |
| F-DGM-06 | 図表エクスポート | - | - | - | R | - | - | - | - | - | - | - | MVP |
| F-DGM-07 | バージョン履歴確認 | - | - | - | R | - | - | - | - | - | - | - | v3 |
| F-DGM-08 | バージョン復元 | - | - | - | U | - | - | - | - | - | - | - | v3 |
| F-DGM-09 | 図表削除 | - | - | - | D | - | - | - | - | - | - | - | MVP |
| F-DGM-10 | 学習コンテンツ検索 | - | - | - | - | - | - | - | - | - | - | R | Phase 2 |
| F-DGM-11 | 学習コンテンツ確認 | - | - | - | - | - | - | - | - | - | - | R | Phase 2 |

**詳細**:
- **F-DGM-01**: Project(R)で所属確認、Diagram(C)で新規作成、Template(R)でテンプレート適用
- **F-DGM-02**: Template(R)でテンプレート一覧/詳細取得
- **F-DGM-03**: Diagram(U)でソースコード更新
- **F-DGM-04**: Diagram(R)でソースコード取得（検証処理自体はエンティティ操作なし）
- **F-DGM-05**: Diagram(U)でソースコード・プレビュー更新
- **F-DGM-06**: Diagram(R)でソースコード取得（エクスポート処理）
- **F-DGM-07**: Diagram(R)でバージョン履歴取得（v3でDB追加後）
- **F-DGM-08**: Diagram(U)でソースコード復元（v3でDB追加後）
- **F-DGM-09**: Diagram(D)で図表削除
- **F-DGM-10/11**: LearningContent(R)で学習コンテンツ検索/参照

---

### 3.4 AI機能（F-AI）

| 機能ID | 機能名 | USR | SES | PRJ | DGM | TPL | LLM | PRM | FMA | CFG | LOG | LRN | 優先度 |
|:------:|--------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:------:|
| F-AI-01 | AI Question-Start | - | - | - | - | - | R | R | R | - | C | - | MVP |
| F-AI-02 | AIチャット | - | - | - | - | - | R | R | R | - | C | - | MVP |

**詳細**:
- **F-AI-01/02**: LLMModel(R)でモデル情報取得、Prompt(R)でプロンプト取得、FeatureModelAssignment(R)で機能別モデル割当取得、UsageLog(C)で使用量ログ記録

---

### 3.5 管理機能（F-ADM）

| 機能ID | 機能名 | USR | SES | PRJ | DGM | TPL | LLM | PRM | FMA | CFG | LOG | LRN | 優先度 |
|:------:|--------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:------:|
| F-ADM-01 | ユーザー管理 | R,U,D | - | - | - | - | - | - | - | - | - | - | MVP |
| F-ADM-02 | LLMモデル登録 | - | - | - | - | - | C | - | - | - | - | - | MVP |
| F-ADM-03 | LLMモデル切替 | - | - | - | - | - | R | - | U | - | - | - | MVP |
| F-ADM-04 | LLMプロンプト管理 | - | - | - | - | - | - | C,R,U,D | - | - | - | - | MVP |
| F-ADM-05 | LLMパラメータ設定 | - | - | - | - | - | U | U | - | - | - | - | MVP |
| F-ADM-06 | LLMワークフロー定義 | - | - | - | - | - | R | R | C,U | - | - | - | Phase 2 |
| F-ADM-07 | LLM使用量監視 | - | - | - | - | - | R | - | - | - | R | - | MVP |
| F-ADM-08 | LLMフォールバック設定 | - | - | - | - | - | R | - | U | - | - | - | MVP |
| F-ADM-09 | Embeddingモデル設定 | - | - | - | - | - | - | - | - | U | - | - | Phase 2 |
| F-ADM-10 | Embedding使用量監視 | - | - | - | - | - | - | - | - | - | R | - | Phase 2 |
| F-ADM-11 | 学習コンテンツ登録 | - | - | - | - | - | - | - | - | - | - | C | Phase 2 |
| F-ADM-12 | 学習コンテンツ管理 | - | - | - | - | - | - | - | - | - | - | R,U,D | Phase 2 |
| F-ADM-13 | システム設定変更 | - | - | - | - | - | - | - | - | R,U | - | - | MVP |

**詳細**:
- **F-ADM-01**: User(R)で一覧/詳細取得、User(U)でロール変更、User(D)で無効化
- **F-ADM-02**: LLMModel(C)で新規モデル登録
- **F-ADM-03**: LLMModel(R)でモデル一覧取得、FeatureModelAssignment(U)で割当変更
- **F-ADM-04**: Prompt(CRUD)でプロンプト管理
- **F-ADM-05**: LLMModel(U)/Prompt(U)でパラメータ更新
- **F-ADM-06**: LLMModel(R)/Prompt(R)で情報取得、FeatureModelAssignment(C,U)でワークフロー定義
- **F-ADM-07**: LLMModel(R)でモデル情報、UsageLog(R)で使用量取得
- **F-ADM-08**: LLMModel(R)でモデル一覧、FeatureModelAssignment(U)でフォールバック設定
- **F-ADM-09**: SystemConfig(U)でEmbeddingモデル設定
- **F-ADM-10**: UsageLog(R)でEmbedding使用量取得
- **F-ADM-11**: LearningContent(C)で新規登録
- **F-ADM-12**: LearningContent(R,U,D)でコンテンツ管理
- **F-ADM-13**: SystemConfig(R,U)で設定参照/変更

---

## 4. CRUD表サマリ

### 全体マトリクス（32機能×11エンティティ）

| 機能ID | USR | SES | PRJ | DGM | TPL | LLM | PRM | FMA | CFG | LOG | LRN |
|:------:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| F-AUTH-01 | R,U | C | - | - | - | - | - | - | - | - | - |
| F-AUTH-02 | - | D | - | - | - | - | - | - | - | - | - |
| F-PRJ-01 | - | - | C | - | - | - | - | - | - | - | - |
| F-PRJ-02 | U | - | R | - | - | - | - | - | - | - | - |
| F-PRJ-03 | - | - | U | - | - | - | - | - | - | - | - |
| F-PRJ-04 | - | - | D | D | - | - | - | - | - | - | - |
| F-DGM-01 | - | - | R | C | R | - | - | - | - | - | - |
| F-DGM-02 | - | - | - | - | R | - | - | - | - | - | - |
| F-DGM-03 | - | - | - | U | - | - | - | - | - | - | - |
| F-DGM-04 | - | - | - | R | - | - | - | - | - | - | - |
| F-DGM-05 | - | - | - | U | - | - | - | - | - | - | - |
| F-DGM-06 | - | - | - | R | - | - | - | - | - | - | - |
| F-DGM-07 | - | - | - | R | - | - | - | - | - | - | - |
| F-DGM-08 | - | - | - | U | - | - | - | - | - | - | - |
| F-DGM-09 | - | - | - | D | - | - | - | - | - | - | - |
| F-DGM-10 | - | - | - | - | - | - | - | - | - | - | R |
| F-DGM-11 | - | - | - | - | - | - | - | - | - | - | R |
| F-AI-01 | - | - | - | - | - | R | R | R | - | C | - |
| F-AI-02 | - | - | - | - | - | R | R | R | - | C | - |
| F-ADM-01 | R,U,D | - | - | - | - | - | - | - | - | - | - |
| F-ADM-02 | - | - | - | - | - | C | - | - | - | - | - |
| F-ADM-03 | - | - | - | - | - | R | - | U | - | - | - |
| F-ADM-04 | - | - | - | - | - | - | CRUD | - | - | - | - |
| F-ADM-05 | - | - | - | - | - | U | U | - | - | - | - |
| F-ADM-06 | - | - | - | - | - | R | R | C,U | - | - | - |
| F-ADM-07 | - | - | - | - | - | R | - | - | - | R | - |
| F-ADM-08 | - | - | - | - | - | R | - | U | - | - | - |
| F-ADM-09 | - | - | - | - | - | - | - | - | U | - | - |
| F-ADM-10 | - | - | - | - | - | - | - | - | - | R | - |
| F-ADM-11 | - | - | - | - | - | - | - | - | - | - | C |
| F-ADM-12 | - | - | - | - | - | - | - | - | - | - | R,U,D |
| F-ADM-13 | - | - | - | - | - | - | - | - | R,U | - | - |

---

## 5. エンティティ別操作サマリ

各エンティティに対する操作をまとめる。

| エンティティ | C | R | U | D | 操作機能数 | 主要操作機能 |
|-------------|:-:|:-:|:-:|:-:|:----------:|-------------|
| **User** | - | 2 | 3 | 1 | 4 | F-AUTH-01, F-PRJ-02, F-ADM-01 |
| **Session** | 1 | - | - | 1 | 2 | F-AUTH-01, F-AUTH-02 |
| **Project** | 1 | 2 | 1 | 1 | 4 | F-PRJ-01〜04 |
| **Diagram** | 1 | 4 | 3 | 2 | 7 | F-DGM-01〜09, F-PRJ-04 |
| **Template** | - | 2 | - | - | 2 | F-DGM-01, F-DGM-02 |
| **LLMModel** | 1 | 6 | 2 | - | 6 | F-AI-01/02, F-ADM-02〜08 |
| **Prompt** | 1 | 3 | 2 | 1 | 3 | F-AI-01/02, F-ADM-04〜06 |
| **FeatureModelAssignment** | 1 | 2 | 4 | - | 4 | F-AI-01/02, F-ADM-03/06/08 |
| **SystemConfig** | - | 1 | 2 | - | 2 | F-ADM-09, F-ADM-13 |
| **UsageLog** | 2 | 3 | - | - | 4 | F-AI-01/02, F-ADM-07/10 |
| **LearningContent** | 1 | 3 | 1 | 1 | 4 | F-DGM-10/11, F-ADM-11/12 |

### 操作分布

| 操作 | 機能数 | 割合 |
|:----:|:------:|:----:|
| Create | 9 | 15% |
| Read | 28 | 47% |
| Update | 18 | 30% |
| Delete | 5 | 8% |

> Read操作が最も多く（47%）、システムの主な用途が「参照・表示」であることを示す。

---

## 6. 整合性検証

### 6.1 機能一覧表との整合性

| 検証項目 | 結果 | 備考 |
|---------|:----:|------|
| 全32機能がCRUD表に存在 | ✅ | F-AUTH〜F-ADM全機能 |
| 優先度（MVP/Phase 2/v3）が一致 | ✅ | 機能一覧表と同一 |
| データフロー対応と操作が一致 | ✅ | DF番号に対応する操作が定義済み |

### 6.2 クラス図との整合性

| 検証項目 | 結果 | 備考 |
|---------|:----:|------|
| 全11エンティティがCRUD表に存在 | ✅ | クラス図v1.6の全エンティティ |
| Repository操作と整合 | ✅ | 下記対応表参照 |
| 関連エンティティのカスケード操作 | ✅ | F-PRJ-04: Project→Diagram |

### 6.3 DFDとの整合性

| データストア | CRUD表対応 | 備考 |
|:------------:|-----------|------|
| D1（図表ストレージ） | Project, Diagram, Template | Storage操作 |
| D2（認証情報） | User, Session, LLMModel, Prompt, SystemConfig, UsageLog | DB操作 |

---

## 7. クラス図Repositoryとの対応

### IDiagramRepository

| Repositoryメソッド | 対応機能 | CRUD |
|-------------------|---------|:----:|
| list() | F-DGM-01（一覧取得） | R |
| get() | F-DGM-04/06/07 | R |
| save() | F-DGM-01/03/05/08 | C/U |
| delete() | F-DGM-09, F-PRJ-04 | D |
| exists() | F-DGM-01（重複チェック） | R |

### IProjectRepository

| Repositoryメソッド | 対応機能 | CRUD |
|-------------------|---------|:----:|
| list() | F-PRJ-02 | R |
| get() | F-PRJ-02/03, F-DGM-01 | R |
| create() | F-PRJ-01 | C |
| update() | F-PRJ-03 | U |
| delete() | F-PRJ-04 | D |
| exists() | F-PRJ-01（重複チェック） | R |

### ITemplateRepository

| Repositoryメソッド | 対応機能 | CRUD |
|-------------------|---------|:----:|
| list() | F-DGM-02 | R |
| get() | F-DGM-01/02 | R |
| getByCategory() | F-DGM-02 | R |

### IUserRepository

| Repositoryメソッド | 対応機能 | CRUD |
|-------------------|---------|:----:|
| get() | F-AUTH-01, F-ADM-01 | R |
| update() | F-AUTH-01, F-PRJ-02, F-ADM-01 | U |
| deactivate() | F-ADM-01 | U/D |
| listAll() | F-ADM-01 | R |

### IPromptRepository

| Repositoryメソッド | 対応機能 | CRUD |
|-------------------|---------|:----:|
| list() | F-ADM-04 | R |
| get() | F-AI-01/02, F-ADM-04 | R |
| getByPurpose() | F-AI-01/02 | R |
| save() | F-ADM-04/05 | C/U |
| delete() | F-ADM-04 | D |

### ILLMModelRepository

| Repositoryメソッド | 対応機能 | CRUD |
|-------------------|---------|:----:|
| list() | F-ADM-03/07/08 | R |
| get() | F-AI-01/02, F-ADM-05 | R |
| save() | F-ADM-02/05 | C/U |
| activate() | F-ADM-02 | U |
| deactivate() | F-ADM-02 | U |

### ISystemConfigRepository

| Repositoryメソッド | 対応機能 | CRUD |
|-------------------|---------|:----:|
| get() | F-ADM-13 | R |
| getByCategory() | F-ADM-13 | R |
| update() | F-ADM-09/13 | U |

### IUsageLogRepository

| Repositoryメソッド | 対応機能 | CRUD |
|-------------------|---------|:----:|
| log() | F-AI-01/02 | C |
| getByUser() | F-ADM-07 | R |
| getByModel() | F-ADM-07 | R |
| getByPeriod() | F-ADM-07/10 | R |

### ILearningContentRepository

| Repositoryメソッド | 対応機能 | CRUD |
|-------------------|---------|:----:|
| list() | F-ADM-12 | R |
| get() | F-DGM-11, F-ADM-12 | R |
| search() | F-DGM-10 | R |
| save() | F-ADM-11/12 | C/U |
| delete() | F-ADM-12 | D |

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|:----------:|:----:|---------|
| v1.0 | 2025-12-09 | 初版作成（32機能×11エンティティ） |

---

## 関連ドキュメント

| ドキュメント | 内容 |
|-------------|------|
| `PlantUML_Studio_クラス図_20251208.md` | エンティティ・Repository定義 |
| `PlantUML_Studio_機能一覧表_20251208.md` | 機能定義（32機能） |
| `PlantUML_Studio_データフロー図_20251208.md` | データフロー定義 |
