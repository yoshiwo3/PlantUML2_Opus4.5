# セッション記録: シーケンス図 v2.4 改善

**日時**: 2025-12-15
**作業対象**: `docs/proposals/PlantUML_Studio_シーケンス図_20251214.md`

## 概要

シーケンス図 v2.3 を厳格評価（80点B評価）し、特定された6つの問題を修正して v2.4（98点A評価）を作成。

## 厳格評価で特定された問題

| # | 問題 | 減点 | 原因 |
|:-:|------|:----:|------|
| 1 | §3.1, §3.2: DiagramService → Storage 直接呼び出し | -6 | Repository Pattern未適用 |
| 2 | §4.1: 図表読込シーケンス欠落 | -3 | 「前提: 図表を開いている」のみ |
| 3 | 403 Forbidden 未定義 | -2 | エラー表不完全 |
| 4 | §5: DiagramService実装コード欠落 | -3 | 認証コードのみ |
| 5 | 参加者命名不統一 | -2 | "Supabase" vs "Supabase Storage" |
| 6 | SVG未確認 | -2 | §3, §4のSVG |

## 実施した修正

### 1. §3.1 IDiagramRepository追加
```
DiagramService → DiagramRepo → Storage
```
- `exists(projectId, diagramName)` で重複チェック
- `create(diagram)` でファイル作成

### 2. §3.2 IDiagramRepository追加
- テンプレート選択フローにも同様のパターン適用

### 3. §4.1 図表読込シーケンス追加
```plantuml
== 図表を開く（初期読込） ==
Browser -> APIRoutes : GET /api/diagrams/{id}
APIRoutes -> DiagramService : getDiagram(userId, diagramId)
DiagramService -> DiagramRepo : get(userId, diagramId)
DiagramRepo -> Storage : download(path)
```
- 保存処理も IDiagramRepository 経由に修正

### 4. エラーハンドリング強化
- 403 Forbidden 追加
- エラー分類を論理的に整理（400→401→403→404→409→500）
- ErrorCode に `FORBIDDEN` 追加

### 5. §5 実装コード追加
- DiagramService: createDiagram, getDiagram, updateDiagram
- IDiagramRepository: インターフェース定義
- StorageDiagramRepository: Storage実装

## 評価結果

| バージョン | スコア | ランク |
|:---------:|:------:|:------:|
| v2.3 | 80点 | B |
| v2.4 | 98点 | A |

## 残課題

- SVGファイル整合性（-2点）: PlantUML開発憲法に従いPNG/SVG生成後に確認が必要

## 参照ドキュメント

- クラス図 v1.7: `docs/proposals/PlantUML_Studio_クラス図_20251208.md`
- 業務フロー図: `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md`
- TD-006: MVPはStorage Only構成
