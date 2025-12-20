# Evidence: UC 3-6 エクスポートシーケンス図作成

## 作業情報

| 項目 | 内容 |
|------|------|
| 作業日時 | 2025-12-18 01:04 |
| 作業者 | Claude Code |
| 対象UC | UC 3-6 図表をエクスポートする |

## 目標

UC 3-6 エクスポートフローのシーケンス図を作成する。

## コンテキスト

- **業務フロー図**: `03_業務フロー図_20251201.md` § 3.6.2
- **機能一覧表**: F-DGM-06
- **技術仕様**:
  - PlantUML: node-plantuml (PNG/SVG/PDF)
  - Excalidraw: exportToBlob/exportToSvg
- **クラス図v1.7参照**: PlantUMLService, ExcalidrawService

## 実施内容

1. Context7でシーケンス図仕様確認 ✅
2. PlantUML開発憲法v4.6確認 ✅
3. シーケンス図作成ガイドライン確認 ✅
4. 既存シーケンス図パターン確認 ✅
5. シーケンス図コード作成
6. PNG生成・4パスレビュー
7. レビューログ更新
8. SVG生成・統合版に追加

## 完了条件

- [ ] PlantUMLエクスポートシーケンス図が作成されている
- [ ] 4パスレビューが完了している
- [ ] レビューログ（.review.json）がstatus: completedになっている
- [ ] SVG正式版が`docs/proposals/diagrams/08_sequence/`に保存されている
- [ ] 統合版Markdown（`08_シーケンス図_20251214.md`）に追加されている

## 参照ドキュメント

- `docs/guides/PlantUML_Development_Constitution.md` v4.6
- `docs/guides/md_authoring_guides/Sequence_Diagram_Authoring_Guide.md`
- `docs/proposals/03_業務フロー図_20251201.md` § 3.6.2
- `docs/proposals/06_クラス図_20251208.md` v1.7
