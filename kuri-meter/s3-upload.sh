#!/bin/sh

##############################################
# アップロード対象のバケットを確認して
# ファイルをアップロードする
# sh s3-upload.sh
##############################################

# 変数定義
TARGET_BUCKET="hossohdayo-kuri-meter"
TARGET_FILE="index.html"

# 処理開始
echo "[INFO] 処理開始"

# ローカルにアップロード対象があることを確認
if [ ! -e $TARGET_FILE ]; then
  echo "アップロード対象が見つかりません"
  exit 1
fi

# バケット確認
aws s3 ls s3://$TARGET_BUCKET/$TARGET_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] ファイル確認OK"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了"
    exit 1
fi

# ファイルをs3にアップロード
aws s3 cp $TARGET_FILE s3://$TARGET_BUCKET/$TARGET_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] アップロードOK"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了"
    exit 1
fi

exit 0
