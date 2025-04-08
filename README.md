# Arduino IDE scripts
Scripts to automate arduino ide tasks
## Scripts

### `run.sh`
Launches Arduino IDE, setting environment variables for custom profile 
> **Note (08 apr 2025):** 2.x not yet full portable as 1.x legacy.

### `download_latest.sh`
Downloads latest release of Arduino IDE from official github repository (grab latest release).

## Usage

1. Make scripts executable:
```bash
chmod +x run.sh download_latest.sh
```

2. Download Arduino IDE:
```bash
./download_latest.sh /opt/ latest_naming
```

3. Launch IDE:
```bash
./run.sh latest
```