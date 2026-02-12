# Forensic README

## Root
- [00_README_START_HERE.md](./00_README_START_HERE.md) - стартовая навигация и назначение разделов.
- [00_INDEX.md](./00_INDEX.md) - быстрый указатель "куда идти" по типу задачи.
- [01_PLAN_OF_ACTION.md](./01_PLAN_OF_ACTION.md) - пошаговый план действий во время CTF.

## Windows (10 files)
- [10_windows/01_overview.md](./10_windows/01_overview.md) - обзор Windows DFIR и порядок расследования.
- [10_windows/02_live_response_commands.ps1](./10_windows/02_live_response_commands.ps1) - PowerShell-команды для live triage.
- [10_windows/03_key_artifacts.md](./10_windows/03_key_artifacts.md) - основные артефакты Windows для быстрых находок.
- [10_windows/04_event_logs_and_sysmon.md](./10_windows/04_event_logs_and_sysmon.md) - логи и события (EVTX/Sysmon).
- [10_windows/05_registry_and_persistence.md](./10_windows/05_registry_and_persistence.md) - реестр и механизмы persistence.
- [10_windows/06_filesystem_timeline_ntfs.md](./10_windows/06_filesystem_timeline_ntfs.md) - таймлайн по NTFS-артефактам.
- [10_windows/07_kape_quick_guide.md](./10_windows/07_kape_quick_guide.md) - краткий workflow KAPE.
- [10_windows/08_redline_quick_guide.md](./10_windows/08_redline_quick_guide.md) - краткий workflow Redline.
- [10_windows/09_powershell_artifacts.md](./10_windows/09_powershell_artifacts.md) - PowerShell execution traces.
- [10_windows/10_windows_ctf_checklist.md](./10_windows/10_windows_ctf_checklist.md) - финальный чеклист Windows-задачи.

## Linux (10 files)
- [20_linux/01_overview.md](./20_linux/01_overview.md) - обзор Linux DFIR и порядок расследования.
- [20_linux/02_live_response_commands.sh](./20_linux/02_live_response_commands.sh) - shell-команды для live triage.
- [20_linux/03_key_artifacts.md](./20_linux/03_key_artifacts.md) - основные Linux-артефакты для быстрых находок.
- [20_linux/04_auth_journal_audit.md](./20_linux/04_auth_journal_audit.md) - auth/journal/audit логи.
- [20_linux/05_ssh_and_persistence.md](./20_linux/05_ssh_and_persistence.md) - SSH + persistence-проверки.
- [20_linux/06_filesystem_timeline_ext.md](./20_linux/06_filesystem_timeline_ext.md) - таймлайн по файловой системе Linux.
- [20_linux/07_sleuthkit_plaso_quick.md](./20_linux/07_sleuthkit_plaso_quick.md) - быстрый минимум Sleuth Kit/Plaso.
- [20_linux/08_package_and_binary_abuse.md](./20_linux/08_package_and_binary_abuse.md) - package logs, бинари, привилегии.
- [20_linux/09_linux_ctf_checklist.md](./20_linux/09_linux_ctf_checklist.md) - финальный чеклист Linux-задачи.
- [20_linux/10_linux_forensics_paths_and_commands.md](./20_linux/10_linux_forensics_paths_and_commands.md) - отдельный справочник путей/команд и частых уязвимых мест.

## Other (10 files)
- [30_other/01_memory_forensics_volatility3.md](./30_other/01_memory_forensics_volatility3.md) - memory triage (Volatility 3).
- [30_other/02_timeline_correlation_playbook.md](./30_other/02_timeline_correlation_playbook.md) - корреляция событий и построение истории.
- [30_other/03_sigma_yara_ioc_templates.md](./30_other/03_sigma_yara_ioc_templates.md) - шаблоны правил и IOC.
- [30_other/04_ctf_speed_decision_tree.md](./30_other/04_ctf_speed_decision_tree.md) - дерево решений для ускорения.
- [30_other/05_common_flag_locations.md](./30_other/05_common_flag_locations.md) - где обычно искать флаги.
- [30_other/06_reporting_short_template.md](./30_other/06_reporting_short_template.md) - шаблон краткого отчета.
- [30_other/07_reporting_full_template.md](./30_other/07_reporting_full_template.md) - шаблон полного отчета.
- [30_other/08_findings_table_template.csv](./30_other/08_findings_table_template.csv) - таблица находок.
- [30_other/09_timeline_template.csv](./30_other/09_timeline_template.csv) - таблица таймлайна.
- [30_other/10_official_sources_links.md](./30_other/10_official_sources_links.md) - официальные источники.
