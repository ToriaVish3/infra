# Auth, Journal, Audit - с пояснениями

### Команда
```bash
journalctl -u ssh --since '-24h' --no-pager
```
Что делает: выводит ssh-логи за 24 часа.
Параметры: `-u ssh` сервис, `--since` время начала, `--no-pager` без less.

### Команда
```bash
grep -Ei 'failed|invalid user|accepted|sudo' /var/log/auth.log
```
Что делает: фильтрует ключевые auth-события.
Параметры: `-E` расширенный regex, `-i` без регистра.

### Команда
```bash
ausearch -ts recent -m USER_LOGIN,USER_AUTH,CRED_ACQ
```
Что делает: ищет в auditd события входа и аутентификации.
Параметры: `-ts recent` недавнее время, `-m` типы событий.
