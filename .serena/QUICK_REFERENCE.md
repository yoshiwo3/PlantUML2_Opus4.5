---
**📍 このドキュメントの位置付け**: Layer 3 - Configuration & Utilities

このファイルはSerena MCPクイックリファレンスです。プロジェクト全体の知識は以下を参照：
- **Memory Bank**: ../docs/context/（プロジェクト全体の知識）
- **ドキュメント体系**: ../docs/DOCUMENTATION_SYSTEM_OVERVIEW.md
---

# Serena MCP クイックリファレンス

## 目次

1. [よく使うコマンド](#よく使うコマンド)
2. [Serenaツール一覧](#serenaツール一覧)
3. [AI指示の例文集](#ai指示の例文集)
4. [設定変更チートシート](#設定変更チートシート)
5. [トラブルシューティング早見表](#トラブルシューティング早見表)

---

## よく使うコマンド

### プロジェクト管理

```bash
# プロジェクト設定を生成
uvx --from git+https://github.com/oraios/serena serena project generate-yml

# プロジェクトをインデックス化（高速化）
uvx --from git+https://github.com/oraios/serena serena project index

# グローバル設定を編集
uvx --from git+https://github.com/oraios/serena serena config edit

# MCPサーバーを手動起動（テスト用）
uvx --from git+https://github.com/oraios/serena serena start-mcp-server --help
```

### キャッシュ管理

```bash
# キャッシュをクリア
rm -rf .serena/cache

# プロジェクトを再インデックス
uvx --from git+https://github.com/oraios/serena serena project index
```

### Claude Code関連

```bash
# Serena MCPを追加（Claude Code）
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena \
  serena start-mcp-server --context ide-assistant --project "$(pwd)"

# Claude Code設定をリロード
claude --reload-config

# MCP接続状態を確認
claude mcp list
```

---

## Serenaツール一覧

### ファイル・ディレクトリ操作

| ツール名 | 用途 | 使用例（AI指示） |
|---------|------|----------------|
| `list_dir` | ディレクトリ内のファイル一覧取得 | 「`docs/`配下を再帰的にリスト表示して」 |
| `find_file` | ファイル名・パターンでファイル検索 | 「`企画書.md`を探して」 |
| `search_for_pattern` | 正規表現でコンテンツ検索 | 「`PlantUML Validator`を含むファイルを検索」 |

### シンボル解析

| ツール名 | 用途 | 使用例（AI指示） |
|---------|------|----------------|
| `get_symbols_overview` | ファイル内のシンボル一覧（クラス、関数等） | 「`server.ts`のシンボル概要を表示」 |
| `find_symbol` | シンボル名でコード検索 | 「`AuthService`クラスを見つけて」 |
| `find_referencing_symbols` | シンボルの参照箇所を検索 | 「`handleLogin`が呼ばれている場所を全て表示」 |

### コード編集

| ツール名 | 用途 | 使用例（AI指示） |
|---------|------|----------------|
| `replace_symbol_body` | シンボルの本体を置換 | 「`validateInput`メソッドを書き換えて」 |
| `insert_after_symbol` | シンボルの後にコード挿入 | 「`UserClass`の後に新しいメソッドを追加」 |
| `insert_before_symbol` | シンボルの前にコード挿入 | 「最初のimport文の前に新しいimportを追加」 |
| `rename_symbol` | シンボル名の変更（全参照箇所も更新） | 「`getData`を`fetchData`にリネーム」 |

### メモリ管理

| ツール名 | 用途 | 使用例（AI指示） |
|---------|------|----------------|
| `write_memory` | プロジェクト知識を保存 | 「この設計方針をメモリに保存」 |
| `read_memory` | 保存した知識を読み込み | 「`architecture.md`メモリを参照」 |
| `list_memories` | メモリファイル一覧 | 「保存されているメモリを全て表示」 |
| `delete_memory` | メモリファイルを削除 | 「`old_notes.md`メモリを削除」 |

### プロジェクト管理

| ツール名 | 用途 | 使用例（AI指示） |
|---------|------|----------------|
| `activate_project` | プロジェクトを切り替え | 「PlantUML2_Codexプロジェクトをアクティブ化」 |
| `get_current_config` | 現在の設定を表示 | 「Serenaの現在の設定を教えて」 |
| `check_onboarding_performed` | オンボーディング状態確認 | （自動実行） |
| `onboarding` | プロジェクトオンボーディング実行 | （自動実行） |

### 思考・検証ツール

| ツール名 | 用途 | 使用例（AI指示） |
|---------|------|----------------|
| `think_about_collected_information` | 収集した情報の整理 | （自動実行） |
| `think_about_task_adherence` | タスク遂行状況の確認 | （自動実行） |
| `think_about_whether_you_are_done` | タスク完了確認 | （自動実行） |

---

## AI指示の例文集

### ファイル探索

```
# ファイル名で検索
「企画書.mdを探して、その内容を要約してください。」

# パターン検索
「PlantUML Validatorという文字列を含むファイルを全て見つけて。」

# ディレクトリ構造確認
「docs/配下のディレクトリ構造を再帰的に表示して。」
```

### コード理解

```
# シンボル概要取得
「server.tsファイルのシンボル一覧（クラス、関数等）を表示して。」

# クラス定義の取得
「AuthServiceクラスの定義とメソッド一覧を教えて。」

# 関数の参照箇所検索
「handleLogin関数が呼ばれている箇所を全て表示して。」
```

### コード編集

```
# メソッドの置換
「validateInputメソッドを、より厳密な検証ロジックに書き換えて。」

# 新しいメソッドの追加
「UserClassの最後に、getUserById(id: string)メソッドを追加して。」

# インポート文の追加
「最初のimport文の前に、import { Logger } from './utils/logger'を追加。」
```

### メモリ操作

```
# メモリに保存
「このプロジェクトのアーキテクチャ決定事項を.serena/memories/architecture.mdに保存して。」

# メモリを参照
「.serena/memories/roadmap.mdの内容を確認して、次のマイルストーンを教えて。」

# メモリ一覧
「保存されているメモリファイルを全て教えて。」
```

### プロジェクト管理

```
# プロジェクト切り替え
「PlantUML2_Codexプロジェクトをアクティブ化して。」

# 設定確認
「Serenaの現在の設定を表示して。」
```

### 複合タスク

```
# ドキュメント調査 + 要約
「docs/proposals/企画書.mdを読んで、フェーズ5のAI機能について要約して。」

# コード検索 + 編集提案
「ユーザー認証に関連するコードを全て見つけて、セキュリティ改善の提案をして。」

# 設計変更 + メモリ保存
「RenderServiceの設計を見直して、改善案を.serena/memories/architecture.mdに追記して。」
```

---

## 設定変更チートシート

### project.yml

```yaml
# 言語設定を変更（実装フェーズ開始時）
language_server_settings:
  typescript:
    enabled: true  # false → true

# 無視パスを追加
ignored_paths:
  - "test_data/**"
  - "**/*.backup"

# 検索結果の上限を変更
tool_settings:
  search_for_pattern:
    max_results: 200  # デフォルト100

# メモリの保持期間を変更
memory_settings:
  retention_days: 180  # デフォルト90

# プロジェクトタイプを変更
project_type: web_application  # documentation → web_application

# CI/CDを有効化
ci_cd:
  enabled: true
```

### serena_config.yml（グローバル）

```yaml
# ツールを無効化（セキュリティ重視）
disabled_tools:
  - "replace_symbol_body"
  - "insert_after_symbol"
  - "insert_before_symbol"
  - "write_memory"

# 出力行数の上限を変更
output_format:
  max_lines: 5000  # デフォルト2000

# デバッグモードを有効化
debug:
  enabled: true
  log_level: "debug"
```

### .mcp.json（Claude Code）

```json
{
  "mcpServers": {
    "serena": {
      "command": "uvx",
      "args": [
        "--from",
        "git+https://github.com/oraios/serena",
        "serena",
        "start-mcp-server",
        "--context",
        "ide-assistant",
        "--project",
        "C:/d/PlantUML2_Codex"
      ]
    }
  }
}
```

---

## トラブルシューティング早見表

| 症状 | 原因 | 解決策 |
|------|------|--------|
| **Serenaが起動しない** | Python 3.11未インストール | `python3.11 --version`で確認、インストール |
| **プロジェクトが見つからない** | project.ymlが存在しない | `serena project generate-yml`を実行 |
| **検索が遅い** | インデックス未作成 | `serena project index`を実行 |
| **検索結果が不正確** | キャッシュが古い | `.serena/cache`を削除して再インデックス |
| **メモリが保存されない** | write_memoryが無効化 | `disabled_tools`から`write_memory`を削除 |
| **接続エラー** | .mcp.json設定ミス | `.mcp.json`のコマンド・引数を確認 |
| **権限エラー** | ファイル権限不足 | `chmod 755 .serena`で権限付与 |

### 緊急リセット手順

```bash
# 1. キャッシュを全削除
rm -rf .serena/cache

# 2. 設定をリセット（バックアップ後）
cp .serena/project.yml .serena/project.yml.backup
uvx --from git+https://github.com/oraios/serena serena project generate-yml

# 3. Claude Code設定をリロード
claude --reload-config

# 4. プロジェクトを再インデックス
uvx --from git+https://github.com/oraios/serena serena project index
```

---

## パフォーマンス最適化

### 大規模プロジェクト向け

```yaml
# project.yml
ignored_paths:
  - "node_modules/**"      # 必須
  - "**/dist/**"           # 必須
  - "**/.next/**"          # 必須
  - "test_data/**"         # 任意
  - "**/*.test.ts"         # テストファイルを除外（任意）

tool_settings:
  search_for_pattern:
    max_results: 50        # 結果を制限
    context_lines_before: 1
    context_lines_after: 1

memory_settings:
  auto_save: false         # 手動保存に切り替え
  retention_days: 30       # 短縮
```

### 小規模プロジェクト向け

```yaml
# project.yml
tool_settings:
  search_for_pattern:
    max_results: 200       # 多めに設定
    context_lines_before: 3
    context_lines_after: 3

memory_settings:
  auto_save: true
  retention_days: 180
```

---

## セキュリティベストプラクティス

### 読み取り専用モード

```yaml
# serena_config.yml または project.yml
disabled_tools:
  - "replace_symbol_body"
  - "insert_after_symbol"
  - "insert_before_symbol"
  - "rename_symbol"
  - "write_memory"

# 有効なツール（読み取りのみ）
enabled_tools:
  - "list_dir"
  - "find_file"
  - "search_for_pattern"
  - "get_symbols_overview"
  - "find_symbol"
  - "find_referencing_symbols"
  - "read_memory"
  - "list_memories"
```

### 段階的権限拡大

```yaml
# フェーズ1: 読み取りのみ
enabled_tools:
  - "list_dir"
  - "find_file"
  - "search_for_pattern"

# フェーズ2: シンボル解析追加
enabled_tools:
  - "get_symbols_overview"
  - "find_symbol"
  - "find_referencing_symbols"

# フェーズ3: メモリ追加
enabled_tools:
  - "write_memory"
  - "read_memory"

# フェーズ4: 編集機能追加
enabled_tools:
  - "replace_symbol_body"
  - "insert_after_symbol"
  - "insert_before_symbol"
```

---

## 便利なエイリアス（Bash/PowerShell）

### Bash（Linux/macOS）

```bash
# ~/.bashrc または ~/.zshrc に追加
alias serena-start='uvx --from git+https://github.com/oraios/serena serena start-mcp-server'
alias serena-index='uvx --from git+https://github.com/oraios/serena serena project index'
alias serena-config='uvx --from git+https://github.com/oraios/serena serena config edit'
alias serena-clean='rm -rf .serena/cache && echo "Cache cleared"'
```

### PowerShell（Windows）

```powershell
# $PROFILE ファイルに追加
function Serena-Start {
    uvx --from git+https://github.com/oraios/serena serena start-mcp-server
}

function Serena-Index {
    uvx --from git+https://github.com/oraios/serena serena project index
}

function Serena-Config {
    uvx --from git+https://github.com/oraios/serena serena config edit
}

function Serena-Clean {
    Remove-Item -Recurse -Force .serena/cache
    Write-Host "Cache cleared"
}
```

---

## 関連リンク

- **詳細ガイド**: `.serena/README.md`
- **プロジェクト設定**: `.serena/project.yml`
- **公式GitHub**: https://github.com/oraios/serena

---

**最終更新**: 2025-01-15
**作成者**: PlantUML2_Codex開発チーム
