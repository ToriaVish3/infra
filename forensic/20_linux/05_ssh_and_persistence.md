# SSH и Persistence - команды с расшифровкой

### Команда
```bash
find /home /root -type f -name authorized_keys -exec ls -la {} \; 2>/dev/null
```
Что делает: находит все `authorized_keys` и показывает их метаданные.
Параметры: `-type f` файлы, `-name` имя, `-exec ... \;` команда на каждый файл.

### Команда
```bash
crontab -l
```
Что делает: показывает cron текущего пользователя.
Параметры: `-l` list.

### Команда
```bash
systemctl list-timers --all
```
Что делает: показывает все таймеры systemd.
Параметры: `--all` включая неактивные.

### Команда
```bash
grep -RinE 'curl|wget|bash -c|python -c|/tmp/' /etc/cron* /etc/systemd/system 2>/dev/null
```
Что делает: ищет подозрительные команды в cron/systemd.
Параметры: `-R` рекурсивно, `-n` номер строки, `-E` regex.
