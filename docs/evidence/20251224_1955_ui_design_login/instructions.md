# 作業指示書

**作成日**: 2025-12-24 19:55
**作業名**: UI設計図表作成（ログイン画面から開始）
**担当**: Claude + User協調作成

---

## 目標

PlantUML StudioのUI設計図表（ワイヤーフレーム + 画面遷移図）を作成する。

## スコープ

### Phase 1: MVP画面（優先）
- 認証画面群（1画面）
- メイン画面群（3画面）
- モーダル群（5画面）

### Phase 2: 管理画面
- 管理画面群（5画面）

## 準拠ドキュメント

| ドキュメント | パス |
|-------------|------|
| UI設計図表開発憲法 | `docs/guides/ui_design/UI_Design_Constitution.md` |
| セッション開始ガイド | `docs/guides/ui_design/00_Session_Start.md` |
| 作成ガイドライン | `docs/guides/ui_design/02_Authoring_Guide.md` |
| TD-015 | `docs/context/technical_decisions.md` |

## TD-015原則（必須）

| 原則 | 説明 |
|------|------|
| **低精度（Low-Fidelity）** | 概念レベルの表現 |
| **手書き風** | Excalidraw roughness設定 |
| **グレースケール** | 白黒灰のみ使用 |

## 成果物

| 成果物 | 保存先 |
|--------|--------|
| ワイヤーフレーム（.excalidraw） | `wireframes/XX_screen/` |
| ワイヤーフレーム一覧 | `wireframes/00_wireframe_index.md` |
| 画面遷移図（.puml） | `docs/proposals/diagrams/09_screen_transition/` |

## 完了条件

- [ ] 全18画面のワイヤーフレーム作成
- [ ] 各画面90点以上の評価
- [ ] 画面遷移図の整合性確認
- [ ] active_context.md更新
