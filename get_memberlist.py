######################################################################
#   実行コマンド：python3 get_memberlist.py [数値] [p|b|c]
#   ----------
#  |数値  |球団 |
#   ----------
#  | 1   | G  |
#   ----------
#  | 2   | S  |
#   ----------
#  | 3   | De  |
#   ----------
#  | 4   | D  |
#   ----------
#  | 5   | T  |
#   ----------
#  | 6   | C  |
#   ----------
#  | 7   | L  |
#   ----------
#  | 8   | F  |
#   ----------
#  | 9   | M  |
#   ----------
#  | 11  | B  |
#   ----------
#  | 12  | H  |
#   ----------
#  | 376 | E  |
#   ----------
######################################################################

import requests
from bs4 import BeautifulSoup
import sys
import os

# 変数定義
args = sys.argv
url = "https://baseball.yahoo.co.jp/npb/teams/" + args[1] + "/memberlist?kind=" + args[2]
r = requests.get(url)
data = BeautifulSoup(r.text, 'html.parser')
num_url = [] # スポナビのURLの番号
team_id = '' # 球団略称
num_list = [] # 背番号
filename = 'list_player.txt'
contents = '' #ファイルに書き込む内容

# URLを取得
def get_num_url():
    url_lists = data.select("a[href^='/npb/player/']")
    for url_elem in url_lists:
        num_url.append(str(url_elem).split('/')[3])
    return num_url

# 球団略称を取得
def get_team_id():
    team_elems = data.find_all("h1", class_="bb-head01__title")
    for e in team_elems:
        if e.getText() == "埼玉西武ライオンズ":
            team_id = "L"
        elif e.getText() == "福岡ソフトバンクホークス":
            team_id = "H"
        elif e.getText() == "東北楽天ゴールデンイーグルス":
            team_id = "E"
        elif e.getText() == "千葉ロッテマリーンズ":
            team_id = "M"
        elif e.getText() == "北海道日本ハムファイターズ":
            team_id = "F"
        elif e.getText() == "オリックス・バファローズ":
            team_id = "B"
        elif e.getText() == "読売ジャイアンツ":
            team_id = "G"
        elif e.getText() == "横浜ＤｅＮＡベイスターズ":
            team_id = "De"
        elif e.getText() == "阪神タイガース":
            team_id = "T"
        elif e.getText() == "広島東洋カープ":
            team_id = "C"
        elif e.getText() == "中日ドラゴンズ":
            team_id = "D"
        elif e.getText() == "東京ヤクルトスワローズ":
            team_id = "S"
        else:
            print("[ERROR]球団名が見つかりませんでした")
            sys.exit()
    return team_id

# 背番号を取得
def get_num_list():
    if args[2] == 'c':
        number_lists = data.find_all(class_="bb-table__data bb-table__data--num")
    elif args[2] == 'p' or args[2] == 'b':
        number_lists = data.find_all(class_="bb-playerTable__data bb-playerTable__data--number")
    else:
        print('[ERROR]第２引数は次のいずれかを入力してください：p,b,c')
        sys.exit()
    for number_elem in number_lists:
        num_list.append(number_elem.getText())
    return num_list

# リストの要素数が一致していることの確認
def check_list():
    if len(num_url) != len(num_list):
        print('[ERROR]要素数が一致しないためNG len(num_url):' + len(num_url) + ' len(num_list):' + len(num_list))
        sys.exit()

# 書き込み先ファイルの確認
def chech_file():
    if os.path.isfile(filename):
        print('[INFO]ファイル存在確認OK')
    else:
        print('[ERROR]' + filename + '存在確認NG')
        sys.exit()

# 書き込み内容作成,ファイル書込
def write_contents(contents):
    for i in range(len(num_url)):
        contents_tmp = 'insert ' + team_id + ' ' + num_list[i] + ' ' + num_url[i] + '\n'
        contents += contents_tmp
    # 戻り値は書き込まれた文字数
    open(filename, mode='w').write(contents)
    print('[INFO]' + filename + 'に書込完了')

if __name__=="__main__":
    try:
        chech_file()
        get_num_url()
        team_id = get_team_id()
        get_num_list()
        check_list()
        write_contents(contents)
        print('[INFO]完了')
    except Exception as e:
        print(e)
        print('[ERROR]失敗、エラー要確認')
