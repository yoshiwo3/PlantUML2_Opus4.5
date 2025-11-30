# Instructions: シーケンス図作成 2025-11-30

## 目標

PlantUML Studioのシーケンス図を作成する。

## 対象ユースケース

### 完了
- UC 1-1 ログインする（OAuth）
- UC 1-2 ログアウトする
- UC 2-1 PlantUMLコードを入力する
- UC 2-2 リアルタイムプレビューを見る
- UC 2-3 構文エラーを確認する

### 完了（追加）
- UC 3-1 図を画像としてエクスポートする
- UC 3-2 図をSVGとしてエクスポートする
- UC 3-3 図をコピーする
- UC 4-1 図を保存する
- UC 4-2 図を読み込む
- UC 4-3 図を共有する

## 基準ドキュメント

1. `docs/design/PlantUML_Studio_設計図表_20251130.md` - 設計図表集
2. `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md` - ユースケース図

## 検証方法

- Context7 MCP: Supabase SSR、Excalidraw React公式ドキュメント取得
- 設計図表集との整合性確認

## 成果物

1. `docs/proposals/PlantUML_Studio_シーケンス図_ログイン_20251130.md`
2. `docs/proposals/PlantUML_Studio_シーケンス図_編集プレビュー_20251130.md`

## 制約事項

- PlantUMLレンダリングは内部（node-plantuml + Java 17 + Graphviz）
- テキストエディタはMonaco Editor
- 外部PlantUML Server APIは使用しない
