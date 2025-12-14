# DFD v5.0 非エンジニア向け改訂版 - 作業指示書

**作業日**: 2025-12-12 22:07
**作業種別**: 20251212_2207_dfd_v5_revision

---

## 目標
**主目標**: DFD技術版をスキルアップ希望の非エンジニア向けに改訂（PlantUML + Mermaid併記）

**具体的な目標**:
1. 読み方ガイド・用語集を冒頭に配置
2. 全図表でPlantUML + Mermaid併記
3. Level 1を4分割して理解しやすく
4. 技術レベル・詳細度は維持
5. Appendixに詳細仕様を整理

**成果物**:
- `docs/proposals/PlantUML_Studio_データフロー図_20251212.md`

**所要時間**: 約1時間

---

## コンテキスト
### 背景

- 前セッションでDFD学習版（Mermaid only）を作成（91点A）
- ユーザーから「技術版も改訂してほしい」との要望
- PlantUML + Mermaid併記、図表を冒頭に配置

### 前提条件

- [x] DFD v3.1（技術版）が存在する
- [x] DFD学習版（Mermaid only）が存在する
- [x] TD-010: DFDはMermaid、他はPlantUML

### 制約
- 技術レベル・詳細度は維持（スキルアップ希望者向け）
- 日本語ラベル必須（Mermaid版）

---

## 実施内容

### Phase 1: 構成変更（5分）
**目的**: 図表を冒頭に移動

**実施内容**:
1. 読み方ガイドを冒頭に配置
2. 用語集を読み方ガイドの後に配置
3. Level 0/1/2の図を続けて配置
4. データディクショナリ等をAppendixに移動

### Phase 2〜7: コンテンツ作成（40分）
**目的**: PlantUML + Mermaid併記、日本語ラベル

**実施内容**:
- Phase 2: 読み方ガイド追加
- Phase 3: 用語集拡充（4カテゴリ16語）
- Phase 4: Level 0にMermaid版追加
- Phase 5: Level 1を4分割＋Mermaid版追加
- Phase 6: Level 2にMermaid版追加
- Phase 7: Appendix整理

### Phase 8: 最終レビュー（10分）
**目的**: 品質確認

**実施内容**:
1. PlantUML + Mermaid併記確認
2. 日本語ラベル確認
3. 技術詳細度確認
4. 100点満点評価

---

## 完了条件

- [x] PlantUML + Mermaid併記（全10図）
- [x] 日本語ラベル（全Mermaid図）
- [x] 読み方ガイド配置
- [x] 用語集拡充
- [x] Level 1四分割
- [x] Appendix整理
- [x] 評価90点以上
- [x] Evidence 3点セット完成
- [x] SERENA Memory保存

---

## 参照リソース

### Memory Bank
- `docs/context/project_brief.md`
- `docs/context/technical_decisions.md`
- `docs/context/active_context.md`

### 関連ドキュメント
- `docs/proposals/PlantUML_Studio_データフロー図_20251208.md`（v3.1技術版）
- `docs/proposals/PlantUML_Studio_データフロー図_学習版_20251212.md`
- `docs/session_handovers/20251212-2150_dfd_markdown_conversion_strategy.md`

---

## 注意事項
- 技術版の詳細度を落とさない
- 非エンジニアが「読める」ではなく「学べる」構成に
- PlantUMLとMermaidの両方でレンダリング確認必要

---

**作業者**: Claude Opus 4.5
