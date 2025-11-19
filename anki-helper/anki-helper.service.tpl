[Unit]
Description=Parse kaikki dumps and update anki dictionaries

[Service]
EnvironmentFile=<ENV_FILE>
ExecStart=<SHELL_SCRIPT> <SHARE_FILES_DIR>/new_words.csv
