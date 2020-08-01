#!/bin/sh

##############################################
# 以下のシェルを実行
# replacement_hits.sh
# s3-upload.sh
# sh update_upload.sh
##############################################

# 変数定義
REPLACEMENT_HITS="replacement_hits.sh"
S3_UPLOAD="s3-upload.sh"

# 処理開始
echo "[INFO] 処理開始"

# 事前チェック
if [ ! -e $REPLACEMENT_HITS ]; then
  echo "REPLACEMENT_HITSが見つかりません"
  exit 1
fi

# 事前チェック
if [ ! -e $S3_UPLOAD ]; then
  echo "S3_UPLOADが見つかりません"
  exit 1
fi

sh replacement_hits.sh

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] シェル1実行OK"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了"
    exit 1
fi

sh s3-upload.sh

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] シェル2実行OK"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了"
    exit 1
fi

exit 0
