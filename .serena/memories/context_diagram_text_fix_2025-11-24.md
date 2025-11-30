# コンテキスト図テキスト重複修正（2025-11-24）

## 問題
- `plantuml_studio_context.md` のAI/LLMクラウドとNext.js Webアプリ間の矢印ラベルが重複
- テキストが重なり判別不可能な状態

## 修正内容
- `webapp --> llmApi` → `webapp -up-> llmApi` （上方向）
- `llmApi --> webapp` → `llmApi -down-> webapp` （下方向）
- 矢印を上下に分離してラベルの視認性を改善

## 関連技術決定
- TD-011: PlantUML検証エラー情報取得（ローカルJAR専用、公式サーバーフォールバックなし）
- TD-012: Cloud Run一本化（Vercel不要、無料枠で月36万リクエスト処理可能）

## コミット
- `70d03bc`: fix(context): AI/LLM-Next.js間のテキスト重複を修正

## 次のアクション
- 企画書フェーズ5の更新（エラー取得方法の詳細追加）
- コーディング規約の更新（ローカルJAR検証パターン追加）
