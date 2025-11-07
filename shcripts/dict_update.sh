#!/usr/bin/env bash

declare -A dict=(
    [dictionary]='English'
    [ruwiktionary]='Английский'
)

keys=("${!dict[@]}")
input_file="adjective.csv"

for key in $keys; do
    wget -O "${key}-words.jsonl" "https://kaikki.org/$key/${dict[$key]}/words/kaikki.org-dictionary-${dict[$key]}-words.jsonl"
done

while IFS= read -r line; do
  IFS=';' read -r part1 part2 part3 <<< "$line"
  # Если части пустые, подставим пустые строки
  part1=${part1:-""}
  part2=${part2:-""}
  part3=${part3:-""}

  # Вызываем Python-скрипт с тремя аргументами
  python3 kaikki_jsonl_to_csv.py "${keys[1]}-words.jsonl" "$part1" "$part2" "$part3"
done < "$input_file"
