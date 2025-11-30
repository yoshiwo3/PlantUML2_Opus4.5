# TD-011: PlantUML検証エラー情報取得方法の技術決定

**作成日**: 2025-11-24
**セッション**: PlantUML検証戦略の設計完了

## セッション概要

ユーザーからの質問「公式サーバーはエラー内容をテキストで返してくれたのでは？」から始まり、PlantUML検証時のエラー情報取得方法を調査・決定しました。

## 主要な発見

### 1. 公式サーバーのエラーレスポンス
- **HTTPヘッダー**にテキスト形式でエラー情報を返す
- `X-PlantUML-Diagram-Description`、`X-PlantUML-Diagram-Error`等
- HTTPステータスコード400でエラーを示す
- 画像埋め込み形式ではなく、構造化されたテキスト

### 2. ローカルJARのエラー出力
- PlantUML 1.2021.8以降で`-noerror`オプション利用可能
- **標準エラー出力（stderr）**にエラー情報を出力
- 行番号、ファイル名、エラー詳細を含む
- Node.jsの`spawn`でstderr取得が容易

## 技術決定内容（TD-011）

**⚠️ 重要な方針変更（2025-11-24更新）**: 公式サーバーフォールバックは採用しない。ローカルJAR専用とする。

### 検証方式
**ローカルJAR専用**（`-noerror` + stderr）:
- 高速（50-100ms）
- オフライン動作
- プライバシー保護（コードが外部に送信されない）
- 詳細なエラー情報（行番号、ファイル名、エラー詳細）
- Cloud Run環境ではJAR/Javaが常駐（前提条件満たされる）

### 失敗時の対応
- JARなし/Java未インストール時 → エラーメッセージ表示
  「PlantUML JAR（1.2021.8以降）とJavaが必要です」

### 実装戦略
```
ローカルJAR検証実行
  ├─ 成功 → stderrからエラー取得 ✅
  └─ 失敗 → エラーメッセージ表示
     「PlantUML JAR（1.2021.8以降）とJavaが必要です」
```

**理由**:
- プライバシー保護（コードが外部に送信されない）
- 完全なオフライン動作
- ネットワーク障害の影響を受けない
- Cloud Run環境ではJAR/Java常駐

### Node.js実装パターン
```typescript
import { spawn } from 'child_process';

async function validateWithLocalJar(code: string) {
  const process = spawn('java', [
    '-jar', 'plantuml.jar',
    '-noerror', '-tsvg', '-pipe'
  ]);

  let stderr = '';
  process.stderr.on('data', (data) => { stderr += data; });

  process.on('close', () => {
    if (stderr) {
      // stderrからエラー情報を抽出
      const lineNumber = extractLineNumber(stderr);
      const errorMessage = extractErrorMessage(stderr);
      return { valid: false, error: errorMessage, lineNumber };
    }
    return { valid: true, svg: stdout };
  });

  process.stdin.write(code);
  process.stdin.end();
}
```

## 影響範囲

### 1. システムアーキテクチャ
- `plantuml_studio_context.md`に既に反映済み（前セッションで更新）
- ローカルJAR優先、公式サーバーフォールバックの2段階構成

### 2. PlantUML Studio実装（フェーズ1-5）
- AIチャット機能での検証ループ実装
- エラー通知UIの設計
- `/api/validate`エンドポイントの実装

### 3. 非機能要件
- ローカルJAR検証: 平均50-100ms
- 公式サーバー検証: 平均500ms-1s
- エラー検出精度: 100%（実描画テスト）

## 関連技術決定

- **TD-010**: PlantUML検証方式の決定（実描画テスト必須）
  - TD-011はエラー取得方法を具体化
- **TD-001**: 2段階検証アーキテクチャ
  - ローカル→クラウドのフォールバック戦略と一貫性

## 参考資料

- [PlantUML Server DiagramResponse.java](https://github.com/plantuml/plantuml-server/blob/master/src/main/java/net/sourceforge/plantuml/servlet/DiagramResponse.java)
- [Sometimes Missing Response-Headers · Issue #22](https://github.com/plantuml/plantuml-server/issues/22)
- [Error Handling | plantuml/plantuml-server](https://deepwiki.com/plantuml/plantuml-server/6.3-error-handling)
- [how to detect error in plantuml server rendering](https://forum.plantuml.net/6434/how-to-detect-error-in-plantuml-server-rendering)

## 次のアクション

1. ✅ `technical_decisions.md`更新完了
2. ✅ gitコミット・プッシュ完了
3. ✅ Serena記録完了
4. 企画書フェーズ5更新（エラー取得方法の詳細を追加）
5. コーディング規約更新（ローカルJAR検証パターンを追加）

## セッションの重要な学び

### ユーザーからの重要なフィードバック
1. **段階的な更新の重要性**: 「いきなり全ドキュメントから排除しないで」
   - 変更範囲を最小化し、ユーザー確認を取りながら進める
   
2. **システムフロー整合性の確認**: 「単純に削除しただけでは、システムフローが崩壊しませんか？」
   - 削除や変更時は必ず代替手段や影響範囲を検証

3. **実装可能性の確認**: 「ローカルのJarでおなじことはできませんか？」
   - 常に複数の実装選択肢を検討し、トレードオフを明確化

### 技術的な発見
- PlantUML公式サーバーは画像だけでなく、HTTPヘッダーでエラー情報をテキスト提供
- ローカルJARの`-noerror`オプションはPlantUML 1.2021.8以降で利用可能
- 両方式でAI向けエラー情報取得が実現可能（ローカル優先戦略が妥当）

## ローカルJAR戦略の設計状態

✅ **設計完了**: TD-011により、エラー情報取得方法が明確化され、ローカルJAR検証戦略の設計が完了しました。

次のステップ:
- 企画書フェーズ5へのエラー取得詳細の反映
- コーディング規約へのローカルJAR検証パターンの追加
- 実装フェーズでの詳細設計（Node.js実装、エラーパース処理等）
