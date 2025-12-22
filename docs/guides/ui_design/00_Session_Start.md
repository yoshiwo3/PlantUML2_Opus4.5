# UI設計図表作成セッション

**作成日**: 2025-12-22
**用途**: ユーザーがこのファイルと `active_context.md` を渡した時、Claudeが従うべきプロセス

---

## 0. 必読ファイル（最初に読むこと）

**このファイルを受け取ったら、以下の順序でファイルを読むこと。**

| 順序 | ファイル | 目的 |
|:----:|---------|------|
| 1 | `CLAUDE.md` | プロジェクトルール、技術仕様、禁止事項 |
| 2 | `docs/context/active_context.md` | 現在の進捗、次のタスク |
| 3 | 本ファイル（§1以降） | UI設計図表作成プロセス |

---

## 1. 作業開始前の確認（必須）

### 1.1 自動開始禁止

**作業を自動開始してはならない。**

以下の情報をユーザーに提示し、**承認を得てから**作業を開始すること。

### 1.2 ユーザーへの確認内容

```
次に作成するUI設計図表を提案します。

**対象画面**: XX画面（カテゴリ: auth/main/modal）
**関連UC**: UC X-X（〇〇）
**参照ドキュメント**:
  - UC図: §X
  - 業務フロー図: §X.X
  - 機能一覧表: F-XXX-XX

**TD-015準拠確認**:
  - 低精度（Low-Fidelity）: [確認済み]
  - 手書き風: [確認済み]
  - グレースケール: [確認済み]

作業を開始してよいですか？
```

### 1.3 承認後のみ作業開始

ユーザーから「はい」「OK」「開始して」等の承認を得てから、§2以降に進むこと。

---

## 2. 作業単位

### 2.1 1セッション = 1画面セット

- **1回のセッションで作成するのは1画面セット（ワイヤーフレーム + 遷移図更新）**
- 複数画面を連続で作成しない
- 完了後は報告して待機

### 2.2 完了報告

1画面セット完了後、以下を報告すること：

```
**完了報告**

- 作成した画面: XX画面（NN_xxx.excalidraw）
- ワイヤーフレームSVG: docs/proposals/diagrams/10_wireframe/NN_xxx.svg
- 遷移図更新: [更新した/更新不要]
- Evidence: docs/evidence/yyyyMMdd_HHmm_ui_design_xxx/

**評価結果**:
- Phase 1-A（ワイヤーフレーム）: XX点
- Phase 1-B（遷移図）: XX点（該当時）

次の画面に進みますか？
```

---

## 3. 作業手順

### Step 1: 参照ドキュメント確認

`01_Reference_Guide.md` §2 で対象画面の参照先を確認し、以下を読む：

- UC図（該当セクション）
- 業務フロー図（該当セクション）
- 機能一覧表（該当機能ID）
- 既存ワイヤーフレーム（スタイル参照）

### Step 2: 画面一覧確認（憲法 §1.3.7）

- 画面一覧テンプレートで対象画面を確認
- 対応UC・業務フロー整合性テーブルを確認
- 3点対比（画面一覧↔ワイヤーフレーム↔遷移図ノード）を意識

### Step 3: Evidence作成

```powershell
# 現在時刻を確認
Get-Date -Format "yyyyMMdd_HHmm"

# Evidenceディレクトリ作成
pwsh scripts/create_evidence.ps1 <yyyyMMdd_HHmm>_ui_design_<screen_name>
```

### Step 4: Todoリスト作成

`TodoWrite`ツールで以下を登録：

```
1. 関連ドキュメント確認（UC図、業務フロー図、機能一覧表）
2. TD-015原則確認
3. ワイヤーフレーム作成（Excalidraw）
4. PNG/SVGエクスポート
5. Phase 1-Aレビュー・採点（90点以上）
6. 画面遷移図更新（必要時）
7. Phase 1-Bレビュー・採点（90点以上）
8. active_context.md更新
9. SERENA Memory保存
10. Git commit
```

### Step 5: ワイヤーフレーム作成

`02_Authoring_Guide.md` のチェックリストに従う：

- [ ] TD-015原則遵守（低精度、手書き風、グレースケール）
- [ ] 命名規則遵守（NN_category_screen_name.excalidraw）
- [ ] UI要素配置（UC/業務フロー図に基づく）
- [ ] アクセシビリティ考慮（憲法 §8）

### Step 6: 5パスレビュー

| Pass | 対象 | 確認内容 |
|:----:|------|---------|
| 1 | TD-015準拠 | 低精度、手書き風、グレースケール |
| 2 | 網羅性 | 画面一覧チェックリスト照合 |
| 3 | UI要素 | UC図・業務フロー図と照合 |
| 4 | 過剰詳細 | 「やりすぎ」チェック（憲法 §3.4） |
| 5 | 整合性 | 他画面との一貫性 |

### Step 7: 成果物保存

1. PNG/SVGエクスポート
2. 正式版SVG保存（`docs/proposals/diagrams/10_wireframe/`）
3. 画面遷移図更新（該当時）
4. active_context.md更新
5. SERENA Memory保存
6. Git commit

---

## 4. 参照ドキュメント一覧

### ガイドライン

| ドキュメント | パス | 用途 |
|-------------|------|------|
| Reference Guide | `docs/guides/ui_design/01_Reference_Guide.md` | 画面別参照先 |
| Authoring Guide | `docs/guides/ui_design/02_Authoring_Guide.md` | 作成ガイドライン |
| Design Pattern | `docs/guides/ui_design/Design_Pattern_Checklist.md` | UIパターン確認 |
| 知見ベース | `docs/guides/ui_design/UI_Design_Knowledge_Base.md` | EX/SD/TD/IC知見 |
| パターン集 | `docs/guides/ui_design/UI_Design_Patterns.md` | 実装パターン |
| 憲法 | `docs/guides/ui_design/UI_Design_Constitution.md` | 禁止事項、評価基準 |

### 設計仕様

| ドキュメント | パス |
|-------------|------|
| UC図 | `docs/proposals/02_ユースケース図_20251130.md` |
| 業務フロー図 | `docs/proposals/03_業務フロー図_20251201.md` |
| 機能一覧表 | `docs/proposals/05_機能一覧表_20251213.md` |
| 技術決定 | `docs/context/technical_decisions.md` |

---

## 5. 完了条件チェックリスト

- [ ] 5パスレビュー通過
- [ ] Phase 1-A採点 90点以上
- [ ] SVG正式版保存
- [ ] 画面遷移図更新（該当時）
- [ ] Phase 1-B採点 90点以上（該当時）
- [ ] Evidence 3点セット完成
- [ ] active_context.md更新
- [ ] SERENA Memory保存
- [ ] Git commit

---

## 更新履歴

| 日付 | 内容 |
|------|------|
| 2025-12-22 | 初版作成 |
