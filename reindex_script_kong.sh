#!/bin/bash

ind=$(curl --silent -X GET "http://logstash.hel.ninja:9200/_cat/indices?v" | grep logstash-kong | tr -s [:blank:] | cut -d' ' -f3 | cut -d'-' -f3)

for i in $ind; do
  if [ $(curl --silent -X GET "localhost:9200/apilogs-$i"|cut -d'"' -f2) = "error" ]; then
    echo $i
    curl --silent -X POST "localhost:9200/_reindex" -H "Content-Type: application/json" -d'
    {
      "source": {
        "remote": {
          "host": "http://logstash.hel.ninja:9200"
        },
        "index": "logstash-kong-'"$i"'"
      },
      "dest": {
        "index": "apilogs-'"$i"'"
      }
    }'
  fi
done
