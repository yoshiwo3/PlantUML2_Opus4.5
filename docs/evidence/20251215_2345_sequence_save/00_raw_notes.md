# Raw Notes: UC 3-5 保存シーケンス図作成

## 2025-12-15 23:45 - セッション開始

### 前セッションからの引継ぎ
- UC 3-3/3-4完了済み（work_sheet確認）
- 次タスク: UC 3-5 保存

### 要件確認

#### 業務フロー図 § 3.6.1.1 PlantUML保存フロー
- Step 1: 「保存」クリック（Ctrl+S / ボタン）
- Step 2: 現在のソースコード取得
- Step 3: PlantUML構文検証
- Step 4: プレビューSVG生成
- Step 5: ファイル保存（Storage）
- Step 6: 用語チェック（AI）- タイムアウト時は保存継続
- Step 7: 保存完了通知

#### TD-006 Storage Only構成
```
/{user_id}/{project_name}/
  ├── {diagram_name}.puml
  └── {diagram_name}.preview.svg
```

#### TD-007 AI機能構成
- 用語チェック: OpenRouter API経由
- タイムアウト時: 保存は成功扱い

#### シーケンス図作成ガイドライン
1. Repository Pattern遵守
2. 初期読込シーケンス明示
3. 参加者命名規則
4. エラーハンドリング網羅
5. §5技術仕様への追記
6. PlantUMLコード構造
7. チェックリスト

---

## 2025-12-15 23:50 - PlantUMLコード作成

### 作成ファイル
- `sequence_save.puml`

### 設計ポイント
1. **初期読込シーケンス**: 図表を開く→編集→保存の流れを明示
2. **Repository Pattern**: DiagramService → DiagramRepo → Storage
3. **エラーハンドリング**:
   - 400: 構文エラー
   - 500: Storage書き込み失敗
4. **用語チェック**: 非同期処理、3分岐（タイムアウト/不一致/OK）

### PNG生成
- `PlantUML_Studio_Sequence_Save.png` 生成成功

---

## 2025-12-15 23:51 - 4パス視覚的レビュー

### Pass 1: 構造確認
- [x] 参加者（9名）: User, Browser, APIRoutes, DiagramService, ValidationService, PlantUMLService, AIService, DiagramRepo, Storage
- [x] フェーズ区切り: 図表を開く、編集→保存、構文検証、ファイル保存、用語チェック
- [x] activate/deactivate対応

### Pass 2: 接続確認（シーケンス図用）
- [x] 矢印の方向
- [x] alt分岐内のdeactivate
- [x] アクティブバー終端

### Pass 3: 内容確認
- [x] メッセージラベル
- [x] note内容
- [x] エラーメッセージ

### Pass 4: スタイル確認
- [x] skinparam適用
- [x] 色分け
- [x] note配置

---

## 2025-12-16 00:20 - 偽陽性レビュー #1

### 状況
- review.json: `status: completed`, `pass5_activation_bars: true`
- 「All activation bars verified」と記録

### ユーザー指摘
> 「else分岐にアクティブバーがない」

### 原因分析
- else分岐のBrowser→Userメッセージで始点のバーが描画されていない
- LL-001発見: else分岐はALT開始時点の状態を継承

---

## 2025-12-16 00:34 - 偽陽性レビュー #2

### 状況
- メッセージチェック表で「50メッセージ全確認」

### ユーザー指摘
> 「最後の2メッセージにアクティブバーがない！！」

### 原因分析
- LL-012発見: アクティブバー描画 = active状態 ∧ 視覚的トリガー
- 状態はactiveでも視覚的トリガーがなければ描画されない

---

## 2025-12-16 00:48〜01:17 - 修正サイクル

### 試行1: note追加
- ユーザー指摘: 「ノートではダメです」
- LL-009発見: noteはアンカーにならない

### 試行2: Self-message追加
- 問題: 余計なメッセージが表示される
- LL-007記録: Self-message Anchorパターン

### 試行3: hidden arrow ++
- エラー: "Cannot activate Browser"
- LL-001 + LL-008組み合わせ問題発見

### 試行4: hidden arrow（++なし）
- ユーザー指摘: 「else分岐のアクティブバーがまだない」

---

## 2025-12-17 09:01 - 最終修正

### 修正内容
- `Browser -[hidden]-> Browser`（++なし）を適用
- 各分岐終端で`--`ショートカットを使用

### ユーザー承認
- ✅ 最終版承認

---

## 2025-12-17 09:20 - SVG Publish

### 成果物
- `docs/proposals/diagrams/08_sequence/PlantUML_Studio_Sequence_Save.svg`

---

## 2025-12-17 10:00〜11:30 - 知見ドキュメント化

### work_sheet.md更新
- LL-001〜LL-024（アクティブバー知見24項目）
- LL-017〜LL-020（PNG視覚レビュー方法論の失敗分析）
- 教訓サマリー

### SERENA Memory
- `session_20251217_sequence_save_lessons_learned.md` 作成

---

## 2025-12-17 15:17〜15:25 - 知見統合（本日の作業）

### claude ops確認（docs/guides）
| 時刻 | ツール | ファイル | 変更タイプ |
|------|--------|---------|-----------|
| 15:17:05 | Write | `Sequence_Diagram_Knowledge_Integration_Strategy.md` | create |
| 15:22:33 | Write | `sequence_diagram/Activation_Bar_Knowledge_Base.md` | create |
| 15:24:04 | Write | `sequence_diagram/Sequence_Diagram_Patterns.md` | create |
| 15:24:23 | Edit | `PlantUML_Development_Constitution.md` | update |
| 15:24:34 | Edit | `PlantUML_Development_Constitution.md` | update |
| 15:24:47 | Edit | `Sequence_Diagram_Authoring_Guide.md` | update |

### 作成ファイル
1. **戦略ドキュメント**: `docs/guides/Sequence_Diagram_Knowledge_Integration_Strategy.md`
2. **アクティブバー知見ベース**: `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md`（LL-001〜LL-024）
3. **パターン集**: `docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md`（NL-001〜NL-007）

### 更新ファイル（最小限の追加）
- **PlantUML_Development_Constitution.md**: +5行（関連ドキュメント表+2、§3.2末尾+3）
- **Sequence_Diagram_Authoring_Guide.md**: +1行（§8末尾）

### 制約遵守
- Constitution既存テキスト: **変更なし**（追加のみ）
- プロンプトチューニング済み文書の安定性維持

---

## 作業統計（claude ops集計）

### Evidence全体（2025-12-15〜17）
| 対象 | 操作数 | 備考 |
|------|:------:|------|
| sequence_save.puml | 47+ | 編集 |
| work_sheet.md | 30+ | 編集 |
| sequence_save.review.json | 22+ | 更新 |
| **合計** | **108+** | hasMore=true |

### 偽陽性レビュー統計
| 回 | 判定 | 実態 | ユーザー発見 |
|:-:|:---:|:---:|-------------|
| 1 | ✅ | ❌ | else分岐バー欠落 |
| 2 | ✅ | ❌ | 最後2メッセージ欠落 |
| 3 | ✅ | ❌ | Storage errorパス欠落 |
| 4 | ✅ | ❌ | noteアンカー失敗 |
| 5 | ✅ | ❌ | self-message余分表示 |
| 6 | ✅ | ❌ | hidden arrow++エラー |
| **7** | **✅** | **✅** | **承認** |

---

## 知見総括

### アクティブバー関連（LL-001〜LL-024）
- **基本原則**: LL-001〜LL-003
- **構文・パターン**: LL-004〜LL-008（hidden arrow推奨）
- **制限・原則**: LL-009〜LL-012（状態vs描画）
- **レビュー方法論失敗**: LL-017〜LL-020
- **追加知見**: LL-021〜LL-024

### 非アクティブバー関連（NL-001〜NL-007）
- skinparam設定、participant宣言、フェーズ区切り、note配置、矢印タイプ

### 最重要知見
1. **LL-008**: Hidden Arrowアンカー（`++`なし）
2. **LL-012**: アクティブバー描画 = active ∧ 視覚的トリガー
3. **LL-018**: 終端部確認不足（逆順確認推奨）
4. **LL-019**: 否定的証拠探索（「バーがないのはどれ？」）

---

## 参照ファイル

| ファイル | 役割 |
|---------|------|
| `work_sheet.md` | 詳細版知見ドキュメント（31項目） |
| `sequence_save.puml` | ソースコード（最終版） |
| `sequence_save.review.json` | レビューログ（履歴含む） |
| `.serena/memories/session_20251217_sequence_save_lessons_learned.md` | SERENA Memory |
| `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` | 正式版知見ベース |
| `docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md` | 正式版パターン集 |
