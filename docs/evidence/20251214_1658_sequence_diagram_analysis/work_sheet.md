# Work Sheet: シーケンス図要件分析

## 作成日時
2025-12-14 16:58 - 17:30

## 作業サマリ

| 項目 | 内容 |
|------|------|
| **作業内容** | 32UC全件分析、シーケンス図必要性判定、UC番号修正 |
| **更新ファイル** | `CLAUDE.md`, `docs/context/active_context.md` |
| **分析結果** | 15本 → 14本（v3除外） |
| **完了済み** | 1本（ログイン） |
| **残り** | 13本（MVP: 7本、Phase 2: 6本） |

---

## 成果物

### 1. シーケンス図リスト（14本確定、v3除外）

#### MVP必須（8本）
| # | UC | 名称 | 外部システム | 状態 |
|:-:|:---|------|-------------|:----:|
| 1 | UC 1-1, 1-2 | ログイン | Supabase Auth | ✅ |
| 2 | UC 3-1 | 図表作成 | Supabase Storage | 🔴 |
| 3 | UC 3-3, 3-4 | 編集プレビュー | node-plantuml | 🔴 |
| 4 | UC 3-5 | 保存 | Supabase Storage | 🔴 |
| 5 | UC 3-6 | エクスポート | Supabase Storage | 🔴 |
| 6 | UC 3-9 | 図表削除 | Supabase Storage | 🔴 |
| 7 | UC 4-1 | AI Question-Start | OpenRouter API | 🔴 |
| 8 | UC 4-2 | AIチャット | OpenRouter API (Streaming) | 🔴 |

#### Phase 2（6本）
| # | UC | 名称 | 外部システム |
|:-:|:---|------|-------------|
| 9 | UC 5-1 | ユーザー管理 | Supabase Auth Admin |
| 10 | UC 5-2 | LLMモデル登録 | OpenRouter Models API |
| 11 | UC 5-7 | LLM使用量監視 | OpenRouter API |
| 12 | UC 5-11 | 学習コンテンツ登録 | OpenAI Embedding + pgvector |
| 13 | UC 3-10 | エディタ内ヘルプ | 内部API |
| 14 | UC 3-11 | 学習画面 | 内部API + pgvector |

### 2. UC番号修正

| 機能 | 誤 | 正 | 修正場所 |
|------|:--:|:--:|---------|
| LLMモデル登録 | UC 5-7 | UC 5-2 | CLAUDE.md line 347 |
| LLM使用量監視 | UC 5-11 | UC 5-7 | CLAUDE.md line 348 |
| 学習コンテンツ登録 | UC 5-14 | UC 5-11 | CLAUDE.md line 349 |

### 3. スキップ判断基準

**シーケンス図が必要な条件（いずれかを満たす）:**
1. 外部APIコール（Supabase Auth/Storage、OpenRouter、OpenAI、node-plantuml）
2. 複数サービス間の連携
3. 非同期/ストリーミング処理
4. 複雑なエラーリカバリフロー

**スキップ対象（11UC）:**
- 単純CRUD操作（DB/Storage直接アクセス）
- 設定管理系（システム設定、テンプレート等）

---

## 完了条件チェック

- [x] 32UC全件の分析完了
- [x] シーケンス図必要/不要の根拠明確化
- [x] UC番号修正（CLAUDE.md）
- [x] active_context.md更新
- [x] SERENA Memory保存
- [x] Evidence 3点セット完成

---

## 参照ドキュメント

| ドキュメント | パス |
|-------------|------|
| ユースケース図 | `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md` |
| 機能一覧表 v3.12 | `docs/proposals/PlantUML_Studio_機能一覧表_20251213.md` |
| CLAUDE.md | `CLAUDE.md` |
| active_context.md | `docs/context/active_context.md` |

---

## 次のステップ

1. **Phase 4: シーケンス図作成（13本残）**
   - MVP優先（7本）: 図表作成 → 編集プレビュー → 保存 → エクスポート → 削除 → AI×2
   - Phase 2（6本）: 管理機能系

---

**作業完了**: 2025-12-14 17:30
**スクリプト修正**: `scripts/create_evidence.ps1` パス誤り修正
