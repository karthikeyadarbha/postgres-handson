# https://www.pg4e.com/code/elastictweet.py

# Example from:
# https://elasticsearch-py.readthedocs.io/en/master/

# pip install 'elasticsearch<7.14.0'

# (If needed)
# https://www.pg4e.com/code/hidden-dist.py
# copy hidden-dist.py to hidden.py
# edit hidden.py and put in your credentials

from datetime import datetime
from elasticsearch import Elasticsearch
from elasticsearch import RequestsHttpConnection
import time
import copy
import hidden
import uuid
import json
import hashlib

bookfile = input("Enter book file (i.e. pg18866.txt): ")
if bookfile.strip() == '':
    raise Exception("empty string detected, please try again to enter a book file")

# Make sure we can open the file
fhand = open(bookfile)
secrets = hidden.elastic()

es = Elasticsearch(
    [secrets['host']],
    http_auth=(secrets['user'], secrets['pass']),
    url_prefix = secrets['prefix'],
    scheme=secrets['scheme'],
    port=secrets['port'],
    connection_class=RequestsHttpConnection,
)
indexname = secrets['user']

# Start fresh
# https://elasticsearch-py.readthedocs.io/en/master/api.html#indices
res = es.indices.delete(index=indexname, ignore=[400, 404])
print("Dropped index")
print(res)

res = es.indices.create(index=indexname)
print("Created the index...")
print(res)

doc = {
    'author': 'kimchy',
    'type' : 'tweet',
    'text': 'Elasticsearch: cool. bonsai cool.',
    'timestamp': datetime.now(),
}

# Note - you can't change the key type after you start indexing documents
res = es.index(index=indexname, id='abc', body=doc)
print('Added document...')
print(res['result'])

res = es.get(index=indexname, id='abc')
print('Retrieved document...')
print(res)

# Tell it to recompute the index - normally it would take up to 30 seconds
# Refresh can be costly - we do it here for demo purposes
# https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-refresh.html
res = es.indices.refresh(index=indexname)
print("Index refreshed")
print(res)

# Read the documents with a search term
# https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html
x = {
  "query": {
    "bool": {
      "must": {
        "match": {
          "text": 'Elasticsearch: cool. bonsai cool.'
        }
      },
      "filter": {
        "match": {
          "type": "tweet" 
        }
      }
    }
  }
}

res = es.search(index=indexname, body=x)
print('Search results...')
print(res)
print()
print("Got %d Hits:" % len(res['hits']['hits']))

para = 'would eliminate one of them Taking a break helps with the thinking So does talking If you explain the problem to someone else or even to yourself you will sometimes find the answer before you finish asking the question But even the best debugging techniques will fail if there are too many'
chars = 0
count = 0
pcount = 0
for hit in res['hits']['hits']:
    s = hit['_source']
    print(f"{s['timestamp']} {s['author']}: {s['text']}")
    line = s['text']
    pcount = pcount + 1
    doc = {
        'type' : pcount,
        'text': para
    }

    # Use the paragraph count as primary key
    # pkey = pcount

    # Use a GUID for the primary key
    # pkey = uuid.uuid4()

    # Compute a SHA256 of the entire document as the primary key.
    # Because the pkey is a based on the document contents
    # the "index" is in effect INSERT ON CONFLICT UPDATE unless
    # the document contents change
    m = hashlib.sha256()
    m.update(json.dumps(doc).encode())
    pkey = m.hexdigest()

    res = es.index(index=indexname, id=pkey, body=doc)

    print('Added document', pkey)
    # print(res['result'])

    if pcount % 100 == 0 :
        print(pcount, 'loaded...')
        time.sleep(1)

    para = ''
    continue

    para = para + ' ' + line


res = es.indices.refresh(index=indexname)
print("Index refreshed", indexname)
print(res)

print(' ')
print('Loaded',pcount,'paragraphs',count,'lines',chars,'characters')