#!/bin/bash
set -e
# TODO: Добавление русской раскладки
# Установка brave, tomb
# Разбить установку по необходимости (проекты, учеба, работа и т.д.)
#  TZ=UTC gpg --no-options --keyid-format long --verify tails-amd64-7.0.img.sig tails-amd64-7.0.img проверка# сигнатур
# Перееехать в ansible
# Разбить по шагам для удобства дебага в первый раз и добавить тесты

echo "1. Настройка интернета"
# TODO: Сделать парсинг сетей и предпочтительное подключение
nmcli device wifi connect "CYTA_KD45_2.4G-EXT"

echo "2. Установка пакетов"
sudo dnf install -y git kcov make pass python3-pip shellcheck testdisk timeshift xxd

echo "3. Установка python-telegram-bot" для проекта easyTool
# TODO: Не качать лишние пакеты
# Добавить файл, в котором будут записаны все зависимости
pip3 install --user python-telegram-bot[ext] keyring=25.6.0

echo "4. Установка zed редактора"
# Команда установки c помощью скрипта

echo "5. Установка VeraCrypt"
#TODO: Команда скачивания последней версии с проверкой PGP Signature

echo "6. Копирование gpg ключей (файлы должны быть доступны в ./keys)"

echo "7. Копирование git config"

echo "8. Клонирование репозиториев и установка утилит"
# Доделать для всех утилит из исходников
git clone https://github.com/dyne/tomb.git /tmp/tomb
cd /tmp/tomb && make test && make lint && sudo make install
git clone https://github.com/user/pass-update.git ~/pass-update
git clone https://github.com/user/pass-tail-extension.git ~/pass-tail-extension
git clone https://github.com/user/pass-tomb.git ~/pass-tomb

echo "9. Клонирование репозитория"
git clone git@github.com:user/repo.git ~/repo
# Установка pass tomb и копирование исходников

echo "10. Синхронизация Firefox аккаунта — ручная настройка"

echo "11. Скачивание и установка Telegram и Anki (примерно)"
curl -L -o telegram.tar.xz https://telegram.org/dl/desktop/linux
tar -xf telegram.tar.xz -C ~/Applications/

# Аналогично для Anki — скачать и распаковать

echo "12. Настройка Timeshift"

echo "13. Настройка клавиатуры"
# Скачать keymap, скопировать в /usr/local/bin
# Скопировать конфиг в 50-zsa.rules /etc/udev/rules.d
echo "Настройка завершена."
