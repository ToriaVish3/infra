# Kerberos (MIT krb5)

## Ссылки (с описанием)
- https://manpages.debian.org/trixie/krb5-user/kadmin.1 — kadmin/kadmin.local (EN)
- https://docs.redhat.com/fr/documentation/red_hat_enterprise_linux/7/html/system-level_authentication_guide/configuring_a_kerberos_5_server — KDC шаги и команды (EN)
- https://project.altservice.com/issues/163 — пример установки Kerberos на Debian (EN, команды kadmin)

## Команды (шпаргалка: команда — что делает)
- `apt install krb5-kdc krb5-admin-server -y` — установить KDC и админ‑сервер
- `krb5_newrealm` — создать новый realm
- `kadmin.local -q "addprinc adminuser/admin"` — создать админ‑principal
- `systemctl start krb5-kdc` — запустить KDC
- `systemctl start krb5-admin-server` — запустить kadmind
- `kinit adminuser/admin` — получить билет
- `klist` — показать билеты

## Файлы, которые обычно правят
- /etc/krb5.conf
- /etc/krb5kdc/kdc.conf
- /etc/krb5kdc/kadm5.acl
