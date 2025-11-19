BINDIR := $(HOME)/.local/bin
CONFIG_DIR := $(HOME)/.config/anki_helper
ENV_FILE := $(CONFIG_DIR)anki_helper.env
PYTHON_LIB_DIR := $(HOME)/.local/lib/kaikki
SHARE_FILES_DIR := $(HOME)/.local/share/anki_helper
SYSTEMD_DIR :=  $(HOME)/.config/systemd/user

# Файлы
SHELL_SCRIPT_TPL := dict_update.sh.tpl
SHELL_SCRIPT := dict_update.sh
SYSTEMD_SERVICE := anki-helper.service
SYSTEMD_SERVICE_TPL := anki-helper.service.tpl
SYSTEMD_TIMER := anki-helper.timer
PYTHON_SCRIPTS := kaikki_fetcher.py kaikki_jsonl_to_csv.py html_converter.py

.PHONY: all install clean restart-systemd config-dir

all:
	@echo "Use 'make install' to install files"

install: $(SHELL_SCRIPT_TPL) $(SYSTEMD_SERVICE_TPL) $(SYSTEMD_TIMER) $(PYTHON_SCRIPTS)
	# Создание файлов из шаблонов
	sed "s|<ENV_FILE>|$(ENV_FILE)|g" $(SHELL_SCRIPT_TPL) > $(SHELL_SCRIPT)
	sed "s|<ENV_FILE>|$(ENV_FILE)|g" $(SYSTEMD_SERVICE_TPL) > $(SYSTEMD_SERVICE)
	# Установка скрипта в bin
	install -m 755 $(SHELL_SCRIPT) $(BINDIR)/$(SHELL_SCRIPT)
	
	# Установка systemd юнитов
	install -m 644 $(SYSTEMD_SERVICE) $(SYSTEMD_DIR)/
	install -m 644 $(SYSTEMD_TIMER) $(SYSTEMD_DIR)/

	# Создание каталога для python скриптов и копирование
	mkdir -p $(PYTHON_LIB_DIR)
	install -m 644 $(PYTHON_SCRIPTS) $(PYTHON_LIB_DIR)/

	$(MAKE) restart-systemd
	$(MAKE) create-env

restart-systemd:
	# Перезагрузка systemd конфигурации и перезапуск сервиса
	systemctl --user daemon-reload
	systemctl --user enable --now anki-helper.timer
	@echo "systemd daemon-reload and timer restart done."

create-env:
	mkdir -p $(CONFIG_DIR)
	echo "ANKI_HELPER_BINDIR=$(BINDIR)" > $(ENV_FILE)
	echo "ANKI_HELPER_PYTHON_LIB_DIR=$(PYTHON_LIB_DIR)" >> $(ENV_FILE)
	echo "ANKI_HELPER_SHARE_FILES_DIR=$(SHARE_FILES_DIR)" >> $(ENV_FILE)

clean:
	@echo "Nothing to clean"

