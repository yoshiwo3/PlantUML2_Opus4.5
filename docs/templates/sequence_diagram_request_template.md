# シーケンス図作成依頼テンプレート

**最終更新**: 2025-12-21

---

## 推奨方法（ファイルベース）

**以下の2ファイルをClaudeに渡すだけで作業を開始できます。**

1. `docs/context/active_context.md` - 現在の進捗、次のタスク
2. `docs/guides/sequence_diagram/00_Session_Start.md` - 作業プロセス

> **注意**: Claudeは作業を自動開始しません。対象UCを提案し、ユーザーの承認を得てから作業を開始します。

---

## 代替方法（コピー＆ペースト）

以下のテンプレートをコピーして、`[...]`部分を埋めてClaudeに送信してください。

### 基本テンプレート

```
シーケンス図を作成してください。

**対象UC**: UC [X-X]（[UCの名前]）

**作業手順**:
1. `docs/guides/sequence_diagram/01_Reference_Guide.md` を読み、§0〜§2に従う
2. §0.5「UC固有分析」でDP-001〜006の適用要否を判断
3. `02_Authoring_Guide.md` のチェックリストを確認
4. Evidence 3点セット作成
5. 5パスレビュー実施後、SVG生成
6. 統合版（08_シーケンス図_20251214.md）に追記
```

### 簡易テンプレート（慣れてきたら）

```
UC [X-X] [UCの名前] のシーケンス図を作成して。01_Reference_Guide.mdに従って。
```

---

## Phase 2 残りUC用テンプレート

### UC 5-1 ユーザー管理

```
シーケンス図を作成してください。

**対象UC**: UC 5-1（ユーザー管理）

**作業手順**:
1. `docs/guides/sequence_diagram/01_Reference_Guide.md` を読み、§0〜§2に従う
2. §0.5「UC固有分析」でDP-001〜006の適用要否を判断
3. `02_Authoring_Guide.md` のチェックリストを確認
4. Evidence 3点セット作成
5. 5パスレビュー実施後、SVG生成
6. 統合版（08_シーケンス図_20251214.md）に追記
```

### UC 5-2 LLMモデル登録

```
シーケンス図を作成してください。

**対象UC**: UC 5-2（LLMモデル登録）

**作業手順**:
1. `docs/guides/sequence_diagram/01_Reference_Guide.md` を読み、§0〜§2に従う
2. §0.5「UC固有分析」でDP-001〜006の適用要否を判断
3. `02_Authoring_Guide.md` のチェックリストを確認
4. Evidence 3点セット作成
5. 5パスレビュー実施後、SVG生成
6. 統合版（08_シーケンス図_20251214.md）に追記
```

### UC 5-7 LLM使用量監視

```
シーケンス図を作成してください。

**対象UC**: UC 5-7（LLM使用量監視）

**作業手順**:
1. `docs/guides/sequence_diagram/01_Reference_Guide.md` を読み、§0〜§2に従う
2. §0.5「UC固有分析」でDP-001〜006の適用要否を判断
3. `02_Authoring_Guide.md` のチェックリストを確認
4. Evidence 3点セット作成
5. 5パスレビュー実施後、SVG生成
6. 統合版（08_シーケンス図_20251214.md）に追記
```

### UC 5-11 学習コンテンツ登録

```
シーケンス図を作成してください。

**対象UC**: UC 5-11（学習コンテンツ登録）

**作業手順**:
1. `docs/guides/sequence_diagram/01_Reference_Guide.md` を読み、§0〜§2に従う
2. §0.5「UC固有分析」でDP-001〜006の適用要否を判断
3. `02_Authoring_Guide.md` のチェックリストを確認
4. Evidence 3点セット作成
5. 5パスレビュー実施後、SVG生成
6. 統合版（08_シーケンス図_20251214.md）に追記
```

---

## 参照ドキュメント

| ドキュメント | 役割 |
|-------------|------|
| `docs/guides/sequence_diagram/00_Session_Start.md` | **作業プロセス（必読）** |
| `docs/guides/sequence_diagram/01_Reference_Guide.md` | ナビゲーション（どこを見るか） |
| `docs/guides/sequence_diagram/02_Authoring_Guide.md` | How-to（どう書くか） |
| `docs/guides/sequence_diagram/Design_Pattern_Checklist.md` | 設計パターン（DP-001〜006） |
| `docs/guides/sequence_diagram/Activation_Bar_Knowledge_Base.md` | アクティブバー知見（LL-001〜027） |

---

## 現在の進捗

> **最新の進捗は `docs/context/active_context.md` を参照してください。**

| 区分 | 完了 | 残り |
|------|:----:|:----:|
| MVP | 8/8 ✅ | 0 |
| Phase 2 | 2/6 | 4（UC 5-1, 5-2, 5-7, 5-11） |
| **合計** | **10/14** | **4** |

*（2025-12-21時点）*
