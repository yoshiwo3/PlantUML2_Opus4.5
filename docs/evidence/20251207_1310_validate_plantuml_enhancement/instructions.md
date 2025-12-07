# Instructions: validate_plantuml.ps1 機能拡張

## 作業日時
2025-12-07 13:10

## 目標
PlantUML検証スクリプト（validate_plantuml.ps1）に以下の機能を追加：
1. 2段階ワークフロー（-Review / -Publish）
2. レビューログ機能（.review.json）
3. ハッシュ検証による整合性確保

## コンテキスト
ユーザーからの指摘：
- 問題2: レビュー用PNGと正式版SVGの紐付けがない
- 問題3: レビューOK判定が人間依存

これらを解決するため、レビューログ機能を実装する。

## 実施内容
1. スクリプトに-Review/-Publishモードを実装
2. Review時にレビューログ（.review.json）を生成
3. Publish時にレビューログを検証（status=completed、ハッシュ一致）
4. 履歴保持機能（historyに過去のレビュー結果を保持）
5. ガイドドキュメント（PlantUML_SVG_Generation_Guide.md）を更新

## 完了条件
- [ ] スクリプトが正常に動作
- [ ] ガイドドキュメントが更新済み
- [ ] active_context.mdが更新済み
