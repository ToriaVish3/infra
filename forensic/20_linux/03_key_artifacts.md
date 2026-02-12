# Ключевые Linux Артефакты

## Auth
### Команда
```bash
grep -Ei 'failed|invalid user|accepted|sudo|session' /var/log/auth.log
```
Что делает: ищет попытки входа, успехи и sudo-сессии.
Параметры: `-E` regex, `-i` без учета регистра.

## SSH
### Команда
```bash
grep -Ei 'PermitRootLogin|PasswordAuthentication|PubkeyAuthentication' /etc/ssh/sshd_config
```
Что делает: проверяет критичные настройки SSH.
Параметры: `-E` шаблоны через `|`, `-i` без регистра.

## Cron
### Команда
```bash
ls -la /etc/cron.d /etc/cron.daily /var/spool/cron
```
Что делает: показывает scheduled task-поверхность.
Параметры: `-l` длинный формат, `-a` скрытые файлы.

## PrivEsc
### Команда
```bash
find / -xdev -perm -4000 -type f 2>/dev/null
```
Что делает: ищет SUID-файлы.
Параметры: `-xdev`, `-perm -4000`, `-type f`.
