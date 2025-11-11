#!/usr/bin/env bash

set -e
declare -A dict=(
    [dictionary]='English'
    [ruwiktionary]='Английский'
)

keys=("${!dict[@]}")
exec_file='kaikki_jsonl_to_csv.py'
input_file='undef_words.csv'
tmp_file='/tmp/undef_words.csv'
output_file='new_words.csv'

for key in ${keys[@]}; do
    local_file="${key}-words.jsonl"
    remote_url="https://kaikki.org/$key/${dict[$key]}/words/kaikki.org-dictionary-${dict[$key]}-words.jsonl"
    if [ -f $local_file ]; then
        local_date=$(stat -c %y "$local_file" 2>/dev/null || stat -f %Sm "$local_file" 2>/dev/null)
        remote_date=$(curl -sI "$remote_url" | grep -i "last-modified" | cut -d: -f2- | xargs)
        remote_ts=$(date --date="$remote_date" +%s)
        local_ts=$(date --date="$local_date" +%s)

        if [[ $remote_ts > $local_ts ]]; then
            wget -O $local_file $remote_url
            echo "updating $local_file ..."
        else
            echo "$local_file already update."
        fi
    else
        wget -O $local_file $remote_url
        echo "updating $local_file ..."
    fi
done

cp $input_file $tmp_file

while IFS= read -r line; do
  IFS=';' read -r word pos translation <<< "$line"
  # Если части пустые, подставим пустые строки
  pos=${pos:-""}
  translation=${translation:-""}

  echo "Adding $word ..."
  cmd="python3 \
        $exec_file \
        --json-file \"${keys[1]}-words.jsonl\" \
        --json-file2 \"${keys[0]}-words.jsonl\" \
        --word \"$word\" \
        --translation \"$translation\" \
        --csv-file $output_file"
  [ -n "$pos" ] && cmd+=" --pos \"$pos\""
  [ -n "$translation" ] && cmd+=" --translation \"$translation\""

  eval "$cmd"
  if [ $? -eq 0 ]; then
      sed -i "/^$word;/d" $input_file
  fi
done < $tmp_file
