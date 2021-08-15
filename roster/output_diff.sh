#!/bin/sh

##############################################
# sedをしてroster.txtをroster_sed.txtにする
# diff結果をget_diff.txtに出力する
# roster_sed.txtをコピーしてroster_sed.txt_YYYYMMDDにする
# 前日のroster_sed.txt_YYYYMMDDを削除する
# 実行タイミング：get_player.pyが実行された後
##############################################

# 処理開始
echo "[INFO] 処理開始"

# 事前チェック
if [ ! -e $ROSTER_PATH ]; then
  echo "${TIME} [ERROR] 環境変数ROSTER_PATHが見つかりません"
  exit 1
fi

# 変数定義
ROSTER_TXT="roster.txt"
ROSTER_TXT_FULL_PATH="$ROSTER_PATH/$ROSTER_TXT"
ROSTER_TXT_SED="roster_sed.txt"
ROSTER_TXT_SED_FULL_PATH="$ROSTER_PATH/$ROSTER_TXT_SED"
TODAY=`date +%Y%m%d`
ROSTER_TXT_TODAY="roster_sed.txt_$TODAY"
ROSTER_TXT_TODAY_FULL_PATH="$ROSTER_PATH/$ROSTER_TXT_TODAY"
YEST=`date +%Y%m%d --date '1 day ago'`
#YEST=`date -v -1d +%Y%m%d` #macで実行する場合
ROSTER_TXT_YEST="roster_sed.txt_$YEST"
ROSTER_TXT_YEST_FULL_PATH="$ROSTER_PATH/$ROSTER_TXT_YEST"
DIFF_TXT_FULL_PATH="$ROSTER_PATH/get_diff.txt"

# 事前チェック
if [ ! -e $ROSTER_TXT_FULL_PATH ]; then
  echo "${TIME} [ERROR] ROSTER_TXT_FULL_PATHファイルが見つかりません"
  exit 1
fi

# 前日ファイルチェック
if [ ! -e $ROSTER_TXT_YEST_FULL_PATH ]; then
  echo "${TIME} [ERROR] ROSTER_TXT_YEST_FULL_PATHファイルが見つかりません"
  exit 1
fi

# メイン処理
# sedをしてroster.txtをroster_sed.txtにする
sed 's/,/\n/g' < $ROSTER_TXT_FULL_PATH > $ROSTER_TXT_SED_FULL_PATH

# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo "[INFO] sedOK"
else
    echo "[ERROR] sedに異常終了しました"
    exit 1
fi

# ファイルチェック
if [ ! -e $ROSTER_TXT_SED_FULL_PATH ]; then
  echo "${TIME} [ERROR] ROSTER_TXT_SED_FULL_PATHファイルが見つかりません"
  exit 1
fi

# diff結果をget_diff.txtに出力する
diff -u $ROSTER_TXT_YEST_FULL_PATH $ROSTER_TXT_SED_FULL_PATH | tail -n +3 | grep -e "^-" -e "^+" > $DIFF_TXT_FULL_PATH

# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo "[INFO] diffOK差分あり"
elif [ $? -eq 1 ]; then
    echo "[INFO] diffOK差分なし"
    echo "なし" >> $DIFF_TXT_FULL_PATH
else
    echo "[ERROR] diffの結果出力に異常終了しました"
    exit 1
fi

# ファイルチェック
if [ ! -e $DIFF_TXT_FULL_PATH ]; then
  echo "${TIME} [ERROR] DIFF_TXT_FULL_PATHファイルが見つかりません"
  exit 1
fi

# roster_sed.txtをコピーしてroster_sed.txt_YYYYMMDDにする
cp -p $ROSTER_TXT_SED_FULL_PATH $ROSTER_TXT_TODAY_FULL_PATH

# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo "[INFO] cpOK"
else
    echo "[ERROR] cpに異常終了しました"
    exit 1
fi

# 当日ファイルチェック
if [ ! -e $ROSTER_TXT_TODAY_FULL_PATH ]; then
  echo "${TIME} [ERROR] ROSTER_TXT_TODAY_FULL_PATHファイルが見つかりません"
  exit 1
fi

# 前日のroster_sed.txt_YYYYMMDDを削除する
rm -f $ROSTER_TXT_YEST_FULL_PATH

# 結果の終了コードチェック
if [ $? -eq 0 ]; then
    echo "[INFO] rmOK"
else
    echo "[ERROR] rmに異常終了しました"
    exit 1
fi

echo "${TIME} [INFO] 処理終了"
exit 0