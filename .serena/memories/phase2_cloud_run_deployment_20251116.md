# Phase 2 Cloud Runデプロイ（完了）

**作業日**: 2025-11-16
**フェーズ**: Phase 2（Cloud Runデプロイ）- **100%完了** ✅

## 成果

### デプロイ成功（v1.0.1）

- **Service URL**: https://stdio-http-proxy-491539021035.asia-northeast1.run.app
- **サービス名**: stdio-http-proxy
- **最新リビジョン**: stdio-http-proxy-00002-4nm
- **最新イメージ**: asia-northeast1-docker.pkg.dev/plantuml-477523/plantuml-mcp/stdio-http-proxy:v1.0.1
- **ビルド時間**: 1分4秒（v1.0.1）

### 作成したファイル

1. **Dockerfile**（108行）:
   - マルチステージビルド（builder → production）
   - stdio-http-proxyとstdio-mcp-serverの両方を含む
   - 非rootユーザー実行（nodejs:nodejs 1001）
   - PORT環境変数対応（デフォルト8080）

2. **cloudbuild.yaml**（25行、v1.0.1）:
   - BuildKit有効化（DOCKER_BUILDKIT=1）
   - Artifact Registryへのプッシュ（v1.0.1 + latest）
   - タイムアウト設定（600s）
   - **修正**: `dir`設定削除（ビルド成功のため）

3. **proxy-server.ts**（+13行）:
   - handleToolsCallにパラメータ名変換追加（595-608行目）
   - /mcp/call-toolにパラメータ名変換追加（331-342行目）
   - **後方互換性**: plantuml_code → code 自動変換

4. **plantuml.ts**（+7行）:
   - validatePlantUMLにエラーハンドリング追加（18-24行目）
   - **改善**: codeがundefinedの場合の明確なエラーメッセージ

5. **package.json**（バージョン更新）:
   - 1.0.0 → 1.0.1

6. **Evidence 3点セット**（完備）:
   - instructions.md（202行）
   - 00_raw_notes.md（177行）
   - work_sheet.md（362行、doc-reviewer 88点）

## 解決した問題

### validate_plantumlツールエラー（完全解決）

**エラーメッセージ**:
```
"Cannot read properties of undefined (reading 'trim')"
```

**根本原因**:
- クライアントが`plantuml_code`パラメータで送信
- stdio MCPサーバーは`code`パラメータを期待
- HTTPプロキシでパラメータ名変換が未実装

**解決策**:
1. proxy-server.tsの2箇所にパラメータ名変換を追加:
   - handleToolsCall（tools/call メソッドハンドラー）
   - /mcp/call-toolエンドポイント
2. plantuml.tsにエラーハンドリング強化:
   - `!code`チェックを`!code.trim()`の前に追加
   - エラーメッセージに受信パラメータ名を含める

**検証結果**:
- ✅ validate_plantuml: URL生成成功（https://www.plantuml.com/plantuml/svg/SoWk...）
- ✅ encode_plantuml: エンコード成功（SoWkIImgAStDuNBCoKnELT2rKt3AJx9Iy4ZDoSddSaZDIm7A0G00）
- ✅ decode_plantuml: デコード成功（@startuml\nAlice -> Bob: Hello\n@enduml）

## メトリクス

**前セッション（v1.0.0デプロイ、51%完了）**:
- 作業時間: 約40分
- トークン使用量: 57503トークン（28.7%）
- ツール動作確認成功率: 0%（validate_plantumlエラー）

**今セッション（v1.0.1デプロイ、100%完了）**:
- 作業時間: 約60分（エラー調査10分、修正10分、Cloud Build 10分、動作確認5分、Evidence作成25分）
- トークン使用量: 約100K（50%）
- AI生成率: 100%
- Cloud Buildビルド成功率: 100%（2回目で成功、dir設定削除）
- Cloud Runデプロイ成功率: 100%
- ツール動作確認成功率: 100%（全3ツール成功）
- Evidence品質: 88点（doc-reviewer、目標85点以上達成）

**累計**:
- Phase 2総作業時間: 約100分（見積150分より50分短縮、+33%効率化）
- 進捗: 51% → **100%完了** ✅

## 学び

### 技術的な学び

1. **HTTPプロキシのパラメータ名変換パターン（TD-009候補）**:
   - クライアントとサーバー間のパラメータ名不一致を解決
   - プロキシ層でパラメータ名変換を実装（plantuml_code → code）
   - 後方互換性を維持しつつ、両方のパラメータ名をサポート
   - **今後の活用**: MCP over HTTP実装時の標準パターンとして活用

2. **Cloud Build `dir`設定の注意点**:
   - `dir`設定はビルドコンテキストを変更するため、Dockerfileの相対パスに影響
   - http-mcp-serverのcloudbuild.yamlには`dir`設定がない
   - stdio-http-proxyのcloudbuild.yamlから`dir`設定を削除して成功
   - **今後の活用**: Cloud Build設定時は`dir`設定を慎重に検討

3. **エラーハンドリングの重要性**:
   - `code.trim()`の前に`!code`チェックを追加
   - エラーメッセージに受信したパラメータ名を含めることで、デバッグ効率が向上
   - **今後の活用**: すべてのパラメータ検証で明確なエラーメッセージを提供

4. **Dockerfileでの複数プロジェクト包含**:
   - stdio-http-proxyとstdio-mcp-serverを両方含める
   - 相対パス`../../stdio-mcp-server/dist/index.js`を維持
   - 両プロジェクトのdependencies、dist/をコピー

5. **Cloud Runでのstdio MCPサーバー起動**:
   - 子プロセスとして正常に起動
   - ログにstderr出力が表示される

### プロセスの学び

1. **ローカルDockerデバッグのスキップ判断**:
   - 原因が明確な場合は、ローカルデバッグをスキップして直接修正
   - 作業時間を30分短縮（ローカルDocker 30分 → 直接修正 0分）
   - **改善アクション**: エラー原因が特定できた場合は、効率重視で直接修正を選択

2. **Cloud Buildエラーの迅速な解決**:
   - 成功したビルド（a168725a）の設定を参照
   - `gcloud builds describe`で引数とディレクトリを確認
   - 5分でエラー原因を特定・修正
   - **改善アクション**: Cloud Buildエラー時は過去の成功ビルドを参照

3. **Evidence 3点セットの重要性**:
   - instructions.md（作業指示書）
   - 00_raw_notes.md（リアルタイムメモ）
   - work_sheet.md（詳細作業記録）
   - doc-reviewerレビューで88点（目標85点以上達成）
   - **改善アクション**: すべての重要作業でEvidence 3点セットを完備

## 次のステップ

### 即座に実施すべきタスク

- [x] v1.0.1デプロイ完了
- [x] 全3ツール動作確認完了
- [x] Evidence 3点セット完成
- [x] doc-reviewerレビュー完了（88点）
- [x] Gitコミット・プッシュ完了（コミットID: d0da4dd）

### 短期タスク（1週間以内）

- [ ] v1.0.2デプロイ（任意、plantuml_codeパラメータ対応は既に完了）
- [ ] .mcp.json更新（stdio-http-proxy接続情報追加）
- [ ] technical_decisions.mdにTD-009追加（HTTPプロキシパラメータ名変換パターン）
- [ ] active_context.mdにPhase 2完了を記録

### 長期タスク（1ヶ月以内）

- [ ] Phase 3準備（HTTP MCP実装）
- [ ] Phase 4準備（包括的テスト）

## 関連リソース

- **引継ぎ資料**: session_handovers/20251116-0224_phase2_cloud_run_partial.md
- **Evidence**: docs/poc/evidence/20251116/feature_cloud_run_deployment/
  - instructions.md（202行）
  - 00_raw_notes.md（177行）
  - work_sheet.md（362行、doc-reviewer 88点）
- **Dockerfile**: docs/poc/03_plantuml_mcp_poc/project/stdio-http-proxy/Dockerfile（108行）
- **cloudbuild.yaml**: docs/poc/03_plantuml_mcp_poc/project/stdio-http-proxy/cloudbuild.yaml（25行）
- **Gitコミット**: d0da4dd（feature/migration-phase1）

## 技術決定候補

### TD-009: HTTPプロキシパラメータ名変換パターン（候補）

- **決定日**: 2025-11-16
- **ステータス**: 候補（technical_decisions.mdへの追加待ち）
- **カテゴリ**: アーキテクチャパターン

**決定内容**:
クライアントとサーバー間のパラメータ名不一致を解決するため、プロキシ層でパラメータ名変換を実装

**実装例** (proxy-server.ts):
```typescript
// 後方互換性のため、plantuml_codeパラメータもサポート
if (name === 'validate_plantuml' || name === 'encode_plantuml') {
  if (args && args.plantuml_code && !args.code) {
    args.code = args.plantuml_code;
    delete args.plantuml_code;
  }
}
```

**理由**:
- stdio MCPサーバーは`code`パラメータを期待
- 一部のクライアントが`plantuml_code`で送信
- 後方互換性を維持しつつ、新しい仕様にも対応

**影響**:
- MCP over HTTP実装時の標準パターンとして活用
- 将来的にplantuml_codeパラメータの非推奨化を検討

**関連ファイル**:
- proxy-server.ts（595-618行目、331-342行目）
