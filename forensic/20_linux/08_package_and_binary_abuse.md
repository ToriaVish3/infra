# 08 package and binary abuse

## Commands from THM (must-know)
```bash
find / -type f -executable 2> /dev/null
# Поиск исполняемых файлов
strings example.elf
# Извлечение строк из бинаря
sudo debsums -e -s
# Проверка системных пакетов на измененные файлы
find / -perm -u=s -type f 2>/dev/null
# Поиск SUID бинарей
sudo cat /home/jane/.bash_history | grep -B 2 -A 2 "python"
# Поиск подозрительных python-команд в history
/usr/bin/python3.8 -c 'import os; os.execl("/bin/sh", "sh", "-p", "-c", "cp /bin/bash /var/tmp/bash && chown root:root /var/tmp/bash && chmod +s /var/tmp/bash")'
# Пример SUID abuse chain через python (артефакт атаки)
ls -al /var/tmp
# Проверка содержимого /var/tmp
/var/tmp/bash -p
# Запуск SUID bash с сохранением привилегий
md5sum /var/tmp/bash
# MD5 сравнение подмененного bash
md5sum /bin/bash
# MD5 системного bash
sudo chkrootkit
# Быстрый скан rootkit-индикаторов
sudo rkhunter -c -sk
# Расширенный rootkit-скан
```

## Extra forensic commands
```bash
sha256sum /var/tmp/bash /bin/bash
# SHA256 для более надежного сравнения
cmp -l /var/tmp/bash /bin/bash | head
# Побайтное сравнение двух бинарей
getcap -r / 2>/dev/null
# Поиск Linux capabilities
find / -perm -2000 -type f 2>/dev/null
# Поиск SGID бинарей
sudo debsums -s
# Проверка измененных файлов пакетов
sudo dpkg -V 2>/dev/null | head -n 100
# Верификация пакетов через dpkg
sudo rkhunter --update
# Обновление базы rkhunter (только если хост не изолирован)
```

## Abuse indicators
- SUID на `python`, `bash`, нестандартных бинарях в `/tmp`/`/var/tmp`
- world-writable + executable файлы
- расхождение checksum у системных бинарей
