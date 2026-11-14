#!/data/data/com.termux/files/usr/bin/bash
# pakai: ./go.sh lfs-stage1 "pesan commit"
set -e
cd ~/lfs-ci
WF="$1"; MSG="${2:-update}"
git add -A
git commit -m "$MSG" || true
git push
gh workflow run "$WF.yml"
sleep 8
gh run watch "$(gh run list --workflow "$WF.yml" --limit 1 --json databaseId -q '.[0].databaseId')" --exit-status \
  || gh run view --log-failed | tail -n 80
