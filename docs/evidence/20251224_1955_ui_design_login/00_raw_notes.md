# 作業メモ（完全版 v2.0 - diff詳細付き）

**データソース**: Claude Ops MCP（ファイル変更履歴・Bash履歴）
**総操作数**: 96件（ファイル変更65件 + Bash 31件）
**本ドキュメント特徴**: 各操作のdiff詳細、作成ファイル内容、技術仕様を完全記録

---

## 2025-12-24（セッション1）3操作

### 19:55 プロジェクト初期化

| # | 時刻 | 操作 | 詳細 |
|:-:|------|------|------|
| 1 | 19:55:03 | Bash | `Get-Date -Format 'yyyyMMdd_HHmm'` |
| 2 | 19:55:22 | Bash | `create_evidence.ps1 20251224_1955_ui_design_login` |
| 3 | 19:56:41 | Write | `wireframes/01_login.excalidraw` 作成 |

**#3 詳細: 01_login.excalidraw 初期作成**

```
作成内容:
- OAuth認証ボタン（GitHub, Google）配置
- TD-015原則準拠（グレースケール、手書き風）
- roughness: 1（手書き風）
- strokeStyle: solid
- 背景色: #ffffff（白）
- 枠線色: #1e1e1e（黒）
```

---

## 2025-12-25（セッション1.5）9操作

### 08:08〜08:09 画面遷移図・ガイドドキュメント更新

| # | 時刻 | 操作 | ファイル | diff詳細 |
|:-:|------|------|---------|---------|
| 4 | 08:08:21 | Edit | `99_screen_transition.puml` | バージョン 1.0 → 1.1（OAuth-only設計対応）|
| 5 | 08:08:22 | Edit | `02_Authoring_Guide.md` | 作成日追加 |
| 6 | 08:08:24 | Edit | `UI_Design_Constitution.md` | 更新1 |
| 7 | 08:08:25 | Edit | `UI_Design_Constitution.md` | 更新2 |
| 8 | 08:08:27 | Edit | `UI_Design_Patterns.md` | 更新1 |
| 9 | 08:08:29 | Edit | `UI_Design_Patterns.md` | 更新2 |
| 10 | 08:08:34 | Edit | `UI_Design_Knowledge_Base.md` | 初期設定 |
| 11 | 08:09:33 | Bash | `validate_plantuml.ps1 -Review` | PNG生成確認1 |
| 12 | 08:09:49 | Bash | `validate_plantuml.ps1 -Review` | PNG生成確認2 |

**#4 diff詳細: 99_screen_transition.puml v1.0→v1.1**

```diff
-' バージョン: 1.0
+' バージョン: 1.1 (OAuth-only設計対応)
```

**変更理由**: OAuth-only認証採用により、signup/reset画面を削除

---

## 2025-12-26（セッション2）30操作

### 07:33〜07:40 画面遷移図PNG生成・更新

| # | 時刻 | 操作 | 詳細 |
|:-:|------|------|------|
| 13 | 07:33:18 | Bash | `java -jar plantuml-mit-1.2025.0.jar -tpng` |
| 14 | 07:34:07 | Bash | `dir *.png` 生成確認 |
| 15 | 07:36:43 | Bash | `java -jar plantuml-mit-1.2025.0.jar -tpng` |
| 16 | 07:36:50 | Bash | `java -jar plantuml-mit-1.2025.0.jar -tpng` |
| 17 | 07:37:14 | Bash | `java -jar plantuml-mit-1.2025.2.jar -tpng` |
| 18 | 07:40:28 | Edit | `99_screen_transition.puml` v1.1→v1.2更新開始 |
| 19 | 07:40:30 | Edit | `99_screen_transition.puml` |
| 20 | 07:40:32 | Edit | `99_screen_transition.puml` |
| 21 | 07:40:44 | Bash | `java -jar plantuml-mit-1.2025.2.jar -tpng` 最終生成 |

**#18-20 diff詳細: 99_screen_transition.puml v1.1→v1.2**

```diff
-' バージョン: 1.1 (OAuth-only設計対応)
+' バージョン: 1.2 (学習コンテンツ画面追加)
```

### 08:07 ログイン画面修正

| # | 時刻 | 操作 | 詳細 |
|:-:|------|------|------|
| 22 | 08:07:16 | Edit | `01_login.excalidraw` signup/resetリンク削除 |
| 23 | 08:07:22 | Edit | `01_login.excalidraw` OAuth-only対応完了 |

**#22-23 変更内容**:
- 「新規登録」リンク削除
- 「パスワードリセット」リンク削除
- OAuth認証ボタン（GitHub, Google）のみに

### 08:10〜08:16 active_context.md 進捗更新（12回）

| # | 時刻 | 操作 | diff詳細 |
|:-:|------|------|---------|
| 24 | 08:10:04 | Edit | 最終更新日を2025-12-27に変更、OAuth-only設計対応記載 |
| 25 | 08:10:08 | Edit | 認証画面群の画面数更新（3→1）|
| 26 | 08:10:14 | Edit | ワイヤーフレーム進捗更新 |
| 27 | 08:10:18 | Edit | 画面遷移図バージョン更新 |
| 28 | 08:10:25 | Edit | 次のステップ更新 |
| 29 | 08:10:33 | Edit | ループ改善フロー記録 |
| 30 | 08:10:38 | Edit | 評価点数記載（70点→98点）|
| 31 | 08:10:47 | Edit | 詳細説明追加 |
| 32 | 08:16:05 | Edit | ダッシュボード完成追記 |
| 33 | 08:16:13 | Edit | 構成要素詳細追加 |
| 34 | 08:16:19 | Edit | UC準拠情報追加 |
| 35 | 08:16:45 | Edit | 進捗数値更新（1/17→2/17）|

**#24 diff詳細: active_context.md 最終更新**

```diff
-**最終更新**: 2025-12-22（UI設計図表 詳細進捗セクション追加、半自動ガイド機能整備完了）
+**最終更新**: 2025-12-27（OAuth-only設計対応: signup/reset画面削除、ログインワイヤーフレーム完成）
```

**#32-35 diff詳細: ダッシュボード完成追記**

```diff
+- **#2 ダッシュボード ワイヤーフレーム完成** ✅
+  - UC 2-1〜2-4準拠、5パスレビュー100点
+  - 構成要素: ヘッダー、ユーザーメニュー、新規プロジェクトボタン、
+    プロジェクト一覧（カード形式、編集/削除ボタン付き）、
+    最近の図表（プレビュー付き3件）、
+    管理画面リンク（管理者のみ）、ログアウトボタン
+  - ワイヤーフレーム進捗: 1/17 → 2/17
```

### 08:15〜08:58 ダッシュボード画面作成

| # | 時刻 | 操作 | 詳細 |
|:-:|------|------|------|
| 36 | 08:15:10 | Write | `02_dashboard.excalidraw` v1 初期作成 |
| 37 | 08:40:11 | Write | `02_dashboard.excalidraw` v2 要素追加 |
| 38 | 08:58:32 | Write | `02_dashboard.excalidraw` v3 レイアウト調整 |

**#36-38 ダッシュボード構成要素**:

```
ヘッダー:
- PlantUML Studio ロゴ
- グローバル検索バー（Ctrl+K）
- ユーザーアバター + メニュー

メインコンテンツ:
- 「+ 新規プロジェクト」ボタン（右上）
- プロジェクト一覧（カード形式）
  - プロジェクト名
  - 説明（2行まで）
  - 図表数
  - 最終更新日
  - 編集ボタン（ペンアイコン）
  - 削除ボタン（ゴミ箱アイコン）
- 最近の図表セクション（3件）
  - プレビューサムネイル
  - ファイル名
  - 所属プロジェクト

サイドバー（管理者のみ）:
- 管理画面リンク

フッター:
- ログアウトボタン
```

---

## 2025-12-27（セッション3）54操作

### 09:03〜09:09 ダッシュボード改善・検索設計

| # | 時刻 | 操作 | 詳細 |
|:-:|------|------|------|
| 39 | 09:03:53 | Write | `02_dashboard.excalidraw` v4 検索機能追加 |
| 40 | 09:08:25 | Bash | `mkdir search_design/` |
| 41 | 09:09:48 | Write | `search_functionality_design.md` 262行 |

**#41 作成ファイル: search_functionality_design.md（262行）**

<details>
<summary>クリックで展開: 検索機能設計書 全文</summary>

```markdown
# 検索機能設計書

**作成日**: 2025-12-27
**関連UC**: UC 3-10（学習コンテンツ検索）
**関連TD**: TD-006（Storage Only MVP）、TD-007（AI機能プロバイダー構成）

## 1. 概要

### 1.1 検索対象

| 対象 | 検索可能な属性 | ユースケース |
|------|---------------|-------------|
| **プロジェクト** | 名前、説明、作成日、更新日 | 「前に作ったあのプロジェクト」を探す |
| **図表** | ファイル名、種類(PlantUML/Excalidraw)、所属PJ | 「認証のシーケンス図」を探す |
| **学習コンテンツ** | タイトル、本文、カテゴリ | UC 3-10（構文や例を探す） |

### 1.2 TD-006（Storage Only MVP）との整合性

**制約**: MVPはデータベースなし → Storage APIのみ

| 検索方式 | MVP可能性 | 理由 |
|----------|:---------:|------|
| ファイル名検索 | ✅ | Storage metadata取得可能 |
| ファイル内容検索 | ⚠️ | 全ファイル読込が必要（高コスト） |
| 全文検索 | ❌ | DB必須（v3で対応） |
| セマンティック検索 | ❌ | Embedding + DB必須（v3+） |

## 2. MVP検索機能設計

### 2.1 グローバル検索（ヘッダー）

**配置**: 全画面共通ヘッダー中央

**機能仕様**:
| 項目 | 仕様 |
|------|------|
| 検索対象 | プロジェクト名、図表名 |
| 検索方式 | インクリメンタル検索（部分一致） |
| デバウンス | 200ms |
| キーボードショートカット | Ctrl+K / Cmd+K |
| 結果表示 | ドロップダウン（タイプ別グループ化） |
| 最大表示件数 | 各タイプ5件（「もっと見る」で全件） |

### 2.2 学習コンテンツ検索（UC 3-10）

**配置**: 学習コンテンツ画面専用

**機能仕様**:
| 項目 | 仕様 |
|------|------|
| 検索対象 | タイトル、本文、カテゴリ |
| 検索方式 | キーワードマッチ（AND検索） |
| カテゴリフィルタ | サイドバーで選択可能 |
| 結果表示 | カード形式（スニペット付き） |
| ハイライト | 検索キーワードを強調表示 |

## 3. 実装方式

### 3.1 MVP推奨: クライアントサイドフィルタ

**理由**:
- Storage APIのみでDB不要
- 小〜中規模データ（〜100件）で十分なパフォーマンス
- 実装コストが低い

**実装イメージ**:

// hooks/useSearch.ts
import { useMemo, useState } from 'react';
import { useDebouncedValue } from '@/hooks/useDebouncedValue';

interface SearchResults {
  projects: Project[];
  diagrams: Diagram[];
}

export function useSearch(
  projects: Project[],
  diagrams: Diagram[]
): {
  query: string;
  setQuery: (q: string) => void;
  results: SearchResults;
  isSearching: boolean;
} {
  const [query, setQuery] = useState('');
  const debouncedQuery = useDebouncedValue(query, 200);

  const results = useMemo(() => {
    if (!debouncedQuery.trim()) {
      return { projects: [], diagrams: [] };
    }

    const q = debouncedQuery.toLowerCase();

    return {
      projects: projects
        .filter(p => p.name.toLowerCase().includes(q))
        .slice(0, 5),
      diagrams: diagrams
        .filter(d => d.name.toLowerCase().includes(q))
        .slice(0, 5),
    };
  }, [debouncedQuery, projects, diagrams]);

  return {
    query,
    setQuery,
    results,
    isSearching: query !== debouncedQuery,
  };
}

## 4. UXパターン

### 4.1 採用パターン

| パターン | 説明 | 採用 |
|----------|------|:----:|
| **インスタント検索** | 入力と同時に結果表示（debounce 200ms） | ✅ |
| **キーボードナビ** | ↑↓で結果選択、Enterで開く | ✅ |
| **Escで閉じる** | Escキーで検索結果を閉じる | ✅ |
| **フォーカス時に履歴** | 空の状態で最近のアイテム表示 | ✅ |

## 5. フェーズ別ロードマップ

| Phase | 検索機能 | 技術要件 | 優先度 |
|:-----:|----------|---------|:------:|
| **MVP** | プロジェクト名・図表名検索 | Storage API + Client filter | P1 |
| **MVP** | 学習コンテンツ検索（UC 3-10） | API Routes + Text match | P1 |
| v3 | 図表内容の全文検索 | DB + Full-text index | P2 |
| v4+ | セマンティック検索 | Embedding (TD-007) + pgvector | P3 |

## 6. アクセシビリティ

| 要件 | 対応 |
|------|------|
| キーボード操作 | Ctrl+K、↑↓、Enter、Esc |
| スクリーンリーダー | aria-label、role="search"、aria-live |
| フォーカス管理 | 検索結果内でフォーカストラップ |
| 色のコントラスト | WCAG AA準拠（4.5:1以上） |
```

</details>

### 09:21〜09:46 ダッシュボード改善・デバッグ

| # | 時刻 | 操作 | 詳細 |
|:-:|------|------|------|
| 42 | 09:21:32 | Write | `02_dashboard.excalidraw` v5 |
| 43 | 09:33:06 | Bash | `npm list -g @excalidraw/cli` |
| 44 | 09:33:07 | Bash | `ls -la` |
| 45 | 09:33:18 | Bash | `npm install -g @excalidraw/cli` |
| 46 | 09:34:04 | Bash | `npm info excalidraw-to-svg` |
| 47 | 09:34:39 | Bash | `npm install -g excalidraw-export` |
| 48 | 09:34:48 | Bash | `npm search excalidraw svg` |
| 49 | 09:35:14 | Bash | `npm info create-excalidraw-svg` |
| 50 | 09:41:22 | Bash | `stat` ファイル確認 |
| 51 | 09:43:42 | Bash | `cat | head -250` |
| 52 | 09:44:04 | Bash | `grep -n '"id":'` |
| 53 | 09:45:56 | Write | `02_dashboard.excalidraw` v6 z-index問題修正 |
| 54 | 09:46:05 | Bash | `grep -n '"id":' | tail -20` |

**#53 z-index問題の発見と解決**:

```
問題: 検索ドロップダウンがプロジェクトカードの背後に表示
原因: Excalidrawの要素配列順序がz-indexを決定
     （配列の後ろの要素ほど前面に表示）

解決: 検索ドロップダウン関連要素を配列末尾に移動
     → 状態別ファイル分離を決定（後述）
```

### 09:51〜09:58 フォルダ構成変更

| # | 時刻 | 操作 | 詳細 |
|:-:|------|------|------|
| 55 | 09:51:26 | Bash | `mkdir main/ modal/ admin/` ← **却下案** |
| 56 | 09:55:01 | Bash | `rm -rf main/ modal/ admin/` |
| 57 | 09:56:47 | Bash | `mkdir 01_login/ 02_dashboard/ ...` 14フォルダ |
| 58 | 09:57:12 | Bash | `ls -la` 確認 |
| 59 | 09:57:21 | Bash | `mv 01_login.excalidraw → 01_login/default.excalidraw` |
| 60 | 09:57:23 | Bash | `mv 02_dashboard.excalidraw → 02_dashboard/default.excalidraw` |

**意思決定#1: フォルダ命名規則**

| 項目 | 却下案 | 採用案 | 理由 |
|------|--------|--------|------|
| 命名規則 | `main/`, `modal/`, `admin/` | `01_login/`, `02_dashboard/`, ... | ファイラーでの並び順保証、画面遷移図との対応明確 |

### 09:58〜10:02 インデックス・README・状態分離

| # | 時刻 | 操作 | 詳細 |
|:-:|------|------|------|
| 61 | 09:58:06 | Write | `00_wireframe_index.md` v1 テーブル形式 |
| 62 | 09:58:20 | Write | `01_login/README.md` |
| 63 | 09:58:37 | Write | `02_dashboard/README.md` |
| 64 | 10:00:48 | Write | `02_dashboard/default.excalidraw` 状態分離版 |
| 65 | 10:02:20 | Write | `02_dashboard/search_active.excalidraw` |

**意思決定#2: 状態管理**

| 項目 | 却下案 | 採用案 | 理由 |
|------|--------|--------|------|
| 状態管理 | 1ファイルに複数状態 | 状態別ファイル分離 | z-index問題解決、Obsidianでの閲覧性向上 |

### 10:02〜10:05 画面遷移図更新・active_context更新

| # | 時刻 | 操作 | diff詳細 |
|:-:|------|------|---------|
| 66 | 10:02:58 | Edit | `99_screen_transition.puml` バージョン v1.1→v1.2 |
| 67 | 10:03:10 | Edit | `99_screen_transition.puml` ログアウト遷移追加 |
| 68 | 10:03:19 | Edit | `99_screen_transition.puml` learning_content→[*] 追加 |
| 69 | 10:03:27 | Edit | `99_screen_transition.puml` 学習コンテンツnote追加 |
| 70 | 10:04:03 | Edit | `active_context.md` フォルダ再構成記録 |
| 71 | 10:04:13 | Edit | `active_context.md` 画面遷移図v1.2記録 |
| 72 | 10:04:35 | Edit | `active_context.md` 画面数更新（17→18） |
| 73 | 10:05:02 | Edit | `active_context.md` 分割記録 |
| 74 | 10:05:24 | Edit | `active_context.md` 進捗数値更新（2/18） |

**#66-69 diff詳細: 99_screen_transition.puml v1.2完成**

```diff
-' バージョン: 1.1 (OAuth-only設計対応)
+' バージョン: 1.2 (学習コンテンツ画面追加)

 ' ========== ログアウト ==========
 dashboard --> [*] : ログアウト
 editor --> [*] : ログアウト
+learning_content --> [*] : ログアウト
 admin_dashboard --> [*] : ログアウト

+note right of learning_content
+  学習コンテンツ:
+  - PlantUML構文ガイド
+  - テンプレートサンプル
+  - カテゴリ別検索
+  - キーワード検索
+end note
```

**#70-74 diff詳細: active_context.md 更新内容**

```diff
+### 2025-12-27（続き）
+
+- **ワイヤーフレームフォルダ再構成** ✅
+  - 番号プレフィックス方式導入（01_login/, 02_dashboard/, ...）
+  - 状態別ファイル分離（default.excalidraw, search_active.excalidraw）
+  - README.md + 複数Excalidraw埋め込み形式
+  - ワイヤーフレーム一覧インデックス作成（00_wireframe_index.md）
+
+- **画面遷移図 v1.2 更新** ✅
+  - 学習コンテンツ画面（learning_content）追加（UC 3-10, 3-11）
+  - メイン画面群: 3→4画面
+  - 全画面数: 17→18画面
+  - ノード: dashboard → learning_content 遷移追加
+  - 注釈: 学習コンテンツ機能説明追加
+
+- **ダッシュボードワイヤーフレーム分割** ✅
+  - 02_dashboard/default.excalidraw: 通常状態のみ
+  - 02_dashboard/search_active.excalidraw: 検索ドロップダウン表示状態
+  - z-index問題解決（検索ドロップダウン要素を配列末尾に移動）
```

### 10:15〜10:32 index.md形式の試行錯誤（EX-005発見）

| # | 時刻 | 操作 | 形式 | 結果 |
|:-:|------|------|------|------|
| 75 | 10:15:52 | Write | テーブル形式 | 基本形 |
| 76 | 10:18:54 | Write | `[[path.excalidraw]]` | プレビュー非表示 |
| 77 | 10:28:49 | Write | リンク形式修正 | **戻るボタン問題発見** |
| 78 | 10:32:03 | Write | `![[path.excalidraw]]` | **成功（EX-005）** |

**意思決定#3: index.md形式**

| 項目 | 却下案 | 採用案 | 理由 |
|------|--------|--------|------|
| index.md形式 | `[[...]]` リンク形式 | `![[...]]` 埋め込み形式 | 戻るボタン問題解消、スクロールで全画面確認可能 |

**#77 問題発見: 戻るボタン位置リセット問題**

```
現象: リンククリック後、戻るボタンで元のスクロール位置に戻らない
原因: Obsidianの仕様（新しいファイルを開くとスクロール位置リセット）
解決: 埋め込み形式 ![[...]] を使用
     → 画面遷移なしで一覧確認可能
```

### 10:41〜10:43 知見ドキュメント更新（EX-005反映）

| # | 時刻 | 操作 | ファイル | diff詳細 |
|:-:|------|------|---------|---------|
| 79 | 10:41:22 | Edit | `UI_Design_Knowledge_Base.md` | EX-005本文追加（40行） |
| 80 | 10:41:33 | Edit | `UI_Design_Knowledge_Base.md` | 更新履歴v1.2追加 |
| 81 | 10:42:11 | Edit | `00_Session_Start.md` | Step 4.5追加（15行） |
| 82 | 10:42:29 | Edit | `00_Session_Start.md` | 更新履歴v1.5追加 |
| 83 | 10:43:06 | Edit | `02_Authoring_Guide.md` | §4.4追加（18行） |
| 84 | 10:43:15 | Edit | `02_Authoring_Guide.md` | 更新履歴追加 |

**#79-80 diff詳細: EX-005 Embedded Index Pattern**

```diff
-### EX-005: （テンプレート - 新規知見追加用）
+### EX-005: Embedded Index Pattern（埋め込みインデックスパターン）

 | 項目 | 内容 |
 |------|------|
-| **発見日** | YYYY-MM-DD |
+| **発見日** | 2025-12-27 |
-| **状況** | （発見状況を記載） |
+| **状況** | 複数ワイヤーフレームのレビュー時に各ファイルを個別に開く必要があり、
+            リンククリック後に戻るボタンで位置がリセットされる問題が発生 |
-| **知見** | （獲得した知見を記載） |
+| **知見** | 閲覧用のindex.mdと編集用の個別ファイルを分離し、
+            index.mdに `![[path.excalidraw]]` で埋め込み表示することで、
+            画面遷移なしで一覧確認が可能 |
-| **推奨** | （推奨される対応を記載） |
+| **推奨** | 以下のファイル構成を採用する |

+#### 構成
+
+wireframes/
+├── 00_wireframe_index.md      ← 閲覧用（埋め込み一覧）
+├── 01_login/
+│   └── default.excalidraw     ← 編集用（基本状態）
+├── 02_dashboard/
+│   ├── default.excalidraw
+│   └── search_active.excalidraw  ← 編集用（派生状態）
+└── ...

+#### 命名規則
+
+| 要素 | 規則 | 例 |
+|------|------|-----|
+| インデックス | `00_` プレフィックス | `00_wireframe_index.md` |
+| 画面フォルダ | `XX_screen_name/` | `02_dashboard/` |
+| 基本状態 | `default.excalidraw` | 通常表示 |
+| 派生状態 | `<state>.excalidraw` | `search_active.excalidraw` |

+#### メリット
+
+- スクロールで全画面確認（画面遷移不要）
+- 戻るボタン問題解消
+- 編集性維持（個別ファイル直接編集可能）
+- 状態管理の明確化（ファイル名で状態識別）
```

**#81-82 diff詳細: 00_Session_Start.md Step 4.5追加**

```diff
+### Step 4.5: ワイヤーフレーム一覧確認
+
+既存ワイヤーフレームがある場合、`00_wireframe_index.md` で一覧確認する。
+
+```markdown
+# index.md の形式（EX-005 Embedded Index Pattern）
+
+## 01. ログイン画面
+![[01_login/default.excalidraw]]
+
+## 02. ダッシュボード
+![[02_dashboard/default.excalidraw]]
+![[02_dashboard/search_active.excalidraw]]
+```
+
+- **閲覧**: `00_wireframe_index.md`（スクロールで全画面確認）
+- **編集**: 個別の `.excalidraw` ファイル
+
+> **詳細**: UI_Design_Knowledge_Base.md §EX-005
```

**#83-84 diff詳細: 02_Authoring_Guide.md §4.4追加**

```diff
+### 4.4 ファイル構成（EX-005 Embedded Index Pattern）
+
+ワイヤーフレームの閲覧と編集を分離するパターン。
+
+wireframes/
+├── 00_wireframe_index.md      ← 閲覧用（埋め込み一覧）
+├── 01_login/
+│   └── default.excalidraw     ← 編集用（基本状態）
+├── 02_dashboard/
+│   ├── default.excalidraw
+│   └── search_active.excalidraw  ← 編集用（派生状態）
+└── ...
+
+| ファイル | 役割 |
+|---------|------|
+| `00_wireframe_index.md` | 閲覧用（`![[file.excalidraw]]` で埋め込み一覧）|
+| `XX_screen/default.excalidraw` | 編集用（個別ファイル）|
+| `XX_screen/<state>.excalidraw` | 編集用（派生状態）|
+
+> **詳細**: UI_Design_Knowledge_Base.md §EX-005
```

### 15:06 憲法更新

| # | 時刻 | 操作 | diff詳細 |
|:-:|------|------|---------|
| 85 | 15:06:00 | Edit | `UI_Design_Constitution.md` §6.3.5 Evidence作成コマンド追加 |
| 86 | 15:06:17 | Edit | `UI_Design_Constitution.md` 更新履歴v3.4追加 |

**#85-86 diff詳細: UI_Design_Constitution.md 更新**

```diff
+**作成コマンド**:
+```powershell
+# Evidence 3点セット自動作成
+pwsh scripts/create_evidence.ps1 <yyyyMMdd_HHmm>_ui_design_<scope>
+
+# 例
+pwsh scripts/create_evidence.ps1 20251227_1430_ui_design_dashboard
+```

 ## 更新履歴

 | 日付 | Ver | 内容 |
 |------|:---:|------|
+| 2025-12-27 | 3.4 | §6.3.5 Evidence作成コマンド追加（create_evidence.ps1参照）|
 | 2025-12-24 | 3.3 | **品質改善**: ① §8 ID体系をAP-001/RP-001/NP-001/FP-001形式に統一...
```

### 15:09〜15:18 Evidence 3点セット作成

| # | 時刻 | 操作 | ファイル |
|:-:|------|------|---------|
| 87 | 15:09:34 | Bash | `ls -la` 確認 |
| 88 | 15:10:16 | Write | `instructions.md` |
| 89 | 15:10:49 | Write | `00_raw_notes.md` v1 |
| 90 | 15:13:01 | Write | `work_sheet.md` v1 |
| 91 | 15:17:11 | Write | `00_raw_notes.md` 詳細版 |
| 92 | 15:18:38 | Write | `work_sheet.md` 詳細版 |

---

## 発見した知見

### EX-005: Embedded Index Pattern

| 項目 | 内容 |
|------|------|
| **発見日時** | 2025-12-27 10:32 |
| **発見経緯** | index.md形式の試行錯誤（4回のWrite操作: #75-78）|
| **問題** | リンククリック後に戻るボタンで位置がリセットされる |
| **解決** | `![[path.excalidraw]]` 埋め込み形式で一覧表示 |
| **反映先** | UI_Design_Knowledge_Base.md, 00_Session_Start.md, 02_Authoring_Guide.md |
| **反映操作** | #79-84（6回のEdit操作） |

---

## 発見した問題と対応

| # | 問題 | 原因 | 対応 | 発見時刻 | 操作# |
|:-:|------|------|------|---------|:-----:|
| 1 | z-index問題 | Excalidraw配列順序がz-index決定 | 状態別ファイル分離 | 09:45頃 | #53 |
| 2 | 戻るボタン位置リセット | Obsidianの仕様 | 埋め込み形式採用 | 10:28頃 | #77 |

---

## 意思決定履歴

| # | 決定事項 | 却下案 | 採用案 | 時刻 | 操作# |
|:-:|---------|--------|--------|------|:-----:|
| 1 | フォルダ命名規則 | main/, modal/, admin/ | 番号プレフィックス | 09:55 | #55-57 |
| 2 | 状態管理 | 1ファイルに複数状態 | 状態別ファイル分離 | 10:00 | #64-65 |
| 3 | index.md形式 | リンク形式 | 埋め込み形式 | 10:32 | #75-78 |

---

## 2025-12-27（セッション4）5操作 - 知見ドキュメント公式反映

### 16:06〜16:07 知見ベース・ガイドライン公式反映

| # | 時刻(JST) | 操作 | ファイル | diff詳細 |
|:-:|-----------|------|---------|---------|
| 97 | 16:06:04 | Edit | `UI_Design_Knowledge_Base.md` | EX-006（z-index問題）、EX-007（状態別ファイル分離）追加 |
| 98 | 16:06:45 | Edit | `02_Authoring_Guide.md` | §4.5（フォルダ命名規則）、§4.6（TD-015設定値一覧）追加 |
| 99 | 16:06:56 | Edit | `02_Authoring_Guide.md` | 更新履歴追加 |
| 100 | 16:07:13 | Edit | `UI_Design_Knowledge_Base.md` | 更新履歴v1.3追加 |
| 101 | 16:07:20 | Edit | `UI_Design_Knowledge_Base.md` | ヘッダーバージョン1.0→1.3更新 |

**#97 diff詳細: EX-006/EX-007追加（約70行追加）**

```diff
-### EX-006: （テンプレート - 新規知見追加用）
+### EX-006: z-index問題（配列順序依存）

 | 項目 | 内容 |
 |------|------|
-| **発見日** | YYYY-MM-DD |
+| **発見日** | 2025-12-27 |
-| **状況** | （発見状況を記載） |
+| **状況** | ダッシュボード画面で検索ドロップダウンがプロジェクトカードの背後に表示された |
-| **知見** | （獲得した知見を記載） |
+| **知見** | Excalidrawでは要素の配列順序がz-indexを決定する。配列の後ろの要素ほど前面に表示される |
-| **推奨** | （推奨される対応を記載） |
+| **推奨** | 前面表示したい要素は配列末尾に配置、または状態別ファイル分離（EX-007）を採用 |

+#### 技術詳細
+```json
+{
+  "elements": [
+    { "id": "card-1", ... },      // 背面
+    { "id": "card-2", ... },      // 中間
+    { "id": "dropdown", ... }     // 最前面（配列末尾）
+  ]
+}
+```

+### EX-007: 状態別ファイル分離パターン
+（約35行追加）
```

**#98 diff詳細: §4.5/§4.6追加（約55行追加）**

```diff
+### 4.5 フォルダ命名規則（番号プレフィックス方式）
+
+| 方式 | 例 | 採否 | 理由 |
+|------|-----|:----:|------|
+| カテゴリ別 | `main/`, `modal/`, `admin/` | ❌ 却下 | ファイラーでの並び順が不定 |
+| 番号プレフィックス | `01_login/`, `02_dashboard/` | ✅ 採用 | 並び順保証、遷移図との対応明確 |

+### 4.6 TD-015準拠 設定値一覧
+
+| 用途 | カラーコード | 備考 |
+|------|:-----------:|------|
+| 背景色（画面） | `#ffffff` | 白 |
+| 枠線色 | `#1e1e1e` | 黒 |
+| ボタン背景 | `#e0e0e0` | 中グレー |
+（以下省略、合計7色+8スタイル設定）
```

---

## 統計サマリー

| 項目 | 件数 |
|------|-----:|
| **総操作数** | **101** |
| ファイル変更操作 | 70 |
| Bashコマンド実行 | 31 |
| ワイヤーフレーム作成 | 3ファイル（login, dashboard×2） |
| ガイドドキュメント更新 | **19件（5ファイル）** |
| active_context.md更新 | 17件 |
| 画面遷移図更新 | 8件 |
| 知見追加 | **3件（EX-005, EX-006, EX-007）** |
| 技術設計書作成 | 1件（search_functionality_design.md） |

---

## 作成・更新ファイル一覧（完全版）

### 新規作成ファイル

| ファイル | 行数 | 主要内容 |
|---------|-----:|---------|
| `01_login/default.excalidraw` | - | ログイン画面（OAuth-only） |
| `02_dashboard/default.excalidraw` | - | ダッシュボード通常状態 |
| `02_dashboard/search_active.excalidraw` | - | 検索ドロップダウン表示状態 |
| `00_wireframe_index.md` | 20 | 埋め込み一覧 |
| `01_login/README.md` | 15 | ログイン画面説明 |
| `02_dashboard/README.md` | 25 | ダッシュボード説明 |
| `search_design/search_functionality_design.md` | 262 | 検索機能設計書 |
| `instructions.md` | 54 | 作業指示書 |
| `00_raw_notes.md` | 本ファイル | 作業メモ完全版 |
| `work_sheet.md` | - | ワークシート |

### 更新ファイル

| ファイル | 更新回数 | 主要変更内容 |
|---------|:--------:|-------------|
| `99_screen_transition.puml` | 8 | v1.0→v1.1→v1.2（学習コンテンツ追加） |
| `active_context.md` | 17 | OAuth-only対応、進捗更新 |
| `UI_Design_Knowledge_Base.md` | **6** | EX-005追加、**EX-006/EX-007追加**、v1.3 |
| `00_Session_Start.md` | 2 | Step 4.5追加、v1.5 |
| `02_Authoring_Guide.md` | **5** | §4.4追加、**§4.5/§4.6追加** |
| `UI_Design_Constitution.md` | 4 | §6.3.5コマンド追加、v3.4 |
| `UI_Design_Patterns.md` | 2 | 初期設定 |
