#!/bin/bash

# 引数チェック
if [ "$#" -ne 1 ]; then
    echo "使用法: $0 URL"
    exit 1
fi

# 出力ディレクトリの設定
OUTPUT_DIR="output"

# 出力ディレクトリがなければ作成
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p $OUTPUT_DIR
fi

# URLからファイル名を抽出
URL=$1
FILENAME=$(basename $URL)

# 一時ファイルパスの生成
TEMP_FILE="$OUTPUT_DIR/$FILENAME"

# URLからファイルをダウンロードし、一時ファイルに保存
curl -s -o "$TEMP_FILE" $URL

# ファイル名に拡張子が既にあるかチェック
if [[ ! $FILENAME =~ \.[^./]+$ ]]; then
    # fileコマンドでファイルタイプを取得
    FILETYPE=$(file --mime-type -b "$TEMP_FILE")

    # 拡張子のマッピング例
    case $FILETYPE in
        image/jpeg) EXT="jpg" ;;
        image/png) EXT="png" ;;
        image/gif) EXT="gif" ;;
        image/webp) EXT="webp" ;;
        *) EXT="png" ;; # 未知のファイルタイプの場合はデフォルトでpng
    esac

    # 拡張子を追加
    FILENAME="$FILENAME.$EXT"
    mv "$TEMP_FILE" "$OUTPUT_DIR/$FILENAME"
else
    # 拡張子が既にある場合はリネームの必要なし
    mv "$TEMP_FILE" "$OUTPUT_DIR/$FILENAME"
fi

echo "ダウンロード完了: $OUTPUT_DIR/$FILENAME"
