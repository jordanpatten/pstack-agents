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
- **Codex invocation.** Every skill except `pstack-typescript` has `agents/openai.yaml` with `allow_implicit_invocation: false`, so Codex runs them only when you call them, matching `disable-model-invocation: true` in Claude Code and Grok Build.
- **Forge.** Upstream supports GitHub and an internal tool called Origin, and ships a TypeScript PR watcher. This port uses plain `gh` commands.
- **Principles.** Four principle texts (laziness-protocol, exhaust-the-design-space, guard-the-context-window, encode-lessons-in-structure) use the fuller wording from before upstream PR #571, which cut them as redundant for Opus 5.5. Delegates here often run on smaller models, so the fuller text stays.
- **Deslop.** Upstream calls `/deslop` from Cursor's separate `cursor-team-kit` plugin. The Opening a PR playbook replaces it with a self-review pass against the principles.

## Not ported

- **Orchestrate, Autopilot-full, Autopilot-stack.** Fleet machinery for dozens to hundreds of Cursor cloud agents. Use figure-it-out, autonomous-run, and multi-phase-plan instead.
- **Worktree cleanup.** Specific to macOS, Xcode simulators, and Cursor's own storage.
- **setup-pstack, poteto-help, automate-me, recall, reflect, maintain-verification-skill.** Each depends on Cursor's model rule, Cursor transcript paths, or Cursor's built-in `create-skill`. `pstack-create-verification-skill` includes the upkeep loop in its last step.
- **make-bot-ui and the benny automation pack.** Specific to Grok Bot webhooks and Cursor's automation runtime.
