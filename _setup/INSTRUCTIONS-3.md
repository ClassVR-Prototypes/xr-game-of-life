# Template update: let the kit's scripts run without prompts

You are Claude Code working in `ClassVR-Prototypes/xr-prototype-template`.

1. Replace `.claude/settings.json` with `_setup/claude-settings.json` (same
   marketplace and plugin as before, plus `permissions.allow` rules so the
   kit's Python scripts, ordinary git commands and the GitHub API calls run
   without a permission prompt; destructive git forms still ask).
2. `git rm -r _setup`
3. Commit as "Allow the kit's scripts and git to run without prompts", then
   publish with the kit's `publish_pr.py` (or push directly if on main).
4. Tell the user: repos made from this template before today need the same
   `.claude/settings.json` — in each, ask Claude to "copy .claude/settings.json
   from ClassVR-Prototypes/xr-prototype-template (raw.githubusercontent.com)
   and publish".
