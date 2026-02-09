# OpenLDAP

## Ссылки (с описанием)
- https://debian-handbook.info/browse/ru-RU/stable/sect.ldap-directory.html — LDAP в Debian (RU, общая настройка slapd)
- https://www.openldap.org/doc/admin24/guide.pdf — OpenLDAP Admin Guide (EN, команды ldapadd/ldapsearch)

## Команды (шпаргалка: команда — что делает)
- `apt install slapd ldap-utils -y` — установить сервер и утилиты
- `dpkg-reconfigure slapd` — пересоздать базовую конфигурацию
- `systemctl status slapd` — проверить статус
- `ldapsearch -x -b '' -s base '(objectclass=*)' namingContexts` — проверить работу LDAP
- `ldapadd -x -D "cn=admin,dc=example,dc=local" -W -f base.ldif` — добавить записи из LDIF

## Мини‑LDIF (base.ldif)
```
dn: dc=example,dc=local
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Org
dc: example

dn: cn=admin,dc=example,dc=local
objectClass: organizationalRole
cn: admin
```
