import json
import os
import sys
import tweepy
import datetime
from logging import getLogger, config
import yaml

def roster_tweet():
    ########################################################
    #変数定義
    ########################################################
    roster_path = os.environ['ROSTER_PATH']
    log_config_path = roster_path + "/log_config.yaml"
    filepath = roster_path + "/config.json"

    config.dictConfig(yaml.load(open(log_config_path).read(), Loader=yaml.SafeLoader))
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

    filepath = roster_path + '/roster.txt'
    # rosterファイル存在確認
    if os.path.isfile(filepath) == 0:
        logger.error(filepath + 'ファイルがありません。処理を終了します。')
        sys.exit(1)
    else:
        logger.info(filepath + 'ファイル存在確認OK')

    ########################################################
    #メイン処理
    ########################################################
    with open(filepath) as f:
        pitcher_catcher = f.readlines()[0:2]
    with open(filepath) as f:
        infilder_outfilder = f.readlines()[2:4]
    today = datetime.date.today()
    mmdd = today.strftime("%m/%d")
    tweet_content1 = mmdd + '出場選手登録\n'
    tweet_content2 = ''
    for p_c in pitcher_catcher:
        tweet_content1 += p_c
        #print(p_c, end='')
    for i_o in infilder_outfilder:
        tweet_content2 += i_o
        #print(i_o, end='')
    # 末尾の改行コードを削除
    tweet_content1 = tweet_content1.rstrip('\n')
    logger.info("1tweet目：" + tweet_content1)
    logger.info("2tweet目：" + tweet_content2)

    # 140文字以内であることを確認
    if len(tweet_content1) > 140:
        logger.error('tweet_content1が140字を超過しています')
        sys.exit(1)
    elif len(tweet_content2) > 140:
        logger.error('tweet_content2が140字を超過しています')
        sys.exit(1)
    else:
        logger.info('140字以内OK')

    # Tweet
    post_tweet = api.update_status(tweet_content1)
    logger.info('tweetID:' + str(post_tweet.id))
    logger.info('1tweetしました')

    # リプライ形式でTweet
    api.update_status(status = tweet_content2, in_reply_to_status_id = post_tweet.id)
    logger.info('2tweetしました')
    logger.info('処理終了')
    return 0

if __name__=="__main__":
    roster_tweet()
