import json
from json import load
import os
import sys
import tweepy
import datetime
from logging import getLogger, config

def roster_diff_tweet():
    ########################################################
    #変数定義
    ########################################################
    roster_path = os.environ['ROSTER_PATH']
    log_config_path = roster_path + "/log_config.json"
    filepath = roster_path + "/config.json"
    tweet_content = "出場選手登録抹消\n"

    with open(log_config_path, "r", encoding="utf-8") as f:
        config.dictConfig(load(f))

    logger = getLogger(__name__)

    ########################################################
    #事前確認
    ########################################################
    logger.info('処理開始')
    # configファイル存在確認
    if os.path.isfile(filepath) == 0:
        logger.error(filepath + 'ファイルがありません。処理を終了します。')
        sys.exit(1)
    else:
        logger.info(filepath + 'ファイル存在確認OK')

    # ファイルを開く
    json_file = open(filepath, 'r')
    # JSONとして読み込む
    json_obj = json.load(json_file)

    #　値の取り出し
    CONSUMER_KEY        = json_obj['api_key']['CONSUMER_KEY']
    CONSUMER_SECRET     = json_obj['api_key']['CONSUMER_SECRET']
    ACCESS_TOKEN        = json_obj['api_key']['ACCESS_TOKEN']
    ACCESS_TOKEN_SECRET = json_obj['api_key']['ACCESS_TOKEN_SECRET']

    auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
    auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
    api = tweepy.API(auth)

    filepath = roster_path + '/get_diff.txt'
    # get_diff.txtファイル存在確認
    if os.path.isfile(filepath) == 0:
        logger.error(filepath + 'ファイルがありません。処理を終了します。')
        sys.exit(1)
    else:
        logger.info(filepath + 'ファイル存在確認OK')

    ########################################################
    #メイン処理
    ########################################################
    with open(filepath) as f:
        tweet_content += f.read()
    logger.info("tweet内容：" + tweet_content)

    # 140文字以内であることを確認
    if len(tweet_content) > 140:
        logger.error('tweet_contentが140字を超過しています')
        sys.exit(1)
    else:
        logger.info('140字以内OK')

    # Tweet
    post_tweet = api.update_status(tweet_content)
    logger.info('roster_diff_tweetしました')
    tweet_obj = api.get_status(post_tweet.id)

    logger.info('処理終了')
    return 0

if __name__=="__main__":
    roster_diff_tweet()
