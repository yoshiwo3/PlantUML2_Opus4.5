# 作業指示書: issuesテンプレート実装

**作成日時**: 2025-12-07 15:30
**作業者**: Claude (AI Assistant)

---

## 目標

`validate_plantuml.ps1`のレビューログにissuesテンプレート構造を追加し、Claudeが問題点を記録しやすくする。

## コンテキスト

- 指示書: `docs/guides/validate_plantuml_issues_template_spec.md`
- 現状: レビューログの`issues`は空配列`[]`で生成される
- 課題: Claudeがissuesの構造を知らないと記入が困難

## 実施内容

1. `scripts/validate_plantuml.ps1`の`New-ReviewLog`関数を修正
   - `issues`にテンプレート構造（pass/symptom/cause）を追加
2. `docs/guides/PlantUML_SVG_Generation_Guide.md`を更新
   - レビューログ構造例にissuesテンプレートを反映
   - Claudeの操作手順を追記
   - トラブルシューティングにスクリプト修正時の注意を追加
3. `CLAUDE.md`を更新
   - Step 5にissues操作手順を追加
4. 指示書のステータスを更新

## 完了条件

- [ ] `-Review`実行でissuesテンプレートが生成される
- [ ] ConvertTo-Jsonで正しくシリアライズされる
- [ ] 関連ドキュメントが更新されている
- [ ] 指示書のステータスが「実装完了」になっている

## 参照ドキュメント

- `docs/guides/validate_plantuml_issues_template_spec.md`
- `docs/guides/PlantUML_SVG_Generation_Guide.md`
- `CLAUDE.md`
