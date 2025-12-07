# 作業指示書: 3.9 管理機能フロー（MVP）作成

## 作業日時
- **開始**: 2025-12-07 09:02
- **担当**: Claude Code (Opus 4.5)

## 目標
業務フロー図「3.9 管理機能フロー（MVP）」を作成し、MVP必須の管理機能UCをカバーする。

## コンテキスト
- **現在の進捗**: 業務フロー図 8/11完了（73%）、MVP必須 8/9完了（89%）
- **残り**: 3.9（MVP）、3.10・3.11（Phase 2）
- **TD-007**: AI機能プロバイダー構成決定済み（LLM: OpenRouter, Embedding: OpenAI直接）

## 対象UC（8件）

### 5-A. ユーザー管理
| UC | 機能名 | 優先度 |
|:--:|--------|:------:|
| 5-1 | ユーザーを管理する | MVP |

### 5-B. LLM管理（OpenRouter経由）
| UC | 機能名 | 優先度 |
|:--:|--------|:------:|
| 5-2 | LLMモデルを登録する | MVP |
| 5-3 | LLMモデルを切り替える | MVP |
| 5-4 | LLMプロンプトを管理する | MVP |
| 5-5 | LLMパラメータを設定する | MVP |
| 5-7 | LLM使用量を監視する | MVP |
| 5-8 | LLMフォールバックを設定する | MVP |

### 5-E. システム設定
| UC | 機能名 | 優先度 |
|:--:|--------|:------:|
| 5-13 | システム設定を変更する | MVP |

## 実施内容

1. **関連資料確認**
   - LLM管理機能設計書
   - OpenRouter調査結果
   - ユースケース図定義

2. **業務フロー図作成**
   - 3.9.1 ユーザー管理フロー（UC 5-1）
   - 3.9.2 LLM管理フロー（UC 5-2〜5-5, 5-7, 5-8）
   - 3.9.3 システム設定フロー（UC 5-13）

3. **PlantUMLバリデーション**
   - Context7でアクティビティ図構文確認
   - バリデーター実行

4. **ドキュメント更新**
   - 業務フロー図ファイル更新
   - active_context.md更新

## 完了条件

- [ ] 3.9 管理機能フロー（MVP）のPlantUMLコード作成
- [ ] バリデーション成功
- [ ] 業務フロー図ファイル（proposals/）に追記
- [ ] active_context.md進捗更新
- [ ] Evidence work_sheet.md完成

## 参考資料

- `docs/evidence/20251206_openrouter_research/llm_management_feature_design.md`
- `docs/evidence/20251206_openrouter_research/openrouter_api_spec.md`
- `docs/proposals/PlantUML_Studio_ユースケース図_20251130.md`
- `docs/proposals/PlantUML_Studio_業務フロー図_20251201.md`
