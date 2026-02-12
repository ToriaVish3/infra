# 03 key artifacts

## High-value Linux artifacts
- Web foothold: `/var/www/html/uploads`, `/var/www/html/assets`
- Auth: `/var/log/auth.log`, `/var/log/secure`, `journalctl`
- Users: `/etc/passwd`, `/etc/group`, `/etc/sudoers`
- Access: `~/.ssh/authorized_keys`, shell history
- Priv-esc: SUID/SGID/capabilities, world-writable paths

## Commands from THM Linux File System Analysis
```bash
ls -al /var/www/html/
# Список файлов в web root
ls -al /var/www/html/uploads
# Содержимое каталога загрузок
ls -al /var/www/html/uploads | grep -v ".jpeg"
# Фильтр: показать не-jpeg файлы в uploads
cat /var/www/html/uploads/b2c8e1f5.phtml
# Просмотр содержимого подозрительного web-shell файла
find / -user www-data -type f 2>/dev/null | less
# Поиск файлов, принадлежащих www-data
ls -l /var/www/html/assets/reverse.elf
# Базовая метаинформация о бинаре
exiftool /var/www/html/assets/reverse.elf
# Метаданные файла (в т.ч. build info)
md5sum /var/www/html/assets/reverse.elf
# Контрольная сумма MD5
sha256sum /var/www/html/assets/reverse.elf
# Контрольная сумма SHA256
ls -lc /var/www/html/assets/reverse.elf
# Показать ctime
ls -lu /var/www/html/assets/reverse.elf
# Показать atime
stat /var/www/html/assets/reverse.elf
# Полная статистика inode/timestamps/permissions
```

## Extra forensic commands
```bash
file /var/www/html/assets/reverse.elf
# Определение типа файла
readelf -h /var/www/html/assets/reverse.elf
# Заголовки ELF
strings -a -n 8 /var/www/html/assets/reverse.elf | head -n 80
# Извлечь строки из бинаря
find /var/www/html -xdev -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %p\n' | sort
# Таймлайн по файлам web root
find /var/www/html -type f \( -name '*.php' -o -name '*.phtml' -o -name '*.phar' \) -print
# Поиск потенциальных web-shell расширений
find /tmp /var/tmp /dev/shm -xdev -type f -mmin -120 -printf '%TY-%Tm-%Td %TH:%TM %u %g %m %p\n' | sort
# Поиск свежих файлов в tmp-путях за 120 минут
```
