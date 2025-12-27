# 01. ログイン画面

**対応UC**: UC 1-1（ログイン）
**画面遷移図参照**: `login`

---

## 概要

OAuth認証（GitHub/Google）によるログイン画面。

### 機能要件

- GitHub OAuth ログイン
- Google OAuth ログイン
- エラーメッセージ表示
- ロゴ・タイトル表示

---

## 状態一覧

| 状態 | ファイル | 説明 |
|------|----------|------|
| **通常** | `default.excalidraw` | 初期表示状態 |

---

## ワイヤーフレーム

### 通常状態

![[default.excalidraw|600]]

---

## UI要素

| 要素 | 説明 |
|------|------|
| ロゴ | PlantUML Studio ロゴ（プレースホルダー） |
| タイトル | "PlantUML Studio" |
| サブタイトル | "ログイン" |
| GitHubボタン | "GitHubでログイン" |
| Googleボタン | "Googleでログイン" |
| エラーエリア | 認証エラー時のメッセージ表示 |

---

## 関連ドキュメント

- [シーケンス図 §1-2](../../../../proposals/08_シーケンス図_20251214.md)
- [画面遷移図](../../../../proposals/diagrams/09_screen_transition/)
