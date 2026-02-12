# Sleuth Kit + Plaso Quick Guide

## Sleuth Kit (disk image)

1) Partition layout:
```bash
mmls image.dd
```

2) File-system stats:
```bash
fsstat -o <offset> image.dd
```

3) Recursive listing:
```bash
fls -r -o <offset> image.dd | head -n 200
```

4) Extract file by inode:
```bash
icat -o <offset> image.dd <inode> > extracted.bin
file extracted.bin
sha256sum extracted.bin
```

5) Timeline:
```bash
fls -r -m / -o <offset> image.dd > bodyfile.txt
mactime -b bodyfile.txt > mactime.csv
```

## Plaso (log2timeline)

1) Create super timeline:
```bash
log2timeline.py --status_view none --storage-file timeline.plaso image.dd
```

2) Convert to CSV:
```bash
psort.py -o l2tcsv -w timeline.csv timeline.plaso
```

3) Filter by keywords:
```bash
psort.py -o dynamic --slice "date > '2026-02-12T00:00:00'" timeline.plaso | grep -Ei 'ssh|sudo|cron|systemd|tmp|wget|curl'
```

## Practical tip
- Use Sleuth Kit for targeted extraction and inode-level checks.
- Use Plaso for broad timeline correlation across many artifact types.
