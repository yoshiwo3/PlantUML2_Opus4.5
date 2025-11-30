# TD-013: Playwright MCPスクリーンショット自動生成（2025-11-24）

## 背景
ユーザーから「Playwright MCPでスクショを取るようですが、何のスクショをとるのですか？」という質問があり、既存ドキュメント（CLAUDE.md, docs/scripts/playwright_capture_recipe.md）が断片的で全体像が不明瞭と判断。包括的なドキュメント化を実施。

## 決定内容

### 1. スクリーンショットの用途
- **保存先**: `docs/learning/<diagram-type>/images/`
- **撮影対象**: PlantUML Studio画面全体（4パネルレイアウト）
  - 左パネル: 図表タイプ選択、専用GUIコントロール
  - 中央パネル: Monaco Editorでのコード編集
  - 右パネル: リアルタイムプレビュー
  - 下部AIパネル: Explain/AIチャットタブ

### 2. 自動生成フロー
```
steps.json定義 → Playwright MCP起動 → PlantUML Studio起動
→ UI操作実行 → スクリーンショット撮影 → images/*.png保存
```

### 3. RAGシステムとの連携
1. ユーザーが質問: 「シーケンス図でメッセージを追加するには？」
2. RAG検索: `learning_documents`テーブルからFTS/ベクトル検索
3. 提示: AIチャット回答末尾に「📚 関連学習コンテンツ（最大3件）」
4. クリック: スクリーンショット付きHow-toガイドをin-appモーダル表示
5. 効果: 非エンジニアでも視覚的に操作方法を即座に理解

### 4. メリット
- ✅ 手動撮影の工数削減（22図表 × 5ステップ = 110枚自動化）
- ✅ 一貫性のある撮影（ビューポート、解像度、命名規則統一）
- ✅ 自動更新（UIデザイン変更時も自動再生成）
- ✅ CI/CD統合（PRマージ前に最新スクショが常に準備）
- ✅ 学習効果向上（非エンジニアの図表作成成功率向上）

## ドキュメント化
- **TD-013追加**: `docs/context/technical_decisions.md` (795-940行目)
- **既存参照**: `CLAUDE.md` (1444-1463行目), `docs/scripts/playwright_capture_recipe.md`

## 関連技術決定
- **TD-012**: Cloud Run一本化 - Playwright MCPもCloud Runから呼び出し可能
- **TD-010**: 実描画テスト必須 - 学習コンテンツのサンプルコードも検証必須

## コミット
- `9c2b92f`: docs(TD-013): Playwright MCPスクリーンショット自動生成を技術決定に追加

## 次のアクション
1. PlantUML Studio開発時に `data-testid` 属性の命名規則を策定
2. 学習コンテンツ作成ガイドラインに `steps.json` スキーマを追加
3. CI/CDパイプラインにスクリーンショット自動生成ステップを追加
