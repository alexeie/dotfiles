#!/bin/bash
# statusline-command.sh — Claude Code status line
# Shows git branch + dirty marker, then the caveman badge when active.

input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

# --- CWD segment ---
cwd_segment=""
if [ -n "$cwd" ]; then
  short_cwd="${cwd/#$HOME/\~}"
  cwd_segment=$(printf '\033[38;5;245m%s\033[0m' "$short_cwd")
fi

# --- Git branch segment ---
git_segment=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    dirty=""
    if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null \
       || ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
      dirty="*"
    fi
    git_segment=$(printf '\033[38;5;39m(%s%s)\033[0m' "$branch" "$dirty")
  fi
fi

# --- Caveman badge (delegate to the plugin script) ---
caveman_segment=$(bash "/Users/alex/.claude/plugins/cache/caveman/caveman/84cc3c14fa1e/hooks/caveman-statusline.sh" 2>/dev/null)

# --- Assemble output ---
parts=()
[ -n "$cwd_segment" ]    && parts+=("$cwd_segment")
[ -n "$git_segment" ]    && parts+=("$git_segment")
[ -n "$caveman_segment" ] && parts+=("$caveman_segment")

if [ ${#parts[@]} -gt 0 ]; then
  printf '%s' "${parts[0]}"
  for part in "${parts[@]:1}"; do
    printf ' %s' "$part"
  done
fi
