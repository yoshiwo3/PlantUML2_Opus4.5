# セッション記録: DFD Mermaid比較検証・ハイブリッド方式決定

**日時**: 2025-12-12
**内容**: DFD図表の記法比較とハイブリッド方式の決定

---

## 決定事項

### TD-010: DFD図表記法ハイブリッド方式

| 図表種別 | 採用記法 | 理由 |
|---------|---------|------|
| **DFD（データフロー図）** | **Mermaid** | レイアウト制御◎、矢印交差少ない、GitHub/Obsidianネイティブ対応 |
| シーケンス図 | PlantUML | 詳細な制御が必要、既存資産あり |
| クラス図 | PlantUML | 複雑な関係表現、既存資産あり |
| 業務フロー図 | PlantUML | アクティビティ図の表現力、既存資産あり |
| ユースケース図 | PlantUML | 既存資産あり |

### 比較検証結果

| 観点 | Mermaid | PlantUML |
|------|:-------:|:--------:|
| レイアウト制御 | ◎ | △（自動配置で交差多い） |
| プロセス記号 | ◎ 二重円 | ○ 楕円 |
| データストア記号 | ○ 円筒 | ◎ シリンダー |
| Obsidian対応 | ◎ ネイティブ | ◎ プラグイン |
| GitHub対応 | ◎ ネイティブ | △ 画像参照必要 |

---

## 作成ファイル

| ファイル | 内容 |
|---------|------|
| `docs/proposals/DFD_Mermaid_Hybrid_Sample.html` | Mermaid版DFD改善版（v5.0）- 非エンジニア向け |
| `docs/evidence/20251212_1430_dfd_phase2_update/DFD_comparison_sample.md` | PlantUML/Mermaid比較サンプル |
| `docs/session_handovers/20251212-2150_dfd_markdown_conversion_strategy.md` | DFD Markdown変換戦略（次セッション用） |

---

## 次のタスク

`PlantUML_Studio_データフロー図_20251208.md`を非エンジニア向けに改善：
1. 「この図の読み方」セクション追加
2. 用語集拡充
3. DFD図をMermaidに変換
4. レベル1を4分割
5. 技術詳細をAppendixに移動

詳細は引継ぎ資料参照: `docs/session_handovers/20251212-2150_dfd_markdown_conversion_strategy.md`
