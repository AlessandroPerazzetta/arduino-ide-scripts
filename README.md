# Arduino IDE scripts
Scripts to automate arduino ide tasks
## Scripts

### `run.sh`
Launches Arduino IDE, setting environment variables for custom profile 
> **Note (08 apr 2025):** 2.x not yet full portable as 1.x legacy. [Issue open on Github](https://github.com/arduino/arduino-ide/issues/122)

### `download_latest.sh`
Downloads latest release of Arduino IDE from official github repository (grab latest release).

### `backup_homedirs.sh`
Backup arduino related directory from user's home
Specify destination dir (optional, default on $HOME)

## Usage

1. Make scripts executable:
```bash
chmod +x run.sh download_latest.sh backup_homedirs.sh
```

2. Download Arduino IDE:
```bash
./download_latest.sh /opt/ latest_naming
```

3. Launch IDE:
```bash
./run.sh latest
```

3. Backup:
```bash
./backup_homedirs.sh /destination_backup_dir/
``````