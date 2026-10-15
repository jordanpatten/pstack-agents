# Harness map

pstack runs in Claude Code, Codex, and Grok Build. The skills use neutral terms. This file maps each term to the tool you are running in. Find your harness's column and use it.

## Terms

| pstack term | Claude Code | Codex | Grok Build |
|---|---|---|---|
| Spawn a subagent | Agent tool | Spawn a subagent (built-in types `default`, `worker`, `explorer`) | `spawn_subagent` (built-in types `general-purpose`, `explore`, `plan`) |
| Read-only subagent | `subagent_type: "Explore"` | the `explorer` type | the `explore` type |
| Delegate subagent | `subagent_type: "pstack-delegate"` | a `worker` subagent whose brief starts with "Read `../pstack/delegate-brief.md` first" | a `general-purpose` subagent with the same brief |
| Comment reviewer | `subagent_type: "pstack-comment-sicko"` | a `worker` subagent briefed with `../pstack-no-comments/comment-sicko.md` | a `general-purpose` subagent with the same brief |
| Own worktree | `isolation: "worktree"` | a separate `git worktree` you create for the subagent | `isolation: worktree` |
| Run in the background | the default for subagents | parallel subagents | parallel subagents |
| Keep going until a condition holds | `/goal <condition>` | `/goal <condition>` | `/goal <condition>` |
| Re-run on an interval | `/loop <interval> <prompt>` | not verified, use `/goal` | `/loop <interval> <prompt>` |
| Invoke a pstack skill | `/pstack-<name>` | `$pstack-<name>` | `/pstack-<name>` |
| GitHub PR commands | `gh pr ...` on your computer. In cloud sessions the GitHub proxy rejects `gh pr` and `gh issue` (they use GraphQL), so use the session's built-in pull request tools or REST calls through `gh api` | `gh pr ...` | `gh pr ...` |
| Session transcripts | `~/.claude/projects/<project>/` | the Codex session store (use its resume picker) | the Grok session store (use its sessions view) |

If your harness lacks a feature in a row, do the closest thing it supports and say so in the reply.

## Model roles

pstack assigns a model per role. Panels need at least two different models, because the review signal comes from model diversity.

| Role | Claude Code | Codex | Grok Build |
|---|---|---|---|
| Code delegates (feature, refactoring, bug fix, perf, hillclimb) | `sonnet` | your default Codex model | your default Grok model |
| Hardest changes (cross-cutting design, concurrency, subtle algorithms) | `opus` | your strongest available model, highest reasoning effort | your strongest available model (`grok models` lists them), highest effort |
| Judgment, prose, explainers, synthesizers, lead review | `opus` | strongest model, high effort | strongest model, high effort |
| Explorers, investigators, swarm and verification workers | `sonnet` | default model | default model |
| Panels (arena runners, architect runners, interrogate reviewers, cross-judge) | `opus` and `sonnet`, plus `fable` if available | two different models from your model picker, or one model at two effort levels if only one is available | two different models from `grok models`, or one model at two effort levels |
| Trivial mechanical edits | `haiku` or `sonnet` | fastest available model | fastest available model |

Codex and Grok model IDs change often, so this map names roles, not IDs. Check your picker (`/model` in Codex, `grok models` in Grok Build). In Grok Build, if `subagent_model_inheritance` is on and every model in your picker is from xAI, subagents always run on the parent model. Then a panel is one model at different effort levels, which is the weakest form of diversity. Say so in the reply when it happens.

A project can override this table in its own `AGENTS.md` or `CLAUDE.md`.
