# Linux forensics: paths and commands (separate quick file)

Этот файл содержит:
- полный набор команд из TryHackMe `linuxfilesystemanalysis`
- расширенный набор команд для CTF/IR Linux форензики

## 0) Secure investigation environment (THM)
```bash
export PATH=/mnt/usb/bin:/mnt/usb/sbin
# Подменить PATH на trusted toolkit на USB
export LD_LIBRARY_PATH=/mnt/usb/lib:/mnt/usb/lib64
# Подменить library path на trusted libs
check-env
# Проверка forensic environment
```

## 1) Web foothold and suspicious uploads (THM)
```bash
ls -al /var/www/html/
# Просмотр web root
ls -al /var/www/html/uploads
# Просмотр каталога загрузок
ls -al /var/www/html/uploads | grep -v ".jpeg"
# Найти нетипичные файлы в uploads
cat /var/www/html/uploads/b2c8e1f5.phtml
# Прочитать подозрительный phtml
find / -user www-data -type f 2>/dev/null | less
# Найти все файлы пользователя www-data
ls -l /var/www/html/assets/reverse.elf
# Проверить атрибуты подозрительного бинаря
```

## 2) `find` patterns shown in THM
```bash
find / -group GROUPNAME 2>/dev/null
# Поиск файлов/директорий по группе
find / -perm -o+w 2>/dev/null
# Поиск world-writable объектов
find / -type f -cmin -5 2>/dev/null
# Поиск файлов с ctime за последние 5 минут
find / -type f -executable 2> /dev/null
# Поиск исполняемых файлов
find / -perm -u=s -type f 2>/dev/null
# Поиск SUID файлов
```

## 3) Metadata and integrity (THM)
```bash
exiftool /var/www/html/assets/reverse.elf
# Метаданные через exiftool
md5sum /var/www/html/assets/reverse.elf
# MD5 checksum
sha256sum /var/www/html/assets/reverse.elf
# SHA256 checksum
ls -lc /var/www/html/assets/reverse.elf
# Показать ctime
ls -lu /var/www/html/assets/reverse.elf
# Показать atime
stat /var/www/html/assets/reverse.elf
# Полный stat
```

## 4) Users, groups, sudo, login activity (THM)
```bash
cat /etc/passwd
# Список пользователей
cat /etc/passwd | cut -d: -f1,3 | grep ':0$'
# Найти UID 0 аккаунты
cat /etc/group
# Список групп
groups investigator
# Проверить группы пользователя investigator
getent group adm
# Получить данные группы adm
getent group 27
# Получить данные группы с GID 27
last
# История логинов
lastlog
# Последний логин каждого пользователя
who
# Текущие сессии
sudo cat /etc/sudoers
# Правила sudo
```

## 5) Home directory and SSH artefacts (THM)
```bash
ls -l /home
# Просмотреть домашние каталоги
ls -a /home/jane
# Показать скрытые файлы в home пользователя
ls -al /home/jane/.ssh
# Проверить .ssh
cat /home/jane/.ssh/authorized_keys
# Прочитать authorized_keys
stat /home/jane/.ssh/authorized_keys
# Получить метаданные authorized_keys
ls -al /home/jane/.ssh/authorized_keys
# Проверить права authorized_keys
```

## 6) Binary abuse / rootkits (THM)
```bash
strings example.elf
# Извлечь строки из подозрительного бинаря
sudo debsums -e -s
# Найти измененные файлы пакетов
sudo cat /home/jane/.bash_history | grep -B 2 -A 2 "python"
# Найти исполнение python в истории команд
/usr/bin/python3.8 -c 'import os; os.execl("/bin/sh", "sh", "-p", "-c", "cp /bin/bash /var/tmp/bash && chown root:root /var/tmp/bash && chmod +s /var/tmp/bash")'
# Пример цепочки повышения привилегий через SUID python
ls -al /var/tmp
# Проверить /var/tmp на новые бинари
/var/tmp/bash -p
# Запуск SUID-бинаря bash
md5sum /var/tmp/bash
# Сравнение контрольной суммы подмененного bash
md5sum /bin/bash
# Контрольная сумма оригинального bash
sudo chkrootkit
# Сканер rootkit индикаторов
sudo rkhunter -c -sk
# Глубже rootkit-проверка
```

## 7) Extended Linux forensic commands (added)

### 7.1 Logs and auth
```bash
sudo journalctl -n 300 --no-pager
# Последние записи журнала
sudo journalctl --since "2026-02-11 00:00:00" --until "2026-02-11 23:59:59" --no-pager
# Журнал за конкретный период
sudo journalctl _COMM=sshd --since "-24h" --no-pager
# Только sshd за 24 часа
sudo grep -Ei "failed|invalid user|accepted|sudo|session" /var/log/auth.log 2>/dev/null | tail -n 200
# Выжимка auth событий
sudo lastb -a | head -n 50
# Неуспешные входы
sudo ausearch -m USER_LOGIN,USER_AUTH,USER_ACCT -ts recent 2>/dev/null
# Audit логины/аутентификация
```

### 7.2 Advanced `find` for timelines and pivots
```bash
find / -xdev -type f -mmin -60 2>/dev/null
# Файлы, измененные за 60 минут
find / -xdev -type f -amin -60 2>/dev/null
# Файлы, к которым обращались за 60 минут
find / -xdev -type f -ctime -1 2>/dev/null
# Файлы с ctime за последние сутки
find / -xdev -type f -size -50k -mmin -120 2>/dev/null | head -n 300
# Небольшие свежие файлы (часто дропперы)
find / -xdev -type f \( -iname '*.php' -o -iname '*.phtml' -o -iname '*.phar' \) 2>/dev/null
# Поиск webshell-подобных расширений
find /tmp /var/tmp /dev/shm -xdev -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %p\n' | sort
# Таймлайн файлов в tmp-путях
find / -xdev -type f -newermt '2026-02-12 23:00:00' ! -newermt '2026-02-13 01:00:00' 2>/dev/null
# Файлы за конкретное окно времени
```

### 7.3 Processes, network, execution
```bash
ps aux --sort=-%cpu | head -n 30
# Топ процессов по CPU
ps auxf
# Дерево процессов
ss -tulpen
# Слушающие/активные сокеты
lsof -i -P -n | head -n 100
# Сетевые файлы процессов
sudo ls -l /proc/<PID>/exe
# Путь к исполняемому файлу процесса
sudo tr '\0' ' ' < /proc/<PID>/cmdline; echo
# Полная командная строка процесса
```

### 7.4 Persistence
```bash
crontab -l
# Cron текущего пользователя
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /var/spool/cron 2>/dev/null
# Системные cron директории
systemctl list-timers --all
# Таймеры systemd
systemctl list-unit-files --type=service | grep enabled
# Включенные сервисы
sudo find /etc/systemd/system /usr/lib/systemd/system -type f -name '*.service' -mtime -7 -print
# Измененные service-файлы за 7 дней
```

### 7.5 SUID/SGID/capabilities/package integrity
```bash
find / -perm -u=s -type f 2>/dev/null
# Поиск SUID
find / -perm -2000 -type f 2>/dev/null
# Поиск SGID
getcap -r / 2>/dev/null
# Поиск capabilities
sudo debsums -s
# Проверка целостности пакетов debsums
sudo dpkg -V 2>/dev/null | head -n 100
# Проверка целостности пакетов dpkg
sha256sum /var/tmp/bash /bin/bash
# SHA256 сравнение подозрительного и системного bash
cmp -l /var/tmp/bash /bin/bash | head
# Побайтное сравнение бинарей
```

## 8) Practical CTF answer workflow
1. Найди initial foothold (`uploads`, web shell, exec-бинарь).
2. Подтверди escalation через SUID/history/checksum.
3. Подтверди persistence (SSH key, cron/systemd, sudoers).
4. Сведи все во `findings` + `timeline` CSV.
5. Проверяй ответ минимум двумя независимыми артефактами.
