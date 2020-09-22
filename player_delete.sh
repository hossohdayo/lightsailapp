#!/bin/sh

##############################################
# 対象選手をSELECTして
# DELETEする
# 引数1:球団略称
# 引数2:背番号
##############################################

# 処理開始
echo "[INFO] 処理開始"

# 事前チェック
if [ $# -ne 2 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには2個の引数が必要です。" 1>&2
  exit 1
fi

# 変数定義
MYSQL_SCHEMA="mydb"
ROOT_DIRECTORY="/usr/local/etc"
CMD_MYSQL="mysql --defaults-extra-file=$ROOT_DIRECTORY/my.cnf -N --show-warnings $MYSQL_SCHEMA"
TEAM_ID=$1
NUMBER=$2

# SQLの指定
# カラムにアスタリスク（*）を使うとうまくいかなかったので、一つずつ指定
QUERY1="SELECT team_id, number, player_name FROM player where team_id='"
QUERY2="' and number='"
QUERY3="'"
QUERY=$QUERY1$TEAM_ID$QUERY2$NUMBER$QUERY3
echo "[INFO] SQL:$QUERY"

# シェルを実行、実行ログを受け取る
RESULT=`echo ${QUERY} | ${CMD_MYSQL}`

# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo $RESULT
else
    echo "[ERROR] SQL異常終了"
    exit 1
fi

# 選手が選択されなかった場合
if [ -z "$RESULT" ]; then
    echo "[INFO] 選手が存在しません"
    exit 1
fi

# DELETEするか確認
read -n1 -p "削除しますか? (y/N): " yn
if [[ $yn = [yY] ]]; then
  echo "[INFO] 削除します"
else
  echo "[INFO] 削除キャンセルしました"
  exit 0
fi

#削除開始
QUERY4="DELETE FROM player WHERE team_id='"
DELETE_QUERY=$QUERY4$TEAM_ID$QUERY2$NUMBER$QUERY3
# 削除
echo ${DELETE_QUERY} | ${CMD_MYSQL}

# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo "[INFO] deleteOK"
    exit 0
else
    echo "[ERROR] delete異常終了"
    exit 1
fi
