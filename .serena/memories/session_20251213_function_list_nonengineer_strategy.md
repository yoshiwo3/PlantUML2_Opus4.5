# セッション記録: 機能一覧表 非エンジニア向け改訂（戦略立案）

**日時**: 2025-12-13 15:35-16:45
**Evidence**: `20251213_1535_function_list_nonengineer_revision`

## 完了事項

1. 機能一覧表v1.8を非エンジニア向けに評価 → 20点/100点（Fランク）
2. 改訂戦略書（instructions.md）作成 → AI実行指示書形式
3. 用語集Tier 1（15語）作成
4. 3層構造テンプレート作成（Obsidian Callout対応）
5. F-AUTH-01サンプル改訂 → 86点/100点（Aランク）達成
6. Obsidian Callout動作確認 → ユーザー確認済み
7. 戦略書の厳格評価 → 46点/100点（Fランク）- 致命的欠陥4件発見

## instructions.md 致命的欠陥

| # | 欠陥 | 修正内容 |
|:-:|------|---------|
| 1 | バージョン番号矛盾（v2.0/v3.0） | v3.0に統一 |
| 2 | 機能数計算エラー（16→22, 14→8） | 正しい数値に修正 |
| 3 | ベースファイル操作手順欠落 | §3.3を追加 |
| 4 | エッジケース処理ルール欠落 | §6.4を追加 |

## 重要な制約

- MDビューワー: **Obsidian**
- 折りたたみ: `> [!note]-` 構文（`<details>`禁止）
- 基本方針: **「削らない、足す」**

## 次セッションのタスク

1. instructions.md致命的欠陥の修正
2. 修正後の再評価（目標80点以上）
3. Phase 2以降の実行（Part 0作成、32機能改訂）

## 関連ファイル

- 引継ぎ書: `docs/session_handovers/20251213-1640_function_list_nonengineer_revision_strategy.md`
- Evidence: `docs/evidence/20251213_1535_function_list_nonengineer_revision/`
