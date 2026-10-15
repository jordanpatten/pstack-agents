---
name: pstack-no-comments
description: Spawn Comment Sicko on the diff, check its deletions, fix accepted refactor flags, and offer structural encodings for claimed constraints. Use before review, or for /pstack-no-comments.
disable-model-invocation: true
---

# No comments

Spawn Comment Sicko. Act on accepted findings. Defer to its fresh perspective.

## Scope

Use the caller's files or diff. Otherwise use the current diff against the base branch, default `main`, including the working tree.

## Steps

1. Spawn the comment reviewer subagent (see `../pstack/harness.md`). In Claude Code it is `subagent_type: "pstack-comment-sicko"`. Elsewhere, brief a subagent with `comment-sicko.md` from this directory. Pass the scope. Do not restate its rules.
2. Inspect its report and diff. Reject application-code edits, scope escapes, deletions of comments a keep clause protects, misstated `MUST KILL` reasons, and flags that treat intentional kept code as guilty. Reshape flags on our-code surprises stay actionable. Do not restore those comments. A keep survives only with proof that it is about something we cannot change. Audit missed lint and TypeScript suppressions in scope. Suppressions that guard correctness or safety stay actionable `MUST KILL` flags. Restore a deletion only with the exact keep clause and scoped proof. Before you accept a thin `IMPORTANT` or `do not remove` kill or keep, run **how** or **why** on its symbol. If a kill is ambiguous, do not restore. If a keep is refuted or still ambiguous, delete it. Revert and rerun one rejected report with the failure named. If a second report is also rejected, report it open and fail the pass.
3. Fix trivial accepted flags directly: delete a dead path, drop a parameter, or use the real API. If any fix needs a new shape, run **architect** once for the accepted set and the code around it. Stop at the sketch. Step 4 implements.
4. Implement the smallest root-cause fix in scope. Remove every named workaround. If the root cause is out of scope, land the smallest in-scope fix and report the rest open. The fix-root-causes and redesign-from-first-principles principles guide intent only. Neither authorizes widening the scope or fixing instances outside it. Never bolt on symptom guards.
5. Constraint comments say `do not remove`, `do not change wording`, or `talk to X before changing`. Leave keeps about things we cannot change. For the rest, offer the cheapest in-scope type, runtime check, test, or CI lint that enforces the constraint. Wait for the user's approval in an interactive session. Unattended runs need the caller's approval in advance. If approved, encode the constraint, then delete the comment. Otherwise delete the comment, report the constraint open, and sketch the out-of-scope work.
6. Report the deletion count, restored comments, reruns, the architect sketch, fixes, encoding offers, encodings made, unenforced constraints, and other open work.
