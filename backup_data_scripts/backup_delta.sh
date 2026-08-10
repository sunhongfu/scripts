#!/bin/bash
# =============================================================
# INCREMENTAL (delta) rsync backup of LaCie drives to bunya
# Reuses a single SSH master connection so Duo is only
# requested once per script run.
#
# How it works:
#   --link-dest points to the previous snapshot ("latest").
#   Unchanged files become hardlinks (zero extra space).
#   Only new/changed files are transferred over the network.
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

backup_drive() {
    local DRIVE_PATH="$1"
    local DRIVE_NAME="$2"
    local SNAP_DIR="$REMOTE_BASE/snapshots_$DRIVE_NAME"

    echo ""
    echo "=========================================="
    echo " Backing up $DRIVE_NAME  (started: $(date))"
    echo "=========================================="

    # Check the drive is mounted
    if [ ! -d "$DRIVE_PATH" ]; then
        echo "ERROR: $DRIVE_PATH not found. Is the drive connected?"
        return 1
    fi

    # Check that a completed snapshot exists (needed for --link-dest)
    if ! ssh_remote "test -L $SNAP_DIR/latest"; then
        echo "ERROR: No 'latest' symlink found at $SNAP_DIR/latest"
        echo "       Run backup_initial.sh first."
        return 1
    fi

    local LATEST_DATE
    LATEST_DATE=$(ssh_remote "readlink $SNAP_DIR/latest | xargs basename")

    # --- Resume logic ---
    # Find any snapshot folder newer than 'latest' that isn't symlinked
    local INCOMPLETE
    INCOMPLETE=$(ssh_remote "find $SNAP_DIR -maxdepth 1 -type d -name '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' -newer $SNAP_DIR/latest ! -name '$LATEST_DATE' 2>/dev/null | head -1" || true)

    local TARGET_DATE
    if [ -n "$INCOMPLETE" ]; then
        TARGET_DATE=$(basename "$INCOMPLETE")
        echo "Found incomplete snapshot: $TARGET_DATE (resuming...)"
        echo "  Linking against: $LATEST_DATE"
    else
        TARGET_DATE="$DATE"
        if [ "$TARGET_DATE" = "$LATEST_DATE" ]; then
            echo "A snapshot for today ($DATE) already exists and is marked complete."
            echo "Skipping $DRIVE_NAME."
            return 0
        fi
        echo "Creating new incremental snapshot: $TARGET_DATE"
        echo "  Linking against: $LATEST_DATE"
    fi

    local LOG_FILE="$LOG_DIR/${DRIVE_NAME}_delta_$TARGET_DATE.log"

    # Log rotation: trim old log on resume to prevent unbounded growth
    if [ -f "$LOG_FILE" ] && [ "$(wc -l < "$LOG_FILE")" -gt 100 ]; then
        tail -50 "$LOG_FILE" > "${LOG_FILE}.tmp"
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
        echo "--- Resumed at $(date) ---" >> "$LOG_FILE"
    fi

    local ERROR_FLAG=$(mktemp)
    echo "0" > "$ERROR_FLAG"

    rsync -az --partial --stats --delete \
        -e "ssh $SSH_OPTS" \
        --link-dest="$SNAP_DIR/latest" \
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
        echo "$DRIVE_NAME done at $(date)"
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
backup_drive "/Volumes/LaCie_Top"    "LaCie_Top"
backup_drive "/Volumes/LaCie_Bottom" "LaCie_Bottom"

echo ""
echo "=========================================="
echo " ALL DONE at $(date)"
echo "=========================================="
echo " Logs saved to: $LOG_DIR"
echo ""
echo " To verify, check snapshot sizes on server:"
echo "   ssh bunya \"du -sh $REMOTE_BASE/snapshots_LaCie_Top/*/\""
echo "   ssh bunya \"du -sh $REMOTE_BASE/snapshots_LaCie_Bottom/*/\""
