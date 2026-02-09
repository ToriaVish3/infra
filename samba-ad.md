# Samba AD (контроллер домена)

## Ссылки (с описанием)
- https://help.ubuntu.ru/wiki/samba4_as_dc_14.04 — Samba4 как AD DC (RU, пошагово, команды)
- https://docs.altlinux.org/ru-RU/alt-server-e2k/10.2/html-single/alt-server-e2k/index.html — примеры `samba-tool domain provision` (RU)
- https://docs.altlinux.org/ru-RU/domain/10.4/html-single/samba/index.html — `samba-tool domain join` и параметры (RU)
- https://support.kaspersky.ru/ksc-linux/15.1/257889 — `samba-tool domain provision --use-rfc2307` и настройки (RU)

## Команды (шпаргалка: команда — что делает)
- `apt update && apt install samba acl krb5-user ntp bind9 smbclient -y` — установить пакеты AD DC
- `samba-tool domain provision --use-rfc2307 --interactive` — поднять домен (интерактивно)
- `systemctl restart samba-ad-dc` — перезапустить сервис DC (если сервис так называется в дистрибутиве)
- `samba-tool domain join <dnsdomain> DC --realm=<REALM> --dns-backend=SAMBA_INTERNAL` — присоединить новый DC

## Типовой сценарий (кратко)
1. Установка пакетов.
2. `samba-tool domain provision` с параметрами Realm/Domain/DNS.
3. Проверка Kerberos (`kinit administrator`).
4. Проверка DNS (`dig _ldap._tcp.<domain>`) и Samba.

## Проверка
- `samba-tool user list` — список пользователей
- `samba-tool domain info 127.0.0.1` — информация о домене

## Дополнительные команды (шпаргалка: команда — что делает)
- `samba-tool user list` — список пользователей
- `samba-tool group list` — список групп
- `samba-tool user create testuser Passw0rd!` — создать пользователя
- `samba-tool user enable testuser` — включить пользователя
- `samba-tool domain info 127.0.0.1` — информация о домене
- `testparm` — проверить конфиг Samba
- `kinit administrator` — получить Kerberos билет (если настроен)
- `klist` — показать билеты Kerberos
