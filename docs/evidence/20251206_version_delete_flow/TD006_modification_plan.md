# TD-006対応 修正計画書

**作成日**: 2025-12-06
**目的**: DB→Storage Only変更に伴うdocs/proposals/配下ファイルの修正

---

## 修正対象サマリ

| ファイル | 修正箇所数 | 作業時間目安 |
|---------|:---------:|:----------:|
| 業務フロー図 | 20箇所 | 70分 |
| コンテキスト図 | 3箇所 | 10分 |
| ユースケース図 | 4箇所 | 15分 |
| **合計** | **27箇所** | **約1.5時間** |

**対象外**: 開発ステップ詳細化計画（開発フェーズで更新）

---

# 1. 業務フロー図（20箇所）

**ファイル**: `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md`

---

## 1.1 セクション3.6 Storage構造（Line 1068-1078）

**現在の記述:**
```
#### Storage構成（統一設計）

両図表タイプで**ソースファイル + プレビューSVG**の構成を採用:

```
Supabase Storage:
/{user_id}/{project_id}/{diagram_id}/
  ├── source.puml          # PlantUMLソース（複数@startuml可）
  │   または source.json   # Excalidraw JSON
  ├── preview_0.svg        # 1つ目の図のプレビュー（サムネイル用）
  ├── preview_1.svg        # 2つ目の図のプレビュー（PlantUMLで複数図の場合）
  └── ...
```
```

**変更後:**
```
#### Storage構成（MVP：TD-006準拠）

MVPはSupabase Storageのみで構成（DBテーブルなし）:

```
Supabase Storage:
/{user_id}/
  └── {project_name}/
      ├── {diagram_name}.puml           # PlantUMLソース
      ├── {diagram_name}.excalidraw.json # Excalidraw JSON
      └── {diagram_name}.preview.svg     # プレビュー（サムネイル用）
```

> **Note**: v3でDB追加時、UUIDベースの構造に移行予定（取込み機能で対応）
```

---

## 1.2 セクション3.1 PlantUMLコードのバージョン保存部分（Line 143-149）

**現在の記述:**
```plantuml
|エンドユーザー|
:"「保存」をクリック";

|PlantUML Service|
:バージョン保存\n(SHA-256ハッシュ);

|Supabase|
:メタデータ保存 (Postgres);
```

**変更後:**
```plantuml
|エンドユーザー|
:"「保存」をクリック";

|Frontend Service|
:Storageへ保存リクエスト;

|Supabase|
:ファイル保存 (Storage);
note right
  {project_name}/{diagram_name}.puml
  Storage Policyで所有権検証
end note
```

---

## 1.3 セクション3.3 Excalidraw保存部分（Line 395-402）

**現在の記述:**
```plantuml
|Excalidraw Service|
:Excalidraw JSON保存;
:SVG/PNG/PDF変換;

|Supabase|
:Storage保存\n(JSON/画像);
```

**変更後:**
```plantuml
|Excalidraw Service|
:Excalidraw JSON生成;
:プレビューSVG生成;

|Supabase|
:Storage保存;
note right
  {project_name}/{diagram_name}.excalidraw.json
  {project_name}/{diagram_name}.preview.svg
end note
```

---

## 1.4 セクション3.5.1 プロジェクト作成フロー（Line 824-830）

**現在の記述:**
```plantuml
|Frontend Service|
if (バリデーション?) then (OK)
  :Supabaseに作成リクエスト;
  note right
    RLS適用
    同名チェック
  end note
```

**変更後:**
```plantuml
|Frontend Service|
if (バリデーション?) then (OK)
  :Storageにフォルダ作成;
  note right
    Storage Policy適用
    /{user_id}/{project_name}/
    同名チェック（フォルダ存在確認）
  end note
```

---

## 1.5 セクション3.5 プロジェクト一覧取得（Line 762-764）

**現在の記述:**
```plantuml
|Frontend Service|
:プロジェクト一覧取得\n（Supabase RLS適用）;
:一覧表示;
```

**変更後:**
```plantuml
|Frontend Service|
:プロジェクト一覧取得\n（Storage API + Policy適用）;
note right
  /{user_id}/ 配下のフォルダ一覧
end note
:一覧表示;
```

---

## 1.6 セクション3.5.3 プロジェクト編集フロー（Line 895-906）

**現在の記述:**
```plantuml
|Frontend Service|
  :Supabaseに更新リクエスト;
  |Supabase|
  if (同名チェック) then (重複)
    |Frontend Service|
    #pink:エラー: 同名プロジェクトが存在;
    stop
  else (OK)
    :プロジェクト名更新\n（RLS適用）;
```

**変更後:**
```plantuml
|Frontend Service|
  :Storageフォルダ名変更リクエスト;
  |Supabase|
  if (同名チェック) then (重複)
    |Frontend Service|
    #pink:エラー: 同名プロジェクトが存在;
    stop
  else (OK)
    :フォルダ名変更\n（Storage Policy適用）;
    note right
      /{user_id}/{old_name}/ → /{user_id}/{new_name}/
      配下ファイルも移動
    end note
```

---

## 1.7 セクション3.5.4 プロジェクト削除フロー（Line 936）

**現在の記述:**
```plantuml
|Frontend Service|
:削除実行\n（カスケード削除）;
```

**変更後:**
```plantuml
|Frontend Service|
:フォルダ削除実行\n（配下ファイル含む）;
note right
  /{user_id}/{project_name}/ を再帰削除
end note
```

---

## 1.8 セクション3.6.1.1 PlantUML保存フロー（Line 1168-1218）

**現在の記述:**
```plantuml
|PlantUML Service|
:SHA-256ハッシュ生成;
:バージョン情報作成;
note right
  コンテンツハッシュで
  バージョンを一意に識別
end note
:プレビューSVG生成;
...
|Supabase|
:メタデータ保存（Postgres）;
:ソース・プレビュー保存（Storage）;
note right
  source.puml + preview_N.svg
  RLS適用・所有権検証
end note
```

**変更後:**
```plantuml
|PlantUML Service|
:プレビューSVG生成;
note right
  node-plantuml実行
end note

|Frontend Service|
:処理結果を受信;
:AI Serviceへ用語チェック依頼;
...
|Supabase|
:ファイル保存（Storage）;
note right
  {diagram_name}.puml
  {diagram_name}.preview.svg
  Storage Policy適用
end note
```

**削除する行:**
- `:SHA-256ハッシュ生成;`
- `:バージョン情報作成;`
- バージョン関連のnote
- `:メタデータ保存（Postgres）;`

---

## 1.9 セクション3.6.1.2 Excalidraw保存フロー（Line 1297-1303）

**現在の記述:**
```plantuml
|Supabase|
:メタデータ保存（Postgres）;
:ソース・プレビュー保存（Storage）;
note right
  source.json + preview_0.svg
  RLS適用・所有権検証
end note
```

**変更後:**
```plantuml
|Supabase|
:ファイル保存（Storage）;
note right
  {diagram_name}.excalidraw.json
  {diagram_name}.preview.svg
  Storage Policy適用
end note
```

---

## 1.10 セクション3.7 バージョン管理フロー ヘッダー（Line 1503-1507）

**現在の記述:**
```markdown
## 3.7 バージョン管理フロー

**関連ユースケース**: UC 3-7 バージョン履歴を確認する, UC 3-8 過去バージョンを復元する
**対象**: PlantUML図表・Excalidraw図表の両方
```

**変更後:**
```markdown
## 3.7 バージョン管理フロー

**関連ユースケース**: UC 3-7 バージョン履歴を確認する, UC 3-8 過去バージョンを復元する
**対象**: PlantUML図表・Excalidraw図表の両方
**実装フェーズ**: ⚠️ **v3で実装予定（MVP対象外）**

> **Note**: 本セクションはv3の設計仕様です。MVPではStorage Onlyのためバージョン管理機能は提供しません。
> v3で「ファイル取込み機能」と共にDB追加後、本機能を実装します（TD-006参照）。
```

---

## 1.11 セクション3.7.1 履歴確認フロー（Line 1597-1603）

**現在の記述:**
```plantuml
|Supabase|
:バージョン一覧取得\n（RLS適用）;
note right
  図表IDに紐づく
  全バージョンを取得
  created_at DESC
end note
```

**変更後:**
```plantuml
|Supabase|
:バージョン一覧取得\n（v3: DB + RLS適用）;
note right
  **v3で実装**
  図表IDに紐づく
  全バージョンを取得
  created_at DESC
end note
```

---

## 1.12 セクション3.7.2 復元フロー（Line 1689-1690）

**現在の記述:**
```plantuml
|Supabase|
:選択バージョンのソース取得;
```

**変更後:**
```plantuml
|Supabase|
:選択バージョンのソース取得\n（v3: DB経由）;
```

---

## 1.13 セクション3.8 図表削除フロー 設計思想（Line 1767-1775）

**現在の記述:**
```markdown
#### 削除時の処理

| 項目 | 説明 |
|------|------|
| **メタデータ削除** | PostgreSQLの図表レコードを削除 |
| **ソースファイル削除** | Storageの`source.puml`/`source.json`を削除 |
| **プレビューファイル削除** | Storageの`preview_N.svg`を全て削除 |
| **バージョン履歴削除** | 図表に紐づく全バージョンをカスケード削除 |
```

**変更後:**
```markdown
#### 削除時の処理（MVP）

| 項目 | 説明 | MVP | v3 |
|------|------|:---:|:---:|
| **ソースファイル削除** | `.puml`/`.excalidraw.json`を削除 | ✅ | ✅ |
| **プレビューファイル削除** | `.preview.svg`を削除 | ✅ | ✅ |
| **メタデータ削除** | DBの図表レコードを削除 | - | ✅ |
| **バージョン履歴削除** | 全バージョンをカスケード削除 | - | ✅ |

> **MVP**: Storageファイルの削除のみ
> **v3**: DB追加後、メタデータ・バージョン履歴も削除
```

---

## 1.14 セクション3.8 PlantUMLコード削除処理（Line 1809-1820）

**現在の記述:**
```plantuml
|Supabase|
:メタデータ削除（Postgres）;
note right
  RLS適用
  所有権検証
end note
:バージョン履歴削除\n（カスケード）;
:Storageファイル削除;
note right
  source.puml / source.json
  preview_N.svg（全件）
end note
```

**変更後:**
```plantuml
|Supabase|
:Storageファイル削除;
note right
  {diagram_name}.puml / .excalidraw.json
  {diagram_name}.preview.svg
  Storage Policy適用
end note
```

---

## 1.15 セクション3.8 削除フローテーブル（Line 1848-1860）

**現在の記述:**
```markdown
| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
...
| 6 | メタデータ削除（RLS適用） | Supabase | 失敗時: エラー通知 |
| 7 | バージョン履歴削除（カスケード） | Supabase | - |
| 8 | Storageファイル削除 | Supabase | - |
...
```

**変更後:**
```markdown
| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
...
| 6 | Storageファイル削除（Policy適用） | Supabase | 失敗時: エラー通知 |
| 7 | 図表一覧を更新 | Frontend Service | - |
| 8 | 完了通知表示 | Frontend Service | - |
```

---

## 1.16 セクション3.8 削除確認ダイアログ（Line 1861-1867）

**現在の記述:**
```markdown
### 削除確認ダイアログの内容

| 図表タイプ | 表示メッセージ |
|-----------|---------------|
| **PlantUML** | 「この図表を削除しますか？」<br>「削除すると復元できません」<br>「N件のバージョン履歴も削除されます」 |
| **Excalidraw** | 「この図表を削除しますか？」<br>「削除すると復元できません」 |
```

**変更後:**
```markdown
### 削除確認ダイアログの内容（MVP）

| 図表タイプ | 表示メッセージ |
|-----------|---------------|
| **共通** | 「この図表を削除しますか？」<br>「削除すると復元できません」 |

> **v3追加**: バージョン管理実装後、「N件のバージョン履歴も削除されます」を表示
```

---

## 1.17 技術仕様テーブル（Line 1479-1491）

**現在の記述:**
```markdown
| 項目 | PlantUML | Excalidraw |
|------|---------|-----------|
...
| **ソースファイル** | `source.puml`（複数@startuml可） | `source.json` |
| **プレビューファイル** | `preview_N.svg`（図の数だけ） | `preview_0.svg`（1ファイル） |
| バージョン管理 | SHA-256ハッシュ | なし |
...
```

**変更後:**
```markdown
| 項目 | PlantUML | Excalidraw |
|------|---------|-----------|
...
| **ソースファイル** | `{name}.puml` | `{name}.excalidraw.json` |
| **プレビューファイル** | `{name}.preview.svg` | `{name}.preview.svg` |
| バージョン管理 | v3で実装（SHA-256ハッシュ） | v3で実装 |
...
```

---

## 1.18 マイクロサービス一覧（Line 1896-1904）

**現在の記述:**
```markdown
| **PlantUML Service** | node-plantuml実行、検証、SVG/PNG/PDF生成、バージョン管理 | 3.1, 3.2, 3.6, 3.7 |
...
| **Excalidraw Service** | JSON保存、SVG/PNG/PDF変換、バージョン管理 | 3.3, 3.6, 3.7, 3.8 |
```

**変更後:**
```markdown
| **PlantUML Service** | node-plantuml実行、検証、SVG/PNG/PDF生成、バージョン管理（v3） | 3.1, 3.2, 3.6, 3.7(v3) |
...
| **Excalidraw Service** | JSON生成、SVG/PNG/PDF変換、バージョン管理（v3） | 3.3, 3.6, 3.7(v3), 3.8 |
```

---

## 1.19 セクション3.6.1.1 PlantUML保存フローテーブル（Line 1236-1253）

**現在の記述:**
```markdown
| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | 「保存」クリック | エンドユーザー | - |
| 2 | 現在のソースコード取得 | Frontend Service | - |
| 3 | PlantUML構文検証 | PlantUML Service | 構文エラー: エラー箇所ハイライト |
| 4 | SHA-256ハッシュ生成 | PlantUML Service | - |
| 5 | バージョン情報作成 | PlantUML Service | - |
| 6 | プレビューSVG生成 | PlantUML Service | 生成失敗: エラー通知 |
| 7 | メタデータ・ソース・プレビュー保存 | Supabase | 保存失敗: リトライ |
| 8 | 用語チェック（AI） | AI Service | タイムアウト: 保存は継続 |
| 9 | 保存完了通知 | Frontend Service | - |
```

**変更後:**
```markdown
| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | 「保存」クリック | エンドユーザー | - |
| 2 | 現在のソースコード取得 | Frontend Service | - |
| 3 | PlantUML構文検証 | PlantUML Service | 構文エラー: エラー箇所ハイライト |
| 4 | プレビューSVG生成 | PlantUML Service | 生成失敗: エラー通知 |
| 5 | ファイル保存（Storage） | Supabase | 保存失敗: リトライ |
| 6 | 用語チェック（AI） | AI Service | タイムアウト: 保存は継続 |
| 7 | 保存完了通知 | Frontend Service | - |

> **削除**: SHA-256ハッシュ生成、バージョン情報作成（v3で追加）
> **変更**: メタデータ・ソース・プレビュー保存 → ファイル保存（Storage）
```

---

## 1.20 セクション3.6.1.2 Excalidraw保存フローテーブル（Line 1324-1334）

**現在の記述:**
```markdown
| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | 「保存」クリック | エンドユーザー | - |
| 2 | Excalidraw状態取得 | Frontend Service | - |
| 3 | JSON生成 | Excalidraw Service | 生成失敗: エラー通知 |
| 4 | プレビューSVG生成 | Excalidraw Service | - |
| 5 | メタデータ・ソース・プレビュー保存 | Supabase | 保存失敗: リトライ |
| 6 | 保存完了通知 | Frontend Service | - |
```

**変更後:**
```markdown
| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | 「保存」クリック | エンドユーザー | - |
| 2 | Excalidraw状態取得 | Frontend Service | - |
| 3 | JSON生成 | Excalidraw Service | 生成失敗: エラー通知 |
| 4 | プレビューSVG生成 | Excalidraw Service | - |
| 5 | ファイル保存（Storage） | Supabase | 保存失敗: リトライ |
| 6 | 保存完了通知 | Frontend Service | - |

> **変更**: メタデータ・ソース・プレビュー保存 → ファイル保存（Storage）
```

---

# 2. コンテキスト図（3箇所）

**ファイル**: `docs/proposals/PlantUML_Studio_コンテキスト図_20251130.md`

---

## 2.1 Supabaseコメント説明（Line 91-98）

**現在の記述:**
```plantuml
'--------------------------------------------------
' 外部システム: Supabase
' - BaaS（Backend as a Service）
' - Postgres: メタデータ、プロジェクト、用語集
' - Storage: PlantUMLファイル、画像
' - pgvector: RAG用ベクトル検索
' - Auth: 認証・認可（OAuth対応）
' - RLS: Row Level Security
'--------------------------------------------------
```

**変更後:**
```plantuml
'--------------------------------------------------
' 外部システム: Supabase
' - BaaS（Backend as a Service）
' - MVP: Storage + Auth のみ（DBテーブルなし）
' - v3: Postgres追加（メタデータ、検索インデックス）
' - Storage: 図表ファイル、プレビュー画像
' - pgvector: RAG用ベクトル検索（v3）
' - Auth: 認証・認可（OAuth対応）
' - Storage Policy: 所有権制御
'--------------------------------------------------
```

---

## 2.2 Supabaseラベル（Line 99）

**現在の記述:**
```plantuml
System_Ext(supabase, "Supabase", "Postgres (RLS)\nStorage\npgvector\nAuth")
```

**変更後:**
```plantuml
System_Ext(supabase, "Supabase", "Storage (Policy)\nAuth\n[v3: Postgres, pgvector]")
```

---

## 2.3 外部システム説明テーブル（Line 182-184）

**現在の記述:**
```markdown
| **Supabase** | BaaS | Postgres(RLS)、Storage、**pgvector(RAG)**、Auth | 全サービス |
```

**変更後:**
```markdown
| **Supabase** | BaaS | **MVP**: Storage(Policy)、Auth / **v3**: Postgres(RLS)、pgvector(RAG) | 全サービス |
```

---

# 3. ユースケース図（4箇所）

**ファイル**: `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md`

---

## 3.1 UC一覧テーブル 3-7, 3-8（Line 735-736）

**現在の記述:**
```markdown
| 3-7 | バージョン履歴を確認する | 過去バージョン一覧表示 | 共通 | エンドユーザー | - |
| 3-8 | 過去バージョンを復元する | 指定バージョンに戻す | 共通 | エンドユーザー | - |
```

**変更後:**
```markdown
| 3-7 | バージョン履歴を確認する | 過去バージョン一覧表示 **（v3）** | 共通 | エンドユーザー | - |
| 3-8 | 過去バージョンを復元する | 指定バージョンに戻す **（v3）** | 共通 | エンドユーザー | - |
```

---

## 3.2 MVP優先度リスト（Line 799-804）

**現在の記述:**
```markdown
### MVP（Phase 1）

| カテゴリ | ユースケース | 理由 |
|---------|-------------|------|
| 1. 認証 | 1-1, 1-2 | 基本機能 |
| 2. プロジェクト | 2-1, 2-2, 2-3, 2-4 | 基本機能 |
| 3. 図表操作（PlantUML・Excalidraw） | 3-1〜3-9 | コア機能 |
| 4. AI機能 | 4-1 | 差別化機能 |
```

**変更後:**
```markdown
### MVP（Phase 1）

| カテゴリ | ユースケース | 理由 |
|---------|-------------|------|
| 1. 認証 | 1-1, 1-2 | 基本機能 |
| 2. プロジェクト | 2-1, 2-2, 2-3, 2-4 | 基本機能 |
| 3. 図表操作（PlantUML・Excalidraw） | 3-1〜3-6, 3-9 | コア機能 |
| 4. AI機能 | 4-1 | 差別化機能 |
```

---

## 3.3 Phase 2以降リスト（Line 806-812）

**現在の記述:**
```markdown
### Phase 2以降

| カテゴリ | ユースケース | 理由 |
|---------|-------------|------|
| 3. 図表操作（PlantUML・Excalidraw） | 3-10, 3-11 | 学習支援機能 |
| 4. AI機能 | 4-2 | 拡張機能 |
| 5. 管理機能 | 5-1〜5-5 | 運用機能 |
```

**変更後:**
```markdown
### Phase 2以降

| カテゴリ | ユースケース | 理由 |
|---------|-------------|------|
| 3. 図表操作（PlantUML・Excalidraw） | 3-10, 3-11 | 学習支援機能 |
| 4. AI機能 | 4-2 | 拡張機能 |
| 5. 管理機能 | 5-1〜5-5 | 運用機能 |

### v3（DB追加後）

| カテゴリ | ユースケース | 理由 |
|---------|-------------|------|
| 3. 図表操作 | 3-7, 3-8 | バージョン管理（DB必須） |
```

---

## 3.4 ユースケース数サマリ（Line 817-825）

**現在の記述:**
```markdown
## ユースケース数サマリ

| カテゴリ | 件数 | MVP | Phase 2 |
|---------|------|-----|---------|
| 1. 認証 | 2 | 2 | - |
| 2. プロジェクト管理 | 4 | 4 | - |
| 3. 図表操作（PlantUML・Excalidraw） | 11 | 9 | 2 |
| 4. AI機能 | 2 | 1 | 1 |
| 5. 管理機能 | 5 | - | 5 |
| **合計** | **24** | **16** | **8** |
```

**変更後:**
```markdown
## ユースケース数サマリ

| カテゴリ | 件数 | MVP | Phase 2 | v3 |
|---------|------|-----|---------|-----|
| 1. 認証 | 2 | 2 | - | - |
| 2. プロジェクト管理 | 4 | 4 | - | - |
| 3. 図表操作（PlantUML・Excalidraw） | 11 | 7 | 2 | 2 |
| 4. AI機能 | 2 | 1 | 1 | - |
| 5. 管理機能 | 5 | - | 5 | - |
| **合計** | **24** | **14** | **8** | **2** |

> **v3 UC**: 3-7（バージョン履歴確認）、3-8（バージョン復元）はDB追加後に実装
```

---

# 依存関係チェックリスト

修正時の依存関係を以下に整理:

## 用語の統一

| 用語 | 統一表記 | 使用箇所 |
|------|---------|---------|
| Storage Policy | `Storage Policy` | 全ファイル |
| RLS | DBの場合のみ使用、Storageは`Storage Policy` | 業務フロー図、コンテキスト図 |
| バージョン管理 | 「v3で実装」を必ず付記 | 全ファイル |
| ファイルパス | `{project_name}/{diagram_name}.puml` 形式 | 業務フロー図 |

## ドキュメント間の整合性

| 整合性項目 | 業務フロー図 | コンテキスト図 | ユースケース図 |
|-----------|:----------:|:------------:|:------------:|
| MVP: Storage Only | ✓ 1.1-1.9, 1.19-1.20 | ✓ 2.1-2.3 | - |
| v3: バージョン管理 | ✓ 1.10-1.12, 1.17 | - | ✓ 3.1-3.4 |
| v3: DB追加 | ✓ 1.13-1.14 | ✓ 2.1-2.3 | ✓ 3.3 |
| UC 3-7, 3-8 → v3 | ✓ 1.10 | - | ✓ 3.1-3.4 |
| 保存フローテーブル | ✓ 1.19-1.20 | - | - |

---

# 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|----------|
| 1.0 | 2025-12-06 | 初版作成 |
| 1.1 | 2025-12-06 | 1.19, 1.20追加（保存フローテーブル）、依存関係チェックリスト更新 |
