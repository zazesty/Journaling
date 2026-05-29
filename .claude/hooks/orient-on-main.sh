#!/bin/bash
# Web routine runs start on a throwaway claude/* branch with a stale origin/main view,
# which causes false "orphaned entries" panic and real orphans. Re-home onto fresh main.
[ "$CLAUDE_CODE_REMOTE" = "true" ] || exit 0
cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0
git fetch origin main 2>/dev/null || exit 0
[ -z "$(git status --porcelain)" ] || exit 0   # don't clobber in-progress work on resume
git checkout -B main origin/main 2>/dev/null || true
exit 0
