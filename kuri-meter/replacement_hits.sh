#!/bin/sh

##############################################
# スクレイピングを実行して
# 結果を取得して
# HTMLファイルを置換する
# sh replacement_hits.sh
##############################################

# 変数定義
HTML_FILE="${KURI_METER_PATH}/index.html"
PYTHON_FILE="${KURI_METER_PATH}/kuri_get_hits.py"
RESULT_FILE="${KURI_METER_PATH}/result.txt"
TIME=`date +"%Y/%m/%d %H:%M:%S"`
LOG_FILE="/var/log/kuri-meter/replacement_hits.log"

# 処理開始
echo "${TIME} [INFO] 処理開始" 2>&1 | tee -a "${LOG_FILE}"

# 事前チェック
if [ ! -e $HTML_FILE ]; then
  echo "${TIME} [ERROR] HTML_FILEファイルが見つかりません" 2>&1 | tee -a "${LOG_FILE}"
  exit 1
fi

if [ ! -e $PYTHON_FILE ]; then
  echo "${TIME} [ERROR] PYTHON_FILEファイルが見つかりません" 2>&1 | tee -a "${LOG_FILE}"
  exit 1
fi

if [ ! -e $RESULT_FILE ]; then
  echo "${TIME} [ERROR] RESULT_FILEファイルが見つかりません" 2>&1 | tee -a "${LOG_FILE}"
  exit 1
fi

# スクレイピング開始
echo "${TIME} [INFO] スクレイピング開始" 2>&1 | tee -a "${LOG_FILE}"
SCRPAING_RES=`python3 $PYTHON_FILE`

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] 処理終了" 2>&1 | tee -a "${LOG_FILE}"
    sleep 1
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

# スクレイピング結果を読み込む
RESULT=`cat ${RESULT_FILE}`
res1_1=`echo ${RESULT} | cut -d ',' -f 1 | awk '{print substr($0, 1, 1)}'`
res1_2=`echo ${RESULT} | cut -d ',' -f 1 | awk '{print substr($0, 2, 1)}'`
res1_3=`echo ${RESULT} | cut -d ',' -f 1 | awk '{print substr($0, 3, 1)}'`
res1_4=`echo ${RESULT} | cut -d ',' -f 1 | awk '{print substr($0, 4, 1)}'`
res2=`echo ${RESULT} | cut -d ',' -f 2`

sed -ie "24s/2...年..月..日........./$res2/" $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] 置換OK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了19行目" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

sed -ie 26s/\>.\</\>$res1_1\</ $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] 置換OK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了21行目" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

sed -ie 27s/\>.\</\>$res1_2\</ $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] 置換OK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了22行目" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

sed -ie 28s/\>.\</\>$res1_3\</ $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] 置換OK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了23行目" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

sed -ie 29s/\>.\</\>$res1_4\</ $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "${TIME} [INFO] 置換OK" 2>&1 | tee -a "${LOG_FILE}"
else
    echo "${TIME} [ERROR] 予期せぬエラーが発生 異常終了24行目" 2>&1 | tee -a "${LOG_FILE}"
    exit 1
fi

exit 0
