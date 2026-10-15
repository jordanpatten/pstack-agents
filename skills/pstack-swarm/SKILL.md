---
name: pstack-swarm
description: Fan out N parallel workers across separate slices or racing the same brief, wait for all, and return one consolidated report. Use for "swarm this", coverage checks across many packages or files, races, and gauntlets.
disable-model-invocation: true
---

# Swarm

Fan out N parallel workers. They cover separate slices, race the same brief, or both. You wait, aggregate, and return one report.

Open a todo list: Frame, Fan out, Aggregate, Report.

## Phase A. Frame

1. State the done predicate and the report the swarm must return.
2. Choose the shape. Partition into slices, race N workers on identical briefs, or mix both. For a race, declare the selection rule before spawning: `first pass`, `rank all`, or `best-of`.
3. Set N from the user, or derive it from the shape.
4. Workers run on the worker model by default (see `../pstack/harness.md`). For a model race, name each arm's model up front.
5. Give each writing worker its own output (its own worktree for code). When workers verify or measure commits, each brief names the exact SHAs. A measurement brief also names the method (sample count, what one sample is, the order), and the worker records both in its result.

## Phase B. Fan out

Spawn all N workers in one message, in the background. Every brief stands alone: the goal, the scope, the exact slice or race arm, how to verify, and what to report. Reports use `PASS`, `ISSUES`, or `BLOCKED` with evidence. A worker that can prove a defect reports `ISSUES` and lists every issue it can prove, not only the first. If a worker drops out, proceed with N minus 1 and note it.

## Phase C. Aggregate

Read the results. Drop a result that does not record the SHAs and method its brief named, and respawn that worker once. After a second miss, record a gap. A gap is not a pass. For coverage, every slice needs a result. For a race, apply the declared selection rule. Do not paste raw worker output.

## Phase D. Report

One consolidated report: a compact result table, one-line evidenced issues, gaps or dropouts, and the race rule when used.

Use **arena**, not swarm, when you want one design built several ways and then merged.
