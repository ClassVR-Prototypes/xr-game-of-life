# Instructions for AI assistants working in this repository

This repository holds **WebXR prototypes for ClassVR headsets**, built with the
**ClassVR Prototyping Kit**. The person you are working with is usually not a
programmer. They describe what they want ("make a new VR app called Planet
Walk", "add a table", "put it on the headset") and you do the rest. Never ask
them to run commands, open a terminal, or edit files by hand.

## The kit is in this repo — use it

The kit lives in `kit/` (a git submodule of
https://github.com/ClassVR-Prototypes/classvr-prototyping-kit). Its skills are
at:

    kit/plugins/classvr-prototyping-kit/skills/
      new-xr-app/       create a working app in a new folder        → read SKILL.md first
      xr-app-rules/     the rules that keep an app working on a headset — apply on EVERY edit
      preview-xr-app/   headless load + error check + screenshot
      share-xr-app/     put the app on its link (GitHub Pages here) and say the URL
      publish-xr-app/   optional: upload to ClassCloud, playlist, QR code
      check-headset/    read what happened on the headset after a play

Each folder has a `SKILL.md` describing when it applies and the exact steps,
plus `scripts/` (Python) and `assets/` it needs. **Before creating or editing
an app, read the relevant `SKILL.md` and follow it.** Where a skill writes
`${CLAUDE_PLUGIN_ROOT}`, substitute `kit/plugins/classvr-prototyping-kit`.

- In **Claude Code** the kit is also registered as a plugin via
  `.claude/settings.json`, so its skills appear as `/new-xr-app`,
  `/share-xr-app`, and so on. Prefer those.
- In **other tools** (Codex, Copilot, Cursor, Gemini CLI…), read the
  `SKILL.md` files directly from the paths above.

**If `kit/` is empty**, the submodule hasn't been checked out yet. Run
`git submodule update --init --recursive` and carry on. Don't tell the user
about submodules; just do it.

## How this repo is laid out

- Every app is **one folder at the repo root** containing `index.html`,
  `xr-project.json` (the app's manifest) and any local libraries
  (`aframe.min.js`, `cannon.iife.js`). Nothing else about the layout matters.
- `.github/workflows/pages.yml` publishes everything on `main` to **GitHub
  Pages**. `.github/scripts/build_pages.py` assembles the site: each app is
  served at `/<slug>/` (slug from the manifest), with an index page listing
  them.
- `kit/` is the kit. Don't edit it here — changes belong in the kit's own
  repository. When the user says "update the kit" (or the kit looks stale),
  run `./update-kit.sh` at the repo root: it updates the submodule, commits
  and pushes. `.github/workflows/update-kit.yml` does the same weekly.
- Never commit `dist/`, `.preview/` or `_site/`.

## Links, and what to tell the user

The app's link is its **GitHub Pages URL**:

    https://<owner>.github.io/<repo>/<slug>/

Work `<owner>/<repo>` out from `git remote get-url origin`. After creating or
changing an app, **end your reply with that URL on its own line** so the
person can click it. Say when it will show the change:

- if the change went to `main`: "live in a minute or two"
- if it went to a `claude/…` branch (Claude Code on the web always does):
  **publish it yourself** — run
  `python3 kit/plugins/classvr-prototyping-kit/skills/share-xr-app/scripts/publish_pr.py --title "…" --body-file …`
  (it opens the pull request and merges it; the session's GitHub credentials
  work through the proxy). Then "live in a couple of minutes". Only if the
  script exits 2 (refused): make a commit ending in `[publish]` (the repo's
  auto-publish workflow) or, failing both, tell the user "press **Create PR**,
  then **Merge**".

**Publishing is pre-authorised by the repository owner.** Do not offer, do not
ask — after the preview passes, publish, unless the user said to hold. A
non-technical user may not know what a pull request is and would never ask;
work left unpublished never reaches their link.
- if this repo has never published before: the owner must set, once,
  *Settings → Pages → Build and deployment → Source: GitHub Actions* on
  github.com. Say so plainly if the link is 404 after a few minutes.

The Pages URL works on a desktop browser **and** on a ClassVR headset (open it
in the headset browser, or scan a QR of it — `share-xr-app` explains how to
make one). The page is public.

## Vocabulary

Talk about "the app", "the link", "saved", "published", "the headset". Avoid
git words (commit, push, branch, PR, repo, submodule) unless the user uses
them first; when a click on GitHub is unavoidable, name the button. Never end
a turn with "saved on your branch — press Create PR" or "say the word and
I'll merge": publishing is your job.

Commit history is for reading: one commit per logical change (the thing, its
behaviour, its self-check, the build bump), plain present-tense messages in
the user's words, and a pull request per finished piece of work with a short
description of what changed and how to try it.

## Headset constraints — the short list

`xr-app-rules/SKILL.md` is the authority; the headlines:

- Single-file apps: local libraries only, no CDN, no external assets.
- Keep the action in front of the player, 0.5–4 m away, at standing height.
- Text is drawn on canvases, not `<a-text>` with web fonts.
- Every edit ends with a preview check (`preview-xr-app`) and a refreshed
  link (`share-xr-app`). A build that fails its preview never ships.
