# 07 sleuthkit plaso quick

## Live-response first (room-aligned)
- Сначала сделай live triage и собери `stat`, `find`, `journalctl`, `auth`.
- Потом переходи к офлайн артефактам через образ диска.

## Sleuth Kit quick
```bash
fls -r -m / image.dd > bodyfile.txt
# Сформировать bodyfile из всех артефактов образа
mactime -b bodyfile.txt -d > timeline.csv
# Построить MACB timeline в CSV
icat image.dd <inode> > recovered.bin
# Извлечь файл по inode
```

## Plaso quick
```bash
log2timeline.py --storage-file timeline.plaso image.dd
# Собрать plaso-хранилище из образа
psort.py -o l2tcsv -w plaso_timeline.csv timeline.plaso
# Экспорт plaso в CSV
psort.py -o dynamic --status_view none timeline.plaso "date > '2026-02-12'"
# Фильтр вывода по времени
```

## Correlation hints
- Сопоставляй `ctime/mtime/atime` из `stat` с auth/web logs.
- Подтверждай гипотезу минимум 2 источниками.
