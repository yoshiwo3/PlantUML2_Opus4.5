# Raw Notes: validate_plantuml.ps1 機能拡張

## 作業ログ

### 1. 初期要件確認
- ユーザー要求: PNG対応オプション追加
- ガイドドキュメント確認: `docs/guides/PlantUML_SVG_Generation_Guide.md`
- 現行スクリプト確認: `scripts/validate_plantuml.ps1`

### 2. 設計議論

#### 問題点の整理
| # | 問題 | 影響 |
|:-:|------|------|
| 1 | Step 3とStep 5で2回手動実行が必要 | 手間、忘れるリスク |
| 2 | レビュー用PNGと正式版SVGの紐付けがない | 別ファイルをレビューしたまま保存する可能性 |
| 3 | レビューOK判定が人間依存 | スクリプトはレビュー結果を知らない |

#### 対策案検討
- 問題2: タイムスタンプ検証 → ハッシュ検証に変更
- 問題3: 確認プロンプト → レビューログ必須に決定

#### レビューログ設計
- ファイル形式: JSON（.review.json）
- 構造: current（現在のレビュー）+ history（履歴）
- 検証項目: status=completed、ハッシュ一致

### 3. 実装

#### スクリプト変更
- パラメータ: -Review, -Publish追加（-Format, -OutputToProposals削除）
- 関数追加:
  - Get-FileHashValue: SHA256ハッシュ計算（先頭16文字）
  - Get-ReviewLogPath: レビューログパス取得
  - New-ReviewLog: レビューログ生成/更新
  - Test-ReviewLog: レビューログ検証

#### ガイドドキュメント更新
- 必須フロー図更新（レビューログ追加）
- Step 3: PNG生成 + レビューログ生成
- Step 5: レビューログ更新（新設）
- Step 6: 正式版SVG保存（旧Step 5から変更）
- 禁止事項追加（レビューログ関連）
- スクリプトリファレンス更新
- 変更履歴: v3.0

### 4. 完了確認
- スクリプト: 正常に更新完了
- ガイド: v3.0として更新完了
