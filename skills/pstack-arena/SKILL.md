---
name: pstack-arena
description: Spawn N parallel candidates at the same task, pick a base, and graft the strongest parts of the others into it. Use for "arena this", a second opinion on a design, or when one attempt at a nontrivial artifact would lock in the wrong shape.
disable-model-invocation: true
---

# Arena

Open a todo list with one entry per phase (Frame, Fan out, Cross-judge, Pick, Graft, Verify) before you launch anything.

## Phase A. Frame

Every candidate gets the same prompt, so the prompt is the contract.

1. State the artifact each candidate produces.
2. Derive the rubric: 3 to 6 concrete, gradeable criteria for success on this task. It is your tool in Phase D. Candidates see only the task.
3. Pick the runners. Default to one runner per panel model in `../pstack/harness.md`. Spawn more runners when the arena covers several design directions. Use the same model N times when the work is generation-bound rather than judgment-sensitive.
4. Give each candidate its own output location: its own worktree for code, or `/tmp/arena-<slug>/candidate-<n>/` for documents.

## Phase B. Fan out

Spawn all N subagents in one message, in the background. Each gets the task, the path to the shared grounding, its own output path, and the instruction to produce the artifact plus a short rationale that names the alternatives it considered and what it rejected. If a candidate produces nothing, proceed with N minus 1 and note the dropout.

## Phase C. Cross-judge

After all candidates finish, spawn one read-only judge subagent, preferably on a different model from your own. It sees the rubric and the candidates by path label, scores each criterion, and recommends a base with a rationale. It runs while you do Phase D. Do not spawn it while candidates are still writing.

## Phase D. Pick a base

Read every candidate end to end before you pick. Score each against the rubric criterion by criterion, not on feel, and compare with the judge. Agreement confirms the pick. Disagreement means one of you is biased or the rubric was ambiguous, so read both rationales before you decide.

Pick the base a future maintainer can extend most easily without breaking invariants. When two feel tied, prefer the cleaner boundary or the smaller API.

## Phase E. Graft

Walk each losing candidate once more for what is worth porting into the base, usually one or two things per candidate. Fold each graft in by hand so the result stays coherent under one mental model. Do not paste mechanically.

If the candidates converge on one shape, that is strong agreement. Ship the consensus shape with no graft. If they diverge wildly, Phase A was under-specified. Reframe and re-run rather than averaging the divergence.

## Phase F. Verify

Verify the result like any other output, on the real artifact. If verification finds a problem the arena missed, either Phase A was wrong (reframe and re-run) or a candidate caught it and you missed the graft (go back to Phase E).

## Output

One synthesized artifact, with a short note naming the base and why, the judge's verdict, each graft and its source candidate, what was rejected and why, any convergence or dropouts, and the verification result.
