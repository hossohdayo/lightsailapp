#!/bin/sh

##############################################
# 対象選手をSELECTして
# INSERTする
# 引数1:球団略称
# 引数2:背番号
# 引数3:スポナビのURLの番号
##############################################

# 処理開始
echo "[INFO] 処理開始"

# 事前チェック
if [ $# -ne 3 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには3個の引数が必要です。" 1>&2
  exit 1
fi

# 変数定義
MYSQL_SCHEMA="mydb"
ROOT_DIRECTORY="/usr/local/etc"
CMD_MYSQL="mysql --defaults-extra-file=$ROOT_DIRECTORY/my.cnf -N --show-warnings $MYSQL_SCHEMA"
TEAM_ID=$1
NUMBER=$2
URL=$3

# SQLの指定
# カラムにアスタリスク（*）を使うとうまくいかなかったので、一つずつ指定
QUERY1="SELECT count(team_id) FROM player where team_id='"
QUERY2="' and number='"
QUERY3="'"
QUERY=$QUERY1$TEAM_ID$QUERY2$NUMBER$QUERY3
echo "[INFO] SQL:$QUERY"

# シェルを実行、実行ログを受け取る
VALUE=`echo ${QUERY} | ${CMD_MYSQL}`
# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo "[INFO] SELECT OK"
else
    echo "[ERROR] SQL異常終了"
    exit 1
fi
if [ $VALUE != "0" ] || [ $VALUE != "1" ]; then
    echo "[INFO] 選手存在確認${VALUE}件"
else
    echo "[ERROR] VALUEが0でなく1でもないため異常終了"
    exit 1
fi

# スクレイピング開始
echo "[INFO] スクレイピング開始"
SCRPAING_RES=`python3 player_scraping.py $URL`

# 結果のチェック
if [ $? -eq 0 ]; then
    echo "[INFO] 処理終了"
else
    echo "[ERROR] 予期せぬエラーが発生 異常終了"
    exit 1
fi

# スクレイピング結果をインサート
echo ${SCRPAING_RES} | ${CMD_MYSQL}

# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo "[INFO] insertOK"
    exit 0
else
    echo "[ERROR] insertSQL異常終了"
    exit 1
fi
