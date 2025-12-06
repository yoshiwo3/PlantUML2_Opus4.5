# 3.6 保存・エクスポートフロー 設計完了メモ

## 完了日: 2025-12-06

## 対応ユースケース
- UC 3-5: 図表を保存する（手動保存のみ: Ctrl+S）※自動保存はStorage Only構成では未実装
- UC 3-6: 図表をエクスポートする（PNG/SVG/PDF出力）

## 設計決定事項

### Storage構成（統一設計）
```
/{user_id}/{project_id}/{diagram_id}/
├── source.puml または source.json
├── preview_0.svg
├── preview_1.svg (PlantUMLで複数図がある場合)
└── ...
```

| 項目 | PlantUML | Excalidraw |
|------|----------|------------|
| ソースファイル | `source.puml`（複数@startuml可） | `source.json` |
| プレビューファイル | `preview_N.svg`（図の数だけ） | `preview_0.svg`（1ファイル） |
| サムネイル | `preview_0.svg`を使用 | `preview_0.svg`を使用 |

### Frontend Serviceオーケストレーションパターン
Frontend Serviceがバックエンドサービスへの処理依頼・結果受信を明示的に行う設計：
```
Frontend Service → バックエンドサービスへ処理依頼
バックエンドサービス → 処理実行
Frontend Service ← 処理結果を受信
Frontend Service → Supabaseへ保存リクエスト
```

### PlantUML既知の制限と回避策
| 制限 | 回避策 |
|------|--------|
| switch内のスイムレーン変更 | 同一スイムレーン内に収める |
| note内の`@startuml`文字列 | 別の表現に置き換え |
| 条件分岐でスイムレーンをまたぐ | 概要図+詳細図に分割 |

## 作成した図表
1. **3.6 概要図** - 保存/エクスポート/編集継続の分岐（手動保存のみ）
2. **3.6.1.1 PlantUML保存フロー** - 13ステップ、プレビューSVG生成含む
3. **3.6.1.2 Excalidraw保存フロー** - 9ステップ
4. **3.6.2.1 PlantUMLエクスポートフロー** - 7ステップ
5. **3.6.2.2 Excalidrawエクスポートフロー** - 7ステップ

## 技術仕様
| 項目 | PlantUML | Excalidraw |
|------|---------|-----------|
| PNG生成 | node-plantuml | Excalidraw exportToBlob |
| SVG生成 | node-plantuml | Excalidraw exportToSvg |
| PDF生成 | SVG→PDF変換 | SVG→PDF変換 |
| バージョン管理 | SHA-256ハッシュ | なし |
| 用語一貫性チェック | ✅ 対応 | ❌ 非対応（ビジュアル図表のため） |

## 業務フロー図 進捗更新
- 3.6 保存・エクスポートフロー: ✅ 完了
- 業務フロー図 進捗: 6/10 完了（60%）

## Git コミット

- コミット: `46ae4f7`
- 内容: docs: 3.6保存・エクスポートフロー完成、整合性チェック実施
- プッシュ: master → origin/master

## 参照ドキュメント
- `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md` セクション3.6
- `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md` UC 3-5, 3-6
