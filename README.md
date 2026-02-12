# Forensic Pack

Этот репозиторий содержит компактный набор материалов для соревнований по форензике (Windows, Linux, Memory, timeline/reporting).

## Root
- [forensic/README.md](./forensic/README.md) - полный каталог forensic-пака.
- [forensic/00_README_START_HERE.md](./forensic/00_README_START_HERE.md) - стартовая навигация.
- [forensic/00_INDEX.md](./forensic/00_INDEX.md) - быстрый роутинг по типам задач.
- [forensic/01_PLAN_OF_ACTION.md](./forensic/01_PLAN_OF_ACTION.md) - пошаговый план действий на CTF.

## Windows Files
- [forensic/10_windows/01_overview.md](./forensic/10_windows/01_overview.md) - обзор Windows DFIR по room-driven подходу.
- [forensic/10_windows/02_live_response_commands.ps1](./forensic/10_windows/02_live_response_commands.ps1) - быстрые PowerShell-команды live triage.
- [forensic/10_windows/03_key_artifacts.md](./forensic/10_windows/03_key_artifacts.md) - список ключевых Windows-артефактов.
- [forensic/10_windows/04_event_logs_and_sysmon.md](./forensic/10_windows/04_event_logs_and_sysmon.md) - EVTX/Sysmon и базовые связки событий.
- [forensic/10_windows/05_registry_and_persistence.md](./forensic/10_windows/05_registry_and_persistence.md) - реестр и точки закрепления.
- [forensic/10_windows/06_filesystem_timeline_ntfs.md](./forensic/10_windows/06_filesystem_timeline_ntfs.md) - NTFS-таймлайн (MFT/USN/LogFile).
- [forensic/10_windows/07_kape_quick_guide.md](./forensic/10_windows/07_kape_quick_guide.md) - краткий практический гайд KAPE.
- [forensic/10_windows/08_redline_quick_guide.md](./forensic/10_windows/08_redline_quick_guide.md) - краткий практический гайд Redline.
- [forensic/10_windows/09_powershell_artifacts.md](./forensic/10_windows/09_powershell_artifacts.md) - PowerShell-артефакты и следы выполнения.
- [forensic/10_windows/10_windows_ctf_checklist.md](./forensic/10_windows/10_windows_ctf_checklist.md) - чеклист Windows-задачи на соревновании.

## Linux Files
- [forensic/20_linux/01_overview.md](./forensic/20_linux/01_overview.md) - обзор Linux DFIR по room-driven подходу.
- [forensic/20_linux/02_live_response_commands.sh](./forensic/20_linux/02_live_response_commands.sh) - быстрые Linux-команды live triage.
- [forensic/20_linux/03_key_artifacts.md](./forensic/20_linux/03_key_artifacts.md) - список ключевых Linux-артефактов.
- [forensic/20_linux/04_auth_journal_audit.md](./forensic/20_linux/04_auth_journal_audit.md) - auth/journal/audit источники и анализ.
- [forensic/20_linux/05_ssh_and_persistence.md](./forensic/20_linux/05_ssh_and_persistence.md) - SSH и persistence-проверки.
- [forensic/20_linux/06_filesystem_timeline_ext.md](./forensic/20_linux/06_filesystem_timeline_ext.md) - таймлайн по Linux FS.
- [forensic/20_linux/07_sleuthkit_plaso_quick.md](./forensic/20_linux/07_sleuthkit_plaso_quick.md) - быстрый набор Sleuth Kit/Plaso.
- [forensic/20_linux/08_package_and_binary_abuse.md](./forensic/20_linux/08_package_and_binary_abuse.md) - package logs, SUID/SGID/capabilities.
- [forensic/20_linux/09_linux_ctf_checklist.md](./forensic/20_linux/09_linux_ctf_checklist.md) - чеклист Linux-задачи на соревновании.
- [forensic/20_linux/10_linux_forensics_paths_and_commands.md](./forensic/20_linux/10_linux_forensics_paths_and_commands.md) - частые forensic-папки и команды (отдельный справочник).

## Other Files
- [forensic/30_other/01_memory_forensics_volatility3.md](./forensic/30_other/01_memory_forensics_volatility3.md) - базовый memory triage с Volatility 3.
- [forensic/30_other/02_timeline_correlation_playbook.md](./forensic/30_other/02_timeline_correlation_playbook.md) - playbook по корреляции событий.
- [forensic/30_other/03_sigma_yara_ioc_templates.md](./forensic/30_other/03_sigma_yara_ioc_templates.md) - шаблоны Sigma/YARA/IOC.
- [forensic/30_other/04_ctf_speed_decision_tree.md](./forensic/30_other/04_ctf_speed_decision_tree.md) - дерево решений по типу входных данных.
- [forensic/30_other/05_common_flag_locations.md](./forensic/30_other/05_common_flag_locations.md) - типовые места и форматы флагов.
- [forensic/30_other/06_reporting_short_template.md](./forensic/30_other/06_reporting_short_template.md) - шаблон короткого отчета.
- [forensic/30_other/07_reporting_full_template.md](./forensic/30_other/07_reporting_full_template.md) - шаблон полного отчета.
- [forensic/30_other/08_findings_table_template.csv](./forensic/30_other/08_findings_table_template.csv) - CSV-шаблон таблицы находок.
- [forensic/30_other/09_timeline_template.csv](./forensic/30_other/09_timeline_template.csv) - CSV-шаблон таймлайна.
- [forensic/30_other/10_official_sources_links.md](./forensic/30_other/10_official_sources_links.md) - подборка официальных DFIR-ссылок.
