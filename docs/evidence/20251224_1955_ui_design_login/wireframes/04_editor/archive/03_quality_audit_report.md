# 02_screen_composition_analysis.md 品質監査レポート

**監査日時**: 2025-12-29
**対象ファイル**: `02_screen_composition_analysis.md` v8.2
**監査者**: Claude Opus 4.5
**目的**: 正確性検証、トレーサビリティ強化、実装可能性確認

---

## 1. 情報棚卸し（Information Inventory）

### 1.1 ドキュメント構成

| セクション | 行範囲 | 情報カテゴリ | 情報量 |
|:----------:|--------|-------------|:------:|
| §1 | 1-76 | TD一覧、MVP/延期分類 | 高 |
| §2 | 77-310 | 画面レイアウト、モーダル構造 | 最高 |
| §3 | 311-340 | 評価フレームワーク | 中 |
| §4 | 341-700 | 13項目詳細評価 | 高 |
| §5 | 701-770 | 総合評価スコア | 中 |
| §6 | 771-850 | 問題解決状況 | 中 |
| §7 | 851-920 | 将来アクション | 低 |
| §8 | 921-1000 | 改善提案 | 中 |
| §9 | 1001-1030 | 結論 | 低 |
| §10 | 1031-1060 | 更新履歴 | 低 |
| §11 | 1061-1170 | 議論経緯（Phase 2） | 高 |
| §12 | 1171-2709 | TD-028詳細設計（6サブセクション）| 最高 |

### 1.2 TD参照一覧（17TD）

| TD | タイトル | 参照状況 | 詳細定義 | 優先度 |
|:--:|---------|:--------:|:--------:|:------:|
| TD-017 | GUIパネル動的切り替え | ✅ | ✅ | MVP |
| TD-018 | パネル間同期 | ✅ | △ | MVP |
| TD-019 | 2層統合モーダル v2.1 | ✅ | ✅ | MVP |
| TD-020 | 2レベルGUI編集 v2.0 | ✅ | ✅ | MVP |
| TD-021 | パネルモード切替 | ✅ | △ | MVP |
| TD-022 | GUIパネル内部構成 | ✅ | △ | MVP |
| TD-023 | 基本レイアウト | ✅ | ✅ | MVP |
| TD-024 | Undo/Redo | ✅ | △ | v1.1延期 |
| TD-025 | WCAG準拠 | ✅ | △ | v1.1延期 |
| TD-026 | オンボーディング | ✅ | △ | v1.1延期 |
| TD-027 | 編集状態表示 | ✅ | △ | MVP |
| TD-028 | AIコード適用 | ✅ | **✅✅** | MVP |
| TD-029 | ローカルバックアップ | ✅ | △ | v1.1延期 |
| TD-030 | Previewズーム | ✅ | △ | MVP |
| TD-031 | ダークモード | ✅ | △ | v1.1延期 |
| TD-032 | AIチャット折りたたみ | ✅ | △ | MVP |
| TD-033 | ショートカットヘルプ | ✅ | △ | MVP |

**凡例**: ✅=定義あり、✅✅=詳細定義あり、△=概要のみ

### 1.3 UC参照一覧

| UC | 名称 | 明示的参照 | 暗黙的カバー |
|:--:|------|:----------:|:------------:|
| UC 3-1 | 図表作成 | ✅ | - |
| UC 3-2 | テンプレート選択 | ✅ | - |
| UC 3-3 | コード編集 | ✅ | - |
| UC 3-4 | プレビュー | ✅ | - |
| UC 3-5 | 保存 | △ | - |
| UC 3-6 | エクスポート | △ | - |
| UC 4-1 | AI Question-Start | ✅ | - |
| UC 4-2 | AIチャット | ✅ | - |

---

## 2. 型定義インベントリ（Type Definition Inventory）

### 2.1 定義済みインターフェース

| Interface | 行番号 | 完全性 | 問題点 |
|-----------|:------:|:------:|--------|
| `SelectedElement` | 1382-1385 | ✅ | 完全 |
| `ErrorFixRequest` | 1742-1749 | ⚠️ | AttemptRecordを参照 |
| `AttemptRecord` | 1751-1755 | ✅ | 完全（ErrorFixRequestの後で定義） |
| `Constitution` | 2070-2108 | ✅ | 完全 |
| `IConstitutionProvider` | 2296-2313 | ✅ | 完全 |
| `IConstitutionResolver` | 2320-2328 | ✅ | 完全 |
| `ResolvedConstitution` | 2330-2341 | ✅ | 完全 |
| `IPromptBuilder` | 2348-2355 | ✅ | 完全 |
| `PromptContext` | 2357-2367 | ✅ | 完全 |
| `LLMType` | 2369 | ✅ | 完全 |
| `DiagramType` | 2370 | ✅ | 完全 |

### 2.2 欠落型定義

| 欠落型 | 参照箇所 | 影響度 | 推奨定義 |
|--------|---------|:------:|----------|
| `OutputFormat` | 2335, 2410 | 高 | `{ wrapper?: string; single_block?: boolean; no_explanation?: boolean; max_lines?: number; }` |
| `KnownIssue` | 2336, 2411 | 高 | `{ id: string; description: string; workaround: string; }` |
| `ErrorInfo` | 2365 | 中 | `{ message: string; lineNumber: number; code: string; }` |
| `ITemplateEngine` | 2453 | 中 | `{ render(template: string, variables: object): string; }` |

### 2.3 型定義詳細（追加推奨）

```typescript
// 欠落型の推奨定義

interface OutputFormat {
  wrapper?: string;         // コードラッパー（例: "```plantuml"）
  single_block?: boolean;   // 単一ブロック出力強制
  no_explanation?: boolean; // 説明文禁止
  max_lines?: number;       // 最大行数制限
}

interface KnownIssue {
  id: string;               // 例: "SEQ-001", "ACT-002"
  description: string;      // 問題の説明
  workaround: string;       // 回避策
}

interface ErrorInfo {
  message: string;          // エラーメッセージ
  lineNumber: number;       // エラー行番号
  code: ErrorCode;          // エラーコード（enum）
}

interface ITemplateEngine {
  render(template: string, variables: Record<string, unknown>): string;
}
```

---

## 3. トレーサビリティマトリクス

### 3.1 UC → TD → 仕様 → 実装 マッピング

| UC | TD | 仕様セクション | 型定義 | 実装コード例 | 検証状態 |
|:--:|:--:|---------------|:------:|:------------:|:--------:|
| UC 3-3 | TD-017 | §2.2-2.4 | - | - | △ |
| UC 3-3 | TD-018 | §2.1 (概要) | - | - | △ |
| UC 3-3 | TD-019 | §2.3 | - | - | ✅ |
| UC 3-3 | TD-020 | §2.4 | - | - | ✅ |
| UC 3-4 | TD-023 | §2.1 | - | - | ✅ |
| UC 4-1 | TD-028 | §12.1-12.5 | SelectedElement | buildApplyPrompt | ✅ |
| UC 4-2 | TD-028 | §12.6-12.9 | ErrorFixRequest | handleSyntaxError | ✅ |
| UC 4-2 | TD-028 | §12.12 | AttemptRecord | handleSyntaxError | ✅ |
| UC 4-2 | TD-028 | §12.13 | Constitution系 | HierarchicalResolver | ✅ |

### 3.2 TD詳細度評価

| 詳細度 | TD | 説明 |
|:------:|:---|------|
| **完全** | TD-028 | 型定義、実装コード、フロー図、エッジケース全て定義 |
| **完全** | TD-019 | 画面構成、UI詳細、却下理由含む |
| **完全** | TD-020 | 操作パターン、要素別対応表含む |
| **概要** | TD-017 | Registry Pattern言及あるが詳細なし |
| **概要** | TD-018 | 同期方式の詳細なし |
| **概要** | TD-021-027, 029-033 | 概要レベルのみ |

### 3.3 トレーサビリティギャップ

| ギャップ | 影響 | 対策 |
|---------|------|------|
| TD-018 パネル間同期の実装詳細なし | 高 | Pub/Sub or Zustand設計を追加 |
| TD-021 パネルモード切替の状態管理なし | 中 | React State設計を追加 |
| TD-027 編集状態表示のUI仕様なし | 中 | ビジュアル仕様を追加 |
| UC 3-5/3-6 保存/エクスポートの画面仕様なし | 低 | 本ドキュメントのスコープ外 |

---

## 4. 実装可能性チェックリスト

### 4.1 実装必須要素の完全性

| 要素 | 定義状態 | 実装可能性 | 備考 |
|------|:--------:|:----------:|------|
| **画面レイアウト（3パネル）** | ✅ | ✅ | px単位で定義済み |
| **モーダル構造（2層）** | ✅ | ✅ | HTML構造例含む |
| **GUI編集（2レベル）** | ✅ | ✅ | 操作パターン定義済み |
| **AIコード適用フロー** | ✅ | ✅ | 実装コード例含む |
| **エラー修正フロー** | ✅ | ✅ | 完全な実装コード例 |
| **階層的憲法システム** | ✅ | ✅ | ディレクトリ構成、YAML例含む |
| **Monaco Editor連携** | △ | △ | setValue()のみ、getSelection()なし |
| **パネル同期** | △ | ⚠️ | 実装詳細不足 |

### 4.2 API契約検証

| API/メソッド | パラメータ | 戻り値 | 検証状態 |
|-------------|-----------|--------|:--------:|
| `buildApplyPrompt()` | originalRequest, target, appliedCode | string | ✅ |
| `extractPlantUMLCode()` | response | string \| null | ✅ |
| `handleApplyCode()` | 4 params | Promise<void> | ✅ |
| `buildErrorFixPrompt()` | ErrorFixRequest | string | ✅ |
| `extractSurroundingCode()` | fullCode, errorLine, contextLines | string | ✅ |
| `handleSyntaxError()` | 4 params | Promise<void> | ✅ |
| `HierarchicalResolver.resolve()` | llm, diagramType | Promise<ResolvedConstitution> | ✅ |
| `ApplyPromptBuilder.build()` | PromptContext | Promise<string> | ✅ |

### 4.3 実装上の注意点

| # | 注意点 | セクション | 対応方針 |
|:-:|--------|-----------|----------|
| 1 | `MAX_ATTEMPTS = 5` はハードコード | §12.12.9 | 環境変数化推奨 |
| 2 | 憲法ファイルパスはハードコード | §12.13.3 | 設定ファイル化推奨 |
| 3 | Monaco Editor getSelection() 未定義 | §12.3 | 追加定義必要 |
| 4 | WebSocket/SSE仕様なし | - | ストリーミング検討時に追加 |

---

## 5. 重複コンテンツ分析

### 5.1 重複箇所一覧

| 内容 | 出現箇所 | 行数 | 正規化提案 |
|------|---------|:----:|-----------|
| 決定事項サマリー | §6, §12.9, §12.12.10 | ~60 | §12.14 に統合参照 |
| エラーフロー図 | §12.7, §12.12.5, §12.12.9 | ~50 | §12.12.9 を正とし他は参照 |
| MVP vs v1.1 表 | §1.2, §12.13.13 | ~30 | §1.2 を正とし §12 は参照 |
| プロンプト例 | §12.6, §12.13.10 | ~30 | §12.13.10 を正とし §12.6 は概要化 |

### 5.2 重複排除戦略（情報消失ゼロ）

**原則**: 削除ではなく「正規化 + 参照」方式

```markdown
# 重複排除例

## 変更前（重複）
### §12.9 決定事項サマリー
| カテゴリ | 項目 | 決定内容 |
|---------|------|---------|
| 技術制約 | AI直接修正 | 不可能 |
...（20行続く）

### §12.12.10 決定事項サマリー
| カテゴリ | 項目 | 決定内容 |
|---------|------|---------|
| 通知方式 | エラー表示 | Previewバナー |
...（15行続く）

## 変更後（正規化）
### §12.9 基本決定事項サマリー
> **完全版**: §12.14 統合決定事項一覧を参照

| カテゴリ | 項目 | 決定内容 |
|---------|------|---------|
| 技術制約 | AI直接修正 | 不可能（システム経由で適用） |
| 適用処理 | Undo | Ctrl+Z 1回で全復元 |
（主要5項目のみ抜粋）

### §12.12.10 エラー処理決定事項
> **関連**: §12.9 基本決定事項、§12.14 統合一覧

（エラー処理固有の5項目のみ）
```

---

## 6. 改善推奨事項

### 6.1 優先度P0（実装前に必須）

| # | 項目 | 対応方法 |
|:-:|------|---------|
| 1 | OutputFormat型定義追加 | §2.3の推奨定義を追加 |
| 2 | KnownIssue型定義追加 | §2.3の推奨定義を追加 |
| 3 | Monaco getSelection() 仕様追加 | §12.3にAPI定義追加 |

### 6.2 優先度P1（実装時に推奨）

| # | 項目 | 対応方法 |
|:-:|------|---------|
| 4 | TD-018 パネル同期詳細 | 別セクション or 別ファイルで定義 |
| 5 | 重複の正規化 | §12.14 統合決定事項セクション作成 |
| 6 | 環境変数一覧 | MAX_ATTEMPTS等の設定項目リスト作成 |

### 6.3 優先度P2（将来改善）

| # | 項目 | 対応方法 |
|:-:|------|---------|
| 7 | §11 議論履歴の分離 | 別ファイル `04_design_discussion_log.md` |
| 8 | トレーサビリティID付与 | REQ-XXX形式の要件ID追加 |
| 9 | テスト仕様追加 | 主要関数のユニットテストケース定義 |

---

## 7. 結論

### 7.1 総合評価

| 評価軸 | スコア | 判定 |
|--------|:------:|:----:|
| **情報完全性** | 92/100 | A |
| **技術的正確性** | 85/100 | B+ |
| **トレーサビリティ** | 75/100 | B- |
| **実装可能性** | 88/100 | B+ |
| **保守性** | 78/100 | B |
| **総合** | **83.6/100** | **B+** |

### 7.2 実装への推奨アクション

1. **即時対応**: 欠落型定義（OutputFormat, KnownIssue）を追加
2. **実装前**: Monaco Editor API仕様の補完
3. **実装中**: TD-018パネル同期の詳細設計
4. **実装後**: 重複コンテンツの正規化

### 7.3 情報消失リスク評価

| リスク | レベル | 理由 |
|--------|:------:|------|
| **現状維持** | 低 | 全情報は保持されている |
| **重複統合時** | 中 | 正規化+参照方式で回避可能 |
| **セクション分離時** | 低 | ファイル分割は内容保持 |

---

## 8. 付録

### 8.1 全型定義一覧（検証用）

```typescript
// 定義済み型
interface SelectedElement { text: string; lineNumber: number; }
interface AttemptRecord { attemptNumber: number; errorMessage: string; appliedFix: string; }
interface ErrorFixRequest { originalRequest: string; errorMessage: string; errorLineNumber: number; surroundingCode: string; fullCode: string; attemptHistory: AttemptRecord[]; }
interface Constitution { version: string; type: 'base'|'llm'|'diagram'|'combined'; extends?: string|string[]; /* ... */ }
interface IConstitutionProvider { load(path: string): Promise<Constitution|null>; list(): Promise<string[]>; getVersion(path: string): Promise<string|null>; }
interface IConstitutionResolver { resolve(llm: LLMType, diagramType: DiagramType): Promise<ResolvedConstitution>; }
interface ResolvedConstitution { requirements: string[]; prohibitions: string[]; recommendations: string[]; outputFormat: OutputFormat; knownIssues: KnownIssue[]; resolvedFrom: string[]; resolvedAt: Date; }
interface IPromptBuilder { build(context: PromptContext): Promise<string>; }
interface PromptContext { type: 'apply'|'error_fix'|'generate'; llm: LLMType; diagramType: DiagramType; userRequest: string; currentCode?: string; targetElements?: SelectedElement[]; appliedCode?: string; errorInfo?: ErrorInfo; attemptHistory?: AttemptRecord[]; }
type LLMType = 'claude'|'gpt4'|'gemini'|'llama'|'mistral';
type DiagramType = 'sequence'|'class'|'activity'|'usecase'|'state'|'component';

// 追加推奨型
interface OutputFormat { wrapper?: string; single_block?: boolean; no_explanation?: boolean; max_lines?: number; }
interface KnownIssue { id: string; description: string; workaround: string; }
interface ErrorInfo { message: string; lineNumber: number; code: ErrorCode; }
interface ITemplateEngine { render(template: string, variables: Record<string, unknown>): string; }
```

---

*監査完了: 2025-12-29*
*ファイルバージョン: v1.0*
