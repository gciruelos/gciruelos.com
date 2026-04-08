#!/usr/bin/env bash
set -e

BASEDIR=$(pwd)
OUTDIR=__site
ORIGIN_REF=${1:-origin/master}
SITE_HEAD="__diff_head"
SITE_ORIGIN="__diff_origin"

# Build site at HEAD
echo "Building site at HEAD..."
bash build.sh build 2>&1 | grep -v '^rm:'
rm -rf "$SITE_HEAD"
mv "$OUTDIR" "$SITE_HEAD"

# Build site at origin
echo "Building site at $ORIGIN_REF..."
git stash --include-untracked 2>/dev/null || true
git checkout "$ORIGIN_REF" --detach 2>/dev/null
bash build.sh build 2>&1 | grep -v '^rm:'
rm -rf "$SITE_ORIGIN"
mv "$OUTDIR" "$SITE_ORIGIN"

# Restore HEAD
git checkout - 2>/dev/null
git stash pop 2>/dev/null || true

# Diff file by file (recursive)
echo ""
echo "=== Diff ==="
has_diff=0

# Find all files in both trees
all_files=$( (cd "$BASEDIR/$SITE_HEAD" && find . -type f; cd "$BASEDIR/$SITE_ORIGIN" && find . -type f) | sort -u )

for f in $all_files; do
  head_f="$SITE_HEAD/$f"
  origin_f="$SITE_ORIGIN/$f"
  if [ ! -f "$origin_f" ]; then
    echo "NEW: $f"
    has_diff=1
  elif [ ! -f "$head_f" ]; then
    echo "DELETED: $f"
    has_diff=1
  elif ! diff -q "$head_f" "$origin_f" > /dev/null 2>&1; then
    echo "CHANGED: $f"
    diff -u "$origin_f" "$head_f" --label "origin/$f" --label "head/$f" || true
    has_diff=1
  fi
done

if [ $has_diff -eq 0 ]; then
  echo "No differences."
fi

# Cleanup
rm -rf "$SITE_HEAD" "$SITE_ORIGIN"
