---
**📍 このドキュメントの位置付け**: Layer 3 - Configuration & Utilities

このファイルはSerena MCP設定の変更履歴です。プロジェクト全体の知識は以下を参照：
- **Memory Bank**: ../docs/context/（プロジェクト全体の知識）
- **ドキュメント体系**: ../docs/DOCUMENTATION_SYSTEM_OVERVIEW.md
---

# Serena MCP設定 - 変更履歴

## 2025-01-15 - 初版作成（v0.1.0）

### 追加された機能

#### 1. 充実したプロジェクト設定（`project.yml`）

PlantUML2_Codexプロジェクトの特性に最適化された設定ファイルを作成：

- **プロジェクト基本情報**: 名称、説明、タイプ（現在はdocumentation）
- **言語設定**: TypeScript（将来の実装用）+ Markdown/YAML/JSON
- **無視パス**: node_modules、.next、キャッシュ、バックアップ等を除外
- **ディレクトリ構造定義**: 各ディレクトリの説明と優先度
- **Language Server設定**: TypeScript（現在は無効）、Markdown（有効）
- **ツール設定**: 検索結果上限、優先拡張子、コンテキスト行数
- **メモリ管理**: 自動保存、保持期間（90日）、事前定義メモリ
- **プロジェクトコンテキスト**: フェーズ、技術スタック、ステークホルダー
- **ベストプラクティス**: ドキュメント作成・コード品質の規則
- **カスタムコマンド**: 企画書更新、設計ドキュメント作成等のエイリアス
- **検証設定**: PlantUML自動検証、Markdownリント
- **CI/CD設定**: 将来のGitHub Actions用（現在は無効）
- **メタデータ**: 作成日、バージョン、リンク集

**主な特徴**:
- 現在の企画フェーズに最適化（ドキュメント専用）
- 将来の実装フェーズへの移行を考慮（コメント付き設定）
- PlantUML Validator MCP統合（自動検証）

#### 2. 包括的なベストプラクティスガイド（`README.md`）

Serena MCPの使い方を日本語で詳しく解説：

- **Serenaの概要**: 機能、メリット、従来アプローチとの比較表
- **ディレクトリ構造**: `.serena/`配下のファイル説明
- **設定ファイル**: `project.yml`とグローバル設定の詳細
- **ベストプラクティス**:
  - プロジェクトアクティベーション（自動/手動）
  - 事前インデックス作成
  - メモリファイルの活用方法
  - セキュリティ設定（読み取り専用モード、段階的ツール有効化）
  - コンテキスト選択（Claude Code、Cursor等）
  - PlantUML2_Codex固有のガイドライン
- **よくある質問**: 遅延、メモリ管理、ツール選択、優先順位
- **トラブルシューティング**: 起動失敗、プロジェクト未検出、検索不正確、メモリ保存失敗
- **参考リンク**: 公式ドキュメント、コミュニティリソース

**主な特徴**:
- 初心者にも分かりやすい構成
- 実践的な使用例とコマンド
- PlantUML2_Codexプロジェクト固有の注意事項

#### 3. クイックリファレンスガイド（`QUICK_REFERENCE.md`）

日常的な作業で頻繁に使う情報を素早く参照できるチートシート：

- **よく使うコマンド**: プロジェクト管理、キャッシュ管理、Claude Code関連
- **Serenaツール一覧**: 19ツールの用途と使用例（テーブル形式）
- **AI指示の例文集**: ファイル探索、コード理解、編集、メモリ操作、複合タスク
- **設定変更チートシート**: `project.yml`、`serena_config.yml`、`.mcp.json`の設定例
- **トラブルシューティング早見表**: 症状→原因→解決策の一覧
- **緊急リセット手順**: キャッシュ削除、設定リセット、再インデックス
- **パフォーマンス最適化**: 大規模/小規模プロジェクト向け設定
- **セキュリティベストプラクティス**: 読み取り専用モード、段階的権限拡大
- **便利なエイリアス**: Bash/PowerShell用のショートカット

**主な特徴**:
- 1ページで必要な情報が見つかる設計
- コピー&ペーストですぐ使える設定例
- 症状別トラブルシューティング

#### 4. 変更履歴（`CHANGELOG.md`）

このファイル。設定の変更履歴とバージョン管理。

### 設定の詳細

#### 無視パス（ignored_paths）

```yaml
# Node.js関連
- "node_modules/**"
- "**/.next/**"
- "**/dist/**"
- "**/build/**"

# キャッシュ・一時ファイル
- "**/.cache/**"
- "**/*.log"
- "**/.DS_Store"
- "**/Thumbs.db"

# バックアップ・履歴
- ".backups/**"
- "**/*.bak"
- "**/*~"

# MCPサーバー関連
- ".playwright-mcp/**"
- ".serena/cache/**"

# 過去のドキュメント
- "docs/proposals/Old/**"
```

**理由**: 検索・解析の高速化、不要なファイルの除外

#### ディレクトリ優先度

| ディレクトリ | 優先度 | 説明 |
|-------------|--------|------|
| `docs/proposals` | high | プロジェクト企画書とロードマップ |
| `docs/design` | high | UI/UX設計、アーキテクチャ設計 |
| `docs/learning` | medium | 学習コンテンツ・RAG用データ |
| `docs/poc` | medium | PoC（概念実証）ドキュメント |
| `docs/api` | medium | APIモックとOpenAPI仕様 |
| `docs/tools` | low | 開発ツールとスクリプト |

**理由**: Serenaがコンテキスト理解を最適化

#### 推奨メモリファイル

| ファイル名 | 内容 | 更新頻度 |
|-----------|------|---------|
| `project_overview.md` | プロジェクト全体概要 | プロジェクト開始時 + 大きな変更時 |
| `architecture.md` | 技術アーキテクチャ | アーキテクチャ決定時 |
| `roadmap.md` | 開発ロードマップ | フェーズ移行時 |
| `mcp_servers.md` | MCPサーバー設定 | MCP設定変更時 |

**理由**: AI会話の文脈保持、プロジェクト知識の蓄積

### 移行ガイド（将来の実装フェーズ用）

#### フェーズ1実装開始時

1. **TypeScript Language Serverを有効化**:
   ```yaml
   language_server_settings:
     typescript:
       enabled: true  # false → true
   ```

2. **プロジェクトタイプを変更**:
   ```yaml
   project_type: web_application  # documentation → web_application
   ```

3. **プロジェクトを再インデックス**:
   ```bash
   uvx --from git+https://github.com/oraios/serena serena project index
   ```

#### CI/CD導入時

1. **CI/CDを有効化**:
   ```yaml
   ci_cd:
     enabled: true
   ```

2. **GitHub Actionsワークフローを作成**:
   - `.github/workflows/validate-plantuml.yml`
   - `.github/workflows/lint-markdown.yml`
   - `.github/workflows/test-and-build.yml`

### 既知の制限事項

1. **言語サーバーの制約**:
   - TypeScript/Python/Goなど主要言語のみ対応
   - PlantUML（.puml）は言語サーバー未対応（テキスト検索のみ）

2. **プロジェクト切り替え**:
   - 複数プロジェクト同時作業は非推奨（パフォーマンス低下）
   - プロジェクト切り替え時はキャッシュ再生成が必要な場合あり

3. **メモリ管理**:
   - メモリファイルは手動で整理が必要（自動削除は90日後）
   - 大量のメモリファイルはパフォーマンスに影響

### セキュリティ考慮事項

1. **読み取り専用モード推奨**:
   - 本番環境では編集ツールを無効化
   - 段階的にツールを有効化

2. **機密情報の除外**:
   - `.env`ファイルは`ignored_paths`に追加
   - APIキー、パスワードを含むファイルも除外

3. **権限管理**:
   - `.serena/`ディレクトリの権限を適切に設定
   - メモリファイルは誰でも読めないように制限

### パフォーマンス最適化

1. **事前インデックス作成**（推奨）:
   ```bash
   uvx --from git+https://github.com/oraios/serena serena project index
   ```

2. **ignored_pathsの適切な設定**:
   - 大規模な依存関係（node_modules等）を除外
   - ビルド成果物（dist、build等）を除外

3. **検索結果上限の調整**:
   ```yaml
   tool_settings:
     search_for_pattern:
       max_results: 50  # 大規模プロジェクトでは少なめに
   ```

### 今後の予定

- [ ] TypeScript実装開始時の設定更新
- [ ] CI/CD設定の追加
- [ ] メモリファイルのテンプレート作成
- [ ] Serena v2.0対応（リリース時）

### 参考情報

- **Serena公式**: https://github.com/oraios/serena
- **MCP公式**: https://modelcontextprotocol.io/
- **Claude Code**: https://docs.claude.com/en/docs/claude-code

---

## バージョン履歴

| バージョン | 日付 | 変更内容 |
|----------|------|---------|
| 0.1.0 | 2025-01-15 | 初版作成（企画フェーズ向け設定） |

---

**次の更新予定**: フェーズ1実装開始時（TypeScript有効化、プロジェクトタイプ変更）
