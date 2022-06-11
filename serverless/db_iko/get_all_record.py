import MySQLdb
import json
from datetime import date, datetime
import os

########################################################
# MySQLに接続して
# SQL文を実行
# ファイルに出力
########################################################

# date の変換関数
def json_serial(obj):
    # 日付型の場合には、文字列に変換します
    if isinstance(obj, date):
        return obj.isoformat()
    # 上記以外はサポート対象外.
    raise TypeError ("Type %s not serializable" % type(obj))

def get_record():
    conn = MySQLdb.connect(user='root',
                        password='your password',
                        host='127.0.0.1',
                        db='mydb')
    query = "SELECT team_name, number, player_name, position, throwing_batting, height, weight, birthday, career, pro_year FROM player INNER JOIN team ON player.team_id = team.team_id;"
    with conn.cursor(MySQLdb.cursors.DictCursor) as cursor:
        cursor.execute(query)
        data = cursor.fetchall()
    # print(data)
    # print(json.dumps(data, indent=4, default=json_serial))
    with open(filepath, mode='w') as f:
        f.write(json.dumps(data, indent=4, default=json_serial))
    with open(filepath) as f:
        print(f.read())

if __name__=="__main__":
    # 変数定義
    # ファイル名はdb_dump_YYYYMMDDHHMM.json
    d = datetime.now().strftime('%Y%m%d%H%M')
    serverless_path = os.environ['APP_PATH'] + "/serverless"
    filepath = serverless_path + "/db_iko/db_dump_" + d + ".json"

    get_record()
