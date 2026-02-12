# Linux Forensics Commands and Options (Kali/Ubuntu/Debian/RHEL)

Этот файл - практическая шпаргалка: команды, частые опции и что они делают.
Фокус: CTF/IR/forensics без разрушения артефактов.

## 1) Базовая навигация и список файлов

### `pwd`
Показывает текущую директорию.

### `ls`
- `ls -a` - показать скрытые файлы (`.` и `..` тоже).
- `ls -l` - длинный формат (права, владелец, размер, время).
- `ls -la` - длинный формат + скрытые файлы.
- `ls -lh` - размер в удобном виде (`K`, `M`, `G`).
- `ls -lt` - сортировка по времени изменения (новые выше).
- `ls -ltr` - сортировка по времени, старые выше.
- `ls -lc` - показывать `ctime` (время изменения метаданных).
- `ls -lu` - показывать `atime` (время последнего доступа).
- `ls -R` - рекурсивно по подпапкам.
- `ls -i` - показать inode.

Примеры:
```bash
ls -la /etc
ls -lct /var/log
ls -lu /home/kali
```

### `tree`
Показывает древовидную структуру.
- `tree -a` - со скрытыми файлами.
- `tree -L 2` - глубина 2.

## 2) Поиск файлов (`find`) - ключевая команда форензики

### Синтаксис
```bash
find <path> <условия> <действие>
```

### Частые условия
- `-type f` - только файлы.
- `-type d` - только директории.
- `-name "*.log"` - имя (регистрозависимо).
- `-iname "*.LOG"` - имя (без учета регистра).
- `-user bob` - владелец `bob`.
- `-group adm` - группа `adm`.
- `-perm 644` - точные права.
- `-perm -4000` - есть SUID бит.
- `-perm -2000` - есть SGID бит.
- `-mtime -1` - изменено за последние сутки.
- `-mmin -60` - изменено за последние 60 минут.
- `-atime -1` - доступ за последние сутки.
- `-ctime -1` - менялись метаданные за сутки.
- `-newermt "2026-02-11 10:00:00"` - новее указанного времени.
- `-size +10M` - размер больше 10 MB.
- `-xdev` - не уходить на другие файловые системы.
- `-maxdepth 2` - ограничить глубину.
- `-mindepth 1` - пропустить верхний уровень.

### Частые действия
- `-print` - вывести путь (по умолчанию).
- `-ls` - вывести с подробностями.
- `-exec cat {} \;` - выполнить команду для каждого файла.
- `-exec ls -la {} \;` - подробный листинг для каждого файла.
- `-delete` - удалить (в форензике почти всегда избегать).

### Практические примеры
```bash
# Файлы пользователя bob за последнюю минуту
find / -type f -user bob -mmin -1 2>/dev/null

# Сразу посмотреть содержимое найденных файлов
find / -type f -user bob -mmin -1 2>/dev/null -exec cat {} \;

# Поиск SUID/SGID
find / -xdev -perm -4000 -type f 2>/dev/null
find / -xdev -perm -2000 -type f 2>/dev/null

# Подозрительное в temp
find /tmp /var/tmp /dev/shm -type f -mmin -180 2>/dev/null

# Поиск вероятных флагов
find /home /root /opt /var/www -type f \( -name "*.txt" -o -name "*.log" -o -name "*.conf" \) 2>/dev/null
```

## 3) Чтение и фильтрация текста

### `cat`, `less`, `head`, `tail`
- `cat file` - вывести весь файл.
- `less file` - просмотр постранично.
- `head -n 50 file` - первые 50 строк.
- `tail -n 50 file` - последние 50 строк.
- `tail -f file` - следить за обновлением.

### `grep`
- `grep "text" file` - обычный поиск.
- `grep -i` - без учета регистра.
- `grep -n` - показать номер строки.
- `grep -R` - рекурсивно.
- `grep -E` - расширенные regex.
- `grep -v` - исключить совпадения.
- `grep -A 3 -B 3` - контекст до/после.

Примеры:
```bash
grep -RinE "flag\{|THM\{" /home /root 2>/dev/null
grep -Ei "failed|invalid user|accepted|sudo" /var/log/auth.log
```

### `awk`, `cut`, `sort`, `uniq`, `wc`
```bash
awk -F: '{print $1,$3,$7}' /etc/passwd
cut -d: -f1 /etc/passwd
sort file.txt | uniq -c
wc -l /var/log/auth.log
```

## 4) Логи и аутентификация

### Пути
- `/var/log/auth.log` (Debian/Ubuntu/Kali)
- `/var/log/secure` (RHEL/CentOS)
- `/var/log/syslog`, `/var/log/messages`
- `/var/log/audit/audit.log`

### Команды
```bash
journalctl -n 300 --no-pager
journalctl --since "2026-02-11 00:00:00" --until "2026-02-11 23:59:59" --no-pager
journalctl -u ssh --since "-2h" --no-pager
last -a | head
lastb -a | head
who
w
```

## 5) Процессы и сеть

### Процессы
```bash
ps aux --sort=-%cpu | head -n 30
ps auxf
pgrep -a ssh
pstree -ap
```

### Сеть
```bash
ss -tulpen
ss -tpn
lsof -i -P -n | head -n 100
ip a
ip r
arp -an
```

Что означают опции `ss -tulpen`:
- `-t` TCP
- `-u` UDP
- `-l` listening sockets
- `-p` process using socket
- `-e` extended info
- `-n` не резолвить имена

## 6) Пользователи, группы, права

```bash
id
id username
groups username
getent passwd username
getent group 46
cat /etc/passwd
cat /etc/group
```

Проверка root-эквивалентов:
```bash
awk -F: '$3 == 0 {print}' /etc/passwd
```

## 7) SSH и persistence

Пути:
- `/etc/ssh/sshd_config`
- `~/.ssh/authorized_keys`
- `/root/.ssh/authorized_keys`

Команды:
```bash
grep -Ei "PermitRootLogin|PasswordAuthentication|PubkeyAuthentication" /etc/ssh/sshd_config
find /home /root -type f -name authorized_keys -exec ls -la {} \; 2>/dev/null
```

Планировщики:
```bash
crontab -l
ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /var/spool/cron 2>/dev/null
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled
```

## 8) Файловая система и таймстемпы

### `stat`
Показывает inode, права, UID/GID, atime/mtime/ctime.
```bash
stat /etc/passwd
```

### Быстрый таймлайн через `find`
```bash
find /home -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %p\n' | sort
```

## 9) Бинарники и строки

```bash
file suspicious.bin
strings suspicious.bin | head -n 100
xxd suspicious.bin | head
sha256sum suspicious.bin
md5sum suspicious.bin
```

## 10) Пакеты и установки

```bash
tail -n 200 /var/log/apt/history.log 2>/dev/null
tail -n 200 /var/log/dpkg.log 2>/dev/null
tail -n 200 /var/log/yum.log 2>/dev/null
dnf history 2>/dev/null
```

## 11) Часто полезные forensic-папки

- `/tmp`, `/var/tmp`, `/dev/shm`
- `/home/*`, `/root`
- `/var/log/`
- `/etc/cron*`, `/var/spool/cron`
- `/etc/systemd/system`, `/usr/lib/systemd/system`
- `/etc/ssh/`, `~/.ssh/`
- `/opt`, `/usr/local/bin`, `/usr/local/sbin`
- `/var/www`, `/srv/www`

## 12) Важное замечание

Для форензики старайся:
1. Сначала собирать и читать артефакты.
2. Не выполнять команды, которые меняют систему (`rm`, `chmod`, `chown`, `systemctl restart`, и т.д.), если это не требуется условием.
3. Логировать свои действия в отдельный файл:
```bash
script -a investigator_session.log
```
