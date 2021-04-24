import requests
from bs4 import BeautifulSoup
import datetime
from json import load
import os
import sys
from logging import getLogger, config

def get_player():
    ########################################################
    #変数定義
    ########################################################
    roster_path = os.environ['ROSTER_PATH']
    log_config_path = roster_path + "/log_config.json"
    filepath = roster_path + "/roster.txt"

    with open(log_config_path, "r", encoding="utf-8") as f:
        config.dictConfig(load(f))

    logger = getLogger(__name__)

    ########################################################
    #事前確認
    ########################################################
    logger.info('処理開始')
    # rosterファイル存在確認
    if os.path.isfile(filepath) == 0:
        logger.error(filepath + 'ファイルがありません。処理を終了します。')
        sys.exit(1)
    else:
        logger.info(filepath + 'ファイル存在確認OK')

    ########################################################
    #メイン処理
    ########################################################

    # 本日の日付を取得
    today = datetime.date.today()
    mmdd = today.strftime("%m%d")
    logger.info('日付は' + mmdd)

    # 日付を変数にして代入
    url_date = 'https://npb.jp/announcement/roster/roster_' + mmdd + '.html'
    url = requests.get(url_date)
    data = BeautifulSoup(url.content, 'html.parser')
    data_three_column_right = data.select('.three_column_right')
    if data_three_column_right == []:
        logger.error('データがありません。処理を終了します。')
        sys.exit(50)

    data_lions = data_three_column_right[2]

    # ポジションを抽出
    pos_array = data_lions.select('.pos')
    # 背番号を抽出
    num_array = data_lions.select('.num')
    # 選手名を抽出
    name_array = data_lions.select('a')

    # 0バイト書き込み
    with open(filepath, mode='w') as f:
            f.write('')

    logger.info('0バイト書き込み完了')

    roster_pitcher = roster_catcher = roster_infielder = roster_outfielder = ''
    for i in range(len(pos_array)):
        if pos_array[i].getText() == '投手':
            roster_pitcher += name_array[i].getText() + ","
        elif pos_array[i].getText() == '捕手':
            roster_catcher += name_array[i].getText() + ","
        elif pos_array[i].getText() == '内野手':
            roster_infielder += name_array[i].getText() + ","
        elif pos_array[i].getText() == '外野手':
            roster_outfielder += name_array[i].getText() + ","
    roster_list = roster_pitcher[:-1] + '\n'
    roster_list += roster_catcher[:-1] + '\n'
    roster_list += roster_infielder[:-1] + '\n'
    roster_list += roster_outfielder[:-1]
    with open(filepath, mode='a') as f:
        f.write(roster_list)

    logger.info('処理終了')

if __name__=="__main__":
    get_player()
