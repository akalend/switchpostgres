#!/usr/bin/env bash

if [ -z "$1"]; then
    ls -ld /usr/local/pgsql*    
    exit 0
fi

# Проверка: передан ли аргумент
if [ $# -ne 1 ]; then
    echo "Ошибка: требуется один аргумент (16, 17 или 18)."
    echo "Использование: $0 {16|17|18}"
    exit 1
fi

VERSION="$1"
# Допустимые версии
if [[ ! "$VERSION" =~ ^(16|17|18|list)$ ]]; then
    echo "Ошибка: аргумент должен быть 16, 17 или 18 (получено: $VERSION)."
    exit 1
fi

TARGET="/usr/local/pgsql.$VERSION"
LINK="/usr/local/pgsql"


if [[ $EUID -ne 0 ]]; then
    echo "Пожалуйста, запустите скрипт с sudo: sudo $0 $*"
    exit 1
fi

# Проверка существования целевой директории
if [ ! -d "$TARGET" ]; then
    echo "Ошибка: целевая директория $TARGET не существует."
    exit 1
fi

# Создание символической ссылки (перезапишет существующую)
ln -sfn "$TARGET" "$LINK"

# Проверка успешности операции
if [ $? -eq 0 ]; then
    echo "Символическая ссылка создана: $LINK -> $TARGET"
else
    echo "Ошибка при создании символической ссылки."
    exit 1
fi

ls -ld /usr/local/pgsql*
