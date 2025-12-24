# UI設計図表作成ガイドライン

**作成日**: 2025-12-22
**対象**: ワイヤーフレーム・画面遷移図
**根拠**: UI設計図表開発憲法 v3.2

---

## 目的

本ガイドラインは、UI設計図表（ワイヤーフレーム・画面遷移図）を作成する際に、後から修正が必要にならないよう、事前に留意すべき点をまとめたものです。

---

## 1. TD-015原則の遵守（最重要）

### ルール

**UI設計図表は「低精度（Low-Fidelity）」「手書き風」「グレースケール」の3原則を必ず満たすこと。**

### 正しいパターン

| 原則 | 適用方法 |
|------|---------|
| **低精度** | 1画面15分以内で作成、詳細な装飾なし |
| **手書き風** | Excalidraw標準スタイル、Roughness 1-2 |
| **グレースケール** | 白・グレー・黒のみ、カラー禁止 |

### 禁止パターン

| 禁止事項 | 理由 |
|---------|------|
| グラデーション | 「デザイン」議論を誘発 |
| ドロップシャドウ | 高精度の印象を与える |
| カラー使用 | 配色議論は設計フェーズで行う |
| ピクセル完璧 | 実装詳細に踏み込みすぎ |
| 複雑なアイコン | 簡易記号のみ許可 |

---

## 2. Excalidrawスタイル設定（ワイヤーフレーム）

### 必須設定

```json
{
  "strokeColor": "#1e1e1e",
  "backgroundColor": "#f5f5f5",
  "fillStyle": "solid",
  "strokeWidth": 1,
  "roughness": 1,
  "opacity": 100,
  "fontFamily": 1,
  "fontSize": 16,
  "textAlign": "center",
  "verticalAlign": "middle"
}
```

### 要素別推奨設定

| 要素 | Roughness | Fill | 備考 |
|------|:---------:|------|------|
| コンテナ（画面枠） | 1 | #ffffff | 外枠は太め（strokeWidth: 2） |
| ボタン | 1 | #e0e0e0 | グレー背景 |
| テキスト入力 | 0 | #ffffff | 直線的に |
| ラベル | - | なし | Hand-drawn font、16px以上 |
| 区切り線 | 1 | - | 破線使用可 |

---

## 3. PlantUML画面遷移図の構文

### 必須ヘッダー

```plantuml
@startuml PlantUML_Studio_Screen_Transition
'==================================================
' 画面遷移図: PlantUML Studio
' 対象: 全画面（認証/メイン/モーダル/管理）
' 基準: UC図、業務フロー図
'==================================================

!option handwritten true

skinparam state {
    BackgroundColor #F5F5F5
    BorderColor #666666
    FontColor #333333
}

skinparam state<<auth>> {
    BackgroundColor #FFFDE7
}

skinparam state<<main>> {
    BackgroundColor #E3F2FD
}

skinparam state<<modal>> {
    BackgroundColor #E8F5E9
}
```

### 必須構造

```plantuml
[*] --> ログイン画面 : 初回アクセス

state "認証画面群" as auth {
    state "ログイン画面" as login <<auth>>
    state "新規登録画面" as signup <<auth>>
}

state "メイン画面群" as main {
    state "ダッシュボード" as dashboard <<main>>
    state "エディタ画面" as editor <<main>>
}

login --> dashboard : ログイン成功
dashboard --> editor : 図表選択
editor --> [*] : ログアウト

@enduml
```

---

## 4. 命名規則

### 4.1 ワイヤーフレームファイル

```
NN_<category>_<screen_name>.excalidraw
```

| 要素 | ルール | 例 |
|------|--------|-----|
| NN | 2桁ゼロ埋め連番 | 01, 02, 10 |
| category | 画面カテゴリ（auth/main/modal/admin） | auth |
| screen_name | スネークケース | login, project_list |

**予定ファイル一覧**:

| # | ファイル名 | 画面名 |
|:-:|-----------|--------|
| 01 | `01_auth_login.excalidraw` | ログイン画面 |
| 02 | `02_auth_signup.excalidraw` | 新規登録画面 |
| 03 | `03_main_dashboard.excalidraw` | ダッシュボード |
| 04 | `04_main_editor.excalidraw` | エディタ画面 |
| 05 | `05_main_project_list.excalidraw` | プロジェクト一覧 |

### 4.2 エクスポートファイル

```
NN_<category>_<screen_name>-Review.png   # レビュー用
NN_<category>_<screen_name>.svg          # 正式版
```

### 4.3 画面遷移図

```
99_screen_transition.puml   # PlantUMLソース
99_screen_transition.svg    # 正式版
```

---

## 5. 整合性確認（3点対比）

### ルール

**「画面一覧」「ワイヤーフレーム」「遷移図ノード」の3点が1:1対応していることを確認すること。**

### 確認手順

1. **画面一覧テンプレート**で全画面をリストアップ
2. 各画面に対応する**ワイヤーフレーム**が存在するか確認
3. 各画面が**遷移図ノード**として存在するか確認

### 整合性確認テーブル（必須）

```markdown
| 画面名 | ワイヤーフレーム | 遷移図ノード | 対応UC |
|--------|:---------------:|:------------:|--------|
| ログイン画面 | ✅ 01_auth_login | ✅ login | UC 1-1 |
| ダッシュボード | ✅ 03_main_dashboard | ✅ dashboard | UC 2-1 |
| エディタ画面 | 🔴 未作成 | ✅ editor | UC 3-1〜3-6 |
```

### 孤立ノードチェック（遷移図）

- [ ] 全ノードに**入力矢印**があるか（開始点除く）
- [ ] 全ノードに**出力矢印**があるか（終了点除く）
- [ ] 到達不能な画面がないか

---

## 6. チェックリスト（作成前に確認）

### 設計確認（ワイヤーフレーム作成前必須）

> **⚠️ 重要**: 以下の確認をワイヤーフレーム作成**前**に実施すること。

- [ ] **UC図確認**: 該当UCの機能要件を確認した
- [ ] **業務フロー確認**: 該当セクションの業務フローを確認した
- [ ] **機能一覧表確認**: 該当機能ID（F-XXX-XX）の詳細を確認した
- [ ] **既存ワイヤーフレーム確認**: 類似画面のスタイルを参照した

**UC/業務フロー整合性テーブル（必須）**:

```markdown
| 確認項目 | 参照先 | 確認内容 | 確認 |
|---------|--------|---------|:----:|
| UC定義 | UC X-X | 機能要件 | ✅ |
| 業務フロー | §3.X | 処理フロー | ✅ |
| 機能一覧 | F-XXX-XX | 詳細仕様 | ✅ |
```

### TD-015原則確認

- [ ] 低精度（Low-Fidelity）を維持しているか
- [ ] 手書き風スタイルを適用しているか
- [ ] グレースケールのみ使用しているか
- [ ] 1画面15分以内で作成できる程度か

### UI要素配置確認

- [ ] 全ての必須UI要素が含まれているか
- [ ] 要素の論理的なグルーピングがされているか
- [ ] ナビゲーション要素が明確か
- [ ] アクセシビリティが考慮されているか

### 過剰詳細チェック（憲法 §3.4）

- [ ] ピクセル単位の配置調整をしていないか
- [ ] 詳細なアイコンデザインを含んでいないか
- [ ] カラーパレットを定義していないか
- [ ] フォントサイズの細かい調整をしていないか
- [ ] 30分以上かけていないか（目安15分/画面）

---

## 7. 5パスレビュー

### レビュープロセス

PNG生成後、以下の5パスで視覚的レビューを実施。

| Pass | 対象 | 確認内容 |
|:----:|------|---------|
| 1 | **TD-015準拠** | 低精度、手書き風、グレースケール |
| 2 | **網羅性** | 画面一覧チェックリスト照合 |
| 3 | **UI要素** | UC図・業務フロー図と照合 |
| 4 | **過剰詳細** | 「やりすぎ」チェック（憲法 §3.4） |
| 5 | **整合性** | 他画面との一貫性 |

### Pass 1: TD-015準拠確認

```markdown
| チェック項目 | 確認 | 備考 |
|-------------|:----:|------|
| グラデーションなし | ✅/🔴 | |
| ドロップシャドウなし | ✅/🔴 | |
| グレースケールのみ | ✅/🔴 | |
| 手書き風スタイル | ✅/🔴 | |
| 低精度維持 | ✅/🔴 | |
```

### Pass 4: 過剰詳細チェック

```markdown
| 過剰詳細項目 | 該当 | 対応 |
|-------------|:----:|------|
| ピクセル完璧配置 | ✅/🔴 | |
| 複雑なアイコン | ✅/🔴 | |
| 詳細なタイポグラフィ | ✅/🔴 | |
| 実装寄りの詳細 | ✅/🔴 | |
```

---

## 8. 採点基準

### Phase 1-A: ワイヤーフレーム採点

| カテゴリ | 配点 | 確認内容 |
|---------|:----:|---------|
| TD-015準拠 | 25 | 3原則遵守 |
| UC/業務フロー整合性 | 20 | 機能網羅性 |
| UI要素配置 | 20 | 論理的グルーピング |
| アクセシビリティ | 15 | 基本配慮 |
| 命名規則 | 10 | ファイル名・要素名 |
| 可読性 | 10 | 視認性・明瞭さ |
| **合計** | **100** | **90点以上で合格** |

### Phase 1-B: 画面遷移図採点

| カテゴリ | 配点 | 確認内容 |
|---------|:----:|---------|
| 網羅性 | 30 | 全画面ノード化 |
| 遷移完全性 | 25 | 孤立ノードなし |
| UC対応 | 20 | UC→遷移追跡可能 |
| 構文正確性 | 15 | PlantUML構文 |
| 可読性 | 10 | レイアウト・ラベル |
| **合計** | **100** | **90点以上で合格** |

---

## 9. 成果物保存

### 保存先

| 成果物 | 保存先 |
|--------|--------|
| ワイヤーフレーム（.excalidraw） | `docs/proposals/diagrams/10_wireframe/` |
| ワイヤーフレーム正式版（.svg） | `docs/proposals/diagrams/10_wireframe/` |
| 画面遷移図（.puml） | `docs/proposals/diagrams/09_screen_transition/` |
| 画面遷移図正式版（.svg） | `docs/proposals/diagrams/09_screen_transition/` |

### Evidence 3点セット

```
docs/evidence/yyyyMMdd_HHmm_ui_design_xxx/
├── instructions.md     # 作業指示
├── 00_raw_notes.md     # 作業メモ
└── work_sheet.md       # 作業結果・採点
```

---

## 10. 知見反映（セッション終了前必須）

> **参照**: UI設計図表開発憲法 v3.2

セッション終了前に以下を確認：

- [ ] Excalidraw関連の発見 → `UI_Design_Knowledge_Base.md` に EX-XXX として追加
- [ ] State Diagram関連の発見 → `UI_Design_Knowledge_Base.md` に SD-XXX として追加
- [ ] TD-015適用の発見 → `UI_Design_Knowledge_Base.md` に TD-XXX として追加
- [ ] 整合性チェックの発見 → `UI_Design_Knowledge_Base.md` に IC-XXX として追加
- [ ] プロセス改善を発見 → `UI_Design_Constitution.md` を更新
- [ ] ガイドライン変更が必要 → 本ガイド（02_Authoring_Guide.md）を更新
- [ ] work_sheet.md に反映結果を記録

---

## 11. 参照ドキュメント

| ドキュメント | パス | 参照目的 |
|-------------|------|---------|
| **UI設計図表開発憲法** | `docs/guides/ui_design/UI_Design_Constitution.md` | 禁止事項、評価基準 |
| **セッション開始ガイド** | `docs/guides/ui_design/00_Session_Start.md` | 作業プロセス |
| **参照ガイド** | `docs/guides/ui_design/01_Reference_Guide.md` | ドキュメントナビ |
| 知見統合戦略 | `docs/guides/ui_design/03_Knowledge_Strategy.md` | 知見ID体系、追加フロー |
| **知見ベース** | `docs/guides/ui_design/UI_Design_Knowledge_Base.md` | EX/SD/TD/IC知見 |
| **設計パターンチェックリスト** | `docs/guides/ui_design/Design_Pattern_Checklist.md` | UIパターン確認 |
| **UI設計パターン集** | `docs/guides/ui_design/UI_Design_Patterns.md` | 実装パターン |
| **UC図** | `docs/proposals/02_ユースケース図_20251130.md` | 機能要件 |
| **業務フロー図** | `docs/proposals/03_業務フロー図_20251201.md` | 業務フロー詳細 |
| **機能一覧表** | `docs/proposals/05_機能一覧表_20251213.md` | UC番号、機能ID |
| **技術決定** | `docs/context/technical_decisions.md` | TD-015 |

---

## 更新履歴

| 日付 | 内容 |
|------|------|
| 2025-12-22 | 初版作成 |
