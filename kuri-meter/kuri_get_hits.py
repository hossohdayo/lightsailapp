import requests
from bs4 import BeautifulSoup
import datetime

def get_kuri_hits():
    # 結果を書き込むファイル
    result = 'result.txt'
    # 栗山のトップページ
    url = "https://baseball.yahoo.co.jp/npb/player/12102/top"
    r = requests.get(url)
    data = BeautifulSoup(r.text, 'html.parser')

    # 安打数を含むHTMLを取得
    elems = data.find_all("th", class_="bb-playerStatsTable__head")
    # 安打数の部分を抽出
    hits = elems[-20].getText()

    # 現在時刻を取得
    now = datetime.datetime.now()
    now = now.strftime('%Y年%m月%d日 %H:%M:%S')

    # ファイルに書き込むために成形
    hits_now = hits + ',' + now

    # ファイルに書き込み
    open(result, mode='w').write(hits_now)

    return 0

if __name__=="__main__":
    _results = get_kuri_hits()
    print(_results)
