# Windows CTF checklist

Основано в основном на `Windows Forensics 1`, `KAPE`, `Redline`.

1. Кто пользователь и когда был интерактивный вход?
2. Какие процессы были запущены подозрительно?
3. Есть ли следы PowerShell/скриптового исполнения?
4. Есть ли persistence (Run keys, tasks, services, startup)?
5. Какие файлы запускались (Prefetch/Amcache/Shimcache)?
6. Что в EVTX/Sysmon around incident time?
7. Есть ли внешние сетевые коннекты в этот же период?
8. Есть ли следы удаления/маскировки (Recycle, rename, timestomp hints)?
9. Что подтверждается минимум двумя независимыми артефактами?
10. Сформирован ли короткий timeline для ответа/флага?
