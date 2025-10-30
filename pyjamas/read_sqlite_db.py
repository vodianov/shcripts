#!/usr/bin/env python3

import sqlite3
import json
import sys

def print_db_content(db_path):
    # Подключение к базе данных
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Получение списка таблиц
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()

    if not tables:
        print("Таблицы в базе данных не найдены.")
        return

    # Для каждой таблицы выводим данные
    for (table_name,) in tables:
        print(f"\nТаблица: {table_name}")
        cursor.execute(f"SELECT * FROM {table_name}")
        rows = cursor.fetchall()
        columns = [desc[0] for desc in cursor.description]

        if not rows:
            print("  Пустая таблица.")
            continue

        for row in rows:
            record = dict(zip(columns, row))
            print(json.dumps(record, ensure_ascii=False, indent=2))

    # Закрываем соединение
    conn.close()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Использование: python script.py путь_к_базе_данных")
        sys.exit(1)

    db_path = sys.argv[1]
    print_db_content(db_path)

