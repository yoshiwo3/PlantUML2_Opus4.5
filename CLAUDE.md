# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PlantUML Studio - 次世代PlantUML図表作成Webアプリケーションの企画・調査リポジトリ。現在はドキュメント中心のフェーズ（`project_type: documentation`）。

## MCP Servers

このプロジェクトでは以下のMCPサーバーを使用：

### 必須
- **Context7**: ライブラリドキュメント参照（PlantUML仕様等）
- **Serena**: コードベース理解、シンボル検索、プロジェクトメモリ管理

### 設定済み
- **PlantUML Validator**: PlantUML構文検証（`mcp__plantuml-validator__generate_plantuml_diagram`）
- **Playwright**: ブラウザ自動操作
- **GitHub**: GitHub API操作
- **Claude Ops**: 操作履歴・ファイル変更追跡

## Custom Agents

`.claude/agents/`配下にPlantUML専用エージェントを定義：

- **plantuml-validator**: PlantUMLコード検証専門家。PlantUMLコード発見時に積極的に使用（`use PROACTIVELY`）。検証ループで100%成功保証
- **plantuml-explorer**: プロジェクト内の.pumlファイル一括検証・レポート生成
- **diagram-type-analyzer**: 図表タイプ分類とUI最適化提案

## PlantUML Code Rules

すべてのPlantUMLコード（.pumlファイル、ドキュメント内コードブロック）は：
1. 保存/コミット前に必ず`mcp__plantuml-validator__generate_plantuml_diagram`で検証
2. 検証失敗時は修正→再検証（最大5回リトライ）
3. 検証スキップ・エラー無視は禁止

## Directory Structure

```
PlantUML2_Opus4.5/
├── .claude/
│   ├── agents/              # カスタムエージェント定義
│   └── settings.local.json  # MCP設定・権限
├── .serena/
│   ├── memories/            # プロジェクト知識永続化
│   ├── project.yml          # Serena設定
│   └── QUICK_REFERENCE.md   # Serenaクイックリファレンス
├── docs/
│   ├── context/             # Memory Bank（Layer 1）
│   │   ├── project_brief.md
│   │   ├── technical_decisions.md
│   │   ├── coding_standards.md
│   │   └── active_context.md
│   ├── session_handovers/   # セッション引継ぎ資料
│   ├── poc/evidence/        # PoC証跡（Layer 3）
│   ├── templates/           # ドキュメントテンプレート
│   └── guides/              # ガイドドキュメント
├── scripts/
│   ├── create_evidence.ps1  # Evidence自動作成（Windows）
│   └── create_evidence.sh   # Evidence自動作成（Linux/macOS）
└── doc/
    └── AI_DRIVEN_DEV_ENVIRONMENT_SETUP_GUIDE.md
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
