# 07_reporting_full_template

## Steps
1. Identify evidence type and scope.
2. Run minimal command set.
3. Record findings in CSV templates.

## Commands
```bash
mkdir -p case
printf "time_utc,source,event,details\n" > timeline.csv
grep -RinE "flag\{|THM\{" . 2>/dev/null
```
