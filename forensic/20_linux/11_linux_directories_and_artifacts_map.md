# Linux directories and artifacts map

Короткая карта: где обычно что хранится и что проверять в форензике.

## 1) `/var/`
Обычно: изменяемые данные сервисов, логи, кэши, очереди, runtime-данные.

### Важные подпути
- `/var/log/` - системные и сервисные логи.
- `/var/tmp/` - временные файлы (живут дольше, чем в `/tmp`).
- `/var/spool/` - очереди задач (в т.ч. cron/mail/print).
- `/var/lib/` - состояние приложений/БД/пакетов.
- `/var/www/` - web-контент (если веб-сервер).

### Что смотреть
- Подозрительные новые файлы в `/var/tmp/`, `/var/www/`, `/var/spool/cron`.
- Аномальные логи входа/ошибок/эскалации.

## 2) `/var/www/`
Обычно: сайты, upload-директории, статические файлы, web-shell артефакты.

### Часто полезные пути
- `/var/www/html/`
- `/var/www/html/uploads/`
- `/var/www/html/assets/`

### Что смотреть
- `*.php`, `*.phtml`, `*.phar`, неожиданные бинарники, обфусцированные скрипты.
- Связь web-файлов с пользователями `www-data`, `apache`, `nginx`.

## 3) `/var/log/`
Обычно: ключевой источник таймлайна и подтверждений.

### Ключевые файлы
- `/var/log/auth.log` (Debian/Ubuntu)
- `/var/log/secure` (RHEL/CentOS)
- `/var/log/syslog`, `/var/log/messages`
- `/var/log/audit/audit.log`
- `/var/log/wtmp`, `/var/log/btmp`, `/var/log/lastlog`
- `/var/log/apache2/`, `/var/log/nginx/`

## 4) `/home/` и `/root/`
Обычно: пользовательские артефакты, history, SSH-ключи, локальные скрипты.

### Часто важные файлы
- `/home/<user>/.bash_history`
- `/home/<user>/.zsh_history`
- `/root/.bash_history`
- `/home/<user>/.ssh/authorized_keys`
- `/home/<user>/.ssh/known_hosts`
- `/root/.ssh/authorized_keys`
- `/home/<user>/.profile`, `/home/<user>/.bashrc`

### Что смотреть
- Необычные команды в history (скачивание, chmod +s, reverse shell).
- Неизвестные SSH-ключи, изменение времени `authorized_keys`.

## 5) `/etc/`
Обычно: конфигурация системы, сервисов и механизмы persistence.

### Ключевые файлы и директории
- `/etc/passwd`, `/etc/shadow`, `/etc/group`
- `/etc/sudoers`, `/etc/sudoers.d/`
- `/etc/ssh/sshd_config`
- `/etc/crontab`, `/etc/cron.d/`, `/etc/cron.daily/`, `/etc/cron.hourly/`
- `/etc/systemd/system/`
- `/etc/rc.local` (если используется)
- `/etc/ld.so.preload` (очень важный IOC)
- `/etc/profile`, `/etc/environment`

## 6) `/tmp/`, `/var/tmp/`, `/dev/shm/`
Обычно: staging атакующего, дропперы, временные бинарники, скрипты.

### Что смотреть
- Исполняемые файлы, SUID/SGID, необычные имена, недавние timestamp.
- Бинарники, созданные после входа подозрительного пользователя.

## 7) `/usr/`, `/usr/local/`, `/opt/`
Обычно: системные и сторонние бинарники/скрипты.

### Важные подпути
- `/usr/bin/`, `/usr/sbin/`
- `/usr/local/bin/`, `/usr/local/sbin/`
- `/opt/`

### Что смотреть
- Нестандартные бинарники в `PATH`.
- Подмена/дублирование имен системных утилит.

## 8) `/proc/` и `/sys/`
Обычно: runtime-состояние процессов и ядра.

### Полезно в live response
- `/proc/<PID>/exe`
- `/proc/<PID>/cmdline`
- `/proc/<PID>/environ`
- `/proc/net/*`

## 9) `/boot/` и модули ядра
Обычно: загрузка, kernel, initramfs, модули.

### Что смотреть
- Необычные изменения в `/boot/`.
- Подозрительные `.ko` модули.

## 10) Журналы package manager
Обычно: следы установки/обновления вредоносных пакетов.

### Debian/Ubuntu
- `/var/log/apt/history.log`
- `/var/log/dpkg.log`

### RHEL/CentOS
- `/var/log/yum.log`
- `dnf history`

## 11) Быстрый список must-check файлов
- `/etc/passwd`
- `/etc/sudoers`
- `/etc/ssh/sshd_config`
- `/home/<user>/.bash_history`
- `/root/.bash_history`
- `/home/<user>/.ssh/authorized_keys`
- `/var/log/auth.log` или `/var/log/secure`
- `/var/log/audit/audit.log`
- `/etc/crontab`
- `/etc/systemd/system/*.service`
- `/tmp/*`, `/var/tmp/*`, `/dev/shm/*`

## 12) Быстрые команды для этой карты
```bash
# Проверить пользователей и привилегии
cat /etc/passwd
cat /etc/group
sudo cat /etc/sudoers

# Проверить SSH и history
ls -al /home/*/.ssh /root/.ssh 2>/dev/null
for u in /home/* /root; do ls -la "$u"/.bash_history "$u"/.zsh_history 2>/dev/null; done

# Проверить логи входа
sudo grep -Ei "failed|invalid user|accepted|sudo|session" /var/log/auth.log 2>/dev/null | tail -n 200
sudo journalctl _COMM=sshd --since "-24h" --no-pager

# Проверить persistence
crontab -l
sudo ls -la /etc/cron.d /etc/cron.daily /etc/cron.hourly /var/spool/cron 2>/dev/null
systemctl list-timers --all
systemctl list-unit-files --type=service | grep enabled

# Проверить свежие файлы в risky dirs
find /tmp /var/tmp /dev/shm -xdev -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %p\n' | sort
find /var/www -xdev -type f \( -name '*.php' -o -name '*.phtml' -o -name '*.phar' \) 2>/dev/null
```
