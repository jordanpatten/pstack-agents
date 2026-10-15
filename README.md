# pstack-agents

A port of [pstack](https://github.com/cursor/plugins/tree/main/pstack) (Lauren Tan, Cursor, v0.15.25, MIT) to Claude Code, Codex, and Grok Build. One set of skill files works in all three.

pstack's thesis is less code of higher quality, verified on the real artifact, so you can run several agents in parallel and trust each one.

## What is in this repo

- `rules/pstack-core.md`. Always-on rules: autonomy limits, the 24 principles as one-line triggers, verification standards, subagent policy, and writing and PR rules. The installer fills in the skills path for each tool.
- `skills/pstack/`. The rigorous mode. It matches a task to one of 18 playbooks and routes to the sub-skills. Next to it are `principles.md` (full principle texts), `harness.md` (how each pstack term and model role maps to Claude Code, Codex, and Grok Build), `delegate-brief.md`, and `playbooks/`.
- `skills/pstack-<name>/`. 22 sub-skills: how, why, architect, arena, swarm, interrogate, unslop, technical-writing, no-comments, tdd, blast-radius, benchmark-checklist, show-me-your-work, figure-it-out, correct, teach, ketchup, bro, sharpen, in-your-own-words, create-verification-skill, and typescript.
- `claude-agents/`. Two Claude Code subagent definitions, `pstack-delegate` and `pstack-comment-sicko`.
- `install.ps1` (Windows) and `install.sh` (macOS, Linux, and cloud sessions).

## Where each tool reads pstack

| Tool | Skills | Always-on rules |
|---|---|---|
| Claude Code on your computer | `~/.claude/skills/` | `~/.claude/rules/pstack-core.md` |
| Claude Code cloud sessions (phone, browser) | `~/.claude/skills/` on the cloud machine, written by the environment setup script | `~/.claude/rules/pstack-core.md` on the cloud machine |
| Codex | `~/.agents/skills/` | a marked block in `~/.codex/AGENTS.md` |
| Grok Build | reads both `~/.claude/skills/` and `~/.agents/skills/`, and keeps one copy per skill name | reads `~/.claude/rules/` |

Grok Build needs no install target of its own. It reads Claude Code's skills and rules by default (`[compat.claude]` in `~/.grok/config.toml`).

## Install on Windows

In PowerShell, from a folder where you keep code:

```powershell
git clone https://github.com/jordanpatten/pstack-agents.git
cd pstack-agents
.\install.ps1
```

Or double-click `install.cmd` in File Explorer. Either way installs both targets. Use `.\install.ps1 -Targets claude` or `-Targets codex` for one. If PowerShell blocks the script, run `powershell -ExecutionPolicy Bypass -File .\install.ps1`.

## Install on macOS or Linux

```bash
git clone https://github.com/jordanpatten/pstack-agents.git
cd pstack-agents
bash install.sh
```

## Install for Claude Code cloud sessions

Cloud sessions run on a fresh machine and never see your computer's `~/.claude`. Add this to the setup script of your cloud environment (claude.ai/code, environment settings, **Setup script**):

```bash
#!/bin/bash
# pstack-agents v1
git clone --depth 1 https://github.com/jordanpatten/pstack-agents.git /tmp/pstack-agents
bash /tmp/pstack-agents/install.sh claude
```

The environment caches the setup result. After you update this repo, change the version comment (`v1` to `v2`) so the next session reruns the script and picks up the update.

Check it worked: in a new cloud session, run `/context` and look for `pstack-core.md` under memory files, then type `/pstack-bro`.

If a cloud session ever does not show the skills, the fallback is to commit a copy into that repository: `.claude/skills/` and `.claude/rules/` in the repo are always loaded.

## Use it

| Tool | Start the mode | Run a sub-skill | Long unattended run |
|---|---|---|---|
| Claude Code | `/pstack <task>` | `/pstack-how ...` | `/goal <checkable condition>` |
| Codex | `$pstack <task>` | `$pstack-how ...` | `/goal <checkable condition>` |
| Grok Build | `/pstack <task>` | `/pstack-how ...` | `/goal <checkable condition>` |

State the goal, the check for done, the proof you want to see, and the real constraints. Leave out the steps. The playbook supplies them.

```text
/pstack this page has a bug where the list jumps every few seconds while idle. repro first, then fix and verify.
/pstack read this thread. restate the underlying issue in plain english. don't change any code yet.
/pstack prototype a few options for the settings layout behind a switcher and send me screenshots of each.
/pstack turn this design into a plan. small verifiable PRs, each with its own proof.
/pstack-interrogate the whole branch, skeptically. don't change anything. no nitpicks unless it's a real bug or regression.
/pstack-benchmark-checklist vet this 40% speedup before it goes in the PR description.
/pstack-correct agents keep adding config flags without registering them in the schema.
im going to bed. keep going until every fixture passes. do not stop. keep a decision log i can audit in the morning.
```

Steer a drifting run in one line: "i said the goal is to repro. i did not ask for a fix yet." or "apply prove it works. show me the real output, not the build log." or `/pstack-bro`.

## Which skills run on their own

Three layers, from always-on to explicit:

1. **Always on.** The core rules load in every session. They set autonomy limits, the principles, verification standards, and the writing rules. You do nothing.
2. **Automatic.** These skills are cheap and have a clear trigger, so the agent loads them when the situation matches. You can still call them by name.

| Skill | Loads when |
|---|---|
| `pstack-tdd` | Fixing a bug that has a cheap, local test path, or you ask for a failing or regression test |
| `pstack-benchmark-checklist` | A speed number gets measured or reported (speedup, slowdown, latency, throughput) |
| `pstack-blast-radius` | You ask what a change could break or whether it is safe, or a small diff touches shared code before merge |
| `pstack-show-me-your-work` | You say you are stepping away, ask for a log, or a `/goal` or `/loop` run starts |
| `pstack-ketchup` | You come back after an unattended run, or ask to be caught up |
| `pstack-bro` | You say a reply is confusing or too technical |
| `pstack-unslop` | Writing docs, a README, a PR description, or release notes, or you ask to tighten text |
| `pstack-typescript` | Working on `.ts` or `.tsx` files |

3. **Manual.** These cost real time (subagents, review panels, edits), so they run only when you ask.

## When to reach for a manual one

If you are unsure, type `/pstack` and the task. It picks the playbook, and the playbook calls the sub-skills below at the right steps. Call one directly only when you want just that one thing.

| You want to | Use |
|---|---|
| Do any nontrivial change with full rigor (bug fix, feature, refactor, perf) | `/pstack <task>` |
| Understand how some code works before you touch it | `/pstack-how` |
| Know why code was built a certain way, or why something changed | `/pstack-why` |
| Learn a subsystem or change well enough to explain it yourself | `/pstack-teach` |
| Design the types and structure before writing a feature | `/pstack-architect` |
| Get several competing attempts at one design or file, then merge the best parts | `/pstack-arena` |
| Check many separate things in parallel (every package, every page) and get one report | `/pstack-swarm` |
| Have several models try to break a branch or PR before you ship it | `/pstack-interrogate` |
| Strip comments and workaround code before review | `/pstack-no-comments` |
| Make the agent stop repeating the same mistake in a repo | `/pstack-correct` |
| A big or vague job no playbook fits (a migration, a long unattended task) | `/pstack-figure-it-out` |
| Give agents a scripted way to drive your app and prove it works | `/pstack-create-verification-skill` |
| Get docs, a spec, or a PR description written to a strict standard | `/pstack-technical-writing` |
| Check the agent understood your goal before it starts | `/pstack-in-your-own-words` |
| Have the agent rethink your request the way an expert would before it starts | `/pstack-sharpen` |

Rule of thumb: start with `/pstack` for real work, `/pstack-how` for questions, and `/pstack-interrogate` before you merge anything that matters.

## Check what each tool loaded

- Claude Code: `/context` lists the rules file. Type `/pstack` and the skills appear in the menu.
- Codex: `/skills` lists the pstack skills.
- Grok Build: `grok inspect` lists rules files and skills.

## Update or remove

Update: `git pull`, then run the installer again. It replaces the pstack folders and the marked block and leaves everything else alone.

Remove: `.\install.ps1 -Uninstall` or `bash install.sh --uninstall`.

## Pitfalls from the original pstack guide

- Listing skills in your prompt. It reorders steps the playbook already sequences. Name a skill only to override a default.
- A vague finish condition. "Make it better" gives `/goal` nothing to check.
- Leading with your theory of the cause. Ask for a restatement first.
- Taking the first design. Ask for prototypes or architect.
- Polishing an abstract plan. Reviewers invent risks. Settle questions with prototypes first.
- Parallel agents in one worktree. Each writer needs its own worktree.
- Looping before you trust the loop. Get a verify skill working first (`pstack-create-verification-skill`).
- Trusting an unvetted number. Use the benchmark checklist.
- Correcting the same mistake by hand. Use `pstack-correct` so the repo prevents it.
- Using arena for coverage. Arena builds one thing several ways and merges. Swarm splits work into slices.
- Reporting success off a green build. Ask for the real output.

## What changed from the Cursor version

- **One layout for three tools.** Upstream is a Cursor plugin with `poteto-mode` and namespaced skills. Here the mode is the `pstack` skill and each sub-skill is a sibling folder named `pstack-<name>`. The skills use neutral terms ("spawn a read-only subagent", "the code model"), and `skills/pstack/harness.md` maps them to each tool.
- **Models.** Upstream sends code to Grok and judgment to Opus 5.5, and its review panels mix vendors on purpose. Here each tool reviews with its own models, so panels are less diverse than upstream's. `harness.md` names roles, not model IDs, because Codex and Grok IDs change often.
- **Always-on rules are new.** Upstream's mode can stay on across turns in Cursor. Here a short core rules file loads in every session instead.
- **Tool mappings.** Cursor's Task tool options map to each tool's subagent feature. Cursor's `/loop` became `/goal`, which all three tools have. Cursor's `control-ui` and `control-cli` skills (from a separate plugin) became "drive the real surface with whatever is available", plus `pstack-create-verification-skill`.
- **Codex invocation.** Every skill has `agents/openai.yaml`. Manual skills set `allow_implicit_invocation: false`, matching `disable-model-invocation: true` in Claude Code and Grok Build. The automatic skills set it to `true`.
- **Forge.** Upstream supports GitHub and an internal tool called Origin, and ships a TypeScript PR watcher. This port uses plain `gh` commands.
- **Principles.** Four principle texts (laziness-protocol, exhaust-the-design-space, guard-the-context-window, encode-lessons-in-structure) use the fuller wording from before upstream PR #571, which cut them as redundant for Opus 5.5. Delegates here often run on smaller models, so the fuller text stays.
- **Deslop.** Upstream calls `/deslop` from Cursor's separate `cursor-team-kit` plugin. The Opening a PR playbook replaces it with a self-review pass against the principles.

## Not ported

- **Orchestrate, Autopilot-full, Autopilot-stack.** Fleet machinery for dozens to hundreds of Cursor cloud agents. Use figure-it-out, autonomous-run, and multi-phase-plan instead.
- **Worktree cleanup.** Specific to macOS, Xcode simulators, and Cursor's own storage.
- **setup-pstack, poteto-help, automate-me, recall, reflect, maintain-verification-skill.** Each depends on Cursor's model rule, Cursor transcript paths, or Cursor's built-in `create-skill`. `pstack-create-verification-skill` includes the upkeep loop in its last step.
- **make-bot-ui and the benny automation pack.** Specific to Grok Bot webhooks and Cursor's automation runtime.
