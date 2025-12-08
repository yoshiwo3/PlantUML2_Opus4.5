# クラス図作成 - 作業指示書

**作業日時**: 2025-12-08 04:30開始
**作業者**: Claude Code (Opus 4.5)
**ステータス**: 作業中

---

## 目標

機能一覧表v1.5のセクション9「クラス図への橋渡し」を基に、PlantUML Studio用のクラス図を作成する。

---

## コンテキスト

### 参照ドキュメント

| ドキュメント | 用途 |
|-------------|------|
| `docs/proposals/PlantUML_Studio_機能一覧表_20251208.md` §9 | クラス図への橋渡し（エンティティ候補、属性、関連） |
| `docs/design/PlantUML_Studio_設計図表_20251130.md` §7 | 下書き（ドメインモデル、サービス層） |
| `docs/context/technical_decisions.md` | TD-006（Storage Only）、TD-007（AI機能分離） |

### 重要な設計決定

1. **TD-006（Storage Only構成）**
   - MVPはSupabase Storageのみ、DBテーブルなし（auth.usersのみ）
   - Repository Patternでストレージ層を抽象化
   - v3でDB追加時にRepositoryの実装を差し替え

2. **TD-007（AI機能プロバイダー分離）**
   - LLM: OpenRouter経由
   - Embedding: OpenAI直接接続

---

## 実施内容

### 作成する図表

1. **ドメインモデルクラス図**
   - エンティティ: User, Project, Diagram, Template, Session, LLMModel, Prompt, SystemConfig
   - 値オブジェクト: ValidationResult, ValidationError
   - 列挙型: ContentType, DiagramCategory, UserRole, LLMProvider

2. **サービス層クラス図**
   - サービス: AuthService, ProjectService, DiagramService, ValidationService, ExportService, AIService, LLMConfigService, AdminService
   - リポジトリ: IDiagramRepository, IProjectRepository + 実装（StorageRepository）

### プロセス

1. PlantUMLコード作成
2. PNG生成（-Review）
3. 視覚的レビュー（4パス方式）
4. レビューログ更新
5. SVG生成（-Publish）
6. 正式版ドキュメント作成

---

## 完了条件

- [ ] ドメインモデルクラス図作成・レビュー完了
- [ ] サービス層クラス図作成・レビュー完了
- [ ] `docs/proposals/PlantUML_Studio_クラス図_20251208.md` 作成
- [ ] `docs/proposals/diagrams/class/` にSVG保存
- [ ] `active_context.md` 更新
- [ ] SERENA Memory保存

---

## 関連ファイル

- Evidence: `docs/evidence/20251208_0430_class_diagram/`
- 正式版: `docs/proposals/PlantUML_Studio_クラス図_20251208.md`
- SVG: `docs/proposals/diagrams/class/`
