# Serena TypeScript Language Server セットアップ記録

**日付**: 2025-11-07
**対象プロジェクト**: PlantUML2_Codex
**Phase**: Phase 2 HTTP MCP実装開始

---

## 実施した設定変更

### 1. root tsconfig.json 作成

**ファイルパス**: `/c/d/PlantUML2_Codex/tsconfig.json` (新規作成)

**目的**: Serena Language Server Manager がTypeScriptプロジェクトを認識するため

**設定内容**:
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "node",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "lib": ["ES2020"]
  },
  "include": [
    "docs/poc/**/project/**/src/**/*.ts"
  ],
  "exclude": [
    "node_modules",
    "**/*.spec.ts",
    "**/dist/**",
    "**/build/**",
    "**/.next/**"
  ]
}
```

**重要なポイント**:
- `include`: サブディレクトリの全TypeScriptファイルをカバー
- `exclude`: テストファイル、ビルド成果物を除外
- 厳格な型チェック（`strict: true`）

### 2. TypeScript Language Server グローバルインストール

```bash
npm install -g typescript-language-server typescript
```

**インストールバージョン**:
- `typescript-language-server@4.3.3`
- `typescript@5.9.3`

### 3. .serena/project.yml 更新

**ファイルパス**: `/c/d/PlantUML2_Codex/.serena/project.yml`

**変更内容**:
```yaml
# Before:
language_server_settings:
  typescript:
    enabled: false  # 現在は無効（ドキュメント専用フェーズ）

# After:
language_server_settings:
  typescript:
    enabled: true  # Phase 2実装開始（2025-11-07）
```

**変更理由**: Phase 2実装フェーズへ移行

---

## 結果

### Language Server Manager の状態

- ❌ **初期化は依然として失敗**
  - Serenaダッシュボード: Task-4:init_language_server_manager Failed
- ✅ **Serenaの基本ツール（22個中20個以上）は正常動作**

### 影響評価

**開発効率への影響**: 限定的
- シンボル定義ジャンプ: 5-10秒 → 30-60秒（Read + Grep代替）
- 主な作業（ファイル読み込み、パターン検索）は問題なし

**トークン消費**: Read ツールで十分対応可能

**コスト対効果**: 追加調査は不要と判断（30分以上の調査済み）

---

## ベストプラクティス（今後の参考）

### ✅ TypeScript Language Server 有効化の推奨条件

1. プロジェクトルートに tsconfig.json が存在
2. typescript-language-server がグローバルインストール済み
3. Phase 2（実装フェーズ）以降
4. **プロジェクトルートにTypeScriptファイルが存在**（重要）

### ⚠️ 注意事項

1. **プロジェクト構造の制約**:
   - TypeScriptファイルがサブディレクトリのみに存在する場合、Language Server初期化が困難
   - プロジェクトルートにコードファイルが無いプロジェクトでは効果が限定的

2. **調査時間のコスト対効果**:
   - Language Server調査に30分以上を費やすのは非効率
   - 基本ツールで十分な場合は代替手段を優先

3. **Phase 1（企画フェーズ）では無効化を推奨**:
   - ドキュメント専用フェーズでは不要
   - Phase 2以降の実装フェーズで有効化

### 代替手段

Language Server が利用できない場合:
1. **Read ツール**: ファイル全体読み込み
2. **Grep ツール**: パターン検索
3. **Serena基本ツール**: list_dir, find_file, search_for_pattern

**推奨アプローチ**:
1. まず基本ツールで作業を進める
2. 明確な効率性の問題が発生した場合のみLanguage Server調査
3. 30分以上の調査は投資対効果を再評価

---

## 今後のアクション

- [ ] `docs/best_practices/serena_configuration.md`作成（設定ベストプラクティス）
- [ ] `docs/best_practices/serena_troubleshooting.md`作成（Language Server問題のトラブルシューティング）
- [ ] Phase 3以降でプロジェクト構造変更時に Language Server 再評価

---

**記録者**: Claude Code
**記録日時**: 2025-11-07 22:20 JST
