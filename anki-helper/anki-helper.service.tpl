[Unit]
Description=Parse kaikki dumps and update anki dictionaries

[Service]
EnvironmentFile=<ENV_FILE>
ExecStart=$ANKI_HELPER_BIN_DIR/dict_update.sh $ANKI_HELPER_SHARE_FILES_DIR/new_words.csv
