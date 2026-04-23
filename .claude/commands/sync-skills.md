---
description: Compare repo skills with ~/.claude/skills and sync (repo → system, one-way)
argument-hint: [--dry-run]
allowed-tools: Bash(bash .claude/scripts/sync-skills.sh:*)
---

Run the sync script to compare skills in this repository against the user's
system skills directory (`~/.claude/skills/`) and update the system copy so
it matches this repo.

Behavior:
- One-way: repo → `~/.claude/skills/`
- New skills in the repo are copied over
- Changed skills in the repo overwrite the system copy
- Skills that exist only in `~/.claude/skills/` (not in the repo) are left untouched and reported
- Pass `--dry-run` (via `$ARGUMENTS`) to preview without writing

Execute:

!`bash .claude/scripts/sync-skills.sh $ARGUMENTS`
