#!/bin/bash

echo -e "Домашний каталог пользователя\n$(whoami)\nСодержит обычных файлов:";
find ~ -maxdepth 1 -type f -not -name ".*" | wc -l;
echo -e "скрытых файлов:";
find ~ -maxdepth 1 -type f -name ".*" | wc -l;