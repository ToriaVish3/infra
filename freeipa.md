# FreeIPA (домен/LDAP)

## Ссылки (с описанием)
- https://dondub.com/2022/08/zapusk-freeipa-v-astra-linux-smolensk/ — установка FreeIPA на Astra Linux (RU)

## Команды (шпаргалка: команда — что делает)
- `apt update && apt install astra-freeipa-server -y` — установить FreeIPA (Astra)
- `ipa-server-install` — мастер установки сервера FreeIPA
- `ipa user-add testuser` — добавить пользователя
- `ipa user-show testuser` — показать пользователя
- `ipa-client-install` — подключить клиент к домену FreeIPA

## Мини‑план
1. Установить пакет сервера.
2. Правильно настроить hostname/FQDN.
3. Запустить `ipa-server-install` и пройти мастер.
4. Проверить создание пользователей и вход с клиента.

## Дополнительные команды (шпаргалка: команда — что делает)
- `ipa user-find` — список пользователей
- `ipa group-find` — список групп
- `ipa host-find` — список хостов
- `ipa service-find` — список сервисов
- `ipa passwd testuser` — сменить пароль
- `ipa-server-upgrade` — обновление схемы/БД (если нужно)
- `journalctl -u ipa -f` — логи FreeIPA (если сервис так называется)
