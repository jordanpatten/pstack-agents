---
name: pstack
description: Rigorous engineering mode ported from poteto's pstack. Matches the task to a playbook, routes to the pstack sub-skills, and verifies work on the real artifact. Use for /pstack or when the user asks for rigor.
disable-model-invocation: true
---

# pstack mode

This skill works in Claude Code, Codex, and Grok Build. Next to this file are `playbooks/`, `principles.md` (the full principle texts), `harness.md` (how each pstack term and model role maps to the tool you are running in), and `delegate-brief.md`. The sub-skills are sibling folders named `pstack-<name>`. When a step names a sub-skill such as **architect**, read `../pstack-architect/SKILL.md` relative to this file and follow it. The user can also invoke each sub-skill directly (`/pstack-<name>` in Claude Code and Grok Build, `$pstack-<name>` in Codex).

Read `harness.md` once at the start of a run. The always-on pstack core rules still apply. This mode adds the triggers, the playbooks, and the subagent policy below.

## Start every run the same way

1. Match the task to one playbook in the router below. Read that playbook file.
2. Open a todo list. Its first items are the playbook's steps, copied in verbatim, before any task-specific items. A step you choose not to do stays in the list as `skip: <reason>`.
3. Run the steps. Route to the sub-skills as the steps name them.
4. End with the reply the playbook names, written per "Writing the reply" below.

## Non-negotiable triggers

- Nontrivial change, architecture decision, or "are we sure?" → **how**.
- About to ask the user "which approach", "how should I", or "what should this do" → classify the fork first. If running something can answer it (behavior, timing, layout, output, perf, even whether an eval separates), run the Prototype playbook and let the result decide. A read-only Investigation answers from evidence instead. Ask only for a product or preference call that no experiment can settle. Under a full-autonomy grant, decide the calls the grant covers, act, and report. For a call only the user can make, apply a default, report it with the reason, and say in plain words what the user could tell you to do instead.
- Any code → name the data shape first and pick its structure per the model-the-domain principle.
- Code that crosses a function boundary → **architect**.
- Parallel coverage, races, or a sweep across slices → **swarm**. A design or code bake-off with base selection and grafting → **arena**.
- Contested design, or a diff before ship → **interrogate**.
- Nontrivial multi-step work → write the throughput checkpoint (Feature playbook, step 3).
- Any prose, your reply included → **unslop**.
- Docs, READMEs, RFCs, PR descriptions, commit messages → **technical-writing**.
- Before review → **no-comments**.
- Shipping UI, CLI, or a service → verify on the real surface. Use the project's verify skill if one exists (make one with **create-verification-skill**), or drive it with whatever is available here: a browser tool, Playwright, a tmux or PTY session for CLIs, or curl for services.
- You measured a number (a benchmark, a speedup, a regression) → **benchmark-checklist** before you report or act on it.
- A small diff you do not trust, or "what could this break" → **blast-radius**.
- A PR-status request ("check on PR 12", "get it green", "address the review comments") → the Babysit playbook.
- Asked to land or ship a green stack → the Shipping playbook. Green is not safe.
- Bot review comments → skeptical posture. Triage each one as fix, dismiss with a concrete reason, or ask. Never churn code to quiet a bot.
- A broken skill or tool found mid-task → fix it in its own commit or PR. Do not block on it. Do not silently work around it.
- Long, autonomous, or multi-phase work, or any task the user steps away from → keep a decision trail with **show-me-your-work**.

## Playbook router

A large or cross-cutting effort (a migration across many call sites, an ambitious multi-part change), or work the user will trust later without watching, routes to **figure-it-out** even when a narrower playbook fits. Use **figure-it-out** whenever no playbook below fits.

| Playbook | File | Use for |
|---|---|---|
| Investigation | `playbooks/investigation.md` | A read-only question. How does X work, why was Y built this way, are we sure, should we do X or Y. |
| Bug fix | `playbooks/bug-fix.md` | A reported defect to reproduce, root-cause, and fix with runtime evidence. |
| Perf issue | `playbooks/perf-issue.md` | A measured slowness to trace and improve against a baseline. |
| Hillclimb | `playbooks/hillclimb.md` | Sustained improvement of one metric against a target, one change and one measurement per loop. |
| Forensics | `playbooks/forensics.md` | Diagnose a live symptom (leak, idle CPU spin, glitch) or a captured profile. The deliverable is a diagnosis, not a fix. |
| Feature | `playbooks/feature.md` | New or changed behavior, built from a named data shape. |
| Refactoring | `playbooks/refactoring.md` | A behavior-preserving change to structure. |
| Prototype | `playbooks/prototype.md` | A throwaway sketch to make a design decision, or to settle an empirical fork by observing it. |
| Visual parity | `playbooks/visual-parity.md` | Pixel-exact UI equivalence between two implementations. |
| Authoring a skill | `playbooks/authoring-a-skill.md` | Writing or editing a SKILL.md. |
| Eval | `playbooks/eval.md` | Testing how a skill or prompt change affects agent behavior, blinded. |
| Multi-phase plan | `playbooks/multi-phase-plan.md` | Work that spans phases or stacked PRs. The plan is the deliverable. |
| Autonomous run | `playbooks/autonomous-run.md` | Drive a long task to a checkable exit condition without stopping. |
| Babysit | `playbooks/babysit.md` | Drive a PR or a stack to merge-ready: conflicts, review threads, CI. |
| Shipping | `playbooks/shipping.md` | Verify a green stack independently, then land the verified run bottom-up. |
| Session pickup | `playbooks/session-pickup.md` | Resume or take over a prior agent's in-flight work. |
| Pause safely | `playbooks/pause-safely.md` | Stop in-flight work so a cold-start agent can resume it. |
| Opening a PR | `playbooks/opening-a-pr.md` | The end of every other playbook that changes code. |

## Subagents

**Use the delegate subagent for every code-writing or helper subagent inside a playbook step.** `harness.md` says how to spawn it in your tool. In every tool, its brief starts by pointing it at `delegate-brief.md` in this folder, so it reads this file and `principles.md` before it works. Never spawn a delegate to run the playbook itself. This chat owns the playbook, the todo list, and every spawn. Sub-skills that ask for a read-only subagent keep that.

**Defaults for every spawn.** Run in the background or in parallel. Pass file pointers, not inlined context. Give each writer its own worktree. Pick the model per role from the model table in `harness.md`: the code model for routine code delegates, the hardest-changes model for cross-cutting design, concurrency, and subtle algorithms, the judgment model for judgment and prose, the worker model for explorers and verification workers, and the panel models for arena, architect, and interrogate.

A role table in a project's `AGENTS.md` or `CLAUDE.md` overrides these defaults. A panel must use at least two different models. A second opinion is the same prompt against a different model.

**You own every subagent's work.** Review the diff and write your own summary. Agreement between models is high signal.

**Fresh subagents by default.** Give a fix round, a follow-up, a retry, or the next queue item to a fresh subagent with consolidated scope: the original brief, every later directive, the prior report, and the branch. Resume an existing subagent only when the new work needs state that lives only in it (its checkout, its uncommitted changes, or a process it still runs). Resume chains silently drop directives.

## Writing the reply

Write the reply clean as you draft it.

- Short declarative sentences. One thought per sentence.
- No long dash anywhere. Write a file-list bullet as a sentence ("`main.js` owns persistence and the IPC handlers"). Write a bold section header as its own sentence ("**Verification.** End to end through the browser").
- No colon as a mid-sentence connector. A colon before a list is fine.
- Terse is not an excuse to drop content. Every section the playbook's reply names stays.
- Frame impact for the consumer and the maintainer, before implementation detail.
- Never fabricate a link, citation, or transcript reference.
- Every claim carries its evidence or its label in the same sentence: measured, inferred, or guess.
- Name each principle that shaped a decision and the choice it changed.

Every playbook that opens a PR ends with the PR link.
