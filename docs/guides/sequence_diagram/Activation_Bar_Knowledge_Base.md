# PlantUML シーケンス図 アクティブバー知見ベース

**作成日**: 2025-12-18
**出典**: `docs/evidence/20251215_2345_sequence_save/work_sheet.md`
**対象UC**: UC 3-5 保存シーケンス図
**総項目数**: 24項目（LL-001〜LL-024）

---

## 概要

UC 3-5 保存シーケンス図作成で得られたアクティブバー関連の知見集。
47回のファイル編集、5回以上の偽陽性レビューを経て蓄積された実践的な教訓。

### 知見分類

| カテゴリ | 項目 | 内容 |
|---------|------|------|
| 基本原則 | LL-001〜LL-003 | alt/else分岐の状態継承、選択的activate |
| 構文・パターン | LL-004〜LL-008 | ショートカット構文、hidden arrowアンカー |
| 制限・原則 | LL-009〜LL-012 | note非アンカー、deactivateタイミング |
| 状態vs描画 | LL-013〜LL-016 | 視覚的トリガー、チェック表限界 |
| レビュー方法論 | LL-017〜LL-020 | 大域的確認バイアス、終端部確認、否定的証拠探索 |
| 追加知見 | LL-021〜LL-024 | ネストalt、初期activate、段階的リファクタリング |

---

## 1. 基本原則（LL-001〜LL-003）

### LL-001: else分岐のactivation継承

**最重要知見**

else分岐は**ALT開始時点**の状態を継承（first branch終了時点ではない）。

```plantuml
' ❌ エラー: "Cannot activate DiagramService" - 既にactiveなため
else 用語一貫性OK
    activate AIService
    activate DiagramService   ' ← ここでエラー
    activate APIRoutes        ' ← ここでもエラー
```

**PlantUMLの内部動作**:
```
ALT開始時点:
  DiagramService = active
  APIRoutes = active
  AIService = deactivated（first branchで終了）

ELSE分岐進入時:
  → ALT開始時点の状態がコピーされる
  → DiagramService, APIRoutesは既にactive
  → 再度activateするとエラー
```

**影響**:
- alt開始時点でactiveな参加者は、else分岐で再度activateするとエラー
- first branchでdeactivateしても、else分岐ではactiveとして扱われる
- これはPlantUMLの「並列世界モデル」（LL-011）に基づく動作

### LL-002: 選択的activate

else分岐では、first branchで非活性化された参加者のみactivate可能。

**判定ロジック**:
```
for each participant P in else分岐:
    if P was active at ALT START:
        → activateしてはいけない（既にactive）
    if P was deactivated in first branch:
        → activateしてもよい（ただしALT開始時点で既にactiveなら不要）
```

**具体例**:

| 参加者 | alt開始時 | first branch | else分岐でactivate? | 理由 |
|--------|:---------:|:------------:|:-------------------:|------|
| AIService | active | deactivate | ✅ 必要 | 使うなら再activate |
| DiagramService | active | 継続 | ❌ 不要（エラー） | 既にactive状態 |
| APIRoutes | active | 継続 | ❌ 不要（エラー） | 既にactive状態 |

### LL-003: メッセージチェック表の有効性と限界

メッセージごとの始点・終点チェック表は有効だが、**視覚的描画の問題は検出できない**。

| 検出可能 | 検出不可能 |
|---------|-----------|
| activate文の漏れ | 状態activeだが描画されないケース |
| deactivate文の漏れ | alt/else分岐での視覚的トリガー欠如 |
| 矢印方向の間違い | hidden arrowアンカーの必要性 |

---

## 2. 構文・パターン（LL-004〜LL-008）

### LL-004: ショートカット構文の優先使用

**Context7検証済み**

| 従来の書き方 | ショートカット構文 | 効果 |
|-------------|-------------------|------|
| `A -> B`<br>`activate B` | `A -> B ++ : msg` | Bをactivate |
| `A -> B`<br>`deactivate A` | `A -> B -- : msg` | Aをdeactivate |
| 複数行必要 | `A -> B --++ : msg` | A deactivate + B activate |

**利点**:
- コードが簡潔（20行以上削減実績）
- activate/deactivate の対応漏れを防止
- アクティブバーの意図が明確

### LL-005: 矢印タイプの選択

return arrow (`-->`) よりも regular arrow (`->`) の方がアクティブバーが明確。

```plantuml
' ❌ return arrowを使用 → アクティブバーが薄く見える
Browser --> User : 「保存完了」

' ✅ regular arrowに変更 → アクティブバーが明確
Browser -> User : 「保存完了」
```

**推奨**: エラー応答でも `->` を使用

### LL-006: `--++`構文による制御の引き渡し（Handoff Pattern）

「送信者の仕事が終わり、受信者が後続処理を担う」場合に使用。

```plantuml
' ❌ 誤: Browserのアクティブバーが表示されない
APIRoutes --> Browser : 200 OK

' ✅ 正: APIRoutes deactivate + Browser activate を同時に
APIRoutes -> Browser --++ : 200 OK
```

**適用場面**:
- API → UI への最終レスポンス
- 非同期処理開始後のコールバック受信側

### LL-007: Self-Message Anchor（可視）

else分岐で単一メッセージのみの場合、アクティブバーが視覚的に表示されないことがある。

```plantuml
' ❌ 誤: Browserのアクティブバーが表示されない
else 用語一貫性OK
    Browser -> User -- : 「保存完了」

' ✅ 正: Self-messageでアクティブバーをアンカー
else 用語一貫性OK
    Browser -> Browser : レスポンス処理
    Browser -> User -- : 「保存完了」
```

**欠点**: 余計なメッセージが表示される → LL-008の方が推奨

### LL-008: Hidden Arrowアンカー（推奨解）

**最重要パターン**

`[hidden]`キーワードで不可視の矢印を作成し、視覚的トリガーとして使用。

```plantuml
' ✅ 正: 不可視アンカーでアクティブバーを描画
else 用語一貫性OK
    Browser -[hidden]-> Browser  ' 不可視アンカー
    Browser -> User -- : 「保存完了」
```

**最大の罠**:

```plantuml
' ❌ 危険: hidden arrowに++をつけるとLL-001エラー
Browser -[hidden]-> Browser ++  ' "Cannot activate Browser" エラー

' ✅ 正しい: hidden arrowに++をつけない
Browser -[hidden]-> Browser     ' アンカーのみ、activateしない
```

**重要**: `Browser -[hidden]-> Browser ++` は**NG**（LL-001によりactivateエラー）

---

## 3. 制限・原則（LL-009〜LL-012）

### LL-009: noteはアンカーにならない

noteはアクティブバーの視覚的トリガーにならない。

```plantuml
' ❌ 誤: noteだけではBrowserのアクティブバーが表示されない
else 用語一貫性OK
    note right of Browser : 処理中
    Browser -> User -- : 「保存完了」
```

| 要素 | 参加者状態への影響 | 視覚的トリガー |
|------|-------------------|:-------------:|
| メッセージ (`A -> B`) | 状態遷移あり | ✅ Yes |
| activate/deactivate | 状態変更 | ✅ Yes |
| note | 影響なし（注釈のみ） | ❌ No |
| 空行 | 影響なし | ❌ No |
| コメント (`' ...`) | 影響なし | ❌ No |

### LL-010: deactivateのタイミング原則

alt/else分岐の「前」でdeactivateすると、分岐内でアクティブバーが描画されない。

**原則**: deactivateは各分岐の**終端**で行う

```plantuml
' ✅ 正: 各分岐終端で--ショートカットを使用
APIRoutes -> Browser --++ : 200 OK  ' BrowserをactivateしたままALTへ

alt 用語不一致あり
    note right of Browser : 警告トースト表示
    Browser -> User -- : メッセージ  ' --で終端
else 用語一貫性OK
    Browser -[hidden]-> Browser  ' アンカーのみ（++なし）
    Browser -> User -- : メッセージ  ' --で終端
end
```

| タイミング | 結果 | 推奨 |
|-----------|------|:----:|
| alt前でdeactivate | 分岐内でバーなし | ❌ |
| 分岐内で`++`再activate | LL-001エラー（else分岐） | ❌ |
| 分岐終端で`--` | 各分岐で正しくdeactivate | ✅ |

### LL-011: PlantUML並列世界モデル

alt/elseの各分岐は「並列世界」として独立した状態遷移を持つ。

```
ALT開始時点の状態（スナップショット）
       │
   ┌───┴───┐
   ▼       ▼
 [alt]   [else]  ← 両方ともALT開始時点の状態をコピー
   │       │
   ↓       ↓
 独立     独立    ← 互いに影響しない
```

**重要**: first branchでのdeactivateはelse branchに影響**しない**

### LL-012: アクティブバー描画の必要条件

**公式**:
```
アクティブバー描画 = 内部状態active ∧ 視覚的トリガー
```

| 条件 | 説明 | 例 |
|------|------|-----|
| 内部状態active | activate/++で有効化 | `activate Browser` |
| 視覚的トリガー | メッセージ送受信など | `A -> B : msg` |

**視覚的トリガーにならないもの**: note、空行、コメント、スペーサー（`|||`）

---

## 4. 状態vs描画（LL-013〜LL-016）

### LL-013: 「状態」と「描画」の乖離

**根本原因**: PlantUMLでは「内部状態がactive」と「アクティブバーが視覚的に描画される」は**別物**。

```plantuml
alt 用語不一致あり
    ' ✅ トリガーあり: noteの前にAPIRoutesからのメッセージがある
    note right of Browser : 警告トースト表示
    Browser -> User -- : 「保存完了（警告あり）」

else 用語一貫性OK
    ' ❌ トリガーなし: この分岐に入った直後にメッセージがない
    Browser -> User -- : 「保存完了」  ' ← このメッセージの始点にバーがない！
end
```

### LL-014: メッセージチェック表方式の適用限界

チェック表は「構文レベル」の確認には有効だが、「描画レベル」の確認には別の手法が必要。

| チェック対象 | 検出可能 | 検出不可能 |
|-------------|:--------:|:----------:|
| activate/deactivate文の漏れ | ✅ | - |
| 矢印の方向・タイプ | ✅ | - |
| 状態とトリガーの乖離 | - | ❌ |
| alt/else分岐での描画条件 | - | ❌ |

### LL-015: 意味論的確証バイアス

first branchでアクティブバーが表示されていると、else branchも「同様にあるはず」と思い込む。

| 種類 | 定義 | 憲法での対策 | 効果 |
|------|------|-------------|:----:|
| 構文的確証バイアス | ソースに`A -> B`があるから接続があるはず | PNGと.puml同時読み禁止 | ✅ 有効 |
| **意味論的確証バイアス** | 状態がactiveだからバーがあるはず | **対策なし** | ❌ 無効 |

→ LL-017〜LL-020で対策

### LL-016: 視覚的トリガー分析

**改善されたチェックプロセス**:

```
for each 分岐 in alt/else:
  for each メッセージ M in 分岐:
    Q: Mの始点participantに対して、
       この分岐内でMより前に
       メッセージ（視覚的トリガー）があるか？

    - YES → バー描画される
    - NO  → 隠し矢印アンカーが必要
           participant -[hidden]-> participant
```

---

## 5. レビュー方法論（LL-017〜LL-020）

### LL-017: 大域的確認バイアス

```
❌ 失敗パターン: PNG全体を俯瞰して「バーがある」と認識
✅ 正しい方法: 各メッセージの始点を1つずつ確認
```

**対策**: 全体俯瞰ではなく、**メッセージ単位**で始点を追跡

### LL-018: 終端部確認不足

```
❌ 失敗パターン: 図の上部から順に確認し、下部で注意力低下
✅ 正しい方法: 最終メッセージから逆順に確認開始
```

**理由**: アクティブバーの欠落は**図の終端部**で発生しやすい

### LL-019: 否定的証拠の探索不足

```
❌ 失敗パターン: 「バーがある」ことを確認（肯定的証拠探索）
✅ 正しい方法: 「バーがないメッセージ」を能動的に探す（否定的証拠探索）
```

**対策**: 「どのメッセージにバーがないか？」と自問

### LL-020: 分岐両側の独立確認欠如

```
❌ 失敗パターン: if側を確認し、else側を「同様だろう」と推測
✅ 正しい方法: if側とelse側を完全に別々に全メッセージ確認
```

**対策**: 分岐を「別々の図」として扱う

---

## 6. 追加知見（LL-021〜LL-024）

### LL-021: ネストされたalt内のelse分岐でのactivateエラー

ネストされたalt構造では、親のalt分岐でactivateした参加者を、子のelse分岐で再activateするとエラー。

**解決策**: ショートカット構文（`--`）でdeactivate

### LL-022: User参加者の初期activate漏れ

シーケンス図の開始点となるアクター（User等）は、最初のメッセージ送信**前**にactivateが必要。

```plantuml
' ✅ 修正後: Userを先にactivate
== 図表を開く ==

activate User
User -> Browser : 図表一覧から図表をクリック
activate Browser
```

### LL-023: リファクタリングの段階的進化パターン

大規模なリファクタリングは一度に行わず、段階的に適用し、各段階でPNG確認。

**本セッションでの進化**:
1. 従来構文 → 2. ショートカット構文 → 3. return arrow修正 → 4. hidden arrow → 5. ++削除 → 6. **完成**

### LL-024: 知識の組み合わせ爆発

複数の知見の組み合わせが必要な問題が多い。

| 失敗 | 必要な知見の組み合わせ |
|------|----------------------|
| else分岐でactivateエラー | LL-001 + LL-011 |
| hidden arrow++でエラー | LL-001 + LL-008 |
| note後にバー描画されない | LL-009 + LL-012 |
| alt前deactivateでバーなし | LL-010 + LL-012 |

**教訓**: 個々の知見を暗記するだけでは不十分。**組み合わせパターン**を理解

---

## チェックリスト

### 技術面（PlantUML）

- [ ] alt/else分岐内の最初のメッセージで、始点participantへの直前メッセージがあるか？
- [ ] なければ、隠し矢印アンカー `participant -[hidden]-> participant` を追加したか？
- [ ] deactivateはalt前ではなく各分岐終端で行っているか？
- [ ] hidden arrowに`++`をつけていないか？

### 方法論面（視覚レビュー）

- [ ] **最終メッセージから逆順**に始点のバーを確認したか？
- [ ] 各分岐（if/else）を**独立して**全メッセージ確認したか？
- [ ] 「バーが**ない**メッセージ」を能動的に探したか？
- [ ] メッセージ単位で始点participantのバーを追跡したか？

---

## 参照

- **詳細版**: `docs/evidence/20251215_2345_sequence_save/work_sheet.md`
- **SERENA Memory**: `.serena/memories/session_20251217_sequence_save_lessons_learned.md`
- **憲法**: `docs/guides/PlantUML_Development_Constitution.md`
