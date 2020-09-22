#!/bin/sh

##############################################
# list_player.txtを読み込んで
# insertの場合はplayer_insert.shを実行する
# deleteの場合はplayer_delete.shを実行する
# 引数:なし
##############################################

# 処理開始
echo "[INFO] 処理開始"

# 事前チェック
if [ $# -ne 0 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには0個の引数が必要です。" 1>&2
  exit 1
fi

# 変数定義
LIST_PLAYER="list_player.txt"
ROOT_DIR=`pwd`
LIST_PLAYER_FULL_PATH="$ROOT_DIR/$LIST_PLAYER"
TARGET_FILE="player_insert.sh"
TARGET_FILE2="player_delete.sh"
TARGET_FILE_FULL_PATH="$ROOT_DIR/$TARGET_FILE"
TARGET_FILE_FULL_PATH2="$ROOT_DIR/$TARGET_FILE2"

# 事前チェック
if [ ! -e $LIST_PLAYER_FULL_PATH ]; then
  echo "${TIME} [ERROR] LIST_PLAYERファイルが見つかりません"
  exit 1
fi

# 事前チェック
if [ ! -e $TARGET_FILE_FULL_PATH ] && [ ! -e $TARGET_FILE_FULL_PATH2 ]; then
  echo "${TIME} [ERROR] TARGET_FILE(2)ファイルが見つかりません"
  exit 1
fi

# LIST_PLAYER行数確認
ROW=`wc -l $LIST_PLAYER_FULL_PATH | awk '{print $1}'`

# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo "[INFO] LIST_PLAYER行数確認OK"
else
    echo "[ERROR] LIST_PLAYER行数確認異常終了"
    exit 1
fi

# LIST_PLAYER行数0はスキップ
if [ $ROW -eq 0 ]; then
    echo "[INFO] 0行です"
    exit 0
fi

# メイン処理
for i in `seq $ROW`
do
  # i行目を読み込む
  LIST_PLAYER_CONTENTS=`cat $LIST_PLAYER_FULL_PATH | head -n $i | tail -n 1`
  LIST_PLAYER_CONTENTS_1=`echo $LIST_PLAYER_CONTENTS | awk '{print $1}'`
  LIST_PLAYER_CONTENTS_2=`echo $LIST_PLAYER_CONTENTS | awk '{print $2}'`
  LIST_PLAYER_CONTENTS_3=`echo $LIST_PLAYER_CONTENTS | awk '{print $3}'`
  LIST_PLAYER_CONTENTS_4=`echo $LIST_PLAYER_CONTENTS | awk '{print $4}'`
  # insertかdeleteか判定して別シェルを叩く
  if [ $LIST_PLAYER_CONTENTS_1 = "insert" ]; then
    sh $TARGET_FILE_FULL_PATH $LIST_PLAYER_CONTENTS_2 $LIST_PLAYER_CONTENTS_3 $LIST_PLAYER_CONTENTS_4
  elif [ $LIST_PLAYER_CONTENTS_1 = "delete" ]; then
    sh $TARGET_FILE_FULL_PATH2 $LIST_PLAYER_CONTENTS_2 $LIST_PLAYER_CONTENTS_3
  else
    echo "[ERROR] 1文字目がdeleteまたはinsert以外"
    exit 1
  fi
  # 結果の終了コードチェック
  if [ $? -eq 0 ]; then
      echo "[INFO] 別シェルOK"
  else
      echo "[ERROR] 別シェル異常終了"
      exit 1
  fi
done

# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo "[INFO] LOOP OK"
    exit 0
else
    echo "[ERROR] LOOP 異常終了"
    exit 1
fi
