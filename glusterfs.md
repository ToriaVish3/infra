# GlusterFS

## Ссылки (с описанием)
- https://docs.gluster.org/en/latest/Install-Guide/Install/ — установка (EN)
- https://docs.gluster.org/en/main/Administrator-Guide/Setting-Up-Volumes/ — создание томов (EN)
- https://www.gluster.org/gluster-new-user-guide/ — New User Guide (EN)

## Команды (шпаргалка: команда — что делает)
- `apt install glusterfs-server -y` — установить сервер GlusterFS (если доступно в репозитории)
- `systemctl enable --now glusterd` — запустить glusterd
- `gluster peer probe node2` — добавить узел в кластер
- `gluster peer status` — статус узлов
- `gluster volume create gv0 replica 2 node1:/bricks/b1 node2:/bricks/b1` — создать реплицируемый том
- `gluster volume start gv0` — запустить том
- `gluster volume status` — статус тома

## Монтирование на клиенте
- `apt install glusterfs-client -y` — установить клиент
- `mount -t glusterfs node1:/gv0 /mnt/gv0` — примонтировать том
