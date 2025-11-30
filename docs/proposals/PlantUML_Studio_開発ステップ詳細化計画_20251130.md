# PlantUML Studio 開発ステップ詳細化計画

**作成日**: 2025-11-30
**バージョン**: 1.0
**ステータス**: 承認済み

---

## 概要

`PlantUML_Studio_最新開発ステップ詳細_20251130.md`の6つの重要なWeekを日次タスクレベルまで詳細化した計画書。

---

## 対象Week一覧

| Week | タイトル | Phase | 合計時間 |
|------|---------|-------|----------|
| Week 2 | Monaco Editor統合 | Phase 1 | 29h |
| Week 7 | ファイル管理 | Phase 1 | 30h |
| Week 9 | AI Question-Start基盤 | Phase 1 | 30h |
| Week 11 | 検証ループ | Phase 1 | 30h |
| Week 21 | フェーズ認識システム | Phase 2 | 30h |
| Week 24 | 用語一貫性チェッカー | Phase 2 | 30h |

**合計**: 99タスク / 179時間

---

## Week 2: Monaco Editor統合（29h）

### 日次タスク分解

| Day | タスク | 時間 | 成果物 |
|-----|--------|------|--------|
| Day 1 | Monaco基本統合 + SSR無効化 | 6h | `MonacoEditor.tsx` |
| Day 2 | PlantUML構文ハイライト定義（50+キーワード） | 6h | `plantuml-language.ts` |
| Day 3 | 自動補完実装（CompletionItemProvider） | 6h | `plantuml-completions.ts` |
| Day 4 | テーマ対応（Light/Dark）+ Undo/Redo | 5h | `ThemeToggle.tsx` |
| Day 5 | 統合テスト + バグ修正 | 6h | テスト合格 |

### ファイル構成

```
/components/editor/
  ├── MonacoEditor.tsx      # メインエディタコンポーネント
  └── ThemeToggle.tsx       # テーマ切替ボタン

/lib/monaco/
  ├── plantuml-language.ts  # 言語定義（キーワード、トークン）
  ├── plantuml-completions.ts # 自動補完プロバイダー
  └── plantuml-themes.ts    # ライト/ダークテーマ定義

/hooks/
  ├── useEditorTheme.ts     # テーマ状態管理
  └── useMonaco.ts          # Monaco初期化フック
```

### 依存ライブラリ

- `@monaco-editor/react`: ^4.6.0
- `monaco-editor`: ^0.45.0

### 技術的考慮事項

- Next.js App RouterでのSSR無効化（dynamic import + ssr: false）
- Monaco Workerの適切な設定
- メモリリーク防止のためのクリーンアップ処理

---

## Week 7: ファイル管理（30h）

### 日次タスク分解

| Day | タスク | 時間 | 成果物 |
|-----|--------|------|--------|
| Day 1 | Supabase Storage設定 + RLS | 6h | `diagrams`バケット |
| Day 2 | バージョン保存API（SHA-256ハッシュ） | 6h | `POST /api/diagrams/[id]/versions` |
| Day 3 | バージョン履歴UI | 6h | `VersionHistory.tsx` |
| Day 4 | Diff表示 + ドラフト自動保存（30秒） | 6h | `DiffViewer.tsx`, `useAutoSave.ts` |
| Day 5 | 手動保存（Ctrl+S）+ テスト | 6h | テスト合格 |

### 主要インターフェース

```typescript
interface DiagramVersion {
  id: string;
  diagram_id: string;
  version: number;
  file: string;           // "versions/v001.puml"
  created_at: string;
  content_hash: string;   // SHA-256
  user_id: string;
}

interface VersionHistoryProps {
  diagramId: string;
  onRestore: (version: DiagramVersion) => void;
}
```

### RLSポリシー

```sql
-- diagrams_versionsテーブルのRLS
CREATE POLICY "Users can view own diagram versions"
ON diagrams_versions FOR SELECT
USING (user_id = auth.uid());

CREATE POLICY "Users can create own diagram versions"
ON diagrams_versions FOR INSERT
WITH CHECK (user_id = auth.uid());
```

---

## Week 9: AI Question-Start基盤（30h）

### 日次タスク分解

| Day | タスク | 時間 | 成果物 |
|-----|--------|------|--------|
| Day 1 | OpenRouter API統合 + ストリーミング | 6h | `openrouter-client.ts` |
| Day 2 | システムプロンプト + 図表タイプ推論 | 6h | `prompts/system.ts` |
| Day 3 | 質問UIコンポーネント | 6h | `QuestionStartPanel.tsx` |
| Day 4 | 質問テンプレート20種 + API | 6h | `question-templates.json` |
| Day 5 | テスト + プロンプト調整 | 6h | 精度80%以上 |

### API仕様

```typescript
// POST /api/ai/generate
interface GenerateRequest {
  prompt: string;
  diagramType?: DiagramType;
  context?: string;
}

interface GenerateResponse {
  code: string;
  diagramType: DiagramType;
  confidence: number;
  suggestions?: string[];
}

type DiagramType =
  | 'sequence'
  | 'class'
  | 'usecase'
  | 'activity'
  | 'state'
  | 'component'
  | 'deployment'
  | 'er'
  | 'mindmap'
  | 'gantt';
```

### 質問テンプレート例

```json
{
  "templates": [
    {
      "id": "sequence_api",
      "category": "シーケンス図",
      "question": "APIリクエストのフローを教えてください",
      "followUp": ["認証は必要ですか？", "エラーハンドリングは？"]
    },
    {
      "id": "class_domain",
      "category": "クラス図",
      "question": "主要なドメインオブジェクトは何ですか？",
      "followUp": ["継承関係はありますか？", "多重度は？"]
    }
  ]
}
```

---

## Week 11: 検証ループ（30h）

### 日次タスク分解

| Day | タスク | 時間 | 成果物 |
|-----|--------|------|--------|
| Day 1 | PlantUML検証API + エラーパース | 6h | `POST /api/validate` |
| Day 2 | MCP Validator連携 + フォールバック | 6h | `validator.ts` |
| Day 3 | エラーハイライト + 通知システム | 6h | `error-markers.ts` |
| Day 4 | AI自動修正ループ（最大3回） | 6h | `validation-loop.ts` |
| Day 5 | 統合テスト + 500ms以内最適化 | 6h | テスト合格 |

### 検証フロー

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  コード入力  │───▶│  検証API    │───▶│  成功       │───▶ プレビュー表示
└─────────────┘    └─────────────┘    └─────────────┘
                          │
                          ▼ 失敗
                   ┌─────────────┐
                   │ AI修正提案  │
                   └─────────────┘
                          │
                          ▼ 承認
                   ┌─────────────┐
                   │  再検証     │◀──┐
                   │ (最大3回)   │───┘
                   └─────────────┘
```

### エラーハンドリング

```typescript
interface ValidationError {
  line: number;
  column: number;
  message: string;
  severity: 'error' | 'warning';
  suggestion?: string;
}

interface ValidationResult {
  valid: boolean;
  errors: ValidationError[];
  svg?: string;           // 成功時のみ
  processingTime: number; // ミリ秒
}
```

---

## Week 21: フェーズ認識システム（30h）

### 日次タスク分解

| Day | タスク | 時間 | 成果物 |
|-----|--------|------|--------|
| Day 1 | ProjectPhase enum + DBマイグレーション | 6h | `ProjectPhase` 6種 |
| Day 2 | フェーズ認識AIプロンプト | 6h | `phase-recognition.ts` |
| Day 3 | フェーズ選択UI | 6h | `PhaseSelector.tsx` |
| Day 4 | フェーズ進捗トラッキング | 6h | `progress-calculator.ts` |
| Day 5 | テスト + 遷移提案 | 6h | 精度90%以上 |

### ProjectPhase定義

```typescript
enum ProjectPhase {
  REQUIREMENTS = 'requirements',      // 要件定義
  BASIC_DESIGN = 'basic_design',      // 基本設計
  DETAILED_DESIGN = 'detailed_design', // 詳細設計
  IMPLEMENTATION = 'implementation',   // 実装
  TESTING = 'testing',                 // テスト
  OPERATION = 'operation'              // 運用
}

interface PhaseConfig {
  phase: ProjectPhase;
  label: string;
  diagramTypes: DiagramType[];  // 推奨される図表タイプ
  templates: string[];          // 推奨テンプレート
}

const PHASE_CONFIGS: PhaseConfig[] = [
  {
    phase: ProjectPhase.REQUIREMENTS,
    label: '要件定義',
    diagramTypes: ['usecase', 'mindmap', 'activity'],
    templates: ['usecase_basic', 'stakeholder_map']
  },
  // ...
];
```

### DBマイグレーション

```sql
-- projectsテーブルにphaseカラム追加
ALTER TABLE projects
ADD COLUMN phase VARCHAR(50) DEFAULT 'requirements';

-- フェーズ履歴テーブル
CREATE TABLE phase_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id),
  from_phase VARCHAR(50),
  to_phase VARCHAR(50),
  changed_at TIMESTAMPTZ DEFAULT NOW(),
  changed_by UUID REFERENCES auth.users(id)
);
```

---

## Week 24: 用語一貫性チェッカー（30h）

### 日次タスク分解

| Day | タスク | 時間 | 成果物 |
|-----|--------|------|--------|
| Day 1 | Levenshtein距離 + 類似検出（閾値0.8） | 6h | `term-similarity.ts` |
| Day 2 | EntityGlossary + 用語抽出エンジン | 6h | `entity-extractor.ts` |
| Day 3 | 一貫性チェックUI | 6h | `ConsistencyChecker.tsx` |
| Day 4 | 自動統一 + 一括置換 | 6h | `apply-consistency-fix` API |
| Day 5 | テスト + 閾値調整 | 6h | テスト合格 |

### 依存ライブラリ

- `js-levenshtein`: ^1.1.6

### 類似度計算

```typescript
import levenshtein from 'js-levenshtein';

interface TermSimilarity {
  term1: string;
  term2: string;
  similarity: number;  // 0.0 - 1.0
}

function calculateSimilarity(a: string, b: string): number {
  const distance = levenshtein(a.toLowerCase(), b.toLowerCase());
  const maxLength = Math.max(a.length, b.length);
  return 1 - distance / maxLength;
}

function findSimilarTerms(
  terms: string[],
  threshold: number = 0.8
): TermSimilarity[] {
  const results: TermSimilarity[] = [];

  for (let i = 0; i < terms.length; i++) {
    for (let j = i + 1; j < terms.length; j++) {
      const similarity = calculateSimilarity(terms[i], terms[j]);
      if (similarity >= threshold && similarity < 1.0) {
        results.push({
          term1: terms[i],
          term2: terms[j],
          similarity
        });
      }
    }
  }

  return results;
}
```

### EntityGlossaryインターフェース

```typescript
interface GlossaryEntry {
  id: string;
  term: string;           // 正式名称
  aliases: string[];      // 別名・略称
  definition: string;     // 定義
  category: string;       // カテゴリ
  projectId: string;
}

interface ConsistencyIssue {
  id: string;
  term1: string;
  term2: string;
  similarity: number;
  locations: TermLocation[];
  suggestedAction: 'merge' | 'keep_both' | 'review';
}
```

---

## 重要ファイル一覧

実装時に参照すべきファイル：

1. `docs/proposals/PlantUML_Studio_最新開発ステップ詳細_20251130.md` - 基盤ドキュメント
2. `docs/design/PlantUML_Studio_ファイル管理・バージョン管理仕様_20251129.md` - Week 7仕様
3. `docs/design/PlantUML_Studio_目的別AIチャット機能仕様_20251129.md` - Week 21/24仕様
4. `.serena/memories/phase2_ai_chat_design_2025-11-29.md` - Phase 2設計

---

## 企画書レビュー結果（doc-reviewer）

**総合スコア: 88/100**

### スコア内訳

| 観点 | スコア |
|------|--------|
| 技術的正確性 | 88/100 |
| プロジェクト整合性 | 92/100 |
| 履歴分析 | 95/100 |
| 業界動向 | 85/100 |
| ドキュメント品質 | 82/100 |

### 高優先度の改善提案

1. **目次の追加** - 4,300行のドキュメントにナビゲーションがない
2. **競合分析の更新** - 2025年のAI機能を持つ競合製品の分析が不足
3. **TD-012反映** - Cloud Run一本化の決定後、Vercel関連記述が残存

### 中優先度の改善提案

4. Supabase Realtime記述を最新API仕様に更新
5. OpenAIモデル名を`gpt-4o-mini`に更新
6. デプロイ戦略セクションの統合

### 具体的な修正箇所

- 行 728-729: `gpt-4` → `gpt-4o-mini`
- 行 2923: `@endluml` → `@enduml` (typo)
- 行 14-15: バージョン1.0 → 2.5に更新

---

## 変更履歴

| バージョン | 日付 | 変更内容 |
|-----------|------|----------|
| 1.0 | 2025-11-30 | 初版作成 |
