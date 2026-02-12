# Plan of Action (CTF Forensics)

## 0. First 3 minutes
1. Определи тип задания: Windows / Linux / Memory / mixed logs.
2. Зафиксируй UTC/local time и временное окно инцидента.
3. Создай рабочую заметку: гипотеза, артефакты, ответы.

## 1. Fast triage (10-15 minutes)
1. Сначала high-value артефакты из чеклиста OS.
2. Ищи execution, persistence, auth, network, file changes.
3. Любую находку подтверждай минимум двумя источниками.

## 2. Windows branch
1. Открой `10_windows/10_windows_ctf_checklist.md`.
2. Используй `10_windows/02_live_response_commands.ps1`.
3. Приоритет: EVTX/Sysmon, Registry persistence, Prefetch/Amcache, PowerShell traces.
4. Если есть KAPE/Redline артефакты - сразу pivot process -> network -> persistence.

## 3. Linux branch
1. Открой `20_linux/09_linux_ctf_checklist.md`.
2. Используй `20_linux/02_live_response_commands.sh`.
3. Приоритет: auth/journal/audit, SSH keys/config, cron/systemd timers, SUID/capabilities.
4. Используй `20_linux/10_linux_forensics_paths_and_commands.md` как основной справочник путей.

## 4. Memory branch
1. Открой `30_other/01_memory_forensics_volatility3.md`.
2. Приоритет: pslist/pstree/cmdline/netscan/dlllist.
3. Ищи нехарактерные процессы, странные parent-child, необычные сетевые коннекты.

## 5. Build answer
1. Заполняй `30_other/08_findings_table_template.csv`.
2. Заполняй `30_other/09_timeline_template.csv`.
3. Сформируй финальный краткий вывод: кто/что/когда/чем подтверждено.

## 6. Before submit
1. Проверь формат флага (`flag{...}`/`THM{...}` и т.д.).
2. Проверь timezone и точность времени.
3. Убедись, что ответ подтвержден артефактами, а не только одной догадкой.
