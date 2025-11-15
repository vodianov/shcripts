#!/usr/bin/env bash
set -e

# Подгружаем функцию mkcd из файла
source .env

function test_mkcd_creates_and_enters() {
    rm -rf testdir
    mkcd testdir
    [[ "$(basename "$PWD")" == "testdir" ]] && echo "PASS: Создание и вход" || { echo "FAIL: Создание и вход"; exit 1; }
    cd ..
    rm -rf testdir
}

function test_mkcd_existing_directory() {
    mkdir -p existingdir
    mkcd existingdir
    [[ "$(basename "$PWD")" == "existingdir" ]] && echo "PASS: Существующая директория" || { echo "FAIL: Существующая директория"; exit 1; }
    cd ..
    rm -rf existingdir
}

function test_mkcd_nested_directory() {
    rm -rf nested/dir
    mkcd nested/dir
    [[ "$(basename "$PWD")" == "dir" ]] && echo "PASS: Вложенная директория" || { echo "FAIL: Вложенная директория"; exit 1; }
    cd ../..
    rm -rf nested
}

test_mkcd_creates_and_enters
test_mkcd_existing_directory
test_mkcd_nested_directory

echo "Все тесты пройдены."

