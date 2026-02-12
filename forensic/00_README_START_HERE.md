# Forensic Knowledge Base

База для чемпионата по форензике. Приоритет: материал из TryHackMe rooms + боевые команды и чеклисты.

## Как использовать
1. Открой `00_INDEX.md`.
2. Выбери тип задачи (Windows/Linux/Memory).
3. Иди в соответствующий checklist и командный файл.
4. Все найденное сразу фиксируй в timeline/findings csv.

## Root
- [00_README_START_HERE.md](./00_README_START_HERE.md): этот файл, навигация.
- [00_INDEX.md](./00_INDEX.md): быстрый роутинг по задачам и румкам.

## Windows (до 10)
- [10_windows/01_overview.md](./10_windows/01_overview.md): каркас Windows DFIR, привязанный к room-подходу.
- [10_windows/02_live_response_commands.ps1](./10_windows/02_live_response_commands.ps1): команды live triage.
- [10_windows/03_key_artifacts.md](./10_windows/03_key_artifacts.md): главные артефакты для быстрых ответов.
- [10_windows/04_event_logs_and_sysmon.md](./10_windows/04_event_logs_and_sysmon.md): ключевые логи/ID.
- [10_windows/05_registry_and_persistence.md](./10_windows/05_registry_and_persistence.md): реестр и точки закрепления.
- [10_windows/06_filesystem_timeline_ntfs.md](./10_windows/06_filesystem_timeline_ntfs.md): NTFS-таймлайн.
- [10_windows/07_kape_quick_guide.md](./10_windows/07_kape_quick_guide.md): практический KAPE-порядок.
- [10_windows/08_redline_quick_guide.md](./10_windows/08_redline_quick_guide.md): практический Redline-порядок.
- [10_windows/09_powershell_artifacts.md](./10_windows/09_powershell_artifacts.md): PowerShell traces.
- [10_windows/10_windows_ctf_checklist.md](./10_windows/10_windows_ctf_checklist.md): чеклист под соревнование.

## Linux (до 10)
- [20_linux/01_overview.md](./20_linux/01_overview.md): Linux DFIR-основа по room-логике.
- [20_linux/02_live_response_commands.sh](./20_linux/02_live_response_commands.sh): live команды.
- [20_linux/03_key_artifacts.md](./20_linux/03_key_artifacts.md): ключевые Linux артефакты.
- [20_linux/04_auth_journal_audit.md](./20_linux/04_auth_journal_audit.md): auth/journal/audit.
- [20_linux/05_ssh_and_persistence.md](./20_linux/05_ssh_and_persistence.md): SSH + persistence.
- [20_linux/06_filesystem_timeline_ext.md](./20_linux/06_filesystem_timeline_ext.md): FS timeline.
- [20_linux/07_sleuthkit_plaso_quick.md](./20_linux/07_sleuthkit_plaso_quick.md): TSK/Plaso быстрый набор.
- [20_linux/08_package_and_binary_abuse.md](./20_linux/08_package_and_binary_abuse.md): пакеты, SUID, capabilities.
- [20_linux/09_linux_ctf_checklist.md](./20_linux/09_linux_ctf_checklist.md): чеклист под соревнование.
- [20_linux/10_linux_forensics_paths_and_commands.md](./20_linux/10_linux_forensics_paths_and_commands.md): отдельный файл с частыми forensic-папками и командами.

## Other (до 10)
- [30_other/01_memory_forensics_volatility3.md](./30_other/01_memory_forensics_volatility3.md): memory triage.
- [30_other/02_timeline_correlation_playbook.md](./30_other/02_timeline_correlation_playbook.md): корреляция событий.
- [30_other/03_sigma_yara_ioc_templates.md](./30_other/03_sigma_yara_ioc_templates.md): шаблоны детектов.
- [30_other/04_ctf_speed_decision_tree.md](./30_other/04_ctf_speed_decision_tree.md): дерево решений.
- [30_other/05_common_flag_locations.md](./30_other/05_common_flag_locations.md): где часто лежат флаги.
- [30_other/06_reporting_short_template.md](./30_other/06_reporting_short_template.md): короткий отчет.
- [30_other/07_reporting_full_template.md](./30_other/07_reporting_full_template.md): полный отчет.
- [30_other/08_findings_table_template.csv](./30_other/08_findings_table_template.csv): findings table.
- [30_other/09_timeline_template.csv](./30_other/09_timeline_template.csv): timeline table.
- [30_other/10_official_sources_links.md](./30_other/10_official_sources_links.md): полезные официальные ссылки.
