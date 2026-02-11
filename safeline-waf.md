# SafeLine WAF (雷池)

## Ссылки (с описанием)
- https://www.wizstudio.cn/archives/314 — RU/中文: установка через Docker и примеры
- https://www.cnblogs.com/wanganmuzi/p/18920355 — RU/中文: краткий гайд по развертыванию
- https://github.com/chaitin/SafeLine — репозиторий проекта (EN/中文)
- https://dev.to/carrie_luo1/how-to-manually-install-safeline-waf-44ko — ручная установка (EN)
- https://dev.to/sharon_42e16b8da44dabde6d/how-to-deploy-safeline-waf-with-docker-in-5-minutes-2eh4 — быстрая установка (EN)

## Пример топологии (минимальный рабочий вариант)
- `web` (Debian) — контейнер nginx на `10.10.30.20:80`
- `waf` (Debian) — SafeLine WAF на `10.10.30.30`
- DNS в домене указывает `web.lanb.local` → `10.10.30.30`
- SafeLine проксирует на upstream `10.10.30.20:80`

## Быстрый старт (автоустановка)
```
bash -c "$(curl -fsSLk https://waf.chaitin.com/release/latest/manager.sh)" -- --en
```
Что делает:
- Скачивает менеджер установки SafeLine.
- Разворачивает контейнеры и зависимости.
- Готовит веб‑панель управления.

Получить логин/пароль администратора:
```
docker exec safeline-mgt resetadmin
```
Что делает:
- Сбрасывает и показывает админские учётные данные для веб‑панели.

Открыть панель:
```
https://<IP_узла_waf>:9443/
```

## Ручная установка (если автоустановка не подходит)
1) Установить Docker:
```
curl -sSL "https://get.docker.com/" | bash
```
Что делает: ставит актуальный Docker.

2) Создать каталог данных:
```
mkdir -p /data/safeline
```
Что делает: каталог для конфигов/данных SafeLine.

3) Скачать compose‑файл:
```
cd /data/safeline
wget "https://waf.chaitin.com/release/latest/compose.yaml"
```
Что делает: получаем docker‑compose описание всех сервисов WAF.

4) Создать `.env` и заполнить:
```
cd /data/safeline
touch .env
```
Минимальный пример:
```
SAFELINE_DIR=/data/safeline
IMAGE_TAG=latest
MGT_PORT=9443
POSTGRES_PASSWORD=<пароль>
SUBNET_PREFIX=172.22.222
IMAGE_PREFIX=chaitin
ARCH_SUFFIX=
RELEASE=
REGION=-g
```
Что делает: задаёт директорию, порт панели и параметры сети/образов.

5) Запуск:
```
docker compose up -d
```
Что делает: поднимает все контейнеры SafeLine в фоне.

## Добавление приложения (reverse proxy)
В веб‑панели SafeLine:
1) **Applications → Add Application**
2) Заполнить:
   - **Domain**: `web.lanb.local`
   - **Port**: `80`
   - **Upstream**: `10.10.30.20:80`

Что делает:
- WAF принимает запросы на домен `web.lanb.local`.
- Проксирует их на реальный сервис на `10.10.30.20:80`.

## DNS (обязательная часть)
DNS должен указывать на IP WAF, иначе трафик обойдёт защиту:
```
web.lanb.local  ->  10.10.30.30
```

## Проверки
1) Проверка доступности веба через WAF:
```
curl http://web.lanb.local
```
2) Проверка, что контейнеры живы:
```
docker ps
```
3) Проверка логов WAF (в панели):
- Должны появляться запросы на домен.

## Где что хранится
- Данные SafeLine: `/data/safeline/`
- Контейнеры: `/var/lib/docker/containers/`
- Конфиги docker‑compose: `/data/safeline/compose.yaml` и `/data/safeline/.env`
