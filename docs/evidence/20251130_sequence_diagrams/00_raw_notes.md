# Raw Notes: シーケンス図作成 2025-11-30

## セッション記録

### 1. ログインシーケンス図作成

#### Context7検証結果

**Supabase SSR公式ドキュメント**

重要な発見:
- `getAll()`/`setAll()` パターンが必須
- `get`/`set`/`remove` は動作しない（BREAKS APPLICATION）
- `getUser()` in middleware（NOT `getSession()`）
- `await cookies()` for Next.js 15

```typescript
// 正しいパターン
cookies: {
  getAll() {
    return cookieStore.getAll()
  },
  setAll(cookiesToSet) {
    try {
      cookiesToSet.forEach(({ name, value, options }) =>
        cookieStore.set(name, value, options)
      )
    } catch {
      // Server Componentから呼ばれた場合は無視
    }
  }
}
```

**セッション検証の重要事項**
- `createServerClient`と`getUser()`の間にコードを入れない
- 入れると予期せぬログアウトが発生

**ログアウト方式**
- クライアント側: `signOut()` + `router.refresh()`
- サーバー側（推奨）: `signOut()` + `revalidatePath('/', 'layout')`

### 2. 編集・プレビューシーケンス図作成

#### 設計図表集との不整合発見

| 項目 | 初期作成 | 設計図表集 |
|------|---------|-----------|
| PlantUMLレンダリング | PlantUML Server API (外部) | node-plantuml + Java 17 + Graphviz (内部) |
| テキストエディタ | CodeMirror | Monaco Editor |
| 検証処理 | サーバーAPIへHTTP | ValidationService (内部API Routes) |

**修正実施**: 設計図表集に合わせて全面修正

#### Context7検証結果

**Excalidraw React公式ドキュメント**

重要な発見:
- SSR無効化必須（Dynamic Import with ssr: false）
- `excalidrawAPI` prop でAPI取得
- `onChange(elements, appState, files)` でリアルタイム更新

```typescript
// SSR無効化
const Excalidraw = dynamic(
  () => import('@excalidraw/excalidraw').then(mod => mod.Excalidraw),
  { ssr: false }
)
```

### 3. PlantUML構文エラー修正

**発見**: `note bottom of middleware` - シーケンス図では使用不可

**修正**: `note over middleware` に変更

## 学んだこと

1. シーケンス図作成前に必ず設計図表集を確認する
2. Context7で外部ライブラリの正確な仕様を検証する
3. PlantUML構文でシーケンス図固有の制約に注意する
