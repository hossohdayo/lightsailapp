import requests
from bs4 import BeautifulSoup
from datetime import datetime as dt
import sys

args = sys.argv
url = "https://baseball.yahoo.co.jp/npb/player/" + args[1] + "/top"
#r = requests.get('https://baseball.yahoo.co.jp/npb/player/1600127/top')
r = requests.get(url)
data = BeautifulSoup(r.text, 'html.parser')

def get_team():
    elems = data.find_all("h1", class_="bb-head01__title")

    for e in elems:
        if e.getText() == "埼玉西武ライオンズ":
            team = 'L'
        elif e.getText() == "福岡ソフトバンクホークス":
            team = 'H'
        elif e.getText() == "東北楽天ゴールデンイーグルス":
            team = 'E'
        elif e.getText() == "千葉ロッテマリーンズ":
            team = 'M'
        elif e.getText() == "北海道日本ハムファイターズ":
            team = 'F'
        elif e.getText() == "オリックス・バファローズ":
            team = 'B'
        elif e.getText() == "読売ジャイアンツ":
            team = 'G'
        elif e.getText() == "横浜DeNAベイスターズ":
            team = 'De'
        elif e.getText() == "阪神タイガース":
            team = 'T'
        elif e.getText() == "広島東洋カープ":
            team = 'C'
        elif e.getText() == "中日ドラゴンズ":
            team = 'D'
        elif e.getText() == "東京ヤクルトスワローズ":
            team = 'S'
        else:
            team = 'エラー'
    return team

def get_player_number():
    elems3 = data.find_all("p", class_="bb-profile__number")
    number = elems3[0].getText()
    return number

def get_player_position():
    elems4 = data.find_all("p", class_="bb-profile__position")
    position = elems4[0].getText()
    return position

def get_player_name():
    elems5 = data.find_all("h1")
    name = elems5[2].getText()
    return name

def get_player_data():
    titles = data.find_all(class_="bb-profile__title")
    player = "F_player"
    elems2 = data.find_all("dd", class_="bb-profile__text")
    birth = elems2[1].getText()[:-5]
    birthday = dt.strptime(birth,'%Y年%m月%d日').date() #文字列から日付に変換
    birthplace = elems2[0].getText()
    height = elems2[2].getText()[:3]
    weight = elems2[3].getText().split('kg')[0]
    tou = elems2[5].getText()[0:2]
    da = elems2[5].getText()[3:5]
    touda = tou + da
    for title in titles:
        if "ドラフト年（順位）" in title: #日本人選手
            player = "J_player"
            break

    if player == "J_player":
        draft = elems2[6].getText()
        pro_year = elems2[7].getText()[:-1]
        career = elems2[8].getText()
    elif player == "F_player":
        draft = None
        pro_year = elems2[6].getText()[:-1]
        career = elems2[7].getText()
    else:
        print("[ERROR]ドラフト対象選手の可否が判断できません")

    results = [
        birthday,
        birthplace,
        height,
        weight,
        touda,
        draft,
        pro_year,
        career
    ]

    return results

if __name__=="__main__":
    _team = get_team()
    _number = get_player_number()
    _name = get_player_name()
    _position = get_player_position()
    _results = get_player_data()
    print("insert into player values(\'" + _team + "\', \'" + _number + "\', \'" + _name + "\', \'" + _position + "\', \'" + _results[4] + "\', " + _results[2] + ", " + _results[3]
     + ", \'" + str(_results[0]) + "\', \'" + _results[7] + "\', " + _results[6] + ");")
