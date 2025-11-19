#!/usr/bin/env bash
set -euo pipefail

STATUS="${1:-unknown}"
NOTIFY_TITLE="Anki Helper"

# Получаем последние строки из журнала
LOG_OUTPUT=$(journalctl --user -u anki-helper.service -n 5 --no-pager 2>/dev/null || echo "No logs available")

if [[ "$STATUS" == "success" ]]; then
    NOTIFY_BODY="✓ Новые слова успешно добавлены"
    NOTIFY_ICON="dialog-information"
    URGENCY="low"
else
    # При ошибке берем больше информации из журнала
    LOG_OUTPUT=$(journalctl --user -u anki-helper.service -n 20 --no-pager --grep="error\|Error\|ERROR\|failed" 2>/dev/null || echo "Check logs manually")
    NOTIFY_BODY="✗ Ошибка при добавлении слов\n\n${LOG_OUTPUT:0:200}"
    NOTIFY_ICON="dialog-error"
    URGENCY="critical"
    # Отправляем DBus notification (работает с любым DE)
    dbus-send --print-reply --dest=org.freedesktop.Notifications \
        /org/freedesktop/Notifications \
        org.freedesktop.Notifications.Notify \
        string:"$NOTIFY_TITLE" \
        uint32:0 \
        string:"$NOTIFY_ICON" \
        string:"$NOTIFY_TITLE" \
        string:"$NOTIFY_BODY" \
        array:string: \
        dict:string:variant: \
        uint32:5000 \
        2>/dev/null || {
            # Fallback если DBus недоступен - логируем
            echo "[$(date)] [$STATUS] $NOTIFY_BODY" >> "$HOME/.local/share/anki_helper/notifications.log"
    }
fi

# Также логируем в systemd journal
if [[ "$STATUS" == "success" ]]; then
    logger -t anki-helper "Successfully added new words"
else
    logger -t anki-helper -p user.err "Failed to add new words. Last logs: $LOG_OUTPUT"
fi
