#!/usr/bin/env bash

declare -A dict=(
    [dictionary]="English"
    [ruwiktionary]="Английский"
)

// parts of speech
pos=("noun" "verb" "adj" "adv" "prep")

# Скачать свежие дампы
for key in "${!dict[@]}"; do
  wget -O "${key}-words.jsonl" "https://kaikki.org/$key/${dict[$key]}/words/kaikki.org-dictionary-${dict[$key]}-words.jsonl"
  for part in "${pos[@]}"; do
    wget -O "${key}-${part}.jsonl" "https://kaikki.org/$key/${dict[$key]}/pos-$part/kaikki.org-dictionary-${dict[$key]}-by-pos-${part}.jsonl"
  done
done
