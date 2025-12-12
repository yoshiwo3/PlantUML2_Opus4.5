# DFD draw.io作成 - 作業指示書

**作成日**: 2025-12-13 01:04
**作業種別**: DFD図表作成（draw.io形式）
**Evidenceフォルダ**: `docs/evidence/20251213_0104_dfd_drawio/`

---

## 目標

ISO規格DFD（Yourdon-DeMarco記法）をdraw.io形式（.drawio XML）で作成する。

## 背景

- 前回セッションで手書きSVGを作成したが、品質が低かった
- draw.ioを使用することで、視覚的に正確なDFD図表を作成可能
- `.drawio`ファイルは後から編集可能

## 作成対象

| # | 図表名 | ファイル名 | 内容 |
|:-:|--------|-----------|------|
| 1 | Level 0 | `dfd_level0.drawio` | コンテキスト図 |
| 2 | Level 1-A | `dfd_level1_auth.drawio` | 認証フロー |
| 3 | Level 1-B | `dfd_level1_diagram.drawio` | 図表操作フロー |
| 4 | Level 1-C | `dfd_level1_ai.drawio` | AI支援フロー |
| 5 | Level 1-D | `dfd_level1_admin.drawio` | 管理機能フロー |
| 6 | Level 2-P3 | `dfd_level2_diagram_mgmt.drawio` | P3.0 図表管理分解 |
| 7 | Level 2-P5 | `dfd_level2_ai.drawio` | P5.0 AI支援分解 |
| 8 | Level 2-P6M | `dfd_level2_admin_mvp.drawio` | P6.0 管理機能MVP分解 |
| 9 | Level 2-P6P | `dfd_level2_admin_phase2.drawio` | P6.0 管理機能Phase2分解 |
| 10 | Level 2-P8 | `dfd_level2_learning.drawio` | P8.0 学習コンテンツ分解 |

## Yourdon-DeMarco記法

| 要素 | 記号 | draw.io図形 |
|------|------|------------|
| プロセス | 円（○） | Ellipse |
| 外部エンティティ | 四角形（□） | Rectangle |
| データストア | 平行線（═） | Rectangle（上下線のみ） |
| データフロー | 矢印（→） | Arrow |

## 配色規則

| 要素 | 塗り | 線 |
|------|------|-----|
| 外部エンティティ（人） | #E3F2FD | #1565C0 |
| 外部エンティティ（API） | #EDE7F6 | #5E35B1 |
| プロセス | #FFFFFF | #333333 |
| データストア | #FFF8E1 | #F57C00 |
| Phase 2要素 | 同上 | 破線 |

## 出力先

- draw.ioファイル: `docs/evidence/20251213_0104_dfd_drawio/`
- 最終SVG: `docs/proposals/diagrams/dfd/`

## 完了条件

- [ ] 全10図のdraw.ioファイル作成完了
- [ ] SVGエクスポート完了
- [ ] v5.0ドキュメントに埋め込み完了
- [ ] Evidence 3点セット完成

---

## 参照ドキュメント

- `docs/proposals/PlantUML_Studio_データフロー図_20251208.md` - DFD v4.0仕様
- `docs/poc/evidence/20251213_0056_dfd_iso_svg/instructions.md` - 前回作業（参考）
