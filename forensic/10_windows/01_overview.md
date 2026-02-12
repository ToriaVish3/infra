# Overview (room-driven)

Эта папка собрана в первую очередь из практик TryHackMe:
- Windows Forensics 1
- KAPE
- Redline
- Memory Analysis Introduction
- Linux File System Analysis

## Что откуда
- Артефакты Windows, реестр, EVTX, таймлайн: `Windows Forensics 1`
- Сбор и первичный парсинг: `KAPE`
- Host investigation и IOC-поиск: `Redline`
- Базовый memory triage: `Memory Analysis Introduction`

## Мини-порядок на задаче
1. Быстрый triage хоста (процессы, сеть, автозапуск).
2. Снять/собрать артефакты (KAPE или руками).
3. Проверить execution + persistence + lateral traces.
4. Собрать таймлайн и подтвердить гипотезу фактами.
