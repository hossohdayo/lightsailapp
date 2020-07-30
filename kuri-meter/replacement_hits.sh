#!/bin/sh

##############################################
# スクレイピングを実行して
# 結果を取得して
# HTMLファイルを置換する
# sh replacement_hits.sh
##############################################

# 変数定義
HTML_FILE="index.html"
PYTHON_FILE="kuri_get_hits.py"
RESULT_FILE="result.txt"

# 処理開始
echo "[INFO] 処理開始"

# 事前チェック
if [ ! -e $HTML_FILE ]; then
  echo "HTML_FILEファイルが見つかりません"
  exit 1
fi

if [ ! -e $PYTHON_FILE ]; then
  echo "PYTHON_FILEファイルが見つかりません"
  exit 1
fi

if [ ! -e $RESULT_FILE ]; then
  echo "RESULT_FILEファイルが見つかりません"
  exit 1
fi

# スクレイピング開始
echo "[INFO] スクレイピング開始"
SCRPAING_RES=`python3 $PYTHON_FILE`

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] 処理終了"
    sleep 1
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了"
    exit 1
fi

# スクレイピング結果を読み込む
RESULT=`cat ${RESULT_FILE}`
res1_1=`echo ${RESULT} | cut -d ',' -f 1 | awk '{print substr($0, 1, 1)}'`
res1_2=`echo ${RESULT} | cut -d ',' -f 1 | awk '{print substr($0, 2, 1)}'`
res1_3=`echo ${RESULT} | cut -d ',' -f 1 | awk '{print substr($0, 3, 1)}'`
res1_4=`echo ${RESULT} | cut -d ',' -f 1 | awk '{print substr($0, 4, 1)}'`
res2=`echo ${RESULT} | cut -d ',' -f 2`

sed -ie "19s/2...年..月..日........./$res2/" $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] 置換OK"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了19行目"
    exit 1
fi

sed -ie 21s/\>.\</\>$res1_1\</ $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] 置換OK"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了21行目"
    exit 1
fi

sed -ie 22s/\>.\</\>$res1_2\</ $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] 置換OK"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了22行目"
    exit 1
fi

sed -ie 23s/\>.\</\>$res1_3\</ $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] 置換OK"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了23行目"
    exit 1
fi

sed -ie 24s/\>.\</\>$res1_4\</ $HTML_FILE

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] 置換OK"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了24行目"
    exit 1
fi

exit 0
