# 04 auth journal audit

## Core logs
- Debian/Ubuntu: `/var/log/auth.log`
- RHEL/CentOS: `/var/log/secure`
- Systemd journal: `journalctl`
- Optional: `/var/log/audit/audit.log`

## Baseline triage
```bash
sudo journalctl -n 300 --no-pager
# Последние 300 записей journal
sudo grep -Ei "failed|invalid user|accepted|sudo|session" /var/log/auth.log 2>/dev/null | tail -n 200
# Фильтр auth-событий: failed/accepted/sudo/session
last
# История успешных входов
lastlog
# Информация о последнем входе каждого пользователя
who
# Кто сейчас в системе
```

## Extra deep-dive
```bash
sudo journalctl --since "2026-02-11 00:00:00" --until "2026-02-11 23:59:59" --no-pager
# Journal за точное окно времени
sudo journalctl _COMM=sshd --since "-24h" --no-pager
# Только sshd события за 24 часа
sudo grep -RInE "sudo|su:|session opened|session closed" /var/log 2>/dev/null | tail -n 200
# Корреляция sudo/su/session по всем логам
sudo lastb -a | head -n 50
# Неуспешные логины
sudo ausearch -m USER_LOGIN,USER_AUTH,USER_ACCT -ts recent 2>/dev/null
# Auditd события аутентификации (если auditd есть)
```

## Users/groups checks from THM
```bash
cat /etc/passwd
# Пользователи и UID/GID/shell
cat /etc/passwd | cut -d: -f1,3 | grep ':0$'
# Поиск аккаунтов с UID 0
cat /etc/group
# Локальные группы
groups investigator
# Группы конкретного пользователя
getent group adm
# Детали группы adm
getent group 27
# Детали группы по GID
sudo cat /etc/sudoers
# Правила sudo
```
