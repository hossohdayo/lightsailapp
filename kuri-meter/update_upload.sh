#!/bin/sh

##############################################
# 以下のシェルを実行
# replacement_hits.sh
# s3-upload.sh
# sh update_upload.sh
##############################################

# 変数定義
REPLACEMENT_HITS="${KURI_METER_PATH}/replacement_hits.sh"
S3_UPLOAD="${KURI_METER_PATH}/s3-upload.sh"
TIME=`date +"%Y/%m/%d %H:%M:%S"`
LOG_FILE="/var/log/kuri-meter/update_upload.log"

# 処理開始
echo "${TIME} [INFO] 処理開始" 2>&1 | tee -a "${LOG_FILE}"

# 事前チェック
if [ ! -e $REPLACEMENT_HITS ]; then
  echo "${TIME} [ERROR] REPLACEMENT_HITSが見つかりません" 2>&1 | tee -a "${LOG_FILE}"
  exit 1
fi

# 事前チェック
if [ ! -e $S3_UPLOAD ]; then
  echo "${TIME} [ERROR] S3_UPLOADが見つかりません" 2>&1 | tee -a "${LOG_FILE}"
  exit 1
fi

if [ ! -e ${KURI_METER_PATH} ]; then
  echo "${TIME} [ERROR] KURI_METER_PATHが見つかりません" 2>&1 | tee -a "${LOG_FILE}"
  exit 1
fi

cd ${KURI_METER_PATH}

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] CDOK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

sh ${KURI_METER_PATH}/replacement_hits.sh

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] シェル1実行OK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

sh ${KURI_METER_PATH}/s3-upload.sh

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] シェル2実行OK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

exit 0
