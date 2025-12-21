# シーケンス図作成セッション

**作成日**: 2025-12-21
**用途**: ユーザーがこのファイルと `active_context.md` を渡した時、Claudeが従うべきプロセス

---

## 0. 必読ファイル（最初に読むこと）

**このファイルを受け取ったら、以下の順序でファイルを読むこと。**

| 順序 | ファイル | 目的 |
|:----:|---------|------|
| 1 | `CLAUDE.md` | プロジェクトルール、技術仕様、禁止事項 |
| 2 | `docs/context/active_context.md` | 現在の進捗、次のタスク |
| 3 | 本ファイル（§1以降） | シーケンス図作成プロセス |

---

## 1. 作業開始前の確認（必須）

### 1.1 自動開始禁止

**作業を自動開始してはならない。**

以下の情報をユーザーに提示し、**承認を得てから**作業を開始すること。

### 1.2 ユーザーへの確認内容

```
次に作成するシーケンス図を提案します。

**対象UC**: UC X-X（〇〇）
**参照ドキュメント**:
  - 業務フロー図: §X.X
  - 機能一覧表: F-XXX-XX
  - クラス図: XxxService, XxxRepository

**UC固有分析結果**:
  - DP-001（レジリエンス）: [適用/不要]
  - DP-002（デバウンス）: [適用/不要]
  - DP-004（レート制限）: [適用/不要]
  - DP-005（監査ログ）: [適用/不要]

作業を開始してよいですか？
```

### 1.3 承認後のみ作業開始

ユーザーから「はい」「OK」「開始して」等の承認を得てから、§2以降に進むこと。

---

## 2. 作業単位

### 2.1 1セッション = 1UC

- **1回のセッションで作成するのは1UCのみ**
- 複数UCを連続で作成しない
- 完了後は報告して待機

### 2.2 完了報告

1UC完了後、以下を報告すること：

```
**完了報告**

- 作成したUC: UC X-X（〇〇）
- SVG: docs/proposals/diagrams/08_sequence/X_X_Xxx.svg
- 統合版: 08_シーケンス図_20251214.md §X に追記済み
- Evidence: docs/evidence/yyyyMMdd_HHmm_sequence_xxx/

次のUCに進みますか？
```

---

## 3. 作業手順

### Step 1: 参照ドキュメント確認

`01_Reference_Guide.md` §2 で対象UCの重点参照先を確認し、以下を読む：

- 業務フロー図（該当セクション）
- 機能一覧表（該当機能ID）
- クラス図（使用するService/Repository）
- 技術決定（該当TD）

### Step 2: UC固有分析（LL-027）

`Design_Pattern_Checklist.md` を参照し、以下を判断：

| # | 質問 | 適用パターン |
|:-:|------|-------------|
| 1 | 外部APIを呼び出すか？ | DP-001（タイムアウト・リトライ・503） |
| 2 | ユーザー入力がリアルタイムか？ | DP-002（デバウンス300ms） |
| 3 | 同一リクエストが繰り返されるか？ | DP-003（キャッシュ）検討 |
| 4 | 高頻度呼び出しが想定されるか？ | DP-004（レート制限） |
| 5 | 権限変更・データ削除があるか？ | DP-005（監査ログ） |

### Step 3: Evidence作成

```powershell
# 現在時刻を確認
Get-Date -Format "yyyyMMdd_HHmm"

# Evidenceディレクトリ作成
pwsh scripts/create_evidence.ps1 <yyyyMMdd_HHmm>_sequence_<uc_name>
```

### Step 4: Todoリスト作成

`TodoWrite`ツールで以下を登録：

```
1. 関連ドキュメント確認（業務フロー図、機能一覧表、クラス図）
2. Context7でPlantUML仕様確認
3. PlantUMLコード作成
4. PNG生成・5パスレビュー
5. レビューログ更新
6. SVG生成・統合版追記
7. active_context.md更新
8. SERENA Memory保存
9. Git commit
```

### Step 5: コード作成

`02_Authoring_Guide.md` のチェックリストに従う：

- [ ] Repository Pattern遵守
- [ ] 初期読込シーケンス明示
- [ ] 参加者命名規則
- [ ] エラーハンドリング網羅（400/401/403/404/409/500/503）
- [ ] alt/else状態追跡（LL-025）

### Step 6: 5パスレビュー

| Pass | 対象 | 確認内容 |
|:----:|------|---------|
| 1 | 構造 | participant、alt/loop/optの対応 |
| 2 | 接続 | activate/deactivate、矢印の整合性 |
| 3 | 内容 | メッセージテキスト、note内容 |
| 4 | スタイル | skinparam、色、フォント |
| 5 | 設計パターン | DP-001〜006の適用確認 |

### Step 7: 成果物保存

1. SVG生成（-Publish）
2. 統合版（08_シーケンス図_*.md）に追記
3. active_context.md更新
4. SERENA Memory保存
5. Git commit

---

## 4. 参照ドキュメント一覧

### ガイドライン

| ドキュメント | パス | 用途 |
|-------------|------|------|
| Reference Guide | `docs/guides/sequence_diagram/01_Reference_Guide.md` | UC別参照先 |
| Authoring Guide | `docs/guides/sequence_diagram/02_Authoring_Guide.md` | コードパターン |
| Design Pattern | `docs/guides/sequence_diagram/Design_Pattern_Checklist.md` | DP-001〜006 |
| 知見ベース | `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` | LL-001〜027 |
| パターン集 | `docs/guides/sequence_diagram/Sequence_Diagram_Patterns.md` | NL-001〜007 |
| 憲法 | `docs/guides/PlantUML_Development_Constitution.md` | 禁止事項、5パスレビュー |

### 設計仕様

| ドキュメント | パス |
|-------------|------|
| 業務フロー図 | `docs/proposals/03_業務フロー図_20251201.md` |
| 機能一覧表 | `docs/proposals/05_機能一覧表_20251213.md` |
| クラス図 | `docs/proposals/06_クラス図_20251208.md` |
| CRUD表 | `docs/proposals/07_CRUD表_20251213.md` |
| シーケンス図統合版 | `docs/proposals/08_シーケンス図_20251214.md` |
| 技術決定 | `docs/context/technical_decisions.md` |

---

## 5. 完了条件チェックリスト

- [ ] 5パスレビュー通過
- [ ] SVG正式版保存
- [ ] 統合版に追記
- [ ] Evidence 3点セット完成
- [ ] active_context.md更新
- [ ] SERENA Memory保存
- [ ] Git commit

---

## 更新履歴

| 日付 | 内容 |
|------|------|
| 2025-12-21 | 初版作成 |
