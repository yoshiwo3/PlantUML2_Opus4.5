# Session 2025-12-20: UC 4-1 AI Question-Start シーケンス図完了

## 完了事項

### UC 4-1 AI Question-Start シーケンス図
- **対象UC**: UC 4-1 AI Question-Startで図表を生成する
- **外部システム**: OpenRouter（SSEストリーミング）
- **参加者**: 7名（User, Browser, APIRoutes, AIService, OpenRouterClient, OpenRouter, UsageRepo）
- **エラーハンドリング**: 401/403/429/500/503
- **SVG**: `docs/proposals/diagrams/08_sequence/7_1_AI_Question_Start.svg`
- **ドキュメント**: `08_シーケンス図_20251214.md` §7

### シーケンス図進捗
- **MVP**: 8/8完了（100%）✅
- **Phase 2**: 0/6
- **全体**: 8/14（57%）

## 発見した知見

### LL-025: ネストaltでのactivate漏れ防止

**問題**: ネストしたalt/else構造で、else分岐の活動する参加者のactivateが漏れる

**根本原因**:
1. LL-001の「知識」はあったが「適用」しなかった
2. 複雑なalt構造（3重ネスト）で追跡が困難
3. ストリーミングloop内は正常に見えたため、loop終了後の確認が甘くなった

**回避策**: alt/elseブロックを書く前に状態追跡表を作成

```markdown
| 参加者 | alt開始時 | alt分岐終了時 | else分岐で必要 | else冒頭でactivate? |
|--------|:---------:|:------------:|:--------------:|:------------------:|
| APIRoutes | active | deactivated | active | ✅ 必要 |
```

## ドキュメント更新

| ドキュメント | 更新内容 | バージョン |
|-------------|---------|-----------|
| `Activation_Bar_Knowledge_Base.md` | LL-025追加 | 25項目 |
| `Sequence_Diagram_Authoring_Guide.md` | §7チェックリスト追加 | - |
| `PlantUML_Development_Constitution.md` | LL-025参照追加 | v4.7 |

## 次のアクション

Phase 2 シーケンス図 6本:
1. UC 4-2 AIチャット
2. UC 3-10 学習コンテンツ検索
3. UC 5-1 ユーザー管理
4. UC 5-2 LLMモデル登録
5. UC 5-7 LLM使用量監視
6. UC 5-11 学習コンテンツ登録

## Evidence

- `docs/evidence/20251220_2214_sequence_ai_question_start/`
  - `ai_question_start.puml`
  - `ai_question_start.review.json`
  - `00_raw_notes.md`
  - `work_sheet.md`
