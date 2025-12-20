# Instructions: UC 4-2 AIチャット シーケンス図作成

## 目標

UC 4-2「AIチャットで図表を修正する」のシーケンス図を作成し、統合版（08_シーケンス図_20251214.md）の§8として追加する。

## コンテキスト

- **前提**: UC 4-1 AI Question-Start（§7）完了済み
- **関係**: §7で生成した図表に対して、会話形式で修正・改善を依頼するフロー
- **外部システム**: OpenRouter（conversation mode）

## §7 AI Question-Startとの違い

| 項目 | §7 AI Question-Start | §8 AIチャット |
|------|---------------------|---------------|
| 目的 | 新規図表生成 | 既存図表の修正・改善 |
| 入力 | 質問テキスト | 修正指示 + 現在の図表コード |
| 会話 | 単発（1ターン） | マルチターン（履歴維持） |
| 出力 | 新規PlantUMLコード | 修正済みPlantUMLコード |

## 参照ドキュメント

| ドキュメント | パス | 参照ポイント |
|-------------|------|-------------|
| シーケンス図統合版 §7 | `docs/proposals/08_シーケンス図_20251214.md` | AI Question-Startパターン（ベース） |
| 業務フロー図 §3.2 | `docs/proposals/03_業務フロー図_20251201.md` | PlantUML AI支援フロー |
| 機能一覧表 F-AI-02 | `docs/proposals/05_機能一覧表_20251213.md` | AIチャット機能詳細 |
| クラス図 | `docs/proposals/06_クラス図_20251208.md` | AIService、OpenRouterClient |
| 技術決定 TD-007 | `docs/context/technical_decisions.md` | OpenRouter経由でLLM利用 |
| シーケンス図作成ガイド | `docs/guides/md_authoring_guides/Sequence_Diagram_Authoring_Guide.md` | チェックリスト |
| アクティブバー知見ベース | `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` | LL-001〜025 |

## 実施内容

1. 関連ドキュメント確認（業務フロー、機能一覧表、クラス図、TD-007）
2. PlantUML開発憲法・シーケンス図ガイドライン確認
3. シーケンス図PlantUMLコード作成
4. PNG生成・4パスレビュー
5. SVG生成・統合版§8として追加
6. Evidence完成・active_context更新

## 完了条件

- [ ] シーケンス図PlantUMLコード完成
- [ ] 4パスレビュー完了（アクティブバー確認含む）
- [ ] SVG生成・統合版§8追加
- [ ] Evidence 3点セット完成
- [ ] active_context.md更新
- [ ] Git commit & push

## 成果物

- `docs/proposals/diagrams/08_sequence/8_1_AI_Chat.svg`
- `docs/proposals/08_シーケンス図_20251214.md` §8追加
- Evidence 3点セット

---

**作成日時**: 2025-12-20 23:30
**作業者**: Claude Code
