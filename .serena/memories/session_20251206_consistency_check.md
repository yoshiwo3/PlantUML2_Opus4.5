# 整合性チェック・コンテキスト図更新メモ

## 実施日: 2025-12-06

## 概要

3.6 保存・エクスポートフロー完成後、docs/proposals内の全図表との整合性チェックを実施。

## 調査対象ドキュメント

| ドキュメント | 作成日 |
|-------------|--------|
| PlantUML_Studio_コンテキスト図_20251130.md | 2025-11-30 |
| PlantUML_Studio_ユースケース図_20251130.md | 2025-11-30 |
| PlantUML_Studio_シーケンス図_ログイン_20251130.md | 2025-11-30 |
| PlantUML_Studio_業務フロー図_20251201.md（3.6追加） | 2025-12-06 |

## 整合性チェック結果

### 確認済み項目（すべて整合）
- アクター名: エンドユーザー、開発者
- サービス名: Frontend/PlantUML/AI/Excalidraw Service
- 外部システム名: Supabase、OpenRouter API、OpenAI API
- UC参照: UC 3-5, 3-6の定義と業務フロー図が一致
- Storage構成: Supabase Storage使用
- API Gateway: 業務フロー図で「省略」と明記済み
- 認証フロー: Supabase Auth - シーケンス図・業務フロー図で一致

### 発見した不整合と対応

**PlantUMLレンダリング方式の記述差異**

| ドキュメント | 修正前 | 修正後 |
|-------------|--------|--------|
| コンテキスト図 | 「PlantUML JAR同梱」「java -jar」 | 「node-plantuml（ローカルJAR）」 |
| 業務フロー図 | 「node-plantuml + Java 17 + Graphviz」 | 変更なし |

**対応**: コンテキスト図を更新し、node-plantumlがローカルJARを使用することを明確化。

## コンテキスト図の更新内容

### 1. PlantUML Service定義
```
修正前: "Cloud Run\n図表CRUD\nJAR同梱検証\nAI自動修正"
修正後: "Cloud Run\n図表CRUD\nnode-plantuml\n(ローカルJAR)"
```

### 2. コメント注記
- node-plantuml: PlantUML JARのNode.jsラッパー
- ローカルJAR: PlantUML Serviceコンテナに同梱
- 実行環境: Java 17 + Graphviz（コンテナ内）
- 公式サーバー不使用（プライバシー保護）

### 3. 内部コンポーネントテーブル
| コンポーネント | 同梱先 | 詳細 |
|--------------|-------|------|
| **node-plantuml** | PlantUML Service | Node.jsラッパー、ローカルJAR + Java 17 + Graphviz |
| **PlantUML JAR** | PlantUML Service | ローカル実行、公式サーバー不使用（プライバシー保護） |

## API Gatewayの扱い

### 問題
- コンテキスト図: Frontend → API Gateway → バックエンドサービス
- 業務フロー図: Frontend → 直接バックエンドサービス

### 対応方針
**選択肢B**を採用: 業務フロー図は「論理フロー」として、API Gatewayは暗黙的に存在すると明記

### 更新内容
1. 業務フロー図に「業務フロー図の表現について」セクション追加
2. API Gatewayが暗黙的に介在することを明記
3. サービス一覧テーブルの「図では省略」を「暗黙的に介在」に変更

## 結論

全ドキュメント間で整合性が取れていることを確認。
- ローカルJARによるプライバシー保護が重要なポイント
- API Gatewayは全フローで暗黙的に介在（業務フローの可読性を優先）
