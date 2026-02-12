#!/usr/bin/env bash
set -euo pipefail

# Показывает UTC-время для привязки таймлайна
date -u
# Показывает состояние времени и таймзону
timedatectl || true
# Показывает имя хоста
hostname
# Показывает ОС и версию
cat /etc/os-release

# Текущие пользователи в системе
who
# Пользователи + активные команды
w
# Успешные входы
last -a | head -n 50
# Неуспешные входы
lastb -a | head -n 50 || true

# Топ процессов по CPU
ps aux --sort=-%cpu | head -n 40
# Дерево процессов с PID и аргументами
pstree -ap | head -n 120

# Сокеты и порты
ss -tulpen
# Установленные TCP-соединения
ss -tpn

# Cron текущего пользователя
crontab -l || true
# Системные cron-каталоги
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /var/spool/cron 2>/dev/null || true

# Все systemd timers
systemctl list-timers --all
# Включенные сервисы
systemctl list-unit-files --type=service | grep enabled || true

# Последние записи журнала
sudo journalctl -n 300 --no-pager
# Фильтр auth событий (Debian/Kali)
sudo grep -Ei 'failed|invalid user|accepted|sudo|session' /var/log/auth.log 2>/dev/null | tail -n 300 || true

# Подозрительные новые файлы во временных папках
sudo find /tmp /var/tmp /dev/shm -type f -mmin -360 2>/dev/null | head -n 200
# SUID-файлы
sudo find / -xdev -perm -4000 -type f 2>/dev/null | head -n 200
# Capabilities у файлов
sudo getcap -r / 2>/dev/null | head -n 200
