# DFD（データフロー図）作成 - Instructions

**作成日時**: 2025-12-08 01:28
**作業者**: Claude Code (Opus 4.5)

---

## 目標

PlantUML Studioのデータフロー図（DFD）を作成する。

## コンテキスト

- **フェーズ**: PRD作成（図表正式版作成中）
- **依存関係**: コンテキスト図・ユースケース図・業務フロー図（MVP）完了後
- **次工程**: 機能一覧表（業務フロー・DFD対比）

## 参照ドキュメント

| ドキュメント | パス | 内容 |
|-------------|------|------|
| 下書き | `docs/design/PlantUML_Studio_設計図表_20251130.md` §4.1-4.2 | DFDレベル0・レベル1 |
| コンテキスト図 | `docs/proposals/PlantUML_Studio_コンテキスト図_20251130.md` | システム境界・外部アクター |
| 業務フロー図 | `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` | プロセスフロー |
| PlantUML憲法 | `docs/guides/PlantUML_Development_Constitution.md` | 作成ルール |

## 実施内容

1. **下書き分析**: §4.1-4.2の内容確認・問題点洗い出し
2. **Context7確認**: PlantUML DFD構文仕様
3. **DFDレベル0作成**: コンテキスト図との整合性確認
4. **DFDレベル1作成**: 主要プロセスのデータフロー詳細化
5. **視覚的レビュー**: PNG生成・4パスレビュー
6. **正式版保存**: SVG生成・proposals配置

## 完了条件

- [ ] DFDレベル0・レベル1が正式版として保存されている
- [ ] コンテキスト図・業務フロー図との整合性が確認されている
- [ ] SVGが `docs/proposals/diagrams/dfd/` に保存されている
- [ ] work_sheet.mdが完成している

## 出力先

| 種類 | パス |
|------|------|
| 正式版 | `docs/proposals/PlantUML_Studio_データフロー図_20251208.md` |
| SVG | `docs/proposals/diagrams/dfd/*.svg` |
