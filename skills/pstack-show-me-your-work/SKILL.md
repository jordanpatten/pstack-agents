---
name: pstack-show-me-your-work
description: Keep a reviewable decision trail as one append-only TSV, audit it against the transcript at the end, and get a cross-model review of it. Use for long, autonomous, or multi-phase runs, or "keep a decision log I can audit".
disable-model-invocation: true
---

# Show me your work

Keep one canonical log.

## The format

One TSV file, one row per decision. Cells stay on one line. Evidence is a pointer, not prose. Columns:

- **ts.** ISO 8601 timestamp.
- **phase.** The phase or workstream.
- **decision.** What was chosen or done, one line.
- **why.** The reason in plain words. If a principle drove it, say it plainly, not as a jargon tag.
- **evidence.** A link or path that proves it: commit SHA, PR number, `file:line`, or an artifact, trace, or screenshot path. Never a paragraph.
- **result.** The outcome or predicate state: `tests green`, `reverted`, `pixel-diff 0`, `INCONCLUSIVE`, `open`.

Example, plain-spoken so a reviewer reads it at a glance:

```
ts	phase	decision	why	evidence	result
2026-05-24T09:02:00Z	frame	counted the work first, about 100 components and roughly 75 hours	wanted to know the size before starting a long run	commit 3a9f1c2	found 5 things to sort out before starting
2026-05-24T09:40:00Z	harness	took screenshots of the old version before changing anything	so we can compare old against new and catch any visual change	scripts/snapshot.sh, baseline/	saved 120 reference screenshots
2026-05-24T11:15:00Z	widget	moved the widget styles over without changing how it looks	keep the change small and the result identical	commit 7c21e0a, pixel-diff 0	looks identical, tests pass
2026-05-24T12:30:00Z	widget	threw out a helper's work because its screenshots were blank	checked the real files instead of trusting its summary	worktree reset	reverted, tightened the instructions for next time
```

## Logging a row

Write each entry the way you would tell a teammate what you did. Plain words, concrete actions, no AI speak (**unslop** applies to log text too).

Use `log.sh` in this directory: `bash <this dir>/log.sh <logfile> <phase> <decision> <why> <evidence> <result>`. It stamps `ts`, writes the header on first use, strips stray tabs and newlines, and prefixes any cell that starts with `=`, `+`, `-`, or `@` with a single quote so spreadsheets do not run it as a formula.

Log decision points and checkpoints, not every action: a fork chosen, a unit completed with its verification result, a pivot or revert with its trigger, a blocker surfaced, a gate fixed. For loop runs, one row per iteration. Skip the trivial.

A run is one agent conversation, including its later turns. A pickup, a replacement agent, or a new chat starts a new run. When a run adds to a log that already has rows, its first row has phase `start`. Before it writes, a run that returns to a log reads the last rows to see whether another run wrote since. A `start` row names the `ts` range of earlier rows this run did not write, and its evidence names this run (for example the session ID). Use phase `start` for nothing else.

## Where it lives

By default the log is a working artifact, not committed. Keep it at `decisions.tsv` in the work directory, or `.audit/<task-slug>.tsv` when several efforts run at once, and keep it out of git. Commit it only when the work is ambitious enough that a reviewer needs the trail to trust the result.

## Rules

- Append-only. A wrong call gets a new row that supersedes it. Never edit or delete history.
- Prefer evidence produced by committed scripts over hand-made one-offs.

## Audit the log against the transcript

At the end of the run, before you hand back, check that the log told the truth. Walk this run's rows against what actually happened in this conversation (transcript location per `../pstack/harness.md`; read only this session's file).

- Every row maps to a real decision or action.
- Each row's evidence resolves and shows what the row claims.
- A fork, pivot, or abandoned approach that shaped the work but is not logged is a gap. Add it.

Correct the log, not the story. The audit never edits or removes a row. When a row is wrong, add a row that supersedes it with what actually happened and a pointer that resolves.

## Cross-model review of the trail

Before you hand back, spawn a subagent on a different model from the one that did the work. Self-review is not a substitute. It reads the trail and the run's transcript and flags what the user should look at. It does not redo the work.

- Decisions logged with weak or absent evidence.
- Verification steps skipped, or claimed without proof in the transcript.
- Choices that look risky in hindsight (premature, scope-creeping, papering over a symptom).
- Gaps the user would miss on a quick skim.

Every reply for a run that produced a trail ends with an "Attention" section. Lead with `reviewed by <model>` on its own line, then list each flag with the rows or moments it points to. "No flags" is a valid value.

## Reviewing the trail

Read top to bottom, follow the evidence pointers, spot-check. GitHub renders a committed TSV as a table. `column -s$'\t' -t decisions.tsv` renders it in a terminal.

Other skills route their audit trail here instead of inventing one.
