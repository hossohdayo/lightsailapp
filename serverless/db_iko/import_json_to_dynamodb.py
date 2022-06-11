from boto3.session import Session
from decimal import Decimal
import json
import os
import sys
 
def get_dynamo_table(table_name):
    session = Session(profile_name='dynamodb_access')
 
    dynamodb = session.resource('dynamodb')
    dynamo_table = dynamodb.Table(table_name)
    return dynamo_table
 
def insert_data_from_json(table, input_file_name):
    with open(input_file_name, "r") as f:
        json_data = json.load(f)
        with table.batch_writer() as batch:
            for record in json_data:
                record["height"] = Decimal("{}".format(record["height"])) # テーブル側で数値型を指定している場合はこのような処理が必要
                record["weight"] = Decimal("{}".format(record["weight"])) # テーブル側で数値型を指定している場合はこのような処理が必要
                record["pro_year"] = Decimal("{}".format(record["pro_year"])) # テーブル側で数値型を指定している場合はこのような処理が必要
                batch.put_item(Item=record)
    print('Successfully inserted data.')
 
if __name__ == '__main__':
    args = sys.argv
    file_name = args[1]
    serverless_path = os.environ['APP_PATH'] + "/serverless"
    input_file_name = serverless_path + "/db_iko/" + file_name

    dynamo_table = get_dynamo_table('player')
    insert_data_from_json(dynamo_table, input_file_name)