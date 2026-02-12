# 06 filesystem timeline ext

## Timestamps used in THM
```bash
ls -lc /var/www/html/assets/reverse.elf
# Показать ctime
ls -lu /var/www/html/assets/reverse.elf
# Показать atime
stat /var/www/html/assets/reverse.elf
# Полный набор метаданных файла
stat /home/jane/.ssh/authorized_keys
# Полный набор метаданных authorized_keys
```

## Build quick timeline
```bash
find /var/www/html -xdev -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %p\n' | sort
# Построить хронологический список файлов web root
find / -xdev -type f -cmin -5 2>/dev/null
# Файлы с изменением ctime за последние 5 минут
find / -type f -newermt '2026-02-12 23:00:00' ! -newermt '2026-02-13 01:00:00' 2>/dev/null | head -n 400
# Файлы, измененные в заданном окне времени
```

## Extra `find` options (forensics)
```bash
find / -xdev -type f -mmin -60 2>/dev/null
# Файлы, измененные за последний час
find / -xdev -type f -amin -60 2>/dev/null
# Файлы, к которым обращались за последний час
find / -xdev -type f -size -20k 2>/dev/null | head
# Небольшие свежие файлы (часто дропперы/скрипты)
find / -xdev -type f \( -iname '*.phtml' -o -iname '*.php' \) 2>/dev/null
# Потенциальные webshell расширения
find / -xdev -type f -user www-data -newermt '2026-02-12 00:00:00' 2>/dev/null
# Файлы пользователя www-data с фильтром по времени
```
