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

## Порядок настройки (как делали в лабе, Debian 10)
1. Установить пакеты (встроенный DNS Samba, без отдельного MIT KDC):
   - `sudo apt update`
   - `sudo apt install samba krb5-user winbind smbclient dnsutils -y`
2. Остановить конфликтующие сервисы (иначе AD DC не стартует):
   - `sudo systemctl stop smbd nmbd winbind`
   - `sudo systemctl disable smbd nmbd winbind`
3. Создать домен:
   - `sudo samba-tool domain provision --use-rfc2307 --interactive`
4. Применить конфиг и запустить AD DC:
   - `sudo systemctl unmask samba-ad-dc`
   - `sudo systemctl enable --now samba-ad-dc`
5. Настроить DNS на самого себя:
   - `echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf`
6. Проверить домен и DNS:
   - `sudo samba-tool domain info 127.0.0.1`
   - `host -t SRV _ldap._tcp.<domain> 127.0.0.1`
   - `host -t SRV _kerberos._tcp.<domain> 127.0.0.1`
7. Создать пользователя:
   - `sudo samba-tool user create testuser`

## Куда что записывается (файлы и их смысл)
- `/etc/samba/smb.conf` — основной конфиг Samba AD DC (realm/workgroup/role).
- `/etc/krb5.conf` — конфиг Kerberos клиента (realm, KDC, domain_realm).
- `/var/lib/samba/private/` — база домена (sam.ldb, secrets.ldb и т.д.).
- `/var/lib/samba/sysvol/` — SYSVOL для GPO/скриптов.
- `/etc/resolv.conf` — локальный DNS (должен смотреть на 127.0.0.1 для Samba DNS).

## Пояснения к ключевым параметрам
- `realm` — полное имя домена в верхнем регистре (например, `LANB.LOCAL`).
- `workgroup` — NetBIOS‑имя домена (короткое, например `LANB`).
- `server role` — должен быть `active directory domain controller`.
- `dns forwarder` — внешний DNS для форвардинга (например, `8.8.8.8`).
- `--use-rfc2307` — включить Unix‑атрибуты (uid/gid) в AD.
- `SAMBA_INTERNAL` — встроенный DNS Samba (проще, без bind9).

## Типовые ошибки и что с ними делать
- Пароль администратора слишком короткий:
  - Требование минимум 7 символов. Использовать 8+.
- Ошибка `realm was not specified in supplied /etc/samba/smb.conf`:
  - Удалить/переименовать старый `smb.conf` и заново выполнить provision.
- `samba-ad-dc` в состоянии `masked`:
  - `sudo systemctl unmask samba-ad-dc`
- `NT_STATUS_CANT_ACCESS_DOMAIN` при старте:
  - Остановить `smbd/nmbd/winbind`, проверить наличие `/var/lib/samba/private/secrets.ldb`.
- Kerberos `Cannot find KDC for realm`:
  - Проверить `/etc/krb5.conf`, `domain_realm`, DNS‑запись `infra.<domain>`.
- DNS SRV возвращает NXDOMAIN:
  - Проверить, что запрос идёт в 127.0.0.1 и что домен правильный.

## Пример корректного /etc/krb5.conf (domain = lanb.local)
```
[libdefaults]
 default_realm = LANB.LOCAL
 dns_lookup_realm = false
 dns_lookup_kdc = false

[realms]
 LANB.LOCAL = {
  kdc = infra.lanb.local
  admin_server = infra.lanb.local
 }

[domain_realm]
 .lanb.local = LANB.LOCAL
 lanb.local = LANB.LOCAL
```

## Пример корректного /etc/samba/smb.conf (AD DC)
```
[global]
   workgroup = LANB
   realm = LANB.LOCAL
   netbios name = DEBIAN
   server role = active directory domain controller
   dns forwarder = 8.8.8.8
   idmap_ldb:use rfc2307 = yes

[netlogon]
   path = /var/lib/samba/sysvol/lanb.local/scripts
   read only = No

[sysvol]
   path = /var/lib/samba/sysvol
   read only = No
```
