#!/bin/bash
# Evidence 3点セット自動作成スクリプト（Linux/macOS Bash）
# 使用方法: ./scripts/create_evidence.sh <work_type>
# 例: ./scripts/create_evidence.sh feature_http_mcp

set -e

# 引数チェック
if [ $# -eq 0 ]; then
    echo "エラー: work_typeを指定してください"
    echo "使用方法: ./scripts/create_evidence.sh <work_type>"
    exit 1
fi

WORK_TYPE="$1"

# 現在の日時取得
DATE_STR=$(date "+%Y%m%d")
TIME_STR=$(date "+%H%M")
DATETIME_STR=$(date "+%Y-%m-%d %H:%M")
TIME_ONLY=$(date "+%H:%M")

# Evidenceディレクトリパス
EVIDENCE_DIR="docs/poc/evidence/$DATE_STR/$WORK_TYPE"

# ディレクトリ作成
echo "Evidenceディレクトリ作成: $EVIDENCE_DIR"
mkdir -p "$EVIDENCE_DIR"

# instructions.mdテンプレートコピー
INSTRUCTIONS_SRC="docs/templates/instructions_template.md"
INSTRUCTIONS_DEST="$EVIDENCE_DIR/instructions.md"

if [ -f "$INSTRUCTIONS_SRC" ]; then
    echo "instructions.md作成中..."
    cp "$INSTRUCTIONS_SRC" "$INSTRUCTIONS_DEST"

    # プレースホルダー置換
    sed -i.bak "s/<作業タイトル>/$WORK_TYPE/g" "$INSTRUCTIONS_DEST"
    sed -i.bak "s/YYYY-MM-DD HH:MM/$DATETIME_STR/g" "$INSTRUCTIONS_DEST"
    sed -i.bak "s/feature \/ review \/ research \/ migration \/ refactor \/ bugfix/$WORK_TYPE/g" "$INSTRUCTIONS_DEST"
    rm "$INSTRUCTIONS_DEST.bak"

    echo "instructions.md作成完了: $INSTRUCTIONS_DEST"
else
    echo "テンプレートが見つかりません: $INSTRUCTIONS_SRC"
fi

# 00_raw_notes.mdテンプレートコピー
RAW_NOTES_SRC="docs/templates/00_raw_notes_template.md"
RAW_NOTES_DEST="$EVIDENCE_DIR/00_raw_notes.md"

if [ -f "$RAW_NOTES_SRC" ]; then
    echo "00_raw_notes.md作成中..."
    cp "$RAW_NOTES_SRC" "$RAW_NOTES_DEST"

    # プレースホルダー置換
    sed -i.bak "s/<作業タイトル>/$WORK_TYPE/g" "$RAW_NOTES_DEST"
    sed -i.bak "s/YYYY-MM-DD HH:MM/$DATETIME_STR/g" "$RAW_NOTES_DEST"
    sed -i.bak "s/<work_type>/$WORK_TYPE/g" "$RAW_NOTES_DEST"
    sed -i.bak "s/HH:MM/$TIME_ONLY/g" "$RAW_NOTES_DEST"
    rm "$RAW_NOTES_DEST.bak"

    echo "00_raw_notes.md作成完了: $RAW_NOTES_DEST"
else
    echo "テンプレートが見つかりません: $RAW_NOTES_SRC"
fi

# Git状態表示
echo ""
echo "Git状態:"
git status --short

# 次のステップガイド
echo ""
echo "次のステップ:"
echo "1. instructions.md を編集（目標、コンテキスト、実施内容、完了条件）"
echo "2. 作業開始（00_raw_notes.md にリアルタイム記録）"
echo "3. 作業完了後、work_sheet.md を作成（テンプレート: docs/templates/work_sheet_template.md）"
echo "4. Git commit & push"

echo ""
echo "Evidence 3点セット初期化完了！"
