#!/usr/bin/env python3
"""
Скрипт для преобразования JSONL дампов kaikki.org в SQLite БД для Anki Wiktionary аддона.
Основано на изучении аддона abdnh/anki-wiktionary v1.2.0+

Структура БД точно соответствует формату, используемому аддоном.
"""

import sqlite3
import json
import sys
import os
from pathlib import Path
from typing import Dict, Any


def create_kaikki_database(db_path: str) -> sqlite3.Connection:
    """
    Создает SQLite БД со схемой, используемой аддоном Wiktionary.

    Схема основана на анализе версии 1.2.0+, где словари хранятся как SQLite БД
    для решения проблем с недопустимыми символами в именах файлов.

    Args:
        db_path: путь к файлу БД

    Returns:
        соединение с БД
    """
    conn = sqlite3.connect(db_path)
    conn.execute("PRAGMA journal_mode=WAL")
    conn.execute("PRAGMA synchronous=NORMAL")

    cursor = conn.cursor()

    # Основная таблица словаря
    # word - само слово
    # data - полный JSON объект записи
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS words (
            word TEXT NOT NULL,
            data TEXT NOT NULL,
            PRIMARY KEY (word, data)
        ) WITHOUT ROWID
    """)

    conn.commit()
    return conn


def import_kaikki_jsonl(jsonl_path: str, db_path: str, language: str) -> None:
    """
    Импортирует JSONL дамп от kaikki.org в SQLite БД.

    Args:
        jsonl_path: путь к JSONL файлу
        db_path: путь к выходной БД
        language: название языка
    """
    # Удаляем старую БД если существует
    if os.path.exists(db_path):
        os.remove(db_path)
        print(f"✓ Удалена старая БД")

    # Создаем БД
    print(f"\n📦 Создание БД для {language}...")
    conn = create_kaikki_database(db_path)
    cursor = conn.cursor()

    # Статистика
    total = 0
    skipped = 0
    batch_size = 5000
    batch = []

    print(f"📥 Импорт из {jsonl_path}...\n")

    try:
        with open(jsonl_path, "r", encoding="utf-8") as f:
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                if not line:
                    continue

                try:
                    entry = json.loads(line)

                    # Извлекаем поля
                    word = entry.get("word", "").strip()

                    if not word:
                        skipped += 1
                        continue

                    # Сохраняем entry как JSON строку
                    entry_json = json.dumps(
                        entry, ensure_ascii=False, separators=(",", ":")
                    )

                    batch.append((word, entry_json))

                    # Вставляем батчами для производительности
                    if len(batch) >= batch_size:
                        cursor.executemany(
                            "INSERT OR REPLACE INTO words (word, data) VALUES (?, ?)",
                            batch,
                        )
                        conn.commit()
                        total += len(batch)
                        print(f"   ⚙ Импортировано {total:,} записей...")
                        batch = []

                except json.JSONDecodeError as e:
                    print(f"   ⚠ JSON ошибка на строке {line_num}: {e}")
                    skipped += 1
                except Exception as e:
                    print(f"   ⚠ Ошибка на строке {line_num}: {e}")
                    skipped += 1

            # Вставляем остаток
            if batch:
                cursor.executemany(
                    "INSERT OR REPLACE INTO words (word, data) VALUES (?, ?)",
                    batch,
                )
                conn.commit()
                total += len(batch)
                print(f"   ⚙ Импортировано {total:,} записей...")

        # Оптимизация
        print("\n🔧 Оптимизация БД...")
        conn.execute("VACUUM")
        conn.execute("ANALYZE")
        conn.commit()

        # Итоговая статистика
        db_size_mb = os.path.getsize(db_path) / (1024 * 1024)

        print(f"\n{'=' * 60}")
        print(f"✅ Импорт завершен!")
        print(f"{'=' * 60}")
        print(f"   Язык:           {language}")
        print(f"   Импортировано:  {total:,} записей")
        print(f"   Пропущено:      {skipped:,}")
        print(f"   Размер БД:      {db_size_mb:.2f} МБ")
        print(f"   Путь к БД:      {db_path}")
        print(f"{'=' * 60}\n")

    except FileNotFoundError:
        print(f"❌ Файл не найден: {jsonl_path}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Критическая ошибка: {e}")
        import traceback

        traceback.print_exc()
        sys.exit(1)
    finally:
        conn.close()


def main():
    if len(sys.argv) < 3:
        print("=" * 60)
        print("Конвертер Kaikki JSONL → SQLite для Anki Wiktionary")
        print("=" * 60)
        print("\nИспользование:")
        print("  python kaikki_to_sqlite.py <jsonl_file> <language> [output_dir]")
        print("\nПримеры:")
        print("  python kaikki_to_sqlite.py kaikki.org-dictionary-Russian.json Russian")
        print("  python kaikki_to_sqlite.py english.json English ./dicts/")
        print("\nПараметры:")
        print("  jsonl_file  - путь к JSONL файлу от kaikki.org")
        print("  language    - название языка (English, Russian, German...)")
        print("  output_dir  - (опционально) директория для БД")
        print("=" * 60)
        sys.exit(1)

    jsonl_file = sys.argv[1]
    language = sys.argv[2]

    # Определяем выходную директорию
    if len(sys.argv) >= 4:
        output_dir = sys.argv[3]
    else:
        output_dir = "."

    # Создаем директорию если не существует
    os.makedirs(output_dir, exist_ok=True)

    # Формируем путь к БД
    db_file = os.path.join(output_dir, f"{language}.db")

    # Импортируем
    import_kaikki_jsonl(jsonl_file, db_file, language)


if __name__ == "__main__":
    main()
