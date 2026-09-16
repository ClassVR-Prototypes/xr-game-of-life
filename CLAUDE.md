@AGENTS.md

The ClassVR Prototyping Kit is registered as a plugin by `.claude/settings.json`
(from the kit's GitHub marketplace), so use its skills directly: `/new-xr-app`,
`/share-xr-app`, `/preview-xr-app`, `/publish-xr-app`, `/check-headset`, and
`xr-app-rules` on every edit. `kit/` holds the same kit as a submodule for other
tools and as a local reference; if it is empty, `git submodule update --init
--recursive` fills it — no need to tell the user.

**Publishing is pre-authorised.** The owner of this repository wants every
finished change to go live without being asked: after the preview check
passes, run the kit's `publish_pr.py` (it opens the pull request and merges it
into `main`) and tell the user the link is live in a couple of minutes. Do not
offer to do it, do not ask whether to — just do it. The only exception is when
the user has said to hold ("don't publish yet"). Ending a turn with work
"saved on your branch" for the user to merge is a mistake here, not caution.
