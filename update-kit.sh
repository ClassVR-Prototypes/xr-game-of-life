#!/usr/bin/env sh
# Update the ClassVR Prototyping Kit (the kit/ submodule) to its latest version,
# save the change, and push it. Same job as update-kit.cmd, for Mac/Linux and
# for Claude Code sessions. Safe to run any time; does nothing if already current.
set -e
cd "$(dirname "$0")"

git submodule update --init --recursive kit >/dev/null 2>&1 || true
before=$(git -C kit rev-parse --short HEAD 2>/dev/null || echo none)
git submodule update --remote --merge kit
after=$(git -C kit rev-parse --short HEAD)

if [ "$before" = "$after" ]; then
  echo "The kit is already up to date."
  exit 0
fi

version=$(python3 -c "import json;print(json.load(open('kit/plugins/classvr-prototyping-kit/.claude-plugin/plugin.json'))['version'])" 2>/dev/null || echo "$after")
git add kit
git commit -q -m "Update the prototyping kit to $version"
echo "Kit updated to version $version and saved."

if git push >/dev/null 2>&1; then
  echo "Sent to GitHub. Done."
else
  echo "Saved locally. Open GitHub Desktop and press \"Push origin\" to send it."
fi
