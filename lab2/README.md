# Лабораторная №2 Управление правами доступа
### Полищук Максим, Б20-505

## Результаты работы

- ``вывод команды ls``
```bash
❯ ls -lR
.:
total 8
drw-rwxr-x 2 tpk  tpk 4096 Oct 31 19:22 dir
-r--r----- 1 root tpk    5 Oct 31 19:21 file
-rw------- 1 tpk  tpk    0 Oct 31 19:30 file1
-rw-rw-rw- 1 tpk  tpk    0 Oct 31 19:31 file2

./dir:
ls: cannot access './dir/new_file': Permission denied
total 0
-????????? ? ? ? ?            ? new_file
```

- порядок действий записан в файле ``history.txt`` или есть запись при помощи утилиты *script* в файле ``script_out``