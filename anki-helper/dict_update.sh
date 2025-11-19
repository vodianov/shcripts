#!/usr/bin/env bash

set -e
declare -A dict=(
    [dictionary]='English,Russian'
    [ruwiktionary]='Английский'
)

exec_file='kaikki_jsonl_to_csv.py'
input_file='undef_words.csv'
tmp_file='/tmp/undef_words.csv'
output_file='new_words.csv'
downloaded_files=()

for key in "${!dict[@]}"; do
    IFS=',' read -ra values <<< "${dict[$key]}"
    for value in "${values[@]}";do
        local_file="$ANKI_HELPER_SHARE_FILES_DIR/${key}-${value}-words.jsonl"
        downloaded_files+=("$local_file")
        remote_url="https://kaikki.org/$key/$value/words/kaikki.org-dictionary-$value-words.jsonl"
        if [ -f $local_file ]; then
            local_date=$(stat -c %y "$local_file" 2>/dev/null || stat -f %Sm "$local_file" 2>/dev/null)
            remote_date=$(curl -sI "$remote_url" | grep -i "last-modified" | cut -d: -f2- | xargs)
            remote_ts=$(date --date="$remote_date" +%s)
            local_ts=$(date --date="$local_date" +%s)

            if (( $remote_ts > $local_ts )); then
                wget -O $ANKI_HELPER_SHARE_FILES_DIR/$local_file $remote_url
                echo "downloading $local_file ..."
            else
                echo "$local_file already up to date."
            fi
        else
            wget -O $ANKI_HELPER_SHARE_FILES_DIR/$local_file $remote_url
            echo "downloading $local_file ..."
        fi
    done
done

cp $ANKI_HELPER_SHARE_FILES_DIR/$input_file $tmp_file

while IFS= read -r line; do
  IFS=';' read -r word pos translation <<< "$line"
  pos=${pos:-""}
  translation=${translation:-""}

  echo "Check $word"
  if ! grep -q "^${word};" $ANKI_HELPER_SHARE_FILES_DIR/$output_file; then
      echo "Adding $word ..."
      lang=1
      if [[ $word =~ ^[[:alpha:]]+$ ]]; then
        if [[ $word =~ ^[а-яА-ЯёЁ]+$ ]]; then
            lang=2
        fi
      fi

      cmd="python3 \
            $ANKI_HELPER_PYTHON_LIB_DIR/$exec_file \
            --json-file '$ANKI_HELPER_SHARE_FILES_DIR/${downloaded_files[$lang]}' \
            --word '$word' \
            --csv-file $ANKI_HELPER_SHARE_FILES_DIR/$output_file"
      if (($lang == 1)); then
        cmd+=" --json-file2 '$ANKI_HELPER_SHARE_FILES_DIR/${downloaded_files[0]}'" 
        cmd+=" --language ru" 
      fi
      [ -n "$pos" ] && cmd+=" --pos '$pos'"
      [ -n "$translation" ] && cmd+=" --translation '$translation'"

      eval "$cmd"
      if [ $? -eq 0 ]; then
          sed -i "/^$word;/d" $ANKI_HELPER_SHARE_FILES_DIR/$input_file
      fi
  fi
done < $tmp_file
