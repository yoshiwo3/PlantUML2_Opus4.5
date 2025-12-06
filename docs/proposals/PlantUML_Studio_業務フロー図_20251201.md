# PlantUML Studio - 業務フロー図

**作成日**: 2025-12-01
**基準ドキュメント**:
- PlantUML_Studio_コンテキスト図_20251130.md
- PlantUML_Studio_ユースケース図_20251130.md
**記法**: PlantUML（アクティビティ図・スイムレーン形式）

---

## 図表構成

| 図 | 内容 | 関連ユースケース |
|----|------|-----------------|
| 3.1 | PlantUML 図表作成フロー | UC 3-1〜3-4 |
| 3.2 | PlantUML AI支援フロー | UC 4-1, 4-2 |
| 3.3 | Excalidraw ワイヤーフレーム作成フロー | UC 3-1〜3-3（Excalidraw） |
| 3.4 | 認証フロー | UC 1-1, 1-2 |
| 3.5 | プロジェクト管理フロー | UC 2-1, 2-2, 2-3, 2-4 |
| 3.6 | 保存・エクスポートフロー | UC 3-5, 3-6 |
| 3.7 | バージョン管理フロー | UC 3-7, 3-8 |
| 3.8 | 図表削除フロー | UC 3-9 |

---

## 業務フロー図の表現について

### API Gatewayの扱い

本業務フロー図では、**論理的な業務フロー**を表現するため、API Gatewayを図中に明示していません。

**実際のアーキテクチャ**（コンテキスト図参照）:
```
Frontend Service → API Gateway → PlantUML Service / AI Service / Excalidraw Service
```

**業務フロー図での表現**:
```
Frontend Service → PlantUML Service / AI Service / Excalidraw Service
（API Gatewayは暗黙的に介在）
```

| 項目 | 説明 |
|------|------|
| **API Gatewayの役割** | 認証検証、ルーティング、レート制限 |
| **図中の扱い** | 暗黙的に存在（業務フローの可読性を優先） |
| **参照** | `PlantUML_Studio_コンテキスト図_20251130.md` |

> **注意**: Frontend Serviceから各バックエンドサービス（PlantUML Service、AI Service、Excalidraw Service）への通信は、すべてAPI Gatewayを経由します。

---

## 3.1 PlantUML 図表作成フロー

**関連ユースケース**: UC 3-1 図表を作成する, UC 3-2 テンプレートを選択する, UC 3-3 図表を編集する, UC 3-4 図表をプレビューする, UC 3-5 図表を保存する

```plantuml
@startuml business_flow_create
title 業務フロー図 - PlantUML 図表作成

|エンドユーザー|
start
:ログイン;

|Frontend Service|
:認証処理 (Supabase Auth);
:ダッシュボード表示;

|エンドユーザー|
if (作成方法を選択) then (テンプレート)
  :"「テンプレートから作成」をクリック";

  |Frontend Service|
  :テンプレート一覧表示;

  |エンドユーザー|
  :テンプレートを選択;

  |Frontend Service|
  :テンプレートコード適用;

else (新規作成)
  |エンドユーザー|
  :"「新規作成」をクリック";

  |Frontend Service|
  :空のエディタを開く\n(Monaco Editor);
endif

|エンドユーザー|
:PlantUMLコードを編集\n(Monaco Editor);

|Frontend Service|
:入力待機処理（500ms）;

|PlantUML Service|
:node-plantuml実行\n(Java 17 + Graphviz);

while (構文エラー?) is (あり)
  :stderrからエラー抽出;
  :エラー行番号特定;
  :AI自動修正\n(Context7 + OpenRouter API);
  note right
    1. AI Service: エラー解析
    2. Context7: 構文情報取得
    3. AI Service: 修正コード生成
    **最大5回リトライ**
  end note
  :node-plantuml再実行;
  if (構文エラー?) then (なし)
    break
  else (あり)
    if (リトライ上限?) then (到達)
      |Frontend Service|
      :エラー内容と回復オプションを表示;

      |エンドユーザー|
      :回復オプションを選択;
      floating note left
        **5回失敗時の提案:**
        ----
        1. 意図を説明して再試行
        2. 前のバージョンに戻す
        3. AIチャットで相談
      end note
      detach
    else (未到達)
    endif
  endif
endwhile (なし)

:SVG/PNG/PDF生成;

|Frontend Service|
:プレビュー更新;
:処理時間表示;
note right
  目標: 500ms以内
end note

|エンドユーザー|
:"「保存」をクリック";

|PlantUML Service|
:バージョン保存\n(SHA-256ハッシュ);

|Supabase|
:メタデータ保存 (Postgres);

stop

@enduml
```

### 作成方法

| 方法 | 説明 | ユースケース |
|------|------|-------------|
| **新規作成** | 空のエディタから開始 | UC 3-1 |
| **テンプレートから作成** | テンプレート一覧から選択して開始 | UC 3-1, UC 3-2 |

### 検証処理の詳細

| 項目 | 仕様 |
|------|------|
| 入力待機 | 500ms（入力停止後に検証実行） |
| 検証エンジン | node-plantuml + Java 17 + Graphviz |
| AI自動修正 | 最大5回リトライ |
| 目標レスポンス | 500ms以内 |
| エラー表示 | Monaco Editorのマーカー機能 |

### 重要な技術仕様

> **注意**: PlantUML Server API（外部）は使用しない。node-plantuml（内部）でプライバシー保護。

---

## 3.2 PlantUML AI支援フロー

**関連ユースケース**: UC 4-1 AI Question-Startで図表を生成する, UC 4-2 目的別AIチャットを利用する

```plantuml
@startuml business_flow_ai
title 業務フロー図 - PlantUML AI支援

|エンドユーザー|
start
:AIチャットパネルを開く;
:質問を入力;
note right
  例：
  - 「このエラーの意味は？」
  - 「クラス図に継承を追加して」
  - 「シーケンス図に変換して」
end note

|Frontend Service|
:質問をAI Serviceへ送信;

|AI Service|
:コンテキスト解析;
:PlantUML構文知識参照;

if (Context7参照必要?) then (はい)
  |Context7 MCP|
  :最新構文情報取得;
endif

|AI Service|
:LLM呼び出し\n(OpenRouter API);
:回答生成;
:コード修正提案生成;

|Frontend Service|
:回答をストリーミング表示;
:インライン提案を表示\n(Monaco Editor);

|エンドユーザー|
if (修正を適用?) then (はい)
  :"「適用」ボタンをクリック";
else (いいえ)
  :手動で編集続行;
endif

|Frontend Service|
:入力待機処理（500ms）;

|PlantUML Service|
:node-plantuml実行\n(Java 17 + Graphviz);

while (構文エラー?) is (あり)
  :stderrからエラー抽出;
  :エラー行番号特定;
  :AI自動修正\n(Context7 + OpenRouter API);
  note right
    1. AI Service: エラー解析
    2. Context7: 構文情報取得
    3. AI Service: 修正コード生成
    **最大5回リトライ**
  end note
  :node-plantuml再実行;
  if (構文エラー?) then (なし)
    break
  else (あり)
    if (リトライ上限?) then (到達)
      |Frontend Service|
      :エラー内容と回復オプションを表示;

      |エンドユーザー|
      :回復オプションを選択;
      floating note left
        **5回失敗時の提案:**
        ----
        1. 意図を説明して再試行
        2. 前のバージョンに戻す
        3. AIチャットで相談
      end note
      detach
    else (未到達)
    endif
  endif
endwhile (なし)

:SVG/PNG/PDF生成;

|Frontend Service|
:プレビュー更新;

stop

@enduml
```

### 質問例

| 質問タイプ | 例 |
|-----------|-----|
| エラー解説 | 「このエラーの意味は？」 |
| 構文追加 | 「クラス図に継承を追加して」 |
| 図表変換 | 「シーケンス図に変換して」 |
| ベストプラクティス | 「この図表を改善するには？」 |

### AI提案適用後の処理

AI提案を適用後（または手動編集後）、3.1と同じ検証・エラー修正ループが実行される：

| 項目 | 仕様 |
|------|------|
| 入力待機 | 500ms（入力停止後に検証実行） |
| 検証エンジン | node-plantuml + Java 17 + Graphviz |
| AI自動修正 | Context7 + OpenRouter API（最大5回リトライ） |
| 出力形式 | SVG/PNG/PDF |

### AIチャット機能要件

| 機能 | 説明 |
|------|------|
| **ファイル添付** | 各種ファイルをチャットに添付可能（下表参照） |
| **コード共有** | 現在のPlantUMLコードを自動的にコンテキストとして送信 |
| **マルチモーダル** | 画像認識対応LLM（GPT-4o, Claude 3.5等）を使用 |
| **ストリーミング** | 回答をリアルタイムで表示 |
| **インライン提案** | Monaco Editorに修正提案を直接表示 |

#### 対応添付ファイル形式

| 種類 | 形式 | 用途 |
|------|------|------|
| **画像** | PNG, SVG, JPG | 図表イメージ、エラースクリーンショット |
| **PlantUML** | .puml | PlantUMLソースコード |
| **テキスト** | .txt, .md | 仕様書、要件定義、メモ |
| **データ** | .json | 設定ファイル、Excalidraw JSON |

---

## 3.3 Excalidrawワイヤーフレーム作成フロー

**関連ユースケース**: UC 3-1 図表を作成する, UC 3-2 テンプレートを選択する, UC 3-3 図表を編集する（Excalidraw）
**技術決定**: TD-015

```plantuml
@startuml business_flow_excalidraw
title 業務フロー図 - Excalidraw ワイヤーフレーム作成

|エンドユーザー|
start
:プロジェクトを開く;

|Frontend Service|
:プロジェクト画面表示;

|エンドユーザー|
:"「ワイヤーフレーム作成」をクリック";

|Frontend Service|
:Excalidrawエディタを開く;
note right
  Dynamic Import（SSR無効化）
  @excalidraw/excalidraw
end note

|エンドユーザー|
if (AI生成を使用?) then (はい)
  :自然言語で画面を説明;
  note right
    例：「ログインフォーム
    - ユーザー名入力欄
    - パスワード入力欄
    - ログインボタン」
  end note

  |AI Service|
  :説明からExcalidraw JSON生成;
  :LLM呼び出し\n(OpenRouter API);
  note right
    中レベルLLM使用
    （GPT-4o-mini / Claude 3.5 Haiku）
    成功率: 80-90%
    トークン消費: 80-100
  end note

  |Frontend Service|
  :作図イメージを表示\n(Excalidraw);

  |エンドユーザー|
  while (イメージ確認) is (修正必要)
    :図形を操作・編集\n(Excalidraw GUI);
    :AIチャットで修正を依頼;

    |AI Service|
    :作図と会話を解析;
    :Excalidraw JSON再生成;

    |Frontend Service|
    :作図イメージを更新;

    |エンドユーザー|
  endwhile (OK)

else (いいえ)
  |エンドユーザー|
  :図形を描画・編集\n(Excalidraw GUI);
  note right
    ローファイワイヤーフレーム
    手書き風スタイル
    グレースケールモード
  end note
endif

|Frontend Service|
:リアルタイムプレビュー;

|エンドユーザー|
:"「保存」をクリック";

|Excalidraw Service|
:Excalidraw JSON保存;
:SVG/PNG/PDF変換;

|Supabase|
:Storage保存\n(JSON/画像);

stop

@enduml
```

### 編集方法

| 方法 | 説明 | 利用タイミング |
|------|------|---------------|
| **AI生成** | 自然言語からJSON生成 | 初期作成時 |
| **GUI編集** | Excalidraw上で図形を操作 | 微調整・手動作成時 |
| **AIチャット** | 作図を見せながら会話で修正依頼 | AI生成後の修正時 |

### AI生成の仕様

| 項目 | 仕様 |
|------|------|
| 使用LLM | GPT-4o-mini / Claude 3.5 Haiku（中レベル） |
| 成功率 | 80-90% |
| トークン消費 | 80-100 |
| 出力形式 | Excalidraw JSON |

### イテレーティブ修正フロー

AI生成後、ユーザーは以下を繰り返して作図を完成させる：

1. **作図イメージを確認**
2. **GUI編集**: Excalidraw上で図形を操作・編集
3. **AIチャット**: 編集した作図をAIに見せながら修正を依頼
4. **AI再生成**: AIが作図と会話を解析してJSON再生成
5. **イメージ更新**: 新しい作図が表示される
6. **満足するまで繰り返し**

### AIチャット機能要件

| 機能 | 説明 |
|------|------|
| **ファイル添付** | 各種ファイルをチャットに添付可能（下表参照） |
| **自動添付** | 現在の作図を自動的にコンテキストとして送信 |
| **マルチモーダル** | 画像認識対応LLM（GPT-4o, Claude 3.5等）を使用 |
| **ストリーミング** | 回答をリアルタイムで表示 |

#### 対応添付ファイル形式

| 種類 | 形式 | 用途 |
|------|------|------|
| **画像** | PNG, SVG, JPG | ワイヤーフレーム、参考UI画像 |
| **テキスト** | .txt, .md | 仕様書、要件定義、メモ |
| **データ** | .json | Excalidraw JSON、設定ファイル |
| **PlantUML** | .puml | 参考図表のソースコード |

### 自然言語入力例

```
ログインフォーム
- ユーザー名入力欄
- パスワード入力欄
- ログインボタン
- 「パスワードを忘れた方」リンク
```

### Excalidraw実装の注意点

```typescript
// SSR無効化必須（Dynamic Import）
const Excalidraw = dynamic(
  () => import('@excalidraw/excalidraw').then(mod => mod.Excalidraw),
  { ssr: false }
)
```

### ワイヤーフレームスタイル

| スタイル | 説明 |
|---------|------|
| ローファイ | 手書き風、概念検証向け |
| グレースケール | 色に依存しないUI設計 |
| テンプレート | 基本UIパーツ（ボタン、フォーム、ナビ等） |

---

## 3.4 認証フロー

**関連ユースケース**: UC 1-1 ログインする, UC 1-2 ログアウトする

```plantuml
@startuml business_flow_auth
title 業務フロー図 - 認証

|エンドユーザー|
start
:アプリケーションにアクセス;

|Frontend Service|
if (セッション有効?) then (はい)
  :ダッシュボード表示;
  stop
else (いいえ)
  :ログイン画面表示;
endif

|エンドユーザー|
:OAuthプロバイダーを選択;
note right
  **対応プロバイダー**
  - GitHub
  - Google
  ※Email/Password認証は不使用
end note

|Frontend Service|
:OAuthプロバイダーにリダイレクト;

|OAuthプロバイダー|
:認証画面表示;

|エンドユーザー|
:認証情報入力・許可;

|OAuthプロバイダー|
:認証コード発行;
:コールバックURLにリダイレクト;

|Frontend Service|
:認証コード受信;

|Supabase Auth|
:認証コード検証;
:アクセストークン発行;
:セッション作成;

|Frontend Service|
if (認証成功?) then (はい)
  :ダッシュボード表示;
else (いいえ)
  :エラーメッセージ表示;
  :ログイン画面に戻る;
  stop
endif

|エンドユーザー|
:アプリケーションを使用;

fork
  :セッション期限切れ;

  |Frontend Service|
  :自動ログアウト;
  :ログイン画面にリダイレクト;
  stop
fork again
  :ログアウトボタンをクリック;

  |Frontend Service|
  :ログアウトリクエスト送信;

  |Supabase Auth|
  :セッション終了;

  |Frontend Service|
  :ログイン画面にリダイレクト;
  stop
end fork

@enduml
```

### 認証方式

| 方式 | 説明 | 対応状況 |
|------|------|:--------:|
| **GitHub OAuth** | GitHubアカウントで認証 | ✅ |
| **Google OAuth** | Googleアカウントで認証 | ✅ |
| Email/Password | メールアドレスとパスワードで認証 | ❌ 不使用 |

### ログインフロー

| ステップ | 処理内容 | 担当 |
|---------|---------|------|
| 1 | アプリアクセス | エンドユーザー |
| 2 | セッション確認 | Frontend Service |
| 3 | OAuthプロバイダー選択 | エンドユーザー |
| 4 | OAuthリダイレクト | Frontend Service |
| 5 | 認証・許可 | OAuthプロバイダー |
| 6 | コールバック処理 | Frontend Service |
| 7 | トークン検証・セッション作成 | Supabase Auth |
| 8 | ダッシュボード表示 | Frontend Service |

### ログアウトフロー

| ステップ | 処理内容 | 担当 |
|---------|---------|------|
| 1 | ログアウトボタンクリック | エンドユーザー |
| 2 | ログアウトリクエスト | Frontend Service |
| 3 | セッション終了 | Supabase Auth |
| 4 | ログイン画面リダイレクト | Frontend Service |

### セッション管理

| 項目 | 仕様 |
|------|------|
| セッション保持 | Supabase Auth（JWT） |
| 自動更新 | アクセストークン自動リフレッシュ |
| 期限切れ | 自動ログアウト → ログイン画面 |

---

## 3.5 プロジェクト管理フロー

**関連ユースケース**: UC 2-1 プロジェクトを作成する, UC 2-2 プロジェクトを選択する, UC 2-3 プロジェクトを編集する, UC 2-4 プロジェクトを削除する

### 設計思想・利用想定

#### プロジェクトの定義

PlantUML Studioにおける「プロジェクト」は**図表をグループ化する単位**である。
ユーザーは複数のプロジェクトを持ち、各プロジェクト内で複数の図表を管理する。

```
ユーザー（認証済み）
  ├─ プロジェクトA
  │    ├─ 図表1（シーケンス図）
  │    ├─ 図表2（クラス図）
  │    └─ 図表3（ユースケース図）
  ├─ プロジェクトB
  │    ├─ 図表4（コンポーネント図）
  │    └─ 図表5（ER図）
  └─ プロジェクトC
       └─ ...
```

**データモデル上の関係**:
- ユーザー : プロジェクト = 1 : N（1人のユーザーが複数プロジェクトを所有）
- プロジェクト : 図表 = 1 : N（1つのプロジェクトに複数図表を格納）
- プロジェクト削除時は配下の図表もカスケード削除

#### 想定ユーザーペルソナ

| ペルソナ | 特徴 | 主な利用目的 |
|---------|------|-------------|
| **システムエンジニア** | 企業所属、複数案件を担当 | 設計ドキュメント作成、レビュー資料 |
| **フリーランス開発者** | 複数クライアント、個人作業 | 顧客別の提案・設計資料管理 |
| **テックリード/アーキテクト** | チームを牽引、設計方針を決定 | アーキテクチャ図、技術ドキュメント |
| **学生・学習者** | PlantUML初心者〜中級者 | 学習用サンプル、課題提出用 |
| **技術ライター** | ドキュメント専門 | 技術書・ブログ用の図表作成 |

#### 想定利用ケース

##### ケース1: システム開発プロジェクト単位

| 項目 | 内容 |
|------|------|
| **シナリオ** | 受託開発でECサイトリニューアル案件を担当 |
| **プロジェクト名** | 「ECサイトリニューアル_2024」 |
| **含まれる図表** | ユースケース図、シーケンス図、クラス図、ER図、画面遷移図、コンポーネント図 |
| **作成期間** | 数ヶ月（設計フェーズ） |
| **図表数目安** | 10〜30枚 |

##### ケース2: 顧客・クライアント単位

| 項目 | 内容 |
|------|------|
| **シナリオ** | フリーランスとして複数クライアントの案件を並行管理 |
| **プロジェクト名** | 「A社_基幹システム」「B社_Webアプリ」「C社_提案資料」 |
| **含まれる図表** | 各クライアント向けの設計図・提案図 |
| **作成期間** | 継続的（クライアントとの契約期間） |
| **図表数目安** | 各プロジェクト5〜20枚 |

##### ケース3: ドキュメント種別単位

| 項目 | 内容 |
|------|------|
| **シナリオ** | 大規模プロジェクトで設計書をフェーズごとに分割管理 |
| **プロジェクト名** | 「基本設計書」「詳細設計書」「テスト設計書」 |
| **含まれる図表** | 各設計フェーズに対応する図表群 |
| **作成期間** | 各フェーズ1〜2ヶ月 |
| **図表数目安** | 各プロジェクト10〜50枚 |

##### ケース4: 学習・練習用

| 項目 | 内容 |
|------|------|
| **シナリオ** | PlantUML初心者が図表作成を学習 |
| **プロジェクト名** | 「シーケンス図練習」「クラス図サンプル」「UML学習」 |
| **含まれる図表** | 各図表タイプのサンプル・練習用 |
| **作成期間** | 継続的（学習ペースに応じて） |
| **図表数目安** | 各プロジェクト3〜10枚 |

##### ケース5: バージョン・リリース単位

| 項目 | 内容 |
|------|------|
| **シナリオ** | 自社プロダクトの各バージョン設計を管理 |
| **プロジェクト名** | 「ProductX_v1.0」「ProductX_v2.0」「ProductX_v3.0」 |
| **含まれる図表** | 各バージョンのアーキテクチャ・設計変更図 |
| **作成期間** | リリースサイクルに応じて |
| **図表数目安** | 各プロジェクト5〜15枚 |

#### 典型的なワークフロー

```
【初回利用時】
1. ログイン（OAuth認証）
2. プロジェクト作成（案件名を入力）
3. 図表を作成・編集
4. プレビュー確認
5. 保存

【継続利用時】
1. ログイン
2. プロジェクト選択（前回の続き or 別案件）
3. 図表を選択 or 新規作成
4. 編集・プレビュー
5. 保存

【案件完了時】
1. 必要に応じてエクスポート
2. プロジェクトを保持（アーカイブ）or 削除
```

#### UX設計のポイント

| ポイント | 説明 | 具体的な実現方法 |
|---------|------|-----------------|
| **整理性** | 図表が増えても混乱しない | プロジェクト単位でのグループ化、一覧表示 |
| **切替容易性** | 複数案件を並行して作業可能 | ワンクリックでプロジェクト切替、前回選択の記憶（Supabase） |
| **直感性** | 迷わず操作できる | CRUDの明確なUI、確認ダイアログでの誤操作防止 |
| **安全性** | 意図しないデータ損失を防ぐ | 削除時の警告表示、カスケード削除の明示 |
| **拡張性** | 将来機能追加に対応 | プロジェクト単位での共有・エクスポート・テンプレート化を想定 |
| **検索性** | 目的の図表を素早く見つける | プロジェクト内図表一覧、将来的に検索機能追加 |

#### 将来的な拡張（Phase 2以降）

| 機能 | 説明 | フェーズ |
|------|------|:--------:|
| **プロジェクト共有** | 他ユーザーとプロジェクトを共有 | Phase 2 |
| **プロジェクトテンプレート** | 既存プロジェクトをテンプレート化 | Phase 2 |
| **プロジェクト一括エクスポート** | 全図表をまとめてエクスポート | Phase 2 |
| **プロジェクトアーカイブ** | 削除せず非表示化（復元可能） | Phase 2 |
| **プロジェクト検索** | 名前・作成日での絞り込み | Phase 2 |
| **プロジェクトタグ** | タグによる分類・フィルタリング | Phase 3 |

### 前提条件・事後条件

| 種別 | 条件 |
|------|------|
| **前提条件** | ユーザーが認証済みであること（UC 1-1完了） |
| **事後条件** | プロジェクト情報がSupabaseに永続化される |

```plantuml
@startuml business_flow_project_management_overview
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - プロジェクト管理（概要）

|エンドユーザー|
start
:プロジェクト管理画面へ遷移;

|Frontend Service|
:プロジェクト一覧取得\n（Supabase RLS適用）;
:一覧表示;

|エンドユーザー|
switch (操作を選択)
case (新規作成\nUC 2-1)
  :プロジェクト名を入力;
  |Frontend Service|
  :作成＆結果表示;
  detach
case (選択\nUC 2-2)
  |エンドユーザー|
  :プロジェクトをクリック;
  |Frontend Service|
  #palegreen:エディタ画面へ遷移;
  detach
case (編集\nUC 2-3)
  |エンドユーザー|
  :編集をクリック;
  |Frontend Service|
  #lightblue:名前変更→保存;
  note right: 詳細は下図参照
  detach
case (削除\nUC 2-4)
  |エンドユーザー|
  :削除をクリック;
  |Frontend Service|
  #lightyellow:確認→削除実行;
  note right: 詳細は下図参照
  detach
case (戻る)
  |エンドユーザー|
  :「戻る」をクリック;
  |Frontend Service|
  :ダッシュボードへ遷移;
  detach
endswitch

@enduml
```

#### 3.5.1 プロジェクト作成フロー詳細（UC 2-1）

```plantuml
@startuml business_flow_project_create_detail
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - プロジェクト作成（詳細）

|エンドユーザー|
start
:「新規作成」ボタンをクリック;

|Frontend Service|
:プロジェクト名入力\nダイアログ表示;

|エンドユーザー|
:プロジェクト名を入力;

|Frontend Service|
if (バリデーション?) then (OK)
  :Supabaseに作成リクエスト;
  note right
    RLS適用
    同名チェック
  end note
  if (作成成功?) then (はい)
    :一覧更新;
    #palegreen:完了メッセージ表示;
    stop
  else (エラー)
    #mistyrose:エラーメッセージ表示;
    stop
  endif
else (NG)
  #mistyrose:バリデーションエラー表示;
  stop
endif

@enduml
```

#### 3.5.2 プロジェクト選択フロー詳細（UC 2-2）

```plantuml
@startuml business_flow_project_select_detail
skinparam ActivityFontSize 12

title 業務フロー図 - プロジェクト選択（詳細）

|エンドユーザー|
start
:プロジェクトをクリック;

|Frontend Service|
:現在のプロジェクトを切替;
:選択状態を保存\n（Supabase）;
#palegreen:エディタ画面へ遷移;
note right
  選択したプロジェクトの
  図表一覧を表示
end note
stop

@enduml
```

#### 3.5.3 プロジェクト編集フロー詳細（UC 2-3）

```plantuml
@startuml business_flow_project_edit_detail
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - プロジェクト編集（詳細）

|エンドユーザー|
start
:編集ボタンをクリック;

|Frontend Service|
:名前変更ダイアログ表示\n（現在の名前をプリセット）;

|エンドユーザー|
:新しいプロジェクト名を入力;

|Frontend Service|
if (入力バリデーション) then (NG)
  #pink:エラー: 入力値が不正;
  stop
else (OK)
  :Supabaseに更新リクエスト;
  |Supabase|
  if (同名チェック) then (重複)
    |Frontend Service|
    #pink:エラー: 同名プロジェクトが存在;
    stop
  else (OK)
    :プロジェクト名更新\n（RLS適用）;
    |Frontend Service|
    #palegreen:一覧更新・完了表示;
    stop
  endif
endif

@enduml
```

#### 3.5.4 プロジェクト削除フロー詳細（UC 2-4）

```plantuml
@startuml business_flow_project_delete_detail
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - プロジェクト削除（詳細）

|エンドユーザー|
start
:削除ボタンをクリック;

|Frontend Service|
#lightyellow:確認ダイアログ表示;
note right
  配下図表の警告
  「このプロジェクトを削除すると
  　含まれる図表も削除されます」
end note

|エンドユーザー|
if (確認?) then (はい)
  |Frontend Service|
  :削除実行\n（カスケード削除）;
  :一覧更新;
  #palegreen:完了メッセージ表示;
  stop
else (キャンセル)
  |Frontend Service|
  :一覧画面に戻る;
  stop
endif

@enduml
```

#### 3.5.5 戻るフロー詳細

```plantuml
@startuml business_flow_project_back_detail
skinparam ActivityFontSize 12

title 業務フロー図 - 戻る（詳細）

|エンドユーザー|
start
:「戻る」ボタンをクリック;

|Frontend Service|
:現在のプロジェクト選択を解除;
#palegreen:ダッシュボードへ遷移;
note right
  プロジェクト一覧から
  メイン画面に戻る
end note
stop

@enduml
```

### プロジェクト作成フロー（UC 2-1）

| ステップ | 処理内容 | 担当 | エラー処理 |
|---------|---------|------|-----------|
| 1 | 「新規作成」ボタンをクリック | エンドユーザー | - |
| 2 | プロジェクト名入力ダイアログ表示 | Frontend Service | - |
| 3 | プロジェクト名を入力 | エンドユーザー | - |
| 4 | **入力バリデーション** | Frontend Service | エラー時: メッセージ表示 |
| 5 | プロジェクト作成リクエスト | Frontend Service | - |
| 6 | **同名チェック** | Supabase | 重複時: エラー返却 |
| 7 | プロジェクト作成（RLS適用） | Supabase | 失敗時: エラー返却 |
| 8 | 一覧更新・完了メッセージ表示 | Frontend Service | - |

### プロジェクト選択フロー（UC 2-2）

| ステップ | 処理内容 | 担当 | エラー処理 |
|---------|---------|------|-----------|
| 1 | プロジェクトをクリック | エンドユーザー | - |
| 2 | 現在のプロジェクトを切替 | Frontend Service | - |
| 3 | エディタ画面（図表一覧）へ遷移 | Frontend Service | - |

### プロジェクト編集フロー（UC 2-3）

| ステップ | 処理内容 | 担当 | エラー処理 |
|---------|---------|------|-----------|
| 1 | 編集ボタンをクリック | エンドユーザー | - |
| 2 | 名前変更ダイアログ表示（現在値プリセット） | Frontend Service | - |
| 3 | 新しいプロジェクト名を入力 | エンドユーザー | - |
| 4 | **入力バリデーション** | Frontend Service | エラー時: メッセージ表示 |
| 5 | 更新リクエスト送信 | Frontend Service | - |
| 6 | **同名チェック** | Supabase | 重複時: エラー返却 |
| 7 | プロジェクト名更新（RLS適用） | Supabase | 失敗時: エラー返却 |
| 8 | 一覧更新・完了メッセージ表示 | Frontend Service | エラー時: メッセージ表示 |

### プロジェクト削除フロー（UC 2-4）

| ステップ | 処理内容 | 担当 | エラー処理 |
|---------|---------|------|-----------|
| 1 | 削除ボタンをクリック | エンドユーザー | - |
| 2 | 配下の図表数を取得 | Frontend Service | - |
| 3 | 削除確認ダイアログ表示（警告付き） | Frontend Service | - |
| 4 | 削除を確認 or キャンセル | エンドユーザー | キャンセル時: 一覧に戻る |
| 5 | 削除リクエスト送信 | Frontend Service | - |
| 6 | プロジェクト削除（カスケード削除） | Supabase | 失敗時: エラー返却 |
| 7 | 一覧更新・完了メッセージ表示 | Frontend Service | エラー時: メッセージ表示 |

### バリデーションルール

| 項目 | ルール | エラーメッセージ |
|------|--------|----------------|
| 必須チェック | 空文字不可 | 「プロジェクト名を入力してください」 |
| 文字数 | 1〜100文字 | 「100文字以内で入力してください」 |
| 禁止文字 | `< > : " / \ | ? *` | 「使用できない文字が含まれています」 |
| 重複チェック | 同一ユーザー内で一意 | 「同名のプロジェクトが存在します」 |

### プロジェクト属性

| 属性 | 説明 | 必須 | 制約 |
|------|------|:----:|------|
| **名前** | プロジェクト名 | ✅ | 1-100文字、禁止文字なし |
| 作成日時 | 自動設定 | - | UTC |
| 更新日時 | 自動更新 | - | UTC |
| 所有者ID | RLSで自動設定 | - | auth.uid() |

### エラーハンドリング

| エラー種別 | 原因 | 対応 |
|-----------|------|------|
| ネットワークエラー | 通信障害 | 「接続に失敗しました。再試行してください。」 |
| 認証エラー | セッション期限切れ | ログイン画面にリダイレクト |
| バリデーションエラー | 入力値不正 | リアルタイムでエラー表示 |
| 重複エラー | 同名プロジェクト | 「同名のプロジェクトが存在します」 |
| 削除エラー | DB障害等 | 「削除に失敗しました。再試行してください。」 |

---

## 3.6 保存・エクスポートフロー

**関連ユースケース**: UC 3-5 図表を保存する, UC 3-6 図表をエクスポートする

### 設計思想

保存・エクスポート機能は、ユーザーの作業成果を安全に保持し、外部利用を可能にする重要な機能である。

#### 保存機能（UC 3-5）の要件

| 項目 | 仕様 |
|------|------|
| **手動保存** | Ctrl+S または保存ボタン |
| **自動保存** | 30秒間隔（編集中のみ） |
| **バージョン管理** | SHA-256ハッシュでバージョン識別（PlantUMLのみ） |
| **用語一貫性チェック** | 保存時に自動実行（PlantUMLのみ、OpenRouter API経由） |

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

| 図表タイプ | ソースファイル | プレビューファイル | 備考 |
|-----------|--------------|-------------------|------|
| **PlantUML** | `source.puml`（1ファイル） | `preview_N.svg`（図の数だけ） | 1ファイルに複数@startuml可 |
| **Excalidraw** | `source.json`（1ファイル） | `preview_0.svg`（1ファイル） | 常に1図=1プレビュー |

> **サムネイル表示**: 図表一覧では `preview_0.svg` を使用

#### エクスポート機能（UC 3-6）の要件

| 形式 | PlantUML | Excalidraw | 用途 |
|------|:--------:|:----------:|------|
| **PNG** | ✅ | ✅ | ラスター画像、ドキュメント埋め込み |
| **SVG** | ✅ | ✅ | ベクター画像、スケーラブル |
| **PDF** | ✅ | ✅ | ドキュメント配布、印刷 |

### 3.6 概要図

```plantuml
@startuml business_flow_save_export_overview
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - 保存・エクスポート（概要）

|エンドユーザー|
start
:図表を編集中;

|Frontend Service|
switch (操作を選択)
case (手動保存\nUC 3-5)
  :Ctrl+S または保存ボタン;
  #palegreen:保存処理実行;
  note right
    PlantUML: 3.6.1.1参照
    Excalidraw: 3.6.1.2参照
  end note
  detach
case (自動保存\nUC 3-5)
  :30秒経過（編集中）;
  #palegreen:自動保存処理;
  note right
    PlantUML: 3.6.1.1参照
    Excalidraw: 3.6.1.2参照
  end note
  detach
case (エクスポート\nUC 3-6)
  :エクスポートボタンクリック検知;
  #lightblue:エクスポート処理;
  note right
    PlantUML: 3.6.2.1参照
    Excalidraw: 3.6.2.2参照
  end note
  detach
case (編集継続)
  :編集継続（操作なし）;
  detach
endswitch

@enduml
```

---

### 3.6.1 保存フロー詳細（UC 3-5）

#### 3.6.1.1 PlantUML保存フロー

```plantuml
@startuml business_flow_save_plantuml
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - PlantUML保存（詳細）

|エンドユーザー|
start
if (保存トリガー?) then (手動)
  :Ctrl+S または保存ボタン;
else (自動)
  :30秒間隔で自動実行;
  note right
    編集中のみ
    未編集時はスキップ
  end note
endif

|Frontend Service|
:現在のPlantUMLコードを取得;
:PlantUML Serviceへ処理依頼;

|PlantUML Service|
:SHA-256ハッシュ生成;
:バージョン情報作成;
note right
  コンテンツハッシュで
  バージョンを一意に識別
end note
:プレビューSVG生成;
note right
  図ごとに preview_N.svg を生成
  （複数の図がある場合は複数SVG）
end note

|Frontend Service|
:処理結果を受信;
note right
  ハッシュ、バージョン情報、
  プレビューSVG（複数可）
end note
:AI Serviceへ用語チェック依頼;

|AI Service|
:用語一貫性チェック;
note right
  OpenRouter API経由
  プロジェクト内の
  用語統一を検証
end note

|Frontend Service|
:チェック結果を受信;
if (用語不一致?) then (あり)
  #lightyellow:警告通知を表示;
  note right
    「用語の不一致を検出しました」
    修正は任意
  end note
else (なし)
endif
:Supabaseへ保存リクエスト;

|Supabase|
:メタデータ保存（Postgres）;
:ソース・プレビュー保存（Storage）;
note right
  source.puml + preview_N.svg
  RLS適用・所有権検証
end note

|Frontend Service|
if (保存成功?) then (はい)
  #palegreen:完了通知を表示;
  :最終保存時刻を更新;
else (エラー)
  #mistyrose:エラー通知を表示;
  note right
    「保存に失敗しました」
    リトライオプション表示
  end note
endif
stop

@enduml
```

#### PlantUML保存フローテーブル

| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | 保存トリガー（手動/自動） | エンドユーザー/システム | - |
| 2 | 現在のPlantUMLコードを取得 | Frontend Service | - |
| 3 | PlantUML Serviceへ処理依頼 | Frontend Service | - |
| 4 | SHA-256ハッシュ生成 | PlantUML Service | - |
| 5 | バージョン情報作成 | PlantUML Service | - |
| 6 | **プレビューSVG生成**（図の数だけ） | PlantUML Service | - |
| 7 | 処理結果を受信（ハッシュ、バージョン、プレビュー） | Frontend Service | - |
| 8 | AI Serviceへ用語チェック依頼 | Frontend Service | - |
| 9 | **用語一貫性チェック** | AI Service | - |
| 10 | チェック結果を受信 | Frontend Service | 不一致時: 警告通知 |
| 11 | Supabaseへ保存リクエスト | Frontend Service | - |
| 12 | メタデータ・ソース・プレビュー保存 | Supabase | 失敗時: エラー通知 |
| 13 | 完了通知・最終保存時刻更新 | Frontend Service | - |

---

#### 3.6.1.2 Excalidraw保存フロー

```plantuml
@startuml business_flow_save_excalidraw
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - Excalidraw保存（詳細）

|エンドユーザー|
start
if (保存トリガー?) then (手動)
  :Ctrl+S または保存ボタン;
else (自動)
  :30秒間隔で自動実行;
  note right
    編集中のみ
    未編集時はスキップ
  end note
endif

|Frontend Service|
:現在のExcalidraw状態を取得;
:Excalidraw Serviceへ処理依頼;

|Excalidraw Service|
:Excalidraw JSON生成;
:プレビューSVG生成;
note right
  source.json: elements,
  appState, files を含む
  preview_0.svg: サムネイル用
end note

|Frontend Service|
:処理結果を受信;
note right
  JSON、プレビューSVG
end note
:Supabaseへ保存リクエスト;

|Supabase|
:メタデータ保存（Postgres）;
:ソース・プレビュー保存（Storage）;
note right
  source.json + preview_0.svg
  RLS適用・所有権検証
end note

|Frontend Service|
if (保存成功?) then (はい)
  #palegreen:完了通知を表示;
  :最終保存時刻を更新;
else (エラー)
  #mistyrose:エラー通知を表示;
  note right
    「保存に失敗しました」
    リトライオプション表示
  end note
endif
stop

@enduml
```

#### Excalidraw保存フローテーブル

| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | 保存トリガー（手動/自動） | エンドユーザー/システム | - |
| 2 | 現在のExcalidraw状態を取得 | Frontend Service | - |
| 3 | Excalidraw Serviceへ処理依頼 | Frontend Service | - |
| 4 | Excalidraw JSON生成（source.json） | Excalidraw Service | - |
| 5 | プレビューSVG生成（preview_0.svg） | Excalidraw Service | - |
| 6 | 処理結果を受信 | Frontend Service | - |
| 7 | Supabaseへ保存リクエスト | Frontend Service | - |
| 8 | メタデータ・ソース・プレビュー保存 | Supabase | 失敗時: エラー通知 |
| 9 | 完了通知・最終保存時刻更新 | Frontend Service | - |

> **Note**: Excalidrawはビジュアル図表のため、用語一貫性チェックは適用しない。Excalidrawは常に1図=1プレビュー。

---

### 3.6.2 エクスポートフロー詳細（UC 3-6）

#### 3.6.2.1 PlantUMLエクスポートフロー

```plantuml
@startuml business_flow_export_plantuml
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - PlantUMLエクスポート（詳細）

|エンドユーザー|
start
:エクスポートボタンをクリック;

|Frontend Service|
:エクスポートダイアログ表示;

|エンドユーザー|
:形式を選択;
note right
  **対応形式**
  - PNG（ラスター画像）
  - SVG（ベクター画像）
  - PDF（ドキュメント）
end note

|Frontend Service|
:エクスポートリクエスト送信;

|PlantUML Service|
switch (選択形式)
case (PNG)
  :PNG生成\n(node-plantuml);
case (SVG)
  :SVG生成\n(node-plantuml);
case (PDF)
  :SVG生成;
  :PDF変換;
endswitch

|Frontend Service|
if (生成成功?) then (はい)
  :Blobデータ受信;
  :ダウンロード開始;
  #palegreen:完了通知を表示;
else (エラー)
  #mistyrose:エラー通知を表示;
  note right
    「エクスポートに失敗しました」
  end note
endif
stop

@enduml
```

#### PlantUMLエクスポートフローテーブル

| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | エクスポートボタンをクリック | エンドユーザー | - |
| 2 | エクスポートダイアログ表示 | Frontend Service | - |
| 3 | 形式を選択（PNG/SVG/PDF） | エンドユーザー | - |
| 4 | エクスポートリクエスト送信 | Frontend Service | - |
| 5 | 画像/PDF生成（node-plantuml） | PlantUML Service | 失敗時: エラー通知 |
| 6 | ダウンロード開始 | Frontend Service | - |
| 7 | 完了通知表示 | Frontend Service | - |

---

#### 3.6.2.2 Excalidrawエクスポートフロー

```plantuml
@startuml business_flow_export_excalidraw
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - Excalidrawエクスポート（詳細）

|エンドユーザー|
start
:エクスポートボタンをクリック;

|Frontend Service|
:エクスポートダイアログ表示;

|エンドユーザー|
:形式を選択;
note right
  **対応形式**
  - PNG（ラスター画像）
  - SVG（ベクター画像）
  - PDF（ドキュメント）
end note

|Frontend Service|
:エクスポートリクエスト送信;

|Excalidraw Service|
switch (選択形式)
case (PNG)
  :PNG生成\n(Excalidraw exportToBlob);
case (SVG)
  :SVG生成\n(Excalidraw exportToSvg);
case (PDF)
  :SVG生成;
  :PDF変換;
endswitch

|Frontend Service|
if (生成成功?) then (はい)
  :Blobデータ受信;
  :ダウンロード開始;
  #palegreen:完了通知を表示;
else (エラー)
  #mistyrose:エラー通知を表示;
  note right
    「エクスポートに失敗しました」
  end note
endif
stop

@enduml
```

#### Excalidrawエクスポートフローテーブル

| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | エクスポートボタンをクリック | エンドユーザー | - |
| 2 | エクスポートダイアログ表示 | Frontend Service | - |
| 3 | 形式を選択（PNG/SVG/PDF） | エンドユーザー | - |
| 4 | エクスポートリクエスト送信 | Frontend Service | - |
| 5 | 画像/PDF生成（Excalidraw API） | Excalidraw Service | 失敗時: エラー通知 |
| 6 | ダウンロード開始 | Frontend Service | - |
| 7 | 完了通知表示 | Frontend Service | - |

---

### 技術仕様

| 項目 | PlantUML | Excalidraw |
|------|---------|-----------|
| PNG生成 | node-plantuml | Excalidraw exportToBlob |
| SVG生成 | node-plantuml | Excalidraw exportToSvg |
| PDF生成 | SVG→PDF変換 | SVG→PDF変換 |
| **ソースファイル** | `source.puml`（複数@startuml可） | `source.json` |
| **プレビューファイル** | `preview_N.svg`（図の数だけ） | `preview_0.svg`（1ファイル） |
| バージョン管理 | SHA-256ハッシュ | なし |
| 用語一貫性チェック | ✅ 対応 | ❌ 非対応（ビジュアル図表のため） |
| サムネイル | `preview_0.svg` を使用 | `preview_0.svg` を使用 |

### エラーハンドリング

| エラー種別 | 原因 | 対応 |
|-----------|------|------|
| ネットワークエラー | 通信障害 | 「保存に失敗しました。再試行してください。」 |
| 認証エラー | セッション期限切れ | ログイン画面にリダイレクト |
| ストレージエラー | 容量超過等 | 「ストレージ容量が不足しています」 |
| 生成エラー | 内部処理失敗 | 「エクスポートに失敗しました」 |
| 構文エラー | PlantUMLコード不正 | 「図表の構文エラーを修正してください」 |

---

## 3.7 バージョン管理フロー

**関連ユースケース**: UC 3-7 バージョン履歴を確認する, UC 3-8 過去バージョンを復元する
**対象**: PlantUML図表・Excalidraw図表の両方

### 設計思想

バージョン管理機能は、ユーザーの作業履歴を保護し、誤った編集からの回復を可能にする重要な機能である。

#### バージョン管理の要件

| 項目 | 仕様 |
|------|------|
| **対象** | PlantUML図表・Excalidraw図表の両方 |
| **識別方法** | SHA-256ハッシュ（コンテンツベース） |
| **保存タイミング** | 手動保存時・自動保存時（3.6参照） |
| **保持期間** | 無期限（将来的に上限設定可能） |
| **最大バージョン数** | 制限なし（MVP）、将来的に100件程度を想定 |

#### 図表タイプ別のバージョン管理

| 図表タイプ | ソースファイル | ハッシュ対象 | 備考 |
|-----------|--------------|-------------|------|
| **PlantUML** | `source.puml` | PlantUMLコード全体 | テキストベース |
| **Excalidraw** | `source.json` | JSON全体 | elements, appState, files含む |

#### バージョン情報の構成

| 属性 | 説明 | 例 |
|------|------|-----|
| **version_id** | UUID（一意識別子） | `550e8400-e29b-41d4-a716-446655440000` |
| **content_hash** | SHA-256ハッシュ | `a7ffc6f8bf1ed...` |
| **created_at** | 作成日時（UTC） | `2025-12-06T10:30:00Z` |
| **source_size** | ソースファイルサイズ | `2048 bytes` |
| **preview_url** | プレビューSVGのURL | `preview_0.svg` |

### 3.7 概要図

```plantuml
@startuml business_flow_version_overview
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - バージョン管理（概要）

|エンドユーザー|
start
:図表編集画面で操作;

|Frontend Service|
switch (操作を選択)
case (履歴確認\nUC 3-7)
  :履歴ボタンをクリック検知;
  #lightblue:履歴一覧表示;
  note right
    詳細は 3.7.1 参照
  end note
  detach
case (バージョン復元\nUC 3-8)
  :復元ボタンをクリック検知;
  #palegreen:復元処理実行;
  note right
    詳細は 3.7.2 参照
    （履歴確認が前提）
  end note
  detach
case (編集継続)
  :編集継続（操作なし）;
  detach
endswitch

@enduml
```

---

### 3.7.1 履歴確認フロー詳細（UC 3-7）

```plantuml
@startuml business_flow_version_history
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - バージョン履歴確認（詳細）

|エンドユーザー|
start
:「履歴」ボタンをクリック;

|Frontend Service|
:バージョン一覧取得リクエスト;

|Supabase|
:バージョン一覧取得\n（RLS適用）;
note right
  図表IDに紐づく
  全バージョンを取得
  created_at DESC
end note

|Frontend Service|
if (バージョンあり?) then (はい)
  :履歴パネル表示;
  note right
    **表示項目**
    - バージョン番号
    - 保存日時
    - サムネイル（preview_0.svg）
    - コンテンツハッシュ（短縮）
  end note

  |エンドユーザー|
  :バージョンを選択;

  |Frontend Service|
  :選択バージョンのプレビュー表示;
  note right
    現在のエディタ内容と
    比較表示（オプション）
  end note

  |エンドユーザー|
  if (復元する?) then (はい)
    :「復元」ボタンをクリック;
    #palegreen:→ 3.7.2 復元フローへ;
    detach
  else (いいえ)
    :履歴パネルを閉じる;
    stop
  endif
else (なし)
  #lightyellow:「バージョン履歴がありません」表示;
  stop
endif

@enduml
```

#### 履歴確認フローテーブル

| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | 「履歴」ボタンをクリック | エンドユーザー | - |
| 2 | バージョン一覧取得リクエスト | Frontend Service | - |
| 3 | バージョン一覧取得（RLS適用） | Supabase | 失敗時: エラー通知 |
| 4 | 履歴パネル表示 | Frontend Service | 履歴なし時: メッセージ表示 |
| 5 | バージョン選択 | エンドユーザー | - |
| 6 | 選択バージョンのプレビュー表示 | Frontend Service | - |
| 7 | 復元判断 or パネルを閉じる | エンドユーザー | - |

---

### 3.7.2 バージョン復元フロー詳細（UC 3-8）

```plantuml
@startuml business_flow_version_restore
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - バージョン復元（詳細）

|エンドユーザー|
start
:復元するバージョンを選択;
:「復元」ボタンをクリック;

|Frontend Service|
#lightyellow:確認ダイアログ表示;
note right
  「このバージョンに復元しますか？」
  「現在の編集内容は新しい
  　バージョンとして保存されます」
end note

|エンドユーザー|
if (確認?) then (はい)
  |Frontend Service|
  :現在の内容を自動保存;
  note right
    復元前に現在の状態を
    バージョンとして保存
    （データ損失防止）
  end note
  :復元リクエスト送信;

  |Supabase|
  :選択バージョンのソース取得;

  |Frontend Service|
  :エディタ内容を更新;
  :プレビュー更新;
  note right
    復元したコードで
    自動的にプレビュー生成
  end note

  if (復元成功?) then (はい)
    #palegreen:完了通知を表示;
    note right
      「バージョン XX に復元しました」
    end note
    :履歴パネルを閉じる;
  else (エラー)
    #mistyrose:エラー通知を表示;
    note right
      「復元に失敗しました」
      リトライオプション表示
    end note
  endif
else (キャンセル)
  |Frontend Service|
  :履歴パネルに戻る;
endif
stop

@enduml
```

#### 復元フローテーブル

| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | 復元するバージョンを選択 | エンドユーザー | - |
| 2 | 「復元」ボタンをクリック | エンドユーザー | - |
| 3 | 確認ダイアログ表示 | Frontend Service | - |
| 4 | 確認 or キャンセル | エンドユーザー | キャンセル時: パネルに戻る |
| 5 | **現在の内容を自動保存** | Frontend Service | - |
| 6 | 復元リクエスト送信 | Frontend Service | - |
| 7 | 選択バージョンのソース取得（RLS適用） | Supabase | 失敗時: エラー通知 |
| 8 | エディタ内容を更新 | Frontend Service | - |
| 9 | プレビュー更新 | Frontend Service | - |
| 10 | 完了通知表示 | Frontend Service | - |

### 復元時の安全対策

| 対策 | 説明 |
|------|------|
| **自動保存** | 復元前に現在の内容を新しいバージョンとして自動保存 |
| **確認ダイアログ** | 意図しない復元を防止 |
| **プレビュー確認** | 復元前に選択バージョンのプレビューを確認可能 |
| **取り消し可能** | 復元後も履歴から元の状態に戻せる |

### エラーハンドリング

| エラー種別 | 原因 | 対応 |
|-----------|------|------|
| ネットワークエラー | 通信障害 | 「履歴の取得に失敗しました。再試行してください。」 |
| 認証エラー | セッション期限切れ | ログイン画面にリダイレクト |
| バージョン不存在 | 削除済み・不整合 | 「指定されたバージョンが見つかりません」 |
| 復元失敗 | DB障害等 | 「復元に失敗しました。再試行してください。」 |

---

## 3.8 図表削除フロー

**関連ユースケース**: UC 3-9 図表を削除する
**対象**: PlantUML図表・Excalidraw図表の両方

### 設計思想

図表削除機能は、不要になった図表を安全に削除するための機能である。
プロジェクト削除（3.5.4）と同様に、確認ダイアログで誤操作を防止する。

#### 削除時の処理

| 項目 | 説明 |
|------|------|
| **メタデータ削除** | PostgreSQLの図表レコードを削除 |
| **ソースファイル削除** | Storageの`source.puml`/`source.json`を削除 |
| **プレビューファイル削除** | Storageの`preview_N.svg`を全て削除 |
| **バージョン履歴削除** | 図表に紐づく全バージョンをカスケード削除 |

### 3.8 図表削除フロー詳細（UC 3-9）

```plantuml
@startuml business_flow_diagram_delete
skinparam ActivityFontSize 12
skinparam ConditionEndStyle hline

title 業務フロー図 - 図表削除（詳細）

|エンドユーザー|
start
:図表の「削除」ボタンをクリック;

|Frontend Service|
:図表情報を取得;
note right
  図表名、タイプ
  バージョン数（PlantUMLの場合）
end note
#lightyellow:確認ダイアログ表示;
note right
  **警告内容**
  「この図表を削除しますか？」
  「削除すると復元できません」
  （PlantUMLの場合）
  「N件のバージョン履歴も削除されます」
end note

|エンドユーザー|
if (確認?) then (はい)
  |Frontend Service|
  :削除リクエスト送信;

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

  |Frontend Service|
  if (削除成功?) then (はい)
    :図表一覧を更新;
    #palegreen:完了通知を表示;
    note right
      「図表を削除しました」
    end note
  else (エラー)
    #mistyrose:エラー通知を表示;
    note right
      「削除に失敗しました」
      リトライオプション表示
    end note
  endif
else (キャンセル)
  |Frontend Service|
  :ダイアログを閉じる;
  :図表一覧に戻る;
endif
stop

@enduml
```

#### 削除フローテーブル

| ステップ | 処理内容 | 担当 | エラー処理 |
|:-------:|---------|------|-----------|
| 1 | 「削除」ボタンをクリック | エンドユーザー | - |
| 2 | 図表情報を取得 | Frontend Service | - |
| 3 | 確認ダイアログ表示 | Frontend Service | - |
| 4 | 確認 or キャンセル | エンドユーザー | キャンセル時: 一覧に戻る |
| 5 | 削除リクエスト送信 | Frontend Service | - |
| 6 | メタデータ削除（RLS適用） | Supabase | 失敗時: エラー通知 |
| 7 | バージョン履歴削除（カスケード） | Supabase | - |
| 8 | Storageファイル削除 | Supabase | - |
| 9 | 図表一覧を更新 | Frontend Service | - |
| 10 | 完了通知表示 | Frontend Service | - |

### 削除確認ダイアログの内容

| 図表タイプ | 表示メッセージ |
|-----------|---------------|
| **PlantUML** | 「この図表を削除しますか？」<br>「削除すると復元できません」<br>「N件のバージョン履歴も削除されます」 |
| **Excalidraw** | 「この図表を削除しますか？」<br>「削除すると復元できません」 |

### エラーハンドリング

| エラー種別 | 原因 | 対応 |
|-----------|------|------|
| ネットワークエラー | 通信障害 | 「削除に失敗しました。再試行してください。」 |
| 認証エラー | セッション期限切れ | ログイン画面にリダイレクト |
| 権限エラー | 所有者以外の削除試行 | 「この図表を削除する権限がありません」 |
| DB障害 | 内部エラー | 「削除に失敗しました。再試行してください。」 |

### 将来的な拡張（Phase 2以降）

| 機能 | 説明 | フェーズ |
|------|------|:--------:|
| **ゴミ箱機能** | 削除後30日間は復元可能 | Phase 2 |
| **一括削除** | 複数図表を選択して削除 | Phase 2 |
| **アーカイブ** | 削除せず非表示化（復元可能） | Phase 3 |

---

## アクター一覧（整合性確認）

| アクター | 役割 | 関連フロー |
|---------|------|-----------|
| **エンドユーザー** | 図表作成・編集、AI機能利用、認証、プロジェクト管理、保存・エクスポート、バージョン管理、図表削除 | 3.1〜3.8 全て |
| **開発者** | システム管理（本フローには未登場） | - |

---

## マイクロサービス一覧（整合性確認）

| サービス | 役割 | 関連フロー |
|---------|------|-----------|
| **Frontend Service** | UI、Monaco Editor、Excalidraw、入力待機処理、プレビュー更新、認証画面、プロジェクト管理UI、保存・エクスポートUI、履歴パネル、削除確認UI | 3.1〜3.8 全て |
| **PlantUML Service** | node-plantuml実行、検証、SVG/PNG/PDF生成、バージョン管理 | 3.1, 3.2, 3.6, 3.7 |
| **AI Service** | AI自動修正（Context7 + OpenRouter）、AIチャット、JSON生成、用語一貫性チェック | 3.1〜3.3, 3.6 |
| **Excalidraw Service** | JSON保存、SVG/PNG/PDF変換、バージョン管理 | 3.3, 3.6, 3.7, 3.8 |
| **API Gateway** | ルーティング、認証検証（暗黙的に介在、詳細は「業務フロー図の表現について」参照） | 全て |

---

## 外部システム一覧（整合性確認）

| システム | 役割 | 関連フロー |
|---------|------|-----------|
| **Supabase Auth** | OAuth認証、セッション管理、JWT発行 | 3.4 |
| **Supabase** | データ永続化、Storage、プロジェクトCRUD、RLS、図表保存、バージョン履歴、削除処理 | 3.1, 3.3, 3.5, 3.6, 3.7, 3.8 |
| **OAuthプロバイダー** | GitHub OAuth, Google OAuth | 3.4 |
| **OpenRouter API** | LLM呼び出し（GPT-4o-mini, Claude等）、用語一貫性チェック | 3.1, 3.2, 3.3, 3.6 |
| **OpenAI API** | Embedding生成（本フローには未登場） | - |
| **Context7 MCP** | PlantUML構文情報取得 | 3.1, 3.2 |

---

## 関連ドキュメント

- [PlantUML_Studio_コンテキスト図_20251130.md](./PlantUML_Studio_コンテキスト図_20251130.md) - システム境界、サービス構成
- [PlantUML_Studio_ユースケース図_20251130.md](./PlantUML_Studio_ユースケース図_20251130.md) - UC 3-1〜3-11, UC 4-1, 4-2
- [PlantUML_Studio_シーケンス図_ログイン_20251130.md](./PlantUML_Studio_シーケンス図_ログイン_20251130.md) - 認証フロー詳細

---

## レビュー観点

1. **コンテキスト図との整合性**: サービス名、外部システム名は統一されているか？
2. **ユースケース図との整合性**: UCIDは正しくマッピングされているか？
3. **技術仕様の遵守**: Monaco Editor、node-plantuml（内部）、Excalidrawを使用しているか？
4. **フローの網羅性**: 主要な業務フローは網羅されているか？
5. **PlantUML記法の妥当性**: 図表は正しくレンダリングされるか？
6. **エラー修正ループの整合性**: 3.1と3.2で同じAI自動修正ロジック（最大5回リトライ）が適用されているか？
7. **AIチャット連携**: 3.3でGUI編集とAIチャットの組み合わせによるイテレーティブ修正が可能か？
8. **認証仕様の整合性**: 3.4でOAuth認証のみ（GitHub, Google）、Email/Password不使用が明記されているか？
9. **プロジェクト管理の整合性**: 3.5で削除確認ダイアログ、RLS、カスケード削除が適切に実装されているか？
10. **保存・エクスポートの整合性**: 3.6で手動/自動保存、用語一貫性チェック、PNG/SVG/PDF対応が適切か？
11. **バージョン管理の整合性**: 3.7でPlantUML/Excalidraw両対応、SHA-256ハッシュ、復元前自動保存が適切か？
12. **図表削除の整合性**: 3.8で確認ダイアログ、カスケード削除、RLS適用が適切か？
