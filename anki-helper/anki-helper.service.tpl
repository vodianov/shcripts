[Unit]
Description=Parse kaikki dumps and update anki dictionaries

[Service]
EnvironmentFile=<ENV_FILE>
ExecStart=<BIN_DIR>/dict_update.sh <SHARE_FILES_DIR>/new_words.csv
