#!/usr/bin/env bash

declare -A dict=(
    [dictionary]='English'
    [ruwiktionary]='Английский'
)

keys=("${!dict[@]}")
input_file="adjective.csv"

for key in ${keys[@]}; do
    local_file="${key}-words.jsonl"
    remote_url="https://kaikki.org/$key/${dict[$key]}/words/kaikki.org-dictionary-${dict[$key]}-words.jsonl"
    echo $local_file
    if [ -f $local_file ]; then
        local_date=$(stat -c %y "$local_file" 2>/dev/null || stat -f %Sm "$local_file" 2>/dev/null)
        remote_date=$(curl -sI "$remote_url" | grep -i "last-modified" | cut -d: -f2- | xargs)
        remote_ts=$(date --date="$remote_date" +%s)
        local_ts=$(date --date="$local_date" +%s)

        if [[ $remote_ts > $local_ts ]]; then
            wget -O $local_file $remote_url
        fi
    else
        wget -O $local_file $remote_url
    fi
done

#while IFS= read -r line; do
#  IFS=';' read -r part1 part2 part3 <<< "$line"
#  # Если части пустые, подставим пустые строки
#  part1=${part1:-""}
#  part2=${part2:-""}
#  part3=${part3:-""}
#
#  # Вызываем Python-скрипт с тремя аргументами
#python3 kaikki_jsonl_to_csv.py "${keys[1]}-words.jsonl" "$part1" "$part2" "$part3"
#done < "$input_file"
#
