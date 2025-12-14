
# セッション引継ぎ資料: 機能一覧表 非エンジニア向け改訂 Phase 2開始

**作成日時**: 2025-12-13 19:32
**前セッション完了**: 戦術書v3.5 100点達成
**次セッション目標**: Phase 2-5 機能一覧表の実改訂

---

## 1. 現在の状況サマリ

### 完了済み

| 項目 | 状態 | 成果物 |
|------|:----:|--------|
| Phase 1: 戦術書作成 | ✅ | instructions.md v3.5（100点A+） |
| 用語集（Tier 1） | ✅ | glossary_tier1.md（15語） |
| 3層構造テンプレート | ✅ | template_3layer.md |
| サンプル改訂（F-AUTH-01） | ✅ | sample_F-AUTH-01_nonengineer.md（86点A） |
| 評価基準確立 | ✅ | 7項目100点満点 |

### 未完了（次セッションで実行）

| Phase | 作業内容 | 対象機能数 | 見積時間 |
|:-----:|---------|:----------:|:--------:|
| 2 | Part 0（読み方ガイド + 用語集）追加 | - | 30分 |
| 3 | F-AUTH改訂 | 2機能 | 40分 |
| 4-1 | MVP機能改訂 | 22機能 | 5.5時間 |
| 4-2 | Phase 2機能改訂 | 8機能 | 2時間 |
| 5 | 品質評価・最終調整 | - | 1時間 |

**合計見積**: 約10時間（複数セッションに分割可能）

---

## 2. 必読ドキュメント（優先順）

### 最重要（作業開始前に必ず読む）

| # | ファイル | 内容 | 読む理由 |
|:-:|---------|------|---------|
| 1 | `docs/evidence/20251213_1535_function_list_nonengineer_revision/instructions.md` | **戦術書v3.5** | 全作業手順が記載 |
| 2 | `docs/evidence/20251213_1535_function_list_nonengineer_revision/sample_F-AUTH-01_nonengineer.md` | サンプル改訂版 | 完成形のイメージ |
| 3 | `docs/evidence/20251213_1535_function_list_nonengineer_revision/glossary_tier1.md` | 用語集 | 用語変換の参照 |

### 参照用（作業中に必要に応じて）

| # | ファイル | 内容 |
|:-:|---------|------|
| 4 | `docs/evidence/20251213_1535_function_list_nonengineer_revision/template_3layer.md` | テンプレート |
| 5 | `docs/evidence/20251213_0255_function_list_revision/revised_function_list_v2.md` | ベースファイル（v2.0） |
| 6 | `docs/proposals/PlantUML_Studio_機能一覧表_20251213.md` | 現行版（v1.8） |

---

## 3. 作業開始手順（Step 0から順に実行）

### Step 0: 環境確認（必須）

```powershell
# 1. 入力ファイル4点の存在確認
$inputFiles = @(
    "docs/evidence/20251213_1535_function_list_nonengineer_revision/glossary_tier1.md",
    "docs/evidence/20251213_1535_function_list_nonengineer_revision/template_3layer.md",
    "docs/evidence/20251213_1535_function_list_nonengineer_revision/sample_F-AUTH-01_nonengineer.md",
    "docs/proposals/PlantUML_Studio_機能一覧表_20251213.md"
)

foreach ($file in $inputFiles) {
    if (Test-Path $file) {
        Write-Host "✅ 存在: $file"
    } else {
        Write-Host "❌ 不在: $file" -ForegroundColor Red
    }
}

# 2. v2.0ベースファイルの確認
$v2Path = "docs/evidence/20251213_0255_function_list_revision/revised_function_list_v2.md"
if (Test-Path $v2Path) {
    Write-Host "✅ v2.0ベースファイル存在"
    $lineCount = (Get-Content $v2Path).Count
    Write-Host "   行数: $lineCount"
} else {
    Write-Host "❌ v2.0ベースファイルなし - 作業不可" -ForegroundColor Red
}
```

### Step 1: バックアップ作成

```powershell
# v1.8をバックアップ
Copy-Item "docs/proposals/PlantUML_Studio_機能一覧表_20251213.md" `
          "docs/proposals/PlantUML_Studio_機能一覧表_20251213_v1.8_backup.md"
Write-Host "✅ バックアップ作成完了"
```

### Step 2: v2.0をベースにコピー

```powershell
# v2.0をコピーして作業開始
Copy-Item "docs/evidence/20251213_0255_function_list_revision/revised_function_list_v2.md" `
          "docs/proposals/PlantUML_Studio_機能一覧表_20251213.md" -Force
Write-Host "✅ v2.0をベースにコピー完了"
```

### Step 3: 進捗ファイル作成

```powershell
# progress.md テンプレート生成（戦術書§5.3.1参照）
# ※ 戦術書内のPowerShellコードをそのまま実行
```

---

## 4. Phase別作業詳細

### Phase 2: Part 0追加（30分）

**作業内容**: 機能一覧表の冒頭（タイトルとPart 1の間）にPart 0を挿入

**挿入内容**: 戦術書§7.0のテンプレートをそのまま使用
- 対象読者
- アイコンの意味
- 用語集（15語）

**確認コマンド**:
```powershell
(Get-Content "docs/proposals/PlantUML_Studio_機能一覧表_20251213.md" -Raw) -match '## Part 0:'
# True → 成功
```

### Phase 3: F-AUTH改訂（40分）

| 機能ID | 機能名 | 参照サンプル |
|--------|--------|-------------|
| F-AUTH-01 | ログイン | `sample_F-AUTH-01_nonengineer.md`をそのまま使用可能 |
| F-AUTH-02 | ログアウト | サンプルを参考に新規作成 |

**1機能あたりの作業**:
1. 概要セクション書き換え（5分）
2. 操作フロー簡略化（5分）
3. エラーメッセージ日本語化（3分）
4. 技術詳細のCallout化（2分）

### Phase 4-1: MVP機能改訂（5.5時間）

| カテゴリ | 機能数 | 機能ID |
|---------|:------:|--------|
| F-PRJ | 4 | F-PRJ-01〜04 |
| F-DGM（MVP） | 7 | F-DGM-01〜06, 09 |
| F-AI | 2 | F-AI-01, 02 |
| F-ADM（MVP） | 9 | F-ADM-01〜08, 13 |

**推奨作業順序**:
1. F-PRJ-01〜04（プロジェクト管理）
2. F-DGM-01〜06（図表操作・基本）
3. F-DGM-09（図表削除）
4. F-AI-01〜02（AI機能）
5. F-ADM-01〜08, 13（管理機能）

### Phase 4-2: Phase 2機能改訂（2時間）

| カテゴリ | 機能数 | 機能ID |
|---------|:------:|--------|
| F-DGM（Ph2） | 4 | F-DGM-07, 08, 10, 11 |
| F-ADM（Ph2） | 4 | F-ADM-09〜12 |

### Phase 5: 品質評価・最終調整（1時間）

**評価コマンド（戦術書§8.3参照）**:
```powershell
$file = "docs/proposals/PlantUML_Studio_機能一覧表_20251213.md"

# 条件1: 3層構造（📌）
$pinCount = (Select-String -Path $file -Pattern '##### 📌' -AllMatches).Matches.Count
Write-Host "📌 概要セクション: $pinCount / 32"

# 条件2: Callout
$calloutCount = (Select-String -Path $file -Pattern '> \[!note\]-' -AllMatches).Matches.Count
Write-Host "📘 技術詳細Callout: $calloutCount / 32"

# 条件3: Mermaid図
$mermaidCount = (Select-String -Path $file -Pattern '```mermaid' -AllMatches).Matches.Count
Write-Host "🎬 Mermaid図: $mermaidCount / 32"

# 条件4: 💡tip
$tipCount = (Select-String -Path $file -Pattern '> \[!tip\]' -AllMatches).Matches.Count
Write-Host "💡 tip Callout: $tipCount / 32"
```

---

## 5. 重要な注意事項

### 絶対に守ること

| # | ルール | 理由 |
|:-:|--------|------|
| 1 | **v2.0をベースに作業** | 3層構造が適用済み |
| 2 | **技術詳細は削除しない** | エンジニア向け情報の保持 |
| 3 | **各機能完了ごとにgit commit** | 進捗喪失防止 |
| 4 | **バックアップは作業完了まで保持** | ロールバック用 |
| 5 | **戦術書（instructions.md）は編集しない** | 進捗はprogress.mdに記録 |

### コミットメッセージ形式

```bash
# 機能単位
git commit -m "docs: F-AUTH-01 非エンジニア向け改訂"

# Phase完了時
git commit -m "docs: Phase 3 完了 - F-AUTH 2機能改訂"
git tag function-list-v3.0-phase3
```

### 問題発生時

| 状況 | 対処 |
|------|------|
| 1機能の改訂を取り消したい | `git checkout -- ファイル` |
| Phase全体を取り消したい | `git checkout function-list-v3.0-phaseN -- ファイル` |
| 最初からやり直したい | バックアップから復元 |

---

## 6. 進捗管理

### 進捗ファイル

```
docs/evidence/20251213_1535_function_list_nonengineer_revision/progress.md
```

**更新タイミング**: 各機能の改訂完了時に `☐` → `✅` に変更

### 進捗確認コマンド

```powershell
$progressPath = "docs/evidence/20251213_1535_function_list_nonengineer_revision/progress.md"
$completed = (Get-Content $progressPath | Select-String -Pattern "✅" -AllMatches).Matches.Count
Write-Host "完了: $completed / 32 機能"
```

---

## 7. セッション分割ガイド

1セッションで全Phase完了が難しい場合の分割案:

| セッション | Phase | 作業内容 | 見積 |
|:----------:|:-----:|---------|:----:|
| **次セッション** | 2-3 | Part 0追加 + F-AUTH 2機能 | 1.5h |
| セッション2 | 4-1前半 | F-PRJ 4機能 + F-DGM 7機能 | 3h |
| セッション3 | 4-1後半 | F-AI 2機能 + F-ADM MVP 9機能 | 3h |
| セッション4 | 4-2, 5 | Phase 2機能 8機能 + 最終調整 | 3h |

**セッション間の引継ぎ**:
- progress.mdで完了状況を確認
- git logで最後のコミットを確認
- 中断した機能から再開

---

## 8. 関連ファイルパス一覧

### Evidence（作業用）

```
docs/evidence/20251213_1535_function_list_nonengineer_revision/
├── instructions.md          ★ 戦術書v3.5（必読）
├── glossary_tier1.md        用語集
├── template_3layer.md       テンプレート
├── sample_F-AUTH-01_nonengineer.md  サンプル
├── evaluation_sample_F-AUTH-01.md   サンプル評価
├── work_sheet.md            作業完了報告
├── 00_raw_notes.md          作業ログ
└── progress.md              ★ 進捗トラッキング（作業開始時に作成）
```

### 入力ファイル

```
docs/proposals/PlantUML_Studio_機能一覧表_20251213.md          現行版（v1.8）
docs/evidence/20251213_0255_function_list_revision/revised_function_list_v2.md  ベース（v2.0）
```

### 出力ファイル

```
docs/proposals/PlantUML_Studio_機能一覧表_20251213.md          改訂版（v3.0）
```

---

## 9. クイックスタート（次セッション開始時）

```
1. この引継ぎ資料を読む
2. 戦術書（instructions.md）を読む（特に§3.3, §7）
3. Step 0-2を実行（環境確認、バックアップ、v2.0コピー）
4. progress.mdを作成
5. Phase 2開始（Part 0追加）
6. Phase 3開始（F-AUTH-01, 02改訂）
7. 各機能完了ごとにgit commit
```

---

**作成者**: Claude Code (Opus 4.5)
**次セッション開始可能状態**: ✅ 準備完了
