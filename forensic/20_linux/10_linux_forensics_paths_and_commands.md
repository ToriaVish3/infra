# Linux forensics: paths and commands (separate quick file)

Этот файл под задачу: частые папки + команды, где обычно находят следы компрометации, persistence и потенциальные уязвимые места конфигурации.

## 1) Логи (первый приоритет)
- `/var/log/auth.log` (Debian/Ubuntu)
- `/var/log/secure` (RHEL/CentOS)
- `/var/log/syslog`, `/var/log/messages`
- `journalctl` (systemd journal)
- `/var/log/audit/audit.log` (если auditd включен)
- `/var/log/wtmp`, `/var/log/btmp`, `/var/log/lastlog`

Команды:
```bash
sudo journalctl -n 300 --no-pager
sudo journalctl --since "2026-02-11 00:00:00" --until "2026-02-11 23:59:59" --no-pager
sudo grep -Ei "failed|invalid user|accepted|sudo|session" /var/log/auth.log 2>/dev/null | tail -n 200
last -a | head
lastb -a | head
```

## 2) Пользователи и доступ
- `/etc/passwd`, `/etc/shadow`, `/etc/group`, `/etc/sudoers`, `/etc/sudoers.d/`
- Домашние директории: `/home/*`, `/root`

Команды:
```bash
cat /etc/passwd
sudo cat /etc/sudoers
sudo ls -la /etc/sudoers.d/
awk -F: '$3 == 0 {print}' /etc/passwd
sudo chage -l <username>
```

## 3) SSH-артефакты
- `/etc/ssh/sshd_config`
- `~/.ssh/authorized_keys`, `~/.ssh/known_hosts`
- `/root/.ssh/`

Команды:
```bash
sudo grep -Ei "PermitRootLogin|PasswordAuthentication|PubkeyAuthentication" /etc/ssh/sshd_config
sudo find /home /root -type f -name authorized_keys -exec ls -la {} \;
sudo find /home /root -type f -name authorized_keys -exec cat {} \;
```

## 4) Persistence (cron + systemd)
- `/etc/crontab`
- `/etc/cron.d/`, `/etc/cron.daily/`, `/etc/cron.hourly/`, `/var/spool/cron/`
- `/etc/systemd/system/`, `/usr/lib/systemd/system/`

Команды:
```bash
crontab -l
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /var/spool/cron 2>/dev/null
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled
sudo systemctl cat <service_name>
```

## 5) Процессы, сеть, выполнение
Команды:
```bash
ps aux --sort=-%cpu | head -n 30
ps auxf
ss -tulpen
lsof -i -P -n | head -n 50
sudo ls -l /proc/<PID>/exe
sudo tr '\0' ' ' < /proc/<PID>/cmdline; echo
```

## 6) Файловая система и таймстемпы
Часто полезные пути:
- `/tmp`, `/var/tmp`, `/dev/shm`
- `/opt`, `/usr/local/bin`, `/usr/local/sbin`
- web roots: `/var/www/`, `/srv/www/`

Команды:
```bash
sudo find /tmp /var/tmp /dev/shm -xdev -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %p\n' | sort
sudo find / -xdev -type f -mtime -2 2>/dev/null | head -n 200
sudo stat <file>
```

## 7) SUID/SGID/capabilities (часто для privilege escalation)
Команды:
```bash
sudo find / -xdev -perm -4000 -type f 2>/dev/null
sudo find / -xdev -perm -2000 -type f 2>/dev/null
sudo getcap -r / 2>/dev/null
```

## 8) Пакеты и подозрительные установки
- Debian/Ubuntu: `/var/log/apt/history.log`, `/var/log/dpkg.log`
- RHEL-based: `/var/log/yum.log`, `dnf history`

Команды:
```bash
sudo tail -n 200 /var/log/apt/history.log 2>/dev/null
sudo tail -n 200 /var/log/dpkg.log 2>/dev/null
sudo tail -n 200 /var/log/yum.log 2>/dev/null
sudo dnf history 2>/dev/null
```

## 9) Shell history
- `~/.bash_history`, `~/.zsh_history`
- `/root/.bash_history`

Команды:
```bash
for u in /home/* /root; do sudo ls -la "$u"/.bash_history "$u"/.zsh_history 2>/dev/null; done
sudo strings /home/<user>/.bash_history 2>/dev/null | tail -n 200
```

## 10) Быстрые флаг/индикатор-поиски (CTF)
Команды:
```bash
sudo grep -RIn --binary-files=without-match -E "flag\{|ctf\{|THM\{" /home /root /var/www /opt 2>/dev/null | head
sudo find /home /root /var/www /opt -type f \( -name "*.txt" -o -name "*.log" -o -name "*.conf" \) 2>/dev/null | head -n 300
```

## 11) Мини-заметки по "уязвимым местам" в Linux (что часто проверяют)
- Небезопасные sudo rules (`NOPASSWD: ALL`, wildcard abuse)
- SUID на нестандартных бинарях
- Опасные capabilities (`cap_setuid`, `cap_sys_admin`, и т.д.)
- Writeable systemd unit/cron scripts
- Слабый `sshd_config` (root login, password auth без MFA)
- Директории/скрипты в PATH, доступные на запись
