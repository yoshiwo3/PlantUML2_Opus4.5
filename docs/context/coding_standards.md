# コーディング規約（Coding Standards）

**最終更新**: 2025-11-30

---

## 言語別規約

### TypeScript

#### ファイル構成

```
src/
├── components/      # UIコンポーネント
├── lib/             # ユーティリティ関数
├── types/           # 型定義
├── hooks/           # カスタムフック
└── app/             # Next.js App Router
```

#### 命名規則

```typescript
// PascalCase（コンポーネント、クラス）
export function MyComponent() { }
export class UserService { }

// camelCase（関数、変数）
export const myFunction = () => { };
export const userData = {};

// snake_case禁止
```

#### 型定義

```typescript
// 型アノテーション必須
function processData(input: string): number {
  return parseInt(input, 10);
}

// any禁止
```

---

### Markdown

#### 見出しレベル

```markdown
# H1: ドキュメントタイトル（1つのみ）
## H2: セクション
### H3: サブセクション
#### H4: 詳細項目
```

#### コードブロック

````markdown
```typescript
// 言語指定必須
const example = "Hello, World!";
```
````

---

### PlantUML

#### 検証ルール

- すべてのPlantUMLコードは`mcp__plantuml-validator__generate_plantuml_diagram`で検証必須
- 検証失敗時は修正→再検証（最大5回）
- 検証スキップ・エラー無視禁止

#### ファイル規則

- 拡張子: `.puml`
- エンコーディング: UTF-8
- 開始/終了タグ必須: `@startuml` / `@enduml`

---

## AI生成コードの識別

### コミットメッセージ

```
feat(scope): 機能追加

AI生成コード:
- src/file1.ts (100% AI生成)
- src/file2.ts (80% AI生成, 20% 手動修正)

Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

---

**次のレビュー予定**: 2025-12-07
