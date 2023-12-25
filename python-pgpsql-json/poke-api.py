
# https://www.pg4e.com/code/swapi.py
# https://www.pg4e.com/code/myutils.py

# If needed:
# https://www.pg4e.com/code/hidden-dist.py
# copy hidden-dist.py to hidden.py
# edit hidden.py and put in your credentials

# python3 swapi.py
# Pulls data from the swapi.py4e.com API and puts it into our swapi table

import psycopg2
import hidden
import time
import myutils
import requests
import json

def summary(cur) :
    total = myutils.queryValue(cur, 'SELECT COUNT(*) FROM pokeapi;')
    ##print(f'Total={total} todo={todo} good={good} error={error}')

# Load the secrets
secrets = hidden.secrets()

conn = psycopg2.connect(host=secrets['host'],
        port=secrets['port'],
        database=secrets['database'],
        user=secrets['user'],
        password=secrets['pass'],
        connect_timeout=3)

cur = conn.cursor()

defaulturl = 'https://pokeapi.co/api/v2/pokemon/1/'
print('If you want to restart the spider, run')
print('DROP TABLE IF EXISTS pokeapi CASCADE;')

sql = '''
CREATE TABLE IF NOT EXISTS pokeapi
(id INTEGER, body JSONB);
'''
print(sql)
cur.execute(sql)


for i in range(1,100):
    url = 'https://pokeapi.co/api/v2/pokemon/'+str(i)+'/'
    
    
    try:
        print('=== Url is', url)
        response = requests.get(url)
        text = response.text
        print('=== Text is', text)
        status = response.status_code
        
        sql = 'INSERT INTO pokeapi (id,body) VALUES ( %s,%s);'
        cur.execute(sql,(i,text	))
        conn.commit()

    except KeyboardInterrupt:
        print('')
        print('Program interrupted by user...')
        break
    except Exception as e:
        print("Unable to retrieve or parse page",url)
        print("Error",e)
    
    
    
print('Closing database connection...')
conn.commit()
cur.close()