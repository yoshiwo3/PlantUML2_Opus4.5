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
| 3.1 | PlantUML 図表作成フロー | UC 3-1〜3-5 |
| 3.2 | PlantUML AI支援フロー | UC 4-1, 4-2 |
| 3.3 | Excalidraw ワイヤーフレーム作成フロー | UC 3-1〜3-3（Excalidraw） |
| 3.4 | 認証フロー | UC 1-1, 1-2 |
| 3.5 | プロジェクト管理フロー | UC 2-1, 2-2, 2-3, 2-4 |

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

## アクター一覧（整合性確認）

| アクター | 役割 | 関連フロー |
|---------|------|-----------|
| **エンドユーザー** | 図表作成・編集、AI機能利用、認証、プロジェクト管理 | 3.1〜3.5 全て |
| **開発者** | システム管理（本フローには未登場） | - |

---

## マイクロサービス一覧（整合性確認）

| サービス | 役割 | 関連フロー |
|---------|------|-----------|
| **Frontend Service** | UI、Monaco Editor、Excalidraw、入力待機処理、プレビュー更新、認証画面、プロジェクト管理UI | 3.1〜3.5 全て |
| **PlantUML Service** | node-plantuml実行、検証、SVG/PNG/PDF生成、バージョン管理 | 3.1, 3.2 |
| **AI Service** | AI自動修正（Context7 + OpenRouter）、AIチャット、JSON生成 | 3.1〜3.3 |
| **Excalidraw Service** | JSON保存、SVG/PNG/PDF変換 | 3.3 |
| **API Gateway** | ルーティング、認証検証（図では省略） | - |

---

## 外部システム一覧（整合性確認）

| システム | 役割 | 関連フロー |
|---------|------|-----------|
| **Supabase Auth** | OAuth認証、セッション管理、JWT発行 | 3.4 |
| **Supabase** | データ永続化、Storage、プロジェクトCRUD、RLS | 3.1, 3.3, 3.5 |
| **OAuthプロバイダー** | GitHub OAuth, Google OAuth | 3.4 |
| **OpenRouter API** | LLM呼び出し（GPT-4o-mini, Claude等） | 3.1, 3.2, 3.3 |
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
