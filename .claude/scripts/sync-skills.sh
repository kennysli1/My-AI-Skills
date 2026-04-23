#!/bin/bash
# Sync skills from this repo to ~/.claude/skills/
# Direction: repo -> system (one-way)
# Usage: .claude/scripts/sync-skills.sh [--dry-run]

set -e

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "/e/My-Ai-Skills/My-AI-Skills")"
SRC="$REPO_ROOT/skills"
DEST="$HOME/.claude/skills"
DRY_RUN=0

if [ "$1" = "--dry-run" ]; then
    DRY_RUN=1
fi

if [ ! -d "$SRC" ]; then
    echo "ERROR: source skills dir not found: $SRC" >&2
    exit 1
fi
mkdir -p "$DEST"

echo "== Skill sync =="
echo "  src : $SRC"
echo "  dest: $DEST"
echo "  mode: $([ $DRY_RUN -eq 1 ] && echo 'DRY-RUN' || echo 'APPLY')"
echo

NEW=0
UPDATED=0
UNCHANGED=0
ONLY_IN_DEST=0

# Scan each skill in the repo
for skill_path in "$SRC"/*/; do
    [ -d "$skill_path" ] || continue
    skill_name="$(basename "$skill_path")"
    dest_path="$DEST/$skill_name"

    if [ ! -d "$dest_path" ]; then
        echo "  [NEW]        $skill_name"
        NEW=$((NEW+1))
        [ $DRY_RUN -eq 0 ] && cp -r "$skill_path" "$dest_path"
        continue
    fi

    # Compare; exit 0 = identical
    if diff -rq "$skill_path" "$dest_path" > /dev/null 2>&1; then
        UNCHANGED=$((UNCHANGED+1))
    else
        echo "  [UPDATED]    $skill_name"
        diff -rq "$skill_path" "$dest_path" 2>/dev/null | sed 's/^/      /'
        UPDATED=$((UPDATED+1))
        if [ $DRY_RUN -eq 0 ]; then
            rm -rf "$dest_path"
            cp -r "$skill_path" "$dest_path"
        fi
    fi
done

# Report skills that exist only in ~/.claude/skills (not deleted, only reported)
for dest_skill in "$DEST"/*/; do
    [ -d "$dest_skill" ] || continue
    skill_name="$(basename "$dest_skill")"
    if [ ! -d "$SRC/$skill_name" ]; then
        echo "  [ONLY-IN-SYS] $skill_name  (exists in ~/.claude/skills but not in repo; NOT touched)"
        ONLY_IN_DEST=$((ONLY_IN_DEST+1))
    fi
done

echo
echo "Summary: new=$NEW  updated=$UPDATED  unchanged=$UNCHANGED  only-in-system=$ONLY_IN_DEST"
[ $DRY_RUN -eq 1 ] && echo "(dry-run — nothing was written)"
