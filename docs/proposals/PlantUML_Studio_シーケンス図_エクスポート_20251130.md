# PlantUML Studio シーケンス図 - エクスポート

**作成日**: 2025-11-30
**バージョン**: 1.0
**対象ユースケース**: UC 3-1, UC 3-2, UC 3-3

---

## 目次

1. [PlantUML図表エクスポートフロー](#1-plantuml図表エクスポートフロー)
2. [Excalidrawワイヤーフレームエクスポートフロー](#2-excalidrawワイヤーフレームエクスポートフロー)
3. [クリップボードコピーフロー](#3-クリップボードコピーフロー)

---

## 対象ユースケース

| UC ID | ユースケース名 | 説明 |
|-------|---------------|------|
| UC 3-1 | 図を画像としてエクスポートする | PNG形式でダウンロード |
| UC 3-2 | 図をSVGとしてエクスポートする | SVG形式でダウンロード |
| UC 3-3 | 図をコピーする | クリップボードにコピー |

---

## 1. PlantUML図表エクスポートフロー

```plantuml
@startuml export_plantuml

title シーケンス図 - PlantUML図表エクスポート（UC 3-1, UC 3-2）

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
  BackgroundColor<<service>> #FCE4EC
  BackgroundColor<<storage>> #FFF3E0
}

actor "エンドユーザー" as user
participant "エクスポート\nモーダル" as modal <<frontend>> #E3F2FD
participant "API Routes\n(/api/diagrams/{id}/export)" as api <<backend>> #E8F5E9
participant "DiagramService" as service <<service>> #FCE4EC
participant "PlantUML\nValidator" as validator <<service>> #FCE4EC
database "Supabase\nStorage" as storage <<storage>> #FFF3E0

== エクスポートモーダル表示 ==

user -> modal : エクスポートボタンクリック
activate modal

modal -> modal : エクスポートオプション表示
note right of modal
  **選択可能なオプション**
  - PNG（画像形式）
  - SVG（ベクター形式）
  - PDF（印刷用）
  - PUML（ソースコード）
end note

modal --> user : モーダル表示

== フォーマット選択・エクスポート実行 ==

user -> modal : フォーマット選択\n（例: PNG）
user -> modal : 「エクスポート」クリック

modal -> api : POST /api/diagrams/{id}/export\n{ format: "PNG", options: { scale: 2 } }
activate api

api -> api : 認証チェック（JWT検証）
api -> api : 権限チェック（RLS）

api -> service : export(diagramId, format, options)
activate service

service -> service : 図表データ取得
note right of service
  diagrams テーブルから
  content（PlantUMLコード）を取得
end note

alt フォーマット = PNG or SVG
  service -> validator : render(code, format)
  activate validator

  validator -> validator : node-plantuml実行
  note right of validator
    **内部レンダリング**
    - node-plantuml
    - Java 17 Runtime
    - Graphviz
  end note

  validator -> validator : 画像生成

  alt 成功
    validator --> service : Buffer（PNG/SVG）
  else 構文エラー
    validator --> service : ValidationError
    service --> api : 400 Bad Request
    api --> modal : エラーメッセージ
    modal --> user : 「構文エラーがあります」
  end
  deactivate validator

else フォーマット = PDF
  service -> validator : render(code, "SVG")
  activate validator
  validator --> service : SVG Buffer
  deactivate validator

  service -> service : SVG → PDF変換
  note right of service
    **PDF変換**
    puppeteer または
    svg-to-pdf ライブラリ使用
  end note

else フォーマット = PUML
  service -> service : ソースコードをそのまま返却
end

== ファイルダウンロード ==

service -> storage : upload(exports/{userId}/{diagramId}.{format})
activate storage
note right of storage
  **一時保存**
  有効期限: 1時間
  バケット: exports (Private)
end note
storage --> service : signedUrl
deactivate storage

service --> api : { url: signedUrl, filename: "diagram.png" }
deactivate service

api --> modal : 200 OK\n{ downloadUrl, filename }
deactivate api

modal -> modal : ダウンロード開始
note right of modal
  **ダウンロード方式**
  - Blob URL生成
  - <a download> による自動ダウンロード
end note

modal --> user : ファイルダウンロード完了
modal -> modal : モーダル閉じる

deactivate modal

@enduml
```

### 処理詳細

| ステップ | 処理内容 | 技術要素 |
|---------|---------|---------|
| 1 | フォーマット選択 | React State管理 |
| 2 | API呼び出し | fetch + JWT認証 |
| 3 | 画像レンダリング | node-plantuml + Java 17 + Graphviz |
| 4 | PDF変換 | puppeteer / svg-to-pdf |
| 5 | ファイル保存 | Supabase Storage (signed URL) |
| 6 | ダウンロード | Blob URL + <a download> |

### エクスポートオプション

| オプション | 説明 | デフォルト |
|-----------|------|-----------|
| scale | PNG出力時の拡大率 | 2 |
| background | 背景色 | transparent |
| darkMode | ダークモード出力 | false |

---

## 2. Excalidrawワイヤーフレームエクスポートフロー

```plantuml
@startuml export_excalidraw

title シーケンス図 - Excalidrawワイヤーフレームエクスポート

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
  BackgroundColor<<service>> #FCE4EC
  BackgroundColor<<storage>> #FFF3E0
}

actor "エンドユーザー" as user
participant "Excalidraw\nエディタ" as editor <<frontend>> #E3F2FD
participant "エクスポート\nモーダル" as modal <<frontend>> #E3F2FD
participant "API Routes\n(/api/wireframes/{id}/export)" as api <<backend>> #E8F5E9
participant "WireframeService" as service <<service>> #FCE4EC
database "Supabase\nStorage" as storage <<storage>> #FFF3E0

== エクスポート開始 ==

user -> editor : 「エクスポート ▼」クリック
activate editor

editor -> modal : エクスポートモーダル表示
activate modal

modal --> user : フォーマット選択表示
note right of modal
  **Excalidraw対応フォーマット**
  - PNG（ラスター画像）
  - SVG（ベクター画像）
  - Excalidraw JSON（再編集可能）
end note

== PNG/SVGエクスポート ==

alt フォーマット = PNG or SVG
  user -> modal : PNG/SVG選択

  modal -> editor : getSceneElements()
  editor --> modal : elements, appState, files

  modal -> modal : Excalidraw exportToBlob()
  note right of modal
    **クライアントサイド生成**
    @excalidraw/excalidraw の
    exportToBlob() / exportToSvg()
    を使用
  end note

  modal -> modal : Blob URL生成
  modal -> modal : ダウンロードトリガー
  modal --> user : ファイルダウンロード

== Excalidraw JSONエクスポート ==

else フォーマット = Excalidraw JSON
  user -> modal : JSON選択

  modal -> editor : getSceneElements()
  editor --> modal : elements, appState, files

  modal -> modal : JSON.stringify(sceneData)
  note right of modal
    **Excalidraw形式**
    {
      "type": "excalidraw",
      "version": 2,
      "elements": [...],
      "appState": {...},
      "files": {...}
    }
  end note

  modal -> modal : Blob URL生成
  modal --> user : .excalidraw ファイルダウンロード

== サーバーサイド保存（オプション） ==

else サーバー保存を選択
  user -> modal : 「サーバーに保存」選択

  modal -> api : POST /api/wireframes/{id}/export\n{ format: "PNG" }
  activate api

  api -> service : export(wireframeId, format)
  activate service

  service -> storage : get wireframe JSON
  activate storage
  storage --> service : Excalidraw JSON
  deactivate storage

  service -> service : サーバーサイドレンダリング
  note right of service
    **Puppeteer使用**
    Excalidrawをヘッドレスブラウザで
    レンダリング → スクリーンショット
  end note

  service -> storage : upload(exports/{userId}/{wireframeId}.png)
  activate storage
  storage --> service : signedUrl
  deactivate storage

  service --> api : { url: signedUrl }
  deactivate service

  api --> modal : 200 OK
  deactivate api

  modal --> user : ダウンロードリンク
end

deactivate modal
deactivate editor

@enduml
```

### Excalidrawエクスポート方式比較

| 方式 | メリット | デメリット | 使用場面 |
|------|---------|-----------|---------|
| クライアントサイド | 高速、サーバー負荷なし | ブラウザ依存 | 通常のエクスポート |
| サーバーサイド | 一貫した品質 | Puppeteer必要、遅い | 高品質印刷用 |

---

## 3. クリップボードコピーフロー

```plantuml
@startuml export_clipboard

title シーケンス図 - クリップボードコピー（UC 3-3）

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<browser>> #FFF9C4
}

actor "エンドユーザー" as user
participant "プレビュー\nパネル" as preview <<frontend>> #E3F2FD
participant "コンテキスト\nメニュー" as menu <<frontend>> #E3F2FD
participant "Clipboard\nAPI" as clipboard <<browser>> #FFF9C4

== 画像コピー ==

user -> preview : プレビュー画像を右クリック\nまたはコピーボタンクリック
activate preview

preview -> menu : コンテキストメニュー表示
activate menu

menu --> user : メニュー表示
note right of menu
  **コピーオプション**
  - 画像をコピー（PNG）
  - SVGをコピー
  - コードをコピー
end note

alt 画像をコピー（PNG）
  user -> menu : 「画像をコピー」選択

  menu -> preview : 現在のSVGを取得
  preview --> menu : SVG Element

  menu -> menu : SVG → Canvas変換
  note right of menu
    **変換処理**
    1. SVG → Base64 Data URL
    2. Image要素に描画
    3. Canvas.drawImage()
    4. Canvas.toBlob('image/png')
  end note

  menu -> clipboard : navigator.clipboard.write(\n  [new ClipboardItem({\n    'image/png': pngBlob\n  })]\n)
  activate clipboard

  clipboard -> clipboard : 権限チェック
  note right of clipboard
    **Permissions API**
    clipboard-write 権限必要
    HTTPS必須
  end note

  clipboard --> menu : 成功
  deactivate clipboard

  menu --> user : 「コピーしました」通知

== SVGコピー ==

else SVGをコピー
  user -> menu : 「SVGをコピー」選択

  menu -> preview : 現在のSVGを取得
  preview --> menu : SVG Element

  menu -> menu : SVG文字列化
  note right of menu
    new XMLSerializer()
      .serializeToString(svgElement)
  end note

  menu -> clipboard : navigator.clipboard.writeText(svgString)
  activate clipboard
  clipboard --> menu : 成功
  deactivate clipboard

  menu --> user : 「SVGをコピーしました」通知

== コードコピー ==

else コードをコピー
  user -> menu : 「コードをコピー」選択

  menu -> preview : 現在のPlantUMLコードを取得
  preview --> menu : PlantUMLコード文字列

  menu -> clipboard : navigator.clipboard.writeText(code)
  activate clipboard
  clipboard --> menu : 成功
  deactivate clipboard

  menu --> user : 「コードをコピーしました」通知
end

deactivate menu
deactivate preview

@enduml
```

### クリップボードAPI対応状況

| ブラウザ | 画像コピー | テキストコピー | 備考 |
|---------|-----------|---------------|------|
| Chrome 66+ | ○ | ○ | フル対応 |
| Firefox 63+ | ○ | ○ | フル対応 |
| Safari 13.1+ | △ | ○ | 画像は制限あり |
| Edge 79+ | ○ | ○ | フル対応 |

### フォールバック処理

```plantuml
@startuml clipboard_fallback

title クリップボードコピー - フォールバック処理

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<browser>> #FFF9C4
}

participant "コピー処理" as copy <<frontend>> #E3F2FD
participant "Clipboard API" as clipboard <<browser>> #FFF9C4
participant "execCommand\n(レガシー)" as legacy <<browser>> #FFF9C4

copy -> clipboard : navigator.clipboard.write()
activate clipboard

alt Clipboard API対応
  clipboard --> copy : 成功
  copy -> copy : 通知表示「コピーしました」

else Clipboard API非対応 or 権限エラー
  clipboard --> copy : エラー
  deactivate clipboard

  copy -> copy : フォールバック処理
  note right of copy
    **レガシー方式**
    テキストのみ対応
  end note

  copy -> legacy : document.execCommand('copy')
  activate legacy

  alt テキストコピー成功
    legacy --> copy : 成功
    copy -> copy : 通知表示「コピーしました」
  else 画像コピー不可
    legacy --> copy : 失敗
    deactivate legacy
    copy -> copy : 通知表示「ダウンロードしてください」
    copy -> copy : 自動ダウンロード開始
  end
end

@enduml
```

---

## エラーハンドリング

### エクスポートエラー一覧

| エラーコード | 説明 | 対処方法 |
|-------------|------|---------|
| EXPORT_001 | 構文エラーでレンダリング不可 | エラー修正を促す |
| EXPORT_002 | ファイルサイズ超過（10MB以上） | 図を分割するか解像度を下げる |
| EXPORT_003 | タイムアウト（30秒） | 図を簡素化する |
| EXPORT_004 | ストレージ容量不足 | 古いエクスポートを削除 |
| EXPORT_005 | クリップボード権限なし | 手動コピーまたはダウンロード |

### エラーシーケンス

```plantuml
@startuml export_error

title シーケンス図 - エクスポートエラーハンドリング

skinparam participant {
  BackgroundColor<<frontend>> #E3F2FD
  BackgroundColor<<backend>> #E8F5E9
}

actor "エンドユーザー" as user
participant "エクスポート\nモーダル" as modal <<frontend>> #E3F2FD
participant "API Routes" as api <<backend>> #E8F5E9

user -> modal : エクスポート実行
activate modal

modal -> api : POST /api/diagrams/{id}/export
activate api

alt 構文エラー
  api --> modal : 400 Bad Request\n{ error: "EXPORT_001", message: "構文エラー" }
  modal -> modal : エラーダイアログ表示
  modal --> user : 「構文エラーを修正してください」

else タイムアウト
  api --> modal : 504 Gateway Timeout\n{ error: "EXPORT_003" }
  modal -> modal : リトライオプション表示
  modal --> user : 「タイムアウトしました。再試行しますか？」

else ファイルサイズ超過
  api --> modal : 413 Payload Too Large\n{ error: "EXPORT_002" }
  modal --> user : 「ファイルが大きすぎます」

else 成功
  api --> modal : 200 OK
  modal --> user : ダウンロード開始
end

deactivate api
deactivate modal

@enduml
```

---

## 技術仕様

### レンダリングパフォーマンス

| 図表サイズ | PNG生成時間 | SVG生成時間 | PDF生成時間 |
|-----------|------------|------------|------------|
| 小（〜50要素） | 〜500ms | 〜200ms | 〜1s |
| 中（〜200要素） | 〜1s | 〜500ms | 〜2s |
| 大（〜500要素） | 〜3s | 〜1s | 〜5s |

### ストレージ設定

```typescript
// Supabase Storage設定
const exportsBucket = {
  name: 'exports',
  public: false,
  fileSizeLimit: 10 * 1024 * 1024, // 10MB
  allowedMimeTypes: [
    'image/png',
    'image/svg+xml',
    'application/pdf',
    'text/plain'
  ]
};

// 署名付きURL設定
const signedUrlOptions = {
  expiresIn: 3600, // 1時間
  download: true
};
```

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|----------|
| 1.0 | 2025-11-30 | 初版作成 |
