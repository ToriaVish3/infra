# Package and Binary Abuse Investigation

## Package manager traces

### Debian/Ubuntu/Kali
```bash
sudo tail -n 300 /var/log/apt/history.log
sudo tail -n 300 /var/log/dpkg.log
```

### RHEL-family
```bash
sudo tail -n 300 /var/log/yum.log 2>/dev/null
sudo dnf history 2>/dev/null
```

## Suspicious binaries

Commands:
```bash
file /path/suspicious
strings /path/suspicious | head -n 120
sha256sum /path/suspicious
ldd /path/suspicious 2>/dev/null
```

## Abuse of permissions

### SUID/SGID
```bash
sudo find / -xdev -perm -4000 -type f 2>/dev/null
sudo find / -xdev -perm -2000 -type f 2>/dev/null
```

### Linux capabilities
```bash
sudo getcap -r / 2>/dev/null
```

Look for dangerous capabilities:
- `cap_setuid`
- `cap_setgid`
- `cap_sys_admin`
- `cap_dac_override`

## Quick checks for masquerading
```bash
sudo find /tmp /var/tmp /dev/shm /usr/local/bin /opt -type f -executable 2>/dev/null | head -n 300
sudo find / -xdev -type f -name '.*' 2>/dev/null | head -n 300
```

## Shared library hijack hints
```bash
env | grep -E '^LD_'
sudo grep -RinE 'LD_PRELOAD|LD_LIBRARY_PATH' /etc /home /root 2>/dev/null | head -n 300
```
