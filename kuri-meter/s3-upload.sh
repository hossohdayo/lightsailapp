#!/bin/sh

##############################################
# アップロード対象のバケットを確認して
# ファイルをアップロードする
# sh s3-upload.sh
##############################################

# 変数定義
TARGET_BUCKET="hossohdayo-kuri-meter"
TARGET_FILE="index.html"
TIME=`date +"%Y/%m/%d %H:%M:%S"`
LOG_FILE="/var/log/kuri-meter/s3-upload.log"

# 処理開始
echo "${TIME} [INFO] 処理開始" 2>&1 | tee -a "${LOG_FILE}"

# ローカルにアップロード対象があることを確認
if [ ! -e ${KURI_METER_PATH}/$TARGET_FILE ]; then
  echo "${TIME} [ERROR] アップロード対象が見つかりません" 2>&1 | tee -a "${LOG_FILE}"
  exit 1
fi

# バケット確認
/usr/local/bin/aws s3 ls s3://$TARGET_BUCKET/$TARGET_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] ファイル確認OK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

# ファイルをs3にアップロード
#/usr/local/bin/aws s3 cp ${KURI_METER_PATH}/$TARGET_FILE s3://$TARGET_BUCKET/$TARGET_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] アップロードOK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

exit 0
