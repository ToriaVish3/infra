# Linux Filesystem Timeline (ext*)

## Objective
Построить последовательность событий по MAC-times и логам.

## 1) Fast file timeline with find
```bash
sudo find /home /root /tmp /var/tmp -xdev -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %u %g %m %s %p\n' | sort > timeline_files.txt
head -n 50 timeline_files.txt
```

## 2) Use stat for key files
```bash
stat /path/file
```
Interpretation:
- `Access` = atime
- `Modify` = mtime
- `Change` = ctime

## 3) ext filesystem metadata tools
```bash
lsblk -f
sudo dumpe2fs -h /dev/sdXN 2>/dev/null | head -n 80
sudo debugfs -R 'stat /path/in/fs' /dev/sdXN 2>/dev/null
```

## 4) Sleuth Kit workflow (offline image)
```bash
mmls image.dd
fls -r -m / image.dd > bodyfile.txt
mactime -b bodyfile.txt > mactime.csv
```

## 5) Correlate with logs
```bash
grep -Ei 'accepted|sudo|session|failed' /var/log/auth.log 2>/dev/null | tail -n 200
journalctl --since '2026-02-12 10:00:00' --until '2026-02-12 12:00:00' --no-pager
```

## 6) Detect timestomp-like anomalies (heuristics)
- file mtime old, but ctime very recent.
- batch of suspicious files with near-identical timestamps.

Commands:
```bash
sudo find /home /tmp -type f -printf '%T@ %C@ %p\n' 2>/dev/null | awk '{if ($1+0 < $2+0-300) print $0}' | head -n 200
```
