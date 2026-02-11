# Docker

## Ссылки (с описанием)
- https://habr.com/ru/companies/ruvds/articles/450312/ — Docker Compose: примеры файлов и команд
- https://habr.com/ru/articles/913978/ — практические команды Docker (run/exec/logs)
- https://habr.com/ru/companies/flant/articles/336654/ — практика контейнеризации приложений
- https://habr.com/ru/companies/ruvds/articles/440660/ — базовые команды и разбор Docker
- https://docs.docker.com/get-started/ — официальный getting started
- https://docs.docker.com/get-started/introduction/ — введение, термины, команды

## Команды (шпаргалка: команда — что делает)
- `docker ps -a` — список всех контейнеров (включая остановленные)
- `docker images` — список локальных образов
- `docker pull nginx:alpine` — скачать образ
- `docker run -d --name web -p 8080:80 nginx:alpine` — запустить контейнер в фоне и пробросить порт
- `docker logs -f web` — смотреть логи контейнера в реальном времени
- `docker exec -it web sh` — зайти в контейнер с shell
- `docker stop web` — остановить контейнер
- `docker rm web` — удалить контейнер
- `docker rmi nginx:alpine` — удалить образ
- `docker build -t myweb .` — собрать образ из Dockerfile

## Docker Compose (минимум)
```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
```

## Команды Compose (шпаргалка)
- `docker compose up -d` — поднять сервисы в фоне
- `docker compose down` — остановить и удалить сервисы
- `docker compose ps` — статус сервисов
- `docker compose logs -f` — логи сервисов
- `docker compose exec web sh` — выполнить команду в контейнере сервиса

## Дополнительные команды (шпаргалка: команда — что делает)
- `docker stats` — потребление ресурсов контейнерами
- `docker inspect web` — подробные параметры контейнера
- `docker network ls` — список сетей Docker
- `docker network inspect bridge` — детали сети bridge
- `docker volume ls` — список volume
- `docker volume inspect <vol>` — детали volume
- `docker system df` — место, занятое Docker
- `docker system prune -f` — очистка неиспользуемых ресурсов
- `docker cp file web:/path/` — копировать файл в контейнер
- `docker compose config` — проверить итоговую конфигурацию Compose
- `docker compose pull` — скачать образы

## Порядок настройки (как в задании)
1. Установить Docker:
   - `sudo apt update`
   - `sudo apt install docker.io`
2. Включить и запустить сервис:
   - `sudo systemctl enable --now docker`
3. Запустить контейнер nginx:
   - `sudo docker run -d -p 80:80 --name web nginx`
4. Проверка на самом web‑узле:
   - `curl http://localhost`

## Пояснения к параметрам команды run
- `-d` — запуск в фоне (daemon).
- `-p 80:80` — проброс порта: хост 80 → контейнер 80.
- `--name web` — имя контейнера (чтобы удобно управлять).
- `nginx` — образ (если нет локально, будет скачан).

## Что где хранится
- Образы: `/var/lib/docker/`
- Контейнеры: `/var/lib/docker/containers/`
- Логи контейнеров: `/var/lib/docker/containers/<id>/*-json.log`

## Проверки
- `docker ps` — контейнер запущен
- `curl http://localhost` — отдаётся дефолтная страница nginx
