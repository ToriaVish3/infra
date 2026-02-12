# Таймлайн ФС (ext)

### Команда
```bash
find /home /root /tmp -xdev -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %p\n' | sort
```
Что делает: строит текстовый таймлайн по файлам.
Параметры: `-printf` формат даты/владельца/прав/пути, `-xdev` одна ФС.

### Команда
```bash
stat /path/to/file
```
Что делает: показывает atime/mtime/ctime/inode.
Параметры: путь к файлу.

### Команда
```bash
fls -r -m / image.dd > bodyfile.txt
```
Что делает: создает bodyfile для `mactime`.
Параметры: `-r` рекурсивно, `-m /` точка монтирования.

### Команда
```bash
mactime -b bodyfile.txt > mactime.csv
```
Что делает: формирует CSV таймлайн.
Параметры: `-b` входной bodyfile.
