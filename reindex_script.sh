#!/bin/bash

reindex() {
  curl --silent -X POST "localhost:9200/_reindex" -H "Content-Type: application/json" -d'
  {
    "source": {
      "remote": {
        "host": "http://logstash.hel.ninja:9200"
      },
      "index": "logstash-'"$1"'-'"$2"'"
    },
    "dest": {
      "index": "'"$1"'-'"$2"'"
      "type": "_doc"
    }
  }'
}

DIR=$(mktemp -d ~/elk_ansible.XXXXXX) || exit 1
fifo=$DIR/tmp_fifo
if [[ ! -e $fifo ]]; then
  mkfifo $fifo
fi

# number of processes to run for reindexing
process_num=4
counter=0

ind=$(curl --silent -X GET "localhost:9200/_cat/indices?v" | grep file | tr -s [:blank:] | cut -d' ' -f3 | cut -d'-' -f2-3)

for i in $ind; do
    #name=$(echo $i | cut -d'-' -f1)
    name=${ind%-*}
    #date=$(echo $i | cut -d'-' -f2)
    date=${ind#*-}

    if [ "$name" = "kong" ]; then
      name=apilogs
    fi

    if [ $counter -lt $process_num ]; then
      { reindex "$name" "$date" ; echo 'done' > tmp_fifo; } &
      let $[counter++]
    else
      read x < tmp_fifo # waiting for a process to finish
      { reindex "$name" "$date"; echo 'done' > tmp_fifo; } &
    fi
done

if [ $counter -gt 0 ]; then
  cat tmp_fifo > /dev/null # let all the background processes end
fi

rm $fifo
