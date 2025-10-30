#!/usr/bin/env bash

declare -A dict=(
    [dictionary]='English'
    [ruwiktionary]='Английский'
)

db_dir="$HOME/.local/share/Anki2/addons21/2087444887/user_files/dictionaries"
# parts of speech
pos=("noun" "verb" "adj" "adv" "prep")

for key in "${!dict[@]}"; do
  wget -O "${key}-words.jsonl" "https://kaikki.org/$key/${dict[$key]}/words/kaikki.org-dictionary-${dict[$key]}-words.jsonl"
  kaikki_to_sqlite.py "${key}-words.jsonl" "${key}-words" $db_dir
  for part in "${pos[@]}"; do
    wget -O "${key}-${part}.jsonl" "https://kaikki.org/$key/${dict[$key]}/pos-$part/kaikki.org-dictionary-${dict[$key]}-by-pos-${part}.jsonl"
    kaikki_to_sqlite.py "${key}-${part}.jsonl" "${key}-${part}" $db_dir
  done
done
