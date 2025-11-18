BINDIR := $(HOME)/.local/bin
SYSTEMD_DIR :=  $(HOME)/.config/systemd/user
PYTHON_LIB_DIR := $(HOME)/.local/lib/kaikki

# Файлы
SHELL_SCRIPT := dict_update.sh
SYSTEMD_SERVICE := anki-helper.timer
SYSTEMD_TIMER := anki-helper.timer
PYTHON_SCRIPTS := kaikki_fetcher.py kaikki_jsonl_to_csv.py html_converter.py

.PHONY: all install clean restart-systemd

all:
	@echo "Use 'make install' to install files"

install: $(SHELL_SCRIPT) $(SYSTEMD_SERVICE) $(SYSTEMD_TIMER) $(PYTHON_SCRIPTS)
	# Установка скрипта в bin
	install -m 755 $(SHELL_SCRIPT) $(BINDIR)/$(SHELL_SCRIPT)
	
	# Установка systemd юнитов
	install -m 644 $(SYSTEMD_SERVICE) $(SYSTEMD_DIR)/
	install -m 644 $(SYSTEMD_TIMER) $(SYSTEMD_DIR)/

	# Создание каталога для python скриптов и копирование
	mkdir -p $(PYTHON_LIB_DIR)
	install -m 644 $(PYTHON_SCRIPTS) $(PYTHON_LIB_DIR)/

	$(MAKE) restart-systemd

restart-systemd:
	# Перезагрузка systemd конфигурации и перезапуск сервиса
	systemctl --user daemon-reload
	systemctl --user enable --now anki-helper.timer
	@echo "systemd daemon-reload and timer restart done."

clean:
	@echo "Nothing to clean"

