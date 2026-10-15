### Pause safely

**You own a clean stop. Leave a checkpoint a cold-start agent can resume from.** This playbook runs only on an explicit pause, going offline, a restart, or imminent context compaction. On "keep going", "going to bed, keep going", or "don't stop", do not pause.

1. Stop at a safe boundary. Finish the current atomic step or back out of it. Start nothing new, and stop any running subagents.
2. Take no irreversible action to pause. No PR and no push unless you already had one out.
3. Make the work durable. Commit uncommitted edits as one clear `wip:` commit on the current branch so nothing is lost. If the tree is broken, say so in one line of the commit body.
4. Write the resume note outside the context window. Capture the intent, what you were doing, the progress and what is verified, the current state, next steps, key files, and gotchas. Write it to a file such as `/tmp/<slug>-resume.md`, or the repo's scratch folder. If a show-me-your-work trail exists, point at it instead of duplicating it.

**Reply:** where you are in the loop, what is on disk against what is still only in your head (paths, no diff dumps), the commits you made and whether the tree is clean, and the first action on resume. This is a pause, not a final report.
