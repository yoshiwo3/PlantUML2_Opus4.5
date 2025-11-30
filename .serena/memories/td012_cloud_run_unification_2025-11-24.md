# TD-012: Cloud Run一本化によるアーキテクチャ統合

**作成日**: 2025-11-24
**セッション**: アーキテクチャ設計の最適化

## セッション概要

ユーザーからの指摘「コンテキスト図にCloud Runがいませんね。そもそもVercelは存在意義がなくなってきましたね。」から始まり、Cloud Run一本化の実現可能性を調査・決定しました。

## 問題提起

### 現在のコンテキスト図の問題点

1. **Cloud Runが不在**
   - TD-008（2025-11-03）でCloud Run採用決定済み
   - しかしコンテキスト図に反映されていない

2. **Vercelの存在意義が不明瞭**
   - PlantUML検証: Cloud Run（ローカルJAR必要）
   - Next.jsアプリ: Vercel（暗黙の前提）
   - データベース: Supabase
   - → Cloud RunでNext.jsも動かせる

## 調査内容

### Cloud Run Always Free Tier（月間制限）
- **CPU**: 180,000 vCPU-秒
- **メモリ**: 360,000 GiB-秒
- **リクエスト数**: 200万リクエスト
- **ネットワーク送信**: 1 GiB（北米）

### 統合コンテナの構成
```dockerfile
FROM node:20-slim                       # ベース: ~200MB
RUN apt-get install openjdk-17-jre graphviz  # 追加: ~150MB
COPY plantuml-1.2024.3.jar              # 追加: ~15MB
COPY .next/ node_modules/               # 追加: ~300-400MB
# 合計コンテナサイズ: 約700-800MB
```

### メモリ要件
- **Next.js本体**: 512MB（推奨最小）
- **PlantUML処理**: 256MB（通常の図表）
- **合計メモリ**: **768MB～1GB**

### 無料枠試算

#### シナリオB: 推奨構成（1GB、1 vCPU）
```
月間リクエスト: 10,000回
平均レスポンス時間: 500ms

CPU使用量: 5,000 vCPU-秒（無料枠の2.8%）
メモリ使用量: 5,000 GiB-秒（無料枠の1.4%）

結果: ✅ 無料枠内で快適に動作
```

#### シナリオC: 高トラフィック（1GB、1 vCPU、10万リクエスト/月）
```
CPU使用量: 50,000 vCPU-秒（無料枠の27.8%）
メモリ使用量: 50,000 GiB-秒（無料枠の13.9%）
リクエスト数: 100,000回（無料枠の5%）

結果: ✅ 無料枠内で十分動作可能
```

## 技術決定内容（TD-012）

### アーキテクチャパターン選択

❌ **却下: パターンA（Vercel + Cloud Run分離）**
- 2つのプラットフォーム管理
- コスト増（Vercel有料プラン＋Cloud Run）
- 複雑なネットワーク構成

✅ **採用: パターンB（Cloud Run一本化）**
```
Cloud Run (統合サーバー)
  ├─ Next.js (SSR/API Routes)
  ├─ PlantUML検証（node-plantuml）
  └─ Java + Graphviz

Supabase (BaaS)
```

### 推奨構成
- **メモリ**: 1GB
- **CPU**: 1 vCPU
- **min-instances**: 0（スケールトゥゼロ）
- **max-instances**: 10
- **リージョン**: asia-northeast1（東京）

### 無料枠内での実現可能性

✅ **結論: Cloud Run一本化は無料枠内で構築可能**

**月間処理能力（無料枠内）**:
- 約36万リクエスト（無料枠の20%消費想定）
- 平均レスポンス時間: 500ms
- Cold Start: 2-5秒（初回リクエスト時）

## メリット・デメリット

### メリット
1. ✅ シンプルな構成（1つのコンテナ）
2. ✅ 無料枠活用（Always Free Tier）
3. ✅ Java/Graphvizとの統合
4. ✅ 完全なオフライン動作（外部PlantUMLサーバー不要）
5. ✅ 低レイテンシ（同一プロセス内通信）
6. ✅ プライバシー保護（コードが外部送信されない）

### デメリット
- ❌ エッジキャッシングなし（CDN別途必要な場合あり）
- ❌ Vercel特有の最適化なし
- ❌ Cold Start待機時間（初回2-5秒）

### トレードオフ判断
- PoC/MVP段階では**無料運用とシンプル構成を優先**
- 本番環境移行時にmin-instances=1（常時起動、約$7-10/月）を検討
- トラフィック増加時はCloud CDN追加を検討

## 影響範囲

### 1. システムコンテキスト図
- Vercel削除、Cloud Runコンポーネント追加
- デプロイメント戦略の明確化

### 2. 企画書
- デプロイメントセクション更新（Vercel → Cloud Run）
- コスト試算更新（無料枠前提）

### 3. 技術スタック
- フロントエンド: Next.js (App Router) + React + TypeScript
- バックエンド: Next.js API Routes（Cloud Run上）
- PlantUML検証: node-plantuml + ローカルJAR（同一コンテナ内）
- データベース: Supabase Postgres
- ストレージ: Supabase Storage
- **デプロイ: Google Cloud Run**（Vercel削除）

## 関連技術決定

- **TD-008**: Google Cloud Run採用 → PlantUML専用から統合サーバーへ拡張
- **TD-011**: ローカルJAR専用、公式サーバーフォールバック不要 → Cloud Run内で完結
- **TD-010**: 実描画テスト必須 → Cloud Run内のローカルJARで実施

## 参考資料

- [Google Cloud Run Pricing](https://cloud.google.com/run/pricing)
- [Free Tier Services | Google Cloud](https://cloud.google.com/free)
- [Cloud Run Pricing Guide 2025](https://cloudchipr.com/blog/cloud-run-pricing)
- [Next.js Memory Usage Guide](https://nextjs.org/docs/app/guides/memory-usage)
- [Next.js Docker Discussions](https://github.com/vercel/next.js/discussions/65908)
- [PlantUML Docker Memory Settings](https://forum.plantuml.net/15850/what-the-ideal-memory-settings-for-plantuml-docker-container)

## 次のアクション

1. ✅ `technical_decisions.md`更新完了
2. ✅ gitコミット・プッシュ完了
3. ✅ Serena記録完了
4. `plantuml_studio_context.md`更新（Cloud Run追加、Vercel削除、公式サーバーフォールバック削除）
5. 企画書更新（デプロイメント戦略をCloud Run一本化に変更）
6. TD-008更新（PlantUML専用から統合サーバーへ拡張の注記追加）
7. TD-011更新（公式サーバーフォールバック削除の注記追加）

## セッションの重要な学び

### ユーザーからの重要な指摘
1. **アーキテクチャ図と実装の乖離**: コンテキスト図にCloud Runが反映されていない
2. **コンポーネントの存在意義の再検討**: Vercelの必要性を根本的に問い直す
3. **コスト試算の重要性**: 無料枠内での実現可能性を数値で検証

### 技術的な発見
- Cloud Runの無料枠は予想以上に寛容（月間36万リクエスト処理可能）
- Next.js + PlantUMLの統合コンテナは約700-800MB（許容範囲）
- メモリ1GB、1 vCPUで快適に動作可能
- Vercel削除により構成がシンプル化し、管理コストとランニングコストの両方を削減

## アーキテクチャ設計の教訓

1. **プラットフォームの存在意義を常に問う**: 慣習的に使っているツールも再検討の余地あり
2. **統合によるシンプル化**: 複数プラットフォームより単一プラットフォームの方が管理しやすい
3. **無料枠の活用**: Cloud Runの無料枠は小規模プロジェクトに十分すぎる
4. **段階的な最適化**: PoC段階は無料枠、本番環境は常時起動と段階的に対応可能
