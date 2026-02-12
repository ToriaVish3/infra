# Sleuth Kit + Plaso

### Команда
```bash
mmls image.dd
```
Что делает: показывает таблицу разделов образа.
Параметры: путь к образу.

### Команда
```bash
fsstat -o <offset> image.dd
```
Что делает: информация по файловой системе раздела.
Параметры: `-o` смещение раздела.

### Команда
```bash
icat -o <offset> image.dd <inode> > extracted.bin
```
Что делает: извлекает файл по inode.
Параметры: `-o` offset, `<inode>` номер inode.

### Команда
```bash
log2timeline.py --status_view none --storage-file timeline.plaso image.dd
```
Что делает: строит Plaso-хранилище таймлайна.
Параметры: `--storage-file` выходной файл.
