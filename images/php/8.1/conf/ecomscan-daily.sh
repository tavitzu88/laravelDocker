#!/bin/bash

# eComscan Daily Monitoring Script
# Runs daily via cron to scan for security issues

# Configuration from environment variables
SCAN_DIR="${ECOMSCAN_SCAN_DIR:-/var/www/src}"
EMAIL_TO="${ECOMSCAN_EMAIL:-alin.munteanu@roweb.com}"
LICENSE_KEY="${ECOMSCAN_LICENSE_KEY:-trial}"
PROJECT_NAME="${PROJECT_NAME:-magento}"
MIN_CONFIDENCE="${ECOMSCAN_MIN_CONFIDENCE:-50}"
STATE_FILE="/var/www/src/var/log/ecomscan-state.json"
LOG_FILE="/var/www/src/var/log/ecomscan-latest.log"

# Check if eComscan is installed
if ! command -v ecomscan >/dev/null 2>&1; then
    echo "[$(date)] ERROR: eComscan is not installed!" | tee -a "$LOG_FILE"
    echo "Please run: bin/setup-ecomscan to install eComscan" | tee -a "$LOG_FILE"
    echo "Skipping scan..." | tee -a "$LOG_FILE"
    exit 0  # Exit with 0 so cron doesn't report error
fi

# Verify eComscan version
ECOMSCAN_VERSION=$(ecomscan --version 2>/dev/null || echo "unknown")
echo "[$(date)] Starting eComscan v$ECOMSCAN_VERSION" | tee -a "$LOG_FILE"
echo "Project: $PROJECT_NAME" | tee -a "$LOG_FILE"
echo "Scan directory: $SCAN_DIR" | tee -a "$LOG_FILE"
echo "Email: $EMAIL_TO" | tee -a "$LOG_FILE"
echo "----------------------------------------" | tee -a "$LOG_FILE"

# Check if scan directory exists
if [ ! -d "$SCAN_DIR" ]; then
    echo "[$(date)] ERROR: Scan directory $SCAN_DIR does not exist!" | tee -a "$LOG_FILE"
    exit 1
fi

# Run eComscan in monitoring mode
# --monitor: Sends email only when changes are detected (new issues found)
# --tag: Identifies the project in reports
# --state-file: Tracks changes between scans
# --min-confidence: Minimum confidence level (0-100)
# --no-auto-update: Disable auto-updates (for stability)
# --one-file-system: Don't cross filesystem boundaries

echo "[$(date)] Running scan..." | tee -a "$LOG_FILE"

ecomscan "$SCAN_DIR" \
    --key "$LICENSE_KEY" \
    --monitor "$EMAIL_TO" \
    --tag "$PROJECT_NAME" \
    --state-file "$STATE_FILE" \
    --min-confidence "$MIN_CONFIDENCE" \
    --no-auto-update \
    --one-file-system \
    2>&1 | tee -a "$LOG_FILE"

EXIT_CODE=${PIPESTATUS[0]}

echo "----------------------------------------" | tee -a "$LOG_FILE"
echo "[$(date)] Scan completed with exit code: $EXIT_CODE" | tee -a "$LOG_FILE"

# Exit codes:
# 0 = No issues found or no changes since last scan
# 1 = Issues found or errors during scan
# 2 = Critical issues found

if [ $EXIT_CODE -eq 0 ]; then
    echo "[$(date)] ✓ No new security issues detected" | tee -a "$LOG_FILE"
elif [ $EXIT_CODE -eq 1 ]; then
    echo "[$(date)] ⚠ Security issues detected - check email report" | tee -a "$LOG_FILE"
elif [ $EXIT_CODE -eq 2 ]; then
    echo "[$(date)] ✗ CRITICAL security issues detected - immediate action required!" | tee -a "$LOG_FILE"
fi

# Cleanup old state files (keep last 30 days)
find /var/www/src/var/log -name "ecomscan-state-*.json" -mtime +30 -delete 2>/dev/null || true

# Rotate log file if it gets too large (>10MB)
if [ -f "$LOG_FILE" ]; then
    LOG_SIZE=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)
    if [ "$LOG_SIZE" -gt 10485760 ]; then
        mv "$LOG_FILE" "$LOG_FILE.old"
        echo "[$(date)] Log file rotated" > "$LOG_FILE"
    fi
fi

exit 0  # Always exit 0 so cron doesn't report errors