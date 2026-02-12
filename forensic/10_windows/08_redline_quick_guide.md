# Redline quick guide (for CTF)

Основано на румке `TryHackMe Redline`.

## Быстрый workflow
1. Открыть уже собранный пакет или сделать collection.
2. Проверить процессы и parent-child цепочки.
3. Проверить network artifacts.
4. Проверить autoruns/persistence.
5. Прогнать IOC Search.

## Что искать
- Необычные `cmd.exe`/`powershell.exe` с подозрительными аргументами
- Родители процессов, нехарактерные для workstation
- Выполнение из `AppData`, `Temp`, `Public`, user profile paths
- Сетевые коннекты к нетипичным внешним IP/портам
- Следы encoded/obfuscated команд

## Практика из румки
- Анализ уже скомпрометированного хоста
- Сведение нескольких артефактов в одну версию событий

## Мини-вывод
Redline особенно полезен как быстрый pivot-инструмент: процесс -> сеть -> persistence -> IOC.
