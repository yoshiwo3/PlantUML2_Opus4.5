# Session Memory: シーケンス図 UC 3-3/3-4 作成とdeactivate問題発見

**日時**: 2025-12-15
**作業**: シーケンス図 UC 3-3（リアルタイムプレビュー）、UC 3-4（AI支援プレビュー）作成

## 重要な発見事項

### alt分岐内でのdeactivate問題

**症状**: PNG上でアクティベーションバーが分岐終了後も続いている

**原因**: alt分岐内で戻り矢印（`-->`）の後にdeactivateを記述していなかった

**誤ったパターン**:
```plantuml
alt 構文エラーあり
    PlantUMLService --> ValidationService : { errors: [...] }
    ' deactivateがない → アクティブバーが続く
    ValidationService --> APIRoutes : { is_valid: false, errors }
end
```

**正しいパターン**:
```plantuml
alt 構文エラーあり
    PlantUMLService --> ValidationService : { errors: [...] }
    deactivate PlantUMLService
    ValidationService --> APIRoutes : { is_valid: false, errors }
    deactivate ValidationService
end
```

## 憲法更新（v4.3）

以下の箇所を更新:

1. **§ 3.2 シーケンス図の制限**
   - 「alt分岐内でdeactivateが抜けるとアクティブバーが不正確」追加

2. **§ 4.2 Pass 2 チェックリスト（シーケンス図用）**
   - activate/deactivate対応確認
   - alt分岐内のdeactivate確認
   - アクティブバー終端確認
   - ネストしたactivate確認

3. **付録C Phase 3-2**
   - チェック項目 3-2-8〜3-2-11 追加

## シーケンス図進捗

- 全体: 4/14（29%）
- MVP: 4/8（50%）
- 完了: 認証、プロジェクトCRUD、図表作成、編集プレビュー

## 参照

- Evidence: `docs/evidence/20251214_2330_sequence_edit_preview/`
- 統合版: `docs/proposals/PlantUML_Studio_シーケンス図_20251214.md`
- 憲法: `docs/guides/PlantUML_Development_Constitution.md` v4.3
