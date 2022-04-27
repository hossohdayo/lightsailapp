import requests
from bs4 import BeautifulSoup
import datetime
from json import load
import os
import sys
from logging import getLogger, config
import schedule
import time
import get_player
import roster_tweet
import roster_diff_tweet
import subprocess

########################################################
#　実行すると試合開始1時間前にget_playerとroster_tweetを実行する
#　さらにroster_diff_tweetも実行するよう改修
########################################################

########################################################
#変数定義
########################################################
roster_path = os.environ['ROSTER_PATH']
log_config_path = roster_path + "/log_config.json"
output_diff_path = roster_path + "/output_diff.sh"

with open(log_config_path, "r", encoding="utf-8") as f:
    config.dictConfig(load(f))

logger = getLogger(__name__)

def get_schedule():
    ########################################################
    #事前確認
    ########################################################
    logger.info('処理開始')

    today = datetime.date.today()
    mm = today.strftime("%m")
    dd = today.strftime("%d")
    mmdd = mm + dd
    logger.info('本日の日付' + mmdd )

    ########################################################
    #メイン処理
    ########################################################
    # 日付が0から始まる場合は下一桁にする
    if dd[0] == '0':
        d = dd[1]
        logger.info('日付を変換しました。変換後：' + d )
    else:
        d = dd
    if mm[1] == '3':
        mm = '04'
        logger.info('月を変換しました。変換後：' + mm )
    # 月を変数にして代入
    url_date = 'https://npb.jp/bis/teams/calendar_l_' + mm + '.html'
    url = requests.get(url_date)
    data = BeautifulSoup(url.content, 'html.parser')
    data_teschedate = data.find_all('td', class_="teschedule")

    # 本日の試合開始時間を取得
    for d_date in data_teschedate:
        try: 
            #本日日付
            if d_date.find("div", text=d) != None:
                # 時間の記載があるかチェック
                if d_date.find("div", class_="tevsteam") != None:
                    game_time = d_date.find("div", class_="tevsteam").contents[2]
                    str_game_time = game_time.get_text()
                    str_game_time = str_game_time.replace('：', ':')
                    logger.info('試合時間は' + str_game_time)
                    game_dttm = datetime.datetime.strptime(str_game_time, '%H:%M')
                    minus_time = datetime.timedelta(hours=1) # ずらす時間
                    kouji_time = game_dttm - minus_time
                    str_kouji_time = kouji_time.strftime('%H:%M')
                    logger.info('公示時間は' + str_kouji_time)
                    return(str_kouji_time)
                else:
                    logger.info("日付はあるが試合なし")
                    return('16:00')
        except ValueError as err: # 3・4月は同じ日付があるためうまく時間が取得できないバグの暫定対応
            logger.info(err)
            return('16:00')

def get_player_roster_tweet_roster_diff_tweet():
    logger.info('get_player_roster_tweet_roster_diff_tweet開始')
    res_get_player = get_player.get_player()
    if res_get_player == 0:
        logger.info('res_get_playerが正常終了')
        res_roster_tweet = roster_tweet.roster_tweet()
        if res_roster_tweet == 0:
            logger.info('roster_tweetが正常終了')
            res_sh = subprocess.run(['sh', output_diff_path])
            if res_sh.returncode == 0:
                logger.info('sh output_diff.shが正常終了')
                res_roster_diff_tweet = roster_diff_tweet.roster_diff_tweet()
                if res_roster_diff_tweet == 0:
                    logger.info('roster_diff_tweetが正常終了')
                else:
                    logger.error('roster_diff_tweetでエラーが発生しました')
                    sys.exit(1)
            else:
                logger.error('sh output_diff.shでエラーが発生しました')
                sys.exit(1)
        else:
            logger.error('roster_tweetでエラーが発生しました')
            sys.exit(1)
    else:
        logger.error('res_get_playerでエラーが発生しました')
        sys.exit(1)
    sys.exit(0)

if __name__=="__main__":
    _results = get_schedule()
    logger.info('_results = ' + _results)
    schedule.every().day.at(_results).do(get_player_roster_tweet_roster_diff_tweet)
    while True:
        schedule.run_pending()
        time.sleep(60)
