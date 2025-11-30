# PlantUML Studio - シーケンス図: ログイン（OAuth）

**作成日**: 2025-11-30
**対象ユースケース**: UC 1-1 ログインする, UC 1-2 ログアウトする
**基準ドキュメント**: PlantUML_Studio_ユースケース図_20251130.md
**検証**: Context7 MCP（Supabase Auth公式ドキュメント）

---

## 概要

Supabase Authを使用したOAuth認証フロー（PKCE）を表現します。

**認証方式:**
- OAuth 2.0 + PKCE（GitHub / Google）

**参照:**
- [Supabase OAuth PKCE Flow](https://github.com/supabase/supabase/blob/master/apps/docs/content/_partials/oauth_pkce_flow.mdx)

---

## 1. OAuthログインフロー（PKCE）

```plantuml
@startuml PlantUML_Studio_Sequence_Login_OAuth
'==================================================
' シーケンス図: OAuthログインフロー（PKCE）
' UC 1-1 ログインする
' 検証: Context7 MCP - Supabase Auth公式ドキュメント
'==================================================

skinparam sequenceArrowThickness 2
skinparam roundcorner 10
skinparam maxmessagesize 200
skinparam sequenceParticipant underline

skinparam participant {
    BackgroundColor #FAFAFA
    BorderColor #666666
}

skinparam note {
    BackgroundColor #FFFDE7
    BorderColor #FBC02D
}

title OAuthログインフロー（GitHub/Google）- PKCE

actor "エンドユーザー" as user
participant "ブラウザ\n(Next.js Client)" as browser #E3F2FD
participant "Next.js\nRoute Handler\n(/auth/callback)" as callback #FFF3E0
participant "Supabase Auth" as supabase #E8F5E9
participant "OAuth Provider\n(GitHub/Google)" as oauth #FCE4EC

== 認証開始 ==

user -> browser : ログインボタンをクリック
activate browser

browser -> browser : OAuth Provider選択\n(GitHub/Google)

note right of browser
  **PKCE準備（supabase-js内部）**
  1. code_verifier生成（ランダム文字列）
  2. code_challenge = SHA256(code_verifier)
  3. state生成（CSRF対策）
  4. code_verifierをlocalStorageに保存
end note

browser -> supabase : signInWithOAuth({\n  provider: 'github',\n  options: { redirectTo }\n})
activate supabase

supabase --> browser : { data: { url } }\nOAuth認証URL\n(含: code_challenge, state)
deactivate supabase

browser -> oauth : リダイレクト\n(OAuth認証画面)
deactivate browser

== OAuth認証（外部） ==

activate oauth
oauth -> user : 認証画面表示\n(ログイン/権限確認)
user -> oauth : 認証情報入力\n+ アクセス許可

oauth -> oauth : 認証検証\n+ 認証コード生成

oauth --> browser : リダイレクト\n/auth/callback?code=xxx&state=yyy
deactivate oauth

== コールバック処理（サーバーサイド） ==

activate browser
browser -> callback : GET /auth/callback\n?code=xxx
activate callback

callback -> callback : URLからcode取得

callback -> supabase : exchangeCodeForSession(code)
activate supabase

note right of supabase
  **Supabase Auth内部処理**
  1. codeをOAuth Providerに送信
  2. access_token/refresh_token取得
  3. ユーザー情報取得
  4. auth.usersにユーザー作成/更新
  5. JWTセッション生成
end note

supabase -> oauth : POST /oauth/token\n(code + code_verifier)
activate oauth
oauth --> supabase : access_token\n+ refresh_token\n+ user_info
deactivate oauth

supabase -> supabase : ユーザー作成/更新\n(auth.users)
supabase -> supabase : JWTセッション生成

supabase --> callback : セッション情報
deactivate supabase

callback -> callback : Set-Cookie\n(セッションCookie)

callback --> browser : リダイレクト\n(ダッシュボード)
deactivate callback

== セッション確立 ==

browser -> browser : 認証状態更新\n(Context/Store)
browser --> user : ダッシュボード表示

deactivate browser

@enduml
```

---

## 2. セッション検証フロー（ページ遷移時）

```plantuml
@startuml PlantUML_Studio_Sequence_Session_Check
'==================================================
' シーケンス図: セッション検証フロー
' 保護ページアクセス時
' 検証: Context7 MCP - Supabase SSR公式ドキュメント
'==================================================

skinparam sequenceArrowThickness 2
skinparam roundcorner 10
skinparam maxmessagesize 200

skinparam participant {
    BackgroundColor #FAFAFA
    BorderColor #666666
}

skinparam note {
    BackgroundColor #FFFDE7
    BorderColor #FBC02D
}

title セッション検証フロー（Middleware）

actor "エンドユーザー" as user
participant "ブラウザ" as browser #E3F2FD
participant "Middleware\n(updateSession)" as middleware #FFF3E0
participant "Supabase Auth\n(@supabase/ssr)" as supabase #E8F5E9

== ページリクエスト ==

user -> browser : 保護ページにアクセス
activate browser

browser -> middleware : リクエスト\n+ Cookie
activate middleware

middleware -> middleware : createServerClient()\n+ cookies設定\n(getAll/setAll)

note right of middleware
  **重要: この間にコードを入れない**
  createServerClient()と
  getUser()の間に他の処理を
  入れると予期せぬログアウトが発生
end note

middleware -> supabase : **getUser()**
activate supabase

note right of supabase
  **getUser()の内部処理**
  1. Cookieからセッション取得
  2. JWT期限切れなら自動更新
  3. refresh_tokenでトークン再取得
  4. 新Cookieをレスポンスに設定
end note

supabase -> supabase : JWT検証\n+ 自動トークン更新

alt ユーザー認証済み
    supabase --> middleware : { data: { user } }
    deactivate supabase

    middleware --> browser : supabaseResponse\n(元のレスポンス + 更新Cookie)
    browser --> user : 保護ページ表示

else ユーザー未認証（user: null）
    supabase --> middleware : { data: { user: null } }
    deactivate supabase

    middleware -> middleware : パス確認\n(/login, /auth は除外)

    alt 保護ページへのアクセス
        middleware --> browser : NextResponse.redirect\n(/login)
        browser --> user : ログインページへ
    else 公開ページへのアクセス
        middleware --> browser : supabaseResponse
        browser --> user : ページ表示
    end
end

deactivate middleware
deactivate browser

note over middleware
  **重要: supabaseResponseをそのまま返す**
  新しいNextResponse.next()を作る場合:
  1. request を渡す
  2. cookiesをコピー
  これを怠るとセッション同期が壊れる
end note

@enduml
```

---

## 3. ログアウトフロー

### 3-A. クライアント側ログアウト

```plantuml
@startuml PlantUML_Studio_Sequence_Logout_Client
'==================================================
' シーケンス図: ログアウトフロー（クライアント側）
' UC 1-2 ログアウトする
' 検証: Context7 MCP - Supabase SSR公式ドキュメント
'==================================================

skinparam sequenceArrowThickness 2
skinparam roundcorner 10
skinparam maxmessagesize 200

skinparam participant {
    BackgroundColor #FAFAFA
    BorderColor #666666
}

skinparam note {
    BackgroundColor #FFFDE7
    BorderColor #FBC02D
}

title ログアウトフロー（クライアント側）

actor "エンドユーザー" as user
participant "ブラウザ\n(Client Component)" as browser #E3F2FD
participant "Supabase Auth\n(@supabase/ssr)" as supabase #E8F5E9
participant "Next.js Router" as router #FFF3E0

== ログアウト ==

user -> browser : ログアウトボタンをクリック
activate browser

browser -> supabase : signOut()
activate supabase

supabase -> supabase : セッション無効化\n(Supabaseサーバー側)
supabase -> supabase : Cookie削除指示

supabase --> browser : 成功
deactivate supabase

browser -> browser : ローカルセッション削除\n- Cookie\n- localStorage(キャッシュ)

browser -> router : router.push('/login')
activate router
router --> browser : ナビゲーション

browser -> router : **router.refresh()**
note right of router
  **重要: router.refresh()**
  サーバーコンポーネントを
  再検証してキャッシュをクリア
  これがないと古い認証状態が残る
end note

router --> browser : サーバーコンポーネント再検証
deactivate router

browser --> user : ログインページ表示

deactivate browser

@enduml
```

### 3-B. サーバー側ログアウト（推奨）

```plantuml
@startuml PlantUML_Studio_Sequence_Logout_Server
'==================================================
' シーケンス図: ログアウトフロー（サーバー側 - 推奨）
' UC 1-2 ログアウトする
' 検証: Context7 MCP - Supabase SSR公式ドキュメント
'==================================================

skinparam sequenceArrowThickness 2
skinparam roundcorner 10
skinparam maxmessagesize 200

skinparam participant {
    BackgroundColor #FAFAFA
    BorderColor #666666
}

skinparam note {
    BackgroundColor #FFFDE7
    BorderColor #FBC02D
}

title ログアウトフロー（サーバー側 - 推奨）

actor "エンドユーザー" as user
participant "ブラウザ" as browser #E3F2FD
participant "Route Handler\n(/auth/signout)" as handler #FFF3E0
participant "Supabase Auth\n(@supabase/ssr)" as supabase #E8F5E9

== ログアウト ==

user -> browser : ログアウトボタンをクリック
activate browser

browser -> handler : POST /auth/signout
activate handler

handler -> handler : createClient()

handler -> supabase : getUser()
activate supabase
supabase --> handler : { user }
deactivate supabase

alt ユーザーが存在
    handler -> supabase : signOut()
    activate supabase
    supabase -> supabase : セッション無効化
    supabase --> handler : 成功
    deactivate supabase
end

handler -> handler : **revalidatePath('/', 'layout')**
note right of handler
  **重要: revalidatePath()**
  サーバー側でキャッシュを
  無効化してデータを再取得
end note

handler --> browser : NextResponse.redirect\n('/login', 302)
deactivate handler

browser --> user : ログインページ表示

deactivate browser

@enduml
```

**ログアウト方式の比較:**

| 方式 | メリット | デメリット |
|------|----------|------------|
| クライアント側 | シンプル、即時反映 | キャッシュ管理が複雑 |
| サーバー側（推奨） | 確実なキャッシュクリア | 追加のRoute Handler必要 |

---

## 技術仕様

### 使用ライブラリ

| ライブラリ | バージョン | 用途 |
|-----------|-----------|------|
| @supabase/ssr | ^0.5.x | Next.js SSR対応（推奨） |
| next | ^15.x | App Router |

> **注意**: `@supabase/auth-helpers-nextjs` は非推奨。`@supabase/ssr` を使用すること。

### 実装コード（Context7検証済み）

#### 1. ブラウザ用クライアント

```typescript
// utils/supabase/client.ts
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!
  )
}
```

#### 2. サーバー用クライアント

```typescript
// utils/supabase/server.ts
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'

export async function createClient() {
  const cookieStore = await cookies()  // Next.js 15では await 必須

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
    {
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
            // Middlewareでセッション更新されるため
          }
        }
      }
    }
  )
}
```

#### 3. Middleware（セッション管理）

```typescript
// utils/supabase/middleware.ts
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          )
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        }
      }
    }
  )

  // 重要: createServerClientとgetUser()の間にコードを入れない
  const { data: { user } } = await supabase.auth.getUser()

  if (
    !user &&
    !request.nextUrl.pathname.startsWith('/login') &&
    !request.nextUrl.pathname.startsWith('/auth')
  ) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    return NextResponse.redirect(url)
  }

  // 重要: supabaseResponseをそのまま返す
  return supabaseResponse
}
```

```typescript
// middleware.ts（ルート）
import { type NextRequest } from 'next/server'
import { updateSession } from '@/utils/supabase/middleware'

export async function middleware(request: NextRequest) {
  return await updateSession(request)
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)'
  ]
}
```

#### 4. OAuthログイン開始

```typescript
// app/login/page.tsx
'use client'
import { createClient } from '@/utils/supabase/client'

export function LoginButton() {
  async function signInWithGitHub() {
    const supabase = createClient()
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'github',
      options: {
        redirectTo: `${window.location.origin}/auth/callback`,
      },
    })
    if (error) {
      console.error('OAuth error:', error.message)
    }
  }

  return <button onClick={signInWithGitHub}>GitHubでログイン</button>
}
```

#### 5. OAuthコールバック処理

```typescript
// app/auth/callback/route.ts
import { createClient } from '@/utils/supabase/server'
import { NextResponse } from 'next/server'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')

  // セキュリティ: オープンリダイレクト防止
  let next = searchParams.get('next') ?? '/'
  if (!next.startsWith('/')) {
    next = '/'
  }

  if (code) {
    const supabase = await createClient()
    const { error } = await supabase.auth.exchangeCodeForSession(code)

    if (!error) {
      // ロードバランサー対応
      const forwardedHost = request.headers.get('x-forwarded-host')
      const isLocalEnv = process.env.NODE_ENV === 'development'

      if (isLocalEnv) {
        return NextResponse.redirect(`${origin}${next}`)
      } else if (forwardedHost) {
        return NextResponse.redirect(`https://${forwardedHost}${next}`)
      } else {
        return NextResponse.redirect(`${origin}${next}`)
      }
    }
    console.error('Code exchange error:', error.message)
  }

  return NextResponse.redirect(`${origin}/auth/auth-code-error`)
}
```

#### 6. ログアウト

```typescript
// app/components/LogoutButton.tsx
'use client'
import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'

export function LogoutButton() {
  const router = useRouter()

  async function handleSignOut() {
    const supabase = createClient()
    const { error } = await supabase.auth.signOut()

    if (error) {
      console.error('Logout error:', error.message)
    }

    router.push('/login')
    router.refresh()  // サーバーコンポーネント再検証
  }

  return <button onClick={handleSignOut}>ログアウト</button>
}
```

### 非推奨パターン（使用禁止）

```typescript
// ❌ これは動作しない - 絶対に使わない
{
  cookies: {
    get(name: string) {           // ❌ BREAKS APPLICATION
      return cookieStore.get(name)
    },
    set(name: string, value: string) {  // ❌ BREAKS APPLICATION
      cookieStore.set(name, value)
    },
    remove(name: string) {        // ❌ BREAKS APPLICATION
      cookieStore.remove(name)
    }
  }
}
```

> **正しいパターン**: `getAll()` と `setAll()` を使用すること

### セキュリティ考慮事項

| 項目 | 対策 | 説明 |
|------|------|------|
| PKCE | @supabase/ssr標準対応 | code_verifier/code_challengeで認可コード保護 |
| CSRF | stateパラメータ | OAuth認証時のリクエスト偽装防止 |
| XSS | HttpOnly Cookie | JavaScriptからのセッションアクセス防止 |
| セッション | JWT + refresh_token | 短命JWT + 長命refresh_tokenで安全性確保 |
| オープンリダイレクト | `next.startsWith('/')` | 相対パスのみ許可 |
| ロードバランサー | `x-forwarded-host` | プロキシ環境対応 |

### PKCEフローの詳細

```
1. クライアント: code_verifier生成（43-128文字のランダム文字列）
2. クライアント: code_challenge = BASE64URL(SHA256(code_verifier))
3. クライアント: OAuth認証URLにcode_challenge付与
4. OAuth Provider: 認証後、認可コード発行
5. サーバー: exchangeCodeForSession(code)でcode_verifierと共にトークン交換
6. OAuth Provider: code_verifier検証後、access_token発行
```

### ファイル構成

```
project/
├── middleware.ts                    # ルートMiddleware
├── utils/
│   └── supabase/
│       ├── client.ts               # ブラウザ用クライアント
│       ├── server.ts               # サーバー用クライアント
│       └── middleware.ts           # Middleware用ユーティリティ
├── app/
│   ├── login/
│   │   └── page.tsx                # ログインページ
│   ├── auth/
│   │   └── callback/
│   │       └── route.ts            # OAuthコールバック
│   └── components/
│       └── LogoutButton.tsx        # ログアウトボタン
└── .env.local
    ├── NEXT_PUBLIC_SUPABASE_URL
    └── NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY
```

---

## 関連ドキュメント

- [PlantUML_Studio_ユースケース図_20251130.md](./PlantUML_Studio_ユースケース図_20251130.md) - UC 1-1, 1-2
- [PlantUML_Studio_コンテキスト図_20251130.md](./PlantUML_Studio_コンテキスト図_20251130.md) - Supabase連携
- [Supabase SSR公式ドキュメント](https://github.com/supabase/supabase/blob/master/apps/docs/content/guides/auth/server-side/creating-a-client.mdx)
