# KAPE quick guide (for CTF)

Основано на румке `TryHackMe KAPE`.

## Что делать быстро
1. Запустить triage-сбор по хосту.
2. Сфокусироваться на артефактах execution/persistence/logs.
3. Сразу выгрузить результаты в отдельную папку case.

## Что забирать в первую очередь
- Event Logs (Security/System/PowerShell/Sysmon)
- Registry hives (SAM/SYSTEM/SOFTWARE/NTUSER.DAT/UsrClass.dat)
- Prefetch
- Amcache/Shimcache-related data
- Jump Lists / LNK / Recent
- Scheduled tasks / services traces
- Browser artifacts

## Базовая схема
- Source: подозрительный хост/образ
- Target profiles: triage-профили на системные артефакты
- Modules: парсинг в удобный CSV/текст
- Output: отдельная case-папка с timestamp

## Что фиксировать в отчете
- Что собирали (профиль/таргеты)
- Время сбора
- Путь до output
- Ключевые находки (файл/ключ/лог/время)
