# Memory forensics (Volatility 3)

Опирается на `TryHackMe Memory Analysis Introduction` + базовый практический минимум.

## Быстрый старт
1. Определи профиль/символы (если требуется).
2. Построй список процессов и дерево.
3. Проверь сетевые артефакты.
4. Проверь CLI-артефакты и подозрительные DLL/handles.

## Часто используемые плагины
- `windows.pslist`
- `windows.pstree`
- `windows.cmdline`
- `windows.netscan`
- `windows.dlllist`
- `windows.handles`
- `windows.filescan`

## Что искать
- Процессы без нормального parent
- Несоответствие image path и ожидаемого места запуска
- Подозрительные сетевые соединения
- Следы инжекта/аномальных модулей
