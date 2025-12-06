# セッション記録: TD-005 プロジェクト選択状態の保存方法

**作成日**: 2025-12-06
**作業内容**: プロジェクト選択状態の保存方法の技術決定

## 技術決定

### TD-005: プロジェクト選択状態のSupabase保存

**決定内容**: ユーザーが最後に選択したプロジェクトの状態をSupabaseに保存する（`users.last_selected_project_id`）

**理由**:
- UX向上：前回の作業を即座に再開可能
- アーキテクチャ一貫性：本プロジェクトはSupabase中心設計
- クロスデバイス対応：どのデバイスからでも同じ状態で再開

**代替案（不採用）**:
- ローカルストレージ/React State
  - メリット: 実装コストほぼゼロ
  - デメリット: リロード時消失、デバイス固有

## 更新したファイル

1. `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md`
   - 3.5.2 プロジェクト選択フロー詳細
   - 「ローカルストレージ」→「Supabase」に修正

2. `docs/context/technical_decisions.md`
   - TD-005 追加

## 背景

業務フロー図3.5.2に「選択状態を保存（ローカルストレージ）」という記述があり、
Supabase中心設計との整合性が問題視された。

分析の結果、以下の結論に達した：
- 既存仕様に明示的な定義なし（矛盾ではなく未定義）
- UXとアーキテクチャ一貫性を考慮しSupabase採用を決定

## 実装への影響

```sql
-- usersテーブルに追加
ALTER TABLE users ADD COLUMN last_selected_project_id UUID REFERENCES projects(id);
```
