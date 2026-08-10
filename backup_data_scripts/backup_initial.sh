#!/bin/bash
# =============================================================
# INITIAL rsync backup of LaCie drives to bunya
# Reuses a single SSH master connection so Duo is only
# requested once per script run.
#
# RESUME-SAFE: If SSH drops mid-transfer, just re-run this
# script. It detects the incomplete snapshot and resumes
# into the same folder instead of creating a new one.
# =============================================================

REMOTE_HOST="bunya"
REMOTE_BASE="/QRISdata/Q1041/backups"
DATE=$(date +%Y-%m-%d)
LOG_DIR="/Users/uqhsun8/Documents/repos/scripts/backup_data_scripts/backup_logs"
mkdir -p "$LOG_DIR"

SSH_CONTROL_DIR="${HOME}/.ssh/cm"
mkdir -p "$SSH_CONTROL_DIR"
SSH_CONTROL_PATH="${SSH_CONTROL_DIR}/%C"
SSH_OPTS="-o ControlMaster=auto -o ControlPersist=48h -o ControlPath=$SSH_CONTROL_PATH -o ServerAliveInterval=60 -o ServerAliveCountMax=3"

EXCLUDES=(
    --exclude='.DS_Store'
    --exclude='.fseventsd'
    --exclude='.TemporaryItems'
    --exclude='.DocumentRevisions*'
    --exclude='.Trashes'
    --exclude='.Spotlight*'
)

cleanup() {
    ssh $SSH_OPTS -O exit "$REMOTE_HOST" >/dev/null 2>&1 || true
}
trap cleanup EXIT

ssh_remote() {
    ssh $SSH_OPTS "$REMOTE_HOST" "$@"
}

# Retry an SSH command up to 3 times
ssh_retry() {
    local attempt
    for attempt in 1 2 3; do
        if ssh_remote "$@"; then
            return 0
        fi
        echo "  SSH command failed (attempt $attempt/3). Retrying in 5s..."
        sleep 5
    done
    echo "  ERROR: SSH command failed after 3 attempts: $*"
    return 1
}

ensure_master_connection() {
    echo "Opening persistent SSH connection to $REMOTE_HOST ..."
    echo "(You may be prompted for Duo authentication once)"
    ssh $SSH_OPTS -MNf "$REMOTE_HOST"
}

init_drive() {
    local DRIVE_PATH="$1"
    local DRIVE_NAME="$2"
    local SNAP_DIR="$REMOTE_BASE/snapshots_$DRIVE_NAME"

    echo ""
    echo "=========================================="
    echo " Backing up $DRIVE_NAME  (started: $(date))"
    echo "=========================================="

    if [ ! -d "$DRIVE_PATH" ]; then
        echo "ERROR: $DRIVE_PATH not found. Is the drive connected?"
        return 1
    fi

    ssh_remote "mkdir -p $SNAP_DIR"

    # --- Resume logic ---
    # If 'latest' symlink exists, this drive is already done
    if ssh_remote "test -L $SNAP_DIR/latest"; then
        echo "$DRIVE_NAME already has a completed initial backup."
        echo "  latest -> $(ssh_remote "readlink $SNAP_DIR/latest")"
        echo "Skipping. Use backup_delta.sh for incremental backups."
        return 0
    fi

    # Find any existing incomplete snapshot
    local EXISTING
    EXISTING=$(ssh_remote "ls -d $SNAP_DIR/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] 2>/dev/null | head -1" || true)

    local TARGET_DATE
    if [ -n "$EXISTING" ]; then
        TARGET_DATE=$(basename "$EXISTING")
        echo "Found incomplete snapshot: $TARGET_DATE"
        echo "Resuming transfer into $SNAP_DIR/$TARGET_DATE/ ..."
    else
        TARGET_DATE="$DATE"
        echo "Starting fresh initial backup into $SNAP_DIR/$DATE/ ..."
    fi

    local LOG_FILE="$LOG_DIR/${DRIVE_NAME}_init_$TARGET_DATE.log"
    local ERROR_FLAG=$(mktemp)
    echo "0" > "$ERROR_FLAG"

    # Full verbose log for the initial backup
    # Output is monitored line-by-line for fatal errors (disk quota, I/O errors).
    # If detected, rsync is killed immediately rather than continuing uselessly.
    rsync -avz --partial --progress \
        -e "ssh $SSH_OPTS" \
        "${EXCLUDES[@]}" \
        "$DRIVE_PATH/" \
        "$REMOTE_HOST:$SNAP_DIR/$TARGET_DATE/" \
        2>&1 | while IFS= read -r line; do
            echo "$line" >> "$LOG_FILE"
            echo "$line"
            if echo "$line" | grep -qiE "Disk quota exceeded|No space left on device|Input/output error|Read-only file system"; then
                echo ""
                echo "*** FATAL: $line"
                echo "*** STOPPING rsync. Fix the issue and re-run this script to resume."
                echo "1" > "$ERROR_FLAG"
                # Kill the rsync process (our parent in the pipe)
                kill %1 2>/dev/null || true
                break
            fi
        done

    local RSYNC_EXIT=${PIPESTATUS[0]}
    local HAD_FATAL=$(cat "$ERROR_FLAG")
    rm -f "$ERROR_FLAG"

    if [ "$HAD_FATAL" = "1" ]; then
        echo ""
        echo "Backup stopped due to fatal error. Re-run after fixing the issue."
        return 1
    fi

    if [ "$RSYNC_EXIT" -ne 0 ]; then
        echo ""
        echo "ERROR: rsync exited with code $RSYNC_EXIT for $DRIVE_NAME."
        echo "Re-run this script to resume after fixing the issue."
        return 1
    fi

    # Update the 'latest' symlink (marks this snapshot as complete)
    echo "Setting 'latest' symlink..."
    if ssh_retry "ln -snf $SNAP_DIR/$TARGET_DATE $SNAP_DIR/latest"; then
        echo ""
        echo "$DRIVE_NAME initial backup COMPLETE at $(date)"
        echo "  Snapshot: $SNAP_DIR/$TARGET_DATE/"
    else
        echo ""
        echo "WARNING: rsync succeeded but failed to set 'latest' symlink."
        echo "Run this manually on bunya:"
        echo "  ln -snf $SNAP_DIR/$TARGET_DATE $SNAP_DIR/latest"
    fi
}

# --- Open master connection (Duo auth happens here, once) ---
ensure_master_connection

# --- Run backups ---
init_drive "/Volumes/LaCie_Top"    "LaCie_Top"
init_drive "/Volumes/LaCie_Bottom" "LaCie_Bottom"

echo ""
echo "=========================================="
echo " ALL DONE at $(date)"
echo "=========================================="
echo " Logs saved to: $LOG_DIR"
echo ""
echo " Remote structure:"
echo "   $REMOTE_HOST:$REMOTE_BASE/snapshots_LaCie_Top/"
echo "   $REMOTE_HOST:$REMOTE_BASE/snapshots_LaCie_Bottom/"
echo ""
echo " From now on, use backup_delta.sh for incremental backups."
